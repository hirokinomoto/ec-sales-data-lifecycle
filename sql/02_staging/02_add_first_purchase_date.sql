-- first_purchase_date 付与（valid注文前提で顧客の初回購入日を作る）
-- 目的：新規/既存判定（初回購入月ベース）の土台となる列をstagingに追加する

CREATE OR REPLACE TABLE `ec-sales-lifecycle.ec_sales.orders_stg` AS
WITH base AS (
  SELECT
    order_id,
    order_date,
    customer_id,
    product_id,
    product_name,
    category,
    quantity,
    unit_price,
    amount,
    status,
    is_valid_order
  FROM `ec-sales-lifecycle.ec_sales.orders_stg`
),
first_purchase AS (
  SELECT
    customer_id,
    MIN(order_date) AS first_purchase_date
  FROM base
  WHERE is_valid_order = 1
    AND customer_id IS NOT NULL
    AND customer_id <> ''
    AND order_date IS NOT NULL
  GROUP BY customer_id
)
SELECT
  b.*,
  fp.first_purchase_date
FROM base b
LEFT JOIN first_purchase fp
USING (customer_id);