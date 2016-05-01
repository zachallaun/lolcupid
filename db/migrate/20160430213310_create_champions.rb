class CreateChampions < ActiveRecord::Migration
  def change
    create_table :champions do |t|
      t.integer :champion_id, null: false
      t.string :name, null: false
      t.string :key, null: false
      t.string :title, null: false
      t.string :image, null: false
    end

    add_index :champions, :champion_id
  end
end
