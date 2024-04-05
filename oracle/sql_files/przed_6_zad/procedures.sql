create or replace procedure p_add_reservation(p_trip_id int, p_person_id int)
as
    v_trip_exists INT;
    v_person_exists INT;
    v_available_places_no INT;
    v_reservation_already_exists INT;
begin
-- kontrola wejscia
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

    -- to mozna obskoczyk triggerem!!
-- date juz zalatwia vw_trip
    SELECT AVAILABLE_PLACES_NO INTO v_available_places_no FROM VW_TRIP WHERE TRIP_ID = p_trip_id;

    IF v_available_places_no = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Brak wolnych miejsc na wycieczce.');
    end if;

    -- to mozna obskoczyk triggerem!!
    -- zobacz czy nie jest juz zapisany
    SELECT COUNT(*) INTO v_reservation_already_exists FROM RESERVATION WHERE TRIP_ID = p_trip_id AND PERSON_ID = p_person_id;
    IF v_reservation_already_exists > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Osoba o podanym PERSON_ID jest juz zapisana na wycieczke o podanym TRIP_ID.');
    END IF;

    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID , STATUS) VALUES (p_trip_id, p_person_id, 'N');

    Insert into LOG (RESERVATION_ID, LOG_DATE, STATUS) VALUES ("S_LOG_SEQ".CURRVAL, SYSDATE, 'N');

    COMMIT;
end;

create or replace procedure p_modify_reservation_status( p_reservation_id int, p_status char)
as
    v_reservation_exists INT;
    v_old_status char;
    v_free_places INT;
begin
    -- Sprawdzenie, czy podany reservation_id istnieje w tabeli RESERVATION
    SELECT COUNT(*) INTO v_reservation_exists FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;

    IF v_reservation_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Podany RESERVATION_ID nie istnieje.');
    END IF;

    -- triger by sie przydal
    SELECT STATUS INTO v_old_status FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;

    IF v_old_status = 'C' THEN
        -- sprawdzenie czy da sie zapisac na wycieczke
        SELECT AVAILABLE_PLACES_NO INTO v_free_places FROM VW_TRIP
            WHERE TRIP_ID = (SELECT TRIP_ID FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id);

        IF v_free_places = 0 THEN
            RAISE_APPLICATION_ERROR(-20011, 'Brak wolnych miejsc na wycieczce.');
        end if;
    END IF;

    -- zmiana statusu
    UPDATE RESERVATION SET STATUS = p_status WHERE RESERVATION_ID = p_reservation_id;

    -- wpisanie do logow
    Insert into LOG (RESERVATION_ID, LOG_DATE, STATUS) VALUES (p_reservation_id, SYSDATE, p_status);

    COMMIT;
end;


create or replace procedure p_modify_max_no_places( p_trip_id int, p_max_no_places int)
as
    v_trip_exists INT;
    v_curr_occupied_places INT;
begin
    -- Sprawdzenie, czy podany trip_id istnieje w tabeli TRIP
    SELECT COUNT(*) INTO v_trip_exists FROM TRIP WHERE trip_id = p_trip_id;

    IF v_trip_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Podany TRIP_ID nie istnieje.');
    END IF;

    -- Sprawdzenie, czy podany max_no_places jest wiekszy od obecnej liczby zapisanych osob
    SELECT cnt into v_curr_occupied_places FROM VW_TRIP_ENROLLED_NO where trip_id = p_trip_id;

    IF p_max_no_places < v_curr_occupied_places THEN
        RAISE_APPLICATION_ERROR(-20021, 'Podana liczba miejsc jest mniejsza od obecnej liczby zapisanych osob.');
    END IF;

    -- zmiana liczby miejsc
    UPDATE TRIP SET MAX_NO_PLACES = p_max_no_places WHERE TRIP_ID = p_trip_id;

    COMMIT;
end;



