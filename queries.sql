
  -- Query 1: JOIN   
  -- Retrieve booking information along with:
  -- Customer name
  -- Vehicle name

select
  b.booking_id,
  u.name as "customer_name",
  v.name as "vehicle_name",
  b.start_date,
  b.end_date,
  b.status
from
  bookings as b
  inner join users as u on b.user_id = u.user_id
  inner join vehicles as v on b.vehicle_id = v.vehicle_id

-- Query 2: EXISTS
-- Find all vehicles that have never been booked.

select
  *
from
  vehicles as v
where
  not exists (
    select
      1
    from
      bookings as b
    where
      b.vehicle_id = v.vehicle_id
  )


-- Query 3: WHERE
-- Retrieve all available vehicles of a specific type (e.g. cars).

select
  *
from
  vehicles as v
where
  v.status = 'available'
  and v.type = 'car'

-- Query 4: GROUP BY and HAVING
-- Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.

select
  v.name as "vehicle_name",
  count(*) as "total_bookings"
from
  bookings as b
  join vehicles as v
  on b.vehicle_id = v.vehicle_id
group by
  v.name
having
  count(*) > 2
