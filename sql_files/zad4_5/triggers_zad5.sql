--  triggery do P_ADD_RESERVATION

create or replace trigger t_check_available_places_on_trip
before insert on RESERVATION
for each row
declare
    v_available_places_no INT;
begin
    SELECT AVAILABLE_PLACES_NO INTO v_available_places_no FROM VW_TRIP WHERE TRIP_ID = :NEW.TRIP_ID;

    IF v_available_places_no = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Brak wolnych miejsc na wycieczce.');
    end if;
end;

create or replace trigger t_check_available_places_on_trip
before insert on RESERVATION
for each row
declare
    v_reservation_already_exists INT;
begin
    SELECT COUNT(*) INTO v_reservation_already_exists FROM RESERVATION WHERE TRIP_ID = NEW.TRIP_ID AND PERSON_ID = :NEW.PERSON_ID;
    IF v_reservation_already_exists > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Osoba o podanym PERSON_ID jest juz zapisana na wycieczke o podanym TRIP_ID.');
    END IF;
end;

create or replace trigger t_validate_add_reservation_input
before insert on RESERVATION
for each row
declare
    v_trip_exists INT;
    v_person_exists INT;
begin
    SELECT COUNT(*) INTO v_trip_exists FROM TRIP WHERE TRIP_ID = :NEW.trip_id;
    IF v_trip_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Podany TRIP_ID nie istnieje.');
    END IF;
    SELECT COUNT(*) INTO v_person_exists FROM PERSON WHERE PERSON_ID = :NEW.person_id;
    IF v_person_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Podany PERSON_ID nie istnieje.');
    END IF;
end;

--  triggery do P_MODIFY_RESERVATION_STATUS
create or replace trigger t_validate_modify_reservation_status_input
before insert on RESERVATION
for each row
declare
    v_reservation_exists int;
begin
    SELECT COUNT(*) INTO v_reservation_exists FROM RESERVATION WHERE RESERVATION_ID = :NEW.reservation_id;
    IF v_reservation_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Podany RESERVATION_ID nie istnieje.');
    END IF;
end;

create or replace trigger t_check_if_reservation_already_cancelled
before update on RESERVATION
for each row
declare
    v_old_status char;
    v_free_places INT;
begin
    SELECT STATUS INTO v_old_status FROM RESERVATION WHERE RESERVATION_ID = :NEW.reservation_id;

    IF v_old_status = 'C' THEN
        SELECT AVAILABLE_PLACES_NO INTO v_free_places FROM VW_TRIP
            WHERE TRIP_ID = (SELECT TRIP_ID FROM RESERVATION WHERE RESERVATION_ID = :NEW.reservation_id);

        IF v_free_places = 0 THEN
            RAISE_APPLICATION_ERROR(-20011, 'Brak wolnych miejsc na wycieczce.');
        end if;
    END IF;
end;