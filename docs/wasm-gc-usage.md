# WASM-GC Usage Guide

MoonBit WASM-GC ターゲットで `@core` パッケージを使用するガイド。

## 前提条件

- MoonBit v0.1.x 以降
- Deno v2.x / Node v22+ / Chromium 130+ (js-string-builtins サポート必須)

## セットアップ

### 1. 依存関係の追加

```bash
moon add mizchi/js
```

### 2. moon.pkg.json の設定

```json
{
  "import": ["mizchi/js/core"],
  "link": {
    "wasm-gc": {
      "use-js-builtin-string": true,
      "exports": ["your_function"]
    }
  }
}
```

### 3. inject.ts のインポート

`.mooncakes` ディレクトリから直接 inject.ts を使用できます：

```typescript
import { createJsCoreImports, loadWasmWithCore } from "./.mooncakes/mizchi/js/core/inject.ts";
```

または、独自のローダーで使用：

```typescript
import { createJsCoreImports } from "./.mooncakes/mizchi/js/core/inject.ts";

async function loadMyWasm(wasmPath: string) {
  const wasmBytes = await Deno.readFile(wasmPath);

  const { instance } = await (WebAssembly.instantiate as any)(
    wasmBytes,
    { jscore: createJsCoreImports() },
    {
      builtins: ["js-string"],
      importedStringConstants: "_"
    }
  );

  return instance.exports;
}
```

## MoonBit コード例

### 基本的な使用法

```moonbit
///|
pub fn example() -> String {
  // オブジェクト作成
  let obj = @core.new_object()
  obj["name"] = @core.any("MoonBit")
  obj["version"] = @core.any("1.0")

  // プロパティアクセス
  let name = obj["name"]

  // メソッド呼び出し
  let arr = @core.new_array()
  arr._call("push", [@core.any("a"), @core.any("b")]) |> ignore

  @core.json_stringify(obj)
}
```

### ToAny トレイトを使用したプリミティブ変換

WASM-GC では `%identity` が使えないため、`ToAny` トレイトを使用：

```moonbit
///|
pub fn primitives_example() -> String {
  let obj = @core.new_object()

  // ToAny::to_any() で型安全に変換
  obj["int_val"] = @core.ToAny::to_any(42)
  obj["double_val"] = @core.ToAny::to_any(3.14)
  obj["bool_val"] = @core.ToAny::to_any(true)
  obj["string_val"] = @core.ToAny::to_any("hello")

  // 配列
  let arr : Array[@core.Any] = [
    @core.ToAny::to_any(1),
    @core.ToAny::to_any(2),
    @core.ToAny::to_any(3),
  ]
  obj["array"] = @core.ToAny::to_any(arr)

  // Bytes -> Uint8Array
  let bytes : Bytes = b"\x01\x02\x03"
  obj["bytes"] = @core.ToAny::to_any(bytes)

  // BigInt (Int64経由)
  let big : Int64 = 9223372036854775807L
  obj["bigint"] = @core.int64_to_bigint(big)._call("toString", [])

  @core.json_stringify(obj)
}
```

### 型チェックと条件分岐

```moonbit
///|
pub fn type_checks() -> String {
  let results = @core.new_object()

  let obj = @core.new_object()
  let arr = @core.new_array()
  let null_val = @core.null()
  let undef_val = @core.undefined()

  results["is_object"] = @core.any(
    if @core.is_object(obj) { "true" } else { "false" }
  )
  results["is_array"] = @core.any(
    if @core.is_array(arr) { "true" } else { "false" }
  )
  results["is_nullish"] = @core.any(
    if @core.is_nullish(null_val) { "true" } else { "false" }
  )

  @core.json_stringify(results)
}
```

### globalThis へのアクセス

```moonbit
///|
pub fn global_access() -> @core.Any {
  let global = @core.global_this()

  // Math.max(5, 10)
  let math = global["Math"]
  let max_fn = math["max"]
  let result = max_fn._invoke([@core.any("5"), @core.any("10")])

  result
}
```

### new コンストラクタ

```moonbit
///|
pub fn constructor_example() -> String {
  let global = @core.global_this()

  // new Map()
  let map_class = global["Map"]
  let map = @core.new(map_class, [])
  map._call("set", [@core.any("key"), @core.any("value")]) |> ignore

  // new Date()
  let date_class = global["Date"]
  let date = @core.new(date_class, [])

  date._call("toISOString", []) |> @core.Any::to_string
}
```

