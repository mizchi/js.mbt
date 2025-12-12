# xany vs @core.Any 比較

## 結論

**JS バックエンドでは実質的に同じ実装**。パフォーマンス差はない。

## 実装比較

両方とも同じインライン JS を使用：

```moonbit
// @core.Any
pub extern "js" fn Any::_get(self : Any, key : String) -> Any =
  #| (obj, key) => obj[key]

// @xany.Xany
pub extern "js" fn Xany::_get(self : Xany, key : String) -> Xany =
  #| (obj, key) => obj[key]
```

## 違い

| 項目 | @core.Any | @xany.Xany |
|------|-----------|------------|
| 型名 | `Any` | `Xany` |
| 値のラップ | `@core.any(value)` | `Xany::of(value)` |
| WASM-GC | 未対応 | 対応 |
| Native | 未対応 | API は存在するが全て panic |

## xany の存在意義

1. **WASM-GC サポート**: `xany` は WASM-GC バックエンド用の実装を持つ
2. **API 互換性**: `tonyfettes/any` と同じ `Xany::of` スタイル
3. **クロスターゲット**: 同一 API で JS / WASM-GC 両方で動作

## バックエンド対応表

| API | JS | WASM-GC | Native |
|-----|-----|---------|--------|
| `Xany::of` | %identity | externref | panic |
| `Xany::unsafe_coerce` | %identity | %identity | %identity |
| `_get`, `_set`, `_call`, `_invoke` | 動作 | 動作 | panic |
| `global_this` | 動作 | 動作 | panic |
| `null`, `undefined` | 動作 | 動作 | **動作** (C NULL) |
| `is_nullish` | 動作 | 動作 | **動作** (== 0) |
| `equal` | === 比較 | === 比較 | ポインタ比較 |

Native では `#external type Xany` が void* 相当となり、Double など非ポインタ型を格納できないため、`of` や JS 操作系は panic となる。ただし `null`/`undefined`/`is_nullish` は C の NULL ポインタとして実装されている。

## ベンチマーク

```bash
moon build --target js
deno run target/js/release/build/xany/_bench/_bench.js
```

複数回実行すると、JIT ウォームアップ後は**ほぼ同等のパフォーマンス**を示す。

ソース: `src/xany/_bench/main.mbt`
