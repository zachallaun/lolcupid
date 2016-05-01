class UseRiotPrimaryKeys < ActiveRecord::Migration
  def up
    execute "ALTER TABLE champion_masteries DROP CONSTRAINT unique_summoner_champion_pair;"

    remove_foreign_key :champion_masteries, :summoners
    remove_foreign_key :champion_masteries, :champions

    ChampionMastery.connection.update_sql(<<-SQL)
      UPDATE champion_masteries
      SET summoner_id = summoners.summoner_id
      FROM summoners
      WHERE summoners.id = champion_masteries.summoner_id;
    SQL

    ChampionMastery.connection.update_sql(<<-SQL)
      UPDATE champion_masteries
      SET champion_id = champions.champion_id
      FROM champions
      WHERE champions.id = champion_masteries.champion_id;
    SQL

    remove_column :summoners, :id
    rename_column :summoners, :summoner_id, :id
    execute "ALTER TABLE summoners ADD PRIMARY KEY (id);"

    remove_column :champions, :id
    rename_column :champions, :champion_id, :id
    execute "ALTER TABLE champions ADD PRIMARY KEY (id);"

    add_foreign_key :champion_masteries, :summoners
    add_foreign_key :champion_masteries, :champions

    execute "ALTER TABLE champion_masteries ADD CONSTRAINT unique_summoner_champion_pair UNIQUE (summoner_id, champion_id);"
  end

  def down
  end
end
