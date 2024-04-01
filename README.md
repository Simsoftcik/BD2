# Oracle PL/Sql

widoki, funkcje, procedury, triggery
ćwiczenie

---

Imiona i nazwiska autorów :

- Bartłomiej Szubiak
- Szymon Kubiczek
- Konrad Armatys

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

- `Trip` - wycieczki
  - `trip_id` - identyfikator, klucz główny
  - `trip_name` - nazwa wycieczki
  - `country` - nazwa kraju
  - `trip_date` - data
  - `max_no_places` - maksymalna liczba miejsc na wycieczkę
- `Person` - osoby

  - `person_id` - identyfikator, klucz główny
  - `firstname` - imię
  - `lastname` - nazwisko

- `Reservation` - rezerwacje
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

Należy wypełnić tabele przykładowymi danymi

- 4 wycieczki
- 10 osób
- 10 rezerwacji

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

insert into person(firstname, lastname)
values ('Jan', 'Owalski');

insert into person(firstname, lastname)
values ('Anna', 'Nowak');

insert into person(firstname, lastname)
values ('Adam', 'Wiśniewski');

insert into person(firstname, lastname)
values ('Katarzyna', 'Kowalczyk');

insert into person(firstname, lastname)
values ('Piotr', 'Lewandowski');

insert into person(firstname, lastname)
values ('Małgorzata', 'Wójcik');


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

-- trip 4
insert into reservation(trip_id, person_id, status)
values (2, 10, 'N');

-- trip 5
insert into reservation(trip_id, person_id, status)
values (1, 8, 'C');

-- trip 6
insert into reservation(trip_id, person_id, status)
values (1, 7, 'N');

-- trip 7
insert into reservation(trip_id, person_id, status)
values (4, 7, 'P');

-- trip 8
insert into reservation(trip_id, person_id, status)
values (2, 2, 'P');

-- trip 9
insert into reservation(trip_id, person_id, status)
values (4, 4, 'N');

-- trip 10
insert into reservation(trip_id, person_id, status)
values (3, 6, 'N');

```

---

# Zadanie 0 - modyfikacja danych, transakcje

Należy przeprowadzić kilka eksperymentów związanych ze wstawianiem, modyfikacją i usuwaniem danych
oraz wykorzystaniem transakcji

Skomentuj dzialanie transakcji. Jak działa polecenie `commit`, `rollback`?.
Co się dzieje w przypadku wystąpienia błędów podczas wykonywania transakcji? Porównaj sposób programowania operacji wykorzystujących transakcje w Oracle PL/SQL ze znanym ci systemem/językiem MS Sqlserver T-SQL

pomocne mogą być materiały dostępne tu:
https://upel.agh.edu.pl/mod/folder/view.php?id=214774
w szczególności dokument: `1_modyf.pdf`

---

---

Transakcje pozwalają na grupowanie operacji bazodanowych w logiczne jednostki i zapewniające integralność danych.

Polecenia `COMMIT` i `ROLLBACK` są kluczowymi elementami transakcji:

z zasadą ACID:

- A - Atomicity - niepodzielnosć
- C - Consistency - spojność
- I - Isolation - izolacja, niezaleznosć
- D - Durability - trwałosć

`Commit`: używane do zatwierdzenia transakcji, co oznacza, że wszystkie zmiany dokonane w ramach tej transakcji zostaną trwale zapisane w bazie danych.

`Rollback`: używane do cofnięcia transakcji (zerwania), czyli przywrócenia bazy danych do stanu sprzed rozpoczęcia transakcji. Wszystkie zmiany dokonane w ramach tej transakcji są anulowane, a baza danych wraca do poprzedniego stanu.

Jeśli wystąpią błędy podczas transakcji, transakcja nie zostanie zatwierdzona. Wszystkie zmiany dokonane w ramach tej transakcji zostaną anulowane.

Jeśli błąd nie zostanie obsłużony w bloku PL/SQL, automatycznie zostanie wykonane polecenie `ROLLBACK`.

---

## Różnice pomiędzy Oracle SQL a MS Sqlserver pod względem operacji:

Oracle PL/SQL:

- Transakcje są domyślnie otwarte po wykonaniu dowolnego polecenia SQL, które modyfikuje dane.
- Transakcje są zamykane przez polecenia `COMMIT` lub `ROLLBACK`.
- Jeśli wystąpi błąd podczas transakcji, wszystkie zmiany są automatycznie cofane.

MS SQL Server T-SQL:

- Transakcje muszą być wyraźnie otwarte za pomocą polecenia BEGIN TRANSACTION.

przykład:

```sql
-- Oracle PL/SQL:
INSERT INTO employees (id, name, department) VALUES (1, 'John Doe', 'Sales');
COMMIT;

