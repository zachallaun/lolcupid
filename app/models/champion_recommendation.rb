class ChampionRecommendation < ActiveRecord::Base
  belongs_to :champion_in,  class_name: 'Champion'
  belongs_to :champion_out, class_name: 'Champion'
end
