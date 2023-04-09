-- создаём схемы для лабы


CREATE USER de1ukc_prod
IDENTIFIED BY adm;

GRANT CREATE SESSION TO de1ukc_prod;
grant create table to de1ukc_prod;
grant create procedure to de1ukc_prod;
grant create trigger to de1ukc_prod;
grant create view to de1ukc_prod;
grant create sequence to de1ukc_prod;
grant alter any table to de1ukc_prod;
grant alter any procedure to de1ukc_prod;
grant alter any trigger to de1ukc_prod;
grant alter profile to de1ukc_prod;
grant delete any table to de1ukc_prod;
grant drop any table to de1ukc_prod;
grant drop any procedure to de1ukc_prod;
grant drop any trigger to de1ukc_prod;
grant drop any view to de1ukc_prod;
grant drop profile to de1ukc_prod;
grant SELECT ANY DICTIONARY to de1ukc_prod;


CREATE USER gottlieb_dev
IDENTIFIED BY nix;

GRANT CREATE SESSION TO gottlieb_dev;
grant create table tO gottlieb_dev;
grant create procedure tO gottlieb_dev;
grant create trigger tO gottlieb_dev;
grant create view tO gottlieb_dev;
grant create sequence tO gottlieb_dev;
grant alter any table tO gottlieb_dev;
grant alter any procedure tO gottlieb_dev;
grant alter any trigger tO gottlieb_dev;
grant alter profile tO gottlieb_dev;
grant delete any table tO gottlieb_dev;
grant drop any table tO gottlieb_dev;
grant drop any procedure tO gottlieb_dev;
grant drop any trigger tO gottlieb_dev;
grant drop any view tO gottlieb_dev;
grant drop profile tO gottlieb_dev;
grant SELECT ANY DICTIONARY tO gottlieb_dev;

grant all privileges to gottlieb_dev;
grant all privileges to de1ukc_prod;

GRANT CONNECT, RESOURCE TO gottlieb_dev;
GRANT CONNECT, RESOURCE TO de1ukc_prod;


ALTER SESSION SET "_oracle_script"=TRUE;
DROP USER lab3_dev CASCADE;

ALTER SESSION SET "_oracle_script"=TRUE;
DROP USER lab3_prod CASCADE;

ALTER SESSION SET "_oracle_script"=TRUE;
CREATE USER lab3_dev;
ALTER USER lab3_dev QUOTA UNLIMITED ON USERS;

ALTER SESSION SET "_oracle_script"=TRUE;
CREATE USER lab3_prod;
ALTER USER lab3_prod QUOTA UNLIMITED ON USERS;

GRANT CONNECT, RESOURCE TO LAB3_DEV;
GRANT CONNECT, RESOURCE TO LAB3_PROD;


--служебные таблица
-- таблица, содержащая названия разоичаюшихся талиц, которые есть в dev, но не в prod
create table different_tables (
    table_name  varchar2(128) not null
);

create table out_tables (
    table_name  varchar2(128) not null
);


-- вспомогательные функции и процедуры

--сравнение таблиц в двух схемах
create or replace procedure compare_schemas(dev_schema_name varchar2, prod_schema_name varchar2) as
     tab_count number;
    col_count number;

    cursor dev_tables is
        select * from ALL_TABLES where OWNER = dev_schema_name;

    begin
          -- берём таблицу
       for tab in (select * from ALL_TABLES where OWNER = dev_schema_name)
        loop
           select count(*) into tab_count from ALL_TABLES where OWNER=prod_schema_name and TABLE_NAME = tab.TABLE_NAME;

            -- если таблица присутствует, то проверяем колонки, если нет, то подлежит выводу на консоль
           if tab_count = 1 then
               for column in(
               select * from ALL_TAB_COLUMNS where OWNER=dev_schema_name and TABLE_NAME=tab.TABLE_NAME)
               loop
                   select count(*) into col_count from ALL_TAB_COLUMNS WHERE OWNER=prod_schema_name AND COLUMN_NAME = column.COLUMN_NAME
                        AND DATA_LENGTH=column.DATA_LENGTH AND DATA_TYPE=column.DATA_TYPE;

                   if col_count = 0 then
                       insert into different_tables values (tab.TABLE_NAME);
                   end if;
                   if col_count = 0 then
                       exit;
                   end if;
                   end loop;
            else
               insert into different_tables values (tab.TABLE_NAME);
               DBMS_OUTPUT.PUT_LINE('Найдена таблица');
           end if;
           end loop;
    end;

