#### Для дальнейшей работы с проектом были добавлены возможности не выбирать команду при регистрации.

```SQL
ALTER TABLE users
ALTER COLUMN team_id
SET DEFAULT null;
```

Автоматически назанчается роль босса команды:

```SQL
ALTER TABLE users
ALTER COLUMN role_id
SET DEFAULT 1;
```

Добавлено поле, отображающее, была ли команда взята пользователем:

```SQL
ALTER TABLE teams
ADD COLUMN is_taken BOOLEAN default false;
```

```SQL
ALTER TABLE pilots
ALTER COLUMN nickname SET DEFAULT null;

ALTER TABLE pilots
ALTER COLUMN surname SET DEFAULT null;
```

```SQL

CREATE TABLE ready(
id INT PRIMARY KEY  GENERATED ALWAYS AS IDENTITY,
ready BOOLEAN DEFAULT FALSE,
	
user_id INT REFERENCES users (user_id) on UPDATE CASCADE ON DELETE NO ACTION,
grand_prix_id INT REFERENCES grand_prix (grand_prix_id ) on UPDATE CASCADE ON DELETE NO ACTION
);
```
