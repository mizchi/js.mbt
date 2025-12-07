# Pure MoonBit Declarative UI Library

純粋な MoonBit による宣言的 UI ライブラリ。React/Preact のような外部依存なしで、Virtual DOM、差分レンダリング、Hooks を実装します。

## プロジェクト目標

- ✅ **純粋な MoonBit 実装**: React/Preact への FFI 依存を排除
- ✅ **最小限のバンドルサイズ**: コア < 5KB を目標
- ✅ **型安全な API**: MoonBit の型システムを活用
- ✅ **DOM & SSR 対応**: ブラウザレンダリングとサーバーサイドレンダリングの両方に対応
- 🚧 **Hooks ベースの状態管理**: React 風の API (useState, useEffect 等)

## 実装状況

### ✅ Phase 1: Core Types & Element Creation (完了)

**ファイル**: `vdom.mbt`, `element.mbt`

- VNode 型定義 (Element, Text, Fragment, Empty, Component)
- ElementNode 構造体
- Props を `@core.Any` として実装（マップオーバーヘッド回避）
- HTML 要素作成 DSL (div, span, button, etc.)
- ジェネリック関数による柔軟な Props 型

```moonbit
// 構造体リテラルによる Props
struct ButtonProps {
  className : String
  onClick : EventHandler
}

let node = button({ className: "btn", onClick: handler }, [text("Click")])

// または @core.Any オブジェクト
let props = @core.new_object()
props["className"] = @core.any("btn")
let node = button(props, [text("Click")])
```

**テスト**: 12個 - VNode 構築、Props 設定

### ✅ Phase 2: SSR Renderer (完了)

**ファイル**: `renderer_ssr.mbt`, `renderer_ssr_test.mbt`

- `render_to_string()`: VNode を HTML 文字列に変換
- HTML エスケープ (XSS 対策)
- Props から HTML 属性への変換
- Style オブジェクトの CSS 文字列化
- Void 要素のサポート (br, img, input, etc.)
- イベントハンドラーのスキップ（SSR では不要）

```moonbit
let html = render_to_string(
  div({ className: "container" }, [
    h1(@core.new_object(), [text("Title")]),
    p(@core.new_object(), [text("Content")])
  ])
)
// => "<div class=\"container\"><h1>Title</h1><p>Content</p></div>"
```

**テスト**: 18個 - 基本レンダリング、HTML エスケープ、Props、Void 要素

### ✅ Phase 3: DOM Renderer (完了)

**ファイル**: `renderer_dom.mbt`, `renderer_dom_test.mbt`

- `DomRenderer` 構造体: レンダリング管理
- `create_dom_node()`: VNode から DOM ノードを作成
- `apply_props()`: Props を DOM 要素に適用
- イベントハンドラーの設定 (addEventListener)
- Style オブジェクトの適用
- Boolean 属性の処理

```moonbit
let renderer = DomRenderer::new(container)
renderer.render(
  div({ className: "app" }, [
    button({ onClick: fn(_) { ... } }, [text("Click")])
  ])
)
```

**テスト**: 17個 - 基本レンダリング、Props、イベントハンドラー、複雑な構造

### ✅ Phase 4: Reconciliation (完了)

**ファイル**: `reconcile.mbt`

- **Patch 型**: DOM への変更操作を表現
  - CreateElement, RemoveNode, ReplaceNode
  - UpdateProps, UpdateText, ReconcileChildren
- **diff アルゴリズム**: 2つの VNode を比較して Patch を生成
- **apply_patches()**: Patch を DOM に適用
- **reconcile_children()**: 子要素の差分更新（位置ベース）
- **DomRenderer の更新**: 初回レンダリングと差分更新を分離

```moonbit
// 初回レンダリング
renderer.render(div(props, [text("Old")]))

// 差分更新（必要な部分のみ DOM を更新）
renderer.render(div(props, [text("New")]))
```

