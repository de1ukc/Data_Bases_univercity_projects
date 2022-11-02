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