## API リファレンス

### 値の作成

| 関数 | 説明 |
|------|------|
| `new_object()` | 空のオブジェクト `{}` を作成 |
| `new_array()` | 空の配列 `[]` を作成 |
| `null()` | `null` を返す |
| `undefined()` | `undefined` を返す |
| `global_this()` | `globalThis` を返す |
| `any(String)` | 文字列を Any に変換 |

### プロパティ操作

| 関数 | 説明 |
|------|------|
| `obj[key]` | プロパティ取得 |
| `obj[key] = value` | プロパティ設定 |
| `obj._get_by_index(n)` | インデックスアクセス |
| `obj._call(method, args)` | メソッド呼び出し |
| `fn._invoke(args)` | 関数呼び出し |
| `new(cls, args)` | コンストラクタ呼び出し |

### 型チェック

| 関数 | 説明 |
|------|------|
| `is_null(v)` | `v === null` |
| `is_undefined(v)` | `v === undefined` |
| `is_nullish(v)` | `v == null` |
| `is_object(v)` | `typeof v === "object" && v !== null` |
| `is_array(v)` | `Array.isArray(v)` |
| `equal(a, b)` | `a === b` |

### オブジェクト操作

| 関数 | 説明 |
|------|------|
| `object_keys(obj)` | `Object.keys(obj)` |
| `object_values(obj)` | `Object.values(obj)` |
| `object_assign(target, source)` | `Object.assign(target, source)` |
| `object_has_own(obj, key)` | `Object.hasOwn(obj, key)` |

### JSON

| 関数 | 説明 |
|------|------|
| `json_stringify(v)` | `JSON.stringify(v)` |
| `json_stringify_pretty(v, space)` | `JSON.stringify(v, null, space)` |
| `json_parse(text)` | `JSON.parse(text)` |

### 型変換 (ToAny)

| 型 | 変換方法 |
|-----|----------|
| `Int`, `UInt`, `Float`, `Double` | `ToAny::to_any(value)` |
| `Bool` | `ToAny::to_any(value)` |
| `String` | `ToAny::to_any(value)` または `any(value)` |
| `Array[Any]` | `ToAny::to_any(arr)` |
| `Bytes` | `ToAny::to_any(bytes)` → `Uint8Array` |
| `Int64` → `BigInt` | `int64_to_bigint(value)` |
| `BigInt` | `ToAny::to_any(value)` (Int64に変換) |

## 制限事項

### WASM FFI の制約

1. **可変長引数**: `_call`/`_invoke`/`new` は最大4引数まで
2. **ジェネリック型**: `Array[T]` は直接渡せない → `Array[Any]` + `array_to_js()` を使用
3. **BigInt**: Int64 範囲内のみ対応（オーバーフローに注意）

### クロージャの制約（重要）

**MoonBit のクロージャは JavaScript に渡せません**。

```moonbit
// これは動作しない！
add_event_listener(button, "click", fn() {
  console_log("clicked")  // Error: externref type mismatch
})
```

エラー:
```
array.new_fixed expected type externref, found local.get of type (ref X)
```

**回避策**: イベントハンドラは JavaScript 側で設定する

```typescript
// JavaScript から WASM 関数を呼び出す形でイベント処理
button.addEventListener('click', () => {
  wasmExports.handle_click();  // クロージャを使わない WASM 関数
});
```

### 型変換の注意点

- `Any::cast()` は WASM-GC で型エラーになることがある
- プリミティブ → Any は必ず `ToAny::to_any()` または `wasm_from_*` を使用
- `%identity` は JS ターゲットのみで動作

## トラブルシューティング

### "Invalid stub type" エラー

原因: WASM FFI で対応していない型を使用
対策: `ToAny::to_any()` または専用の変換関数を使用

### "(ref extern) vs externref" 型エラー

原因: MoonBit の型システムと WASM-GC の型の不一致
対策: 変換関数を経由せず、`%identity` を使わない

### JSON.stringify で BigInt エラー

原因: BigInt は直接 JSON.stringify できない
対策: `.toString()` で文字列に変換してから使用

```moonbit
let big = @core.int64_to_bigint(123456789L)
let str = big._call("toString", [])  // "123456789"
obj["bigint"] = str  // JSON.stringify 可能
```

## 参考

- [MoonBit js-string-builtins](https://www.moonbitlang.com/blog/js-string-builtins)
- [docs/wasm-bridges.md](./wasm-bridges.md) - 詳細な実装解説
