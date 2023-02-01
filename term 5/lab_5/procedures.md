## Процедуры.
По своей сути процедуры - почти что функции, которые созданы для хранения в бд и обеспечения удобства написания кода. 
Если в кратце, имеются свои плюсы и минусы хранимых SQL-процедур, в основном - минусы. Неудобно дебажить, старый язык написания, необходимо версионирование и поддержка, траблы с зависимостями и тд.


о написании процедур: https://postgrespro.ru/docs/postgresql/11/sql-createprocedure
о вреде хранимых процедур: https://habr.com/ru/company/ruvds/blog/517302/


#### 1. Процедура добавления болида:

```SQL
CREATE PROCEDURE insert_car(engine_by_team_id INT, team_id INT, cars_name VARCHAR)
LANGUAGE SQL
AS $$
INSERT INTO cars (engine_by_team_id, team_id, cars_name) 
VALUES (engine_by_team_id, team_id, cars_name) 
$$;
```

