module ChampionRecommendations
  extend ActiveSupport::Concern

  def query_and_recs
    champ_names = champ_names_from_params

    if champ_names.present?
      [
        query_champions = Champion.by_names(champ_names_from_params),
        Champion.recommended_for(query_champions)
      ]
    else
      [[], []]
    end
  end

  def summoner_recs
    summoner = find_summoner
    champs = summoner.top_champions(5)

    [
      champs,
      Champion.recommended_for(champs, summoner),
      summoner
    ]
  end

  private

  def champ_names_from_params
    names = params[:name] || ""
    names.split(",").map { |n| Champion.standardize_name_url(n) }
  end

  def find_summoner
    summoner_params = find_summoner_params
    s = Summoner.where(
      region: Summoner.regions[summoner_params[:region]],
      standardized_name: summoner_params[:name]
    ).first

    if s.nil?
      s = FetchSummoner.new.fetch_by_name(
        summoner_params[:region],
        summoner_params[:name]
      )
    end

    if s.last_scraped_at.nil? || s.last_scraped_at < 3.days.ago
      FetchMastery.new.update_mastery_data_for(s)
    end

    s
  end

  def find_summoner_params
    {
      region: params[:region].downcase,
      name: params[:name].downcase.gsub(' ', '')
    }
  end
end
