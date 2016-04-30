class Summoner < ActiveRecord::Base
  enum tier: [:challenger, :master, :diamond, :platinum, :gold, :silver, :bronze]
  enum division: [:i, :ii, :iii, :iv, :v]

  validate :validate_tier_and_division

  def self.save_from_api(api_data)
    find_or_initialize(summoner_id: api_data[:summoner_id]) do |summoner|
      if summoner.persisted?
        summoner.summoner_level = nil
        summoner.save!
      else # new_record? will be true

      end
    end
  end

  private

  def validate_tier_and_division
    if challenger? && !i? || master? && !i?
      errors[:division] << "must be I if tier is Challenger or Master"
    elsif tier? && !division?
      errors[:division] << "must be set if tier is set"
    elsif division? && !tier?
      errors[:tier] << "must be set if division is set"
    end
  end
end
