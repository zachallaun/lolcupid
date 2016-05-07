class UpdateRecommendationsJob < ActiveJob::Base
  def perform
    Recommendations.new.update_all_champions
  end
end
