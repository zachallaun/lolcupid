class AddAssetVersionToChampions < ActiveRecord::Migration
  def change
    add_column :champions, :asset_version, :string
  end
end
