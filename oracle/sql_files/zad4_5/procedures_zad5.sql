-- NOTKA: plik zawiera procedury zmienione nie tylko pod wpływem operacji w zadaniu 5, ale i te z 4.

create or replace procedure p_add_reservation_5(p_trip_id int, p_person_id int)
as
begin
    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID , STATUS) VALUES (p_trip_id, p_person_id, 'N');
    COMMIT;
end;


create or replace procedure p_modify_reservation_status_5( p_reservation_id int, p_status char)
as
begin
    UPDATE RESERVATION SET STATUS = p_status WHERE RESERVATION_ID = p_reservation_id;
    COMMIT;
end;