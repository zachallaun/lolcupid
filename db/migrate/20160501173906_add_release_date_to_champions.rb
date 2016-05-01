class AddReleaseDateToChampions < ActiveRecord::Migration
  def change
    add_column :champions, :release_date, :datetime
  end
end
