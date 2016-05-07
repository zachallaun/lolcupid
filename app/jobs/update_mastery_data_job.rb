class UpdateMasteryDataJob < ActiveJob::Base
  def perform
    FetchMastery.new.update_outdated_mastery_data(limit: 5)
  end
end