create or replace procedure fk_check(dev_schema_name varchar2, prod_schema_name varchar2) as
    cursor diff_tables is
        select * from different_tables;

    diff_tables_count number;

    ref_table_count number;

    ddl_script varchar2(300);

    loop_flag boolean := false;

    input_flag boolean := true;

    begin
        select count(*) into diff_tables_count from different_tables;

        while diff_tables_count <> 0 loop
            for tab in diff_tables
            loop
                for foreign_key in (select source_cons_cols.table_name source_table from ALL_CONSTRAINTS all_cons
                    inner join ALL_CONS_COLUMNS all_cons_cols
                    on all_cons.TABLE_NAME=all_cons_cols.CONSTRAINT_NAME and all_cons.R_OWNER=all_cons_cols.OWNER
                    inner join ALL_CONS_COLUMNS source_cons_cols on all_cons.CONSTRAINT_NAME=source_cons_cols.CONSTRAINT_NAME
                    and all_cons.OWNER=source_cons_cols.OWNER
                    where all_cons.CONSTRAINT_TYPE='R'
                    and all_cons_cols.OWNER=dev_schema_name
                    and all_cons_cols.TABLE_NAME=tab.table_name)

                    loop
                        select count(*) into ref_table_count from out_tables
                            where table_name=foreign_key.source_table;

                        for lp in (select dest_cc.table_name dest_table from all_constraints c
                            inner join all_cons_columns dest_cc on c.r_constraint_name=dest_cc.constraint_name
                            and c.r_owner=dest_cc.owner
                            inner join all_cons_columns src_cc on c.constraint_name=src_cc.constraint_name
                            and c.owner=src_cc.owner
                            where c.constraint_type='R' and dest_cc.owner=dev_schema_name
                            and src_cc.table_name=tab.table_name)
                                loop
                                    if lp.dest_table=foreign_key.source_table then
                                    ddl_script := 'Looping ref' || foreign_key.source_table || ' ' || tab.table_name;
                                    dbms_output.put_line(ddl_script);
                                    loop_flag := TRUE;
                    end if;
                                end loop;
                        if ref_table_count=0 and not loop_flag then
                    input_flag:=false;
                        end if;
                            end loop;
                if input_flag then
                delete from different_tables where table_name=tab.table_name;
                insert into out_tables values (tab.table_name);
            end if;
                input_flag:=TRUE;
            loop_flag := FALSE;
            SELECT COUNT(*) INTO diff_tables_count FROM different_tables;
                end loop;
            end loop;
    end;

