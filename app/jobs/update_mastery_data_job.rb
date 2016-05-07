class UpdateMasteryDataJob < ActiveJob::Base
  def perform
    FetchMastery.new.update_outdated_mastery_data(limit: 1000, threads: 3)
  end
end
