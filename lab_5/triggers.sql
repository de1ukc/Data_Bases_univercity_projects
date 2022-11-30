CREATE OR REPLACE FUNCTION inc_winc_count() RETURNS TRIGGER AS $wins_count$
	BEGIN 
	
	IF OLD.winner_id != NEW.winner_id AND OLD.winner_id IS NOT NULL THEN
	
		UPDATE pilots
		SET wins_count = wins_count + 1
		WHERE pilots.pilot_id = OLD.winner_id;
	
	END IF;
	
	RETURN NEW;
	END;
	$wins_count$ LANGUAGE plpgsql;

CREATE TRIGGER inc_wins_count AFTER UPDATE OR INSERT ON grand_prix
	FOR EACH ROW EXECUTE PROCEDURE inc_winc_count();



CREATE OR REPLACE FUNCTION wins_logging() RETURNS TRIGGER AS $wins_logging$
	BEGIN
	IF OLD.winner_id IS NULL AND NEW.winner_id IS NOT NULL THEN
		INSERT INTO logs
		(date_of_log,time_of_log, log_message)
		VALUES
		(CAST(NOW() AS DATE), cast(NOW() AS TIME), 
		 (SELECT first_name || ' ' || second_name 
			FROM pilots
		   	WHERE pilot_id = NEW.winner_id) || ' wins ' || NEW.grand_prix_name);
		RETURN NEW;
	END IF;
	RETURN NULL; -- возвращаемое значение для триггера AFTER игнорируется
END;
$wins_logging$ LANGUAGE plpgsql;

CREATE TRIGGER wins_logging
AFTER INSERT OR UPDATE ON grand_prix
	FOR EACH ROW EXECUTE PROCEDURE wins_logging();


CREATE OR REPLACE FUNCTION qualis_logging() RETURNS TRIGGER AS $qualis_logging$
	BEGIN
	IF OLD.quali_winner_id IS NULL AND NEW.quali_winner_id IS NOT NULL THEN
		INSERT INTO logs
		(date_of_log,time_of_log, log_message)
		VALUES
		(CAST(NOW() AS DATE), cast(NOW() AS TIME), 
		 (SELECT first_name || ' ' || second_name 
			FROM pilots
		   	WHERE pilot_id = NEW.quali_winner_id) || ' wins ' || NEW.grand_prix_name || ' qualification');
		RETURN NEW;
	END IF;
	RETURN NULL; -- возвращаемое значение для триггера AFTER игнорируется
END;
$qualis_logging$ LANGUAGE plpgsql;

CREATE TRIGGER qualis_logging
AFTER INSERT OR UPDATE ON grand_prix
	FOR EACH ROW EXECUTE PROCEDURE qualis_logging();
	

CREATE OR REPLACE FUNCTION new_pilots_logging() RETURNS TRIGGER AS $new_pilots_logging$
	BEGIN
	INSERT INTO logs
	(date_of_log,time_of_log, log_message)
		VALUES
		(CAST(NOW() AS DATE), cast(NOW() AS TIME),
			NEW.first_name || ' ' || NEW.second_name || ' ' || NEW.pilots_number ||
		 ' arrived at the paddock'); 
		 return NEW;
	
	RETURN NULL; -- возвращаемое значение для триггера AFTER игнорируется
END;
$new_pilots_logging$ LANGUAGE plpgsql;

CREATE TRIGGER new_pilots_logging
AFTER INSERT ON pilots
	FOR EACH ROW EXECUTE PROCEDURE new_pilots_logging();

CREATE OR REPLACE FUNCTION delete_pilots_logging() RETURNS TRIGGER AS $delete_pilots_logging$
	BEGIN
	INSERT INTO logs
	(date_of_log,time_of_log, log_message)
		VALUES
		(CAST(NOW() AS DATE), cast(NOW() AS TIME),
			NEW.first_name || ' ' || NEW.second_name || ' ' || NEW.pilots_number ||
		 ' left the paddock. Disqualification.'); 
		 return OLD;
	RETURN NULL; -- возвращаемое значение для триггера AFTER игнорируется
END;
$delete_pilots_logging$ LANGUAGE plpgsql;

CREATE TRIGGER delete_pilots_logging
AFTER DELETE ON pilots
	FOR EACH ROW EXECUTE PROCEDURE delete_pilots_logging();