create or replace procedure cout_tables(dev_schema_name varchar2, prod_schema_name varchar2) as
    cursor tables_to_print is
        select * from out_tables;

    ddl_script varchar2(300);


    begin
        DBMS_OUTPUT.PUT_LINE('таблицы');

        for tab in tables_to_print
        loop
            DBMS_OUTPUT.PUT_LINE(tab.table_name);
            ddl_script := 'create table ' || prod_schema_name || '.' || tab.table_name || '(';
            DBMS_OUTPUT.PUT_LINE(ddl_script);

            for col in (select * from ALL_TAB_COLUMNS where table_name=tab.table_name and OWNER=dev_schema_name)
            loop
                ddl_script := col.COLUMN_NAME || ' ' || col.DATA_TYPE || '(' || col.DATA_LENGTH || ')';

                if col.DATA_DEFAULT is not null then
                    ddl_script := ddl_script || ' default' || col.DATA_DEFAULT;
                end if;
                if col.NULLABLE='N' then
                    ddl_script:=ddl_script || ' not null';
                end if;
                DBMS_OUTPUT.PUT_LINE(ddl_script);
                end loop;

            for cons in (select * from ALL_CONSTRAINTS WHERE TABLE_NAME=tab.table_name and OWNER=dev_schema_name
                                                         and CONSTRAINT_TYPE='P' and GENERATED='USER NAME')
            loop
                for cons_name in (select cols.column_name from all_constraints cons, all_cons_columns cols
                                                          where cols.table_name = tab.table_name
                                                          and cons.constraint_type = 'P'
                                                          and cons.constraint_name = cols.constraint_name
                                                          and cons.owner = cols.owner
                                                          order by cols.table_name, cols.position)
            loop
                    ddl_script:= 'constraint ' || cons.CONSTRAINT_NAME || ' primary key (' || cons_name.COLUMN_NAME || ')';
                    end loop;
                dbms_output.put_line(ddl_script);
                end loop;
            for cons in (select src_cc.owner as src_owner, src_cc.table_name as src_table, src_cc.column_name
                as src_column, dest_cc.owner as dest_owner, dest_cc.table_name as dest_table,
                               dest_cc.column_name as dest_column, c.constraint_name
                from all_constraints c inner join all_cons_columns dest_cc on c.r_constraint_name = dest_cc.constraint_name
                and c.r_owner = dest_cc.owner inner join all_cons_columns src_cc on c.constraint_name = src_cc.constraint_name
                and c.owner = src_cc.owner where c.constraint_type = 'R' and dest_cc.owner = dev_schema_name
                and dest_cc.table_name = tab.table_name)
            loop
                for ref_name in (select * from all_cons_columns a join all_constraints c ON a.owner = c.owner
                and a.constraint_name = c.constraint_name
                join all_constraints c_pk on c.r_owner = c_pk.owner and c.r_constraint_name = c_pk.constraint_name
                where c.constraint_type = 'R' and a.table_name = tab.table_name)
                loop
                    ddl_script := 'constraint ' || ref_name.CONSTRAINT_NAME || ' foreign key ('
                                      || ref_name.COLUMN_NAME || ') references  '
                                      || dev_schema_name || '.' || ref_name.table_name || '(' || ref_name.COLUMN_NAME || ');';
                    end loop;
                dbms_output.put_line(ddl_script);
                end loop;
            dbms_output.put_line(');');
            end loop;
    end;

