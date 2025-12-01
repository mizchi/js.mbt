# TODO

## Deprecated Warning Removal (Priority: Critical)

`moon check` で表示される deprecated 警告を削除することが最優先。

### 現状

`@js.JsImpl` trait は deprecated となり、`@nostd.Any` パターンへの移行を推奨している。
`moon check` を実行すると大量の警告が表示される:

```
Warning (Alert deprecated): trait inlining is too heavy. Use @nostd.Any
```

### 対応方針

1. **各ファイルの `pub impl @js.JsImpl for SomeType` を削除**
2. **代わりに `pub fn SomeType::as_any(self : SomeType) -> @nostd.Any = "%identity"` を追加**
3. **内部で `self._call()` / `self._get()` / `self.set()` を使用している箇所を `self.as_any()._call()` / `self.as_any()["key"]` に変更**

### 警告が多いファイル

- `src/cloudflare/r2.mbt` - R2Bucket, R2Object, R2MultipartUpload 等
- `src/npm/ai/` - 多数の型で JsImpl を使用
- `src/npm/drizzle/` - 多数の型で JsImpl を使用
- `src/npm/puppeteer/` - Page, Browser 等
- `src/node/` パッケージ群

### 現在の警告数

```bash
$ moon check 2>&1 | grep -c "Alert deprecated"
663
```

### 完了基準

`moon check 2>&1 | grep -c "Alert deprecated"` が 0 になること。

---

## nostd Migration (Priority: High)

`@js.JsImpl` trait のオーバーヘッドを削減し、バンドルサイズを最小化するため `@nostd` への移行を進める。

### Migration Pattern

```moonbit
// Before: @js.JsImpl trait
pub impl @js.JsImpl for MyType

// After: Direct %identity conversion
pub fn MyType::as_any(self : MyType) -> @nostd.Any = "%identity"
```

**Note:** `to_any` は `as_any` にリネームされました (TypeScript の `as T` 構文に合わせて)。

### Completed

- [x] `src/builtins/date` - `@js.JsImpl` 削除、`as_any()` 追加
- [x] `src/builtins/bigint` - 直接 FFI 化、`as_any()` 追加 (typedarray 後方互換のため `@js.JsImpl` 維持)
- [x] `src/builtins/math` - 既に nostd 互換 (全て `pub extern`)
- [x] `src/builtins/regexp` - `as_any()` 追加 (内部依存のため `@js.JsImpl` 維持)
- [x] `src/web/console` - 直接 `pub extern` に変換
- [x] `src/web/performance` - `@js.JsImpl` 削除、`as_any()` 追加
- [x] `src/web/encoding` - `@js.JsImpl` 削除、`as_any()` 追加
- [x] `src/web/url` - `as_any()` 追加、`JsError` 使用 (node/url 後方互換のため `@js.JsImpl` 維持)
- [x] `src/web/crypto` - `as_any()` 追加、`&@js.JsImpl` を `@nostd.Any` に変換
- [x] `src/browser/storage` - `@js.JsImpl` 削除、`as_any()` 追加
- [x] `src/browser/location` - `@js.JsImpl` 削除、`as_any()` 追加
- [x] `src/browser/history` - `@js.JsImpl` 削除、`as_any()` 追加
- [x] `src/browser/navigator` - `@js.JsImpl` 削除、`as_any()` 追加
- [x] `src/cloudflare/r2.mbt` - `@nostd.identity` に修正
- [x] `src/builtins/atomics` - `&@js.JsImpl` を `@nostd.Any` に変換、`as_any()` 追加
- [x] `src/builtins/reflect` - `&@js.JsImpl` を `@nostd.Any` に変換、`as_any()` 追加
- [x] `src/builtins/proxy` - `&@js.JsImpl` を `@nostd.Any` に変換、`as_any()` 追加 (後方互換のため `@js.JsImpl` 維持)
- [x] `src/browser/serviceworker` - `as_any()` 追加、`self.as_any().set()` を `self.as_any()["key"] =` に変換
- [x] `src/browser/observer` - 外部タイプに `as_any()` 追加、`self._call()` を `self.as_any()._call()` に変換
- [x] `src/npm/comlink` - 外部タイプに `as_any()` 追加、Remote メソッドを `._call()` に変換
- [x] `src/web/http/headers` - `as_any()` 追加
- [x] `src/web/http/form_data` - `as_any()` 追加、`self._call()` を `self.as_any()._call()` に変換
- [x] `src/web/websocket` - `as_any()` 追加、call/set メソッドを `._call()` / `[]` に変換
- [x] `src/web/event/event_source` - `as_any()` 追加、call/set メソッドを `._call()` / `[]` に変換
- [x] `src/web/streams/stream` - 全ての stream 型に `as_any()` 追加
- [x] `src/web/streams/compression` - `as_any()` 追加
- [x] `@js.JsImpl` trait - `to_any` → `as_any` リネーム (TypeScript `as T` 構文に合わせて)
- [x] `src/npm/ink` - nostd 移行完了、`as_any()` 追加
- [x] `src/npm/ink_testing_library` - nostd 移行完了
- [x] `src/npm/ink_ui` - nostd 移行完了
- [x] `src/npm/react` - nostd 移行完了、`lazy_` 修正 (非async化)
- [x] `src/npm/react_element` - nostd 移行完了、`ref_` 処理修正
- [x] `src/npm/react_dom` - nostd 移行完了
- [x] `src/npm/react_dom_client` - nostd 移行完了
- [x] `src/npm/react_dom_server` - nostd 移行完了
- [x] `src/npm/react_dom_static` - nostd 移行完了
- [x] `src/npm/react_router` - nostd 移行完了
- [x] `src/npm/testing_library_react` - nostd 移行完了
- [x] `src/npm/testing_library_preact` - nostd 移行完了
- [x] `src/npm/hono` - nostd 移行完了 (`@nostd.typeof_`, `@nostd.Object::new()` 使用)
- [x] `src/npm/preact` - nostd 移行完了
- [x] `src/npm/msw` - nostd 移行完了
- [x] `src/npm/ajv` - nostd 移行完了
- [x] `src/deno` - nostd 移行完了 (Deno, FsFile, TestContext, Command, ChildProcess, CommandOutput, CommandStatus, PermissionStatus)

