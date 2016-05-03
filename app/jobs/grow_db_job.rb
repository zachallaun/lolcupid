class GrowDbJob < ActiveJob::Base
  def perform(region, final_target_size)
    n = Summoner.where(region: Summoner.regions[region]).count

    if n >= final_target_size
      FetchMastery.new.update_without_fetch
    else
      GenIds.new(region).grow_until(n + 1)
      FetchMastery.new.fetch_outdated
      GrowDbJob.perform_later(region, final_target_size)
    end
  end
end
