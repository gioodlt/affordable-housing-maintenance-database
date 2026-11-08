-- CSE 5720 Project 1
-- Group 5: Affordable Housing Maintenance Work Orders
-- File: 02_data.sql


-- Synthetic data. Dates are relative to when this file runs.
BEGIN;

INSERT INTO PROPERTY (property_id, property_name, property_address) VALUES
    (1, 'Maple Court', '100 Example Lane'),
    (2, 'Cedar Grove', '200 Sample Avenue'),
    (3, 'Oak Terrace', '300 Fictional Road');

INSERT INTO UNIT (unit_id, property_id, unit_number) VALUES
    (1, 1, '101'),
    (2, 1, '102'),
    (3, 1, '103'),
    (4, 1, '104'),
    (5, 2, '101'),
    (6, 2, '102'),
    (7, 2, '103'),
    (8, 2, '104'),
    (9, 3, '101'),
    (10, 3, '102'),
    (11, 3, '103'),
    (12, 3, '104');

INSERT INTO RESIDENT_CODE (resident_code_id, resident_code) VALUES
    (1, 'RES-001'),
    (2, 'RES-002'),
    (3, 'RES-003'),
    (4, 'RES-004'),
    (5, 'RES-005'),
    (6, 'RES-006'),
    (7, 'RES-007'),
    (8, 'RES-008'),
    (9, 'RES-009'),
    (10, 'RES-010');

INSERT INTO ISSUE_CATEGORY (category_id, category_name) VALUES
    (1, 'Plumbing'),
    (2, 'Electrical'),
    (3, 'Heating and Cooling'),
    (4, 'Appliance'),
    (5, 'Doors and Locks'),
    (6, 'Pest Control');

INSERT INTO TECHNICIAN (technician_id, technician_code, specialty, active_status) VALUES
    (1, 'TECH-001', 'Plumbing', TRUE),
    (2, 'TECH-002', 'General Maintenance', TRUE),
    (3, 'TECH-003', 'Electrical', TRUE),
    (4, 'TECH-004', 'Heating and Cooling', TRUE),
    (5, 'TECH-005', 'General Maintenance', TRUE);

INSERT INTO WORK_ORDER (work_order_id, unit_id, resident_code_id, category_id, description, priority, status, submitted_at, completed_at) VALUES
    (1, 1, 1, 1, 'Kitchen sink pipe leaking', 'HIGH', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '14 days', NULL),
    (2, 1, 1, 1, 'Bathroom drain backing up', 'HIGH', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '12 days', NULL),
    (3, 2, 2, 1, 'Toilet keeps running', 'MEDIUM', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '10 days', NULL),
    (4, 3, 3, 1, 'Shower faucet dripping', 'LOW', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '6 days', NULL),
    (5, 5, 5, 1, 'Water leaking under sink', 'HIGH', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '9 days', NULL),
    (6, 6, 6, 2, 'Kitchen outlet has no power', 'HIGH', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '11 days', NULL),
    (7, 7, 7, 5, 'Front door lock sticking', 'MEDIUM', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '5 days', NULL),
    (8, 8, 8, 4, 'Refrigerator not cooling', 'HIGH', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '3 days', NULL),
    (9, 9, 9, 3, 'Heater not starting', 'HIGH', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '8 days', NULL),
    (10, 10, 10, 6, 'Ants near kitchen window', 'LOW', 'OPEN', CURRENT_TIMESTAMP - INTERVAL '2 days', NULL),
    (11, 1, 1, 2, 'Bathroom light flickering', 'MEDIUM', 'IN_PROGRESS', CURRENT_TIMESTAMP - INTERVAL '7 days', NULL),
    (12, 2, 2, 4, 'Stove burner not heating', 'MEDIUM', 'IN_PROGRESS', CURRENT_TIMESTAMP - INTERVAL '4 days', NULL),
    (13, 5, 5, 3, 'Air conditioner leaking', 'HIGH', 'IN_PROGRESS', CURRENT_TIMESTAMP - INTERVAL '6 days', NULL),
    (14, 9, 9, 5, 'Window latch broken', 'LOW', 'IN_PROGRESS', CURRENT_TIMESTAMP - INTERVAL '3 days', NULL),
    (15, 1, 1, 1, 'Replace worn kitchen faucet', 'MEDIUM', 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP - INTERVAL '25 days'),
    (16, 2, 2, 2, 'Replace faulty wall switch', 'MEDIUM', 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '20 days', CURRENT_TIMESTAMP - INTERVAL '18 days'),
    (17, 5, 5, 1, 'Repair bathroom supply pipe', 'HIGH', 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '18 days', CURRENT_TIMESTAMP - INTERVAL '15 days'),
    (18, 6, 6, 4, 'Repair refrigerator door seal', 'LOW', 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '12 days', CURRENT_TIMESTAMP - INTERVAL '10 days'),
    (19, 3, 3, 5, 'Duplicate door lock request', 'LOW', 'CANCELLED', CURRENT_TIMESTAMP - INTERVAL '5 days', NULL),
    (20, 10, 10, 6, 'Duplicate pest inspection request', 'LOW', 'CANCELLED', CURRENT_TIMESTAMP - INTERVAL '4 days', NULL);