create or replace procedure check_functions(dev_schema_name varchar2, prod_schema_name varchar2) as
    cursor functions is
        select * from all_objects WHERE object_type='FUNCTION' AND owner=dev_schema_name;

    func_count number;

    f1_arg_count number;

    f2_arg_count number;

    arg_count number;

    ddl_script varchar2(300);

    func_end varchar2(300);

    begin
        DBMS_OUTPUT.PUT_LINE(' функции');

        for func in functions
        loop
            select COUNT(*) into func_count from all_objects where object_type='FUNCTION'
                                                            and object_name=func.object_name
                                                            and owner=prod_schema_name;
            if func_count = 0 then
            dbms_output.put_line(func.object_name);
            ddl_script := 'create or replace function ' || prod_schema_name || '.' || func.object_name || ' (';
            dbms_output.put_line(ddl_script);

            for proc_out in (select * from ALL_ARGUMENTS where owner=dev_schema_name
                                                         and OBJECT_NAME=func.object_name AND POSITION<>0
                                                         and PACKAGE_NAME is null)
                loop
                ddl_script := proc_out.DATA_TYPE || ' ' || proc_out.ARGUMENT_NAME;
                dbms_output.put_line(ddl_script);
            end loop;

            dbms_output.put_line(')');

            select DATA_TYPE into func_end from ALL_ARGUMENTS where owner=prod_schema_name
                                                              and OBJECT_NAME=func.object_name AND POSITION=0;
            func_end := 'return ' || func_end;
            dbms_output.put_line(func_end);

            else
                SELECT count(*) into f1_arg_count from ALL_ARGUMENTS where owner=dev_schema_name
                                                                       and OBJECT_NAME=func.object_name;
                SELECT count(*) into f2_arg_count from ALL_ARGUMENTS where owner=prod_schema_name
                                                                       and OBJECT_NAME=func.object_name;
                if f1_arg_count = f2_arg_count then
                    for arg in (select * from ALL_ARGUMENTS where owner=dev_schema_name and OBJECT_NAME=func.object_name)
                        loop
                            if arg.position=0 THEN
                                 SELECT count(*) into arg_count from ALL_ARGUMENTS where owner=prod_schema_name
                                        and OBJECT_NAME=func.object_name and DATA_TYPE=arg.DATA_TYPE and POSITION=0;

                                    if arg_count=0 THEN
                                        dbms_output.put_line(func.object_name);
                                        ddl_script := 'create or replace function ' || prod_schema_name
                                                          || '.' || func.object_name || ' (';
                                        dbms_output.put_line(ddl_script);

                                        for proc_out in (select * from ALL_ARGUMENTS where owner=dev_schema_name
                                                               and OBJECT_NAME=func.object_name and POSITION<>0
                                                               and PACKAGE_NAME is null )
                                            loop
                                            ddl_script := proc_out.DATA_TYPE || ' ' || proc_out.ARGUMENT_NAME;
                                            dbms_output.put_line(ddl_script);
                                            end loop;
                                        dbms_output.put_line(')');

                                        select DATA_TYPE into func_end from ALL_ARGUMENTS where owner=prod_schema_name
                                                                    and OBJECT_NAME=func.object_name and POSITION=0;
                                        func_end := 'return ' || func_end;
                                        dbms_output.put_line(func_end);
                                    end if;
                            else
                                select count(*) into arg_count from ALL_ARGUMENTS where owner=prod_schema_name
                                                        and OBJECT_NAME=func.object_name and DATA_TYPE=arg.DATA_TYPE;

                                if arg_count=0 then
                                dbms_output.put_line(func.object_name);
                                ddl_script:= 'create or replace function ' || prod_schema_name || '.' || func.object_name || ' (';
                                dbms_output.put_line(ddl_script);

                                for proc_out in (select * from ALL_ARGUMENTS where owner=dev_schema_name
                                                                   and OBJECT_NAME=func.object_name and POSITION<>0
                                                                           and PACKAGE_NAME is null)
                                loop
                                    ddl_script := proc_out.DATA_TYPE || ' ' || proc_out.ARGUMENT_NAME;
                                    dbms_output.put_line(ddl_script);
                                end loop;

                                dbms_output.put_line(')');

                                SELECT DATA_TYPE into func_end from ALL_ARGUMENTS where owner=prod_schema_name
                                                                    and OBJECT_NAME=func.object_name and POSITION=0;
                                func_end := 'return ' || func_end;
                                dbms_output.put_line(func_end);
                                end if;
                            end if;
                        end loop;
                else
                        dbms_output.put_line(func.object_name);
                        ddl_script := 'create or replace functions ' || prod_schema_name || '.' || func.object_name || ' (';
                        dbms_output.put_line(ddl_script);
                        for proc_out in (select * from ALL_ARGUMENTS where owner=dev_schema_name
                                                and OBJECT_NAME=func.object_name and POSITION<>0
                                                                       and PACKAGE_NAME is null )
                            loop
                            ddl_script := proc_out.DATA_TYPE || ' ' || proc_out.ARGUMENT_NAME;
                            dbms_output.put_line(ddl_script);
                        end loop;
                        dbms_output.put_line(')');

                        select DATA_TYPE into func_end from ALL_ARGUMENTS where owner=prod_schema_name
                                                                and OBJECT_NAME=func.object_name AND POSITION=0;
                        func_end := 'return ' || func_end;
                        dbms_output.put_line(func_end);
                end if;
            end if;
            end loop;
    end;

