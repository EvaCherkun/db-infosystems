-- Створення бази даних
CREATE DATABASE medical_lab;

-- Підключення до бази даних
\c medical_lab;

-- Створення користувачів
CREATE ROLE admin WITH LOGIN PASSWORD 'admin_password';
CREATE ROLE moderator WITH LOGIN PASSWORD 'moderator_password';
CREATE ROLE "user" WITH LOGIN PASSWORD 'user_password';

-- Призначення прав доступу
GRANT ALL PRIVILEGES ON DATABASE medical_lab TO admin;
GRANT CONNECT ON DATABASE medical_lab TO moderator, "user";

-- Створення таблиць
CREATE TABLE Patient (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Doctor (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE LabTechnician (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Analysis (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2)
);

CREATE TABLE LabOrder (
    id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES Patient(id),
    analysis_id INT NOT NULL REFERENCES Analysis(id),
    lab_technician_id INT REFERENCES LabTechnician(id),
    doctor_id INT REFERENCES Doctor(id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Completed', 'Canceled', 'Needs Retest'))
);

CREATE TABLE Result (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES LabOrder(id),
    result_text TEXT,
    result_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    accuracy_percentage DECIMAL(5,2),
    received_online BOOLEAN DEFAULT FALSE
);