CREATE OR REPLACE VIEW `ec-sales-lifecycle.ec_sales.v_kpi_monthly` AS
SELECT
  order_month,
  sales_amount,
  order_count,
  customer_count,
  aov,
  arpu
FROM `ec-sales-lifecycle.ec_sales.kpi_monthly`;