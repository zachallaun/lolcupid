class GrowDbJob < ActiveJob::Base
  def perform(final_target_size, region="na")
    n = Summoner.where(region: Summoner.regions[region]).count

    if n >= final_target_size
      FetchMastery.new.update_without_fetch
      Recommendations.new.update_all_champions
    else
      GenIds.new(region).grow_until(n + 1)
      FetchMastery.new.fetch_outdated
      GrowDbJob.perform_later(final_target_size, region)
    end
  end
end
