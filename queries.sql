------------- USERS TABLE ----------------------
create type
  user_role as enum('admin', 'customer')
create table
  users (
    user_id serial primary key,
    name varchar(100),
    email varchar(100) not null unique,
    password varchar(200) not null,
    phone varchar(25),
    role user_role not null default 'customer'
  )
 
  -------------- VEHICLES TABLE --------------
create type
  vehicle_type as enum('car', 'bike', 'truck')
create type
  vehicle_status as enum('available', 'rented', 'maintenance')
create table
  vehicles (
    vehicle_id serial primary key,
    name varchar(200) not null,
    type vehicle_type not null,
    model varchar(200) not null,
    registration_number varchar(200) not null unique,
    rental_price decimal(10, 2) not null,
    status vehicle_status not null default 'available'
  )


  ------------ BOOKINGS TABLE -----------------
create type
  booking_status as enum('pending', 'confirmed', 'completed', 'cancelled')
create table
  bookings (
    booking_id int primary key,
    user_id int not null references users (user_id) on delete cascade,
    vehicle_id int not null references vehicles (vehicle_id) on delete cascade,
    start_date date not null,
    end_date date not null,
    status booking_status not null
  )

  
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
