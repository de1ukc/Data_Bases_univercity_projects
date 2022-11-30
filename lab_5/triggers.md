#### 1. Триггер, на инкрементирование количества побед у пилота, если он победил в Гран-При

```SQL
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
```


Проверка, которая уже не сработает, посколку есть проверка на то, что если мы просто тыкаем одного и того же пилота, то не будет добавляться победа, чтоб не стакать победы
```SQL
SELECT grand_prix_name, winner_id, pilots.first_name, pilots.wins_count FROM grand_prix
JOIN pilots ON pilots.pilot_id = grand_prix.winner_id
WHERE grand_prix.grand_prix_id = 1;

UPDATE grand_prix
	SET winner_id = 29
	WHERE grand_prix.grand_prix_id = 1;

UPDATE pilots
	SET wins_count = 103
	WHERE pilot_id = 29;
```


#### 2. Логирование победителей Гранд-При

```SQL
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
```

Проверка:

```SQL
UPDATE grand_prix
	SET winner_id = NULL
	WHERE grand_prix.grand_prix_id = 1;
	
UPDATE grand_prix
	SET winner_id = 29
	WHERE grand_prix.grand_prix_id = 1;

UPDATE pilots
SET wins_count = 103
WHERE pilot_id = 29;

SELECT * FROM logs;
```


#### 3. Логирование победителей квалификаций:

```SQL
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
```
