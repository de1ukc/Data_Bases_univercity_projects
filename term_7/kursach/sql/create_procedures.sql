CREATE OR REPLACE PROCEDURE add_pilot(
    p_first_name VARCHAR(30),
    p_second_name VARCHAR(30),
    p_last_name VARCHAR(30),
    p_country_id INT
) AS $$
BEGIN
    INSERT INTO pilots (first_name, second_name, last_name, country_id)
    VALUES (p_first_name, p_second_name, p_last_name, p_country_id);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE add_race(
    p_track_id INT,
    p_race_date TIMESTAMP,
    p_weather_id INT,
    p_race_type_id INT,
    p_name VARCHAR(256)
) AS $$
BEGIN
    INSERT INTO races (track_id, race_date, weather_id, race_type_id, name)
    VALUES (p_track_id, p_race_date, p_weather_id, p_race_type_id, p_name);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE add_track(
    p_circle_length DECIMAL,
    p_number_of_circles INT,
    p_name VARCHAR(256),
    p_country_id INT
) AS $$
BEGIN
    INSERT INTO tracks (circle_length, number_of_circles, name, country_id)
    VALUES (p_circle_length, p_number_of_circles, p_name, p_country_id);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE add_champion(
    p_pilot_id INT,
    p_wdc INT,
    p_description TEXT
) AS $$
BEGIN
    INSERT INTO champions (pilot_id, wdc, description)
    VALUES (p_pilot_id, p_wdc, p_description);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE add_log(
    p_description TEXT
) AS $$
BEGIN
    INSERT INTO logs (description)
    VALUES (p_description);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE insert_pilots_numbers_by_name_and_year(
    p_number INT,
    p_second_name VARCHAR(30),
    p_year INT
) AS $$
DECLARE
    v_pilot_id INT;
    v_season_id INT;
BEGIN
    -- Получаем pilot_id на основе second_name
    SELECT id INTO v_pilot_id
    FROM pilots
    WHERE second_name = p_second_name;

    -- Получаем season_id на основе year
    SELECT id INTO v_season_id
    FROM seasons
    WHERE season_year = p_year;

    -- Проверяем, что pilot_id и season_id были успешно найдены
    IF v_pilot_id IS NOT NULL AND v_season_id IS NOT NULL THEN
        -- Вставляем данные в таблицу pilots_numbers
        INSERT INTO pilots_numbers (number, pilot_id, season_id)
        VALUES (p_number, v_pilot_id, v_season_id);
    ELSE
        RAISE EXCEPTION 'Не удалось найти pilot_id или season_id для введенных данных.';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE insert_pilots_statistic(
    p_wins INT,
    p_wdc INT,
    p_points DECIMAL,
    p_fastest_laps INT,
    p_first_name VARCHAR(30),
    p_second_name VARCHAR(30),
    p_pilot_id INT DEFAULT NULL
) AS $$
DECLARE
    v_pilot_id INT;
BEGIN
    -- Если pilot_id передан, используем его
    IF p_pilot_id IS NOT NULL THEN
        v_pilot_id := p_pilot_id;
    ELSE
        -- Ищем pilot_id по first_name и second_name
        SELECT id INTO v_pilot_id
        FROM pilots
        WHERE first_name = p_first_name AND second_name = p_second_name;
    END IF;

    IF v_pilot_id IS NOT NULL THEN
        INSERT INTO pilots_statistic (wins, wdc, points, fastest_laps, pilot_id)
        VALUES (p_wins, p_wdc, p_points, p_fastest_laps, v_pilot_id);
    ELSE
        RAISE EXCEPTION 'Не удалось найти pilot_id для введенных данных.';
    END IF;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION get_champions()
RETURNS TABLE (
    first_name VARCHAR(30),
    second_name VARCHAR(30),
    wdc INT,
    points INT,
    wins INT,
    fastest_laps INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.first_name,
        p.second_name,
        c.wdc,
        ps.points,
        ps.wins,
        ps.fastest_laps
    FROM champions c
    LEFT JOIN pilots p ON c.pilot_id = p.id
    LEFT JOIN pilots_statistic ps ON ps.pilot_id = c.pilot_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_document(
    p_fact text,
    p_decision text,
    p_reason text
) AS $$
BEGIN
    INSERT INTO documents (fact, decision, reason)
    VALUES (p_fact, p_decision, p_reason);
END;
$$ LANGUAGE plpgsql;

call add_document('Breaking the track limits', '-5 superlicence points', 'Breaking the track limits in turn 1, 7, 19')
select * from documents;


CREATE OR REPLACE PROCEDURE add_team_pilot(
    p_team_id INT,
    p_pilot_id INT,
    p_valid_from TIMESTAMP DEFAULT current_timestamp,
    p_valid_to TIMESTAMP DEFAULT current_timestamp + interval '1 year'
) AS $$
BEGIN
    INSERT INTO teams_pilots (team_id, pilot_id, valid_from, valid_to)
    VALUES (p_team_id, p_pilot_id, p_valid_from, p_valid_to);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE insert_race_participants_documents(
    p_race_id INT,
    p_team_pilot_id INT,
    p_document_id INT,
	p_document_date TIMESTAMP DEFAULT current_timestamp
) AS $$
BEGIN
	INSERT INTO race_participants_documents (race_id, team_pilot_id, document_id, document_date)
	VALUES (p_race_id, p_team_pilot_id, p_document_id, p_document_date);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_pilots_with_statistic()
RETURNS TABLE (
    first_name VARCHAR(30),
    second_name VARCHAR(30),
	nickname VARCHAR(30),
    wdc INT,
    points INT,
    wins INT,
    fastest_laps INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.first_name,
        p.second_name,
		nn.nickname,
        c.wdc,
        ps.points,
        ps.wins,
        ps.fastest_laps
    FROM pilots p
    LEFT JOIN pilots_statistic ps ON ps.pilot_id = p.id
	LEFT JOIN nicknames nn ON nn.pilot_id = p.id
	left join champions c on c.pilot_id = p.id;
END;
$$ LANGUAGE plpgsql;

select * from get_pilots_with_statistic();


