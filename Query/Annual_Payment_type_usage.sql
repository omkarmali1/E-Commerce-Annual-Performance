
-- STAGE 4 :- Annual Payment type usage


-- 1) Display the total usage count of each payment type all-time sorted from most favorite to least favorite
SELECT payment_type, COUNT(1) 
FROM order_payments_dataset
GROUP BY 1
ORDER BY 2 DESC;

-- 2) Display detailed information on the usage count of each payment type for each year
SELECT
    payment_type,
    SUM(CASE WHEN year = 2016 THEN total ELSE 0 END) AS "2016",
    SUM(CASE WHEN year = 2017 THEN total ELSE 0 END) AS "2017",
    SUM(CASE WHEN year = 2018 THEN total ELSE 0 END) AS "2018",
    SUM(total) AS sum_payment_type_usage
FROM (
    SELECT 
        EXTRACT(YEAR FROM od.order_purchase_timestamp) AS year,
        opd.payment_type,
        COUNT(opd.payment_type) AS total
    FROM orders_dataset AS od
    JOIN order_payments_dataset AS opd 
        ON od.order_id = opd.order_id
    GROUP BY 1, 2
) AS sub
GROUP BY 1
ORDER BY 2 DESC;