create or replace procedure check_procedures(dev_schema_name varchar2, prod_schema_name varchar2) as
    cursor procedures is
        select * from all_objects WHERE object_type='PROCEDURE' AND owner=dev_schema_name;

    proc_count number;

    ddl_script varchar2(300);

    p1_arg_count number;

    p2_arg_count number;

    arg_count number;

    begin
        DBMS_OUTPUT.PUT_LINE('процедуры');

        for proc in procedures
        loop
            select COUNT(*) into proc_count from all_objects where owner=prod_schema_name
                                                   and object_type='PROCEDURE' and object_name=proc.object_name;

            if proc_count = 0 then
                dbms_output.put_line(proc.object_name);
                ddl_script := 'create or replace procedure ' || prod_schema_name || '.' || proc.object_name || ' (';
                dbms_output.put_line(ddl_script);
                for proc_out in (SELECT * from ALL_ARGUMENTS where owner=dev_schema_name and OBJECT_NAME=proc.object_name)
                    loop
                    ddl_script := proc_out.ARGUMENT_NAME || ' in ' || proc_out.DATA_TYPE;
                    dbms_output.put_line(ddl_script);
                    end loop;
                dbms_output.put_line(')');

            else
                select count(*) into p1_arg_count from ALL_ARGUMENTS where owner=dev_schema_name
                                                                       and OBJECT_NAME=proc.object_name;
                select count(*) into p2_arg_count from ALL_ARGUMENTS where owner=prod_schema_name
                                                                   and OBJECT_NAME=proc.object_name;

                if p1_arg_count <> p2_arg_count then
                    dbms_output.put_line(proc.object_name);
                    ddl_script := 'create or replace procedure ' || prod_schema_name || ' . ' || proc.object_name || ' (';
                    dbms_output.put_line(ddl_script);

                    for proc_out in (select * from ALL_ARGUMENTS where owner=dev_schema_name
                                                                 and OBJECT_NAME=proc.object_name)
                        loop
                        ddl_script := proc_out.ARGUMENT_NAME || ' in ' || proc_out.DATA_TYPE;
                        dbms_output.put_line(ddl_script);
                    end loop;
                    dbms_output.put_line(')');

                else
                    for arg in (select * from ALL_ARGUMENTS where owner=dev_schema_name AND OBJECT_NAME=proc.object_name)
                        loop
                            select count(*) into arg_count from ALL_ARGUMENTS where owner=prod_schema_name
                                                        and OBJECT_NAME=proc.object_name and DATA_TYPE=arg.DATA_TYPE;
                            if arg_count=0 then
                            dbms_output.put_line(proc.object_name);
                            ddl_script := 'create or replace procedure ' || prod_schema_name || '.'
                                              || proc.object_name || ' (';
                            dbms_output.put_line(ddl_script);

                            for proc_out in (SELECT * from ALL_ARGUMENTS where owner=dev_schema_name AND OBJECT_NAME=proc.object_name)
                                loop
                                    ddl_script := proc_out.ARGUMENT_NAME || ' in ' || proc_out.DATA_TYPE;
                                    dbms_output.put_line(ddl_script);
                            end loop;
                            dbms_output.put_line(')');
                            end if;
                end loop;
                end if;
            end if;
            end loop;
    end;

