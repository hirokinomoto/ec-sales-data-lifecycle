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
- レポート名：EC Sales KPI Dashboard（任意で変更可）
- データソース（BigQuery View）
  - `ec_sales.v_kpi_monthly`
  - `ec_sales.v_kpi_monthly_by_category`

### 作成した最小ダッシュボード（1ページ）
- KPIカード：`sales_amount` / `order_count` / `customer_count` / `aov` / `arpu`
- 月次推移：`order_month` × `sales_amount`（棒グラフ）
- カテゴリ別（月次）：`order_month` × `sales_amount`（内訳：`category`、積み上げ棒）
- カテゴリ構成比：`category` × `sales_amount`（円グラフ）
- フィルタ：`order_month`（プルダウン、月を1つ選択）

### 検証ポイント
- `order_month` のプルダウン変更に合わせて、KPI・カテゴリ構成比が連動して変化することを確認済み。

### スクリーンショット（保存先：`viz/`）
※ このリポジトリでは、提出用に最低2枚のスクショを保存する想定。
- `viz/dashboard_overview.png`（全体：KPI＋月次推移＋カテゴリ別＋構成比）
- `viz/dashboard_month_YYYY-MM.png`（月を1つ選択した状態）

### 作業状況（更新）
- 接続と表示確認：済
- KPIカード作成：済
- 月次推移：済（棒グラフ）
- カテゴリ別グラフ：済（積み上げ棒）
- カテゴリ構成比：済（円グラフ）
- フィルタ：済（order_month）
- スクショ：未（`viz/` に保存して追記予定）

