class UpdateMasteryDataJob < ActiveJob::Base
  def perform
    FetchMastery.new.update_outdated_mastery_data(region: "na", limit: 500, threads: 2)
    FetchMastery.new.update_outdated_mastery_data(region: "euw", limit: 500, threads: 2)
  end
end
