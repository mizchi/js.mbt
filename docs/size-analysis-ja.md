# バンドルサイズ分析

MoonBit の JavaScript 出力におけるバンドルサイズの分析結果。サイズ増加の主要因と最適化の可能性を特定する。

**注意:** 分析対象は terser DCE (Dead Code Elimination) + compress 適用後の出力。未使用コードは既に除去済み。

## 分析対象

**Example: aisdk** (AI SDK ストリーミング例)
- ソース: 24行の MoonBit (`src/examples/aisdk/main.mbt`)
- 出力: 115,183 bytes (raw JS)

### 入力ソースコード

**main.mbt:**

```moonbit
async fn main {
  // Load environment variables
  @dotenv.config() |> ignore
  println("[ai] Starting stream...")
  // Start streaming
  let stream = @ai.stream_text(
    model=@ai.anthropic("claude-sonnet-4-20250514"),
    prompt="Count from 1 to 10, one number per line",
  )
  // Iterate over text chunks
  let text_iter = stream.text_stream()
  let stdout = @process.stdout()
  while true {
    match text_iter.next() {
      Some(chunk) => stdout.write(chunk) |> ignore
      None => break
    }
  }
  println("\n\n[ai] Stream complete!")
  // Get final usage stats
  let usage = stream.usage()
  println("Tokens used: \{usage.total_tokens.to_string()}")
}
```

**moon.pkg.json:**

```json
{
  "is-main": true,
  "import": [
    "mizchi/js",
    "mizchi/js/node/process",
    "mizchi/js/node/tty",
    "mizchi/js/npm/ai",
    "mizchi/js/npm/dotenv",
    "moonbitlang/async"
  ]
}
```

## サイズ内訳

| カテゴリ | サイズ | 割合 |
|----------|--------|------|
| mizchi$js バインディング (vtable除く) | 48,849 bytes | 42.4% |
| vtable インライン展開 | 33,203 bytes | 28.8% |
| MoonBit ランタイム (core+async) | 19,875 bytes | 17.3% |
| その他 (ヘルパー/型) | 9,545 bytes | 8.3% |
| main.mbt (ユーザーコード) | 2,680 bytes | 2.3% |
| 未分類 | 1,031 bytes | 0.9% |

### MoonBit ランタイム詳細

| コンポーネント | サイズ | 備考 |
|----------------|--------|------|
| moonbitlang$core | 15,010 bytes | Map, Deque, Hasher 等 |
| moonbitlang$async | 4,865 bytes | コルーチンスケジューラ |

### mizchi$js バインディング詳細

| コンポーネント | サイズ | 備考 |
|----------------|--------|------|
| mizchi$js$npm (ai, dotenv) | 45,195 bytes | NPM パッケージバインディング |
| mizchi$js (コア) | 34,534 bytes | コア JS インターフェース |
| mizchi$js$node (process) | 2,323 bytes | Node.js バインディング |

### vtable 内訳

| 種類 | 回数 | インスタンスあたり | 合計 |
|------|------|-------------------|------|
| JsImpl vtable (13メソッド) | 48 | ~558 bytes | 26,799 bytes |
| PropertyKey vtable | 100 | ~64 bytes | 6,404 bytes |

## 主な発見

### 1. バインディング + vtable で 71.2%

JavaScript 連携レイヤーがバンドルサイズを支配:
- バインディングロジック: 48,849 bytes (42.4%)
- vtable インライン展開: 33,203 bytes (28.8%)

### 2. MoonBit ランタイムは比較的小さい (17.3%)

コアランタイムに含まれるもの:
- async 用データ構造 (Map, Deque)
- ハッシュ関数
- コルーチンスケジューラ

### 3. ユーザーコードはわずか 2.3%

24行の MoonBit が 2,680 bytes にコンパイルされるが、残り 97.7% はランタイムとバインディング。

## ソースコード構造

### JsImpl トレイトとデフォルト実装

バインディング層では、デフォルトメソッド実装を持つトレイトを使用している (`src/impl.mbt`):

```moonbit
pub(open) trait JsImpl {
  to_any(Self) -> Any = _
  get(Self, &PropertyKey) -> Any = _
  set(Self, &PropertyKey, &JsImpl) -> Unit = _
  call(Self, &PropertyKey, Array[&JsImpl]) -> Any = _
  call0(Self, &PropertyKey) -> Any = _
  call1(Self, &PropertyKey, &JsImpl) -> Any = _
  call2(Self, &PropertyKey, &JsImpl, &JsImpl) -> Any = _
  call_throwable(Self, &PropertyKey, Array[&JsImpl]) -> Any raise ThrowError = _
  call_self(Self, Array[&JsImpl]) -> Any = _
  call_self0(Self) -> Any = _
  call_self_throwable(Self, Array[&JsImpl]) -> Any raise ThrowError = _
  delete(Self, &PropertyKey) -> Unit = _
  hasOwnProperty(Self, &PropertyKey) -> Bool = _
}

impl JsImpl with get(self, key : &PropertyKey) -> Any {
  ffi_get(self.to_any(), key.to_key() |> identity)
}

impl JsImpl with set(self, key : &PropertyKey, val : &JsImpl) -> Unit {
  ffi_set(self.to_any(), key.to_key() |> identity, val.to_any())
}
```

