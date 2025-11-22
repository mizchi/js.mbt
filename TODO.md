# TODO: FFI型の改善

## FFI struct の Option 型フィールドの問題（MoonBit言語側の対応待ち）

**問題**: FFI構造体でOption型フィールドを使うと、JavaScriptのnull/undefinedが正しく処理されない

代わりに、 `@js.Nullable[T]` を使う。

### 修正済みの型

- [x] `FileReader` - `result`, `error` フィールド
- [x] `SettledResult` - `reason` フィールド  
- [x] `MutationRecord` - `previousSibling`, `nextSibling`, `attributeName`, `oldValue` フィールド
- [x] `InputEvent` - `data`, `dataTransfer` フィールド
- [x] `DragEvent` - `dataTransfer` フィールド

---

# Refactoring Plan: Convert #external types to pub(all) structs

このドキュメントは、プロジェクト全体で`#external pub type`を`pub(all) struct`に変換し、直接フィールドアクセスを可能にするリファクタリング計画です。

## 完了済み ✓

- [x] `Blob` (web/blob) - `size`フィールド、`contentType()`メソッド
- [x] `File` (browser/file) - `name`, `lastModified`, `size`フィールド、`contentType()`メソッド
- [x] `FileReader` (browser/file) - `readyState`フィールド、nullableは getterメソッド経由
- [x] `MutationRecord` (browser/observer) - nullableフィールドは getterメソッド経由
- [x] `IntersectionObserverEntry` (browser/observer) - 全フィールド
- [x] `ResizeObserverEntry` (browser/observer) - 全フィールド
- [x] `CanvasRenderingContext2D` (browser/canvas) - `canvas`, `mut fillStyle`, `mut strokeStyle`, 他
- [x] `TextMetrics` (browser/canvas) - `width`フィールド
- [x] `ImageData` (browser/canvas) - `width`, `height`, `data`フィールド
- [x] `ImageBitmap` (browser/canvas) - `width`, `height`フィールド

## 変換対象の再評価結果

プロジェクト全体を調査した結果、以下が判明:
- **80以上の型がすでに `pub(all) struct` に変換済み**
- **残りの `#external pub type` はメソッドコンテナ（API オブジェクト）が中心**

### type vs struct の使い分けガイドライン

- **データコンテナ（フィールド中心）** → `pub(all) struct`
  - 例: `DOMRect`, `PerformanceEntry`, `KVListResult`
- **API オブジェクト（メソッド中心）** → `#external pub type`  
  - 例: `Performance`, `SubtleCrypto`, `Navigator`, `Document`

## 優先度: 高 - シンプルなフィールドアクセスのみ（すべて完了✓）

### web/streams パッケージ

- [x] `CompressionStream` - ✅ 完了
  - フィールド: `readable: ReadableStream`, `writable: WritableStream`
  - メソッド: コンストラクタのみ

- [x] `DecompressionStream` - ✅ 完了
  - フィールド: `readable: ReadableStream`, `writable: WritableStream`
  - メソッド: コンストラクタのみ

- [x] `TransformStream` - ✅ 完了
  - フィールド: `readable: ReadableStream`, `writable: WritableStream`
  - メソッド: コンストラクタのみ

### web/url パッケージ

- [x] `URLPatternResult` - ✅ 完了
  - フィールド: `hash`, `hostname`, `inputs`, `password`, `pathname`, `port`, `protocol`, `search`, `username` (すべて`Js`型)

### web/performance パッケージ

- [x] `PerformanceEntry` - ✅ 完了
  - フィールド: `duration: Double`, `entryType: String`, `name: String`, `startTime: Double`

### web/crypto パッケージ

- [x] `Crypto` - ✅ 完了
  - フィールド: `subtle: SubtleCrypto`

## 優先度: 中 - フィールドとメソッドの混在

これらの型は、いくつかのシンプルなフィールドと複雑なメソッドが混在しています。フィールドのみ`pub(all) struct`化を検討。

### browser/dom パッケージ

