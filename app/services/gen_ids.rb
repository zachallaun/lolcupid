class GenIds
    def initialize
        @client = RiotClient.new
    end

    def seed
        # add_summoner_by_name_to_db "na", "rekabat"
        # add_summoner_by_name_to_db "na", "nerd time"
        add_summoner_by_name_to_db "na", "gorper"
    end

    def add_summoner_by_name_to_db(region, name)
        summoner = @client.summoner.by_name region, name

        standardized_name = summoner.keys[0]
        id = summoner[standardized_name][:id]

        league = get_league_api_info region, id
        # league   = @client.league.by_id_entry region, id
        Summoner.save_from_api(summoner, league)
    end

    def add_summoner_by_id_to_db(region, id)
        summoner = @client.summoner.by_id region, id
        # this is kind of dumb, i make another call just to get their standardized name + it's in the format Summoner class expects
        summoner = @client.summoner.by_name region, summoner[id.to_s][:name]
        league = get_league_api_info region, id
        # league   = @client.league.by_id_entry region, id
        Summoner.save_from_api(summoner, league)
    end

    # return nil if user not ranked
    def get_league_api_info(region, id)
        begin
            return @client.league.by_id_entry region, id
        rescue
            return nil
        end
    end

    def test
        puts "Test function:"
        # id_list = [19062366, 32638411, 192034, 123, 643, 19062366]
        # puts "#{new_id_list}"

        Summoner.count
    end

    def grow
        # s = Summoner.first
        smnr = Summoner.order("RANDOM()").first
        m_ids = get_match_ids_from_summoner_id "na", smnr.summoner_id
        # s_ids = get_summoner_ids_from_match_ids m_ids
        s_ids = get_summoner_ids_from_match_ids m_ids[0,2]

        filtered_s_ids = Summoner.filter_out_saved_ids s_ids

        for id in filtered_s_ids do
            add_summoner_by_id_to_db("na", id)
        end
    end

    def get_match_ids_from_summoner_id(region, s_id)
        ml = @client.matchlist.by_id region, s_id

        # ml[:matches] is a list of match hashes, with the id at :matchId
        return ml[:matches].map {|x| x[:matchId]}
    end

    def get_summoner_ids_from_match_ids(m_ids)
        s_ids = []
        for m_id in m_ids do
            match_s_ids = get_all_summoners_from_match m_id
            s_ids.concat(match_s_ids)
            s_ids.uniq!
        end

        return s_ids
    end

    def get_all_summoners_from_match(m_id)
        match = @client.match.by_match_id "na", m_id
        participants = match[:participantIdentities]
        return participants.map {|x| x[:player][:summonerId]}
    end
end
