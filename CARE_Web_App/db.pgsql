-- Drop tables if they already exist
-- DROP TABLE IF EXISTS INVENTORY_LOG CASCADE;
-- DROP TABLE IF EXISTS DELIVERIES CASCADE;
-- DROP TABLE IF EXISTS PACKAGES CASCADE;
-- DROP TABLE IF EXISTS USERS CASCADE;

-- Users Table
CREATE TABLE USERS (
    id SERIAL PRIMARY KEY,                          -- Unique user identifier
    email VARCHAR(255) UNIQUE NOT NULL,             -- User email (admin's is predefined)
    password TEXT NOT NULL,                         -- Hashed password
    role VARCHAR(50) NOT NULL,                      -- Defines role (admin or student)
    name VARCHAR(255),                              -- User's name (if student)
    picture_id VARCHAR(100) UNIQUE,                 -- Unique ID for the picture, can include a prefix (e.g., 'PIC-12345')
    id_picture BYTEA,                               -- Binary data for the ID picture (PNG format)
    created_at TIMESTAMP DEFAULT NOW()              -- Account creation date
);

-- Packages Table
CREATE TABLE PACKAGES (
    id SERIAL PRIMARY KEY,                          -- Unique kit identifier
    name VARCHAR(255) NOT NULL,                     -- Kit name (e.g., "Food Kit", "Personal Care Kit")
    description TEXT,                               -- Detailed kit description
    quantity_in_stock INTEGER DEFAULT 0,            -- Number of available kits
    created_at TIMESTAMP DEFAULT NOW()              -- Date the kit was added
);

--Deliveries Table
CREATE TABLE DELIVERIES (
    id SERIAL PRIMARY KEY,                          -- Unique delivery identifier
    student_id INTEGER REFERENCES USERS(id) ON DELETE CASCADE,  -- Foreign key referencing the student requesting the kit
    package_id INTEGER REFERENCES PACKAGES(id) ON DELETE SET NULL,      -- Foreign key referencing the kit to be delivered
    scheduled_date TIMESTAMP NOT NULL,              -- Date when the delivery is scheduled
    status VARCHAR(50) DEFAULT 'requested',         -- Status (e.g., requested, delivered, canceled)
    created_at TIMESTAMP DEFAULT NOW()              -- Request creation date
);

-- InventoryLog Table
CREATE TABLE INVENTORY_LOG (
    id SERIAL PRIMARY KEY,                          -- Unique log entry
    package_id INTEGER REFERENCES PACKAGES(id) ON DELETE CASCADE,  -- Foreign key referencing the kit
    action VARCHAR(50) NOT NULL,                    -- Action performed (e.g., added, removed, updated)
    quantity_change INTEGER NOT NULL,               -- Change in quantity (positive for additions, negative for removals)
    admin_id INTEGER REFERENCES USERS(id) ON DELETE SET NULL,  -- Foreign key referencing the admin who made the update
    timestamp TIMESTAMP DEFAULT NOW()               -- Date and time of the action
);

-- Insert predefined admin account (with hashed password for security)
INSERT INTO USERS (email, password, role, name, created_at)
VALUES ('care_admin@pupr.org', '<hashed_password>', 'admin', 'Care', NOW());

-- PACKAGE insert for testing
INSERT INTO PACKAGES (name, description, quantity_in_stock, created_at)
VALUES ('Food Kit', 'Includes canned meat, beans, rice, and personal care items', 50, NOW());

-- Delivery record for testing
INSERT INTO DELIVERIES (student_id, package_id, scheduled_date, status, created_at)
VALUES (1, 1, '2024-12-01 10:00:00', 'requested', NOW());

-- InventoryLog insert for testing
INSERT INTO INVENTORY_LOG (package_id, action, quantity_change, admin_id, timestamp)
VALUES (1, 'added', 50, 1, NOW());