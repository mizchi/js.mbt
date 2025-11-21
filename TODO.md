# Type Refinement Plan - リリース前の型具体化

## 目的

`@js.Js` を多用している箇所を、可能な限り具体的な型に置き換え、型安全性を向上させる。

## 基本方針

1. **引数の型が自明な場合**: MoonBitのビルトイン型（String, Int, Bool等）で宣言してからキャストする
2. **JSオブジェクトを受け取る場合**: `&JsImpl` で受けて `.to_js()` でキャストする
3. **返り値**: 可能な限り具体的な型を返す（Element, String等）

## 優先度高: リリース前に必須

### 1. `src/console/` - assert_の第2引数を具体化
- [ ] `assert_(Bool, @js.Js)` → `assert_(Bool, &JsImpl)`
- [ ] 任意のMoonBit型を受け取れるようにする

### 2. `src/crypto/` - SubtleCryptoのメソッド引数を具体化
- [ ] `digest(String, &JsImpl)` - データ部分を具体化
- [ ] `encrypt/decrypt` - アルゴリズムとキーの型を明確化
- [ ] `generateKey` - アルゴリズムオプションの型を定義

### 3. `src/http/` - Response/Requestの型具体化
- [ ] `Response::json_(@js.Js)` → `Response::json_(&JsImpl)`
- [ ] `fetch` のオプション引数を構造体で定義
- [ ] `new_response(body?, options?)` の型を明確化

### 4. `src/dom/` - DOM APIの型具体化
- [ ] `Document::getElementById(String) -> @js.Js?` → `Element?`
- [ ] `Document::getElementsByClassName(String) -> @js.Js` → `Array[Element]`
- [ ] `Document::createElement` の返り値を `Element` に
- [ ] イベントハンドラの型を具体化

### 5. `src/websocket/` - WebSocketの型具体化  
- [ ] `send` メソッドの引数型を明確化
- [ ] イベントハンドラの型を具体化
- [ ] `readyState` の返り値を `WebSocketReadyState` に

## 優先度中: リリース後でも可

### 6. `src/stream/` - Stream APIの型具体化
- [ ] `ReadableStream::new(@js.Js)` のストラテジーオブジェクトを型定義
- [ ] `pipeTo/pipeThrough` のオプションを構造体化

### 7. `src/node/fs/` - Node.js FSの型具体化
- [ ] `readSync(..., Int?)` → `readSync(..., position?: Int)`
- [ ] オプションオブジェクトを構造体化

### 8. `src/cloudflare/` - Cloudflare APIの型具体化
- [ ] KV/R2/D1のオプション型をさらに具体化
- [ ] メタデータの型を定義

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
