WITH base AS (
  SELECT
    order_month,
    SUM(amount) AS sales_amount,
    COUNT(DISTINCT order_id) AS order_count,
    COUNT(DISTINCT customer_id) AS customer_count,
    SAFE_DIVIDE(SUM(amount), COUNT(DISTINCT order_id)) AS aov,
    SAFE_DIVIDE(SUM(amount), COUNT(DISTINCT customer_id)) AS arpu
  FROM `ec-sales-lifecycle.ec_sales.orders_stg`
  WHERE is_valid_order = 1
    AND order_month IS NOT NULL
  GROUP BY order_month
)
SELECT
  b.order_month,

  b.sales_amount AS base_sales_amount,
  m.sales_amount AS mart_sales_amount,
  (b.sales_amount - IFNULL(m.sales_amount, 0)) AS diff_sales_amount,

  b.order_count AS base_order_count,
  m.order_count AS mart_order_count,
  (b.order_count - IFNULL(m.order_count, 0)) AS diff_order_count,

  b.customer_count AS base_customer_count,
  m.customer_count AS mart_customer_count,
  (b.customer_count - IFNULL(m.customer_count, 0)) AS diff_customer_count,

  b.aov AS base_aov,
  m.aov AS mart_aov,

  b.arpu AS base_arpu,
  m.arpu AS mart_arpu
FROM base b
LEFT JOIN `ec-sales-lifecycle.ec_sales.kpi_monthly` m
  ON b.order_month = m.order_month
ORDER BY b.order_month;