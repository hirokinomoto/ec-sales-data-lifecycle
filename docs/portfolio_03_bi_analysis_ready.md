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

---

## Looker Studio 作業メモ（作成ログ）

### レポート情報
- レポート名：ec-sales-lifecycle（任意で変更）
- データソース：
  - BigQuery: `ec_sales.v_kpi_monthly`
  - BigQuery: `ec_sales.v_kpi_monthly_by_category`

### 作成する最小ダッシュボード（1ページ）
- KPIカード：sales_amount / order_count / customer_count / aov / arpu
- 月次推移：order_month × sales_amount
- カテゴリ別（月次）：order_month × sales_amount（breakdown: category）
- カテゴリ構成比：category × sales_amount
- フィルタ：order_month、category

### メモ
- 接続と表示確認：未/済
- KPIカード作成：未/済
- 時系列作成：未/済
- カテゴリ別グラフ作成：未/済
- フィルタ追加：未/済
- スクショ保存先（任意）：viz/ に保存予定