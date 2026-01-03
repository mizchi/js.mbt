# Trait-based Any Conversion

`|> @core.any` の使用を削減するためのトレイトベースアプローチの検討。

## 現状の問題

現在、JavaScript API を呼び出す際に値を `Any` に変換する必要がある:

```moonbit
// 現状: 冗長なキャスト
obj._set("name", "Alice" |> @core.any)
obj._set("age", 30 |> @core.any)
arr._call("push", [4 |> @core.any]) |> ignore
```

## MoonBit の最新変更

### 関連する変更点

1. **トレイトオブジェクト構文の変更** (2024-12)
   - `Trait` → `&Trait` に統一
   - トレイト型とトレイトオブジェクト型の区別が明確に

2. **暗黙的変換のサポート** (2025)
   - `String` → `@string.View` の暗黙的変換が追加
   - 将来的に他の型にも拡張される可能性

3. **演算子オーバーロードのトレイト化**
   - メソッドベースからトレイトベースに移行
   - `@moonbitlang/core/builtin` のトレイトを実装する形式に

## アプローチ案

### 案1: ToJsAny トレイト

```moonbit
///| JavaScript Any への変換トレイト
pub trait ToJsAny {
  to_js_any(Self) -> Any
}

///| プリミティブ型の実装
impl ToJsAny for Int with to_js_any(self) -> Any = "%identity"
impl ToJsAny for String with to_js_any(self) -> Any = "%identity"
impl ToJsAny for Bool with to_js_any(self) -> Any = "%identity"
impl ToJsAny for Double with to_js_any(self) -> Any = "%identity"
impl ToJsAny for Any with to_js_any(self) -> Any { self }

///| 使用例（ジェネリクス+トレイト制約）
pub fn Any::set_value[T : ToJsAny](self : Any, key : String, value : T) -> Unit {
  self._set(key, value.to_js_any())
}
```

**利点:**
- 型安全性が向上
- 自動補完が効く
- カスタム型に拡張可能

**欠点:**
- モノモーフィゼーションにより各型でコードが生成される
- 既存コードの変更が必要

### 案2: 固定アリティヘルパー関数

```moonbit
///| 2引数のset（キー:String, 値:Any）
pub fn Any::set2(self : Any, k1 : String, v1 : Any, k2 : String, v2 : Any) -> Unit {
  self._set(k1, v1)
  self._set(k2, v2)
}

///| ビルダーパターン
pub fn Any::with_prop(self : Any, key : String, value : Any) -> Any {
  self._set(key, value)
  self
}
```

### 案3: ジェネリック配列ヘルパー

```moonbit
///| 可変長引数の代替
pub fn call_with[T : ToJsAny](obj : Any, method : String, args : Array[T]) -> Any {
  let js_args = args.map(fn(v) { v.to_js_any() })
  obj._call(method, js_args)
}
```

## 生成コードの比較

### 現状 (`%identity`)

```moonbit
pub fn[T] any(value : T) -> Any = "%identity"
```

`%identity` はコンパイル時に完全に消去されるため、ランタイムコストはゼロ。
ただし、各呼び出し箇所でジェネリック関数のインスタンス化が発生する可能性がある。

### トレイト版

```moonbit
impl ToJsAny for Int with to_js_any(self) -> Any = "%identity"
```

トレイト制約付きジェネリック関数はモノモーフィゼーションにより特殊化される。
MoonBit の最適化により、同じ型パラメータでの呼び出しは共有される。

## 推奨アプローチ

1. **短期**: 現状維持（`%identity` は既にゼロコスト）
2. **中期**: ToJsAny トレイトを実験的に追加し、生成コードサイズを比較
3. **長期**: MoonBit の暗黙的変換機能が拡張されれば、それを採用

## 実験: ToJsAny トレイトの試作

`src/experiments/trait_any/` で試作を検討:

