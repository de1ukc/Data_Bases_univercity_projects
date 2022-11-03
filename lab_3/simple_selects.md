Простые стандартные запросы в БД

#### Пилоты, выигрывавшие WDC:

```SQL
SELECT * FROM pilots
	WHERE wdc > 0;
```

#### Спонсоры определённой команды
```SQL
SELECT sponsor_name FROM sponsors
	WHERE sponsor_id in ( 
	SELECT sponsor_id FROM sponsors_and_teams
		WHERE team_id = (SELECT team_id FROM teams
					WHERE team_name = 'Scuderia Ferrari'));
```

#### Достаём пилота, выйгравшего определённый Гран-При
```SQL
SELECT (pilots.first_name,  pilots.surname, pilots.second_name, pilots.nickname, pilots.pilots_number) FROM pilots
WHERE pilot_id in (SELECT winner_id FROM grand_prix
				  WHERE grand_prix_name = 'Bahrain Grand Prix');
```

#### Выбираем гран-при, которые начинаются с буквы 'A' и достаём их, начиная со второго

```SQL
SELECT * from grand_prix
	WHERE grand_prix_name LIKE 'A%'
	offset 1;
```
