-- widoki
-- TODO nie wiem czy lepiej SYSDATE czy CURRENT_DATE - zapytac

-- trip_date, trip_name, firstname, lastname, status, trip_id, person_id

-- #reservation join trip join person
create or replace view vw_reservation
as
select
    RESERVATION.RESERVATION_ID,
    TRIP.COUNTRY,
    TRIP.TRIP_DATE,
    TRIP.TRIP_NAME,
    PERSON.FIRSTNAME,
    PERSON.LASTNAME,
    RESERVATION.STATUS,
    RESERVATION.TRIP_ID,
    RESERVATION.PERSON_ID
    from person
join reservation on person.person_id = reservation.person_id
join trip on reservation.trip_id = trip.trip_id;

-- test vw_reservation
select * from vw_reservation;

-- #trip join (trip_id, cnt -> ilosc rekordow co maja trip_id to samo)
-- TODO czy New , Paid to zliczac mam?

create or replace view vw_trip_enrolled_no
as
select
    trip_id,
    count(trip_id) as cnt
    from RESERVATION
where status = 'N' or status = 'P'
group by trip_id;

create or replace view vw_trip
as
select
    TRIP.TRIP_ID,
    TRIP.COUNTRY,
    TRIP.TRIP_DATE,
    TRIP.TRIP_NAME,
    TRIP.MAX_NO_PLACES,
    (TRIP.MAX_NO_PLACES - coalesce(vw_trip_enrolled_no.cnt , 0) ) as AVAILABLE_PLACES_NO
    from TRIP
left join vw_trip_enrolled_no on TRIP.TRIP_ID = vw_trip_enrolled_no.trip_id;

-- test vw_trip
select * from vw_trip;

create or replace view vw_available_trip
as
    select * from vw_trip
    where AVAILABLE_PLACES_NO > 0 and TRIP_DATE > current_date;

select * from vw_available_trip;

-- test vw_available_trip
select * from vw_available_trip;






