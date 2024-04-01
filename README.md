

# Oracle PL/Sql

widoki, funkcje, procedury, triggery
ćwiczenie

---


Imiona i nazwiska autorów :

---
<style>
  {
    font-size: 16pt;
  }
</style> 

<style scoped>
 li, p {
    font-size: 14pt;
  }
</style> 

<style scoped>
 pre {
    font-size: 10pt;
  }
</style> 

# Tabele

![](_img/ora-trip1-0.png)


- `Trip`  - wycieczki
	- `trip_id` - identyfikator, klucz główny
	- `trip_name` - nazwa wycieczki
	- `country` - nazwa kraju
	- `trip_date` - data
	- `max_no_places` -  maksymalna liczba miejsc na wycieczkę
- `Person` - osoby
	- `person_id` - identyfikator, klucz główny
	- `firstname` - imię
	- `lastname` - nazwisko


- `Reservation`  - rezerwacje
	- `reservation_id` - identyfikator, klucz główny
	- `trip_id` - identyfikator wycieczki
	- `person_id` - identyfikator osoby
	- `status` - status rezerwacji
		- `N` – New - Nowa
		- `P` – Confirmed and Paid – Potwierdzona  i zapłacona
		- `C` – Canceled - Anulowana
- `Log` - dziennik zmian statusów rezerwacji 
	- `log_id` - identyfikator, klucz główny
	- `reservation_id` - identyfikator rezerwacji
	- `log_date` - data zmiany
	- `status` - status


```sql
create sequence s_person_seq  
   start with 1  
   increment by 1;

create table person  
(  
  person_id int not null
      constraint pk_person  
         primary key,
  firstname varchar(50),  
  lastname varchar(50)
)  

alter table person  
    modify person_id int default s_person_seq.nextval;
   
```


```sql
create sequence s_trip_seq  
   start with 1  
   increment by 1;

create table trip  
(  
  trip_id int  not null
     constraint pk_trip  
         primary key, 
  trip_name varchar(100),  
  country varchar(50),  
  trip_date date,  
  max_no_places int
);  

alter table trip 
    modify trip_id int default s_trip_seq.nextval;
```


```sql
create sequence s_reservation_seq  
   start with 1  
   increment by 1;

create table reservation  
(  
  reservation_id int not null
      constraint pk_reservation  
         primary key, 
  trip_id int,  
  person_id int,  
  status char(1)
);  

alter table reservation 
    modify reservation_id int default s_reservation_seq.nextval;


alter table reservation  
add constraint reservation_fk1 foreign key  
( person_id ) references person ( person_id ); 
  
alter table reservation  
add constraint reservation_fk2 foreign key  
( trip_id ) references trip ( trip_id );  
  
alter table reservation  
add constraint reservation_chk1 check  
(status in ('N','P','C'));

```


```sql
create sequence s_log_seq  
   start with 1  
   increment by 1;


create table log  
(  
    log_id int not null
         constraint pk_log  
         primary key,
    reservation_id int not null,  
    log_date date not null,  
    status char(1)
);  

alter table log 
    modify log_id int default s_log_seq.nextval;
  
alter table log  
add constraint log_chk1 check  
(status in ('N','P','C')) enable;
  
alter table log  
add constraint log_fk1 foreign key  
( reservation_id ) references reservation ( reservation_id );
```


---
# Dane


Należy wypełnić  tabele przykładowymi danymi 
- 4 wycieczki
- 10 osób
- 10  rezerwacji

Dane testowe powinny być różnorodne (wycieczki w przyszłości, wycieczki w przeszłości, rezerwacje o różnym statusie itp.) tak, żeby umożliwić testowanie napisanych procedur.

W razie potrzeby należy zmodyfikować dane tak żeby przetestować różne przypadki.


