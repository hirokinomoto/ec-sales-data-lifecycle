# EC Sales Data Lifecycle Project

EC売上データ（架空）を使って、入社〜1年目レベルのデータ職（データアナリスト／データエンジニア）が行う **実務フロー（raw → staging → mart → BI）** を再現するポートフォリオです。  
「分析結果を断言する」よりも、**分析できる状態を作る（設計・整形・品質・再現性）** ことを重視しています。

---

## 目的

- 実務フロー（raw → staging → mart → BI）を再現し、業務理解を示す
- SQLによる整形・集計能力の証明（主目的の次点）
- データ品質設計（事故検知・監視・定義固定）の理解
- 「分析できる状態」を作る（架空データのため施策の正解は断言しない）

---

## 成果物（3部構成）

本プロジェクトは **1つのリポジトリ** で管理しつつ、成果物として **#1〜#3** に分割して提示します。

### #1 整形・品質管理（raw / staging）
- 目的：取り込み事故検知と、整形・品質監視（分析対象の固定）
- 成果物：品質チェックSQL、staging生成SQL、定義（is_valid_order / first_purchase_date / new/existing）
- ドキュメント：`docs/portfolio_01_raw_staging.md`
- SQL：`sql/01_raw/` `sql/02_staging/`

### #2 KPI集計・検算（mart）
- 目的：月次KPIを再現可能に作成し、検算と定義の明確化を示す
- 成果物：mart設計、月次KPI SQL、カテゴリ別KPI SQL、検算観点
- ドキュメント：`docs/portfolio_02_mart_kpi.md`（作成予定）
- SQL：`sql/03_mart/`

### #3 可視化まで整備（BI）
- 目的：「分析する」ではなく「分析できる状態」に整える
- 成果物：BI用view（任意）、ダッシュボード仕様、最低限のダッシュボード
- ドキュメント：`docs/portfolio_03_bi_analysis_ready.md`（作成予定）
- 資料：`viz/`

---

## 技術スタック

- DWH：BigQuery
- SQL実行：BigQuery Console
- 可視化：Looker Studio（#3で使用）
- Git管理：GitHub
- Python：pandas（品質チェック補助用途。必須ではなく補助）

---

## データ設計（確定ルール）

- 粒度：`orders` は **1行 = 注文明細（order_id × product_id）**
- KPI対象：原則 `is_valid_order = 1`
- 新規/既存：**初回購入月ベース（valid注文前提）**

---

## ディレクトリ構成

- `docs/`：設計・まとめ（#1〜#3）
- `sql/`：SQL（raw / staging / mart / analysis-ready）
- `data/`：公開可能な架空データのみ
- `viz/`：ダッシュボード仕様・スクショ等

---

## 実行順序（要約）

1. raw作成 → CSV取り込み → raw品質チェック
2. staging生成 → staging品質チェック（is_valid_order / first_purchase_date / customer_type）
3. mart作成（KPI）
4. Looker Studioで可視化（分析可能状態）

---

## 補足

- `data/` 配下のデータは **架空データ** です。
- 本リポジトリは「業務フロー理解・再現性・定義固定」を重視して作成しています。