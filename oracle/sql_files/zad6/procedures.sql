create or replace procedure check_available_places_for_all_6
as
begin
    UPDATE TRIP
    SET NO_AVAILABLE_PLACES = NVL((SELECT MAX_NO_PLACES - COUNT(*)
        FROM RESERVATION
        WHERE TRIP.TRIP_ID = RESERVATION.TRIP_ID
        AND STATUS IN ('P', 'N')
        GROUP BY TRIP.TRIP_ID, MAX_NO_PLACES), MAX_NO_PLACES)
    where TRIP.TRIP_ID in (select TRIP_ID from TRIP);

    COMMIT;
end;

-- procedura działa ale wywala się z tymi triggerami:
-- T_VALIDATE_MODIFY_RESERVATION_STATUS_INPUT,
-- T_CHECK_AVAILABLE_PLACES_ON_TRIP
create or replace procedure p_add_reservation_6(p_trip_id int, p_person_id int)
as
begin
    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID , STATUS) VALUES (p_trip_id, p_person_id, 'N');

    UPDATE TRIP
    SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - 1
    WHERE TRIP_ID = p_trip_id;

    COMMIT;
end;

-- nie działa bo trigger T_CHECK_IF_RESERVATION_ALREADY_CANCELLED powoduje konflikt odczytywania i modyfikacji danych
create or replace procedure p_modify_reservation_status_6(p_reservation_id int, p_status char)
as
    v_was_cancelled INT;
    v_trip_id INT;
begin
    SELECT COUNT(*) INTO v_was_cancelled FROM RESERVATION
                                         WHERE RESERVATION_ID = p_reservation_id AND STATUS = p_status;

    UPDATE RESERVATION SET STATUS = p_status WHERE RESERVATION_ID = p_reservation_id;

    SELECT TRIP_ID INTO v_trip_id FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;

    UPDATE TRIP
    SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES + v_was_cancelled - CASE WHEN p_status = 'C' THEN 1 ELSE 0 END
    WHERE TRIP_ID = v_trip_id;

    COMMIT;
end;

create or replace procedure p_modify_max_no_places_6( p_trip_id int, p_max_no_places int)
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

    -- zmiana liczby dostępnych miejsc i max ilości miejsc
    UPDATE TRIP SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - MAX_NO_PLACES + p_max_no_places,
                    MAX_NO_PLACES = p_max_no_places WHERE TRIP_ID = p_trip_id;

    COMMIT;
end;


--  nie zależne od zad 4, 5
CREATE OR REPLACE PROCEDURE p_add_reservation_(
    p_trip_id INT,
    p_person_id INT
)
AS
    v_trip_exists INT;
    v_person_exists INT;
    v_available_places_no INT;
    v_reservation_already_exists INT;
    v_available_places INT;
BEGIN
    SELECT COUNT(*) INTO v_trip_exists FROM TRIP WHERE TRIP_ID = p_trip_id;

    IF v_trip_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Podany TRIP_ID nie istnieje.');
    END IF;

    SELECT COUNT(*) INTO v_person_exists FROM PERSON WHERE PERSON_ID = p_person_id;

    IF v_person_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Podany PERSON_ID nie istnieje.');
    END IF;

    SELECT AVAILABLE_PLACES_NO INTO v_available_places_no FROM VW_TRIP WHERE TRIP_ID = p_trip_id;

    IF v_available_places_no = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Brak wolnych miejsc na wycieczce.');
    end if;

    SELECT COUNT(*) INTO v_reservation_already_exists FROM RESERVATION WHERE TRIP_ID = p_trip_id AND PERSON_ID = p_person_id;
    IF v_reservation_already_exists > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Osoba o podanym PERSON_ID jest juz zapisana na wycieczke o podanym TRIP_ID.');
    END IF;


    SELECT NO_AVAILABLE_PLACES INTO v_available_places FROM TRIP WHERE TRIP_ID = p_trip_id;

    IF v_available_places = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie ma już wolnych miejsc na wycieczce z id: ' || p_trip_id);
    END IF;

    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID , STATUS) VALUES (p_trip_id, p_person_id, 'N');
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE p_modify_reservation_status_(
    p_reservation_id INT,
    p_status char
)
AS
    v_curr_status char;
    v_trip_id INT;
BEGIN
    SELECT
        status,
        trip_id
    INTO
        v_curr_status,
        v_trip_id
    FROM RESERVATION
    WHERE reservation_id = p_reservation_id;

    CASE p_status
    WHEN v_curr_status THEN
        DBMS_OUTPUT.PUT_LINE('Status nie uległ zmianie dla rezerwacji z id: ' || p_reservation_id);
        RETURN;
    WHEN 'C' THEN
        NULL;
    WHEN 'N' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie można ustawiać statusu na N.');
    WHEN 'P' THEN
        IF v_curr_status = 'C' AND (SELECT NO_AVAILABLE_PLACES FROM TRIP
            JOIN RESERVATION ON TRIP.TRIP_ID = RESERVATION.TRIP_ID
            WHERE RESERVATION_ID = p_reservation_id) = 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Nie ma już wolnych miejsc na tej wycieczce.');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Status: ' || p_status || ' nie istnieje.');
    END CASE;

    UPDATE RESERVATION
    SET status = p_status
    WHERE reservation_id = p_reservation_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Nie istnieje rezerwacja z id: ' || p_reservation_id);

    COMMIT;
END;

CREATE OR REPLACE PROCEDURE modifyMaxNoPlaces(
    p_trip_id INT,
    p_max_no_places INT
)
AS
    l_booked_places INT;
    l_curr_max_no_places INT;
BEGIN
    SELECT max_no_places INTO l_curr_max_no_places FROM TRIP WHERE trip_id = p_trip_id;
    select count(*) into l_booked_places from table(f_trip_participants(p_trip_id));

    IF p_max_no_places = l_curr_max_no_places THEN
        DBMS_OUTPUT.PUT_LINE('Liczba miejsc nie uległa zmianie dla wycieczki z id: ' || p_trip_id);
        RETURN;
    END IF;

    IF p_max_no_places < l_booked_places THEN
        RAISE_APPLICATION_ERROR(-20001, 'Dla wycieczki z id: ' || p_trip_id
                                            || 'nie można ustawic mniejszy limit od aktualnie wykupionych miejsc.');
    END IF;

    UPDATE TRIP
    SET max_no_places = p_max_no_places
    WHERE trip_id = p_trip_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Nie istnieje wycieczka z id: ' || p_trip_id);
    COMMIT;
END;
