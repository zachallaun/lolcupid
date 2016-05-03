class CreateChampionRecommendations < ActiveRecord::Migration
  def change
    create_table :champion_recommendations do |t|
      t.references :champion_in, index: true
      t.references :champion_out, index: true
      t.float :score
    end

    add_foreign_key :champion_recommendations, :champions, column: :champion_in_id
    add_foreign_key :champion_recommendations, :champions, column: :champion_out_id
  end
end
