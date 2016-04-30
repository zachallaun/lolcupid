require 'unirest'
require 'json'

class RiotClient
  class RequestError < StandardError; end

  REGIONS = ["br", "eune", "euw", "jp", "kr", "lan", "las", "na", "oce", "ru", "tr"]

  def initialize
    @api_key = ENV['RIOT_API_KEY']

    unless @api_key
      raise "ENV['RIOT_API_KEY'] must be set to use RiotClient"
    end
  end

  def summoner
    @summoner ||= Resource.new(@api_key, "v1.4/summoner",
      by_name: 'by-name/:summoner_names',
      by_id: ':summoner_ids',
      masteries: ':summoner_ids/masteries',
      names: ':summoner_ids/name',
      runes: ':summoner_ids/runes'
    )
  end

  private

  class Resource
    def initialize(api_key, resource_name, method_map={})
      @api_key = api_key
      @resource_name = resource_name

      method_map.each do |method_name, path_spec|
        define_singleton_method method_name do |region, *args|
          validate_region! region
          get region, make_path(path_spec, args)
        end
      end
    end

    def api_url(region)
      "https://#{region}.api.pvp.net/api/lol/#{region}"
    end

    def url(region, path)
      "#{api_url(region)}/#{@resource_name}/#{path}"
    end

    def get(region, path)
      resp = Unirest.get(url(region, path), parameters: {api_key: @api_key})

      if resp.code == 200
        resp.body.with_indifferent_access
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
end