**最適化**:
- 変更が必要な部分のみを更新
- 要素タイプが同じなら props と children のみ差分更新
- テキストノードは textContent のみ更新

**テスト**: 17個 - 基本差分更新6個（テキスト/Props更新、子要素追加/削除、要素置換）+ 高度なテスト11個（スタイル更新、属性追加/削除、Boolean属性、Fragment更新、深いネスト、複数連続更新、混合更新、空ノード、並び替え、実際のシナリオ）

**TODO**:
- keyed reconciliation (key 属性による最適化)

### ✅ Phase 4.5: Props リファクタリング (完了)

**ファイル**: `vdom.mbt`, `props_builder.mbt`

Props を型安全な `Array[(String, AttrValue)]` に変更:

- **AttrValue enum**: Str, Num, Bool, Handler, StyleObj
- **Props型**: `Array[(String, AttrValue)]` として定義
- **Builder API**: `class_name()`, `id()`, `on_click()` 等の型安全な関数
- **Props比較**: 型に基づく正確な比較（EventHandlerは常に異なると判定）

**テスト**: 全66テスト更新（ui_test, renderer_ssr_test, renderer_dom_test）

### ✅ Phase 6: Context API (完了)

**ファイル**: `context.mbt`, `context_test.mbt`

グローバル状態管理:

- `create_context[T](default_value : T) -> Context[T]`
- `set_context[T](context : Context[T], value : T) -> Unit`
- `get_context[T](context : Context[T]) -> T`
- `clear_context[T](context : Context[T]) -> Unit`

**テスト**: 9個 - Context作成、値の設定/取得、複数Context、型安全性

## 今後の計画

### 🚧 Phase 5: Hooks System

**ファイル**: `hooks.mbt`

Hooks による状態管理:

```moonbit
fn Counter(initial : Int) -> VNode {
  let (count, set_count) = use_state(initial)
  let increment = fn(_) { set_count(count + 1) }

  div(@core.new_object(), [
    text("Count: \{count}"),
    button({ onClick: increment }, [text("+")])
  ])
}
```

実装予定:
- `use_state[T](initial : T) -> (T, (T) -> Unit)`
- `use_effect(effect : () -> (() -> Unit)?, deps : Array[@core.Any]?) -> Unit`
- `use_memo[T](compute : () -> T, deps : Array[@core.Any]?) -> T`
- `use_callback[T](f : T, deps : Array[@core.Any]?) -> T`
- `use_ref[T](initial : T?) -> Ref[T]`

内部実装:
- Fiber スタックによる現在のコンポーネント追跡
- HooksState: コンポーネントごとの Hooks 配列
- Hooks インデックス管理

### ✅ Phase 6: Context API (完了)

**ファイル**: `context.mbt`, `context_test.mbt`

グローバル状態管理のためのシンプルなContext API:

```moonbit
// Contextを作成
let ThemeContext = create_context("light")
let UserContext = create_context("anonymous")

// 値を設定（Provider のような使い方）
set_context(ThemeContext, "dark")
set_context(UserContext, "Alice")

// 値を取得（useContext のような使い方）
let theme = get_context(ThemeContext)  // => "dark"
let user = get_context(UserContext)    // => "Alice"

// デフォルト値に戻す
clear_context(ThemeContext)
let theme = get_context(ThemeContext)  // => "light"
```

実装済み:
- `create_context[T](default_value : T) -> Context[T]`
- `set_context[T](context : Context[T], value : T) -> Unit`
- `get_context[T](context : Context[T]) -> T`
- `clear_context[T](context : Context[T]) -> Unit`

**テスト**: 9個 - Context作成、値の設定/取得、複数Context、clear、型安全性

**内部実装**:
- グローバルなJavaScript Map でContext値を保存
- Context毎にユニークなIDを割り当て
- 型パラメータによる型安全性

### 🚧 Phase 7: Component Support

**ファイル**: `component.mbt`

Component VNode のレンダリング:

```moonbit
pub type Component[T] = (T) -> VNode

pub fn[T] component(f : Component[T], props : T, key : String?) -> VNode {
  VNode::Component({
    render: fn() { f(props) },
    key,
    hooks_state: HooksState::new()
  })
}
```

### 🚧 Phase 8: Optimization & Polish

- バンドルサイズ分析
- パフォーマンスベンチマーク
- Keyed reconciliation
- Props の詳細な比較
- API ドキュメント
- サンプルアプリケーション

## アーキテクチャ

### VNode 構造

```moonbit
pub enum VNode {
  Element(ElementNode)      // <div>, <span> 等
  Text(String)               // テキストノード
  Component(ComponentNode)   // 関数コンポーネント (未実装)
  Fragment(Array[VNode])     // 複数の子要素
  Empty                      // 空ノード
}

pub struct ElementNode {
  tag : String               // "div", "span", etc.
  props : @core.Any          // 任意の Props オブジェクト
  children : Array[VNode]    // 子要素
  key : String?              // reconciliation 用 (未使用)
}
```

### レンダリングフロー

1. **VNode 構築**: `div(props, children)` 等で VNode ツリーを作成
2. **初回レンダリング**: `DomRenderer::render()` で DOM ツリーを作成
3. **差分更新**:
   - 古い VNode と新しい VNode を `diff()` で比較
   - 必要な変更を `Patch` として生成
   - `apply_patches()` で DOM に適用
4. **SSR**: `render_to_string()` で HTML 文字列を生成

### サイズ最適化戦略

1. **Array[VNode] 直接使用**: ゼロコスト変換
2. **Props を @core.Any**: Map 使用による ~6KB オーバーヘッド回避
3. **手動オブジェクト構築**: `@core.new_object()` と直接プロパティアクセス
4. **不変コレクション回避**: `@immut/array`, `@immut/hashmap` を使わない
5. **FFI 呼び出し最小化**: DOM 操作をバッチ処理

**現在のサイズ**: コアライブラリ（Components 除く）< 5KB (minified)

## 使用例

### 基本的な例

```moonbit
// SSR
let html = render_to_string(
  div({ className: "app" }, [
    h1(@core.new_object(), [text("Hello MoonBit!")]),
    p(@core.new_object(), [text("Pure MoonBit UI Library")])
  ])
)

// DOM レンダリング
let container = @dom.document().getElementById("app").unwrap()
let renderer = DomRenderer::new(container)

renderer.render(
  div({ className: "app" }, [
    h1(@core.new_object(), [text("Hello MoonBit!")]),
    button({
      onClick: fn(_) {
        renderer.render(
          div({ className: "app" }, [
            h1(@core.new_object(), [text("Clicked!")])
          ])
        )
      }
    }, [text("Click me")])
  ])
)
```

### 動的リスト

```moonbit
let items = ["Apple", "Banana", "Cherry"]
let list_items = items.map(fn(item) {
  li(@core.new_object(), [text(item)])
})

renderer.render(
  ul(@core.new_object(), list_items)
)
```

## テスト

```bash
moon test --package mizchi/js/_experimental/ui
moon test --package mizchi/js/_experimental/ui --update  # スナップショット更新
```

**テスト数**: 75個
- VNode 構築: 12個
- SSR: 18個
- DOM 基本レンダリング: 17個
- Reconciliation（差分レンダリング）: 17個
- Props API: 11個（上記テストに含まれる）
- Context API: 9個

## API リファレンス

### Element 作成