-- MS SQL Server T-SQL:
BEGIN TRANSACTION;
INSERT INTO employees (id, name, department) VALUES (1, 'John Doe', 'Sales');
COMMIT;

```

---

# Zadanie 1 - widoki

Tworzenie widoków. Należy przygotować kilka widoków ułatwiających dostęp do danych. Należy zwrócić uwagę na strukturę kodu (należy unikać powielania kodu)

Widoki:

- `vw_reservation`
  - widok łączy dane z tabel: `trip`, `person`, `reservation`
  - zwracane dane: `reservation_id`, `country`, `trip_date`, `trip_name`, `firstname`, `lastname`, `status`, `trip_id`, `person_id`
- `vw_trip`
  - widok pokazuje liczbę wolnych miejsc na każdą wycieczkę
  - zwracane dane: `trip_id`, `country`, `trip_date`, `trip_name`, `max_no_places`, `no_available_places` (liczba wolnych miejsc)
- `vw_available_trip`
  - podobnie jak w poprzednim punkcie, z tym że widok pokazuje jedynie dostępne wycieczki (takie które są w przyszłości i są na nie wolne miejsca)

Proponowany zestaw widoków można rozbudować wedle uznania/potrzeb

- np. można dodać nowe/pomocnicze widoki
- np. można zmienić def. widoków, dodając nowe/potrzebne pola

# Zadanie 1 - rozwiązanie

```sql
create or replace view vw_reservationd
as
select
    reservation.reservation_id,
    trip.country,
    trip.trip_date,
    trip.trip_name,
    person.firstname,
    person.lastname,
    reservation.status,
    reservation.trip_id,
    reservation.person_id
    from person
join reservation on person.person_id = reservation.person_id
join trip on reservation.trip_id = trip.trip_id;

-- #trip join (trip_id, cnt -> ilosc rekordow co maja trip_id to samo)

create or replace view vw_trip_enrolled_no
as
select
    trip_id,
    count(trip_id) as cnt
    from reservation
where status = 'N' or status = 'P'
group by trip_id;

create or replace view vw_trip
as
select
    trip.trip_id,
    trip.country,
    trip.trip_date,
    trip.trip_name,
    trip.max_no_places,
    (trip.max_no_places - coalesce(vw_trip_enrolled_no.cnt , 0) ) as available_places_no
    from trip
left join vw_trip_enrolled_no on trip.trip_id = vw_trip_enrolled_no.trip_id;

create or replace view vw_available_trip
as
    select * from vw_trip
    where available_places_no > 0 and trip_date > sysdate;
