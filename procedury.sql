create or replace procedure p_add_reservation(p_trip_id int, p_person_id int)
as
    v_trip_exists INT;
    v_person_exists INT;
    v_available_places_no INT;
begin
    -- Sprawdzenie, czy podany p_trip_id istnieje w tabeli TRIP
    SELECT COUNT(*) INTO v_trip_exists FROM TRIP WHERE TRIP_ID = p_trip_id;

    IF v_trip_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Podany TRIP_ID nie istnieje.');
    END IF;

    -- Sprawdzenie, czy podany p_person_id istnieje w tabeli PERSON
    SELECT COUNT(*) INTO v_person_exists FROM PERSON WHERE PERSON_ID = p_person_id;

    IF v_person_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Podany PERSON_ID nie istnieje.');
    END IF;

    SELECT
        -- date juz zalatwia vw_trip
        AVAILABLE_PLACES_NO INTO v_available_places_no
        FROM VW_TRIP
        WHERE TRIP_ID = p_trip_id;

    IF v_available_places_no = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Brak wolnych miejsc na wycieczce.');
    end if;

    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID , STATUS) VALUES (p_trip_id, p_person_id, 'N');

    -- to mozna obskoczyk triggerem
    Insert into LOG (RESERVATION_ID, LOG_DATE, STATUS) VALUES ("BD_415810"."S_LOG_SEQ".CURRVAL, SYSDATE, 'N');

    COMMIT;
end;

create or replace procedure p_modify_reservation_status(p_reservation_id int)

