-- добавляет пилота в таблицу чемпионов, если у него больше 0 чемпионств
CREATE OR REPLACE FUNCTION add_champion_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.wdc > 0 THEN
        CALL add_champion(NEW.pilot_id, NEW.wdc, NULL);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_insert_pilot
AFTER INSERT ON pilots_statistic
FOR EACH ROW
EXECUTE FUNCTION add_champion_trigger();

-- логирует добавление чемпиона в таблицу чемпионов
CREATE OR REPLACE FUNCTION add_champion_log_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO logs (description)
        VALUES ('Welcome, champion ' || (SELECT first_name || ' ' || second_name FROM pilots WHERE id = NEW.pilot_id));
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER on_insert_champion
AFTER INSERT ON champions
FOR EACH ROW
EXECUTE FUNCTION add_champion_log_trigger();


-- отнимает 5 очков у суперлицензии пилота за штраф во время гонки
CREATE OR REPLACE FUNCTION deduct_superlicence_points()
RETURNS TRIGGER AS $$
BEGIN
    -- Уменьшаем суперлицензионные баллы на 5 при добавлении документа
    UPDATE pilots
    SET superlicence_points = superlicence_points - 5
    WHERE id = (select pilot_id from teams_pilots where id = NEW.team_pilot_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_insert_document
AFTER INSERT ON race_participants_documents
FOR EACH ROW
EXECUTE FUNCTION deduct_superlicence_points();


-- если значение суперлицензии становится 0, то баним пилота из чемпионата и логируем
CREATE OR REPLACE FUNCTION check_superlicence_points()
RETURNS TRIGGER AS $$
DECLARE
    pilot_points INT;
BEGIN
    -- Получаем текущее значение superlicence_points
    SELECT superlicence_points INTO pilot_points
    FROM pilots
    WHERE id = NEW.id;

    -- Проверяем и корректируем значение superlicence_points
    IF pilot_points <= 0 THEN
        -- Устанавливаем в ноль
        NEW.superlicence_points = 0;

        -- Удаляем пилота из таблицы teams_pilots
        DELETE FROM teams_pilots
        WHERE pilot_id = NEW.id;

        -- Логируем дисквалификацию
        INSERT INTO logs (description)
        VALUES ('Пилот ' || NEW.first_name || ' ' || NEW.second_name || ' был дисквалифицирован из чемпионата за утрату суперлицензии');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_update_pilot_points
BEFORE UPDATE ON pilots
FOR EACH ROW
EXECUTE FUNCTION check_superlicence_points();


-- изменение в суперлицензии пилотов
CREATE OR REPLACE FUNCTION log_superlicence_points_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.superlicence_points != OLD.superlicence_points THEN
        INSERT INTO logs (description)
        VALUES ('Пилот ' || NEW.first_name || ' ' || NEW.second_name || ' был оштрафован на' || (NEW.superlicence_points - OLD.superlicence_points ));
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_update_superlicence_points
AFTER UPDATE ON pilots
FOR EACH ROW
EXECUTE FUNCTION log_superlicence_points_change();

