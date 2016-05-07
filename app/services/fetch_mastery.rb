class FetchMastery
  MASTERY_INTRODUCED_ON = Date.parse('2015-04-28')
  MASTERY_AGE = (Date.today - MASTERY_INTRODUCED_ON).to_i

  RECENCY_DAMPENING = 0.6

  # cutoff should be
  # => ~mastery_age * (avg_mastery / mastery_age / num_champs)
  # => MASTERY_AGE * (1500 / 370 /130) = MASTERY_AGE * 11
  MASTERY_CUTOFF = MASTERY_AGE * 300
  # MASTERY_CUTOFF = MASTERY_AGE * 11
  # MASTERY_CUTOFF = MASTERY_AGE * 200
  MASTERY_DAMPENING = 1.136
  # MASTERY_DAMPENING = 1.33

  def initialize
    @client = RiotClient.new
  end

  def fetch_all
    Summoner.all.each { |s| fetch_mastery(s) }
  end

  def fetch_outdated(region = "na", limit: nil, threads: 1)
    too_old = 3.days.ago

    summoners = Summoner.where(region: Summoner.regions[region]).where(
      "last_scraped_at IS NULL OR last_scraped_at < ?", too_old
    ).limit(limit)

    chunks = summoners.each_slice((summoners.size / threads).round)

    chunks.map do |summoners|
      Thread.new do
        summoners.each { |s| fetch_mastery(s) }
      end
    end.map(&:join)
  end

  def fetch_mastery(summoner)
    mastery_data = @client.champion_mastery.summoner_champions(summoner.region, summoner.id)
    uw_mastery_points = 0
    last_scraped_at = Time.zone.now

    mastery_data.each do |champion_mastery|
      uw_mastery_points += champion_mastery["championPoints"]

      c = ChampionMastery.where(
        summoner_id: summoner.id,
        champion_id: champion_mastery["championId"]
      ).first_or_initialize

      c.uw_champion_points = champion_mastery["championPoints"]
      c.save!
    end

    summoner.update!(
      uw_mastery_points: uw_mastery_points,
      last_scraped_at: last_scraped_at
    )
  end

  def mult_factor_for(champion)
    if champion.release_date < MASTERY_INTRODUCED_ON
      mult_factor = 1
    else
      days_since_release = (Date.today - champion.release_date.to_date).to_i
      mult_factor = MASTERY_AGE.to_f / days_since_release
      mult_factor = 1 + (mult_factor-1)*RECENCY_DAMPENING
    end

    mult_factor
  end

  def dampen_masteries(masteries)
    md = (1.0/MASTERY_DAMPENING)
    masteries.where("champion_points > #{MASTERY_CUTOFF}").update_all(
      "champion_points = #{MASTERY_CUTOFF} + (champion_points - #{MASTERY_CUTOFF})^(#{md})"
    )
  end

  def update_champion_points
    # multiplicative factor to account for release date > mastery introduction
    Champion.all.each do |champion|
      mult_factor = mult_factor_for(champion)

      champion.champion_masteries.update_all(
        "champion_points = uw_champion_points * #{mult_factor}"
      )
    end

    dampen_masteries(ChampionMastery.all)
  end

  def update_champion_points_s(summoner)
    values = summoner.champion_masteries.includes(:champion).map do |mastery|
      "(#{mastery.id}, #{mastery.uw_champion_points * mult_factor_for(mastery.champion)})"
    end.join(", ")

    ChampionMastery.connection.update_sql(<<-SQL)
      WITH new_champion_masteries (id, champion_points) AS (
          VALUES #{values}
      )
      UPDATE champion_masteries
          SET champion_points = new_champion_masteries.champion_points
      FROM new_champion_masteries
      WHERE new_champion_masteries.id = champion_masteries.id
    SQL

    dampen_masteries(summoner.champion_masteries)
  end

  def update_mastery_points_sql
    <<-SQL
      UPDATE summoners
        SET mastery_points = (
          SELECT sum(cm.champion_points)
          FROM champion_masteries cm
          WHERE cm.summoner_id = summoners.id
        )
    SQL
  end

  def update_mastery_points
    Summoner.connection.update_sql(update_mastery_points_sql)
  end

  def update_mastery_points_s(s)
    Summoner.connection.update_sql(<<-SQL)
      #{update_mastery_points_sql}
      WHERE summoners.id = #{s.id}
    SQL
  end

  def update_devotion
    avg_mastery_points = Summoner.average(:mastery_points).to_i
    Summoner.all.each { |s| update_devotion_s(s, avg_mastery_points) }
    return nil
  end

  def update_devotion_s(summoner, avg_mastery_points=nil)
    s_id = summoner.id

    if avg_mastery_points.nil?
      avg_mastery_points = Summoner.average(:mastery_points).to_i
    end

    mastery_points_s = Summoner.find(s_id).mastery_points
    champs_played_s = ChampionMastery.where(summoner_id: s_id).count
    if champs_played_s == 0 then return nil end

    champs_played_s_frac = 1 / champs_played_s.to_f
    if mastery_points_s.present?
      ChampionMastery.where(summoner_id: s_id).update_all(
        "devotion = (champion_points::float / #{mastery_points_s} - #{champs_played_s_frac}) * (#{mastery_points_s} / #{avg_mastery_points.to_f})"
      )
    end

    return nil
  end

  def update_mastery_data_for(summoner)
    fetch_mastery(summoner)
    update_champion_points_s(summoner)
    update_mastery_points_s(summoner)
    update_devotion_s(summoner)
  end

  def update_all_mastery_data
    fetch_all
    update_champion_points
    update_mastery_points
    update_devotion
  end

  def update_outdated_mastery_data(limit: nil, threads: 1)
    fetch_outdated(limit: limit, threads: threads)
    update_champion_points
    update_mastery_points
    update_devotion
  end

  def update_without_fetch
    update_champion_points
    update_mastery_points
    update_devotion
  end


  def devotion_of(s_id)
    printhash = Hash.new(0)
    ChampionMastery.where(summoner_id: s_id).each do |champ|
      printhash[Champion.find(champ.champion_id).name] = champ.devotion
    end
    printlist = printhash.sort_by {|_key, value| value}.reverse
    puts printlist
  end
end


# SELECT
#     c.name,
#     sum(cm.devotion * target.devotion) AS rec_value
# FROM champions c
# JOIN champion_masteries cm ON cm.champion_id = c.id
# LEFT JOIN LATERAL (
#     SELECT cm2.devotion FROM champion_masteries cm2 JOIN champions ON champions.id = cm2.champion_id
#         WHERE champions.name = 'Twitch'
#         AND cm2.summoner_id = cm.summoner_id
# ) target ON true
# GROUP BY c.id
# ORDER BY rec_value DESC;
