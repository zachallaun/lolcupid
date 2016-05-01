class ChampionMastery < ActiveRecord::Base
  belongs_to :summoner
  belongs_to :champion

  validates :summoner, uniqueness: {scope: :champion}
end
