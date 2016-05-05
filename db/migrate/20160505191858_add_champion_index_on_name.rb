class AddChampionIndexOnName < ActiveRecord::Migration
  def change
    add_index :champions, :name
  end
end
