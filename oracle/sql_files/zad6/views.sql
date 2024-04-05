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