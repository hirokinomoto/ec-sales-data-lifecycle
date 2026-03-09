# Portfolio #3: BI（分析できる状態に整備）

## 目的
「分析結果を断言」するのではなく、KPIをいつでも再現・可視化できる状態（analysis-ready）を整える。

---

## BIで使用するデータソース（BigQuery View）
Looker Studio から参照する対象を view に固定し、列定義を安定させる。

- `ec_sales.v_kpi_monthly`
- `ec_sales.v_kpi_monthly_by_category`

### 作成SQL（SSOT）
- `sql/04_analysis_ready/01_create_view_v_kpi_monthly.sql`
- `sql/04_analysis_ready/02_create_view_v_kpi_monthly_by_category.sql`

---

## 最低限のダッシュボード構成（予定）
- KPIカード：売上 / 注文件数 / 購入者数 / AOV / ARPU
- 月次推移：売上（sales_amount）
- カテゴリ別：月×カテゴリ（sales_amount）
- フィルタ：order_month / category