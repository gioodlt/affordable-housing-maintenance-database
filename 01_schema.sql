-- CSE 5720 Project 1
-- Group 5: Affordable Housing Maintenance Work Orders
-- File: 01_schema.sql


-- Prevent deletion of records that are still referenced.
BEGIN;

CREATE TABLE PROPERTY (
    property_id INTEGER PRIMARY KEY,
    property_name VARCHAR(100) NOT NULL,
    property_address VARCHAR(200) NOT NULL
);

CREATE TABLE UNIT (
    unit_id INTEGER PRIMARY KEY,
    property_id INTEGER NOT NULL REFERENCES PROPERTY(property_id) ON DELETE RESTRICT,
    unit_number VARCHAR(20) NOT NULL,
    CONSTRAINT unique_unit_per_property UNIQUE (property_id, unit_number)
);

CREATE TABLE RESIDENT_CODE (
    resident_code_id INTEGER PRIMARY KEY,
    resident_code VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE ISSUE_CATEGORY (
    category_id INTEGER PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE TECHNICIAN (
    technician_id INTEGER PRIMARY KEY,
    technician_code VARCHAR(20) NOT NULL UNIQUE,
    specialty VARCHAR(50) NOT NULL,
    active_status BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE WORK_ORDER (
    work_order_id INTEGER PRIMARY KEY,
    unit_id INTEGER NOT NULL REFERENCES UNIT(unit_id) ON DELETE RESTRICT,
    resident_code_id INTEGER NOT NULL REFERENCES RESIDENT_CODE(resident_code_id) ON DELETE RESTRICT,
    category_id INTEGER NOT NULL REFERENCES ISSUE_CATEGORY(category_id) ON DELETE RESTRICT,
    description TEXT NOT NULL,
    priority VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    CONSTRAINT valid_priority CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH')),
    CONSTRAINT valid_work_order_status CHECK (status IN ('OPEN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT valid_completion_time CHECK (completed_at IS NULL OR completed_at >= submitted_at)
);

CREATE TABLE WORK_ASSIGNMENT (
    assignment_id INTEGER PRIMARY KEY,
    work_order_id INTEGER NOT NULL REFERENCES WORK_ORDER(work_order_id) ON DELETE RESTRICT,
    technician_id INTEGER NOT NULL REFERENCES TECHNICIAN(technician_id) ON DELETE RESTRICT,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_work_assignment UNIQUE (work_order_id, technician_id)
);

CREATE TABLE WORK_STATUS_HISTORY (
    history_id INTEGER PRIMARY KEY,
    work_order_id INTEGER NOT NULL REFERENCES WORK_ORDER(work_order_id) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_history_status CHECK (status IN ('OPEN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'))
);

-- Work order details, including unassigned work orders.
CREATE VIEW work_order_details AS
SELECT
    wo.work_order_id,
    p.property_name,
    u.unit_number,
    ic.category_name AS issue_category,
    t.technician_code,
    wo.priority,
    wo.status,
    wo.submitted_at,
    wo.completed_at
FROM WORK_ORDER AS wo
JOIN UNIT AS u
    ON wo.unit_id = u.unit_id
JOIN PROPERTY AS p
    ON u.property_id = p.property_id
JOIN ISSUE_CATEGORY AS ic
    ON wo.category_id = ic.category_id
LEFT JOIN WORK_ASSIGNMENT AS wa
    ON wo.work_order_id = wa.work_order_id
LEFT JOIN TECHNICIAN AS t
    ON wa.technician_id = t.technician_id;

COMMIT;
