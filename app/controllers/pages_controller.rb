class PagesController < ApplicationController
  include ChampionRecommendations

  def index
    @summoner_count = Summoner.count
    render layout: "index"
  end

  def about
    render layout: "about"
  end

  def summoner
    begin
      @query_champions, @recommendations, @summoner = summoner_recs
      render layout: "about"
    rescue RiotClient::RequestError => e
      flash.alert = "Couldn't fetch summoner info. The summoner name and region may have been invalid."
      redirect_to root_url
    end
  end

  def champions
    @query_champions, @recommendations = query_and_recs
    render layout: "about"
  end
end
