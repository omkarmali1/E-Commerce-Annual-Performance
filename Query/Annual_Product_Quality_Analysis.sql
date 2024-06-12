-- STAGE 3 :- Annual Product Quality Analysis 


-- 1) Create a table containing the company's total revenue information for each year
CREATE TABLE total_revenue AS
SELECT
   EXTRACT(YEAR FROM od.order_purchase_timestamp) AS year,
   SUM(oid.price + oid.freight_value) AS revenue
FROM order_items_dataset AS oid
JOIN orders_dataset AS od
   ON oid.order_id = od.order_id
WHERE od.order_status LIKE 'delivered'
GROUP BY 1
ORDER BY 1;


-- 2) Create a table containing the total number of canceled orders for each year.

CREATE TABLE canceled_order AS
SELECT
	EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
	COUNT(order_status) AS canceled
FROM orders_dataset
WHERE order_status LIKE 'canceled'
GROUP BY 1
ORDER BY 1;
		
-- 3) Create a table containing the product category names that provide the highest total revenue for each year
CREATE TABLE top_product_category AS
SELECT 
  year,
  top_category,
  product_revenue
FROM (
  SELECT
    EXTRACT(YEAR FROM shipping_limit_date) AS year,
    pd.product_category_name AS top_category,
    SUM(oid.price + oid.freight_value) AS product_revenue,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM shipping_limit_date)
                  ORDER BY SUM(oid.price + oid.freight_value) DESC) AS ranking
  FROM orders_dataset AS od 
  JOIN order_items_dataset AS oid
    ON od.order_id = oid.order_id
  JOIN product_dataset AS pd
    ON oid.product_id = pd.product_id
  WHERE od.order_status LIKE 'delivered'
  GROUP BY 1, 2
) AS sub
WHERE ranking = 1;

	

-- 4) Create a table containing the product category names with the highest number of canceled orders for each year
CREATE TABLE most_canceled_category AS
SELECT 
    year,
    most_canceled,
    total_canceled
FROM (
    SELECT
        EXTRACT(YEAR FROM shipping_limit_date) AS year,
        pd.product_category_name AS most_canceled,
        COUNT(od.order_id) AS total_canceled,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM shipping_limit_date)
                     ORDER BY COUNT(od.order_id) DESC) AS ranking
    FROM orders_dataset AS od 
    JOIN order_items_dataset AS oid
        ON od.order_id = oid.order_id
    JOIN product_dataset AS pd
        ON oid.product_id = pd.product_id
    WHERE od.order_status LIKE 'canceled'
    GROUP BY 1, 2
) AS sub
WHERE ranking = 1;

-- Additional - Remove data anomalies by year
DELETE FROM top_product_category WHERE year = 2020;
DELETE FROM most_canceled_category WHERE year = 2020;


-- Display the required table
SELECT 
	tr.year,
	tr.revenue AS total_revenue,
	tpc.top_category AS top_product,
	tpc.product_revenue AS total_revenue_top_product,
	co.canceled AS total_canceled,
	mcc.most_canceled AS top_canceled_product,
	mcc.total_canceled AS total_top_canceled_product
FROM total_revenue AS tr
JOIN top_product_category AS tpc
	ON tr.year = tpc.year
JOIN canceled_order AS co
	ON tpc.year = co.year
JOIN most_canceled_category AS mcc
	ON co.year = mcc.year
ORDER BY 1;