```

---

# Zadanie 2 - funkcje

Tworzenie funkcji pobierających dane/tabele. Podobnie jak w poprzednim przykładzie należy przygotować kilka funkcji ułatwiających dostęp do danych

Procedury:

- `f_trip_participants`
  - zadaniem funkcji jest zwrócenie listy uczestników wskazanej wycieczki
  - parametry funkcji: `trip_id`
  - funkcja zwraca podobny zestaw danych jak widok `vw_eservation`
- `f_person_reservations`
  - zadaniem funkcji jest zwrócenie listy rezerwacji danej osoby
  - parametry funkcji: `person_id`
  - funkcja zwraca podobny zestaw danych jak widok `vw_reservation`
- `f_available_trips_to`
  - zadaniem funkcji jest zwrócenie listy wycieczek do wskazanego kraju, dostępnych w zadanym okresie czasu (od `date_from` do `date_to`)
  - parametry funkcji: `country`, `date_from`, `date_to`

Funkcje powinny zwracać tabelę/zbiór wynikowy. Należy rozważyć dodanie kontroli parametrów, (np. jeśli parametrem jest `trip_id` to można sprawdzić czy taka wycieczka istnieje). Podobnie jak w przypadku widoków należy zwrócić uwagę na strukturę kodu

Czy kontrola parametrów w przypadku funkcji ma sens?

- jakie są zalety/wady takiego rozwiązania?

Proponowany zestaw funkcji można rozbudować wedle uznania/potrzeb

- np. można dodać nowe/pomocnicze funkcje/procedury

# Zadanie 2 - rozwiązanie

```sql
create or replace type trip_participants_row as object
(
    trip_date date,
    trip_name varchar2(100),
    country varchar2(50),
    firstname varchar2(50),
    lastname varchar2(50),
    status char,
    person_id int,
    reservation_id int
);

create or replace type trip_participants_table is table of trip_participants_row;

create or replace function f_trip_participants(p_trip_id int)
    return trip_participants_table
as
    result trip_participants_table;
begin
    select trip_participants_row(
        trip_date,
        trip_name,
        country,
        firstname,
        lastname,
        status,
        person_id,
        reservation_id
        )
    bulk collect
    into result
    from vw_reservation
    where trip_id = p_trip_id;

    return result;
end;

-- przykladowe wywolanie
select * from table(f_trip_participants(1));


create or replace type person_reservations_row as object
(
    trip_date date,
    trip_name varchar2(100),
    country varchar2(50),
    firstname varchar2(50),
    lastname varchar2(50),
    status char,
    reservation_id int,
    trip_id int
);

create or replace type person_reservations_table is table of person_reservations_row;

create or replace function f_person_reservations(p_person_id int)
    return person_reservations_table
as
    result person_reservations_table;
begin
    select person_reservations_row(
        trip_date,
        trip_name,
        country,
        firstname,
        lastname,
        status,
        reservation_id,
        trip_id
        )
    bulk collect
    into result
    from vw_reservation
    where person_id = p_person_id;

    return result;
end;

-- przykladowe wywolanie
select * from table(f_person_reservations(1));

create or replace type available_trips_row as object
(
    trip_id int,
    country varchar2(50),
    trip_date date,
    trip_name varchar2(100),
    max_no_places int,
    available_places_no int
);

create or replace type available_trips_table is table of available_trips_row;

create or replace function f_available_trips(p_country varchar2(50), p_date_from date, p_date_to date)
    return available_trips_table
as
    result available_trips_table;
begin
    select available_trips_row(
        trip_id,
        country,
        trip_date,
        trip_name,
        max_no_places,
        available_places_no
        )
    bulk collect
    into result
    from vw_trip
    where country = p_country and trip_date between p_date_from and p_date_to;

    return result;
end;

```

---

# Zadanie 3 - procedury

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

# Zadanie 3 - rozwiązanie

```sql
create or replace procedure p_add_reservation(p_trip_id int, p_person_id int)
as
    v_trip_exists int;
    v_person_exists int;
    v_available_places_no int;
    v_reservation_already_exists int;
begin
-- kontrola wejscia
    -- sprawdzenie, czy podany p_trip_id istnieje w tabeli trip
    select count(*) into v_trip_exists from trip where trip_id = p_trip_id;

    if v_trip_exists = 0 then
        raise_application_error(-20001, 'Podany trip_id nie istnieje.');
    end if;

    -- sprawdzenie, czy podany p_person_id istnieje w tabeli person
    select count(*) into v_person_exists from person where person_id = p_person_id;

    if v_person_exists = 0 then
        raise_application_error(-20002, 'Podany person_id nie istnieje.');
    end if;

    select available_places_no into v_available_places_no from vw_trip where trip_id = p_trip_id;

    if v_available_places_no = 0 then
        raise_application_error(-20003, 'Brak wolnych miejsc na wycieczce.');
    end if;

    select count(*) into v_reservation_already_exists from reservation where trip_id = p_trip_id and person_id = p_person_id;
    if v_reservation_already_exists > 0 then
        raise_application_error(-20004, 'Osoba o podanym person_id jest juz zapisana na wycieczke o podanym trip_id.');
    end if;

    insert into reservation (trip_id, person_id , status) values (p_trip_id, p_person_id, 'N');

    insert into log (reservation_id, log_date, status) values ("s_log_seq".currval, sysdate, 'N');

    commit;
