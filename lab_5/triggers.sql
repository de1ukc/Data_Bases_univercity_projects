CREATE OR REPLACE FUNCTION inc_winc_count() RETURNS TRIGGER AS $wins_count$
	BEGIN 
	
	IF OLD.winner_id != NEW.winner_id THEN
	
		UPDATE pilots
		SET wins_count = wins_count + 1
		WHERE pilots.pilot_id = OLD.winner_id;
	
	END IF;
	
	RETURN NEW;
	END;
	$wins_count$ LANGUAGE plpgsql;

CREATE TRIGGER inc_wins_count AFTER UPDATE OR INSERT ON grand_prix
	FOR EACH ROW EXECUTE PROCEDURE inc_winc_count();
