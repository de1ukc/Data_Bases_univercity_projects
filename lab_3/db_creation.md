### 1.Создание БД
<code> CREATE DATABASE f1_university_projects;</code>

### 2. Создание таблиц

#### 2.1 Tires table
<code>CREATE TABLE tires(
tires_type VARCHAR(30) UNIQUE NOT NULL,
tires_brand VARCHAR(30) UNIQUE NOT NULL,
PRIMARY KEY (tires_type, tires_brand)
);
</code>

#### 2.2 Track table
<code>CREATE TABLE Track(
	track_id int4 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	circle_length DECIMAL NOT NULL,
	number_of_circles INT NOT NULL,
	country VARCHAR(30) NOT NULL,
	importance_of_pole INT NOT NULL,
	name_of_track VARCHAR(30) UNIQUE NOT NULL
);</code>
