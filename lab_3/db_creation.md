### 1.Создание БД
```SQL
CREATE DATABASE f1_university_projects;
```

### 2. Создание таблиц

#### 2.1 Tires table
```SQL
CREATE TABLE tires(
	tires_type VARCHAR(30) UNIQUE NOT NULL,
	tires_brand VARCHAR(30) UNIQUE NOT NULL,
	PRIMARY KEY (tires_type, tires_brand)
);
```


#### 2.2 Track table
```SQL
CREATE TABLE track(
	track_id int4 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	circle_length DECIMAL NOT NULL,
	number_of_circles INT NOT NULL,
	country VARCHAR(30) NOT NULL,
	importance_of_pole INT NOT NULL,
	name_of_track VARCHAR(30) UNIQUE NOT NULL
);
```

#### 2.3 Tires_on_Track table
```SQL
CREATE TABLE tires_on_track(
	tires_type VARCHAR(30) REFERENCES tires (tires_type) ON UPDATE CASCADE ON DELETE NO ACTION,
	tires_brand VARCHAR(30) REFERENCES tires (tires_type) ON UPDATE CASCADE ON DELETE NO ACTION,
	track_id INT REFERENCES Track (track_id) on UPDATE CASCADE ON DELETE NO ACTION,
	car_id INT NOT NULL,
	
	CONSTRAINT tires_on_track_pkey PRIMARY KEY (tires_type, tires_brand, track_id)
);
```
#### 2.4 Grand_Prix table
```SQL
CREATE TABLE grand_prix(
	grand_prix_id INT PRIMARY KEY ALWAYS GENERATED AS IDENTITY,
	track_id REFERENCES track (track_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	date_of_gran_prix DATE,
	winner_id REFERENCES pilot (pilot_id) NULLABLE ON UPDATE CASCADE ON DELETE NO ACTION,
	quali_winner_id REFERENCES pilot (pilot_id) NULLABLE ON UPDATE CASCADE ON DELETE NO ACTION,
	weather VARCHAR(30) NULLABLE,
	track_name VARCHAR(30) NOT NULL UNIQUE
);
```

```SQL```

```SQL```

```SQL```

```SQL```

```SQL```

```SQL```

```SQL```

```SQL```

