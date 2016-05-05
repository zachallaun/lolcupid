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

  def champions
    @query_champions = Champion.where(name: champ_names_from_params)
    @recommendations = Champion.recommended_for(@query_champions)

    render layout: "about"
  end

  private

  def champ_names_from_params
    names = params[:name] || ""
    names.split(",").map { |n| Champion.standardize_name_url(n) }
  end
end
