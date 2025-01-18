SQL

SQL queries to answer each question:
1. What are the top 5 brands by receipts scanned for the most recent month?
-- Query 1: Top 5 brands by receipts scanned for the most recent month
SELECT
    b.brand_name,
    COUNT(r.receipt_id) AS receipt_count
FROM
    Brands b
JOIN
    Receipts r ON b.brand_id = r.brand_id
WHERE
    r.purchase_date >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY
    b.brand_name
ORDER BY
    receipt_count DESC
LIMIT 5;

2. How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
-- Query 2: Compare top 5 brands by receipts scanned for recent vs previous month
WITH RecentMonth AS (
    SELECT
        b.brand_name,
        COUNT(r.receipt_id) AS receipt_count,
        RANK() OVER (ORDER BY COUNT(r.receipt_id) DESC) as rank
    FROM
        Brands b
    JOIN
        Receipts r ON b.brand_id = r.brand_id
    WHERE
        r.purchase_date >= DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY
        b.brand_name
),
PreviousMonth AS (
    SELECT
        b.brand_name,
        COUNT(r.receipt_id) AS receipt_count,
        RANK() OVER (ORDER BY COUNT(r.receipt_id) DESC) as rank
    FROM
        Brands b
    JOIN
        Receipts r ON b.brand_id = r.brand_id
    WHERE
        r.purchase_date >= DATE_TRUNC('month', DATE_SUB(CURRENT_DATE, INTERVAL '1 month'))
        AND r.purchase_date < DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY
        b.brand_name
)
SELECT
    COALESCE(rm.brand_name, pm.brand_name) AS brand_name,
    rm.rank AS recent_month_rank,
    pm.rank AS previous_month_rank
FROM
    RecentMonth rm
FULL OUTER JOIN
    PreviousMonth pm ON rm.brand_name = pm.brand_name
ORDER BY
    COALESCE(rm.rank, 9999), COALESCE(pm.rank, 9999)
LIMIT 5;

3. When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
-- Query 3: Compare average spend for 'Accepted' vs 'Rejected' receipts
SELECT
    rewardsReceiptStatus,
    AVG(total_amount) AS average_spend
FROM
    Receipts
WHERE
    rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY
    rewardsReceiptStatus
ORDER BY
    average_spend DESC;

4. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
-- Query 4: Compare total items purchased for 'Accepted' vs 'Rejected' receipts
SELECT
    r.rewardsReceiptStatus,
    SUM(ri.quantity) AS total_items
FROM
    Receipts r
JOIN
    Receipt_Items ri ON r.receipt_id = ri.receipt_id
WHERE
    r.rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY
    r.rewardsReceiptStatus
ORDER BY
    total_items DESC;

5. Which brand has the most spend among users who were created within the past 6 months?
-- Query 5: Brand with most spend among users created in the past 6 months
SELECT
    b.brand_name,
    SUM(r.total_amount) AS total_spend
FROM
    Brands b
JOIN
    Receipts r ON b.brand_id = r.brand_id
JOIN
    Users u ON r.user_id = u.user_id
WHERE
    u.registration_date >= DATE_SUB(CURRENT_DATE, INTERVAL '6 month')
GROUP BY
    b.brand_name
ORDER BY
    total_spend DESC
LIMIT 1;
 
6. Which brand has the most transactions among users who were created within the past 6 months?
-- Query 6: Brand with most transactions among users created in the past 6 months
SELECT
    b.brand_name,
    COUNT(r.receipt_id) AS transaction_count
FROM
    Brands b
JOIN
    Receipts r ON b.brand_id = r.brand_id
JOIN
    Users u ON r.user_id = u.user_id
WHERE
    u.registration_date >= DATE_SUB(CURRENT_DATE, INTERVAL '6 month')
GROUP BY
    b.brand_name
ORDER BY
    transaction_count DESC
LIMIT 1;

Explanation:
•	Query 1: Retrieves the top 5 brands by the number of receipts scanned in the current month.
•	Query 2: Compares the ranking of the top brands by receipts scanned between the current and previous month using Common Table Expressions (CTEs) and RANK() window function.
•	Query 3: Calculates and compares the average spend for receipts with 'Accepted' and 'Rejected' rewardsReceiptStatus.
•	Query 4: Calculates and compares the total number of items purchased for receipts with 'Accepted' and 'Rejected' rewardsReceiptStatus.
•	Query 5: Identifies the brand with the most spend among users who registered within the last 6 months.
•	Query 6: Identifies the brand with the most transactions among users who registered within the last 6 months.
Assumptions:
•	CURRENT_DATE is a function or variable that returns the current date.
•	DATE_TRUNC('month', date) truncates a date to the beginning of the month.
•	DATE_SUB(date, INTERVAL 'n month') subtracts n months from a date.
•	The rewardsReceiptStatus column exists in the Receipts table.
