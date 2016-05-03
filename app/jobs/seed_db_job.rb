class SeedDbJob < ActiveJob::Base
  def perform
    GenIds.new.seed_with_file "seed.txt"
  end
end
