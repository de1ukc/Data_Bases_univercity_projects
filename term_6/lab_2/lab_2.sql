-- создаём табличку студентов
CREATE TABLE STUDENTS
(
    ID       NUMBER,
    NAME     VARCHAR2(100) NOT NULL,
    GROUP_ID NUMBER        NOT NULL,

    CONSTRAINT students_pk PRIMARY KEY (ID)

);

-- автоинкремент для студентов
CREATE SEQUENCE students_sequence
    start with 1
    increment by 1;

CREATE OR REPLACE TRIGGER students_id_trigger
    before insert
    on STUDENTS
    for each row
begin
    select students_sequence.nextval
    into :NEW.id
    from DUAL;
end;
-- уникальный айди для студентика
CREATE OR REPLACE TRIGGER check_unique_student_id
    before insert
    on STUDENTS
    for each row
DECLARE
    id_cnt NUMBER;
    not_unique_student_id EXCEPTION;
    PRAGMA EXCEPTION_INIT (not_unique_student_id, -01422);
BEGIN
    SELECT COUNT(ID) INTO id_cnt FROM STUDENTS WHERE ID = :NEW.ID;
    IF id_cnt <> 0 THEN
        RAISE not_unique_student_id;
    end if;

end;

-- триггеры с каскадным ForeignKey
CREATE OR REPLACE TRIGGER students_cascade_delete_foreigh_key
    before delete
    on STUDENTS
    FOR EACH ROW
BEGIN
    UPDATE GROUPS
    SET C_VAL = C_VAL - 1
    WHERE GROUPS.ID = :OLD.GROUP_ID;
    COMMIT;
end;

CREATE OR REPLACE TRIGGER students_cascade_add_foreigh_key
    before insert
    on STUDENTS
    FOR EACH ROW
BEGIN
    UPDATE GROUPS
    SET C_VAL = C_VAL + 1
    WHERE GROUPS.ID = :NEW.GROUP_ID;
end;

-- логирование
CREATE OR REPLACE TRIGGER log_tg
    AFTER INSERT OR DELETE OR UPDATE
    ON STUDENTS
    FOR EACH ROW
DECLARE
    current_date TIMESTAMP;
    group_name   VARCHAR2(100);
BEGIN

    IF DELETING THEN
        SELECT CURRENT_TIMESTAMP INTO current_date FROM DUAL;
        SELECT name INTO group_name FROM GROUPS WHERE id = :OLD.group_id;

        INSERT INTO LOGS
            (time, user_name, group_name, msg, old_id)
        VALUES (current_date, :OLD.NAME, group_name, 'has been deleted', :OLD.id);

    ELSIF INSERTING THEN
        SELECT CURRENT_TIMESTAMP INTO current_date FROM DUAL;
        SELECT name INTO group_name FROM GROUPS WHERE id = :NEW.group_id;

        INSERT INTO LOGS
            (time, user_name, group_name, msg, old_id)
        VALUES (current_date, :NEW.NAME, group_name, 'has been added', :NEW.id);

    ELSIF UPDATING THEN
        SELECT CURRENT_TIMESTAMP INTO current_date FROM DUAL;
        SELECT name INTO group_name FROM GROUPS WHERE id = :NEW.group_id;

        INSERT INTO LOGS
            (time, user_name, group_name, msg, old_id)
        VALUES (current_date, :OLD.NAME, group_name, 'has been updated', :OLD.id);
    END IF;
end;


-- создаём табличку групп
CREATE
    TABLE
    GROUPS
(
    ID    NUMBER,
    NAME  VARCHAR2(100)      NOT NULL,
    C_VAL NUMBER DEFAULT (0) NOT NULL,
    CONSTRAINT groups_pk PRIMARY KEY (ID)
);

--автоинкремент для групп
CREATE
    SEQUENCE groups_sequence
    start
        with 1
    increment by 1;

CREATE
    OR
    REPLACE TRIGGER groups_id_trigger
    before
        insert
    on GROUPS
    for each row
begin
    select groups_sequence.nextval
    into :NEW.ID
    from DUAL;
end;

-- уникальные айдишники для групп
CREATE
    OR
    REPLACE TRIGGER check_unique_group_id
    before
        insert
    on GROUPS
    for each row
DECLARE
    id_cnt NUMBER;
    not_unique_group_id EXCEPTION;
    PRAGMA EXCEPTION_INIT (not_unique_group_id, -01422);
BEGIN
    SELECT COUNT(ID) INTO id_cnt FROM GROUPS WHERE ID = :NEW.ID;
    IF id_cnt <> 0 THEN
        RAISE not_unique_group_id;
    end if;
end;

--уникальное имя группы
CREATE
    OR
    REPLACE TRIGGER check_unique_group_name
    before
        insert
    on GROUPS
    for each row
DECLARE
    name_cnt NUMBER;
    not_unique_group_name EXCEPTION;
    PRAGMA EXCEPTION_INIT (not_unique_group_name, -01422);
BEGIN
    SELECT COUNT(NAME) INTO name_cnt FROM GROUPS WHERE NAME = :NEW.NAME;
    IF NAME_cnt <> 0 THEN
        RAISE not_unique_group_name;
    end if;

end;

-- удаление группы
CREATE
    OR
    REPLACE TRIGGER delete_group
    BEFORE
        DELETE
    ON GROUPS
    FOR EACH ROW
