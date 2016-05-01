class AddChampionMasteryTablesAndColumns < ActiveRecord::Migration
  def change
    create_table :champion_masteries do |t|
      t.references :summoner, index: true, foreign_key: true
      t.references :champion, index: true, foreign_key: true
      t.integer :champion_points
    end

    reversible do |direction|
      direction.up do
        execute "ALTER TABLE champion_masteries ADD CONSTRAINT unique_summoner_champion_pair UNIQUE (summoner_id, champion_id);"
      end

      direction.down do
        execute "ALTER TABLE champion_masteries DROP CONSTRAINT unique_summoner_champion_pair;"
      end
    end

    add_column :summoners, :mastery_points, :integer
  end
end
