### 1. Заполнение таблиц

#### 1.1 Roles table
```SQL
INSERT INTO roles
(role_name)
VALUES('team_principal') RETURNING role_id;

INSERT INTO roles
(role_name)
VALUES('FIA') RETURNING role_id;
```

#### 1.2. Teams table
```SQL
INSERT INTO teams
(team_principal, budget, country, team_name)
VALUES
('Toto Wolff', 145000000, 'Germany', 'Mercedes AMG Petronas F1 Team'),
('Christian Horner', 145000000, 'United Kingdom', 'Oracle Red Bull Racing'),
('Zak Brown', 145000000, 'United Kingdom', 'McLaren F1 Team'),
('Mike Krack', 145000000, 'United Kingdom', 'Aston Martin Aramco Cognizant F1 Team'),
('Otmar Szafnauer', 145000000, 'United Kingdom', 'BWT Alpine F1 Team'),
('Mattia Binotto', 145000000, 'Italy', 'Scuderia Ferrari'),
('Jody Egginton', 145000000, 'Italy', 'Scuderia AlphaTauri'),
('Frédéric Vasseur', 145000000, 'Italy', 'Alfa Romeo F1 Team ORLEN'),
('Guenther Steiner', 145000000, 'USA', 'Haas F1 Team'),
('Jost Capito', 145000000, 'United Kingdom', 'Williams Racing');
```

#### 1.2. Tires table
```SQL
INSERT INTO tires
(tires_brand, tires_type)
VALUES
('Pirelli', 'Hard'),
('Pirelli', 'Soft'),
('Pirelli', 'Medium'),
('Pirelli', 'Intermediate'),
('Pirelli', 'Wet');
```

Решил добавить полную дистанцию гонки дополнительным параметром трека

```SQL
ALTER TABLE tracks ADD 
	race_distance_km DECIMAL;
```

#### 1.3. Tracks table
```SQL
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
```

#### 1.4. Sponsors table
```SQL
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
('Carrera');
```
