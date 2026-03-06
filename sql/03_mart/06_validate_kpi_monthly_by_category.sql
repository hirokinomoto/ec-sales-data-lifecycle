-- Validate: sales_amount should match between monthly KPI and sum of category KPIs
WITH cat AS (
  SELECT
    order_month,
    SUM(sales_amount) AS sum_sales_amount
  FROM `ec-sales-lifecycle.ec_sales.kpi_monthly_by_category`
  GROUP BY order_month
)
SELECT
  m.order_month,
  m.sales_amount AS monthly_sales_amount,
  c.sum_sales_amount AS by_category_sales_amount,
  (m.sales_amount - c.sum_sales_amount) AS diff_sales_amount
FROM `ec-sales-lifecycle.ec_sales.kpi_monthly` m
LEFT JOIN cat c
  ON m.order_month = c.order_month
ORDER BY m.order_month;