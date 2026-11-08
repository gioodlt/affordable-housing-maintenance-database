-- CSE 5720 Project 1
-- Group 5: Affordable Housing Maintenance Work Orders
-- File: 04_verification.sql



-- TEST 1: Verify row counts for all eight tables.

SELECT 'PROPERTY' AS table_name, COUNT(*) AS row_count FROM PROPERTY
UNION ALL SELECT 'UNIT', COUNT(*) FROM UNIT
UNION ALL SELECT 'RESIDENT_CODE', COUNT(*) FROM RESIDENT_CODE
UNION ALL SELECT 'ISSUE_CATEGORY', COUNT(*) FROM ISSUE_CATEGORY
UNION ALL SELECT 'TECHNICIAN', COUNT(*) FROM TECHNICIAN
UNION ALL SELECT 'WORK_ORDER', COUNT(*) FROM WORK_ORDER
UNION ALL SELECT 'WORK_ASSIGNMENT', COUNT(*) FROM WORK_ASSIGNMENT
UNION ALL SELECT 'WORK_STATUS_HISTORY', COUNT(*) FROM WORK_STATUS_HISTORY
ORDER BY table_name;


-- TEST 2: Duplicate unit number in the same property must be rejected.

BEGIN;

DO $$
DECLARE
    v_property_id INTEGER;
    v_unit_number VARCHAR(20);
    v_unit_id INTEGER;
    v_rejected BOOLEAN := FALSE;
BEGIN
    SELECT property_id, unit_number
    INTO v_property_id, v_unit_number
    FROM UNIT
    ORDER BY unit_id
    LIMIT 1;

    IF v_property_id IS NULL THEN
        RAISE WARNING 'FAIL: TEST 2 skipped; UNIT has no rows.';
    ELSE
        SELECT COALESCE(MAX(unit_id), 0) + 100000
        INTO v_unit_id
        FROM UNIT;

        BEGIN
            INSERT INTO UNIT (unit_id, property_id, unit_number)
            VALUES (v_unit_id, v_property_id, v_unit_number);
        EXCEPTION WHEN unique_violation THEN
            v_rejected := TRUE;
        END;

        IF v_rejected THEN
            RAISE NOTICE 'PASS: duplicate unit number was rejected.';
        ELSE
            RAISE WARNING 'FAIL: duplicate unit number was accepted; check UNIQUE(property_id, unit_number).';
        END IF;
    END IF;
END $$;

ROLLBACK;


-- TEST 3: Invalid priority must be rejected by a CHECK constraint.

BEGIN;

DO $$
DECLARE
    v_unit_id INTEGER;
    v_resident_id INTEGER;
    v_category_id INTEGER;
    v_work_order_id INTEGER;
    v_rejected BOOLEAN := FALSE;
BEGIN
    SELECT unit_id INTO v_unit_id
    FROM UNIT ORDER BY unit_id LIMIT 1;

    SELECT resident_code_id INTO v_resident_id
    FROM RESIDENT_CODE ORDER BY resident_code_id LIMIT 1;

    SELECT category_id INTO v_category_id
    FROM ISSUE_CATEGORY ORDER BY category_id LIMIT 1;

    IF v_unit_id IS NULL OR v_resident_id IS NULL OR v_category_id IS NULL THEN
        RAISE WARNING 'FAIL: TEST 3 skipped; required parent-table data is missing.';
    ELSE
        SELECT COALESCE(MAX(work_order_id), 0) + 100000
        INTO v_work_order_id
        FROM WORK_ORDER;

        BEGIN
            INSERT INTO WORK_ORDER
                (work_order_id, unit_id, resident_code_id, category_id,
                 description, priority, status, submitted_at, completed_at)
            VALUES
                (v_work_order_id, v_unit_id, v_resident_id, v_category_id,
                 'Verification test: invalid priority', 'URGENT', 'OPEN',
                 CURRENT_TIMESTAMP, NULL);
        EXCEPTION WHEN check_violation THEN
            v_rejected := TRUE;
        END;

        IF v_rejected THEN
            RAISE NOTICE 'PASS: invalid priority was rejected.';
        ELSE
            RAISE WARNING 'FAIL: invalid priority was accepted; check priority CHECK constraint.';
        END IF;
    END IF;
END $$;

ROLLBACK;


-- TEST 4: Invalid status must be rejected by a CHECK constraint.

BEGIN;

DO $$
DECLARE
    v_unit_id INTEGER;
    v_resident_id INTEGER;
    v_category_id INTEGER;
    v_work_order_id INTEGER;
    v_rejected BOOLEAN := FALSE;
BEGIN
    SELECT unit_id INTO v_unit_id
    FROM UNIT ORDER BY unit_id LIMIT 1;

    SELECT resident_code_id INTO v_resident_id
    FROM RESIDENT_CODE ORDER BY resident_code_id LIMIT 1;

    SELECT category_id INTO v_category_id
    FROM ISSUE_CATEGORY ORDER BY category_id LIMIT 1;

    IF v_unit_id IS NULL OR v_resident_id IS NULL OR v_category_id IS NULL THEN
        RAISE WARNING 'FAIL: TEST 4 skipped; required parent-table data is missing.';
    ELSE
        SELECT COALESCE(MAX(work_order_id), 0) + 100001
        INTO v_work_order_id
        FROM WORK_ORDER;

        BEGIN
            INSERT INTO WORK_ORDER
                (work_order_id, unit_id, resident_code_id, category_id,
                 description, priority, status, submitted_at, completed_at)
            VALUES
                (v_work_order_id, v_unit_id, v_resident_id, v_category_id,
                 'Verification test: invalid status', 'LOW', 'WAITING',
                 CURRENT_TIMESTAMP, NULL);
        EXCEPTION WHEN check_violation THEN
            v_rejected := TRUE;
        END;

        IF v_rejected THEN
            RAISE NOTICE 'PASS: invalid status was rejected.';
        ELSE
            RAISE WARNING 'FAIL: invalid status was accepted; check status CHECK constraint.';
        END IF;
    END IF;
