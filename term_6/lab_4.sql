-- юзер для лабы
ALTER SESSION SET "_oracle_script"=TRUE;
CREATE USER LAB5;
ALTER USER LAB5 QUOTA UNLIMITED ON USERS;

GRANT CONNECT, RESOURCE TO LAB5;

CREATE USER nik IDENTIFIED BY admin;
GRANT ALL PRIVILEGES TO nik;
GRANT DBA TO nik;

-- task 1
-- таблицы и триггеры для лабы
---------------------------------------------------------------------------------------------------
CREATE TABLE LAB5.GROUPS
(
    GROUP_ID    NUMBER ,
    GROUP_NAME  VARCHAR2(100)      NOT NULL,
    C_VAL NUMBER DEFAULT (0) NOT NULL,
    CONSTRAINT groups_pk PRIMARY KEY (GROUP_ID)
);

CREATE TABLE LAB5.CLASSES (
    class_id    NUMBER ,
    class_NAME  VARCHAR2(100)      NOT NULL,
    class_date DATE DEFAULT SYSDATE,

    CONSTRAINT classes_pk PRIMARY KEY (class_id)
);

CREATE TABLE LAB5.STUDENTS
(
    student_id       NUMBER ,
        student_NAME     VARCHAR2(100) NOT NULL UNIQUE ,
    GROUP_ID NUMBER        NOT NULL,
    class_id NUMBER NOT NULL,

    CONSTRAINT students_pk PRIMARY KEY (student_id),
    CONSTRAINT group_fk FOREIGN KEY(GROUP_ID) REFERENCES LAB5.GROUPS(GROUP_ID) ON DELETE CASCADE ,
    CONSTRAINT class_fk FOREIGN KEY(class_id) REFERENCES LAB5.CLASSES(class_id) ON DELETE CASCADE

);

-- триггеры с каскадным ForeignKey
CREATE OR REPLACE TRIGGER LAB5.students_cascade_delete_foreigh_key
    before delete
    on LAB5.STUDENTS
    FOR EACH ROW
     DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
    UPDATE LAB5.GROUPS
    SET C_VAL = C_VAL - 1
    WHERE LAB5.GROUPS.GROUP_ID = :OLD.GROUP_ID;
    COMMIT;
end;

CREATE OR REPLACE TRIGGER LAB5.students_cascade_add_foreigh_key
    before insert
    on LAB5.STUDENTS
    FOR EACH ROW
    DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
    UPDATE LAB5.GROUPS
    SET C_VAL = C_VAL + 1
    WHERE LAB5.GROUPS.GROUP_ID = :NEW.GROUP_ID;
    COMMIT;
end;

--task 2
-- сохранение изменений
-------------------------------------------------------------------------------------------------------------

create table lab5.history(
    history_id number generated always as identity,
    operation_date DATE,
    OPERATION VARCHAR2(6) NOT NULL CHECK(OPERATION IN ('insert', 'update', 'delete')),
    table_name VARCHAR2(20) NOT NULL,

    old_group_id NUMBER,
    new_group_id NUMBER,
    old_group_name VARCHAR2(100),
    new_group_name VARCHAR2(100),
    old_group_val number,
    new_group_val number,

    old_class_id NUMBER,
    new_class_id NUMBER,
    old_class_name VARCHAR2(100),
    new_class_name VARCHAR2(100),
    old_class_date DATE,
    new_class_date DATE,


    old_student_id NUMBER,
    new_student_id NUMBER,
    old_student_name VARCHAR2(100),
    new_student_name VARCHAR2(100),
    old_student_group_id number,
    new_student_group_id number,
    old_student_class_id number,
    new_student_class_id number,


    constraint history_pk PRIMARY KEY(history_id)
);

