# API Review TODO List

リリース前のAPIレビューで発見された問題点の修正リスト

## 優先度高 (リリース前に必須) - ✅ 完了

- [x] 1. `src/http/` - 具体的すぎるResponseヘルパーメソッドを削除
  - ✅ 削除済み: `Response::json_with_*` 系のメソッドを全て削除
  - ✅ サンプルコードを `Response::json_()` を使うように修正

- [x] 2. `src/http/` - 用途不明な関数の確認
  - ✅ `get_component_groups` と `get_component_input` はテストで使用されているため保持

- [x] 3. `src/math/` - 返り値型の確認と修正
  - ✅ `abs(Double) -> Double` に修正
  - ✅ `ceil(Double) -> Double` に修正
  - ✅ `floor(Double) -> Double` に修正
  - ✅ `round(Double) -> Double` に修正

## 優先度中 (リリース後でも可) - ✅ 完了

- [x] 4. `src/websocket/` - WebSocket状態定数をenumに変更
  - ✅ `enum WebSocketReadyState` を定義
  - ✅ 旧関数を `#deprecated` として残して後方互換性を維持

- [x] 5. `src/cloudflare/` - CloudflareFetchHandler の改善
  - ✅ `struct` から `type alias` に変更
  - ✅ `CloudflareFetchHandler::inner` の自動生成を防止

## 優先度低 (今後の改善) - 未対応

- [ ] 6. `src/crypto/` - @js.Js多用箇所にコメント追加
  - `SubtleCrypto` のメソッドに期待する型を明記

- [ ] 7. `src/dom/` - @js.Js多用箇所の型具体化
  - `Document::getElementById` など

- [ ] 8. `src/http/` - 命名の統一
  - `URLPattern::exec` と `URLPattern::execWithBase` のalias統一

- [ ] 9. `src/console/` - assert_の第2引数を具体化
  - `@js.Js` を `message? : String` に

- [ ] 10. `src/node/fs/` - オプショナルパラメータに名前を付ける
  - `readSync(Int, @buffer.Buffer, Int, Int, Int?)` の最後を `position? : Int` に

## テスト結果

✅ 全てのテスト通過 (1107 tests passed)
✅ `moon info` エラーなし
✅ `moon fmt` 完了
