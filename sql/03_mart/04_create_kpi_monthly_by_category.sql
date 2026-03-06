CREATE OR REPLACE TABLE `ec-sales-lifecycle.ec_sales.kpi_monthly_by_category` AS
SELECT
  order_month,
  category,
  SUM(amount) AS sales_amount,
  COUNT(DISTINCT order_id) AS order_count,
  COUNT(DISTINCT customer_id) AS customer_count,
  SAFE_DIVIDE(SUM(amount), COUNT(DISTINCT order_id)) AS aov,
  SAFE_DIVIDE(SUM(amount), COUNT(DISTINCT customer_id)) AS arpu
FROM `ec-sales-lifecycle.ec_sales.orders_stg`
WHERE is_valid_order = 1
  AND order_month IS NOT NULL
  AND category IS NOT NULL
GROUP BY
  order_month,
  category
ORDER BY
  order_month,
  category;