-- Olist Brazilian E-commerce | Final business analysis
-- Database: olist_ecommerce_analysis_1
-- Sales = recorded item prices, excluding freight; not marketplace net revenue.
-- Source notes: reviews table previously reported 99,214 vs. 99,224 CSV rows.

USE olist_ecommerce_analysis_1;

-- 1. Overall item-sales value and order activity
SELECT
    ROUND(SUM(price), 2) AS total_product_sales,
    COUNT(DISTINCT order_id) AS orders_with_items,
    COUNT(*) AS item_records,
    ROUND(SUM(price) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS avg_order_value
FROM order_items;

-- 2. Monthly item sales, order volume, and average order value
-- Includes all order statuses to match the overall item-sales measure.
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS purchase_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS monthly_product_sales,
    ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS avg_order_value
FROM orders AS o
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY purchase_month;

-- 3. Delivery time for delivered orders with a recorded delivery date
SELECT
    COUNT(*) AS delivered_orders_with_date,
    ROUND(AVG(TIMESTAMPDIFF(SECOND, order_purchase_timestamp,
                            order_delivered_customer_date) / 86400.0), 2)
        AS avg_delivery_days,
    ROUND(MAX(TIMESTAMPDIFF(SECOND, order_purchase_timestamp,
                            order_delivered_customer_date) / 86400.0), 2)
        AS max_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

-- 4. Late delivery count and rate
SELECT
    COUNT(*) AS total_deliveries,
    SUM(CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 1 ELSE 0
        END) AS late_deliveries,
    ROUND(AVG(CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 1 ELSE 0
        END) * 100, 2) AS late_delivery_pct
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

-- 5. Review scores by delivery status (association, not causation)
-- COUNT(*) here counts review rows, not necessarily distinct orders.
SELECT
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(*) AS review_records,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders AS o
INNER JOIN reviews AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status
ORDER BY delivery_status;
