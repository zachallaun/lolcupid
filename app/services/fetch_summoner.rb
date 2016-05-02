class FetchSummoner
    def initialize
        @client = RiotClient.new
    end

    def fetch_by_name(region, name)
        summoner = fetch_summoner region, name
        if summoner == nil then return end

        standardized_name = summoner.keys[0]
        id = summoner[standardized_name][:id]

        display_name = summoner[standardized_name][:name]
        summoner_level = summoner[standardized_name][:summonerLevel]

        solo5x5league = fetch_solo5x5league region, id
        tier = solo5x5league[0]
        division = solo5x5league[1]


        profile_icon_id = summoner[standardized_name][:profileIconId]
        last_scraped_at = nil
        mastery_points = nil

        Summoner.set_entry(
            id, # bigint NOT NULL,
            standardized_name, # character varying NOT NULL,
            display_name, # character varying NOT NULL,
            summoner_level, # integer,
            tier, # integer,
            division, # integer,
            profile_icon_id, # integer,
            last_scraped_at, # timestamp without time zone,
            mastery_points, # integer,
            region)
    end

    def fetch_by_id(region, id)
        # this is kind of dumb, i make another call just to get their standardized name + it's in the format Summoner class expects
        summoner = @client.summoner.by_id region, id
        fetch_by_name region, summoner[id.to_s][:name]
    end

    private

    def fetch_summoner(region, name)
        begin
            return @client.summoner.by_name region, name
        rescue
            return nil
        end
    end

    def fetch_solo5x5league(region, id)
        begin
            l_data = @client.league.by_id_entry region, id
            if l_data then
                leagues = l_data[id.to_s]
                for league in leagues do
                    if league[:queue] == "RANKED_SOLO_5x5" then
                        tier = league[:tier]
                        # I don't understand what the zero is for... Why is it a list of entries
                        division = league[:entries][0][:division]
                        return [tier, division]
                    end
                end
            end
            return [nil, nil]
        rescue
            # puts e.backtrace
            return [nil, nil]
        end
    end

    # def fetch_first_match(region, id)
    #     ml = @client.matchlist.by_id region, id
    #     return ml[:matches].last
    # end

    # def fetch_mastery(region, id)
    # end
end
