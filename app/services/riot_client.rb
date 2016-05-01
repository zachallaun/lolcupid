require 'unirest'
require 'json'
require 'date'

class RiotClient
  class RequestError < StandardError; end

  ASSET_PREFIX = "https://ddragon.leagueoflegends.com/cdn/"
  REGIONS = ["br", "eune", "euw", "jp", "kr", "lan", "las", "na", "oce", "ru", "tr"]
  GAME_QUEUE_TYPE = ["RANKED_SOLO_5x5", "RANKED_TEAM_3x3", "RANKED_TEAM_5x5"]

  # 10 per 10 seconds = 1 s/r
  # 500 per 10 minutes (600 seconds) = 1.2 s/r
  MILLISECONDS_BETWEEN_REQUESTS = 3000
  # MILLISECONDS_BETWEEN_REQUESTS = 1200

  def initialize
    @api_key = ENV['RIOT_API_KEY']
    @last_request = Time.now.to_f

    unless @api_key
      raise "ENV['RIOT_API_KEY'] must be set to use RiotClient"
    end
  end

  def league
    wait_on_request
    @league ||= Resource.new(@api_key, "v2.5/league",
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
    wait_on_request
    @match ||= Resource.new(@api_key, "v2.2/match",
      by_match_id: ':match_id'
    )
  end

  def matchlist
    wait_on_request
    @matchlist ||= Resource.new(@api_key, "v2.2/matchlist",
      by_id: 'by-summoner/:summoner_id'
    )
  end

  def static
    @static ||= StaticDataClient.new(@api_key)
  end

  def summoner
    wait_on_request
    @summoner ||= Resource.new(@api_key, "v1.4/summoner",
      by_name: 'by-name/:summoner_names',
      by_id: ':summoner_ids',
      masteries: ':summoner_ids/masteries',
      names: ':summoner_ids/name',
      runes: ':summoner_ids/runes'
    )
  end

  private

  def wait_on_request
    current_time = Time.now.to_f
    s_since_last_request = current_time - @last_request
    ms_since_last_request = s_since_last_request*1000.0
    sleep_time_in_ms = MILLISECONDS_BETWEEN_REQUESTS - ms_since_last_request
    sleep_time = sleep_time_in_ms/1000.0
    if sleep_time > 0 then
      puts "Waiting: #{sleep_time}"
      sleep(sleep_time)
      puts "Done"
    end

    # really this should come after the request has been fulfilled
    @last_request = current_time
  end



  class Resource
    def initialize(api_key, resource_name, method_map={})
      @api_key = api_key
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

    def get(region, path, query_params)
      resp = Unirest.get(url(region, path), parameters: {api_key: @api_key}.merge(query_params))

      if resp.code == 200
        if resp.body.is_a? Hash
          resp.body.with_indifferent_access
        else
          resp.body
        end
      else
        raise RequestError, "\nRiotClient::Resource GET failure\nResponse code: #{resp.code}\nResponse body: #{resp.raw_body}".gsub(/^/, "  ")
      end
    end

    private

    def make_path(path_spec, args)
      parts = path_spec.split("/")
      arg_n = -1

      parts.map do |part|
        if part.starts_with?(":")
          arg_n += 1
          args[arg_n]
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
end
