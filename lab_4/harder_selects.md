### 1.Запрос с несколькими условиями

#### 1.1 Пилот, у которого есть чемпионство и он из команды Мерседес:
```SQL
SELECT * FROM pilots
	WHERE wdc > 1 AND team_id = 1;
```

#### 1.2. Спонсоры определённой команды:
```
SELECT sponsor_name FROM sponsors
	WHERE sponsor_id in ( 
	SELECT sponsor_id FROM sponsors_and_teams
		WHERE team_id = (SELECT team_id FROM teams
					WHERE team_name = 'Scuderia Ferrari'));
```

### 2. Запросы с GROUP BY:

#### 2.1. Имена трасс, с длиной круга больше 4км и количесвом кругов больше 60
```SQL
SELECT name_of_track FROM tracks
	WHERE circle_length_km > 4.0 AND number_of_circles > 60
	GROUP BY name_of_track;
```

#### 2.2. Группировка столбцов при помощи WHERE и HAVING

```SQL
SELECT circle_length_km, number_of_circles, name_of_track  FROM tracks
	WHERE circle_length_km > 4.0 AND number_of_circles > 55
	GROUP BY number_of_circles, name_of_track,circle_length_km;
```

```SQL
SELECT circle_length_km, number_of_circles, name_of_track  FROM tracks 
	GROUP BY  number_of_circles,name_of_track, circle_length_km  
	HAVING circle_length_km > 4.0 AND number_of_circles > 55;
```