```sql
-- trip
insert into trip(trip_name, country, trip_date, max_no_places)  
values ('Wycieczka do Paryza', 'Francja', to_date('2023-09-12', 'YYYY-MM-DD'), 3);  
  
insert into trip(trip_name, country, trip_date,  max_no_places)  
values ('Piekny Krakow', 'Polska', to_date('2025-05-03','YYYY-MM-DD'), 2);  
  
insert into trip(trip_name, country, trip_date,  max_no_places)  
values ('Znow do Francji', 'Francja', to_date('2025-05-01','YYYY-MM-DD'), 2);  
  
insert into trip(trip_name, country, trip_date,  max_no_places)  
values ('Hel', 'Polska', to_date('2025-05-01','YYYY-MM-DD'),  2);

-- person
insert into person(firstname, lastname)  
values ('Jan', 'Nowak');  
  
insert into person(firstname, lastname)  
values ('Jan', 'Kowalski');  
  
insert into person(firstname, lastname)  
values ('Jan', 'Nowakowski');  
  
insert into person(firstname, lastname)  
values  ('Novak', 'Nowak');

-- reservation
-- trip1
insert  into reservation(trip_id, person_id, status)  
values (1, 1, 'P');  
  
insert into reservation(trip_id, person_id, status)  
values (1, 2, 'N');  
  
-- trip 2  
insert into reservation(trip_id, person_id, status)  
values (2, 1, 'P');  
  
insert into reservation(trip_id, person_id, status)  
values (2, 4, 'C');  
  
-- trip 3  
insert into reservation(trip_id, person_id, status)  
values (2, 4, 'P');
```

proszę pamiętać o zatwierdzeniu transakcji

---
# Zadanie 0 - modyfikacja danych, transakcje

Należy przeprowadzić kilka eksperymentów związanych ze wstawianiem, modyfikacją i usuwaniem danych
oraz wykorzystaniem transakcji

Skomentuj dzialanie transakcji. Jak działa polecenie `commit`, `rollback`?.
Co się dzieje w przypadku wystąpienia błędów podczas wykonywania transakcji? Porównaj sposób programowania operacji wykorzystujących transakcje w Oracle PL/SQL ze znanym ci systemem/językiem MS Sqlserver T-SQL

pomocne mogą być materiały dostępne tu:
https://upel.agh.edu.pl/mod/folder/view.php?id=214774
w szczególności dokument: `1_modyf.pdf`


```sql

-- przyklady, kod, zrzuty ekranów, komentarz ...

```

---
# Zadanie 1 - widoki


Tworzenie widoków. Należy przygotować kilka widoków ułatwiających dostęp do danych. Należy zwrócić uwagę na strukturę kodu (należy unikać powielania kodu)

Widoki:
-   `vw_reservation`
	- widok łączy dane z tabel: `trip`,  `person`,  `reservation`
	- zwracane dane:  `reservation_id`,  `country`, `trip_date`, `trip_name`, `firstname`, `lastname`, `status`, `trip_id`, `person_id`
- `vw_trip` 
	- widok pokazuje liczbę wolnych miejsc na każdą wycieczkę
	- zwracane dane: `trip_id`, `country`, `trip_date`, `trip_name`, `max_no_places`, `no_available_places` (liczba wolnych miejsc)
-  `vw_available_trip`
	- podobnie jak w poprzednim punkcie, z tym że widok pokazuje jedynie dostępne wycieczki (takie które są w przyszłości i są na nie wolne miejsca)


Proponowany zestaw widoków można rozbudować wedle uznania/potrzeb
- np. można dodać nowe/pomocnicze widoki
- np. można zmienić def. widoków, dodając nowe/potrzebne pola

# Zadanie 1  - rozwiązanie

```sql

-- wyniki, kod, zrzuty ekranów, komentarz ...



```



---
# Zadanie 2  - funkcje


Tworzenie funkcji pobierających dane/tabele. Podobnie jak w poprzednim przykładzie należy przygotować kilka funkcji ułatwiających dostęp do danych

Procedury:
- `f_trip_participants`
	- zadaniem funkcji jest zwrócenie listy uczestników wskazanej wycieczki
	- parametry funkcji: `trip_id`
	- funkcja zwraca podobny zestaw danych jak widok  `vw_eservation`
-  `f_person_reservations`
	- zadaniem funkcji jest zwrócenie listy rezerwacji danej osoby 
	- parametry funkcji: `person_id`
	- funkcja zwraca podobny zestaw danych jak widok `vw_reservation`
-  `f_available_trips_to`
	- zadaniem funkcji jest zwrócenie listy wycieczek do wskazanego kraju, dostępnych w zadanym okresie czasu (od `date_from` do `date_to`)
	- parametry funkcji: `country`, `date_from`, `date_to`


Funkcje powinny zwracać tabelę/zbiór wynikowy. Należy rozważyć dodanie kontroli parametrów, (np. jeśli parametrem jest `trip_id` to można sprawdzić czy taka wycieczka istnieje). Podobnie jak w przypadku widoków należy zwrócić uwagę na strukturę kodu

Czy kontrola parametrów w przypadku funkcji ma sens?
- jakie są zalety/wady takiego rozwiązania?

