-- raw重複チェック（完全一致行の重複検知）
-- 目的：取り込み二重などにより、同じ明細行が重複していないかを検知する

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT TO_JSON_STRING(t)) AS distinct_rows,
  COUNT(*) - COUNT(DISTINCT TO_JSON_STRING(t)) AS duplicate_rows
FROM `ec-sales-lifecycle.ec_sales.orders_raw` t;
