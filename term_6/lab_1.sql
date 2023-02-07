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
