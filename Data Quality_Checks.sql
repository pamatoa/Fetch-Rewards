Data Quality

1. Check for NULL values in key columns
SELECT
    'Users' AS table_name,
    COUNT(*) AS null_count,
    'user_id' AS column_name
FROM Users WHERE user_id IS NULL
UNION ALL
SELECT
    'Users',
    COUNT(*),
    'username'
FROM Users WHERE username IS NULL
UNION ALL
SELECT
    'Users',
    COUNT(*),
    'email'
FROM Users WHERE email IS NULL
UNION ALL
SELECT
    'Users',
    COUNT(*),
    'registration_date'
FROM Users WHERE registration_date IS NULL
UNION ALL
SELECT
    'Brands',
    COUNT(*),
    'brand_id'
FROM Brands WHERE brand_id IS NULL
UNION ALL
SELECT
    'Brands',
    COUNT(*),
    'brand_name'
FROM Brands WHERE brand_name IS NULL
UNION ALL
SELECT
    'Brands',
    COUNT(*),
    'brand_category'
FROM Brands WHERE brand_category IS NULL
UNION ALL
SELECT
    'Receipts',
    COUNT(*),
    'receipt_id'
FROM Receipts WHERE receipt_id IS NULL
UNION ALL
SELECT
    'Receipts',
    COUNT(*),
    'user_id'
FROM Receipts WHERE user_id IS NULL
UNION ALL
SELECT
    'Receipts',
    COUNT(*),
    'brand_id'
FROM Receipts WHERE brand_id IS NULL
UNION ALL
SELECT
    'Receipts',
    COUNT(*),
    'purchase_date'
FROM Receipts WHERE purchase_date IS NULL
UNION ALL
SELECT
    'Receipts',
    COUNT(*),
    'total_amount'
FROM Receipts WHERE total_amount IS NULL
UNION ALL
SELECT
    'Receipts',
    COUNT(*),
    'payment_method'
FROM Receipts WHERE payment_method IS NULL
UNION ALL
SELECT
    'Receipt_Items',
    COUNT(*),
    'receipt_id'
FROM Receipt_Items WHERE receipt_id IS NULL
UNION ALL
SELECT
    'Receipt_Items',
    COUNT(*),
    'item_name'
FROM Receipt_Items WHERE item_name IS NULL
UNION ALL
SELECT
    'Receipt_Items',
    COUNT(*),
    'quantity'
FROM Receipt_Items WHERE quantity IS NULL
UNION ALL
SELECT
    'Receipt_Items',
    COUNT(*),
    'price'
FROM Receipt_Items WHERE price IS NULL;

2. Check for duplicate records in key tables
SELECT
    'Users' AS table_name,
    COUNT(*) - COUNT(DISTINCT user_id) AS duplicate_count
FROM Users
UNION ALL
SELECT
    'Brands',
    COUNT(*) - COUNT(DISTINCT brand_id) AS duplicate_count
FROM Brands
UNION ALL
SELECT
    'Receipts',
    COUNT(*) - COUNT(DISTINCT receipt_id) AS duplicate_count
FROM Receipts;

3. Check for invalid date formats
SELECT
    'Users' AS table_name,
    COUNT(*) AS invalid_date_count
FROM Users
WHERE
    registration_date IS NOT NULL AND
    NOT REGEXP_LIKE(registration_date, '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z$')
UNION ALL
SELECT
    'Receipts',
    COUNT(*)
FROM Receipts
WHERE
    purchase_date IS NOT NULL AND
    NOT REGEXP_LIKE(purchase_date, '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z$');

4. Check for inconsistent data in categorical columns
SELECT
    'Receipts' AS table_name,
    payment_method,
    COUNT(*) AS count
FROM Receipts
GROUP BY payment_method
ORDER BY count DESC;

SELECT
    'Brands' AS table_name,
    brand_category,
    COUNT(*) AS count
FROM Brands
GROUP BY brand_category
ORDER BY count DESC;

5. Check for negative or zero values in numeric columns
SELECT
    'Receipts' AS table_name,
    COUNT(*) AS invalid_count
FROM Receipts
WHERE total_amount <= 0
UNION ALL
SELECT
    'Receipt_Items',
    COUNT(*)
FROM Receipt_Items
WHERE quantity <= 0
UNION ALL
SELECT
    'Receipt_Items',
    COUNT(*)
FROM Receipt_Items
WHERE price <= 0;

6. Check for orphaned records in Receipts table
SELECT
    'Receipts' AS table_name,
    COUNT(*) AS orphaned_count
FROM Receipts r
LEFT JOIN Users u ON r.user_id = u.user_id
WHERE u.user_id IS NULL
UNION ALL
SELECT
    'Receipts',
    COUNT(*)
FROM Receipts r
LEFT JOIN Brands b ON r.brand_id = b.brand_id
WHERE b.brand_id IS NULL;

7. Check for inconsistent email formats
SELECT
    'Users' AS table_name,
    COUNT(*) AS invalid_email_count
FROM Users
WHERE
    email IS NOT NULL AND
    NOT REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$');


Explanation of Queries:
1.	Check for NULL values in key columns: This query identifies the number of NULL values in each key column of each table. NULL values in primary or foreign key columns can cause issues with data integrity and relationships.
2.	Check for duplicate records in key tables: This query checks for duplicate records based on the primary key in the Users, Brands, and Receipts tables. Duplicate records can lead to incorrect analysis.
3.	Check for invalid date formats: This query checks if the registration_date in Users and purchase_date in Receipts conform to the expected ISO 8601 format. Incorrect date formats can cause parsing errors.
4.	Check for inconsistent data in categorical columns: This query lists the unique values and their counts for payment_method in Receipts and brand_category in Brands. This helps identify inconsistencies or typos in categorical data.
5.	Check for negative or zero values in numeric columns: This query checks for invalid values (zero or negative) in total_amount in Receipts, and quantity and price in Receipt_Items. These values are usually not valid in these contexts.
6.	Check for orphaned records in Receipts table: This query checks for records in the Receipts table that do not have corresponding records in the Users or Brands tables. Orphaned records indicate data integrity issues.
7.	Check for inconsistent email formats: This query checks if the email in Users conforms to a basic email format using a regular expression.

