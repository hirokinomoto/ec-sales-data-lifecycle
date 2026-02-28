-- customer_type 付与（初回購入月ベースで new / existing を判定）
-- 目的：新規/既存の定義を固定し、KPIや可視化で同じ基準が使えるようにする

CREATE OR REPLACE TABLE `ec-sales-lifecycle.ec_sales.orders_stg` AS
SELECT
  *,
  DATE_TRUNC(order_date, MONTH) AS order_month,
  DATE_TRUNC(first_purchase_date, MONTH) AS first_purchase_month,
  CASE
    WHEN is_valid_order = 0 THEN NULL
    WHEN first_purchase_date IS NULL THEN NULL
    WHEN DATE_TRUNC(order_date, MONTH) = DATE_TRUNC(first_purchase_date, MONTH) THEN 'new'
    ELSE 'existing'
  END AS customer_type
FROM `ec-sales-lifecycle.ec_sales.orders_stg`;
