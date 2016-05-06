class AddSpellsToChampions < ActiveRecord::Migration
  def change
    add_column :champions, :spells, :jsonb
  end
end
