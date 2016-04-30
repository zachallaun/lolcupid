class CreateSummoners < ActiveRecord::Migration
  def change
    create_table :summoners do |t|
      t.bigint :riot_id, null: false
      t.string :normalized_name, null: false
      t.string :name, null: false
      t.integer :summoner_level
      t.integer :tier
      t.integer :division

      t.timestamps null: false
    end

    add_index :summoners, :riot_id
    add_index :summoners, :normalized_name
  end
end
