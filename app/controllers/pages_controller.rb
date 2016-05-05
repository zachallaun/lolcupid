class PagesController < ApplicationController
  def index
    render layout: "index"
  end

  def about
    render layout: "about"
  end

  def rec
  end

  def summoner
  end

  def champion
    @standardized_name = Champion.standardize_name_url(params[:name])
    c_id = Champion.where(name: @standardized_name).first.id

    @recommended_champs = Champion.select("champions.*, recs.score AS score").
      joins("JOIN champion_recommendations recs ON recs.champion_out_id = champions.id").
      where(recs: {champion_in_id: c_id}).
      order("recs.score DESC")

    render layout: "about"
  end
end