end;

create or replace procedure p_modify_reservation_status( p_reservation_id int, p_status char)
as
    v_reservation_exists int;
    v_old_status char;
    v_free_places int;
begin
    -- sprawdzenie, czy podany reservation_id istnieje w tabeli reservation
    select count(*) into v_reservation_exists from reservation where reservation_id = p_reservation_id;

    if v_reservation_exists = 0 then
        raise_application_error(-20010, 'Podany reservation_id nie istnieje.');
    end if;

    select status into v_old_status from reservation where reservation_id = p_reservation_id;

    if v_old_status = 'C' then
        -- sprawdzenie czy da sie zapisac na wycieczke
        select available_places_no into v_free_places from vw_trip
            where trip_id = (select trip_id from reservation where reservation_id = p_reservation_id);

        if v_free_places = 0 then
            raise_application_error(-20011, 'Brak wolnych miejsc na wycieczce.');
        end if;
    end if;

    -- zmiana statusu
    update reservation set status = p_status where reservation_id = p_reservation_id;

    -- wpisanie do dziennika
    insert into log (reservation_id, log_date, status) values (p_reservation_id, sysdate, p_status);

    commit;
end;


create or replace procedure p_modify_max_no_places( p_trip_id int, p_max_no_places int)
as
    v_trip_exists int;
    v_curr_occupied_places int;
begin
    -- sprawdzenie, czy podany trip_id istnieje w tabeli trip
    select count(*) into v_trip_exists from trip where trip_id = p_trip_id;

    if v_trip_exists = 0 then
        raise_application_error(-20020, 'Podany trip_id nie istnieje.');
    end if;

    -- sprawdzenie, czy podany max_no_places jest wiekszy od obecnej liczby zapisanych osob
    select cnt into v_curr_occupied_places from vw_trip_enrolled_no where trip_id = p_trip_id;

    if p_max_no_places < v_curr_occupied_places then
        raise_application_error(-20021, 'Podana liczba miejsc jest mniejsza od obecnej liczby zapisanych osob.');
    end if;

    -- zmiana liczby miejsc
    update trip set max_no_places = p_max_no_places where trip_id = p_trip_id;

    commit;
end;
```

---

# Zadanie 4 - triggery

Zmiana strategii zapisywania do dziennika rezerwacji. Realizacja przy pomocy triggerów

Należy wprowadzić zmianę, która spowoduje, że zapis do dziennika rezerwacji będzie realizowany przy pomocy trierów

Triggery:

- trigger/triggery obsługujące
  - dodanie rezerwacji
  - zmianę statusu
- trigger zabraniający usunięcia rezerwacji

Oczywiście po wprowadzeniu tej zmiany należy "uaktualnić" procedury modyfikujące dane.

> UWAGA
> Należy stworzyć nowe wersje tych procedur (dodając do nazwy dopisek 4 - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu umożliwienia weryfikacji ich poprawności

Należy przygotować procedury: `p_add_reservation_4`, `p_modify_reservation_status_4`

# Zadanie 4 - rozwiązanie

```sql
--trigger dodający logi do dziennika odnośnie właśnie dodanej rezerwacji
create or replace trigger t_log_added_reservation
after insert on reservation
for each row
declare
	--zapewnienie triggerowi niezależnej tranzakcji
	pragma autonomous_transaction;
begin
    --walidacja danych nie jest przeprowadzana, bo zakładamy, że dokonuje się to w ciele procedury
    insert into log (reservation_id, log_date, status) values (:new.reservation_id, sysdate, 'n');
end;


