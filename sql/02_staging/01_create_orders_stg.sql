-- staging生成（空文字→NULL、完全重複除去、is_valid_order付与）
-- 目的：KPI対象を is_valid_order で固定し、以降（mart/BI）が再現可能になる土台を作る

CREATE OR REPLACE TABLE `ec-sales-lifecycle.ec_sales.orders_stg` AS
WITH base AS (
  SELECT
    *,
    -- 空文字をNULL扱いに寄せる（扱いやすくする）
    NULLIF(order_id, '') AS order_id_n,
    NULLIF(customer_id, '') AS customer_id_n
  FROM `ec-sales-lifecycle.ec_sales.orders_raw`
),
dedup AS (
  -- 完全重複行は1つに潰す（rawに重複があってもstagingは安定）
  SELECT * EXCEPT(row_num)
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (
        PARTITION BY TO_JSON_STRING(STRUCT(
          order_id, order_date, customer_id, product_id, product_name,
          category, quantity, unit_price, amount, status
        ))
        ORDER BY order_id
      ) AS row_num
    FROM base
  )
  WHERE row_num = 1
)
SELECT
  order_id_n AS order_id,
  order_date,
  customer_id_n AS customer_id,
  product_id,
  product_name,
  category,
  quantity,
  unit_price,
  amount,
  status,

  -- valid判定（固定定義）
  CASE
    WHEN order_id_n IS NULL THEN 0
    WHEN customer_id_n IS NULL THEN 0
    WHEN order_date IS NULL THEN 0
    WHEN order_date > CURRENT_DATE() THEN 0
    WHEN quantity IS NULL OR quantity <= 0 THEN 0
    WHEN unit_price IS NULL OR unit_price <= 0 THEN 0
    WHEN amount IS NULL OR amount <= 0 THEN 0
    WHEN status <> 'PAID' THEN 0
    ELSE 1
  END AS is_valid_order
FROM dedup;