Proponowany zestaw funkcji można rozbudować wedle uznania/potrzeb
- np. można dodać nowe/pomocnicze funkcje/procedury

# Zadanie 2  - rozwiązanie

```sql

-- wyniki, kod, zrzuty ekranów, komentarz ...

```


---
# Zadanie 3  - procedury


Tworzenie procedur modyfikujących dane. Należy przygotować zestaw procedur pozwalających na modyfikację danych oraz kontrolę poprawności ich wprowadzania

Procedury
- `p_add_reservation`
	- zadaniem procedury jest dopisanie nowej rezerwacji
	- parametry: `trip_id`, `person_id`, 
	- procedura powinna kontrolować czy wycieczka jeszcze się nie odbyła, i czy sa wolne miejsca
	- procedura powinna również dopisywać inf. do tabeli `log`
- `p_modify_reservation_tatus`
	- zadaniem procedury jest zmiana statusu rezerwacji 
	- parametry: `reservation_id`, `status` 
	- procedura powinna kontrolować czy możliwa jest zmiana statusu, np. zmiana statusu już anulowanej wycieczki (przywrócenie do stanu aktywnego nie zawsze jest możliwa – może już nie być miejsc)
	- procedura powinna również dopisywać inf. do tabeli `log`


Procedury:
- `p_modify_max_no_places`
	- zadaniem procedury jest zmiana maksymalnej liczby miejsc na daną wycieczkę 
	- parametry: `trip_id`, `max_no_places`
	- nie wszystkie zmiany liczby miejsc są dozwolone, nie można zmniejszyć liczby miejsc na wartość poniżej liczby zarezerwowanych miejsc

Należy rozważyć użycie transakcji

Należy zwrócić uwagę na kontrolę parametrów (np. jeśli parametrem jest trip_id to należy sprawdzić czy taka wycieczka istnieje, jeśli robimy rezerwację to należy sprawdzać czy są wolne miejsca itp..)


Proponowany zestaw procedur można rozbudować wedle uznania/potrzeb
- np. można dodać nowe/pomocnicze funkcje/procedury

# Zadanie 3  - rozwiązanie

```sql

-- wyniki, kod, zrzuty ekranów, komentarz ...

```



---
# Zadanie 4  - triggery


Zmiana strategii zapisywania do dziennika rezerwacji. Realizacja przy pomocy triggerów

Należy wprowadzić zmianę, która spowoduje, że zapis do dziennika rezerwacji będzie realizowany przy pomocy trierów

Triggery:
- trigger/triggery obsługujące 
	- dodanie rezerwacji
	- zmianę statusu
- trigger zabraniający usunięcia rezerwacji

Oczywiście po wprowadzeniu tej zmiany należy "uaktualnić" procedury modyfikujące dane. 

