-- Чтобы создать новую схему, нужно создать нового юзера
CREATE USER gottlieb
IDENTIFIED BY nix;

GRANT CREATE SESSION TO gottlieb;
grant create table to gottlieb;
grant create procedure to gottlieb;
grant create trigger to gottlieb;
grant create view to gottlieb;
grant create sequence to gottlieb;
grant alter any table to gottlieb;
grant alter any procedure to gottlieb;
grant alter any trigger to gottlieb;
grant alter profile to gottlieb;
grant delete any table to gottlieb;
grant drop any table to gottlieb;
grant drop any procedure to gottlieb;
grant drop any trigger to gottlieb;
grant drop any view to gottlieb;
grant drop profile to gottlieb;
grant SELECT ANY DICTIONARY to gottlieb;


--


CREATE OR REPLACE FUNCTION show_tables_by_schema(dev_schema_name VARCHAR2, prod_schema_name VARCHAR2)
    RETURN sys_refcursor
    IS
    rf_cursos sys_refcursor;
BEGIN
    return rf_cursos;
END;


SELECT ALL_TABLES.TABLE_NAME FROM ALL_TABLES
WHERE ALL_TABLES.TABLE_NAME = 'STUDENTS';

