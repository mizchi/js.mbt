# Type Refinement Plan - リリース前の型具体化

## 目的

`@js.Js` を多用している箇所を、可能な限り具体的な型に置き換え、型安全性を向上させる。

## 基本方針

1. **引数の型が自明な場合**: MoonBitのビルトイン型（String, Int, Bool等）で宣言してからキャストする
2. **JSオブジェクトを受け取る場合**: `&JsImpl` で受けて `.to_js()` でキャストする
3. **返り値**: 可能な限り具体的な型を返す（Element, String等）

## 優先度高: リリース前に必須

### 1. `src/console/` - ✅ 完了
- [x] `assert_(Bool, @js.Js)` → `assert_(Bool, &JsImpl)`
- [x] 全ての関数で `&JsImpl` を受け付けるように変更

### 2. `src/crypto/` - ✅ 完了
- [x] SubtleCrypto メソッドで不要な `.to_js()` 呼び出しを削除
- [x] `self.to_js().call()` → `self.call()` に統一

### 3. `src/http/` - ✅ 完了
- [x] `Response::json_(@js.Js)` → `Response::json_(&JsImpl)`
- [x] オプション引数も `&JsImpl` で受け取るように変更

### 4. `src/dom/` - ✅ 完了
- [x] `Document::getElementById(String) -> @js.Js?` → `Element?`
- [x] `Document::getElementsByClassName(String) -> @js.Js` → `Array[Element]`
- [x] `Document::getElementsByTagName(String) -> @js.Js` → `Array[Element]`
- [x] `Document::createDocumentFragment()` → `DocumentFragment`
- [x] `Document::createComment()` → `Node`

### 5. `src/websocket/` - ✅ 完了
- [x] プロパティの返り値を具体化（String, Int, Bool）
- [x] イベントヘルパー関数の返り値を具体化

## 優先度中: リリース後でも可

### 6. `src/stream/` - Stream APIの型具体化
- 現状: ストリームのオプションオブジェクトは複雑で、構造体化すると柔軟性が失われる
- 決定: 現在の `@js.Js` のまま維持（リリース後に必要に応じて再検討）

### 7. `src/node/fs/` - Node.js FSの型具体化
- [ ] `statSync(String) -> @js.Js` を Stats 構造体に変更
- [ ] Stats 構造体を定義（isFile, isDirectory, size, mtime 等）

### 8. `src/cloudflare/` - Cloudflare APIの型具体化
- 現状: 主要な型は既に具体化済み（KVNamespace, R2Bucket等）
- 決定: 現状で十分（リリース後に必要に応じて拡張）

## 実施手順

1. 各パッケージの `.mbti` を確認して、`@js.Js` を使っている箇所をリストアップ
2. 該当する `.mbt` ファイルを修正
3. `moon info && moon test` で動作確認
4. 一つずつコミット

## 注意事項

- JavaScriptとの相互運用性を保つため、過度な型制約は避ける
- 既存のユーザーコードへの影響を最小限にする
- テストが全て通ることを確認してからコミット

## リファクタリングタスク（リリース後）

### コーディング規約の統一

1. **#alias の一貫性**
   - `#alias` には必ず snake_case を書く
   - 実装側には元のJavaScript関数名を宣言する
   - 例: `#alias(create_element)` + `fn createElement(...)`

2. **関数名の規約**
   - Web標準API: camelCase（JavaScript準拠）
   - MoonBit固有のラッパー: snake_case

3. **ドキュメントリンク**
   - Web標準API: MDNのリンクを記述
   - Node.jsモジュール: Node.js公式サイトの該当モジュールへのリンクを記述

4. **型宣言の最適化**
   - `#external pub type` で宣言されているもののうち、以下の条件を満たすものは `pub(all) struct` に変更:
     - MoonBit側から生成しない
     - ほぼ単純なgetterで構成されている
   - 例: `DOMRect`, `DOMRectReadOnly` など
