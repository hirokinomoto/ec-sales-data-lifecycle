CREATE OR REPLACE VIEW `ec-sales-lifecycle.ec_sales.v_kpi_monthly_by_category` AS
SELECT
  order_month,
  category,
  sales_amount,
  order_count,
  customer_count,
  aov,
  arpu
FROM `ec-sales-lifecycle.ec_sales.kpi_monthly_by_category`;