create or replace trigger LAB5.groups_history_tg
    after insert or update or delete
    on LAB5.GROUPS
    FOR EACH ROW
    begin
        IF INSERTING THEN
        INSERT INTO lab5.HISTORY(table_name,new_group_id, new_group_name,new_group_val, OPERATION, operation_date)
        VALUES('GROUPS',:NEW.group_id,:NEW.GROUP_NAME, :new.C_VAL, 'insert', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO lab5.HISTORY(table_name, old_group_id, old_group_name, old_group_val, new_group_id, new_group_name,new_group_val, OPERATION, operation_date)
        VALUES('GROUPS', :OLD.group_id,:OLD.GROUP_NAME, :OLD.C_VAL,:NEW.group_id,:NEW.GROUP_NAME, :new.C_VAL, 'update', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO lab5.HISTORY(table_name, old_group_id, old_group_name, old_group_val, OPERATION, operation_date)
        VALUES('GROUPS', :OLD.group_id,:OLD.GROUP_NAME, :OLD.C_VAL,'delete', SYSDATE);
    END IF;
    end;

create or replace trigger LAB5.classes_history_tg
    after insert or update or delete
    on LAB5.CLASSES
    FOR EACH ROW
    begin
        IF INSERTING THEN
        INSERT INTO lab5.HISTORY(table_name, new_class_id, new_class_name,new_class_date, OPERATION, operation_date)
        VALUES('CLASSES', :NEW.class_id,:NEW.class_name, :NEW.class_date, 'insert', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO lab5.HISTORY(table_name, old_class_id, old_class_name,old_class_date,new_class_id, new_class_name,new_class_date, OPERATION, operation_date)
        VALUES('CLASSES',:OLD.class_id,:OLD.class_name, :OLD.class_date,:NEW.class_id,:NEW.class_name, :NEW.class_date, 'update', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO lab5.HISTORY(table_name, old_class_id, old_class_name,old_class_date, OPERATION, operation_date)
        VALUES('CLASSES',:OLD.class_id,:OLD.class_name, :OLD.class_date,'delete', SYSDATE);
    END IF;
    end;

create or replace trigger LAB5.students_history_tg
    after insert or update or delete
    on LAB5.STUDENTS
    FOR EACH ROW
    begin
        IF INSERTING THEN
        INSERT INTO lab5.HISTORY(table_name, new_student_id, new_student_name, new_student_group_id,
                                 new_student_class_id, OPERATION, operation_date)
        VALUES('STUDENTS', :NEW.student_id,:NEW.student_name, :NEW.group_id, :NEW.class_id, 'insert', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO lab5.HISTORY(table_name,old_student_id, old_student_name, old_student_group_id, old_student_class_id
         , new_student_id, new_student_name, new_student_group_id, new_student_class_id, OPERATION, operation_date)
        VALUES('STUDENTS', :OLD.student_id,:OLD.student_name, :OLD.group_id, :OLD.class_id,
               :NEW.student_id,:NEW.student_name, :NEW.group_id, :NEW.class_id, 'update', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO lab5.HISTORY(table_name,old_student_id, old_student_name, old_student_group_id, old_student_class_id,
                                 OPERATION, operation_date)
        VALUES('STUDENTS', :OLD.student_id,:OLD.student_name, :OLD.group_id, :OLD.class_id,'delete', SYSDATE);
    END IF;
    end;

--task 3
--пакет с функциями
----------------------------------------------------------------------------------------------------------

-- стоит выключать триггеры сохранения состояний на время откатов
-- также нужно удалять состояний, находящиеся после того, на который мы откатились


CREATE OR REPLACE PACKAGE lab5.rollback_pkg IS
  PROCEDURE rollback_changes(p_date_time IN DATE);
  PROCEDURE rollback_changes(p_interval NUMBER);
  --PROCEDURE kurv(p_interval NUMBER);

END rollback_pkg;

CREATE OR REPLACE PACKAGE BODY lab5.rollback_pkg IS
    procedure restore_groups(data IN LAB5.history%rowtype) is
        begin
            IF data.OPERATION = 'insert' THEN
            DELETE FROM lab5.GROUPS WHERE lab5.GROUPS.GROUP_ID = data.new_group_id;
        ELSIF data.OPERATION = 'update' THEN
            UPDATE lab5.GROUPS SET lab5.GROUPS.GROUP_ID = data.old_group_id, lab5.GROUPS.GROUP_NAME = data.old_group_name,
                                   lab5.GROUPS.C_VAL = data.old_group_val
            WHERE lab5.GROUPS.GROUP_ID = data.new_group_id;
        ELSIF data.OPERATION = 'delete' THEN
            INSERT INTO lab5.GROUPS(GROUP_ID, GROUP_NAME, C_VAL)
            VALUES (data.old_group_id, data.old_group_name, data.old_group_val);
        END IF;
        end restore_groups;

    procedure restore_classes(data IN LAB5.history%rowtype) IS
        begin
            IF data.OPERATION = 'insert' THEN
            DELETE FROM lab5.CLASSES WHERE lab5.CLASSES.class_id = data.new_class_id;
        ELSIF data.OPERATION = 'update' THEN
            UPDATE lab5.CLASSES SET lab5.CLASSES.class_id = data.old_class_id, lab5.CLASSES.class_NAME = data.old_class_name,
                                   lab5.CLASSES.class_date = data.old_class_date
            WHERE lab5.CLASSES.class_id = data.new_class_id;
        ELSIF data.OPERATION = 'delete' THEN
            INSERT INTO lab5.CLASSES(class_id, class_NAME, class_date)
            VALUES (data.old_class_id, data.old_class_name, data.old_class_date);
        END IF;
        end restore_classes;

    procedure restore_students(data IN LAB5.history%rowtype) IS
        begin
             IF data.OPERATION = 'insert' THEN
            DELETE FROM lab5.STUDENTS WHERE lab5.STUDENTS.STUDENT_ID = data.new_student_id;
        ELSIF data.OPERATION = 'update' THEN
            UPDATE lab5.STUDENTS SET lab5.STUDENTS.STUDENT_ID = data.old_student_id,
                                     lab5.STUDENTS.student_NAME = data.old_student_name,
                                  lab5.STUDENTS.class_id = data.old_student_class_id,
                                  lab5.STUDENTS.GROUP_ID = data.old_student_group_id
            WHERE lab5.STUDENTS.STUDENT_ID = data.new_student_id;
        ELSIF data.OPERATION = 'delete' THEN
            INSERT INTO lab5.STUDENTS(STUDENT_ID, student_NAME, GROUP_ID, class_id)
            VALUES (data.old_student_id, data.old_student_name, data.old_student_group_id, data.old_student_class_id);
        END IF;
        end restore_students;


    PROCEDURE rollback_changes(p_date_time IN DATE) IS
        CURSOR history_logs(op_date LAB5.history.operation_date%type) is
            select * from LAB5.history
                where LAB5.history.operation_date >= op_date
                order by LAB5.history.history_id DESC;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('rollback func!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            for log in history_logs(p_date_time) loop
                if log.table_name = 'CLASSES' then
                    restore_classes(log);
                elsif log.table_name = 'GROUPS' then
                    restore_groups(log);
                elsif log.table_name = 'STUDENTS' then
                    restore_students(log);
                end if;
                end loop;

            delete from LAB5.history where LAB5.history.operation_date >= p_date_time;

            END rollback_changes;


        PROCEDURE rollback_changes(p_interval NUMBER) IS
        begin
            DBMS_OUTPUT.PUT_LINE('by interval &&&&&&&&&');
         rollback_pkg.rollback_changes(SYSDATE - NUMTODSINTERVAL(p_interval / 1000, 'SECOND'));
  END rollback_changes;


END rollback_pkg;

--task 4
-----------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE LAB5.report(date_time DATE) is
        student_insert_count number;
        student_delete_count number;
        student_update_count number;

        groups_insert_count number;
        groups_delete_count number;
        groups_update_count number;

        classes_insert_count number;
        classes_delete_count number;
        classes_update_count number;

        report VARCHAR2(9999);

        begin


            select count(*) into student_insert_count from LAB5.history
                                                      where operation_date >= date_time and table_name = 'STUDENTS'
                                                        and OPERATION = 'insert';

            select count(*) into student_delete_count from LAB5.history
                                                      where operation_date >= date_time and table_name = 'STUDENTS'
                                                        and OPERATION = 'delete';

            select count(*) into student_update_count from LAB5.history
                                                      where operation_date >= date_time and table_name = 'STUDENTS'
                                                        and OPERATION = 'update';

            select count(*) into groups_insert_count from LAB5.history
                                                      where operation_date >= date_time and table_name = 'GROUPS'
                                                        and OPERATION = 'insert';

            select count(*) into groups_delete_count from LAB5.history
                                                      where operation_date >= date_time and table_name = 'GROUPS'
                                                        and OPERATION = 'delete';

            select count(*) into groups_update_count from LAB5.history
                                                      where operation_date >= date_time and table_name = 'GROUPS'
                                                        and OPERATION = 'update';

            select count(*) into classes_insert_count from LAB5.history
                                                      where operation_date >= date_time and table_name = 'CLASSES'
                                                        and OPERATION = 'insert';

            select count(*) into classes_delete_count from LAB5.history
                                                      where operation_date >= date_time and table_name = 'CLASSES'
                                                        and OPERATION = 'delete';

            select count(*) into classes_update_count from LAB5.history
                                                      where operation_date >= date_time and table_name = 'CLASSES'
                                                        and OPERATION = 'update';

            report := HTF.HTMLOPEN || CHR(10) || HTF.headopen || CHR(10) || HTF.title('Отчисляемся, студентики')
            || CHR(10) || HTF.headclose || CHR(10) ||HTF.bodyopen || CHR(10);

            -- стедентики

            report := report || 'Студентики' ;

            report := report || '<ul>' || CHR(10);

            report := report || '<li>insert ' || student_insert_count || '</li>' || CHR(10) ;
            report := report || '<li>delete ' || student_delete_count || '</li>' || CHR(10) ;
            report := report || '<li>update ' || student_update_count || '</li>' || CHR(10) ;
            report := report || '</ul>' || CHR(10);


            report := report || '<ul>' || CHR(10);
            report := report || 'Опг(группы) ' || CHR(10) ;
            report := report || '<li>insert ' || groups_insert_count || '</li>' || CHR(10)  ;
            report := report || '<li>delete ' || groups_delete_count || '</li>' || CHR(10) ;
            report := report || '<li>update ' || groups_update_count || '</li>' || CHR(10) ;
            report := report || '</ul>' || CHR(10);

            report := report || '<ul>' || CHR(10);
            report := report || 'Занятки ' || CHR(10) ;
            report := report || '<li>insert ' || classes_insert_count || '</li>' || CHR(10)  ;
            report := report || '<li>delete ' || classes_delete_count || '</li>' || CHR(10) ;
            report := report || '<li>update ' || classes_update_count || '</li>' || CHR(10) ;
            report := report || '</ul>' || CHR(10);

            report := report || HTF.TABLECLOSE || CHR(10) || HTF.bodyclose || CHR(10) || HTF.htmlclose;

            DBMS_OUTPUT.PUT_LINE(report);

        end report;


-- tests
----------------------------------------------------------------------------------------------------

delete from lab5.students where student_id = 2;

select * from LAB5.STUDENTS;
select * from LAB5.GROUPS;

select * from lab5.history order by history_id;


update lab5.STUDENTS
set LAB5.STUDENTS.GROUP_ID=5
where LAB5.STUDENTS.student_id=1;

insert into LAB5.students
(STUDENT_ID,student_NAME, GROUP_ID, class_id)
values
(3, 'loh', 3, 2 );




insert into LAB5.GROUPS
(GROUP_ID, GROUP_NAME)
values
(103221, '103221');

insert into LAB5.CLASSES
(class_id, class_NAME)
values
(4,'vlad');

update LAB5.CLASSES
set class_NAME = 'vlad privet'
where class_id = 4;




drop table LAB5.STUDENTS;
drop table lab5.groups;
drop table LAB5.classes;
drop table LAB5.history;

begin
ALTER TRIGGER LAB5.classes_history_tg DISABLE;
ALTER TRIGGER LAB5.groups_history_tg DISABLE;
ALTER TRIGGER LAB5.students_history_tg DISABLE;

    call LAB5.rollback_pkg.rollback_changes(300000);
--call LAB5.rollback_pkg.rollback_changes(TO_DATE('2023-05-03 13:57:32', 'YYYY-MM-DD hh24:MI:SS'));


ALTER TRIGGER LAB5.classes_history_tg ENABLE ;
ALTER TRIGGER LAB5.groups_history_tg ENABLE ;
ALTER TRIGGER LAB5.students_history_tg ENABLE ;

select * from LAB5.STUDENTS;
select * from LAB5.GROUPS;

select * from lab5.history order by operation_date;


call lab5.report(TO_DATE('2023-04-30 21:30:48','YYYY-MM-DD hh24:MI:SS' ));

end;

begin
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE - NUMTODSINTERVAL(360000 / 1000, 'SECOND'),
                'YYYY-MM-DD hh24:MI:SS'));

end;
--дебаг

ALTER PACKAGE LAB5.rollback_pkg COMPILE BODY;


SELECT * FROM USER_ERRORS WHERE NAME = 'ROLLBACK_PKG';

