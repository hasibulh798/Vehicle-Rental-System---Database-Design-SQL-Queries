# Vehicle Rental System – SQL Queries Documentation


## 📄 queries.sql – Query Explanations

### 🔹 Query 1: JOIN

**Retrieve booking information along with customer name and vehicle name**

```sql
SELECT
  b.booking_id,
  u.name AS customer_name,
  v.name AS vehicle_name,
  b.start_date,
  b.end_date,
  b.status
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN vehicles v ON b.vehicle_id = v.vehicle_id;
```

#### Explanation:

* `INNER JOIN` is used to combine related data from multiple tables.
* Each booking is linked to exactly one user and one vehicle.
* Only bookings with valid users and vehicles are returned.


---

### 🔹 Query 2: NOT EXISTS

**Find all vehicles that have never been booked**

```sql
SELECT *
FROM vehicles v
WHERE NOT EXISTS (
  SELECT 1
  FROM bookings b
  WHERE b.vehicle_id = v.vehicle_id
);
```

#### Explanation:

* `NOT EXISTS` checks whether a related record exists in the `bookings` table.
* For each vehicle, the subquery searches for at least one booking.
* If no booking is found, the vehicle is returned.


---

### 🔹 Query 3: WHERE Clause

**Retrieve all available vehicles of a specific type (e.g., cars)**

```sql
SELECT *
FROM vehicles v
WHERE v.status = 'available'
  AND v.type = 'car';
```

#### Explanation:

* `WHERE` filters rows before any grouping or joining.
* Only vehicles that are both **available** and of type **car** are selected.


---

### 🔹 Query 4: GROUP BY and HAVING

**Find vehicles that have been booked more than 2 times**

```sql
SELECT
  v.name AS vehicle_name,
  COUNT(*) AS total_bookings
FROM bookings b
JOIN vehicles v ON b.vehicle_id = v.vehicle_id
GROUP BY v.name
HAVING COUNT(*) > 2;
```

#### Explanation:

* `GROUP BY` aggregates bookings per vehicle.
* `COUNT(*)` calculates total bookings.
* `HAVING` filters grouped results (unlike `WHERE`).


---

##  Key SQL Concepts Covered

* INNER JOIN
* EXISTS / NOT EXISTS
* WHERE filtering
* GROUP BY & HAVING
* Foreign key relationships
* Real-world relational database design

---

✍️ **Author:** Md. Hasibul Hasan

