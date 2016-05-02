class AddBackMasteryFields < ActiveRecord::Migration
  def change
    add_column :summoners, :mastery_points, :integer
    add_column :champion_masteries, :champion_points, :integer
    add_column :champion_masteries, :devotion, :float
  end
end
