require 'unirest'
require 'json'
require 'date'

class RiotClient
  class RequestError < StandardError; end

  ASSET_PREFIX = "https://ddragon.leagueoflegends.com/cdn/"
  GAME_QUEUE_TYPE = ["RANKED_SOLO_5x5", "RANKED_TEAM_3x3", "RANKED_TEAM_5x5"]
  REGIONS = ["br", "eune", "euw", "jp", "kr", "lan", "las", "na", "oce", "ru", "tr"]
  CHAMPION_MASTERY_REGIONS = {"br" => "br1", "eune" => "eun1", "euw" => "euw1", "jp" => "jp1", "kr" => "kr", "lan" => "la1", "las" => "la2", "na" => "na1", "oce" => "oc1", "ru" => "ru", "tr" => "tr1"}

  def initialize(retries: 1)
    @config = Config.new(retries: retries)
  end

  def league
    @league ||= Resource.new(@config, "v2.5/league",
      by_id:         'by-summoner/:summoner_ids',
      by_id_entry:   'by-summoner/:summoner_ids/entry'
      # by_id_entry:   'by-summoner/:summoner_ids/entry',
    #   by_team:       'by-team/:team_ids',
    #   by_team_entry: 'by-team/:team_ids/entry',
    #   challenger:    'challenger',
    #   master:        'master'
    )
  end

  def match
    @match ||= Resource.new(@config, "v2.2/match",
      by_match_id: ':match_id'
    )
  end

  def matchlist
    @matchlist ||= Resource.new(@config, "v2.2/matchlist",
      by_id: 'by-summoner/:summoner_id'
    )
  end

  def static
    @static ||= StaticDataClient.new(@config)
  end

  def summoner
    @summoner ||= Resource.new(@config, "v1.4/summoner",
      by_name: 'by-name/:summoner_names',
      by_id: ':summoner_ids',
      masteries: ':summoner_ids/masteries',
      names: ':summoner_ids/name',
      runes: ':summoner_ids/runes'
    )
  end

  def champion_mastery
    @champion_mastery ||= ChampionMasteryResource.new(@config, "player",
      summoner_champions: ":summoner_id/champions",
      summoner_score: ":summoner_id/score"
    )
  end

  private

  class Resource
    def initialize(config, resource_name, method_map={})
      @config = config
      @resource_name = resource_name

      method_map.each do |method_name, path_spec|
        define_singleton_method method_name do |region, *args, **query_params|
          validate_region! region
          get region, make_path(path_spec, args), query_params
        end
      end
    end

    def api_url(region)
      "https://#{region}.api.pvp.net/api/lol/#{region}"
    end

    def url(region, path)
      "#{api_url(region)}/#{@resource_name}/#{path}"
    end

    def get(region, path, query_params, attempt: 0)
      resp = Unirest.get(url(region, path), parameters: {api_key: @config.api_key}.merge(query_params))

      wait_for_rate_limiter(region)

      if resp.code == 200
        if resp.body.is_a? Hash
          resp.body.with_indifferent_access
        else
          resp.body
        end
      elsif attempt < @config.retries
        get(region, path, query_params, attempt: attempt + 1)
      else
        raise RequestError, "\nRiotClient::Resource GET failure\nResponse code: #{resp.code}\nResponse body: #{resp.raw_body}".gsub(/^/, "  ")
      end
    end

    private

    def wait_for_rate_limiter(region)
      l1 = @config.limiter_per_10_seconds.wait(region)
      l2 = @config.limiter_per_10_minutes.wait(region)

      if l1 || l2
        puts "Warning: rate limited #{l1} #{l2}"
      end
    end

    def make_path(path_spec, args)
      parts = path_spec.split("/")
      arg_n = -1

      parts.map do |part|
        if part.starts_with?(":")
          arg_n += 1
          URI.encode_www_form_component(args[arg_n].to_s.gsub(' ', ''))
        else
          part
        end
      end.join("/")
    end

    def validate_region!(region)
      unless region.in?(REGIONS)
        raise "Invalid Riot API region: #{region}"
      end
    end
  end


  class StaticDataClient
    def initialize(api_key)
      @api_key = api_key
    end

    def champion
      @champion ||= StaticResource.new(@api_key, "v1.2/champion",
        all: '',
        by_id: ':id'
      )
    end
  end

  class StaticResource < Resource
    def api_url(region)
      "https://global.api.pvp.net/api/lol/static-data/#{region}"
    end
  end

  class ChampionMasteryResource < Resource
    def api_url(region)
      unless CHAMPION_MASTERY_REGIONS[region]
        raise "No champion mastery region for '#{region}'"
      end

      "https://#{region}.api.pvp.net/championmastery/location/#{CHAMPION_MASTERY_REGIONS[region]}"
    end
  end

  class Config
    REQUIRED_VARS = ['RIOT_API_KEY', 'RIOT_REQUESTS_PER_10_SECONDS', 'RIOT_REQUESTS_PER_10_MINUTES']

    attr_reader :retries, :api_key, :limiter_per_10_seconds, :limiter_per_10_minutes

    def initialize(retries:)
      validate_env_vars!

      @retries = retries
      @api_key = ENV['RIOT_API_KEY']
      @limiter_per_10_seconds = RateLimiter.new(
        interval: 10 * 1000,
        max_in_interval: ENV['RIOT_REQUESTS_PER_10_SECONDS'].to_i
      )
      @limiter_per_10_minutes = RateLimiter.new(
        interval: 10 * 60 * 1000,
        max_in_interval: ENV['RIOT_REQUESTS_PER_10_MINUTES'].to_i
      )
    end

    private

    def validate_env_vars!
      missing = REQUIRED_VARS.select { |v| !ENV[v] }
      if missing.present?
        raise "Missing ENV vars: #{missing.join(", ")}"
      end
    end
  end
end
