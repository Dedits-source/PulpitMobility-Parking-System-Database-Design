/* Database Creation */
CREATE DATABASE parking_management_system;
USE parking_management_system;

/*Table Creation*/

/* Who uses the parking system */
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* Enables analytics & future scalability */
CREATE TABLE vehicle_types (
    vehicle_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL
);

/* What is parked */ 
CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    vehicle_number VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(vehicle_type_id)
);

/* Where parking happens */ 
CREATE TABLE parking_lots (
    parking_lot_id INT PRIMARY KEY AUTO_INCREMENT,
    lot_name VARCHAR(100) NOT NULL,
    location VARCHAR(150),
    total_slots INT NOT NULL
);

/* Actual capacity */ 
CREATE TABLE parking_slots (
    slot_id INT PRIMARY KEY AUTO_INCREMENT,
    parking_lot_id INT NOT NULL,
    slot_number VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (parking_lot_id) REFERENCES parking_lots(parking_lot_id)
);

/* Tracks entry & exit */ 
CREATE TABLE parking_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT NOT NULL,
    slot_id INT NOT NULL,
    entry_time DATETIME NOT NULL,
    exit_time DATETIME,
    status ENUM('ACTIVE', 'COMPLETED') DEFAULT 'ACTIVE',
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (slot_id) REFERENCES parking_slots(slot_id)
);

/* How a parking is Charged */
CREATE TABLE pricing_plans (
    pricing_plan_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_type_id INT NOT NULL,
    rate_per_hour DECIMAL(6,2) NOT NULL,
    effective_from DATE NOT NULL,
    effective_to DATE,
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(vehicle_type_id)
);

/* Actual revenue transactions */
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    session_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    payment_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_mode ENUM('CASH', 'CARD', 'UPI') NOT NULL,
    status ENUM('SUCCESS', 'FAILED') DEFAULT 'SUCCESS',
    FOREIGN KEY (session_id) REFERENCES parking_sessions(session_id)
);

/* Sample Data*/
INSERT INTO users (full_name, phone_number, email) VALUES
('Rahul Sharma', '9876543210', 'rahul@mail.com'),
('Anita Verma', '9876543211', 'anita@mail.com'),
('Aman Gupta', '9876543212', 'aman@mail.com'),
('Neha Singh', '9876543213', 'neha@mail.com'),
('Rohan Mehta', '9876543214', 'rohan@mail.com');

INSERT INTO vehicle_types (type_name) VALUES
('Car'),
('Bike'),
('EV');

INSERT INTO vehicles (user_id, vehicle_number, vehicle_type_id) VALUES
(1, 'MH12AB1234', 1),
(2, 'MH14CD5678', 2),
(3, 'DL8CAF4321', 1),
(4, 'MH01EV9999', 3),
(5, 'GJ05XY1111', 1);

INSERT INTO parking_lots (lot_name, location, total_slots) VALUES
('City Mall Parking', 'Mumbai', 50),
('Tech Park Parking', 'Pune', 40);

INSERT INTO parking_slots (parking_lot_id, slot_number) VALUES
(1, 'A1'),
(1, 'A2'),
(1, 'A3'),
(2, 'B1'),
(2, 'B2'),
(2, 'B3');

INSERT INTO parking_sessions (vehicle_id, slot_id, entry_time, exit_time, status) VALUES
(1, 1, '2024-09-01 09:00:00', '2024-09-01 11:00:00', 'COMPLETED'),
(2, 2, '2024-09-01 10:30:00', '2024-09-01 12:00:00', 'COMPLETED'),
(3, 3, '2024-09-01 18:00:00', '2024-09-01 20:30:00', 'COMPLETED'),
(4, 4, '2024-09-02 09:00:00', '2024-09-02 13:00:00', 'COMPLETED'),
(5, 5, '2024-09-02 19:00:00', '2024-09-02 21:00:00', 'COMPLETED'),
(1, 6, '2024-09-03 08:30:00', '2024-09-03 10:00:00', 'COMPLETED');

INSERT INTO pricing_plans (vehicle_type_id, rate_per_hour, effective_from) VALUES
(1, 50.00, '2024-01-01'),
(2, 30.00, '2024-01-01'),
(3, 40.00, '2024-01-01');

INSERT INTO payments (session_id, amount, payment_mode, status) VALUES
(1, 100.00, 'UPI', 'SUCCESS'),
(2, 45.00, 'CASH', 'SUCCESS'),
(3, 125.00, 'CARD', 'SUCCESS'),
(4, 160.00, 'UPI', 'SUCCESS'),
(5, 100.00, 'CARD', 'SUCCESS'),
(6, 75.00, 'UPI', 'SUCCESS');

