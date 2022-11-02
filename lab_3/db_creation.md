### 1.Создание БД
```SQL
CREATE DATABASE f1_university_projects;
```

### 2. Создание таблиц

#### 2.1. Tires table
```SQL
CREATE TABLE tires(
	tires_type VARCHAR(30) NOT NULL,
	tires_brand VARCHAR(30) NOT NULL,
	PRIMARY KEY (tires_type, tires_brand)
);
```


#### 2.2. Track table
```SQL
CREATE TABLE tracks(
	track_id int4 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	circle_length_km DECIMAL NOT NULL,
	number_of_circles INT NOT NULL,
	country VARCHAR(30) NOT NULL,
	name_of_track VARCHAR(30) UNIQUE NOT NULL
);
```

#### 2.3. Tires_on_Track table
```SQL
CREATE TABLE tires_on_track(
	tires_type VARCHAR(30) REFERENCES tires (tires_type) ON UPDATE CASCADE ON DELETE NO ACTION,
	tires_brand VARCHAR(30) REFERENCES tires (tires_type) ON UPDATE CASCADE ON DELETE NO ACTION,
	track_id INT REFERENCES Track (track_id) on UPDATE CASCADE ON DELETE NO ACTION,
	car_id INT NOT NULL,
	
	CONSTRAINT tires_on_track_pkey PRIMARY KEY (tires_type, tires_brand, track_id)
);
```

#### 2.4. Team table
```SQL
CREATE TABLE teams(
	team_id INT PRIMARY KEY  GENERATED ALWAYS AS IDENTITY,
	
	team_principal VARCHAR(30) NOT NULL,
	budget INT NOT NULL,
	country VARCHAR(30) NOT NULL,
	team_name VARCHAR(50) NOT NULL
);
```

#### 2.5. Role table
```SQL
CREATE TABLE roles(
	role_id INT PRIMARY KEY  GENERATED ALWAYS AS IDENTITY,
	
	role_name VARCHAR(30) DEFAULT 'team_pricipal'
);
```

#### 2.6. Users table
```SQL
CREATE TABLE users(
	user_id INT PRIMARY KEY  GENERATED ALWAYS AS IDENTITY,
	
	user_login VARCHAR(30) NOT NULL UNIQUE,
	user_password VARCHAR(30) NOT NULL,
	user_email VARCHAR(30) NOT NULL UNIQUE,
	
	team_id INT REFERENCES Teams (team_id) on Update CASCADE ON DELETE NO ACTION,
	role_id INT REFERENCES roles (role_id) on UPDATE CASCADE ON DELETE NO ACTION
	
-- 	CONSTRAINT fk_team FOREIGN KEY(team_id) REFERENCES teams(team_id) ? как лучше? его можно переиспользовать?
);

```

#### 2.7. Sponsors table
```SQL
CREATE TABLE sponsors(
	sponsor_id INT PRIMARY KEY  GENERATED ALWAYS AS IDENTITY,
	
	sponsor_name VARCHAR(30) NOT NULL UNIQUE
	
);
```

#### 2.8. Sponsors_and_Teams table
```SQL
CREATE TABLE sponsors_and_teams(
	sponsor_id INT REFERENCES sponsors(sponsor_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	team_id INT REFERENCES teams(team_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	
	CONSTRAINT sponsors_and_teams_pkey PRIMARY KEY (sponsor_id, team_id)
);
```

#### 2.9. Cars table
```SQL
CREATE TABLE cars(
	car_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	engine_by_team_id INT REFERENCES teams(team_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	-- cars_max_speed DECIMAL NOT NULL,
	team_id INT REFERENCES teams(team_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	-- cars_power INT NOT NULL CHECK(cars_power > 0 AND cars_power <= 100),
	cars_name VARCHAR(30) UNIQUE NOT NULL
);
```

#### 2.10. Pilots table

```SQL
CREATE TABLE pilots(
	pilot_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	first_name VARCHAR(30) NOT NULL,
	second_name VARCHAR(30) NOT NULL,
	surname_name VARCHAR(30) NOT NULL,
	nickname VARCHAR(30) NOT NULL UNIQUE,
	country VARCHAR(30) NOT NULL,
	pilots_number INT NOT NULL UNIQUE CHECK(pilots_number > 0 AND pilots_number < 100),
	height INT NOT NULL,
	weight DECIMAL NOT NULL,
	wdc INT NOT NULL DEFAULT 0,
	rating INT NOT NULL CHECK(rating > 0 AND rating <= 100),
	price INT NOT NULL,
	
	team_id INT REFERENCES teams(team_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	car_id INT REFERENCES cars(car_id) ON UPDATE CASCADE ON DELETE NO ACTION
);
```

#### 2.11. Grand_Prix table
```SQL
CREATE TABLE grand_prix(
	grand_prix_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	date_of_gran_prix DATE NOT NULL,
	weather VARCHAR(30),  -- если я не указал NOT NULL она ведь может быть NULL, да, энакин?
	track_name VARCHAR(30) NOT NULL UNIQUE,
	
	winner_id INT REFERENCES pilots(pilot_id) ON UPDATE CASCADE ON DELETE NO ACTION, -- оно ведь тоже NULLABLE???
	quali_winner_id INT REFERENCES pilots(pilot_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	track_id INT REFERENCES tracks(track_id) ON UPDATE CASCADE ON DELETE NO ACTION
	
);
```

#### 2.12. Logs table
```SQL
CREATE TABLE logs(
	log_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	date_of_log DATE NOT NULL,
	time_of_log TIME NOT NULL,
	log_message VARCHAR(200) NOT NULL
);
```



