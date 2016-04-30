# # require File.expand_path('../config/environment',  __FILE__)
# require './app/services/riot_client'
# # require 'set'

class GenIds


    # def initialize(client, seed_id)
    def initialize
        @client = RiotClient.new
        # puts "#{ml[:totalGames]}"

        # puts "#{s[:tier]}"
    end

    def seed
        # add_summoner("na", "rekabat")
        add_summoner_to_db("na", "rekabat")
    end

    def add_summoner_to_db(region, name)
        # client = RiotClient.new
        seed = @client.summoner.by_name region, name
        for k in seed.keys do
            standardized_name = k
            summoner_id = seed[k][:id]
            display_name = seed[k][:name]

            puts "#{standardized_name}, #{display_name}, #{summoner_id}"


            Summoner.create(
                riot_id: summoner_id,
                normalized_name: standardized_name,
                name: display_name
                )
        end
    end

    def grow
        smnr = Summoner.order("RANDOM()").first
        find_match_ids "na", smnr[:riot_id]
    end

    def find_match_ids(region, riot_id)
        # s = Summoner.first
        ml = @client.matchlist.by_id region, riot_id

        ml_arr = Array.new
        for match in ml[:matches] do
            ml_arr.push(match[:matchId])
        end

        puts "#{ml_arr}"
        # puts "hello"
    end

    def get_all_summoners_from_match()
    end

    def get_all_summoners_from_matches
    end
end