### Progress

- npm パッケージの主要部分は移行完了
- `src/mbtconv/` パッケージ作成済み (`@js.from_map` → `@mbtconv.from_map`)
- `src/builtins/global/` パッケージ作成済み (setTimeout等のグローバル関数)
- node/http・https・http2・net・tls・v8・wasi などを順次 nostd 呼び出しに置換中
- テスト: 2365 件パス

### In Progress

- [ ] `src/builtins/typedarray` - bigint の `@js.JsImpl` 依存を解消後に移行
- [ ] `src/builtins/collection` - `@js.JsIterator` 依存
- [ ] `src/builtins/weak` - `K : @js.JsImpl` trait 制約使用
- [ ] `src/web/blob` - `@js.Promise`, `@js.ArrayBuffer`, `Array[&@js.JsImpl]` 依存
- [ ] `src/browser/canvas` - nostd import 追加と `drawImage` 等の引数ラップ未完
- [ ] `src/node/` パッケージ群 - `&@js.JsImpl` trait 参照使用 (worker_threads など)
- [ ] `src/npm/modelcontextprotocol` - HashMap/get 置換や nostd ラップの残
- [ ] `_experimental/runtime` - nostd 依存追加済み、コード側の整合性確認が必要

### Deferred (要設計検討)

- [ ] `src/npm/ai` - `@js.JsImpl` を多用、`@reflect.apply`/`@reflect.construct` の引数型問題
- [ ] `src/npm/drizzle` - `@js.JsImpl` trait 制約を広範に使用

### Blocked Patterns

以下のパターンは `@js` への強い依存があり、移行にはより大きな設計変更が必要:

- `K : @js.JsImpl` - ジェネリクス型制約
- `&@js.JsImpl` - trait 参照引数
- `@js.Promise[T]` - Promise 型
- `@js.JsIterator[T]` - Iterator 型
- `@js.ArrayBuffer` - ArrayBuffer 型

### Future Plan

1. 各パッケージの `mizchi/js` 依存を `nostd` に順次移行
2. `mizchi/js` への依存が大部分なくなった時点で `nostd` と `mizchi/js` を入れ替え
   - `nostd` → `mizchi/js` (新しいコア)
   - 旧 `mizchi/js` → 削除または `mizchi/js/legacy` へ
3. trait 廃止により `Any` がユーザー API に露出しやすくなるが、実装済みのより適切なビルトイン型に差し替える
   - 例: `Any` を返す箇所で `Date`, `Blob`, `Response` など具体型が明確な場合はそちらを使用
   - `Any` は本当に動的な値のみに限定

### Notes

- `@js.JsImpl` は段階的に削除。依存先が移行完了するまで後方互換として維持
- 新規コードでは `@nostd.any(value)._call([...])` パターンを使用
- ジェネリクス引数は `value : @nostd.Any` で受ける
- データ変換を伴わない純粋な FFI 呼び出しは `pub extern "js" fn ...` による直接実装を優先する
  - 例: `pub extern "js" fn close(self : Self) -> Unit = #| ...`
  - ラッパー関数より直接 FFI の方がバンドルサイズが小さくなる
- **`@mbtconv` は `@nostd` のみに依存** - `mizchi/js` への依存がなく、MoonBit 変換コストが大きいため、API 内部での使用は推奨しない
  - `@mbtconv.from_map` / `@mbtconv.from_json` / `@mbtconv.to_json` は MoonBit コレクション型の変換でランタイムオーバーヘッドが発生
  - ユーザー向け便利関数としては有用だが、高頻度で呼ばれる内部実装では直接 FFI を使用すること

---

- [ ] Waiting Moonbit(Js): `raise?` for FFI
- [ ] Waiting Moonbit(Js): static `import` support
- [ ] Waiting Moonbit: `moon.pkg`

## Planned npm bindings

- [x] esbuild - Fast bundler/transpiler
- [x] pino - Fast logger
- [ ] kysely - Type-safe SQL query builder
- [ ] sharp - Image processing
- [ ] jose - JWT/JWE/JWS
- [ ] helmet - Security headers for Hono
