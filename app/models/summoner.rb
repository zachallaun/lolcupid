class Summoner < ActiveRecord::Base
  enum region: [:br, :eune, :euw, :jp, :kr, :lan, :las, :na, :oce, :ru, :tr]
  enum tier: [:challenger, :master, :diamond, :platinum, :gold, :silver, :bronze]
  enum division: [:i, :ii, :iii, :iv, :v]

  has_many :champion_masteries

  validates :region, presence: true
  validate :validate_tier_and_division

  TIER_MAP = {"CHALLENGER"=>:challenger, "MASTER"=>:master, "DIAMOND"=>:diamond, "PLATINUM"=>:platinum, "GOLD"=>:gold, "SILVER"=>:silver, "BRONZE"=>:bronze}
  DIVISION_MAP = {"I"=>:i, "II"=>:ii, "III"=>:iii, "IV"=>:iv, "V"=>:v}

  def self.set_entry(
    id, # bigint NOT NULL,
    standardized_name, # character varying NOT NULL,
    display_name, # character varying NOT NULL,
    summoner_level, # integer,
    tier, # integer,
    division, # integer,
    profile_icon_id, # integer,
    last_scraped_at, # timestamp without time zone,
    mastery_points, # integer,
    region # integer
    )

    summoner = where(id: id).first_or_initialize

    summoner.standardized_name = standardized_name
    summoner.display_name = display_name
    summoner.summoner_level = summoner_level
    summoner.tier = TIER_MAP[tier]
    summoner.division = DIVISION_MAP[division]
    summoner.profile_icon_id = profile_icon_id
    summoner.last_scraped_at = last_scraped_at
    summoner.region = region

    summoner.save!

    summoner
  end


  def self.filter_out_saved_ids(list_of_ids)
    # list_of_ids.delete_if {|id| find(id) != nil}
    list_of_ids.delete_if {|id| where(id: id).present?}
  end

  def top_champions(n = 5)
    Champion.joins(:champion_masteries).
      where(champion_masteries: {summoner: self}).
      where("champion_masteries.devotion > 0").
      order("champion_masteries.devotion DESC").
      limit(n)
  end

  private

  def validate_tier_and_division
    if challenger? && !i? || master? && !i?
      errors[:division] << "must be I if tier is Challenger or Master. Attempted to set to #{:division}."
    elsif tier && !division
      errors[:division] << "must be set if tier is set."
    elsif division && !tier
      errors[:tier] << "must be set if division is set."
    end
  end
end
