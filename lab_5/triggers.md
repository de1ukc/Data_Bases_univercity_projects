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
