namespace :summoners do
  desc "Grow the database of Summoners in NA and EUW by 10k each"
  task grow: :environment do
    GrowDbJob.perform_later(Summoner.na.count + 10_000, "na")
    GrowDbJob.perform_later(Summoner.euw.count + 10_000, "euw")
  end
end
