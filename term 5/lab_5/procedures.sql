CREATE PROCEDURE insert_car(engine_by_team_id INT, team_id INT, cars_name VARCHAR)
LANGUAGE SQL
AS $$
INSERT INTO cars (engine_by_team_id, team_id, cars_name) 
VALUES (engine_by_team_id, team_id, cars_name) 
$$;
