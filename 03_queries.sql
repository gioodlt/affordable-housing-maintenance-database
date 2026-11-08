-- CSE 5720 Project 1
-- Group 5: Affordable Housing Maintenance Work Orders
-- File: 03_queries.sql

-- Q1. List open high-priority work orders older than 7 days.
-- Q2. Show each work order with property, unit, issue category, assigned technician, and status.
-- Q3. Count work orders by property and issue category.
-- Q4: Show technicians assigned at least 4 open work orders.
-- Q5. Find units with more work orders than the average unit. Use a nested query or CTE.


-- Q1. List open high-priority work orders older than 7 days

SELECT
    wo.work_order_id,
    p.property_name,
    u.unit_number,
    wo.priority,
    wo.status,
    wo.submitted_at,
    CURRENT_TIMESTAMP - wo.submitted_at AS time_since_submission
FROM WORK_ORDER AS wo
JOIN UNIT AS u
    ON wo.unit_id = u.unit_id
JOIN PROPERTY AS p
    ON u.property_id = p.property_id
WHERE wo.status = 'OPEN'
  AND wo.priority = 'HIGH'
  AND wo.submitted_at < CURRENT_TIMESTAMP - INTERVAL '7 days'
ORDER BY wo.submitted_at ASC;


-- Q2. Show each work order with property, unit, issue category, assigned technician, and status
-- LEFT JOIN keeps unassigned work orders in the results.
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
    ON wa.technician_id = t.technician_id
ORDER BY wo.work_order_id, t.technician_code;


-- Q3. Count work orders by property and issue category
-- Properties/categories with no matching work orders are not shown.
SELECT
    p.property_name,
    ic.category_name AS issue_category,
    COUNT(wo.work_order_id) AS work_order_count
FROM WORK_ORDER AS wo
JOIN UNIT AS u
    ON wo.unit_id = u.unit_id
JOIN PROPERTY AS p
    ON u.property_id = p.property_id
JOIN ISSUE_CATEGORY AS ic
    ON wo.category_id = ic.category_id
GROUP BY
    p.property_id,
    p.property_name,
    ic.category_id,
    ic.category_name
ORDER BY
    p.property_name,
    ic.category_name;


-- Q4: Show technicians assigned at least 4 open work orders
-- "Open" is defined here as status = 'OPEN'.
-- COUNT(DISTINCT ...) avoids double-counting a work order if assignment
-- records happen to contain duplicates for the same technician/work order.
SELECT
    t.technician_id,
    t.technician_code,
    COUNT(DISTINCT wo.work_order_id) AS open_work_order_count
FROM TECHNICIAN AS t
JOIN WORK_ASSIGNMENT AS wa
    ON t.technician_id = wa.technician_id
JOIN WORK_ORDER AS wo
    ON wa.work_order_id = wo.work_order_id
WHERE wo.status = 'OPEN'
GROUP BY
    t.technician_id,
    t.technician_code
HAVING COUNT(DISTINCT wo.work_order_id) >= 4
ORDER BY open_work_order_count DESC, t.technician_code;


-- Q5. Find units with more work orders than the average unit. Use a nested query or CTE
-- The CTE includes every unit, even units with zero work orders.
WITH unit_work_order_counts AS (
    SELECT
        u.unit_id,
        p.property_name,
        u.unit_number,
        COUNT(wo.work_order_id) AS work_order_count
    FROM UNIT AS u
    JOIN PROPERTY AS p
        ON u.property_id = p.property_id
    LEFT JOIN WORK_ORDER AS wo
        ON u.unit_id = wo.unit_id
    GROUP BY
        u.unit_id,
        p.property_name,
        u.unit_number
)
SELECT
    unit_id,
    property_name,
    unit_number,
    work_order_count
FROM unit_work_order_counts
WHERE work_order_count > (
    SELECT AVG(work_order_count::NUMERIC)
    FROM unit_work_order_counts
)
ORDER BY work_order_count DESC, property_name, unit_number;
