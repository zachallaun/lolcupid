class GrowDbJob < ActiveJob::Base
  def perform(final_target_size)
    n = Summoner.count

    if n >= final_target_size
      FetchMastery.new.update_without_fetch
    else
      GenIds.new.grow_until(n + 1)
      FetchMastery.new.fetch_outdated
      GrowDbJob.perform_later(final_target_size)
    end
  end
end
