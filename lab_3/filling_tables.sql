INSERT INTO roles
(role_name)
VALUES('FIA') RETURNING role_id;

INSERT INTO roles
(role_name)
VALUES('team_principal') RETURNING role_id;

INSERT INTO teams
(team_principal, budget, country, team_name)
VALUES
('Toto Wolff', 145000000, 'Germany', 'Mercedes AMG Petronas F1 Team'),
('Christian Horner', 145000000, 'Austria', 'Oracle Red Bull Racing'),
('Zak Brown', 145000000, 'United Kingdom', 'McLaren F1 Team'),
('Mike Krack', 145000000, 'United Kingdom', 'Aston Martin Aramco Cognizant F1 Team'),
('Otmar Szafnauer', 145000000, 'France', 'BWT Alpine F1 Team'),
('Mattia Binotto', 145000000, 'Italy', 'Scuderia Ferrari'),
('Jody Egginton', 145000000, 'Italy', 'Scuderia AlphaTauri'),
('Frédéric Vasseur', 145000000, 'Italy', 'Alfa Romeo F1 Team ORLEN'),
('Guenther Steiner', 145000000, 'USA', 'Haas F1 Team'),
('Jost Capito', 145000000, 'United Kingdom', 'Williams Racing');

INSERT INTO tires
(tires_brand, tires_type)
VALUES
('Pirelli', 'Hard'),
('Pirelli', 'Soft'),
('Pirelli', 'Medium'),
('Pirelli', 'Intermediate'),
('Pirelli', 'Wet');

ALTER TABLE tracks ADD 
	race_distance_km DECIMAL;


INSERT INTO tracks
(circle_length_km, number_of_circles, country, name_of_track, race_distance_km)
VALUES
(5.412, 57, 'Bahrain', 'Bahrain International Circuit', 308.238),
(4.909, 63, 'Italy', 'Imola', 309.267),
(4.653, 66, 'Portugal', 'Autodromo do Algarve', 307.098),
(4.675, 66, 'Spain', 'Circuit de Catalunya', 308.55),
(3.337, 78, 'Monaco', 'Monaco', 260.286),
(6.003, 51, 'Azerbaijan', 'Baku City Circuit', 306.051),
(5.842, 53, 'France', 'Paul Ricard', 309.0626),
(4.326, 71, 'Austria', 'Red Bull Ring', 307.02),
(5.891, 52, 'United Kingdom', 'Silverstone', 306.332),
(4.381, 70, 'Hungary', 'Hungaroring', 306.67),
(7.004, 44, 'Belgium', 'Spa-Francorchamps', 308.052),
(4.259, 72, 'Netherlands', 'Zandvoort', 306.648),
(5.793, 53, 'Italy', 'Autodromo Nazionale Monza', 306.72),
(5.848, 53, 'Russia', 'Sochi Autodrom', 309.745),
(5.338, 58, 'Turkey', 'Istanbul Park', 309.396),
(5.513, 56, 'USA', 'Circuit of the Americas', 308.728),
(4.304, 71, 'Mexico', 'Autodromo Hermanos Rodriguez', 305.354),
(4.309, 71, 'Brazil', 'Interlagos', 305.909),
(5.4, 57, 'Qatar', 'Losail International Circuit', 307.8),
(6.174, 50, 'Saudi Arabia', 'Jeddah Corniche Circuit', 308.7),
(5.554, 55, 'United Arab Emirates', 'Yas Marina', 305.355);

INSERT INTO sponsors
(sponsor_name)
VALUES
('Orlen'),
('BWT'),
('Cognizant'),
('Aramco'),
('Mission Winnow'),
('Shell'),
('Ray-Ban'),
('Kaspersky Lab'),
('HUBLOT'),
('Pirelli'),
('Uralkali'),
('Under Armour'),
('BAT'),
('Renault'),
('Coca-Cola'),
(' Dell Technologies'),
(' Logitech'),
('AMD'),
('Tommy Hilfiger'),
('TeamViewer'),
('IWC Schaffhausen'),
('Epson'),
('Acronis'),
('Lavazza'),
('Bremont'),
('Carrera'),
('Microsoft');


