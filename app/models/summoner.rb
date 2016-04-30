class Summoner < ActiveRecord::Base
  enum tier: [:challenger, :master, :diamond, :platinum, :gold, :silver, :bronze]
  enum division: [:i, :ii, :iii, :iv, :v]

  validate :validate_tier_and_division

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
