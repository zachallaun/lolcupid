require 'unirest'
require 'json'

class RiotClient
  class RequestError < StandardError; end

  def initialize
    @api_key = ENV['RIOT_API_KEY']

    unless @api_key
      raise "ENV['RIOT_API_KEY'] must be set to use RiotClient"
    end
  end

  def summoner
    @summoner ||= Resource.new(
      "summoner",
      by_name: 'by-name/:summoner_names',
      by_id: ':summoner_ids',
      masteries: ':summoner_ids/masteries',
      names: ':summoner_ids/name',
      runes: ':summoner_ids/runes'
    )
  end

  private

  class Resource
    def initialize(resource_name, method_map={})
      @resource_name = resource_name

      method_map.each do |method_name, path_spec|
        define_singleton_method method_name do |region, *args|
          get region, make_path(path_spec, args)
        end
      end
    end

    def api_url(region)
      "https://#{region}.api.pvp.net/api/lol/#{region}"
    end

    def get(region, path)
      resp = Unirest.get("#{api_url(region)}/#{path}", parameters: {api_key: @api_key})

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
  end
end
