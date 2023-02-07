CREATE TABLE my_table
    (
        id NUMBER,
        val NUMBER,

    CONSTRAINT table_pk PRIMARY KEY (id)

);

create sequence tt_sequence
start with 1
increment by 1;

create trigger tt_trigger
before insert on my_table for each row
begin
  select tt_sequence.nextval
  into :new.id
  from dual;
end;


DECLARE
    start_loop number;
    end_loop   number;
BEGIN
    start_loop := 1;
    end_loop := 10000;

    WHILE (start_loop <= end_loop)
        LOOP
        INSERT INTO my_table
            (val)
            values (DBMS_RANDOM.RANDOM());

            start_loop := start_loop + 1;
        end loop;
end;

CREATE OR REPLACE FUNCTION even_more
    RETURN varchar2
    IS

    response     varchar2(10);
    even_cnt     number;
    not_even_cnt number;

BEGIN
    SELECT COUNT(*)
    INTO even_cnt
    FROM (SELECT val FROM MY_TABLE where MOD(val, 2) = 0);

    not_even_cnt := 10000 - even_cnt;

    IF even_cnt > not_even_cnt THEN
        response := 'TRUE';
    ELSIF even_cnt < not_even_cnt THEN
        response := 'FALSE';
    ELSE
        response := 'EQUAL';
    end if;

    return response;
end;

CREATE OR REPLACE FUNCTION check_id(in_id IN number)
    RETURN varchar2
    IS

    val_from_table number;
    response       varchar2(1000);

BEGIN
    SELECT val
    INTO val_from_table
    FROM MY_TABLE
    WHERE ID = in_id;

    response := 'insert into my_table
                    (id, val)
                    values
                    (' || in_id || ', ' || val_from_table || ');';

    return response;

    exception
    WHEN no_data_found THEN  return 'invalid id';

end;

CREATE OR REPLACE PROCEDURE add_line(in_val IN NUMBER) AS
    BEGIN
        INSERT INTO MY_TABLE
            (VAL)
        VALUES
            (in_val);
    end;
    
 CREATE OR REPLACE PROCEDURE remove_line(ID_in IN NUMBER) AS
    BEGIN
        DELETE FROM MY_TABLE
            WHERE ID = ID_in;
    end;
    
 CREATE OR REPLACE PROCEDURE update_line(ID_in IN NUMBER, val_in IN NUMBER) AS
BEGIN
    UPDATE MY_TABLE
    SET VAL = val_in
    WHERE ID = ID_in;
end;