### FFI 定義

FFI 層 (`src/ffi.mbt`) はシンプルな JavaScript 操作を提供:

```moonbit
extern "js" fn ffi_get(obj : Any, key : String) -> Any =
  #| (obj, key) => obj[key]

extern "js" fn ffi_set(obj : Any, key : String, value : Any) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

extern "js" fn ffi_call0(obj : Any, key : String) -> Any =
  #| (obj, key) => obj[key]()

extern "js" fn ffi_call1(obj : Any, key : String, arg1 : Any) -> Any =
  #| (obj, key, arg1) => obj[key](arg1)
```

## 主要な問題点

### 問題1: vtable インライン展開 (最大の問題)

トレイトオブジェクト (`&JsImpl`) を使用すると、コンパイラは呼び出し箇所ごとに vtable を生成する。
すべての JS 値操作で vtable オブジェクトがインラインで生成される:

**生成コードの例:**

```javascript
// 単純な promise.then().catch() で約400バイト生成される:
mizchi$js$$JsImpl$call1$9$(
  mizchi$js$$JsImpl$call1$15$(self,
    { self: "then", method_0: mizchi$js$$PropertyKey$to_key$3$ },
    { self: _cont, method_0: ..., method_1: ..., ..., method_12: ... }
  ),
  { self: "catch", method_0: mizchi$js$$PropertyKey$to_key$3$ },
  { self: _err_cont, method_0: ..., method_1: ..., ..., method_12: ... }
);
```

各 JS 値操作でインラインに vtable オブジェクトが生成される:

```javascript
// 現状: インスタンスあたり 558 bytes
{
  self: value,
  method_0: mizchi$js$$JsImpl$to_any$9$,
  method_1: mizchi$js$$JsImpl$get$9$,
  method_2: mizchi$js$$JsImpl$set$9$,
  // ... さらに10メソッド
  method_12: mizchi$js$$JsImpl$hasOwnProperty$9$
}
```

この 13 メソッドの vtable が 48 回インライン展開されている。

### 問題2: PropertyKey のラップ

単純な文字列キーがオブジェクトでラップされる:

```javascript
// 現状: 64 bytes
{ self: "model", method_0: mizchi$js$$PropertyKey$to_key$3$ }

// 本来可能: 7 bytes
"model"
```

## 最適化の可能性

### 1. vtable 共有 (ポテンシャル: -26.7%)

インライン展開の代わりに vtable オブジェクトを共有:

```javascript
// 一度だけ定義
const JsImpl$vtable$9 = {
  method_0: mizchi$js$$JsImpl$to_any$9$,
  method_1: mizchi$js$$JsImpl$get$9$,
  // ...
};

// 参照を使用
{ self: value, ...JsImpl$vtable$9 }
// または
{ self: value, $v: JsImpl$vtable$9 }
```

**推定削減量: ~30,763 bytes (26.7%)**

### 2. シンプルな操作には直接 FFI

単純なプロパティアクセス/呼び出しには直接コードを生成:

```javascript
// 現状
mizchi$js$$JsImpl$get$9$(obj, { self: "key", method_0: ... })

// 最適化後
obj["key"]
```

### 3. PropertyKey ラッパーの除去

ラップせずに文字列を直接渡す:

```javascript
// 現状
{ self: "key", method_0: mizchi$js$$PropertyKey$to_key$3$ }

// 最適化後
"key"
```

## 最適化の優先順位

1. **vtable 共有** - 最大のインパクト、バンドルの 28.8%
2. **PropertyKey 簡略化** - バンドルの 5.6%
3. **直接 FFI 生成** - バインディングコードの複雑さを軽減
4. **ランタイム tree-shaking** - 未使用の Map/Set 操作を除去

## 分析の実行方法

```bash
# examples をビルド
moon build --target js

# 出力ファイル付きでサイズレポートを生成
./scripts/check_sizes.ts --output-files

# 分析スクリプトを実行
node tmp/analyze_size.js
```

## 関連ファイル

- `scripts/check_sizes.ts` - バンドルサイズ計測ツール
- `tmp/check-sizes/*/` - 検査用出力ファイル
- `.bundle_size_baseline.json` - 比較用サイズベースライン
- `tmp/analyze_size.js` - 詳細分析スクリプト
