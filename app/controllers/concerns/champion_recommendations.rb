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

  private

  def champ_names_from_params
    names = params[:name] || ""
    names.split(",").map { |n| Champion.standardize_name_url(n) }
  end
end
