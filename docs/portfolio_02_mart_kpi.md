# Portfolio #2: mart（KPI集計・検算）

## 目的

stagingで整形・品質管理したデータをもとに、月次KPIを再現可能な形で集計する。
「分析結果を断言」するのではなく、KPIの定義・粒度・集計条件・検算観点を明確にする。

---

## 対象

- 入力：`ec_sales.orders_stg`
- 出力：`ec_sales.kpi_monthly`

---

## 前提（重要）

- `orders_stg` の粒度は **1行 = 注文明細（order_id × product_id）**
- KPI対象は **原則 `is_valid_order = 1`**
- 月次集計は `order_month`
- 注文件数・購入者数は DISTINCT で算出する（明細数を数えない）

---

## kpi_monthly 設計

**粒度：1行 = 1か月**

| column         | 定義                                                    |
| -------------- | ------------------------------------------------------- |
| order_month    | 集計対象月                                              |
| sales_amount   | `SUM(amount)`                                           |
| order_count    | `COUNT(DISTINCT order_id)`                              |
| customer_count | `COUNT(DISTINCT customer_id)`                           |
| aov            | `SAFE_DIVIDE(SUM(amount), COUNT(DISTINCT order_id))`    |
| arpu           | `SAFE_DIVIDE(SUM(amount), COUNT(DISTINCT customer_id))` |

---

## DISTINCT が必要な理由

`orders_stg` は注文明細粒度のため、1つの注文に複数商品があると `order_id` が複数行になる。
そのため `COUNT(*)` は注文件数ではなく明細行数になる。
よって注文件数は `COUNT(DISTINCT order_id)`、購入者数は `COUNT(DISTINCT customer_id)` とする。

### DISTINCT が必要な根拠（実データ確認）

月次で `COUNT(*)`（明細行数）と `COUNT(DISTINCT order_id)`（注文件数）が一致しないことを確認した。

例：

- 2025-09: 明細行数 43 / 注文件数 23 / 購入者数 17
- 2025-10: 明細行数 32 / 注文件数 17 / 購入者数 15
- 2025-11: 明細行数 27 / 注文件数 16 / 購入者数 15

---

## 作成SQL / 検算SQL

- 作成：`sql/03_mart/01_create_kpi_monthly.sql`
- 検算：`sql/03_mart/02_validate_kpi_monthly.sql`
- 根拠（DISTINCT確認）：`sql/03_mart/03_validate_distinct_logic.sql`

---

## 検算観点

- 売上：元データ（valid注文）の `SUM(amount)` と mart の `sales_amount` が一致する
- 注文件数：`COUNT(DISTINCT order_id)` を使っている（`COUNT(*)` ではない）
- 購入者数：`COUNT(DISTINCT customer_id)` を使っている
- AOV/ARPU：分母がそれぞれ 注文件数 / 購入者数 である
- invalid混入防止：`WHERE is_valid_order = 1` が入っている

---

## 検算結果（サマリ）

検算SQLにより、`sales_amount / order_count / customer_count` の差分（diff）が全月で0であることを確認した。
これにより `kpi_monthly` が `orders_stg` から定義どおり再現できている。
