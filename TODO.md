# Refactoring Plan: Convert #external types to pub(all) structs

このドキュメントは、プロジェクト全体で`#external pub type`を`pub(all) struct`に変換し、直接フィールドアクセスを可能にするリファクタリング計画です。

## 完了済み ✓

- [x] `Blob` (web/blob) - `size`フィールド、`contentType()`メソッド
- [x] `File` (browser/file) - `name`, `lastModified`, `size`フィールド、`contentType()`メソッド
- [x] `FileReader` (browser/file) - `readyState`, `result`, `error`フィールド
- [x] `MutationRecord` (browser/observer) - 全フィールド、`mutation_type()`メソッド
- [x] `IntersectionObserverEntry` (browser/observer) - 全フィールド
- [x] `ResizeObserverEntry` (browser/observer) - 全フィールド
- [x] `CanvasRenderingContext2D` (browser/canvas) - `canvas`, `mut fillStyle`, `mut strokeStyle`, 他
- [x] `TextMetrics` (browser/canvas) - `width`フィールド
- [x] `ImageData` (browser/canvas) - `width`, `height`, `data`フィールド
- [x] `ImageBitmap` (browser/canvas) - `width`, `height`フィールド

## 優先度: 高 - シンプルなフィールドアクセスのみ

これらの型は読み取り専用フィールドのみで、getter以外のメソッドがほとんどないため、変換が容易です。

### web/streams パッケージ

- [ ] `CompressionStream`
  - フィールド: `readable: ReadableStream`, `writable: WritableStream`
  - メソッド: コンストラクタのみ

- [ ] `DecompressionStream`
  - フィールド: `readable: ReadableStream`, `writable: WritableStream`
  - メソッド: コンストラクタのみ

- [ ] `TransformStream`
  - フィールド: `readable: ReadableStream`, `writable: WritableStream`
  - メソッド: コンストラクタのみ

### web/url パッケージ

- [ ] `URLPatternResult`
  - フィールド: `hash`, `hostname`, `inputs`, `password`, `pathname`, `port`, `protocol`, `search`, `username` (すべて`Js`型)
  - メソッド: getterのみ
  - 注意: すべて`@js.Js`型を返すため、型安全性は限定的

### web/performance パッケージ

- [ ] `PerformanceEntry`
  - フィールド: `duration: Double`, `entryType: String`, `name: String`, `startTime: Double`
  - メソッド: getterのみ

### web/crypto パッケージ

- [ ] `Crypto`
  - フィールド: `subtle: SubtleCrypto`
  - メソッド: getterのみ

## 優先度: 中 - フィールドとメソッドの混在

これらの型は、いくつかのシンプルなフィールドと複雑なメソッドが混在しています。フィールドのみ`pub(all) struct`化を検討。

### browser/dom パッケージ

- [ ] `CSSRule`
  - 読み取り専用: `parent_rule`, `parent_stylesheet`, `rule_type`
  - 可変: `mut css_text`
  - 注意: 複雑なメソッドもあるため、慎重に判断

- [ ] `CSSStyleSheet`
  - 読み取り専用: `css_rules`, `href`, `media`, `owner_node`, `title`
  - 可変: `mut disabled`
  - メソッド: `insertRule`, `deleteRule`

- [ ] `DataTransfer`
  - 読み取り専用: `files`, `items`, `types`
  - 可変: `mut dropEffect`, `mut effectAllowed`
  - メソッド: `clearData`, `getData`, `setData`等

### browser/navigator パッケージ

- [ ] `Navigator`
  - 読み取り専用: `clipboard`, `connection`, `cookieEnabled`, `deviceMemory`, `doNotTrack`, `geolocation`, `hardwareConcurrency`, `language`, `languages`, `maxTouchPoints`, `onLine`, `permissions`, `platform`, `userAgent`, `vendor`
  - メソッド: `vibrate()`
  - 注意: フィールド数が多い

### web/streams パッケージ

- [ ] `ReadableStream`
  - 読み取り専用: `locked: Bool`
  - メソッド: `cancel`, `getReader`, `pipeThrough`, `pipeTo`, `tee`等（複雑）
  - 注意: `locked`のみフィールド化

- [ ] `WritableStream`
  - 読み取り専用: `locked: Bool`
  - メソッド: `abort`, `close`, `getWriter`等（複雑）
  - 注意: `locked`のみフィールド化

- [ ] `ReadableStreamDefaultReader`
  - 読み取り専用: `closed: Promise[Unit]`
  - メソッド: `cancel`, `read`, `releaseLock`等（複雑）

- [ ] `WritableStreamDefaultWriter`
  - 読み取り専用: `closed: Promise[Unit]`, `desired_size: Int?`, `ready: Promise[Unit]`
  - メソッド: `abort`, `close`, `releaseLock`, `write`等（複雑）

### web/websocket パッケージ

- [ ] `WebSocket`
  - 読み取り専用: `bufferedAmount`, `extensions`, `protocol`, `readyState`, `url`
  - 可変: `mut binaryType`
  - メソッド: `send_*`, `set_on*`, `close`等（複雑）
  - 注意: イベントハンドラー設定が多い

### web/url パッケージ

- [ ] `URLPattern`
  - 読み取り専用: `hash`, `hostname`, `password`, `pathname`, `port`, `protocol`, `search`, `username`
  - メソッド: `exec`, `test`

### web/http パッケージ

- [ ] `Request`
  - 読み取り専用: `body_used`, `credentials`, `method_`, `url`
  - メソッド: `arrayBuffer`, `blob`, `formData`, `json`, `text`, `clone`等（複雑）

- [ ] `Response`
  - 読み取り専用: `body`, `ok`, `redirected`, `status`, `status_text`, `type_`
  - メソッド: `arrayBuffer`, `blob`, `formData`, `json`, `text`, `clone`等（複雑）

## 優先度: 低 - 複雑なメソッド中心

これらの型は、複雑なロジックを持つメソッドが中心のため、現状の`#external pub type`のまま維持することを推奨。

- `Storage` (browser/storage) - getter/setterメソッド中心
- `URLSearchParams` (web/url) - 複雑なメソッド多数
- `EventSource` (web/event) - イベントハンドラー多数
- `FormData` (web/http) - 複雑なメソッド多数
- `Headers` (web/http) - メソッド定義なし（空の型）
- `SubtleCrypto` (web/crypto) - 暗号化メソッド多数
- すべての`TypedArray`型 (builtins/typed_array) - 複雑なメソッド多数
- `DataView` (builtins/typed_array) - get/setメソッド多数
- `Date` (builtins/date) - getter/setterメソッド多数
- `Performance` (web/performance) - 複雑なメソッド多数
- `PerformanceObserver` (web/performance) - 複雑なメソッド多数
- `CSSStyleDeclaration` (browser/dom) - プロパティアクセスメソッド多数
- `MediaQueryList` (browser/dom) - リスナー系メソッドあり

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

- 完了: 10/10 (browser/canvas, browser/file, browser/observer, web/blob)
- 優先度高: 0/6
- 優先度中: 0/14
- 優先度低: 維持

## 次のステップ

1. 優先度高のタスクから順に実施
2. 各パッケージごとにブランチを作成し、個別にテスト
3. すべてのテストが通ることを確認してからマージ
