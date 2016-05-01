class Summoner < ActiveRecord::Base
  enum region: [:br, :eune, :euw, :jp, :kr, :lan, :las, :na, :oce, :ru, :tr]
  enum tier: [:challenger, :master, :diamond, :platinum, :gold, :silver, :bronze]
  enum division: [:i, :ii, :iii, :iv, :v]

  has_many :champion_masteries

  before_create :set_standardized_name
  before_update :set_standardized_name, if: :display_name_changed?

  validates :region, presence: true
  validate :validate_tier_and_division

  def self.save_from_api(summoner_api_data, league_api_data, region)
    tier_map = {"CHALLENGER"=>:challenger, "MASTER"=>:master, "DIAMOND"=>:diamond, "PLATINUM"=>:platinum, "GOLD"=>:gold, "SILVER"=>:silver, "BRONZE"=>:bronze}
    division_map = {"I"=>:i, "II"=>:ii, "III"=>:iii, "IV"=>:iv, "V"=>:v}

    s = summoner_api_data
    s_id = s[:id]

    where(id: s_id).first_or_initialize do |summoner|
      summoner.display_name = s[:name]
      summoner.summoner_level = s[:summonerLevel]
      summoner.profile_icon_id = s[:profileIconId]
      summoner.region = region

      # what happens if unranked? returned 404 earlier
      if league_api_data then
        league_api_data[s[:id].to_s].each do |league|
          if league[:queue] == "RANKED_SOLO_5x5" then
            summoner.tier = tier_map[league[:tier]]
            # I don't understand what the zero is for... Why is it a list of entries
            summoner.division = division_map[league[:entries][0][:division]]
          end
        end
      end

      summoner.save!
    end
  end


  def self.filter_out_saved_ids(list_of_ids)
    list_of_ids.delete_if {|id| find(id) != nil}
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

  def set_standardized_name
    self.standardized_name = display_name.downcase.gsub(' ', '')
  end
end
