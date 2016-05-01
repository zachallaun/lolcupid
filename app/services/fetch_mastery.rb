class FetchMastery
  def initialize
    @client = RiotClient.new
  end

  def fetch_all
    Summoner.all.each { |s| fetch_mastery(s) }
  end

  def fetch_mastery(summoner)
    mastery_data = @client.champion_mastery.summoner_champions(summoner.region, summoner.summoner_id)
    mastery_points = 0
    last_scraped_at = Time.zone.now

    mastery_data.each do |champion_mastery|
      mastery_points += champion_mastery["championPoints"]
      ChampionMastery.where(
        summoner_id: summoner.id,
        champion_id: Champion.where(champion_id: champion_mastery["championId"]).pluck(:id).first
      ).first_or_initialize do |c|
        c.champion_points = champion_mastery["championPoints"]
        c.save!
      end
    end

    summoner.update!(
      mastery_points: mastery_points,
      last_scraped_at: last_scraped_at
    )
  end
end
