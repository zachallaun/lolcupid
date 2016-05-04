class AddSkinsToChampions < ActiveRecord::Migration
  def change
    add_column :champions, :skins, :jsonb
  end
end
