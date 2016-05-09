class GenIds
    TIER_BREAKDOWN = {
        # Breakdowns artificially inflated to get more high-level summoners
        "challenger" => 0.005,
        "master"     => 0.01,
        "diamond"    => 0.0585,
        "platinum"   => 0.1035,
        "gold"       => 0.1842,
        "silver"     => 0.383,
        "bronze"     => 0.34
    }

    GROW_FROM_MOST_RECENT_X_MATCHES = 10

    def initialize(region = "na")
        @client = RiotClient.new
        @region = region
    end

    def summoners
        Summoner.where(region: Summoner.regions[@region])
    end

    def seed
        combo_list = []
        if (@region == "na") then
            challenger = ["Superman Rip", "Grigne", "Janna Mechanics", "Zaganox", "Linsanityy", "HvK Porky", "Myrna", "I Am Revenge", "OfSerenity", "FeedPally", "BillysBoss", "Ablazeolive", "GladeGleamBright", "iMysterious"]
            master = ["Viaz"]
            diamond = ["Wingsofdeath", "Mahir"]
            platinum = []
            gold = ["rekabat", "mutinyonthebay"]
            silver = ["nerd time"]
            bronze = ["shashad"]
            unranked = ["gorper", "theburninator"]

            combo_list = challenger + master + diamond + platinum + gold + silver + bronze + unranked
        elsif @region == "euw" then
            challenger = ["Christofferos"]
            master = ["William", "heliolite"]
            diamond = ["h4h4lolz"]
            platinum = ["LittleDejavue"]
            gold = ["Get Patriced"]
            silver = ["darkxx"]
            bronze = ["OvaLeona211"]
            unranked = ["lescootard"]

            combo_list = challenger + master + diamond + platinum + gold + silver + bronze + unranked
        end

        fs = FetchSummoner.new
        for s in combo_list
            fs.fetch_by_name @region, s
        end
    end

    def seed_with_file(file)
        fs = FetchSummoner.new
        File.open(file, "r") do |f|
            while line = f.gets
                begin
                    fs.fetch_by_id @region, line.to_i
                rescue RiotClient::RequestError => e
                    # skip
                end
            end
        end
    end

    def db_dump_ids(file)
        output = File.open(file, "w")
        for s_id in summoners.map(&:id)
            output << s_id << "\n"
        end
        output.close
    end

    def db_tier_breakdown
        return {
            "challenger" => summoners.challenger.count,
            "master"     => summoners.master.count,
            "diamond"    => summoners.diamond.count,
            "platinum"   => summoners.platinum.count,
            "gold"       => summoners.gold.count,
            "silver"     => summoners.silver.count,
            "bronze"     => summoners.bronze.count
        }
    end

    def db_tier_balance
        db_region_total = summoners.count

        ret = Hash.new
        for tier, count in db_tier_breakdown
            ret[tier] = (count.to_f / db_region_total) / TIER_BREAKDOWN[tier]
        end
        return ret
    end

    def balancing_sample
        ratios = db_tier_balance
        puts "#{ratios}"

        tier, ratio = ratios.sort_by {|_key, value| value}.first
        puts "Most imbalanced tier: #{tier}=> #{ratio}"

        return summoners.where(tier: Summoner.tiers[tier]).order("RANDOM()").first
    end

    def top_sample
        return summoners.order(tier: :asc, division: :asc).first
    end

    def grow_until(minimum_desired_size)
        while summoners.count < minimum_desired_size
            grow
        end
    end

    def grow
        smnr = balancing_sample
        puts "Beginning with: #{smnr.tier}, #{smnr.division}"

        m_ids = get_match_ids_from_summoner_id smnr.id
        if m_ids.empty? then return end

        # s_ids = get_summoner_ids_from_match_ids m_ids
        s_ids = get_summoner_ids_from_match_ids m_ids.first(GROW_FROM_MOST_RECENT_X_MATCHES)
        if s_ids.empty? then return end

        filtered_s_ids = summoners.filter_out_saved_ids s_ids
        fs = FetchSummoner.new
        for id in filtered_s_ids do
            puts "Adding summoner: #{id}"
            fs.fetch_by_id @region, id
        end
    end

private

    def get_match_ids_from_summoner_id(s_id)
        ml = @client.matchlist.by_id @region, s_id

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
        match = @client.match.by_match_id @region, m_id
        participants = match[:participantIdentities]
        return participants.map {|x| x[:player][:summonerId]}
    end
end
