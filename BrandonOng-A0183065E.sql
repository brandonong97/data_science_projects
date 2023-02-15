/*Create a result table that lists each aircraft type, its model and the travel classes it 
supports (one travel class per row).*/
select bookings.seats.aircraft_code, bookings.aircrafts.model, bookings.seats.fare_conditions, count(seat_no) as number_of_seats, sum(count(seat_no)) over(partition by bookings.seats.aircraft_code) as total_number_of_seats 
from bookings.seats
left join bookings.aircrafts
on bookings.seats.aircraft_code = bookings.aircrafts.aircraft_code
group by bookings.seats.aircraft_code, bookings.aircrafts.model, bookings.seats.fare_conditions
order by bookings.seats.aircraft_code, bookings.aircrafts.model, bookings.seats.fare_conditions

/*Create a query that lists all the cities that contain more than one airport, the number of 
airports they have, and the codes of those airports.*/
select city, count(airport_name), string_agg(distinct airport_name, ', ') 
from bookings.airports
group by city
having count(airport_name) > 1

/*Create a view that contains all the flight-related data for each completed flight in a 
single table*/
SELECT
    flight_id,
    flight_no,
    aircraft_code,
    status,
	d.airport_code as departure_airport_code,
	d.airport_name as departure_airport_name,
	d.city as departure_city,
	a.airport_code as arrival_airport_code,
	a.airport_name as arrival_airport_name,
	a.city as arrival_city,
	scheduled_departure,
	scheduled_arrival,
	scheduled_arrival - scheduled_departure as scheduled_duration,
	actual_departure,
	actual_arrival,
	actual_arrival - actual_departure as actual_duration
FROM
    bookings.flights AS f
INNER JOIN bookings.airports AS d
    ON f.departure_airport = d.airport_code
INNER JOIN bookings.airports AS a
    ON f.arrival_airport = a.airport_code
where status = 'Arrived'


/*Create a query that lists all the destinations you can reach from the city of Rostov. For 
each destination, include a field that lists the days during the week when flights are 
available*/
select 
	df.arrival_city,
	string_agg(distinct day_of_week, ', ')
FROM(
	SELECT
    status,
	d.city as departure_city,
	a.city as arrival_city,
	f.scheduled_departure,
	cast(extract(isodow from f.scheduled_departure) as char) as day_of_week
FROM
    bookings.flights AS f
INNER JOIN bookings.airports AS d
    ON f.departure_airport = d.airport_code
INNER JOIN bookings.airports AS a
    ON f.arrival_airport = a.airport_code
WHERE status = 'Scheduled' and d.city = 'Rostov') as df
group by df.arrival_city

/*For the top 3 most expensive bookings, create a query showing their flight and 
passenger details.*/
select 
	f.departure_airport,
	f.arrival_airport,
	f.scheduled_departure,
	f.scheduled_arrival,
	f.actual_departure,
	f.actual_arrival,
	tf.fare_conditions,
	tf.amount,
	t.ticket_no,
	t.passenger_id,
	t.passenger_name
from
(select * 
from bookings.bookings
order by total_amount desc
limit 3) as b
inner join bookings.tickets as t
on b.book_ref = t.book_ref
inner join bookings.ticket_flights as tf
on t.ticket_no = tf.ticket_no
inner join bookings.flights as f
on tf.flight_id = f.flight_id

/*Create a query that lists the average flight delay for the 3 most popular departure cities */
select df.city, count(df.flight_id) as count_of_flights, avg(df.delay) as avg_delay
from(
select *, (actual_arrival - scheduled_arrival) as delay
from bookings.flights as f
inner join bookings.airports as a
on f.departure_airport = a.airport_code
where status='Arrived') as df
group by df.city
order by count_of_flights desc
limit 3


/*Create a query that lists the average flight delay by aircraft type.*/
select df.aircraft_code, avg(delay)
from
(select f.aircraft_code, (actual_arrival - scheduled_arrival) as delay
from bookings.flights as f
where f.status = 'Arrived') as df
group by df.aircraft_code
order by avg(delay) desc


/*Find the minimum and maximum number of travellers on a flight booking. For each 
number in this range, count the number of completed trips that have that many travellers. */
select ans.no_trav, count(distinct ans.book_ref) as no_trips
from
(select df.*,t.ticket_no, tf.flight_id, f.status
from
(select count(distinct passenger_id) as no_trav, book_ref
from bookings.tickets
group by book_ref
order by count(distinct passenger_id) desc) as df
inner join bookings.tickets as t
on df.book_ref = t.book_ref
inner join bookings.ticket_flights as tf
on t.ticket_no = tf.ticket_no
inner join bookings.flights as f
on tf.flight_id = f.flight_id
where status = 'Arrived') as ans
group by ans.no_trav
order by ans.no_trav desc


/* For each flight number, determine its minimum and maximum occupancy through the 
one year period of the data. Include the average occupancy for the year, as well. Calculate 
the monthly occupancy for each month in the data. With the monthly occupancy, include 
the difference from the previous month’s occupancy.*/
select part1.*,part2.max_occ,part2.min_occ,part2.avg_occ
from
(select *, lag(occupants) over(partition by df.flight_no, df.year order by df.flight_no asc,df.year asc,df.month asc ) - occupants as monthly_change
from
(select f.flight_no, date_part('year', f.scheduled_departure) as year, date_part('month', f.scheduled_departure) as month, count(distinct bp.seat_no) as occupants
from bookings.flights as f
inner join bookings.boarding_passes as bp
on f.flight_id = bp.flight_id
where f.status = 'Arrived'
group by f.flight_no, date_part('year', f.scheduled_departure), date_part('month', f.scheduled_departure)
order by f.flight_no asc, date_part('year', f.scheduled_departure) asc, date_part('month', f.scheduled_departure) asc) as df) part1
inner join
(select df2.flight_no, df2.year, max(occ) as max_occ, min(occ) as min_occ, avg(occ) as avg_occ
from
(select f.flight_no, bp.flight_id, date_part('year', f.scheduled_departure) as year, count(distinct bp.seat_no) as occ
from bookings.flights as f
inner join bookings.boarding_passes as bp
on f.flight_id = bp.flight_id
where f.status = 'Arrived'
group by f.flight_no, bp.flight_id, date_part('year', f.scheduled_departure)
order by f.flight_no asc, bp.flight_id asc, date_part('year', f.scheduled_departure) asc) as df2
group by df2.flight_no, df2.year
order by df2.flight_no asc, df2.year asc) as part2
on part1.flight_no = part2.flight_no and part1.year = part2.year
