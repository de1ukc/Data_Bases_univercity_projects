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
