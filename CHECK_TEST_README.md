# Test Stability Checker

`check_test.ts` は MoonBit のテストを複数回実行して、安定性を確認し、フレーキーなテストを特定するためのツールです。

## 使い方

```bash
# 基本的な使い方（2回実行）
./check_test.ts

# 5回実行
./check_test.ts 5

# 3回実行、各実行のタイムアウトを180秒に設定
./check_test.ts 3 180000
```

## 引数

- `runs` - テスト実行回数（デフォルト: 2）
- `timeout` - 各実行のタイムアウト（ミリ秒、デフォルト: 120000）

## 機能

### 1. テスト結果のキャプチャ

`moon test --verbose` の出力を解析して、各テストの結果を記録します：

```
[mizchi/js] test npm/react_testing_library/rtl_test.mbt:465 ("renderHook: useReducer") ok
```

このような出力から、ファイル、行番号、テスト名、結果を抽出します。

### 2. 連続実行の比較

複数回実行したときに、前回と比較して：
- **New failures**: 前回は成功したが今回は失敗したテスト（フレーキーの可能性）
- **New successes**: 前回は失敗したが今回は成功したテスト（フレーキーの可能性）
- **Consistent failures**: 前回も今回も失敗したテスト（再現性のある問題）

### 3. ベースラインとの比較

`.test_baseline.json` にベースラインを保存し、それと比較します。

```bash
# 最初の実行でベースラインを作成
./check_test.ts 1

# 後の実行でベースラインと比較
./check_test.ts 3
```

### 4. 統計情報

- 成功率
- 平均成功率
- タイムアウト回数

## 出力例

```
Running moon test 2 times with 120000ms timeout...
================================================================================

================================================================================
Run 1/2
================================================================================
[mizchi/js] test core_test.mbt:5 ("globalThis") ok
[mizchi/js] test core_test.mbt:13 ("global isNaN") ok
...

================================================================================
Run 1 Summary:
  Total: 1462, Passed: 1462, Failed: 0
  Duration: 45.23s
  Timed out: false
================================================================================

================================================================================
Run 2/2
================================================================================
...

================================================================================
Analysis:
================================================================================

Comparing consecutive runs:

Run 1 vs Run 2:
  New failures (1):
    - src/js_async_test.mbt:30 "JS Async: multiple setTimeouts"
  No consistent failures

Comparison with baseline:
  Fixed tests (2):
    - src/globals_test.mbt:115 "setTimeout and clearTimeout"
    - src/browser/dom/dom_test.mbt:335 "EventTarget - addEventListener"

================================================================================
Statistics:
================================================================================
Success rate: 100.0%, 99.9%
Average success rate: 99.95%
Timeouts: 0/2
```

## ユースケース

### フレーキーなテストの特定

```bash
# 10回実行してフレーキーなテストを見つける
./check_test.ts 10
```

成功率が 100% でない場合、どのテストがフレーキーかを特定できます。

### CI での安定性確認

```bash
# タイムアウトを短くして複数回実行
./check_test.ts 3 60000
```

終了コードが 0 なら全て成功、1 なら失敗またはタイムアウトがあったことを示します。

### リグレッションの検出

ベースラインを作成しておき、変更後に比較することで、新しく失敗したテストを検出できます。

```bash
# main ブランチでベースラインを作成
git checkout main
./check_test.ts 1

# feature ブランチで比較
git checkout feature-branch
./check_test.ts 3
```

## ファイル

- `check_test.ts` - テストチェッカースクリプト
- `.test_baseline.json` - ベースラインファイル（gitignore に追加済み）

## 必要な環境

- Node.js v22.6.0 以降（`--experimental-strip-types` サポート）
- TypeScript 型定義（内蔵の型チェック）

## トラブルシューティング

### タイムアウトが頻繁に発生する

タイムアウト時間を増やしてください：

```bash
./check_test.ts 5 180000  # 180秒に設定
```

### ベースラインをリセットしたい

```bash
rm .test_baseline.json
./check_test.ts 1
```
