create or replace procedure p_add_reservation_4(p_trip_id int, p_person_id int)
as
    v_trip_exists INT;
    v_person_exists INT;
    v_available_places_no INT;
    v_reservation_already_exists INT;
begin
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

    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID , STATUS) VALUES (p_trip_id, p_person_id, 'N');

    COMMIT;
end;


create or replace procedure p_modify_reservation_status_4( p_reservation_id int, p_status char)
as
    v_reservation_exists INT;
    v_old_status char;
    v_free_places INT;
begin
    SELECT COUNT(*) INTO v_reservation_exists FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;
    IF v_reservation_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Podany RESERVATION_ID nie istnieje.');
    END IF;
    SELECT STATUS INTO v_old_status FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;
    IF v_old_status = 'C' THEN
        SELECT AVAILABLE_PLACES_NO INTO v_free_places FROM VW_TRIP
            WHERE TRIP_ID = (SELECT TRIP_ID FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id);
        IF v_free_places = 0 THEN
            RAISE_APPLICATION_ERROR(-20011, 'Brak wolnych miejsc na wycieczce.');
        end if;
    END IF;
    UPDATE RESERVATION SET STATUS = p_status WHERE RESERVATION_ID = p_reservation_id;
    COMMIT;
end;