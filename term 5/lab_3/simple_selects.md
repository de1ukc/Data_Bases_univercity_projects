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

#### Небольшая напоминалка
```SQL
Запросы (  <> -- не равно
			= -- равно)

SELECT DISTINCT col_name FROM table_name; -- выборка уникальных значений
SELECT * FROM table_name ORDER BY col_name; -- выборка с сортировкой по значению (ASC/DESC - по возрастанию, по убыванию)
SELECT col_1, col_2, col_3 FROM table_name ORDER BY col_1 ASC, col_2 DESC;
SELECT col_1, num_2 * num_3 AS total_num FROM table_name ORDER BY total_num; -- можно еще так через псевдонимы 
SELECT * FROM Products ORDER BY ProductName LIMIT 4 OFFSET 2; -- ограничение на вывод (LIMIT - сколько, OFFSET - начиная откуда)
---
SELECT * FROM table_name WHERE col_name IN (val1, val2, val3); -- проверка на вхождение в сет
SELECT * FROM table_name WHERE col_name BETWEEN something AND something; -- проверка на границы 
SELECT * FROM table_name WHERE col_name LIKE шаблон; -- проверка строк по шаблону '%' - любая подстрока ('aboba%' == 'aboba bobs boba')
								--	'_' - символ ('aboba_' == 'abobas') 

SELECT * FROM table1, table2 WHERE table2.fk_table1 = table1.fk_table2; -- выборка через форенкеи
SELECT tab1.col1, tab1.col2, tab2.col3 FROM tab1 JOIN tab2 ON tab2.Id = tab1.fk; -- или так
```
