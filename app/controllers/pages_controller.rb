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

    r = Recommendations.new
    @recs = r.split_recommendation_hash_by_role(r.for_champion(c_id))

    @recs_top            = r.top_x_from_hash(@recs[0], 10)
    @recs_jungle         = r.top_x_from_hash(@recs[1], 10)
    @recs_middle         = r.top_x_from_hash(@recs[2], 10)
    @recs_bottom_carry   = r.top_x_from_hash(@recs[3], 10)
    @recs_bottom_support = r.top_x_from_hash(@recs[4], 10)

    render layout: "about"
  end
end
