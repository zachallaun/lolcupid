class AddComputedMasteryFieldTriggers < ActiveRecord::Migration
  def up
    add_column :summoners, :first_mastery_on, :date
    add_column :summoners, :mastery_rate, :float

    execute <<-SQL
        CREATE OR REPLACE FUNCTION summoner_mastery_rate() RETURNS trigger
        AS $summoner_mastery_rate$
            DECLARE
                days_since_first_mastery integer;

            BEGIN
                days_since_first_mastery = now()::date - NEW.first_mastery_on;

                IF (TG_OP = 'INSERT' OR NEW.mastery_points != OLD.mastery_points) THEN
                    NEW.mastery_rate := NEW.mastery_points::float / days_since_first_mastery;
                END IF;

                RETURN NEW;
            END;
        $summoner_mastery_rate$ LANGUAGE plpgsql;

        CREATE TRIGGER summoner_mastery_rate BEFORE INSERT OR UPDATE ON summoners
            FOR EACH ROW EXECUTE PROCEDURE summoner_mastery_rate();
    SQL
  end

  def down
    remove_column :summoners, :first_mastery_on
    remove_column :summoners, :mastery_rate

    execute "DROP TRIGGER IF EXISTS summoner_mastery_rate ON summoners;"
    execute "DROP FUNCTION IF EXISTS summoner_mastery_rate();"
  end
end
