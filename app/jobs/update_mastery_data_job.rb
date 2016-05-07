class UpdateMasteryDataJob < ActiveJob::Base
  def perform
    FetchMastery.new.update_outdated_mastery_data(region: "na", limit: 1000, threads: 3)
    FetchMastery.new.update_outdated_mastery_data(region: "euw", limit: 1000, threads: 3)
  end
end