create or replace procedure check_pakages(dev_schema_name VARCHAR2, prod_schema_name VARCHAR2) as
    func_count number;

    ddl_script varchar2(300);

    f1_arg_count number;

    f2_arg_count number;

    begin
        DBMS_OUTPUT.PUT_LINE(' пакеты');

        for pkg in (select * from all_objects where object_type='PACKAGE' and owner=dev_schema_name)
            loop
        select COUNT(*) into func_count from all_objects where owner=prod_schema_name and object_type='PACKAGE'
                                                           and object_name=pkg.OBJECT_NAME;
        if func_count=0 then
            dbms_output.put_line(pkg.object_name);
            ddl_script := 'create or replace package ' || prod_schema_name || '.' || pkg.object_name || ' as';
            dbms_output.put_line(ddl_script);

            for proc_out in (select * from all_procedures where owner=dev_schema_name and object_name=pkg.object_name
                                                            and PROCEDURE_NAME is not null)
                loop
                ddl_script := 'procedure ' || proc_out.PROCEDURE_NAME || '(';
                dbms_output.put_line(ddl_script);

                for arg_out in (SELECT * from ALL_ARGUMENTS where owner=dev_schema_name
                                                              and OBJECT_NAME=proc_out.PROCEDURE_NAME
                                                              and PACKAGE_NAME=pkg.object_name)
                    loop
                    ddl_script := arg_out.ARGUMENT_NAME || ' in ' || arg_out.DATA_TYPE;
                    dbms_output.put_line(ddl_script);
                    end loop;

                dbms_output.put_line(')');
                end loop;

            ddl_script := 'end ' || pkg.object_name || ';';
            dbms_output.put_line(ddl_script);
        else
            select count(*) into f1_arg_count from all_procedures where owner=dev_schema_name
                                                                    and OBJECT_NAME=pkg.OBJECT_NAME;
            select count(*) into f2_arg_count from all_procedures where owner=prod_schema_name
                                                                    and OBJECT_NAME=pkg.OBJECT_NAME;

            if f1_arg_count <> f2_arg_count then
                dbms_output.put_line(pkg.object_name);
                ddl_script := 'create or replace package ' || prod_schema_name || '.' || pkg.object_name || ' as';
                dbms_output.put_line(ddl_script);

                for proc_out in (select * from all_procedures where owner=dev_schema_name
                                                                and object_name=pkg.object_name
                                                                and PROCEDURE_NAME is not null)
                    loop
                    ddl_script := 'procedure ' || proc_out.PROCEDURE_NAME || '(';
                    dbms_output.put_line(ddl_script);

                    for arg_out in (SELECT * from ALL_ARGUMENTS where owner=dev_schema_name
                                                                  and OBJECT_NAME=proc_out.object_name
                                                                  and PACKAGE_NAME=pkg.object_name)
                        loop
                        ddl_script := arg_out.ARGUMENT_NAME || ' in ' || arg_out.DATA_TYPE;
                        dbms_output.put_line(ddl_script);
                    end loop;

                    dbms_output.put_line(')');
                end loop;

                ddl_script := 'end ' || pkg.object_name || ';';
                dbms_output.put_line(ddl_script);
            else
                for proc_pkg in (select * from all_procedures where owner=dev_schema_name
                                                                and object_name=pkg.object_name)
                    loop
                    if proc_pkg.SUBPROGRAM_ID<>0 then
                        select COUNT(*) into func_count from all_procedures where owner=prod_schema_name
                                                                               and object_name=pkg.object_name
                                                                               and PROCEDURE_NAME=proc_pkg.PROCEDURE_NAME;
                        if func_count=0 then
                            dbms_output.put_line(pkg.object_name);
                            ddl_script := 'CREATE or replace PACKAGE ' || prod_schema_name || '.'
                                              || pkg.object_name || ' AS';
                            dbms_output.put_line(ddl_script);

                            for proc_out in (select * from all_procedures where owner=dev_schema_name
                                                                            and object_name=pkg.object_name
                                                                            and PROCEDURE_NAME is not null)
                                loop
                                ddl_script := 'procedure ' || proc_out.PROCEDURE_NAME || '(';
                                dbms_output.put_line(ddl_script);

                                for arg_out in (SELECT * from ALL_ARGUMENTS where owner=dev_schema_name
                                                                              and OBJECT_NAME=proc_out.object_name
                                                                              and PACKAGE_NAME=pkg.object_name)
                                    loop
                                    ddl_script := arg_out.ARGUMENT_NAME || ' in ' || arg_out.DATA_TYPE;
                                    dbms_output.put_line(ddl_script);
                                    end loop;
                                dbms_output.put_line(')');
                            end loop;

                            ddl_script := 'end ' || pkg.object_name || ';';
                            dbms_output.put_line(ddl_script);
                        end if;
                    end if;
                end loop;
            end if;
        end if;
    end loop;
    end;

create or replace procedure tables_to_delete(dev_schema_name VARCHAR2, prod_schema_name VARCHAR2) as
    cursor tables is
        select * from ALL_TABLES WHERE OWNER=prod_schema_name;

    tab_count number;

    col_count number;

    ddl_script varchar2(300);

    begin
        for tab in tables
            loop
                select count(*) into tab_count from ALL_TABLES where TABLE_NAME=tab.TABLE_NAME
                                                                 and OWNER=dev_schema_name;
                if tab_count=1 then
                    for col in (select * from ALL_TAB_COLUMNS where table_name=tab.TABLE_NAME
                                                                and OWNER=prod_schema_name)
                        loop
                            select COUNT(*) into col_count from ALL_TAB_COLUMNS where  OWNER=dev_schema_name
                                                      and COLUMN_NAME=col.COLUMN_NAME and DATA_TYPE=col.DATA_TYPE
                                                      and DATA_LENGTH=col.DATA_LENGTH;
                            if col_count=0 then
                                ddl_script := 'drop table ' || tab.TABLE_NAME;
                                dbms_output.put_line(ddl_script);
                            end if;
                            EXIT WHEN col_count=0;
                        end loop;
                else
                    ddl_script := 'drop table ' || tab.TABLE_NAME;
                    dbms_output.put_line(ddl_script);
                end if;
            end loop;
    end;

