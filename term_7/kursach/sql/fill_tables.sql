insert into country
(name)
values
('United Arab Emirates'),
('Bahrain'),
('Turkey'),
('Portugal'),
('Belgium'),
('Hungary'),
('USA'),
('Austria'),
('Italy'),
('Monaco'),
('Russia'),
('United Kingdom'),
('Finland'),
('Netherlands'),
('Mexico'),
('Australia'),
('Spain'),
('Thailand'),
('France'),
('Canada'),
('Germany'),
('Denmark');

select * from country;



insert into pilots
(first_name, second_name, last_name, country_id)
values
('Lewis','Hamilton',null,1),
('Valtteri', 'Bottas', null, 2),
('Max', 'Verstappen', null, 3),
('Sebastian', 'Vettel', null, 10),
('Charles', 'Leclerc', null, 13),
('Sergio', 'Perez', null, 4),
('Daniel', 'Ricciardo', null, 5),
('Carlos', 'Sainz', 'Jr.', 6),
('Alexander', 'Albon', null, 7),
('Pierre', 'Gasly', null, 8),
('Lando', 'Norris', null, 1),
('Kimi', 'Raikkonen', null, 2),
('Nico', 'Hulkenberg', null, 10),
('Lance', 'Stroll', null, 9),
('Esteban', 'Ocon', null, 8),
('Kevin', 'Magnussen', null, 11),
('Romain', 'Grosjean', null, 8),
('Antonio', 'Giovinazzi', null, 14),
('Nicholas', 'Latifi', null, 9),
('George', 'Russell', null, 1);

-- Изменение структуры таблицы, убирая NOT NULL для last_name
-- ALTER TABLE pilots
-- ALTER COLUMN last_name DROP NOT NULL;

select * from pilots;

insert into nicknames
(nickname, pilot_id)
values
('The Iceman', 13),  
('The Billion dollar man', 2),   
('RoBottas', 3),        
('Mad Max', 4),       
('The Finger', 5),           
('Lord Percival', 6),       
('Mexican Minister of Defence', 7),        
('Honeybadger', 8),     
('Smooth Operator', 9),        
('Albono', 10),         
('Mr.Monza', 11),        
('Last lap Lando', 12),       
('Hulk', 14),        
('Strolled', 15),      
('Estebun', 16),         
('Mag', 17),          
('Phoenix', 18),     
('Gio', 19),          
('Goatifi', 20),       
('The terrorist', 21);        

select * from nicknames;

insert into principals
(first_name, second_name, country_id)
values
('Toto','Wolf', 15),
('Christian', 'Horner', 1),  -- United Kingdom
('Zak', 'Brown', 1),  -- United Kingdom
('Cyril', 'Abiteboul', 8),  -- France
('Claire', 'Williams', 14),  -- Italy
('Otmar', 'Szafnauer', 2),  -- Finland
('Franz', 'Tost', 10),  -- Germany
('Fred', 'Vasseur', 9),  -- Canada
('Helmut', 'Marko', 10),  -- Germany
('Guenther', 'Steiner', 10),  -- Germany
('Matti', 'Binotto', 14);  -- Italy (Matti Binotto);

insert into seasons
(season_year)
values(2020);

insert into sponsors
(name)
values
('Shell'),
('Puma'),
('Rolex'),
('Oracle'),
('UPS'),
('Mission Winnow'),
('Petronas'),
('Uralkali'),
('ROKiT'),
('Microsoft'),
('Ray-Ban');


select * from country;
insert into teams
(country_id, name)
values
(10, 'Mercedes-AMG Petronas F1 Team'),
(1, 'McLaren F1 Team'),
(14, 'Scuderia Ferrari'),
(15, 'Red Bull Racing'),
(16, 'Haas F1 Team'),
(8, 'Alpine F1 Team'),
(15, 'Scuderia AlphaTauri'),
(14, 'Alfa Romeo Racing'),
(1, 'Williams Racing'),
(5, 'Racing Point');

select * from teams;

insert into race_types
(type)
values
('Grand Prix'),
('Qualifying'),
('Practice');


