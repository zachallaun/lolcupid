class UpdateSummoners < ActiveRecord::Migration
  def change
    rename_column :summoners, :normalized_name, :standardized_name
    rename_column :summoners, :riot_id, :summoner_id
    rename_column :summoners, :name, :display_name
    add_column :summoners, :first_match, :datetime
    add_column :summoners, :profile_icon_id, :integer
  end
end