--trigger dodający logi do dziennika odnośnie zmiany statusu rezerwacji
create or replace trigger t_log_changed_status
after update on reservation
for each row
declare
	--zapewnienie triggerowi niezależnej tranzakcji
	pragma autonomous_transaction;
begin
    --walidacja danych nie jest przeprowadzana, bo zakładamy, że dokonuje się to w ciele procedury
    insert into log (reservation_id, log_date, status) values (:new.reservation_id, sysdate, :new.status);
end;

--trigger powstrzymujący przed usunięciem rezerwacji z bazy danych
create or replace trigger t_prevent_reservation_deletion_trigger
before delete on reservation
for each row
begin
    raise_application_error(-20022, 'Nie można usunąć rezerwacji. ');
end;

--zmienione procedury w wyniku przeniesienia części ich kodu do triggerów
create or replace procedure p_add_reservation_4(p_trip_id int, p_person_id int)
as
    v_trip_exists int;
    v_person_exists int;
    v_available_places_no int;
    v_reservation_already_exists int;
begin
    select count(*) into v_trip_exists from trip where trip_id = p_trip_id;
    if v_trip_exists = 0 then
        raise_application_error(-20001, 'Podany trip_id nie istnieje.');
    end if;
    select count(*) into v_person_exists from person where person_id = p_person_id;
    if v_person_exists = 0 then
        raise_application_error(-20002, 'Podany person_id nie istnieje.');
    end if;
    select available_places_no into v_available_places_no from vw_trip where trip_id = p_trip_id;
    if v_available_places_no = 0 then
        raise_application_error(-20003, 'Brak wolnych miejsc na wycieczce.');
    end if;
    select count(*) into v_reservation_already_exists from reservation where trip_id = p_trip_id and person_id = p_person_id;
    if v_reservation_already_exists > 0 then
        raise_application_error(-20004, 'Osoba o podanym person_id jest juz zapisana na wycieczke o podanym trip_id.');
    end if;

    insert into reservation (trip_id, person_id , status) values (p_trip_id, p_person_id, 'n');

    commit;
end;


create or replace procedure p_modify_reservation_status_4( p_reservation_id int, p_status char)
as
    v_reservation_exists int;
    v_old_status char;
    v_free_places int;
begin
    select count(*) into v_reservation_exists from reservation where reservation_id = p_reservation_id;
    if v_reservation_exists = 0 then
        raise_application_error(-20010, 'Podany reservation_id nie istnieje.');
    end if;
    select status into v_old_status from reservation where reservation_id = p_reservation_id;
    if v_old_status = 'c' then
        select available_places_no into v_free_places from vw_trip
            where trip_id = (select trip_id from reservation where reservation_id = p_reservation_id);
        if v_free_places = 0 then
            raise_application_error(-20011, 'Brak wolnych miejsc na wycieczce.');
        end if;
    end if;
    update reservation set status = p_status where reservation_id = p_reservation_id;
    commit;
end;
```

---

# Zadanie 5 - triggery

Zmiana strategii kontroli dostępności miejsc. Realizacja przy pomocy triggerów

Należy wprowadzić zmianę, która spowoduje, że kontrola dostępności miejsc na wycieczki (przy dodawaniu nowej rezerwacji, zmianie statusu) będzie realizowana przy pomocy trierów

Triggery:

- Trigger/triggery obsługujące:
  - dodanie rezerwacji
  - zmianę statusu

Oczywiście po wprowadzeniu tej zmiany należy "uaktualnić" procedury modyfikujące dane.

> UWAGA
> Należy stworzyć nowe wersje tych procedur (np. dodając do nazwy dopisek 5 - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu umożliwienia weryfikacji ich poprawności.

Należy przygotować procedury: `p_add_reservation_5`, `p_modify_reservation_status_5`

# Zadanie 5 - rozwiązanie

```sql
--  triggery zapewniające walidację danych do p_add_reservation_5
create or replace trigger t_check_available_places_on_trip
before insert on reservation
for each row
declare
    v_available_places_no int;
