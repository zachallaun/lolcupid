class AddNicknameToChampions < ActiveRecord::Migration
  def change
    add_column :champions, :nickname, :string
  end
end
