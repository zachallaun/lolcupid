class UpdateChampionMasteryFields < ActiveRecord::Migration
  def up
    remove_column :summoners, :first_match
    rename_column :summoners, :mastery_points, :uw_mastery_points
    rename_column :champion_masteries, :champion_points, :uw_champion_points
  end

  def down
    add_column    :summoners, :first_match, :timestamp
    rename_column :summoners, :uw_mastery_points, :mastery_points
    rename_column :champion_masteries, :uw_champion_points, :champion_points
  end
end
