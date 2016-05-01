class GenIds
    TIER_BREAKDOWN = [0.0001, 0.0007, 0.0185, 0.0735, 0.1842, 0.383, 0.34]

    def initialize
        @client = RiotClient.new
    end

    def seed
        na_challenger = ["Superman Rip", "Grigne", "Janna Mechanics", "Zaganox", "Linsanityy", "HvK Porky", "Myrna", "I Am Revenge", "OfSerenity", "FeedPally", "BillysBoss", "Ablazeolive", "GladeGleamBright", "iMysterious"]
        na_master = ["Viaz"]
        na_diamond = ["Wingsofdeath", "Mahir"]
        na_platinum = []
        na_gold = ["rekabat", "mutinyonthebay"]
        na_silver = ["nerd time"]
        na_bronze = ["shashad"]
        na_unranked = ["gorper", "theburninator"]

        for s in na_challenger + na_master + na_diamond + na_platinum + na_gold + na_silver + na_bronze + na_unranked
            add_summoner_by_name_to_db "na", s
        end
    end

    def seed_with_file(file)
        File.open(file, "r") do |f|
            while line = f.gets
                add_summoner_by_id_to_db "na", line.to_i
            end
        end
    end

    def add_summoner_by_name_to_db(region, name)
        summoner = get_summoner_api_info region, name
        if summoner == nil then return end

        standardized_name = summoner.keys[0]
        id = summoner[standardized_name][:id]

        league = get_league_api_info region, id
        # league   = @client.league.by_id_entry region, id
        Summoner.save_from_api(summoner, league, region)
    end

    def add_summoner_by_id_to_db(region, id)
        summoner = @client.summoner.by_id region, id
        # this is kind of dumb, i make another call just to get their standardized name + it's in the format Summoner class expects
        summoner = @client.summoner.by_name region, summoner[id.to_s][:name]
        league = get_league_api_info region, id
        # league   = @client.league.by_id_entry region, id
        Summoner.save_from_api(summoner, league, region)
    end

    # return nil if user can't be found
    def get_summoner_api_info(region, name)
        begin
            return @client.summoner.by_name region, name
        rescue
            return nil
        end
    end

    # return nil if user not ranked
    def get_league_api_info(region, id)
        begin
            return @client.league.by_id_entry region, id
        rescue
            return nil
        end
    end

    def count
        Summoner.count
    end

    def test
        puts "Test function:"
        db_tb = db_tier_balance
        db_total = count

        puts "#{db_total} summoners: #{db_tb}"
    end

    def db_tier_breakdown
        return [
            Summoner.challenger.count,
            Summoner.master.count,
            Summoner.diamond.count,
            Summoner.platinum.count,
            Summoner.gold.count,
            Summoner.silver.count,
            Summoner.bronze.count ]
    end

    def db_tier_balance
        db_tbd = db_tier_breakdown
        db_total = Summoner.count

        return Array.new(7) {|i| (db_tbd[i].to_f/db_total) / TIER_BREAKDOWN[i]}
    end

    def db_dump_ids(file)
        output = File.open(file, "w")
        for s_id in Summoner.all.map(&:id)
            output << s_id << "\n"
        end
        output.close
    end

    def balancing_sample
        db_tbd = db_tier_breakdown
        db_total = Summoner.count

        ratio = Array.new(7) {|i| (db_tbd[i].to_f/db_total) / TIER_BREAKDOWN[i]}
        puts "#{ratio}"

        min = ratio.max+1
        min_idx = 0
        for i in 0..6
            if db_tbd[i] != 0 then
                if ratio[i] < min then
                    min = ratio[i]
                    min_idx = i
                end
            end
        end

        case min_idx
        when 0
            return Summoner.challenger.order("RANDOM()").first
        when 1
            return Summoner.master.order("RANDOM()").first
        when 2
            return Summoner.diamond.order("RANDOM()").first
        when 3
            return Summoner.platinum.order("RANDOM()").first
        when 4
            return Summoner.gold.order("RANDOM()").first
        when 5
            return Summoner.silver.order("RANDOM()").first
        when 6
            return Summoner.bronze.order("RANDOM()").first
        end
    end

    def top_sample
        return Summoner.order(tier: :asc, division: :asc).drop.first
        # return Summoner.order(tier: :asc, division: :asc).drop(pos).first
    end

    def grow
        # s = Summoner.first
        # smnr = Summoner.order("RANDOM()").first
        smnr = balancing_sample
        puts "Beginning with: #{smnr.tier}, #{smnr.division}"

        m_ids = get_match_ids_from_summoner_id "na", smnr.id
        if m_ids.empty? then return end

        # s_ids = get_summoner_ids_from_match_ids m_ids
        s_ids = get_summoner_ids_from_match_ids m_ids[0,10]
        if s_ids.empty? then return end

        filtered_s_ids = Summoner.filter_out_saved_ids s_ids
        for id in filtered_s_ids do
            add_summoner_by_id_to_db("na", id)
        end
    end

    def get_match_ids_from_summoner_id(region, s_id)
        ml = @client.matchlist.by_id region, s_id

        if ml[:matches].empty? then
            return []
        else
            # ml[:matches] is a list of match hashes, with the id at :matchId
            return ml[:matches].map {|x| x[:matchId]}
        end
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
        # id_list = [19062366, 32638411, 192034, 123, 643, 19062366]
        match = @client.match.by_match_id "na", m_id
        participants = match[:participantIdentities]
        return participants.map {|x| x[:player][:summonerId]}
    end
end
