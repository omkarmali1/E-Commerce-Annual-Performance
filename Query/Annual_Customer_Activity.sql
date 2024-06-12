-- STAGE 2 :- Annual Customer Activity growth


-- 1 Display the average monthly active user count for each year

SELECT year, FLOOR(AVG(customer_total)) AS avg_mau
FROM (
    SELECT 
        EXTRACT(YEAR FROM od.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM od.order_purchase_timestamp) AS month,
        COUNT(DISTINCT cd.customer_unique_id) AS customer_total
    FROM orders_dataset AS od
    JOIN customers_dataset AS cd
        ON cd.customer_id = od.customer_id
    GROUP BY 1, 2
    ) AS sub
GROUP BY 1
ORDER BY 1;

-- 2 Display the total number of new customers for each year

SELECT year, COUNT(customer_unique_id) AS total_new_customer
FROM (
    SELECT
        MIN(EXTRACT(YEAR FROM od.order_purchase_timestamp)) AS year,
        cd.customer_unique_id
    FROM orders_dataset AS od
    JOIN customers_dataset AS cd
        ON cd.customer_id = od.customer_id
    GROUP BY 2
    ) AS sub
GROUP BY 1
ORDER BY 1;

-- 3 Display the total number of repeat customers for each year

SELECT year, COUNT(customer_unique_id) AS total_customer_repeat
FROM (
    SELECT
        EXTRACT(YEAR FROM od.order_purchase_timestamp) AS year,
        cd.customer_unique_id,
        COUNT(od.order_id) AS total_order
    FROM orders_dataset AS od
    JOIN customers_dataset AS cd
        ON cd.customer_id = od.customer_id
    GROUP BY 1, 2
    HAVING COUNT(2) > 1
    ) AS sub
GROUP BY 1
ORDER BY 1;

-- 4 Display the average number of orders placed by each customer for each year

SELECT year, ROUND(AVG(freq), 3) AS avg_frequency
FROM (
    SELECT
        EXTRACT(YEAR FROM od.order_purchase_timestamp) AS year,
        cd.customer_unique_id,
        COUNT(order_id) AS freq
    FROM orders_dataset AS od
    JOIN customers_dataset AS cd
        ON cd.customer_id = od.customer_id
    GROUP BY 1, 2
    ) AS sub
GROUP BY 1
ORDER BY 1;

-- 5 Combine the successfully displayed metrics into one table view

WITH cte_mau AS (
    SELECT year, FLOOR(AVG(customer_total)) AS avg_mau
    FROM (
        SELECT 
            EXTRACT(YEAR FROM od.order_purchase_timestamp) AS year,
            EXTRACT(MONTH FROM od.order_purchase_timestamp) AS month,
            COUNT(DISTINCT cd.customer_unique_id) AS customer_total
        FROM orders_dataset AS od
        JOIN customers_dataset AS cd
            ON cd.customer_id = od.customer_id
        GROUP BY 1, 2
        ) AS sub
    GROUP BY 1
),

cte_new_cust AS (
    SELECT year, COUNT(customer_unique_id) AS total_new_customer
    FROM (
        SELECT
            MIN(EXTRACT(YEAR FROM od.order_purchase_timestamp)) AS year,
            cd.customer_unique_id
        FROM orders_dataset AS od
        JOIN customers_dataset AS cd
            ON cd.customer_id = od.customer_id
        GROUP BY 2
        ) AS sub
    GROUP BY 1
),

cte_repeat_order AS (
    SELECT year, COUNT(customer_unique_id) AS total_customer_repeat
    FROM (
        SELECT
            EXTRACT(YEAR FROM od.order_purchase_timestamp) AS year,
            cd.customer_unique_id,
            COUNT(od.order_id) AS total_order
        FROM orders_dataset AS od
        JOIN customers_dataset AS cd
            ON cd.customer_id = od.customer_id
        GROUP BY 1, 2
        HAVING COUNT(2) > 1
        ) AS sub
    GROUP BY 1
),

cte_frequency AS (
    SELECT year, ROUND(AVG(freq), 3) AS avg_frequency
    FROM (
        SELECT
            EXTRACT(YEAR FROM od.order_purchase_timestamp) AS year,
            cd.customer_unique_id,
            COUNT(order_id) AS freq
        FROM orders_dataset AS od
        JOIN customers_dataset AS cd
            ON cd.customer_id = od.customer_id
        GROUP BY 1, 2
        ) AS sub
    GROUP BY 1
)

SELECT
    mau.year AS year,
    avg_mau,
    total_new_customer,
    total_customer_repeat,
    avg_frequency
FROM
    cte_mau AS mau
    JOIN cte_new_cust AS nc
        ON mau.year = nc.year
    JOIN cte_repeat_order AS ro
        ON nc.year = ro.year
    JOIN cte_frequency AS f
        ON ro.year = f.year
GROUP BY 1, 2, 3, 4, 5
ORDER BY 1;