INSERT INTO WORK_ASSIGNMENT (assignment_id, work_order_id, technician_id, assigned_at) VALUES
    (1, 1, 1, CURRENT_TIMESTAMP - INTERVAL '13 days'),
    (2, 2, 1, CURRENT_TIMESTAMP - INTERVAL '11 days'),
    (3, 3, 1, CURRENT_TIMESTAMP - INTERVAL '9 days'),
    (4, 4, 1, CURRENT_TIMESTAMP - INTERVAL '5 days'),
    (5, 5, 1, CURRENT_TIMESTAMP - INTERVAL '8 days'),
    (6, 6, 2, CURRENT_TIMESTAMP - INTERVAL '10 days'),
    (7, 7, 2, CURRENT_TIMESTAMP - INTERVAL '4 days'),
    (8, 8, 2, CURRENT_TIMESTAMP - INTERVAL '2 days'),
    (9, 9, 2, CURRENT_TIMESTAMP - INTERVAL '7 days'),
    (10, 1, 2, CURRENT_TIMESTAMP - INTERVAL '13 days'),
    (11, 6, 3, CURRENT_TIMESTAMP - INTERVAL '10 days'),
    (12, 11, 3, CURRENT_TIMESTAMP - INTERVAL '6 days'),
    (13, 12, 2, CURRENT_TIMESTAMP - INTERVAL '3 days'),
    (14, 13, 4, CURRENT_TIMESTAMP - INTERVAL '5 days'),
    (15, 14, 2, CURRENT_TIMESTAMP - INTERVAL '2 days'),
    (16, 15, 1, CURRENT_TIMESTAMP - INTERVAL '29 days'),
    (17, 16, 3, CURRENT_TIMESTAMP - INTERVAL '19 days'),
    (18, 17, 1, CURRENT_TIMESTAMP - INTERVAL '17 days'),
    (19, 18, 2, CURRENT_TIMESTAMP - INTERVAL '11 days'),
    (20, 11, 2, CURRENT_TIMESTAMP - INTERVAL '6 days');

INSERT INTO WORK_STATUS_HISTORY (history_id, work_order_id, status, changed_at) VALUES
    (1, 1, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '14 days'),
    (2, 2, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '12 days'),
    (3, 3, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '10 days'),
    (4, 4, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '6 days'),
    (5, 5, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '9 days'),
    (6, 6, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '11 days'),
    (7, 7, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '5 days'),
    (8, 8, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '3 days'),
    (9, 9, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '8 days'),
    (10, 10, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '2 days'),
    (11, 11, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '7 days'),
    (12, 12, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '4 days'),
    (13, 13, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '6 days'),
    (14, 14, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '3 days'),
    (15, 15, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '30 days'),
    (16, 16, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '20 days'),
    (17, 17, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '18 days'),
    (18, 18, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '12 days'),
    (19, 19, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '5 days'),
    (20, 20, 'OPEN', CURRENT_TIMESTAMP - INTERVAL '4 days'),
    (21, 11, 'IN_PROGRESS', CURRENT_TIMESTAMP - INTERVAL '5 days'),
    (22, 12, 'IN_PROGRESS', CURRENT_TIMESTAMP - INTERVAL '2 days'),
    (23, 13, 'IN_PROGRESS', CURRENT_TIMESTAMP - INTERVAL '4 days'),
    (24, 14, 'IN_PROGRESS', CURRENT_TIMESTAMP - INTERVAL '1 days'),
    (25, 15, 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '25 days'),
    (26, 16, 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '18 days'),
    (27, 17, 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '15 days'),
    (28, 18, 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '10 days'),
    (29, 19, 'CANCELLED', CURRENT_TIMESTAMP - INTERVAL '3 days'),
    (30, 20, 'CANCELLED', CURRENT_TIMESTAMP - INTERVAL '2 days');

COMMIT;