/* Analytical & Operational Queries */

/* 01 - List all users */
SELECT user_id, full_name, phone_number, email
FROM users;

/* 02 - List all vehicles with owner details */
SELECT v.vehicle_number, u.full_name, vt.type_name
FROM vehicles v
JOIN users u ON v.user_id = u.user_id
JOIN vehicle_types vt ON v.vehicle_type_id = vt.vehicle_type_id;

/* 03 - List all parking lots with total slots */
SELECT parking_lot_id, lot_name, location, total_slots
FROM parking_lots;

/* 04 - List parking slots per parking lot */
SELECT pl.lot_name, ps.slot_number
FROM parking_slots ps
JOIN parking_lots pl ON ps.parking_lot_id = pl.parking_lot_id;

/* 05 - List all completed parking sessions */
SELECT session_id, vehicle_id, entry_time, exit_time
FROM parking_sessions
WHERE status = 'COMPLETED';

/* 06 - Active parking sessions */
SELECT *
FROM parking_sessions
WHERE status = 'ACTIVE';

/* 07 - Vehicles currently parked */
SELECT DISTINCT v.vehicle_number
FROM vehicles v
JOIN parking_sessions ps ON v.vehicle_id = ps.vehicle_id
WHERE ps.status = 'ACTIVE';

/* 08 - Parking duration per session (in hours) */
SELECT session_id,
       TIMESTAMPDIFF(HOUR, entry_time, exit_time) AS duration_hours
FROM parking_sessions
WHERE status = 'COMPLETED';

/* 09 - Slot utilization count */
SELECT ps.slot_id, COUNT(*) AS usage_count
FROM parking_sessions ps
GROUP BY ps.slot_id;

/* 10 - Sessions per parking lot */
SELECT pl.lot_name, COUNT(ps.session_id) AS total_sessions
FROM parking_lots pl
JOIN parking_slots sl ON pl.parking_lot_id = sl.parking_lot_id
JOIN parking_sessions ps ON sl.slot_id = ps.slot_id
GROUP BY pl.lot_name;

/* 11 - Vehicles parked per day */
SELECT DATE(entry_time) AS parking_date, COUNT(*) AS total_vehicles
FROM parking_sessions
GROUP BY DATE(entry_time);

/* 12 - Average parking duration */
SELECT AVG(TIMESTAMPDIFF(MINUTE, entry_time, exit_time)) AS avg_duration_minutes
FROM parking_sessions
WHERE status = 'COMPLETED';

/* 13 - Peak parking hours */
SELECT HOUR(entry_time) AS hour, COUNT(*) AS session_count
FROM parking_sessions
GROUP BY HOUR(entry_time)
ORDER BY session_count DESC;

/* 14 - Revenue per parking lot */
SELECT pl.lot_name, SUM(p.amount) AS total_revenue
FROM payments p
JOIN parking_sessions ps ON p.session_id = ps.session_id
JOIN parking_slots sl ON ps.slot_id = sl.slot_id
JOIN parking_lots pl ON sl.parking_lot_id = pl.parking_lot_id
GROUP BY pl.lot_name;

/* 15 - Revenue by vehicle type */
SELECT vt.type_name, SUM(p.amount) AS total_revenue
FROM payments p
JOIN parking_sessions ps ON p.session_id = ps.session_id
JOIN vehicles v ON ps.vehicle_id = v.vehicle_id
JOIN vehicle_types vt ON v.vehicle_type_id = vt.vehicle_type_id
GROUP BY vt.type_name;

/* 16 - Average revenue per session */
SELECT AVG(amount) AS avg_revenue_per_session
FROM payments
WHERE status = 'SUCCESS';

/* 17 - Payment mode distribution */
SELECT payment_mode, COUNT(*) AS usage_count
FROM payments
GROUP BY payment_mode;

/* 18 - Underutilized parking slots */
SELECT slot_id, COUNT(*) AS usage_count
FROM parking_sessions
GROUP BY slot_id
HAVING usage_count < 5;

/* 19 - Frequent users */
SELECT u.full_name, COUNT(ps.session_id) AS visit_count
FROM users u
JOIN vehicles v ON u.user_id = v.user_id
JOIN parking_sessions ps ON v.vehicle_id = ps.vehicle_id
GROUP BY u.full_name
ORDER BY visit_count DESC;

/* 20 - EV usage analysis */
SELECT COUNT(*) AS ev_sessions
FROM parking_sessions ps
JOIN vehicles v ON ps.vehicle_id = v.vehicle_id
JOIN vehicle_types vt ON v.vehicle_type_id = vt.vehicle_type_id
WHERE vt.type_name = 'EV';


























