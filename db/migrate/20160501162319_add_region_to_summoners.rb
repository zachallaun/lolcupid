class AddRegionToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :region, :integer

    # I'm assuming we only have seed data from GenIds, which is all NA
    reversible do |direction|
      direction.up do
        Summoner.update_all(region: Summoner.regions[:na])
      end
    end
  end
end
