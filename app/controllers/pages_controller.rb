class PagesController < ApplicationController
  include ChampionRecommendations

  def index
    render layout: "index"
  end

  def about
    render layout: "about"
  end

  def summoner
    @query_champions, @recommendations, @summoner = summoner_recs
    render layout: "about"
  end

  def champions
    @query_champions, @recommendations = query_and_recs
    render layout: "about"
  end
end