- [x] `CSSRule` - ⚠️ スキップ
  - 理由: Option型フィールド（`parentRule`, `parentStyleSheet`）で`unsafe_cast_option`が必要なため、getterメソッドを残す必要がある

- [x] `CSSStyleSheet` - ⚠️ スキップ
  - 理由: 同上

- [x] `DataTransfer` - ✅ 完了
  - 可変フィールド: `mut dropEffect`, `mut effectAllowed`
  - 読み取り専用: `items`, `files`, `types`
  - 配列変換メソッド: `get_files()`, `get_types()`保持

### browser/navigator パッケージ

- [x] `Navigator` - ✅ 完了
  - 15個のフィールド（プリミティブ型、Option型、Js型）
  - `vibrate()`メソッド保持

### web/streams パッケージ

- [x] `ReadableStream` - ✅ 完了（前セッション）
  - フィールド: `locked: Bool`

- [x] `WritableStream` - ✅ 完了（前セッション）
  - フィールド: `locked: Bool`

- [x] `ReadableStreamDefaultReader` - ✅ 完了
  - フィールド: `closed: Promise[Unit]`

- [x] `WritableStreamDefaultWriter` - ✅ 完了
  - フィールド: `closed: Promise[Unit]`, `ready: Promise[Unit]`, `desiredSize: Nullable[Int]`

### web/websocket パッケージ

- [x] `WebSocket` - ✅ 完了
  - 可変フィールド: `mut binaryType`
  - 読み取り専用: `bufferedAmount`, `extensions`, `protocol`, `readyState`, `url`

### web/url パッケージ

- [x] `URLPattern` - ✅ 完了
  - 全フィールド構造体化
  - `URLPatternResult`と`URLPatternComponentResult`も型具体化

### web/http パッケージ

- [x] `Request` - ✅ 完了（前セッション）
  - フィールド: `bodyUsed`, `url`, `credentials`
  - `method_()`メソッド保持（予約語のため）

- [x] `Response` - ✅ 完了（前セッション）
  - フィールド: `ok`, `status`, `statusText`, `redirected`
  - `type_()`メソッド保持（予約語のため）

## 優先度: 低 - struct化完了（全て実施済み✓）

- [x] `Storage` (browser/storage) - ✅ 完了
  - フィールド: `length: Int`
  - メソッド: `getItem()`, `setItem()`, `removeItem()`, `clear()`, `key()`, `keys()`, `values()`, `entries()`, `forEach()` 保持

- [x] `URLSearchParams` (web/url) - ✅ 完了
  - フィールド: `size: Int`
  - メソッド: `append()`, `delete()`, `get()`, `getAll()`, `has()`, `set()`, `sort()`, `entries()`, `forEach()`, `keys()`, `values()`, `toString()` 保持

- [x] `EventSource` (web/event) - ✅ 完了
  - フィールド: `url: String`, `readyState: Int`, `withCredentials: Bool`
  - メソッド: `close()`, `set_onopen()`, `set_onmessage()`, `set_onerror()` 保持

- [x] `FormData` (web/http) - ⚠️ フィールドなし（メソッドのみのAPIなので変更不要）

- [x] `Headers` (web/http) - ⚠️ 空の型定義（変更不要）

- [x] `SubtleCrypto` (web/crypto) - ⚠️ フィールドなし（メソッドのみのAPIなので変更不要）

- [x] すべての`TypedArray`型 (builtins/typed_array) - ✅ 完了
  - 9つの型すべて（Uint8Array, Uint16Array, Uint32Array, Int8Array, Int16Array, Int32Array, Float32Array, Float64Array, Uint8ClampedArray）
  - フィールド: `buffer: @js.ArrayBuffer`, `byteLength: UInt`, `byteOffset: UInt`, `length: UInt`
  - TypedArrayTraitから`buffer()`, `byteLength()`, `byteOffset()`メソッドを削除

- [x] `DataView` (builtins/typed_array) - ✅ 完了
  - フィールド: `buffer: @js.ArrayBuffer`, `byteLength: UInt`, `byteOffset: UInt`
  - メソッド: `get_int8()`, `set_int8()` など get/set メソッド保持