create or replace procedure functions_to_delete(dev_schema_name VARCHAR2, prod_schema_name VARCHAR2) as
    cursor functions is
        select * from all_objects where object_type='FUNCTION' and owner=prod_schema_name;

    func_count number;

    ddl_script varchar2(300);

    f1_arg_count number;

    f2_arg_count number;

    arg_count number;

    begin
        dbms_output.put_line('Удаление функций');

        for func in functions
            loop
                select COUNT(*) into func_count from all_objects where owner=dev_schema_name
                                                                   and object_type='FUNCTION'
                                                                   and object_name=func.object_name;

                if func_count=0 then
                    ddl_script := 'drop functions ' || func.object_name;
                    dbms_output.put_line(ddl_script);
                else
                    SELECT count(*) into f1_arg_count from ALL_ARGUMENTS where owner=prod_schema_name
                                                                           and OBJECT_NAME=func.object_name;
                    SELECT count(*) into f2_arg_count from ALL_ARGUMENTS where owner=dev_schema_name
                                                                           and OBJECT_NAME=func.object_name;

                    if f1_arg_count <> f2_arg_count then
                        ddl_script := 'drop functions ' || func.object_name;
                        dbms_output.put_line(ddl_script);
                    else
                        for arg in (select * from ALL_ARGUMENTS where owner=prod_schema_name
                                                                  and OBJECT_NAME=func.object_name)
                            loop
                                if arg.position=0 then
                                    select count(*) into arg_count from ALL_ARGUMENTS where owner=dev_schema_name
                                                        and OBJECT_NAME=func.object_name and DATA_TYPE=arg.DATA_TYPE
                                                        and POSITION=0;
                                    if arg_count=0 then
                                        ddl_script := 'drop functions ' || func.object_name;
                                        dbms_output.put_line(ddl_script);
                                    end if;
                                else
                                    select count(*) into arg_count from ALL_ARGUMENTS where owner=dev_schema_name
                                                        and OBJECT_NAME=func.object_name and DATA_TYPE=arg.DATA_TYPE;
                                    if arg_count=0 then
                                        ddl_script := 'drop functions ' || func.object_name;
                                        dbms_output.put_line(ddl_script);
                                    end if;
                                end if;
                            end loop;
                    end if;
                end if;
            end loop;
    end;

create or replace procedure procedures_to_delete(dev_schema_name VARCHAR2, prod_schema_name VARCHAR2) as
    cursor procedures is
        select * from all_objects where object_type='PROCEDURE' and owner=prod_schema_name;

    proc_count number;

    ddl_script varchar2(300);

    p1_arg_count number;

    p2_arg_count number;

    arg_count number;

    begin
        dbms_output.put_line('Удаление процедур');

        for proc in procedures
            loop
                select COUNT(*) into proc_count from all_objects where owner=dev_schema_name and object_type='PROCEDURE'
                                                                   and object_name=proc.object_name;
                if proc_count=0 then
                    ddl_script := 'drop procedure ' || proc.object_name;
                    dbms_output.put_line(ddl_script);
                ELSE
                    SELECT count(*) into p1_arg_count from ALL_ARGUMENTS where owner=prod_schema_name
                                                                           and OBJECT_NAME=proc.object_name;
                    SELECT count(*) into p2_arg_count from ALL_ARGUMENTS where owner=dev_schema_name
                                                                             and OBJECT_NAME=proc.object_name;

                    if p1_arg_count <> p2_arg_count then
                        ddl_script := 'drop procedure ' || proc.object_name;
                        dbms_output.put_line(ddl_script);
                    else
                        for arg in (select * from ALL_ARGUMENTS where owner=prod_schema_name
                                                                  and OBJECT_NAME=proc.object_name)
                            loop
                                select count(*) into arg_count from ALL_ARGUMENTS where owner=dev_schema_name
                                                        and OBJECT_NAME=proc.object_name and DATA_TYPE=arg.DATA_TYPE;
                                if arg_count=0 then
                                    ddl_script := 'drop procedure ' || proc.object_name;
                                    dbms_output.put_line(ddl_script);
                                end if;
                            end loop;
                    end if;
                end if;
            end loop;
    end;


