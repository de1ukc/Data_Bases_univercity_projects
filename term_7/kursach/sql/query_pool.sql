
-- получаем всех чемпионов
select * from get_champions();

select * from pilots;

-- добавляем пилота в таблицу пилотов
DO $$ 
DECLARE
    country_id INTEGER;
BEGIN
    SELECT id INTO country_id FROM country WHERE name = 'Finland';

    IF country_id IS NOT NULL THEN
        CALL add_pilot('test1', 'test1', null, country_id);
	END IF;
END $$ LANGUAGE plpgsql;

-- delete from pilots
-- where id >= 24


select * from pilots_statistic;
-- вставим статистику пилота, если чемпионств > 1, его должно автоматически добавиь в чемпионы и залогировать
call insert_pilots_statistic(1,1,1.1,1,'test1','test1', NULL);
select * from champions;

-- delete from pilots_statistic where pilot_id = 56
-- delete from champions where pilot_id = 56;

-- добавим пользователя с 5 очками лицензии, а затем бахнем ему штрафик
select * from pilots;
insert into pilots (first_name, second_name, last_name, country_id, superlicence_points)
values
('test_licence','test_licence',null,1,5);

call add_team_pilot(1, 57);
select * from teams_pilots;
select * from logs;
select * from documents;
select * from races;
select * from pilots;

select * from race_participants_documents;

call insert_race_participants_documents(3,1,1);

update pilots
set superlicence_points = -1
where id = 57;


select * from get_pilots_with_statistic();

select * from get_champions();