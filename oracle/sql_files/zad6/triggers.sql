--  triggery do P_ADD_RESERVATION
create or replace trigger t_check_available_places_on_trip_6
before insert on RESERVATION
for each row
declare
    v_available_places_no INT;
begin
    SELECT NO_AVAILABLE_PLACES INTO v_available_places_no FROM TRIP WHERE TRIP.TRIP_ID = :NEW.TRIP_ID;

    IF v_available_places_no = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Brak wolnych miejsc na wycieczce.');
    end if;
end;

--  triggery do P_MODIFY_RESERVATION_STATUS
-- jako że był on bazowany na t_check_if_reservation_already_cancelled to on również nie działa
create or replace trigger t_check_if_reservation_already_cancelled_6
before update on RESERVATION
for each row
declare
    v_old_status char;
    v_free_places INT;
begin
    SELECT STATUS INTO v_old_status FROM RESERVATION WHERE RESERVATION_ID = :NEW.reservation_id;

    IF v_old_status = 'C' THEN
        SELECT NO_AVAILABLE_PLACES INTO v_free_places FROM TRIP
            WHERE TRIP_ID = (SELECT TRIP_ID FROM RESERVATION WHERE RESERVATION_ID = :NEW.reservation_id);

        IF v_free_places = 0 THEN
            RAISE_APPLICATION_ERROR(-20011, 'Brak wolnych miejsc na wycieczce.');
        end if;
    END IF;
end;


--  nie zależne od zad 4, 5
CREATE OR REPLACE TRIGGER t_before_insert_on_reservation
BEFORE INSERT
ON RESERVATION
FOR EACH ROW
DECLARE
    v_trip_exists INT;
    v_person_exists INT;
    v_available_places INT;
BEGIN
    SELECT COUNT(*) INTO v_trip_exists FROM TRIP WHERE TRIP_ID = :NEW.trip_id;
    IF v_trip_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Podany TRIP_ID nie istnieje.');
    END IF;
    SELECT COUNT(*) INTO v_person_exists FROM PERSON WHERE PERSON_ID = :NEW.person_id;
    IF v_person_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Podany PERSON_ID nie istnieje.');
    END IF;

    SELECT NO_AVAILABLE_PLACES INTO v_available_places FROM TRIP WHERE TRIP_ID = :NEW.trip_id;

    IF v_available_places = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Wszystkie miejsca dla wycieczki z id: ' || :NEW.trip_id || ' są już zajęte.');
    END IF;
END;

CREATE OR REPLACE TRIGGER t_before_update_of_status_on_reservation
BEFORE UPDATE
OF status ON RESERVATION
BEGIN
    CASE :NEW.status
    WHEN :OLD.status THEN
        DBMS_OUTPUT.PUT_LINE('Rezerwacja z id: ' || :NEW.reservation_id ||
                             ' już posiada status: ' || :NEW.status);
        RETURN;
    WHEN 'C' THEN
        NULL;
    WHEN 'N' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie można ustawiać statusu na N.');
    WHEN 'P' THEN
        IF :OLD.status = 'C' AND (SELECT NO_AVAILABLE_PLACES FROM TRIP
            JOIN RESERVATION ON TRIP.TRIP_ID = RESERVATION.TRIP_ID
            WHERE RESERVATION_ID = :NEW.reservation_id) = 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Nie ma już wolnych miejsc na tej wycieczce.');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Status: ' || :NEW.status || ' nie istnieje.');
    END CASE;
END;

CREATE OR REPLACE TRIGGER t_before_update_of_max_no_places_on_trip
BEFORE UPDATE
OF max_no_places ON TRIP
DECLARE
    v_booked_places INT;
BEGIN
    IF :NEW.max_no_places = :OLD.max_no_places THEN
        DBMS_OUTPUT.PUT_LINE('Liczba miejsc dla wycieczki z id: ' || :NEW.trip_id || ' nie zmieniła się.');
        RETURN;
    END IF;

    v_booked_places := (select count(*) from table(f_trip_participants(:NEW.TRIP_ID)));

    IF :NEW.max_no_places < v_booked_places THEN
        RAISE_APPLICATION_ERROR(-20001, 'Dla wycieczki z id: ' || :NEW.trip_id
                                            || 'nie można ustawic mniejszy limit od aktualnie wykupionych miejsc.');
    END IF;
END;

CREATE OR REPLACE TRIGGER t_after_update_of_status_on_reservation
AFTER UPDATE
OF status ON RESERVATION
DECLARE
    v_no_change INT;
BEGIN
    CASE :NEW.status
    WHEN :OLD.status THEN
        RETURN;
    WHEN 'C' THEN
        v_no_change := 1;
    WHEN 'P' THEN
        v_no_change := CASE WHEN :old.status = 'C' THEN -1 ELSE 0 END;
    END CASE;

    UPDATE TRIP
    SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES + v_no_change
    WHERE TRIP_ID = :NEW.trip_id;
end;
