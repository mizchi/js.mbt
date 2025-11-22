# FFI Option型フィールドの挙動調査結果

## 調査概要

`pub(all) struct` の `T?` 型フィールドがJavaScriptの `null`/`undefined` をどう扱うか調査した。

## 重要な発見

### ❌ 問題のあるパターン: `Js?` 型フィールド

**`Js?` 型のstructフィールドは、JavaScriptの `null`/`undefined` を正しく扱えない。**

```moonbit
pub(all) struct FileReader {
  result : Js?  // ❌ 問題あり
  error : Js?   // ❌ 問題あり
}
```

**挙動:**
- JavaScriptの `null` → MoonBitで `match` しようとすると `$tag` プロパティアクセスでクラッシュ
- `Some(null)` でも `None` でもない、アクセス不可能な状態

**エラー例:**
```
TypeError: Cannot read properties of null (reading '$tag')
```

**影響を受ける型:**
- `FileReader` - `result: Js?`, `error: Js?`
- `SpawnSyncResult` - `error: Js` (既に修正済み)
- その他多数のCloudflare Workers API型

### ✅ 正しく動作するパターン: プリミティブ型の `T?`

**`Int?`, `String?`, `Bool?` などのプリミティブ型は正しく動作する。**

```moonbit
pub(all) struct SettledResult[T] {
  value : T?     // ✅ 正しく動作 (Tがプリミティブの場合)
  reason : Js?   // ❌ 問題あり
}
```

**挙動:**
- JavaScriptの `undefined` → MoonBitの `None` に正しく変換
- JavaScriptの値 → MoonBitの `Some(value)` に正しく変換

**テスト結果:**
```moonbit
test "@js.SettledResult rejected with undefined value" {
  let result : SettledResult[Int] = create_settled_result_rejected() |> unsafe_cast
  match result.value {
    Some(_) => inspect("has value")
    None => inspect("None", content="None")  // ✅ 正しく None になる
  }
}
```

### ⚠️ 不明: カスタム構造体の `Struct?`

`Element?`, `DataTransfer?` などのカスタム構造体のOption型は未テスト（ブラウザ環境が必要）。

## 修正方針

### 1. `Js?` フィールドの修正

**Before:**
```moonbit
pub(all) struct FileReader {
  result : Js?
  error : Js?
}
```

**Option A: 非Optionalにしてgetterで対応**
```moonbit
pub(all) struct FileReader {
  readyState : Int
  result : Js      // Optionalを削除
  error : Js       // Optionalを削除
}

// getter メソッドで Option に変換
pub fn FileReader::get_result(self : Self) -> Js? {
  unsafe_cast_option(self.to_js().get("result"))
}

pub fn FileReader::get_error(self : Self) -> Js? {
  unsafe_cast_option(self.to_js().get("error"))
}
```

**Option B: フィールドアクセス時に手動チェック**
```moonbit
pub(all) struct FileReader {
  readyState : Int
  result : Js
  error : Js
}

// ユーザーコード
let reader : FileReader = ...
let result_js : Js = reader.result
if is_nullish(result_js) {
  // null/undefined
} else {
  // 値あり
}
```

### 2. プリミティブ型の `T?` はそのまま維持

`Int?`, `String?`, `Bool?` などは正しく動作するので変更不要。

```moonbit
pub(all) struct SettledResult[T] {
  status : String
  value : T?      // ✅ OK (Tがプリミティブの場合)
  reason : Js     // ❌ Js? から Js に変更必要
}
```

## 影響範囲

### 確実に修正が必要
1. `FileReader` - `result: Js?`, `error: Js?`
2. `SpawnSyncResult` - `error: Js` (修正済み)
3. `SettledResult[T]` - `reason: Js?`
4. Cloudflare Workers API (~20個の型)
   - `KVValueWithMetadata` - `value: Js?`, `metadata: Js?`
   - `D1Result` - `results: Array[Js]?`, `meta: D1Meta?`, `error: String?`
   - その他多数

### 要確認
1. `MutationRecord` - `previousSibling: Element?`, `nextSibling: Element?` (ブラウザ環境でテスト必要)
2. `InputEvent` - `dataTransfer: DataTransfer?`
3. `DragEvent` - `dataTransfer: DataTransfer?`
4. その他のDOMイベント型

## 推奨パターン

### ✅ 推奨
```moonbit
// 1. プリミティブ型のOptionはそのまま使用
pub(all) struct Config {
  timeout : Int?
  retry : Bool?
}

// 2. Js型はOptionを避け、getterメソッドで対応
pub(all) struct Response {
  body : Js
}

pub fn Response::get_body(self : Self) -> Js? {
  unsafe_cast_option(self.to_js().get("body"))
}
```

### ❌ 避けるべき
```moonbit
// Js? 型のstructフィールド
pub(all) struct FileReader {
  result : Js?  // ❌ クラッシュの原因
}
```

## 参考

- `src/ffi_check_test.mbt` - 基本的なFFI挙動テスト
- `src/_ffi_spec/struct_option_audit_test.mbt` - 実際の型での挙動確認
- MoonBit公式FFIドキュメント: https://www.moonbitlang.com/pearls/moonbit-jsffi