select * from country;
insert into tracks
(circle_lenght, number_of_circles, name, country_id)
values
(4.318,71,'Red Bull Ring',15),
(5.543, 67, 'Silverstone Circuit', (SELECT id FROM country WHERE name = 'United Kingdom')),
(4.309, 53, 'Circuit de Barcelona-Catalunya', (SELECT id FROM country WHERE name = 'Spain')),
(3.337, 66, 'Circuit Zandvoort', (SELECT id FROM country WHERE name = 'Netherlands')),
(7.004, 44, 'Monza Circuit', (SELECT id FROM country WHERE name = 'Italy')),
(4.309, 53, 'Sochi Autodrom', (SELECT id FROM country WHERE name = 'Russia')),
(5.891, 56, 'Circuit Gilles Villeneuve', (SELECT id FROM country WHERE name = 'Canada')),
(4.574, 66, 'Hockenheimring', (SELECT id FROM country WHERE name = 'Germany')),
(5.412, 57, 'Yas Marina Circuit', (SELECT id FROM country WHERE name = 'United Arab Emirates'));

select * from tracks;

insert into weather
(status)
values
('Rain'),
('Sunny');

select * from car_engine_manufactorer;
insert into car_engine_manufactorer
(related_team_id, name)
values
((select id from teams where name='Scuderia Ferrari'), (select name from teams where name='Scuderia Ferrari')),
((select id from teams where name='Mercedes-AMG Petronas F1 Team'), (select name from teams where name='Mercedes-AMG Petronas F1 Team')),
(null, 'Honda'),
(null, 'Renault');




select * from teams;
ALTER TABLE car RENAME TO cars;
insert into cars
(engine_supplier_id, name)
values
((select id from car_engine_manufactorer where name='Scuderia Ferrari'), 'VF-20'),
((select id from car_engine_manufactorer where name='Scuderia Ferrari'), 'SF1000'),
((select id from car_engine_manufactorer where name='Honda'), 'RB16'),
((select id from car_engine_manufactorer where name='Renault'), 'MCL35'),
((select id from car_engine_manufactorer where name='Mercedes-AMG Petronas F1 Team'), 'W11 EQ Performance'),
((select id from car_engine_manufactorer where name='Honda'), 'AT01'),
((select id from car_engine_manufactorer where name='Mercedes-AMG Petronas F1 Team'), 'FW43'),
((select id from car_engine_manufactorer where name='Mercedes-AMG Petronas F1 Team'), 'RP20'),
((select id from car_engine_manufactorer where name='Scuderia Ferrari'), 'C39');

select * from pilots;
insert into pilots_statistic
(wins, wdc, points, fastest_laps, pilot_id)
values
(103,7,4639.5,65,(select id from pilots where second_name='Hamilton')),
(10,0,1797,19,(select id from pilots where second_name='Bottas')),
(54,3,2586.5,30,(select id from pilots where second_name='Verstappen')),
(53,4,3098,38,(select id from pilots where second_name='Vettel')),
(5,0,1074,7,(select id from pilots where second_name='Leclerc')),
(6,0,1486,11,(select id from pilots where second_name='Perez')),
(8,0,1317,16,(select id from pilots where second_name='Ricciardo')),
(2,0,982.5,3,(select id from pilots where second_name='Sainz')),
(0,0,228,0,(select id from pilots where second_name='Albon')),
(1,0,394,3,(select id from pilots where second_name='Gasly')),
(0,0,633,6,(select id from pilots where second_name='Norris')),
(21,1,1873,46,(select id from pilots where second_name='Raikkonen')),
(0,0,530,2,(select id from pilots where second_name='Hulkenberg')),
(0,0,268,0,(select id from pilots where second_name='Stroll')),
(1,0,422,0,(select id from pilots where second_name='Ocon')),
(0,0,186,2,(select id from pilots where second_name='Magnussen')),
(0,0,391,1,(select id from pilots where second_name='Grosjean')),
(0,0,21,0,(select id from pilots where second_name='Giovinazzi')),
(0,0,9,0,(select id from pilots where second_name='Latifi')),
(1,0,469,6,(select id from pilots where second_name='Russell'));

select * from tracks;
select * from races;
-- grand prix
insert into races
(track_id, race_date, weather_id, race_type_id, name)
values
((select id from tracks where name = 'Red Bull Ring'),'2020-07-05'::timestamp,
 (select id from weather where status = 'Sunny'),
 (select id from race_types where type = 'Grand Prix')
 ,'Austrian Grand Prix');
 
-- quali
--  ALTER TABLE reces column name drop not null; 
 select * from race_types;
insert into races
(track_id, race_date, weather_id, race_type_id, name)
values
((select id from tracks where name = 'Red Bull Ring'),'2020-07-04'::timestamp,
 (select id from weather where status = 'Sunny'),
 (select id from race_types where type = 'Qualifying')
 ,'Austrian Grand Prix Qualifying');


-- practice
 select * from race_types;