INSERT INTO cars
(engine_by_team_id, team_id, cars_name)
VALUES
(1,1,'Mercedes-AMG F1 W12 E Performance'),
(2,2,'Red Bull Racing RB16'),
(1,4,'Aston Martin AMR21'),
(6,6,'Ferrari SF21'),
(2,7,'AlphaTauri AT02'),
(6,8,'Alfa Romeo Racing C41'),
(6,9,'Haas VF-21'),
(1,10,'Williams FW43'),
(5,5,'Alpine A521'),
(1,3,'McLaren MCL35');

INSERT INTO pilots
	(first_name, surname,second_name, nickname, country, pilots_number,
	wdc, rating, team_id, car_id, points)
VALUES
('Kimi', 'Matias','Räikkönen', 'The Iceman', 'Finland', 7, 1, 87, 8, 6, 1873),
('Antonio', 'Maria','Giovinazzi', NULL , 'Italy', 99, 0, 81, 8, 6, 21),
('Pierre', NULL,'Gasly', NULL, 'France', 10, 0, 88, 7, 5, 332),
('Yuki', NULL,'Tsunoda', NULL, 'Japan', 22, 0, 77, 7, 5, 44),
('Fernando', 'Díaz','Alonso', 'El Nano', 'Spain', 14, 2, 89, 5, 9, 2051),
('Esteban', 'José Jean-Pierre','Ocon', 'Teflonso', 'Spain', 31, 0, 83, 5, 9, 354),
('Sebastian', NULL, 'Vettel', 'The Finger', 'Germany', 5, 4, 90, 4, 3, 3097),
('Lance', NULL, 'Stroll', NULL, 'Canada', 18, 0, 82, 4, 3, 189),
('Charles', 'Marc Hervé Perceval', 'Leclerc', NULL, 'Monaco', 16, 0, 89, 6, 4, 835),
('Carlos', 'Vázquez de Castro', 'Sainz', NULL, 'Spain', 55, 0, 89, 6, 4, 748),
('Nikita', 'Dmitryevich ', 'Mazepin', 'Mazespin', 'Russia', 9, 0, 67, 9, 7, 0),
('Mick', NULL, 'Schumacher', NULL, 'Germany', 47, 0, 79, 9, 7, 12),
('Daniel', 'Joseph', 'Ricciardo', 'The Honey Badger', 'Australia', 3, 0, 89, 3, 10, 1309),
('Lando', NULL, 'Norris', NULL, 'United Kingdom', 4, 0, 89, 3, 10, 417),
('Lewis', 'Carl Davidson', 'Hamilton', 'Billion Dollar Man', 'United Kingdom', 44, 7, 94, 1, 1, 4381),
('Valtteri', 'Viktor', 'Bottas', 'Robottas', 'Finland', 77, 0, 90, 1, 1, 1785),
('Sergio', 'Michel', 'Pérez', 'Checo', 'Mexico', 11, 0, 87, 2, 2, 1176),
('Max', 'Emilian', 'Verstappen', 'Mad Max', 'Netherlands', 33, 0, 93, 2, 2, 1973),
('Nicholas', 'Daniel', 'Latifi', 'Goatifi', 'Canada', 6, 0, 72, 10, 8, 9),
('George', 'William', 'Russell', 'Mr. Saturday', 'United Kingdom', 63, 0, 82, 10, 8, 250);


