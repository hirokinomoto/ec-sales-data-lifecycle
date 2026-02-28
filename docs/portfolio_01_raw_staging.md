# ポートフォリオ #1：raw / staging（整形・品質管理）

対象：`raw → staging`  
目的：取り込み事故検知と、分析対象（KPI対象）をブレなく固定するための整形・品質監視の設計/実装

---

## 1. #1は何を目的にしたか

### 主目的
raw取り込み後に **事故検知** を行い、stagingで **分析対象を固定（is_valid_order）** して、以降の `mart / BI` が「同じ定義で再現」できる土台を作る。

### この部で「やらないこと（意図的にやらない）」
- 施策の当たり外れ等の“分析の断言”
- 高度な統計/機械学習  
→ 架空データのため、#3は「分析できる状態」に留める方針の一貫

---

## 2. どのような処理を設計したか（業務フロー）

### 全体フロー（#1）
1. **rawテーブル作成**（CSV取り込み。rawは加工しない）
2. **raw品質チェック**（取り込み事故検知：欠損・異常値・想定外・未来日・重複）
3. **staging生成**（空文字→NULL、重複除去、is_valid_order付与）
4. **staging拡張**
   - `first_purchase_date`（顧客の初回購入日：valid注文前提）
   - `customer_type`（初回購入月ベース：new / existing）

---

## 3. 設計したルール（確定）

### 粒度（granularity）
- `orders` 粒度：**1行 = 注文明細（order_id × product_id）**

### KPI対象（原則）
- KPIは原則 `is_valid_order = 1` のみを対象にする

### is_valid_order（固定定義）
`is_valid_order = 1`（= KPI対象）となる条件：すべて満たす

- `order_id` が空でない
- `customer_id` が空でない
- `order_date` がNULLでない、かつ未来日でない
- `quantity > 0`
- `unit_price > 0`
- `amount > 0`
- `status = 'PAID'`

それ以外は `is_valid_order = 0`

### 新規/既存（固定定義）
- **初回購入月（valid注文前提）** と注文月が一致：`new`
- それ以外：`existing`
- invalid（is_valid_order=0）は判定しない（NULL）

---

## 4. どのようなSQLを使ったか（処理別）

### 4.1 raw品質チェック（事故検知）
- 欠損：`order_id / customer_id / order_date`
- 異常：`quantity <= 0`、`unit_price <= 0`、`amount <= 0`
- 想定外：`status` が許容リスト外
- 未来日：`order_date > CURRENT_DATE()`
- 重複：完全一致行の重複（TO_JSON_STRINGで比較）

### 4.2 staging生成
- 空文字を `NULL` に寄せる（扱いの統一）
- 完全重複行を `ROW_NUMBER()` で1行にする（stagingを安定化）
- `CASE` で `is_valid_order` を付与（定義固定）

### 4.3 first_purchase_date 付与
- valid注文のみで `MIN(order_date)` を顧客ごとに算出
- stagingへ `LEFT JOIN` して列として持たせる

### 4.4 customer_type 付与
- `DATE_TRUNC(..., MONTH)` で注文月・初回購入月を作成
- 月が一致なら `new`、それ以外は `existing`

---

## 5. SQLの結果どうなったか（実行結果）

### 5.1 raw品質チェック（集計結果）
- 総行数：`row_count = 213`
- 注文件数：`distinct_order_id = 120`
- 購入者数：`distinct_customer_id = 50`

検知された異常（件数）：
- `missing_customer_id = 1`
- `missing_order_date = 1`
- `bad_quantity = 1`
- `bad_amount = 1`
- `unexpected_status = 1`
- `future_order_date = 1`

### 5.2 raw重複チェック
- `total_rows = 213`
- `distinct_rows = 212`
- `duplicate_rows = 1`

### 5.3 staging（is_valid_order）
- staging総行数：`212`（rawの重複1行を除去）
- `is_valid_order = 1`：`169`
- `is_valid_order = 0`：`43`

### 5.4 first_purchase_date のNULL
- `row_count = 212`
- `null_first_purchase_date = 7`
  - invalid行や `customer_id` 欠損行は、初回購入日が紐づかないためNULLになる（想定どおり）

### 5.5 customer_type（validのみ）
- `new = 93`（明細行数ベース）
- `existing = 76`（明細行数ベース）

> 注意：上記の new/existing は **顧客数ではなく明細行数**。  
> 顧客数で見たい場合は `COUNT(DISTINCT customer_id)` を使用する。

---

## 6. この部の成果物（ファイル対応）

- `sql/01_raw/01_raw_quality_check.sql`
- `sql/01_raw/02_raw_duplicate_check.sql`
- `sql/02_staging/01_create_orders_stg.sql`
- `sql/02_staging/02_add_first_purchase_date.sql`
- `sql/02_staging/03_add_customer_type.sql`
