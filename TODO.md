# TODO

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
- [x] `src/browser/observer` - 外部タイプに `as_any()` 追加、`self.call()` を `self.as_any()._call()` に変換
- [x] `src/npm/comlink` - 外部タイプに `as_any()` 追加、Remote メソッドを `._call()` に変換
- [x] `src/web/http/headers` - `as_any()` 追加
- [x] `src/web/http/form_data` - `as_any()` 追加、`self.call()` を `self.as_any()._call()` に変換
- [x] `src/web/websocket` - `as_any()` 追加、call/set メソッドを `._call()` / `[]` に変換
- [x] `src/web/event/event_source` - `as_any()` 追加、call/set メソッドを `._call()` / `[]` に変換
- [x] `src/web/streams/stream` - 全ての stream 型に `as_any()` 追加
- [x] `src/web/streams/compression` - `as_any()` 追加
- [x] `@js.JsImpl` trait - `to_any` → `as_any` リネーム (TypeScript `as T` 構文に合わせて)

### Progress

- 残り: 約 100 パッケージ

### In Progress

- [ ] `src/builtins/typedarray` - bigint の `@js.JsImpl` 依存を解消後に移行
- [ ] `src/builtins/collection` - `@js.JsIterator` 依存
- [ ] `src/builtins/weak` - `K : @js.JsImpl` trait 制約使用
- [ ] `src/web/blob` - `@js.Promise`, `@js.ArrayBuffer`, `Array[&@js.JsImpl]` 依存
- [ ] `src/node/` パッケージ群 - `&@js.JsImpl` trait 参照使用

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
