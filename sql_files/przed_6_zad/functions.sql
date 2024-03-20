
-- TODO definicja typu dla tej zwracanej tabelki -> czy da sie lepiej?

create or replace type trip_participants_row as OBJECT
(
    TRIP_DATE date,
    TRIP_NAME varchar2(100),
    COUNTRY varchar2(50),
    FIRSTNAME varchar2(50),
    LASTNAME varchar2(50),
    STATUS char,
    PERSON_ID int,
    RESERVATION_ID int
);

create or replace type trip_participants_table is table of trip_participants_row;

-- TODO jak dla mnie konktrola bledow tutaj to  zle id zroci pusta tabele poprostu
create or replace function f_trip_participants(p_trip_id int)
    return trip_participants_table
as
    result trip_participants_table;
begin
    select trip_participants_row(
        TRIP_DATE,
        TRIP_NAME,
        COUNTRY,
        FIRSTNAME,
        LASTNAME,
        STATUS,
        PERSON_ID,
        RESERVATION_ID
        )
    bulk collect
    into result
    from VW_RESERVATION
    where trip_id = p_trip_id;

    return result;
end;

-- przykladowe wywolanie
select * from table(f_trip_participants(1));


create or replace type person_reservations_row as OBJECT
(
    TRIP_DATE date,
    TRIP_NAME varchar2(100),
    COUNTRY varchar2(50),
    FIRSTNAME varchar2(50),
    LASTNAME varchar2(50),
    STATUS char,
    RESERVATION_ID int,
    TRIP_ID int
);

create or replace type person_reservations_table is table of person_reservations_row;

-- TODO jak dla mnie konktrola bledow tutaj to zle id zroci pusta tabele poprostu
create or replace function f_person_reservations(p_person_id int)
    return person_reservations_table
as
    result person_reservations_table;
begin
    select person_reservations_row(
        TRIP_DATE,
        TRIP_NAME,
        COUNTRY,
        FIRSTNAME,
        LASTNAME,
        STATUS,
        RESERVATION_ID,
        TRIP_ID
        )
    bulk collect
    into result
    from VW_RESERVATION
    where person_id = p_person_id;

    return result;
end;

-- przykladowe wywolanie
select * from table(f_person_reservations(1));

create or replace type available_trips_row as OBJECT
(
    TRIP_ID int,
    COUNTRY varchar2(50),
    TRIP_DATE date,
    TRIP_NAME varchar2(100),
    MAX_NO_PLACES int,
    AVAILABLE_PLACES_NO int
);

create or replace type available_trips_table is table of available_trips_row;

-- TODO available places no > 0 ?
-- TODO jak dla mnie konktrola bledow tutaj to  zle id zroci pusta tabele poprostu
create or replace function f_available_trips(p_country varchar2(50), p_date_from date, p_date_to date)
    return available_trips_table
as
    result available_trips_table;
begin
    select available_trips_row(
        TRIP_ID,
        COUNTRY,
        TRIP_DATE,
        TRIP_NAME,
        MAX_NO_PLACES,
        AVAILABLE_PLACES_NO
        )
    bulk collect
    into result
    from VW_TRIP
    where COUNTRY = p_country and TRIP_DATE between p_date_from and p_date_to;

    return result;
end;