```moonbit
///| trait_any.mbt
pub trait ToJsAny {
  to_js_any(Self) -> @core.Any
}

impl ToJsAny for Int with to_js_any(self) -> @core.Any = "%identity"
impl ToJsAny for String with to_js_any(self) -> @core.Any = "%identity"
impl ToJsAny for Bool with to_js_any(self) -> @core.Any = "%identity"
impl ToJsAny for Double with to_js_any(self) -> @core.Any = "%identity"
impl ToJsAny for @core.Any with to_js_any(self) -> @core.Any { self }

///| 使いやすいヘルパー
pub fn set[T : ToJsAny](obj : @core.Any, key : String, value : T) -> Unit {
  obj._set(key, value.to_js_any())
}

pub fn call1[T : ToJsAny](obj : @core.Any, method : String, arg : T) -> @core.Any {
  obj._call(method, [arg.to_js_any()])
}
```

## ベンチマーク: モノモーフィゼーション vs 動的ディスパッチ

`src/experiments/trait_any/oop_benchmark.mbt` で検証を行った。

### 検証シナリオ

- 12個のメソッドを持つ `LargeApi` トレイト
- 3つの実装型: `TypeA`, `TypeB`, `TypeC`
- 2パターンの関数: ジェネリクス版 (`fn[T : LargeApi]`) と動的ディスパッチ版 (`&LargeApi`)

### 生成コード分析結果

| パターン | 関数 | 生成数 | 行数(概算) |
|----------|------|--------|------------|
| Generics | `process_generic` | 3回複製 | ~9行 |
| Generics | `sum_all_generic` | 2回複製 | ~34行 |
| Dynamic | `process_dynamic` | 1回のみ | ~3行 |
| Dynamic | `sum_all_dynamic` | 1回のみ | ~17行 |

### 結論

**コード膨張問題は解決されていない。**

MoonBitの現在のコンパイラでは、ジェネリクス+トレイト制約を使用すると、
各型パラメータでコードが複製される（モノモーフィゼーション）。

### 生成JSコードの比較

**Generics版** - 型ごとにインライン展開:
```javascript
// TypeA用
function process_generic$0$(item) {
  return item.value + 1 + item.value + 2 + ...
}
// TypeB用
function process_generic$2$(item) {
  return Math.imul(item.value, 1) + Math.imul(item.value, 2) + ...
}
// TypeC用
function process_generic$1$(item) {
  return item.value - 1 + item.value - 2 + ...
}
```

**Dynamic版** - vtable経由で1つの関数:
```javascript
function process_dynamic(item) {
  return item.method_table.method_0(item.self) +
         item.method_table.method_1(item.self) + ...
}
```

### トレードオフ

| 観点 | Generics (`fn[T : Trait]`) | Dynamic (`&Trait`) |
|------|---------------------------|-------------------|
| コードサイズ | 大（型ごとに複製） | 小（1つの関数） |
| ランタイム性能 | 高速（インライン最適化） | 若干遅い（vtable間接参照） |
| 型の混在 | 不可（`Array[T]`は同一型のみ） | 可能（`Array[&Trait]`） |

### 推奨ガイドライン

| ケース | 推奨 |
|--------|------|
| 小さなトレイト (1-3メソッド)、少数の型 | `fn[T : Trait]` - インライン最適化の恩恵 |
| 大きなトレイト (4+メソッド)、多数の型 | `&Trait` - コードサイズ削減 |
| 異なる型を同一コレクションに格納 | `&Trait` 必須 |
| パフォーマンス最優先の内部ループ | `fn[T : Trait]` |
| ライブラリのパブリックAPI | `&Trait` - 利用者側のコードサイズを削減 |

### 参考

- [OOP in MoonBit](https://www.moonbitlang.com/pearls/oop-in-moonbit) - 動的ディスパッチの解説
- `src/experiments/trait_any/oop_benchmark.mbt` - ベンチマークコード

## 関連リンク

- [MoonBit Traits Documentation](https://docs.moonbitlang.com/en/latest/language/methods.html)
- [MoonBit Weekly Updates](https://www.moonbitlang.com/weekly-updates/)
- `tonyfettes/any` - 実行時型情報を持つ動的型システム
- `src/core/core.mbt` - 現在の `any` 関数実装