create or replace procedure packages_to_delete(dev_schema_name VARCHAR2, prod_schema_name VARCHAR2) as
    pack_count number;

    ddl_script varchar2(300);

    p1_arg_count number;

    p2_arg_count number;

    begin
        dbms_output.put_line('Удаление пакетов');

        for pkg in (select * from all_objects where object_type='PACKAGE' and owner=prod_schema_name)
            loop
                select COUNT(*) into pack_count from all_objects where owner=dev_schema_name
                                                                   and object_type='PACKAGE'
                                                                   and object_name=pkg.OBJECT_NAME;
                if pack_count=0 then
                    ddl_script := 'drop package ' || pkg.OBJECT_NAME;
                    dbms_output.put_line(ddl_script);
                else
                    select count(*) into p1_arg_count from all_procedures where owner=prod_schema_name
                                                                            and OBJECT_NAME=pkg.OBJECT_NAME;
                    select count(*) into p2_arg_count from all_procedures where owner=dev_schema_name
                                                                            and OBJECT_NAME=pkg.OBJECT_NAME;

                    if p1_arg_count <> p2_arg_count then
                        ddl_script := 'drop package ' || pkg.OBJECT_NAME;
                        dbms_output.put_line(ddl_script);
                    else
                        for proc_pkg in (select * from all_procedures where owner=prod_schema_name
                                                                        and object_name=pkg.object_name)
                            loop
                                if proc_pkg.SUBPROGRAM_ID<>0 then
                                    select COUNT(*) into pack_count from all_procedures where owner=dev_schema_name
                                                                              and object_name=pkg.object_name
                                                                              and PROCEDURE_NAME=proc_pkg.PROCEDURE_NAME;
                                    if pack_count=0 then
                                        ddl_script := 'drop package ' || pkg.OBJECT_NAME;
                                        dbms_output.put_line(ddl_script);
                                    end if;
                                end if;
                            end loop;
                    end if;
                end if;
            end loop;
    end;

-- основная функция
create or replace procedure get_different_tables(dev_schema_name VARCHAR2, prod_schema_name VARCHAR2) as

    begin
      compare_schemas(dev_schema_name, prod_schema_name);

      fk_check(dev_schema_name, prod_schema_name);

      cout_tables(dev_schema_name, prod_schema_name);

      check_functions(dev_schema_name, prod_schema_name);

      check_procedures(dev_schema_name, prod_schema_name);

      check_pakages(dev_schema_name, prod_schema_name);

      tables_to_delete(dev_schema_name, prod_schema_name);

      functions_to_delete(dev_schema_name, prod_schema_name);

      procedures_to_delete(dev_schema_name, prod_schema_name);

      packages_to_delete(dev_schema_name, prod_schema_name);

    end;

--  главный код

CREATE TABLE LAB3_DEV."tab1"(id int PRIMARY KEY, val INT);
CREATE TABLE LAB3_DEV."tab2"(id int PRIMARY KEY, val INT);
CREATE TABLE LAB3_DEV."tab3"(id int PRIMARY KEY, val INT);

ALTER TABLE LAB3_DEV."tab2" ADD FOREIGN KEY (val) REFERENCES LAB3_DEV."tab1"(id);
ALTER TABLE LAB3_DEV."tab1" ADD FOREIGN KEY (val) REFERENCES LAB3_DEV."tab3"(id);



drop table LAB3_DEV."tab1" cascade constraints;
drop table LAB3_DEV."tab2" cascade constraints;
drop table LAB3_DEV."tab3"cascade constraints;

delete from different_tables
    where 1=1;

delete from out_tables
    where 1=1;

   call GET_DIFFERENT_TABLES('LAB3_DEV','LAB3_PROD');

select * from different_tables;
select * from out_tables;

select * from ALL_TABLES where OWNER = 'LAB3_DEV';
