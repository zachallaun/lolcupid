class Summoner < ActiveRecord::Base
  enum region: [:br, :eune, :euw, :jp, :kr, :lan, :las, :na, :oce, :ru, :tr]
  enum tier: [:challenger, :master, :diamond, :platinum, :gold, :silver, :bronze]
  enum division: [:i, :ii, :iii, :iv, :v]

  has_many :champion_masteries

  validates :region, presence: true
  validate :validate_tier_and_division

  TIER_MAP = {"CHALLENGER"=>:challenger, "MASTER"=>:master, "DIAMOND"=>:diamond, "PLATINUM"=>:platinum, "GOLD"=>:gold, "SILVER"=>:silver, "BRONZE"=>:bronze}
  DIVISION_MAP = {"I"=>:i, "II"=>:ii, "III"=>:iii, "IV"=>:iv, "V"=>:v}

  # def self.save_from_api(summoner_api_data, league_api_data, region)
  #   tier_map = {"CHALLENGER"=>:challenger, "MASTER"=>:master, "DIAMOND"=>:diamond, "PLATINUM"=>:platinum, "GOLD"=>:gold, "SILVER"=>:silver, "BRONZE"=>:bronze}
  #   division_map = {"I"=>:i, "II"=>:ii, "III"=>:iii, "IV"=>:iv, "V"=>:v}

  #   for standardized_name in summoner_api_data.keys() do
  #     s = summoner_api_data[standardized_name]
  #     s_id = s[:id]
  #     where(id: s_id).first_or_initialize do |summoner|
  #       summoner.standardized_name = standardized_name
  #       summoner.display_name = s[:name]
  #       summoner.summoner_level = s[:summonerLevel]
  #       summoner.profile_icon_id = s[:profileIconId]
  #       summoner.region = region

  #       # what happens if unranked? returned 404 earlier
  #       if league_api_data then
  #         leagues = league_api_data[s[:id].to_s]
  #         for league in leagues do
  #           if league[:queue] == "RANKED_SOLO_5x5" then
  #             summoner.tier = tier_map[league[:tier]]
  #             # I don't understand what the zero is for... Why is it a list of entries
  #             summoner.division = division_map[league[:entries][0][:division]]
  #           end
  #         end
  #       end

  #       summoner.save!
  #     end
  #   end

  #   # if summoner.persisted?
  # end

  def self.set_entry(
    id, # bigint NOT NULL,
    standardized_name, # character varying NOT NULL,
    display_name, # character varying NOT NULL,
    summoner_level, # integer,
    tier, # integer,
    division, # integer,
    first_match, # timestamp without time zone,
    profile_icon_id, # integer,
    last_scraped_at, # timestamp without time zone,
    mastery_points, # integer,
    region # integer
    )

    # puts "hello"
    # # s = summoner_api_data[standardized_name]
      summoner = where(id: id).first_or_initialize

      summoner.standardized_name = standardized_name
      summoner.display_name = display_name
      summoner.summoner_level = summoner_level
      summoner.tier = TIER_MAP[tier]
      summoner.division = DIVISION_MAP[division]
      summoner.first_match = first_match
      summoner.profile_icon_id = profile_icon_id
      summoner.last_scraped_at = last_scraped_at
      summoner.region = region

      summoner.save!
  end


  def self.filter_out_saved_ids(list_of_ids)
    # list_of_ids.delete_if {|id| find(id) != nil}
    list_of_ids.delete_if {|id| where(id: id).present?}
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