```moonbit
// 汎用要素作成
pub fn[T] el(tag : String, props : T, children : Array[VNode]) -> VNode
pub fn[T] el_key(tag : String, props : T, children : Array[VNode], key : String) -> VNode

// HTML 要素
pub fn[T] div(props : T, children : Array[VNode]) -> VNode
pub fn[T] span(props : T, children : Array[VNode]) -> VNode
pub fn[T] button(props : T, children : Array[VNode]) -> VNode
pub fn[T] input(props : T) -> VNode
pub fn[T] a(props : T, children : Array[VNode]) -> VNode
pub fn[T] h1(props : T, children : Array[VNode]) -> VNode
pub fn[T] ul(props : T, children : Array[VNode]) -> VNode
pub fn[T] li(props : T, children : Array[VNode]) -> VNode
// ... その他多数

// テキスト・Fragment
pub fn text(content : String) -> VNode
pub fn fragment(children : Array[VNode]) -> VNode
pub fn empty() -> VNode

// Void 要素
pub fn br() -> VNode
pub fn hr() -> VNode
```

### SSR

```moonbit
pub fn render_to_string(vnode : VNode) -> String
```

### DOM レンダリング

```moonbit
pub struct DomRenderer {
  container : @dom.Element
  mut root_vnode : VNode?
  mut root_node : @dom.Node?
}

pub fn DomRenderer::new(container : @dom.Element) -> DomRenderer
pub fn DomRenderer::render(self : DomRenderer, vnode : VNode) -> Unit
```

### Reconciliation

```moonbit
pub fn diff(
  old_vnode : VNode?,
  new_vnode : VNode?,
  dom_node : @dom.Node?,
  parent : @dom.Node?,
) -> Array[Patch]

pub fn apply_patches(patches : Array[Patch]) -> Unit
```

### Context API

```moonbit
pub struct Context[T] {
  id : Int
  default_value : T
}

pub fn[T] create_context(default_value : T) -> Context[T]
pub fn[T] set_context(context : Context[T], value : T) -> Unit
pub fn[T] get_context(context : Context[T]) -> T
pub fn[T] clear_context(context : Context[T]) -> Unit
```

## 技術的な詳細

### Props の型安全性

Props を `@core.Any` として扱うことで、構造体リテラルと動的オブジェクトの両方をサポート:

```moonbit
// 型安全な構造体
struct MyProps { className : String, onClick : EventHandler }
div({ className: "btn", onClick: handler }, [...])

// 動的オブジェクト
let props = @core.new_object()
props["className"] = @core.any("btn")
div(props, [...])
```

### イベントハンドラー

- DOM: `addEventListener` で設定
- SSR: スキップ（`onClick` 等を HTML に含めない）
- イベント名変換: `onClick` → `click`, `onChange` → `change`

### HTML エスケープ

XSS 対策のため、テキストコンテンツと属性値をエスケープ:
- `&` → `&amp;`
- `<` → `&lt;`
- `>` → `&gt;`
- `"` → `&quot;`
- `'` → `&#39;`

## トレードオフと設計判断

### Pros
- ✅ 純粋な MoonBit 実装（外部依存なし）
- ✅ 型安全な VNode 構築
- ✅ 最小限のバンドルサイズ (< 5KB)
- ✅ MoonBit ネイティブ API（FFI ブリッジ不要）
- ✅ DOM と SSR の両方をサポート

### Cons
- ❌ React エコシステムとの互換性なし
- ❌ Hooks, Context 等を再実装する必要がある
- ❌ React と異なるエッジケース動作の可能性
- ❌ Props の型安全性は限定的（`@core.Any` 使用）

### 主要な設計判断

1. **Props を @core.Any に**: 型安全性を犠牲にして最小サイズを実現
2. **keyed reconciliation**: リストパフォーマンスに必須（Phase 8 で実装予定）
3. **Hooks over classes**: モダンな React パターンを採用
4. **JSX なし**: 関数 DSL を使用（MoonBit に JSX パーサーなし）
5. **手動レンダリング**: 自動リアクティブなし（明示的に `render()` を呼ぶ）

## 今後の拡張

- Suspense サポート
- Error boundaries
- Dev tools 統合
- Time-slicing / Concurrent rendering
- Callback refs
- Portal サポート
- 追加 Hooks (useReducer, useLayoutEffect, etc.)

## ライセンス

プロジェクトのライセンスに従う
