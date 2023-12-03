create table country(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	name VARCHAR(256) NOT NULL UNIQUE
);

create table seasons(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	season_year INT NOT NULL UNIQUE
);

create table weather(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	status VARCHAR(64) NOT NULL UNIQUE
	
);


create table pilots(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	first_name VARCHAR(30) NOT NULL,
	second_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30),
	country_id INT NOT NULL,
	pilots_number INT NOT NULL UNIQUE CHECK(pilots_number > 0 AND pilots_number < 100),
	
	constraint  fk_pilots_countries foreign key (country_id) references country(id)
); 

-- drop table pilots;


create table nicknames(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	nickname VARCHAR(256) NOT NULL UNIQUE,
	pilot_id INT NOT NULL,
	
	constraint  fk_nicknames_pilots foreign key (pilot_id) references pilots(id)

);

-- drop table nicknames;

create table pilots_records(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	description VARCHAR(2048) NOT NULL,
	pilot_id INT NOT NULL,
	
	constraint  fk_pilots_records_pilots foreign key (pilot_id) references pilots(id)
);

-- drop table pilots_records;


create table pilots_statistic(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	wins INT NOT NULL,
	wdc INT NOT NULL,
	points INT NOT NULL,
	fastest_laps INT NOT NULL,	
	pilot_id INT NOT NULL,
	
	constraint  fk_pilots_statistic_pilots foreign key (pilot_id) references pilots(id)
);

-- drop table pilots_statistic;

create table teams(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	country_id INT NOT NULL,
	name VARCHAR(512) NOT NULL UNIQUE,
	
	constraint  fk_teams_countries foreign key (country_id) references country(id)
);

create table teams_statistic(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	wcc INT NOT NULL,
	team_id INT NOT NULL,
	
	constraint  fk_teams_statistic_teams foreign key (team_id) references teams(id)
);


create table teams_pilots(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	team_id INT NOT NULL,
	pilot_id INT NOT NULL,
	valid_from TIMESTAMP NOT NULL,
	valid_to TIMESTAMP NOT NULL,
	
	constraint  fk_teams_pilots_pilots foreign key (pilot_id) references pilots(id),
	constraint  fk_teams_pilots_teams foreign key (team_id) references teams(id)
);

create table sponsors(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	name VARCHAR(512) NOT NULL UNIQUE
);

create table team_sponsor(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	team_id INT NOT NULL,
	sponsor_id INT NOT NULL,
	valid_from TIMESTAMP NOT NULL,
	valid_to TIMESTAMP NOT NULL,
	
	constraint  fk_team_sponsor_sponsors foreign key (sponsor_id) references sponsors(id),
	constraint  fk_team_sponsor_teams foreign key (team_id) references teams(id)
);

create table principals(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	first_name VARCHAR(64) NOT NULL,
	second_name VARCHAR(64) NOT NULL,
	country_id INT NOT NULL,
	
	constraint  fk_principals_countries foreign key (country_id) references country(id)
);

create table team_principal(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	team_id INT NOT NULL,
	principal_id INT NOT NULL,
	valid_from TIMESTAMP NOT NULL,
	valid_to TIMESTAMP NOT NULL,
	
	constraint  fk_team_principal_sponsors foreign key (principal_id) references principals(id),
	constraint  fk_team_principal_teams foreign key (team_id) references teams(id)
);

create table car_engine_manufactorer(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	related_team_id INT,
	name VARCHAR(512) NOT NULL UNIQUE,
	
	constraint  fk_car_engine_manufactorer_teams foreign key (related_team_id) references teams(id)
);

create table car(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	engine_supplier_id INT NOT NULL,
	name VARCHAR(128),
	
	constraint  fk_car_car_engine_manufactorer foreign key (engine_supplier_id) references car_engine_manufactorer(id)
);


create table team_car(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	team_id INT NOT NULL,
	car_id INT NOT NULL,
	season_id INT NOT NULL,
	
	constraint  fk_team_car_car foreign key (car_id) references car(id),
	constraint  fk_team_car_season foreign key (season_id) references seasons(id),
	constraint  fk_team_car_teams foreign key (team_id) references teams(id)
);

create table race_types(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	type VARCHAR(64) NOT NULL UNIQUE
);

-- drop table race_type;

create table tracks(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	circle_lenght DECIMAL NOT NULL,
	number_of_circles INT NOT NULL,
	name VARCHAR(256) NOT NULL UNIQUE,
	country_id INT NOT NULL,
	
	constraint  fk_track_countries foreign key (country_id) references country(id)
);

create table track_records(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	track_id INT NOT NULL,
	description text NOT NULL,
	
	constraint fk_track_records_tracks foreign key(track_id) references tracks(id)

);

-- drop table track;


create table races(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	track_id INT NOT NULL,
	race_date TIMESTAMP NOT NULL,
	weather_id INT NOT NULL,
	race_type_id INT NOT NULL,
	name VARCHAR(256) NOT NULL UNIQUE,
	
	constraint  fk_races_tracks foreign key (track_id) references tracks(id),
	constraint  fk_races_weather foreign key (weather_id) references weather(id),
	constraint  fk_races_race_types foreign key (race_type_id) references race_types(id)
);

create table race_starting_grids(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	race_id INT NOT NULL,
	team_pilot_id INT NOT NULL,
	place INT NOT NULL,
	
	constraint  fk_race_starting_grids_races foreign key (race_id) references races(id),
	constraint fk_race_starting_grids_team_pilot foreign key (team_pilot_id) references teams_pilots(id)
	
);

create table race_participants_results(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	race_id INT NOT NULL,
	team_pilot_id INT NOT NULL,
	place INT NOT NULL,
	lap_time VARCHAR(32),
	
	constraint  fk_race_participants_results_races foreign key (race_id) references races(id),
	constraint fk_race_participants_results_pilot foreign key (team_pilot_id) references teams_pilots(id)
);


create table documents(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	fact text NOT NULL, -- can be replaced with table document_type
	decision text not NULL,
	reason text NOT NULL
);

create table race_participants_documents(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	race_id INT NOT NULL,
	team_pilot_id INT NOT NULL,
	document_id INT NOT NULL,
	document_date TIMESTAMP,
	
	
	constraint  fk_race_participants_documents_races foreign key (race_id) references races(id),
	constraint  fk_race_participants_documents_documents foreign key (document_id) references documents(id),
	constraint fk_race_participants_documents_pilot foreign key (team_pilot_id) references teams_pilots(id)
);
	

create table race_weeks(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	
	valid_from TIMESTAMP,
	valid_till TIMESTAMP,
	grand_prix_id INT NOT NULL,
	quali_id INT NOT NULL,
	sprint_id INT,
	season_id INT NOT NULL,
	
	constraint  fk_race_weeks_grand_prix_races foreign key (grand_prix_id) references races(id),
	constraint  fk_race_weeks_quali_races foreign key (quali_id) references races(id),
	constraint  fk_race_weeks_sprint_races foreign key (sprint_id) references races(id),
	constraint  fk_race_weeks_seasons foreign key (season_id) references seasons(id)
);


CREATE TABLE logs (
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

    log_datetime TIMESTAMP DEFAULT current_timestamp,
    description TEXT NOT NULL
);