begin
    select available_places_no into v_available_places_no from vw_trip where trip_id = :new.trip_id;

    if v_available_places_no = 0 then
        raise_application_error(-20003, 'Brak wolnych miejsc na wycieczce.');
    end if;
end;

create or replace trigger t_check_reservation_already_exists
before insert on reservation
for each row
declare
    v_reservation_already_exists int;
begin
    select count(*) into v_reservation_already_exists from reservation where trip_id = new.trip_id and person_id = :new.person_id;
    if v_reservation_already_exists > 0 then
        raise_application_error(-20004, 'Osoba o podanym person_id jest juz zapisana na wycieczke o podanym trip_id.');
    end if;
end;

create or replace trigger t_validate_add_reservation_input
before insert on reservation
for each row
declare
    v_trip_exists int;
    v_person_exists int;
begin
    select count(*) into v_trip_exists from trip where trip_id = :new.trip_id;
    if v_trip_exists = 0 then
        raise_application_error(-20001, 'Podany trip_id nie istnieje.');
    end if;
    select count(*) into v_person_exists from person where person_id = :new.person_id;
    if v_person_exists = 0 then
        raise_application_error(-20002, 'Podany person_id nie istnieje.');
    end if;
end;

--  triggery zapewniające walidację danych do p_modify_reservation_status_5
create or replace trigger t_validate_modify_reservation_status_input
before insert on reservation
for each row
declare
    v_reservation_exists int;
begin
    select count(*) into v_reservation_exists from reservation where reservation_id = :new.reservation_id;
    if v_reservation_exists = 0 then
        raise_application_error(-20010, 'Podany reservation_id nie istnieje.');
    end if;
end;

create or replace trigger t_check_if_reservation_already_cancelled
before update on reservation
for each row
declare
    v_old_status char;
    v_free_places int;
begin
    select status into v_old_status from reservation where reservation_id = :new.reservation_id;

    if v_old_status = 'c' then
        select available_places_no into v_free_places from vw_trip
            where trip_id = (select trip_id from reservation where reservation_id = :new.reservation_id);

        if v_free_places = 0 then
            raise_application_error(-20011, 'Brak wolnych miejsc na wycieczce.');
        end if;
    end if;
end;

--Zmienione procedury w wyniku przeniesienia części ich kodu do triggerów (zarówno z 4 jak i 5 zadania)
create or replace procedure p_add_reservation_5(p_trip_id int, p_person_id int)
as
begin
    insert into reservation (trip_id, person_id , status) values (p_trip_id, p_person_id, 'n');
    commit;
end;


create or replace procedure p_modify_reservation_status_5( p_reservation_id int, p_status char)
as
begin
    update reservation set status = p_status where reservation_id = p_reservation_id;
    commit;
end;

```

---

# Zadanie 6

Zmiana struktury bazy danych. W tabeli `trip` należy dodać redundantne pole `no_available_places`. Dodanie redundantnego pola uprości kontrolę dostępnych miejsc, ale nieco skomplikuje procedury dodawania rezerwacji, zmiany statusu czy też zmiany maksymalnej liczby miejsc na wycieczki.

Należy przygotować polecenie/procedurę przeliczającą wartość pola `no_available_places` dla wszystkich wycieczek (do jednorazowego wykonania)

Obsługę pola `no_available_places` można zrealizować przy pomocy procedur lub triggerów

Należy zwrócić uwagę na spójność rozwiązania.

> UWAGA
> Należy stworzyć nowe wersje tych widoków/procedur/triggerów (np. dodając do nazwy dopisek 6 - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu umożliwienia weryfikacji ich poprawności.

- zmiana struktury tabeli

```sql
alter table trip add
    no_available_places int null
```

- polecenie przeliczające wartość `no_available_places`
  - należy wykonać operację "przeliczenia" liczby wolnych miejsc i aktualizacji pola `no_available_places`

# Zadanie 6 - rozwiązanie

```sql

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

