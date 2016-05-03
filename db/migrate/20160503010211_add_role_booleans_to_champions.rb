class AddRoleBooleansToChampions < ActiveRecord::Migration
  def change
    add_column :champions, :can_top,         :boolean, default: false
    add_column :champions, :can_jungle,      :boolean, default: false
    add_column :champions, :can_mid,         :boolean, default: false
    add_column :champions, :can_bot_carry,   :boolean, default: false
    add_column :champions, :can_bot_support, :boolean, default: false
  end
end
