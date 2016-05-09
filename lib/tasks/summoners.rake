namespace :summoners do
  desc "Grow the database of Summoners in NA and EUW by 10k each"
  task grow: :environment do
    GrowDbJob.perform_later(Summoner.na.count + 10_000, "na")
    GrowDbJob.perform_later(Summoner.euw.count + 10_000, "euw")
  end

  task update: :environment do
    UpdateDbJob.perform_later
  end

  desc "Seed summoners, mastery, and recs"
  task seed: :environment do
    GenIds.new.seed_with_file("id_seeds/small_seed.txt")
    FetchMastery.new.update_outdated_mastery_data
    Recommendations.new.update_all_champions
  end
end
