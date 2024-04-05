create or replace trigger t_log_added_reservation
after insert on RESERVATION
for each row
declare
begin
    --Walidacja danych nie jest przeprowadzana, bo zakładamy, że dokonuje się to w ciele procedury
    Insert into LOG (RESERVATION_ID, LOG_DATE, STATUS) VALUES (:NEW.reservation_id, SYSDATE, 'N');
end;


create or replace trigger t_log_changed_status
after update on RESERVATION
for each row
begin
    --Walidacja danych nie jest przeprowadzana, bo zakładamy, że dokonuje się to w ciele procedury
    Insert into LOG (RESERVATION_ID, LOG_DATE, STATUS) VALUES (:NEW.RESERVATION_ID, SYSDATE, :NEW.STATUS);
end;


create or replace trigger t_prevent_reservation_deletion_trigger
before delete on RESERVATION
for each row
begin
    RAISE_APPLICATION_ERROR(-20022, 'Nie można usunąć rezerwacji. ');
end;