BEGIN
    DELETE FROM STUDENTS WHERE GROUP_ID = :OLD.ID;
end;


CREATE
    TABLE
    logs
(
    log_id     NUMBER GENERATED ALWAYS AS IDENTITY,
    time       TIMESTAMP(0)  NOT NULL,
    user_name  VARCHAR2(100) NOT NULL,
    group_name VARCHAR2(100) NOT NULL,
    old_id     NUMBER        NOT NULL,
    msg        VARCHAR2(100) NOT NULL,
    CONSTRAINT logs_pk PRIMARY KEY (log_id)
);


-- восстановление логов на определённый момент времени
CREATE OR REPLACE PROCEDURE restore_rows_by_time(log_time CHAR) IS
    CURSOR logs_cur IS
        SELECT *
        from LOGS
        WHERE LOGS.time = TO_TIMESTAMP(log_time, 'yyyy-mm-dd hh24:mi:ss');
    gp_id NUMBER;

BEGIN
    FOR log in logs_cur

        LOOP
            DBMS_OUTPUT.PUT_LINE('HERE');
            SELECT id INTO gp_id FROM GROUPS WHERE NAME = log.GROUP_NAME;

            IF log.msg = 'has been deleted' THEN
                INSERT INTO STUDENTS
                    (NAME, GROUP_ID)
                VALUES (LOG.USER_NAME, gp_id);
            ELSIF log.msg = 'has been added' THEN
                DELETE
                FROM STUDENTS
                WHERE NAME = log.user_name;

            ELSIF log.msg = 'has been updated' THEN
                UPDATE STUDENTS
                SET NAME     = log.USER_NAME,
                    GROUP_ID = gp_id
                WHERE ID = log.old_id;
            end if;

            --             DELETE
--             FROM LOGS
--             WHERE time = TO_TIMESTAMP(log_time, 'yyyy-mm-dd hh24:mi:ss');

        END LOOP;
    COMMIT;
end;

--
-- CREATE OR REPLACE PROCEDURE restore_rows_by_time(log_time CHAR) IS
--     CURSOR logs_cur IS
--         SELECT *
--         from LOGS
--         WHERE LOGS.time = TO_TIMESTAMP(log_time, 'yyyy-mm-dd hh24:mi:ss');
--     gp_id NUMBER;
--         log_val LOGS%rowtype;
--
-- BEGIN
--     OPEN logs_cur;
--
--
--         LOOP
--             FETCH logs_cur INTO log_val;
--             EXIT WHEN logs_cur%NOTFOUND;
--             DBMS_OUTPUT.PUT_LINE(TO_CHAR(logs_cur%ROWCOUNT));
--
--             SELECT id INTO gp_id FROM GROUPS WHERE NAME = log_val.GROUP_NAME;
--             DBMS_OUTPUT.PUT_LINE(log_val.group_name);
--             IF log_val.msg = 'has been deleted' THEN
--                 INSERT INTO STUDENTS
--                     (NAME, GROUP_ID)
--                 VALUES (log_val.USER_NAME, gp_id);
--             ELSIF log_val.msg = 'has been added' THEN
--                 DELETE
--                 FROM STUDENTS
--                 WHERE NAME = log_val.user_name;
--
--             ELSIF log_val.msg = 'has been updated' THEN
--                 UPDATE STUDENTS
--                 SET NAME     = log_val.USER_NAME,
--                     GROUP_ID = gp_id
--                 WHERE ID = log_val.old_id;
--             end if;
--
--             DELETE
--             FROM LOGS
--             WHERE time = TO_TIMESTAMP(log_time, 'yyyy-mm-dd hh24:mi:ss');
--
--         END LOOP;
--     CLOSE logs_cur;
--     COMMIT;
-- end;

-- восстановление логов на промежуток времени
CREATE OR REPLACE PROCEDURE restore_rows_by_interval(log_first_time CHAR, log_second_time CHAR) IS
    CURSOR logs_cur2 IS
        SELECT *
        FROM LOGS
        WHERE time >= TO_TIMESTAMP(log_first_time, 'yyyy-mm-dd hh24:mi:ss')
          AND time <= TO_TIMESTAMP(log_second_time, 'yyyy-mm-dd hh24:mi:ss')
        ORDER BY time;
        gp_id NUMBER;

BEGIN
    FOR log_val2 IN logs_cur2
        LOOP
--             RESTORE_ROWS_BY_TIME(TO_CHAR(log_val2.time));

        SELECT id INTO gp_id FROM GROUPS WHERE NAME = log_val2.GROUP_NAME;

            IF log_val2.msg = 'has been deleted' THEN
                INSERT INTO STUDENTS
                    (NAME, GROUP_ID)
                VALUES (log_val2.USER_NAME, gp_id);
            ELSIF log_val2.msg = 'has been added' THEN
                DELETE
                FROM STUDENTS
                WHERE NAME = log_val2.user_name;

            ELSIF log_val2.msg = 'has been updated' THEN
                UPDATE STUDENTS
                SET NAME     = log_val2.USER_NAME,
                    GROUP_ID = gp_id
                WHERE ID = log_val2.old_id;
            end if;

        end loop;
    COMMIT;
end;

------------------------------------------------------