```

---

# Zadanie 6a - procedury

Obsługę pola `no_available_places` należy zrealizować przy pomocy procedur

- procedura dodająca rezerwację powinna aktualizować pole `no_available_places` w tabeli trip
- podobnie procedury odpowiedzialne za zmianę statusu oraz zmianę maksymalnej liczby miejsc na wycieczkę
- należy przygotować procedury oraz jeśli jest to potrzebne, zaktualizować triggery oraz widoki

> UWAGA
> Należy stworzyć nowe wersje tych widoków/procedur/triggerów (np. dodając do nazwy dopisek 6a - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu umożliwienia weryfikacji ich poprawności.

- może być potrzebne wyłączenie 'poprzednich wersji' triggerów

# Zadanie 6a - rozwiązanie

```sql

create or replace procedure p_add_reservation_6(p_trip_id int, p_person_id int)
as
begin
    INSERT INTO RESERVATION (TRIP_ID, PERSON_ID , STATUS) VALUES (p_trip_id, p_person_id, 'N');

    UPDATE TRIP
    SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - 1
    WHERE TRIP_ID = p_trip_id;

    COMMIT;
end;


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

```

---

# Zadanie 6b - triggery

Obsługę pola `no_available_places` należy zrealizować przy pomocy triggerów

- podczas dodawania rezerwacji trigger powinien aktualizować pole `no_available_places` w tabeli trip
- podobnie, podczas zmiany statusu rezerwacji
- należy przygotować trigger/triggery oraz jeśli jest to potrzebne, zaktualizować procedury modyfikujące dane oraz widoki

> UWAGA
> Należy stworzyć nowe wersje tych widoków/procedur/triggerów (np. dodając do nazwy dopisek 6b - od numeru zadania). Poprzednie wersje procedur należy pozostawić w celu umożliwienia weryfikacji ich poprawności.

- może być potrzebne wyłączenie 'poprzednich wersji' triggerów

# Zadanie 6b - rozwiązanie

```sql

--  trigger do P_ADD_RESERVATION
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

--  trigger do P_MODIFY_RESERVATION_STATUS
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

-- widok wycieczki
create or replace view vw_trip_6
as
select
    TRIP.TRIP_ID,
    TRIP.COUNTRY,
    TRIP.TRIP_DATE,
    TRIP.TRIP_NAME,
    TRIP.MAX_NO_PLACES,
    TRIP.NO_AVAILABLE_PLACES as AVAILABLE_PLACES_NO
    from TRIP
left join vw_trip_enrolled_no on TRIP.TRIP_ID = vw_trip_enrolled_no.trip_id;

```

# Zadanie 7 - podsumowanie

Porównaj sposób programowania w systemie Oracle PL/SQL ze znanym ci systemem/językiem MS Sqlserver T-SQL

---

---

Różnice:

1. Platformy różnią się skłądnią. Na przykład, Oracle PL/SQL używa słowa kluczowego _AS_ do oznaczenia bloku kodu, podczas gdy T-SQL nie wymaga tego słowa kluczowego. Ponadto, Oracle PL/SQL używa operatora _:=_ do przypisywania wartości, podczas gdy T-SQL używa operatora _=_.

2. Deklarowanie i przypisywanie. W T-SQL stosuje sie _@_ jako przedrostek zmiennych:

```sql
-- T-SQL
-- deklaracja:
@startDate DATETIME,

--użycie:
endDate = @startDate

-- Oracle PL/SQL
-- deklaracja:
startDate DATE;

--użycie:
endDate := startDate;

```

3. W Oracle PL/SQL wymagane jest zadeklarowanie obiektu tabeli/wiersza zwracanego z procedury/funkcji, w T-SQL nie.

4. Wygląd i budowa trigerrów.

5. Stosowanie transakcji.

6. Dialekty posiadają unikalne funkcje. Na przykład:
   - PL/SQL: `SELECT wartość INTO zmienna`
   - T-SQL: `TRY niebezpieczny kod CATCH wyjątek`

7. Rózne działanie zagnieżdżonych commitów. W PL/SQL dane są zatwierdzane w bazie, a w T-SQL "zmniejszamy poziom zagnieżdżenia commitów", a faktyczne zatwierdzenie danych ma miejsce dopiero po wyjściu z "zagnieżdżenia".
