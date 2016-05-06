class API::RecommendationsController < ApplicationController
  include ChampionRecommendations

  def show
    @query_champions, @recommendations = query_and_recs
  end
end
