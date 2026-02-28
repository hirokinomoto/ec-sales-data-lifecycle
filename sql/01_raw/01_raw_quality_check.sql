-- raw品質チェック（取り込み事故検知：欠損・異常値・想定外・未来日）
-- 目的：raw取り込み後に「異常がどれだけあるか」を数で把握し、調査/停止判断の材料にする

WITH base AS (
  SELECT *
  FROM `ec-sales-lifecycle.ec_sales.orders_raw`
)

SELECT
  COUNT(*) AS row_count,
  COUNT(DISTINCT order_id) AS distinct_order_id,
  COUNT(DISTINCT customer_id) AS distinct_customer_id,

  -- 必須項目の欠損（空文字も欠損扱い）
  SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS missing_order_id,
  SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS missing_customer_id,
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS missing_order_date,

  -- 金額・数量の異常
  SUM(CASE WHEN quantity IS NULL OR quantity <= 0 THEN 1 ELSE 0 END) AS bad_quantity,
  SUM(CASE WHEN unit_price IS NULL OR unit_price <= 0 THEN 1 ELSE 0 END) AS bad_unit_price,
  SUM(CASE WHEN amount IS NULL OR amount <= 0 THEN 1 ELSE 0 END) AS bad_amount,

  -- statusの想定外
  SUM(CASE WHEN status NOT IN ('PAID','CANCELLED','REFUNDED','PENDING') THEN 1 ELSE 0 END) AS unexpected_status,

  -- 未来日（今日より後）
  SUM(CASE WHEN order_date > CURRENT_DATE() THEN 1 ELSE 0 END) AS future_order_date
FROM base;