END $$;

ROLLBACK;


-- TEST 5: completed_at earlier than submitted_at must be rejected.

BEGIN;

DO $$
DECLARE
    v_unit_id INTEGER;
    v_resident_id INTEGER;
    v_category_id INTEGER;
    v_work_order_id INTEGER;
    v_rejected BOOLEAN := FALSE;
BEGIN
    SELECT unit_id INTO v_unit_id
    FROM UNIT ORDER BY unit_id LIMIT 1;

    SELECT resident_code_id INTO v_resident_id
    FROM RESIDENT_CODE ORDER BY resident_code_id LIMIT 1;

    SELECT category_id INTO v_category_id
    FROM ISSUE_CATEGORY ORDER BY category_id LIMIT 1;

    IF v_unit_id IS NULL OR v_resident_id IS NULL OR v_category_id IS NULL THEN
        RAISE WARNING 'FAIL: TEST 5 skipped; required parent-table data is missing.';
    ELSE
        SELECT COALESCE(MAX(work_order_id), 0) + 100002
        INTO v_work_order_id
        FROM WORK_ORDER;

        BEGIN
            INSERT INTO WORK_ORDER
                (work_order_id, unit_id, resident_code_id, category_id,
                 description, priority, status, submitted_at, completed_at)
            VALUES
                (v_work_order_id, v_unit_id, v_resident_id, v_category_id,
                 'Verification test: invalid completion time', 'MEDIUM', 'COMPLETED',
                 TIMESTAMP '2026-01-02 12:00:00',
                 TIMESTAMP '2026-01-01 12:00:00');
        EXCEPTION WHEN check_violation THEN
            v_rejected := TRUE;
        END;

        IF v_rejected THEN
            RAISE NOTICE 'PASS: earlier completion timestamp was rejected.';
        ELSE
            RAISE WARNING 'FAIL: earlier completion timestamp was accepted; check timestamp CHECK constraint.';
        END IF;
    END IF;
END $$;

ROLLBACK;


-- TEST 6: A work order with a nonexistent unit_id must be rejected.

BEGIN;

DO $$
DECLARE
    v_resident_id INTEGER;
    v_category_id INTEGER;
    v_work_order_id INTEGER;
    v_rejected BOOLEAN := FALSE;
BEGIN
    SELECT resident_code_id INTO v_resident_id
    FROM RESIDENT_CODE ORDER BY resident_code_id LIMIT 1;

    SELECT category_id INTO v_category_id
    FROM ISSUE_CATEGORY ORDER BY category_id LIMIT 1;

    IF v_resident_id IS NULL OR v_category_id IS NULL THEN
        RAISE WARNING 'FAIL: TEST 6 skipped; RESIDENT_CODE or ISSUE_CATEGORY has no rows.';
    ELSE
        SELECT COALESCE(MAX(work_order_id), 0) + 100003
        INTO v_work_order_id
        FROM WORK_ORDER;

        BEGIN
            INSERT INTO WORK_ORDER
                (work_order_id, unit_id, resident_code_id, category_id,
                 description, priority, status, submitted_at, completed_at)
            VALUES
                (v_work_order_id, -999999, v_resident_id, v_category_id,
                 'Verification test: invalid unit foreign key', 'LOW', 'OPEN',
                 CURRENT_TIMESTAMP, NULL);
        EXCEPTION WHEN foreign_key_violation THEN
            v_rejected := TRUE;
        END;

        IF v_rejected THEN
            RAISE NOTICE 'PASS: nonexistent unit_id was rejected by the foreign key.';
        ELSE
            RAISE WARNING 'FAIL: nonexistent unit_id was accepted; check WORK_ORDER foreign key.';
        END IF;
    END IF;
END $$;

ROLLBACK;


-- TEST 7: Work orders may be unassigned.
-- Returned rows are valid examples of unassigned work orders.

SELECT
    wo.work_order_id,
    wo.status,
    wo.priority,
    wo.submitted_at
FROM WORK_ORDER AS wo
LEFT JOIN WORK_ASSIGNMENT AS wa
    ON wo.work_order_id = wa.work_order_id
WHERE wa.assignment_id IS NULL
ORDER BY wo.submitted_at;


-- TEST 8: Review status/completion timestamp consistency.
-- The design leaves open whether COMPLETED must require completed_at.
-- This reports possible inconsistencies without imposing that rule.

SELECT
    work_order_id,
    status,
    submitted_at,
    completed_at
FROM WORK_ORDER
WHERE (status = 'COMPLETED' AND completed_at IS NULL)
   OR (status <> 'COMPLETED' AND completed_at IS NOT NULL)
ORDER BY work_order_id;


-- TEST 9: Check for status-history rows without a matching work order.
-- Expected: zero rows because the foreign key should prevent orphan rows.

SELECT
    h.history_id,
    h.work_order_id,
    h.status,
    h.changed_at
FROM WORK_STATUS_HISTORY AS h
LEFT JOIN WORK_ORDER AS wo
    ON h.work_order_id = wo.work_order_id
WHERE wo.work_order_id IS NULL;


-- TEST 10: Summary counts for the report/demo.

-- Work orders grouped by status.
SELECT
    status,
    COUNT(*) AS work_order_count
FROM WORK_ORDER
GROUP BY status
ORDER BY status;

-- Work orders grouped by priority.
SELECT
    priority,
    COUNT(*) AS work_order_count
FROM WORK_ORDER
GROUP BY priority
ORDER BY priority;