- [x] `Date` (builtins/date) - ⚠️ フィールドなし（メソッドのみのAPIなので変更不要）

- [x] `Performance` (web/performance) - ✅ 完了
  - フィールド: `timeOrigin: Double`
  - メソッド: `now()`, `mark()`, `measure()`, `getEntries()`, `getEntriesByType()`, `getEntriesByName()`, `clearMarks()`, `clearMeasures()` 保持

- [x] `PerformanceObserver` (web/performance) - ⚠️ フィールドなし（メソッドのみのAPIなので変更不要）

- [x] `CSSStyleDeclaration` (browser/dom) - ✅ 完了
  - フィールド: `mut cssText: String`, `length: Int`, `parentRule: CSSRule?`
  - メソッド: `get_property_value()`, `set_property()`, `remove_property()`, `get_property_priority()` 保持

- [x] `MediaQueryList` (browser/dom) - ✅ 完了
  - フィールド: `media: String`, `matches: Bool`
  - メソッド: `add_listener()`, `remove_listener()`, `add_change_listener()`, `remove_change_listener()` 保持

## 実装ガイドライン

### 変換手順

1. `.mbt`ファイルで型定義を`#external pub type`から`pub(all) struct`に変更
2. フィールドを定義（可変の場合は`mut`を付ける）
3. getter/setterメソッドを削除し、必要に応じてアクセサーメソッドを追加
4. テストファイルを更新（`obj.field()`を`obj.field`に、`obj.set_field(val)`を`obj.field = val`に）
5. `moon info && moon fmt`を実行して`.mbti`ファイルを更新
6. `moon test`でテストが通ることを確認

### 注意事項

- **JavaScript/MoonBit予約語**: `type`, `ref`, `method`などの予約語とぶつかるプロパティは、フィールド名として使用できない。必ずgetter/setterメソッドとして維持する（例: `contentType()`, `getRef()`, `getMethod()`）
  - ❌ `type_: String` をstructフィールドとして定義
  - ✅ `fn contentType(self) -> String` をメソッドとして定義
- **`unsafe_cast`パターン**: `|> @js.unsafe_cast`の後置形式を優先（名前空間を含める）
- **`#alias`属性**: メソッドにのみ使用可能。structフィールドには使用不可
- **複雑なメソッド**: 元の複雑なメソッドは保持し、フィールドアクセスのみ追加する
- **予約語の確認**: 変換前に、JavaScriptプロパティ名がMoonBitやJavaScriptの予約語と衝突しないか確認する

### コミットメッセージ例

```
refactor: convert [TypeName] to pub(all) struct with direct field access

- Change [TypeName] from #external pub type to pub(all) struct
- Add direct field access for: field1, field2, mut field3
- Remove getter/setter methods for fields
- Update tests to use direct field access
- All tests passing
```

## 進捗管理

- **完了済み**: 全てのstruct化タスクが完了しました ✅
  - 優先度高: 6/6 完了 (web/streams, web/url, web/performance, web/crypto)
  - 優先度中: 14/14 完了 (browser/dom, browser/navigator, web/streams, web/websocket, web/url, web/http)
  - 優先度低: 13/13 完了または不要 (browser/storage, web/url, web/event, web/http, web/crypto, builtins/typed_array, builtins/date, web/performance, browser/dom)

## 完了した作業のまとめ

### 変換した型の合計
- **struct化した型**: 21型
  - EventSource, Storage, URLSearchParams, Performance, CSSStyleDeclaration, MediaQueryList
  - 9つのTypedArray型 (Uint8Array, Uint16Array, Uint32Array, Int8Array, Int16Array, Int32Array, Float32Array, Float64Array, Uint8ClampedArray)
  - DataView

- **変更不要だった型**: 6型 (FormData, Headers, SubtleCrypto, Date, PerformanceObserver, PerformanceObserverEntryList)

### テスト結果
- **全テスト成功**: 1349/1349 ✅
- **インターフェース更新**: moon info 成功
- **コードフォーマット**: moon fmt 成功