insert into races
(track_id, race_date, weather_id, race_type_id, name)
values
((select id from tracks where name = 'Red Bull Ring'),'2020-07-03'::timestamp,
 (select id from weather where status = 'Sunny'),
 (select id from race_types where type = 'Practice')
 ,'Austrian Grand Prix Practice');

select * from seasons;
insert into race_weeks
(valid_from, valid_till, grand_prix_id, quali_id, sprint_id,season_id)
values
(
	'2020-07-01'::timestamp,
	'2020-07-05'::timestamp,
	(select id from races where name = 'Austrian Grand Prix' and race_type_id=1),
	(select id from races where name = 'Austrian Grand Prix Qualifying' and race_type_id=2),
	null,
	1
);

select * from cars;
select * from teams;
insert into team_car
(team_id, car_id, season_id)
values
((select id from teams where name = 'Scuderia Ferrari'),(select id from cars where name = 'SF1000'),1),
((select id from teams where name = 'Mercedes-AMG Petronas F1 Team'),(select id from cars where name = 'W11 EQ Performance'),1),
((select id from teams where name = 'McLaren F1 Team'),(select id from cars where name = 'MCL35'),1),
((select id from teams where name = 'Red Bull Racing'),(select id from cars where name = 'RB16'),1),
((select id from teams where name = 'Haas F1 Team'),(select id from cars where name = 'VF-20'),1),
((select id from teams where name = 'Alpine F1 Team'),(select id from cars where name = 'SF1000'),1),
((select id from teams where name = 'Scuderia AlphaTauri'),(select id from cars where name = 'AT01'),1),
((select id from teams where name = 'Alfa Romeo Racing'),(select id from cars where name = 'C39'),1),
((select id from teams where name = 'Williams Racing'),(select id from cars where name = 'FW43'),1),
((select id from teams where name = 'Racing Point'),(select id from cars where name = 'RP20'),1);

select * from sponsors;
insert into team_sponsor
(team_id, sponsor_id, valid_from,valid_to)
values
(
	(select id from teams where name = 'Scuderia Ferrari'),
	(select id from sponsors where name = 'Puma'),
	'2015-07-03'::timestamp,
	'2023-12-30'::timestamp
),
(
	(select id from teams where name = 'Scuderia Ferrari'),
	(select id from sponsors where name = 'Shell'),
	'2015-07-03'::timestamp,
	'2023-12-30'::timestamp
);


CALL insert_pilots_numbers_by_name_and_year(44, 'Hamilton', 2020);
CALL insert_pilots_numbers_by_name_and_year(77, 'Bottas', 2020);
CALL insert_pilots_numbers_by_name_and_year(33, 'Verstappen', 2020);
CALL insert_pilots_numbers_by_name_and_year(5, 'Vettel', 2020);
CALL insert_pilots_numbers_by_name_and_year(16, 'Leclerc', 2020);
CALL insert_pilots_numbers_by_name_and_year(11, 'Perez', 2020);
CALL insert_pilots_numbers_by_name_and_year(3, 'Ricciardo', 2020);
CALL insert_pilots_numbers_by_name_and_year(55, 'Sainz', 2020);
CALL insert_pilots_numbers_by_name_and_year(23, 'Albon', 2020);
CALL insert_pilots_numbers_by_name_and_year(10, 'Gasly', 2020);
CALL insert_pilots_numbers_by_name_and_year(4, 'Norris', 2020);
CALL insert_pilots_numbers_by_name_and_year(7, 'Raikkonen', 2020);
CALL insert_pilots_numbers_by_name_and_year(27, 'Hulkenberg', 2020);
CALL insert_pilots_numbers_by_name_and_year(18, 'Stroll', 2020);
CALL insert_pilots_numbers_by_name_and_year(31, 'Ocon', 2020);
CALL insert_pilots_numbers_by_name_and_year(20, 'Magnussen', 2020);
CALL insert_pilots_numbers_by_name_and_year(8, 'Grosjean', 2020);
CALL insert_pilots_numbers_by_name_and_year(99, 'Giovinazzi', 2020);
CALL insert_pilots_numbers_by_name_and_year(6, 'Latifi', 2020);
CALL insert_pilots_numbers_by_name_and_year(63, 'Russell', 2020);

call add_pilot('Nico', 'Rosberg', null, 10);
call insert_pilots_numbers_by_name_and_year(6, 'Rosberg', 2016);
call insert_pilots_statistic(23,1,1594.5, 20, 'Nico','Rosberg');


select * from pilots_statistic
select * from pilots