INSERT INTO grand_prix
(grand_prix_name, date_of_gran_prix, track_id, weather, quali_winner_id, winner_id)
VALUES
('Bahrain Grand Prix','2021-03-28', 1, NULL,32, 29),
('Emilia-Romagna Grand Prix','2021-04-18', 2, NULL,29, 32),
('Portuguese Grand Prix','2021-05-02', 3, NULL,30, 29),
('Spanish Grand Prix','2021-05-09', 4, NULL,29, 29),
('Monaco Grand Prix','2021-05-23', 5, NULL,23, 32),
('Azerbaijan Grand Prix','2021-06-06', 6, NULL,23, 31),
('French Grand Prix','2021-06-20', 7, NULL,32, 32),
('Styrian Grand Prix','2021-06-27', 8, NULL,32, 32),
('Austrian Grand Prix','2021-07-04', 8, NULL,32, 32),
('British Grand Prix','2021-07-18', 9, NULL,29, 29),
('Hungarian Grand Prix','2021-08-01', 10, NULL,29, 20),
('Belgian Grand Prix','2021-08-29', 11, NULL,32, 32),
('Dutch Grand Prix','2021-09-05', 12, NULL,32, 32),
('Italian Grand Prix','2021-09-12', 13, NULL,30, 27),
('Russian Grand Prix','2021-09-26', 14, NULL,28, 29),
('Turkish Grand Prix','2021-10-10', 15, NULL,29, 30),
('United States Grand Prix','2021-10-24', 16, NULL,32, 32),
('Mexico City Grand Prix','2021-11-07', 17, NULL,30, 32),
('Sao Paulo Grand Prix','2021-11-14', 18, NULL,29, 29),
('Qatari Grand Prix','2021-11-21', 19, NULL,29, 29),
('Saudi Arabian Grand Prix','2021-12-05', 20, NULL,29, 29),
('Abu Dhabi Grand Prix','2021-12-12', 21, NULL,32, 32);



-- ('Bahrain Grand Prix','2021-03-28', 1, NULL, NULL, NULL),
-- ('Emilia-Romagna Grand Prix','2021-04-18', 2, NULL, NULL, NULL),
-- ('Portuguese Grand Prix','2021-05-02', 3, NULL, NULL, NULL),
-- ('Spanish Grand Prix','2021-05-09', 4, NULL, NULL, NULL),
-- ('Monaco Grand Prix','2021-05-23', 5, NULL, NULL, NULL),
-- ('Azerbaijan Grand Prix','2021-06-06', 6, NULL, NULL, NULL),
-- ('French Grand Prix','2021-06-20', 7, NULL, NULL, NULL),
-- ('Styrian Grand Prix','2021-06-27', 8, NULL, NULL, NULL),
-- ('Austrian Grand Prix','2021-07-04', 8, NULL, NULL, NULL),
-- ('British Grand Prix','2021-07-18', 9, NULL, NULL, NULL),
-- ('Hungarian Grand Prix','2021-08-01', 10, NULL, NULL, NULL),
-- ('Belgian Grand Prix','2021-08-29', 11, NULL, NULL, NULL),
-- ('Dutch Grand Prix','2021-09-05', 12, NULL, NULL, NULL),
-- ('Italian Grand Prix','2021-09-12', 13, NULL, NULL, NULL),
-- ('Russian Grand Prix','2021-09-26', 14, NULL, NULL, NULL),
-- ('Turkish Grand Prix','2021-10-10', 15, NULL, NULL, NULL),
-- ('United States Grand Prix','2021-10-24', 16, NULL, NULL, NULL),
-- ('Mexico City Grand Prix','2021-11-07', 17, NULL, NULL, NULL),
-- ('Sao Paulo Grand Prix','2021-11-14', 18, NULL, NULL, NULL),
-- ('Qatari Grand Prix','2021-11-21', 19, NULL, NULL, NULL),
-- ('Saudi Arabian Grand Prix','2021-12-05', 20, NULL, NULL, NULL),
-- ('Abu Dhabi Grand Prix','2021-12-12', 21, NULL, NULL, NULL);


INSERT INTO  sponsors_and_teams
(sponsor_id, team_id)
VALUES
(1,8),
(26,8),
(10,8),
(10,7),
(10,5),
(2,5),
(27,5),
(10,4),
(3,4),
(4,4),
(10,1),
(19,1),
(20,1),
(22,1),
(18,1),
(10,2),
(28,2),
(29,2),
(30,2),
(31,2),
(10,3),
(16,3),
(13,3),
(17,3),
(10,6),
(5,6),
(6,6),
(7,6),
(8,6),
(9,6),
(10,9),
(12,9),
(11,9),
(10,10),
(23,10),
(24,10),
(25,10);





