class SeedDbJob < ActiveJob::Base
  def perform(region, file)
    GenIds.new(region).seed_with_file file
  end
end
