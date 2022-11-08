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


### 3. Views и JOIN-запросы различных видов (INNER, OUTER, FULL, CROSS, SELF):

Inner Join объединяет строки из дух таблиц при соответствии условию. Если одна из таблиц содержит строки, которые не соответствуют этому условию, то данные строки не включаются в выходную выборку. Left  Join выбирает все строки первой таблицы и затем присоединяет к ним строки правой таблицы. Если строки не соответствуют условию, то строки из левой таблицы вставляются, а остальные - NULL

Полное соединение (FULL JOIN) объединяет обе таблицы

Если требуется добавить какие-то условия после объединения, делаем так:

```SQL
SELECT Customers.FirstName, Orders.CreatedAt, 
       Products.ProductName, Products.Company
FROM Orders 
LEFT JOIN Customers ON Orders.CustomerId = Customers.Id
LEFT JOIN Products ON Orders.ProductId = Products.Id
WHERE Products.Price > 55000
ORDER BY Orders.CreatedAt;
```

можно комбинировать Inner Join и Outer Join:
```SQL
SELECT Customers.FirstName, Orders.CreatedAt, 
       Products.ProductName, Products.Company
FROM Orders 
JOIN Products ON Orders.ProductId = Products.Id AND Products.Price > 45000
LEFT JOIN Customers ON Orders.CustomerId = Customers.Id
ORDER BY Orders.CreatedAt;
```

Вначале по условию к таблице Orders через Inner Join присоединяется связанная информация из Products, затем через Outer Join добавляется информация из таблицы Customers.

Cross Join или перекрестное соединение создает набор строк, где каждая строка из одной таблицы соединяется с каждой строкой из второй таблицы. 

Если в таблице Orders 3 строки, а в таблице Customers то же три строки, то в результате перекрестного соединения создается 3 * 3 = 9 строк вне зависимости, связаны ли данные строки или нет.

При неявном перекрестном соединении можно опустить оператор CROSS JOIN и просто перечислить все получаемые таблицы:
```SQL
SELECT * FROM Orders, Customers;
```

#### 3.1. INNER JOIN

Найдём всех пилотов и их машины, которые выигрывали в этом сезоне

```SQL
SELECT pilots.first_name, pilots.second_name, cars.cars_name, grand_prix.grand_prix_name
FROM pilots
JOIN cars ON cars.car_id = pilots.car_id
JOIN grand_prix ON grand_prix.winner_id = pilots.pilot_id
ORDER BY pilots.wdc;
```
Если здесь заменить INNER JOIN на OUTER JOIN, то будут выведены абсолютно все пилоты сезона, а в столбце Гран-При будет null у тех пилотов, кто не выигрывал в сезоне.

#### 3.2. FULL + INNER JOIN (достаём спонсоров каждой команды по алфавиту(команды))
```SQL
SELECT teams.team_name, teams.team_principal, teams.country, sponsors.sponsor_name
FROM teams 
FULL JOIN sponsors_and_teams ON sponsors_and_teams.team_id = teams.team_id
JOIN sponsors ON sponsors.sponsor_id = sponsors_and_teams.sponsor_id
ORDER BY teams.team_name;
```
#### 3.3. OUTER JOIN (Достаём всех пилотов и приклеиваем название команды)
```SQL
SELECT pilots.first_name, pilots.nickname, pilots.second_name, teams.team_name, 
pilots.pilots_number, pilots.country, pilots.points, pilots.rating, pilots.wdc
FROM pilots LEFT JOIN teams ON teams.team_id = pilots.team_id;
```

### 4. Union объекдинения:

Оператор UNION позволяет объединить два множества (условно две таблицы). Но в отличие от inner/outer join объединения соединяют не столбцы разных таблиц, а два однотипных набора в один. Формальный синтаксис объединения:

```SQL
SELECT_выражение1
UNION [ALL] SELECT_выражение2
[UNION [ALL] SELECT_выражениеN]
```

Для такого объединенения нужны столбцы одного типа, а желательно и с таким же названием.

Если оба объединяемых набора содержат в строках идентичные значения, то при объединении повторяющиеся строки удаляются. 
Если же необходимо при объединении сохранить все, в том числе повторяющиеся строки, то для этого необходимо использовать оператор ALL

При этом(и для UNION ALL SELECT, и для UNION SELECT) названия столбцов объединенной выборки будут совпадать с названия столбцов первой выборки. И если мы захотим при этом еще произвести сортировку, то в выражениях ORDER BY необходимо ориентироваться именно на названия столбцов первой выборки.

Если же в одной выборке больше столбцов, чем в другой, то они не смогут быть объединены.

Также соответствующие столбцы должны соответствовать по типу.

#### 4.1. Объединение никнеймов пользователей и пилотов

```SQL
SELECT pilots.nickname
FROM pilots WHERE pilots.nickname IS NOT NULL
UNION SELECT  users.user_login FROM users;
```


### Прикольные штуки:

#### Разность множеств
Оператор EXCEPT в PostgreSQL позволяет найти разность двух выборок, то есть те строки которые есть в первой выборке, но которых нет во второй. Для его использования применяется следующий формальный синтаксис:

```SQL
SELECT _выражение1
EXCEPT SELECT _выражение2
```

#### Пересечение множеств

Оператор INTERSECT позволяет найти общие строки для двух выборок, то есть данный оператор выполняет операцию пересечения множеств.

```SQL
SELECT _выражение1
INTERSECT SELECT _выражение2
```

