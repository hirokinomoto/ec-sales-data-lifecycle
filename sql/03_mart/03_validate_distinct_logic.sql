SELECT
  order_month,
  COUNT(*) AS detail_row_count,
  COUNT(DISTINCT order_id) AS distinct_order_count,
  COUNT(DISTINCT customer_id) AS distinct_customer_count
FROM `ec-sales-lifecycle.ec_sales.orders_stg`
WHERE is_valid_order = 1
  AND order_month IS NOT NULL
GROUP BY order_month
ORDER BY order_month;