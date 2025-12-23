------------- USERS TABLE ----------------------
CREATE TYPE
  user_role AS ENUM('admin', 'customer')
CREATE TABLE IF NOT EXISTS
  users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(200) NOT NULL,
    phone VARCHAR(25),
    role user_role NOT NULL DEFAULT 'customer'
  )
 
  -------------- VEHICLES TABLE --------------
CREATE TYPE
  vehicle_type AS ENUM('car', 'bike', 'truck')
create type
  vehicle_status AS ENUM('available', 'rented', 'maintenance')
CREATE TABLE IF NOT EXISTS
  vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    type vehicle_type NOT NULL,
    model VARCHAR(200) NOT NULL,
    registration_number VARCHAR(200) NOT NULL UNIQUE,
    rental_price DECIMAL(10, 2) NOT NULL,
    status vehicle_status NOT NULL DEFAULT 'available'
  )


  ------------ BOOKINGS TABLE -----------------
CREATE TYPE
  booking_status AS ENUM('pending', 'confirmed', 'completed', 'cancelled')
CREATE TABLE IF NOT EXISTS
  bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users (user_id) ON DELETE CASCADE,
    vehicle_id INT NOT NULL REFERENCES vehicles (vehicle_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status booking_status NOT NULL
  )

  
  -- Query 1: JOIN   
  -- Retrieve booking information along with:
  -- Customer name
  -- Vehicle name

SELECT
  b.booking_id,
  u.name AS "customer_name",
  v.name AS "vehicle_name",
  b.start_date,
  b.end_date,
  b.status
FROM bookings AS b
INNER JOIN users AS u ON b.user_id = u.user_id
INNER JOIN vehicles AS v ON b.vehicle_id = v.vehicle_id;

-- Query 2: EXISTS
-- Find all vehicles that have never been booked.


SELECT *
FROM vehicles AS v
WHERE NOT EXISTS (
  SELECT 1
  FROM bookings AS b
  WHERE b.vehicle_id = v.vehicle_id
);

-- Query 3: WHERE
-- Retrieve all available vehicles of a specific type (e.g. cars).

SELECT
  *
FROM
  vehicles AS v
WHERE
  v.status = 'available'
  AND v.type = 'car'

-- Query 4: GROUP BY and HAVING
-- Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.

SELECT
  v.name AS "vehicle_name",
  COUNT(*) AS "total_bookings"
FROM
  bookings AS b
  JOIN vehicles AS v
  ON b.vehicle_id = v.vehicle_id
GROUP BY
  v.name
HAVING
  COUNT(*) > 2
