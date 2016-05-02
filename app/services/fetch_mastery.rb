class FetchMastery
  MASTERY_INTRODUCED_ON = Date.parse('2015-04-28')

  def initialize
    @client = RiotClient.new
  end

  def fetch_all
    Summoner.all.each { |s| fetch_mastery(s) }
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

  def update_champion_points
    days_since_mastery_introduced = (Date.today - MASTERY_INTRODUCED_ON).to_i

    Champion.all.each do |champion|
      if champion.release_date < MASTERY_INTRODUCED_ON
        mult_factor = 1
      else
        days_since_release = (Date.today - champion.release_date.to_date).to_i
        mult_factor = days_since_mastery_introduced.to_f / days_since_release
        puts "hmmmm", mult_factor
      end

      champion.champion_masteries.update_all(
        "champion_points = uw_champion_points * #{mult_factor}"
      )
    end
  end

  def update_mastery_points
    Summoner.connection.update_sql(<<-SQL)
      UPDATE summoners
        SET mastery_points = (
          SELECT sum(cm.champion_points)
          FROM champion_masteries cm
          WHERE cm.summoner_id = summoners.id
        )
    SQL
  end

  def update_devotion
    avg_mastery_points = Summoner.average(:mastery_points).to_i

    ChampionMastery.update_all(
      "devotion = champion_points::float / #{avg_mastery_points}"
    )
  end

  def update_all_mastery_data
    fetch_all
    update_champion_points
    update_mastery_points
    update_devotion
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