>UWAGA
Należy stworzyć nowe wersje tych procedur (dodając do nazwy dopisek 4 - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu  umożliwienia weryfikacji ich poprawności

Należy przygotować procedury: `p_add_reservation_4`, `p_modify_reservation_status_4` 


# Zadanie 4  - rozwiązanie

```
--Trigger dodający logi do dziennika odnośnie właśnie dodanej rezerwacji
create or replace trigger t_log_added_reservation
after insert on RESERVATION
for each row
declare
	--Zapewnienie triggerowi niezależnej tranzakcji
	pragma autonomous_transaction;
begin
    --Walidacja danych nie jest przeprowadzana, bo zakładamy, że dokonuje się to w ciele procedury
    Insert into LOG (RESERVATION_ID, LOG_DATE, STATUS) VALUES (:NEW.reservation_id, SYSDATE, 'N');
end;


--Trigger dodający logi do dziennika odnośnie zmiany statusu rezerwacji
create or replace trigger t_log_changed_status
after update on RESERVATION
for each row
declare
	--Zapewnienie triggerowi niezależnej tranzakcji
	pragma autonomous_transaction;
begin
    --Walidacja danych nie jest przeprowadzana, bo zakładamy, że dokonuje się to w ciele procedury
    Insert into LOG (RESERVATION_ID, LOG_DATE, STATUS) VALUES (:NEW.RESERVATION_ID, SYSDATE, :NEW.STATUS);
end;

--Trigger powstrzymujący przed usunięciem rezerwacji z bazy danych
create or replace trigger t_prevent_reservation_deletion_trigger
before delete on RESERVATION
for each row
begin
    RAISE_APPLICATION_ERROR(-20022, 'Nie można usunąć rezerwacji. ');
end;

--Zmienione procedury w wyniku przeniesienia części ich kodu do triggerów
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
```

---
# Zadanie 5  - triggery


Zmiana strategii kontroli dostępności miejsc. Realizacja przy pomocy triggerów

Należy wprowadzić zmianę, która spowoduje, że kontrola dostępności miejsc na wycieczki (przy dodawaniu nowej rezerwacji, zmianie statusu) będzie realizowana przy pomocy trierów

Triggery:
- Trigger/triggery obsługujące: 
	- dodanie rezerwacji
	- zmianę statusu

Oczywiście po wprowadzeniu tej zmiany należy "uaktualnić" procedury modyfikujące dane. 

>UWAGA
Należy stworzyć nowe wersje tych procedur (np. dodając do nazwy dopisek 5 - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu  umożliwienia weryfikacji ich poprawności. 

Należy przygotować procedury: `p_add_reservation_5`, `p_modify_reservation_status_5`


# Zadanie 5  - rozwiązanie

```
--  triggery zapewniające walidację danych do P_ADD_RESERVATION

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

--  triggery zapewniające walidację danych do P_MODIFY_RESERVATION_STATUS
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

--Zmienione procedury w wyniku przeniesienia części ich kodu do triggerów (zarówno z 4 jak i 5 zadania)
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

```

---
# Zadanie 6


Zmiana struktury bazy danych. W tabeli `trip`  należy dodać  redundantne pole `no_available_places`.  Dodanie redundantnego pola uprości kontrolę dostępnych miejsc, ale nieco skomplikuje procedury dodawania rezerwacji, zmiany statusu czy też zmiany maksymalnej liczby miejsc na wycieczki.

Należy przygotować polecenie/procedurę przeliczającą wartość pola `no_available_places` dla wszystkich wycieczek (do jednorazowego wykonania)

Obsługę pola `no_available_places` można zrealizować przy pomocy procedur lub triggerów

Należy zwrócić uwagę na spójność rozwiązania.

>UWAGA
Należy stworzyć nowe wersje tych widoków/procedur/triggerów (np. dodając do nazwy dopisek 6 - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu  umożliwienia weryfikacji ich poprawności. 


- zmiana struktury tabeli

```sql
alter table trip add  
    no_available_places int null
```

- polecenie przeliczające wartość `no_available_places`
	- należy wykonać operację "przeliczenia"  liczby wolnych miejsc i aktualizacji pola  `no_available_places`

# Zadanie 6  - rozwiązanie

```sql

-- wyniki, kod, zrzuty ekranów, komentarz ...

```



---
# Zadanie 6a  - procedury



Obsługę pola `no_available_places` należy zrealizować przy pomocy procedur
- procedura dodająca rezerwację powinna aktualizować pole `no_available_places` w tabeli trip
- podobnie procedury odpowiedzialne za zmianę statusu oraz zmianę maksymalnej liczby miejsc na wycieczkę
- należy przygotować procedury oraz jeśli jest to potrzebne, zaktualizować triggery oraz widoki



>UWAGA
Należy stworzyć nowe wersje tych widoków/procedur/triggerów (np. dodając do nazwy dopisek 6a - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu  umożliwienia weryfikacji ich poprawności. 
- może  być potrzebne wyłączenie 'poprzednich wersji' triggerów 


# Zadanie 6a  - rozwiązanie

```sql

-- wyniki, kod, zrzuty ekranów, komentarz ...

```



---
# Zadanie 6b -  triggery


Obsługę pola `no_available_places` należy zrealizować przy pomocy triggerów
- podczas dodawania rezerwacji trigger powinien aktualizować pole `no_available_places` w tabeli trip
- podobnie, podczas zmiany statusu rezerwacji
- należy przygotować trigger/triggery oraz jeśli jest to potrzebne, zaktualizować procedury modyfikujące dane oraz widoki


>UWAGA
Należy stworzyć nowe wersje tych widoków/procedur/triggerów (np. dodając do nazwy dopisek 6b - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu  umożliwienia weryfikacji ich poprawności. 
- może  być potrzebne wyłączenie 'poprzednich wersji' triggerów 



# Zadanie 6b  - rozwiązanie


```sql

-- wyniki, kod, zrzuty ekranów, komentarz ...

```


# Zadanie 7 - podsumowanie

Porównaj sposób programowania w systemie Oracle PL/SQL ze znanym ci systemem/językiem MS Sqlserver T-SQL

```sql

-- komentarz ...

```
