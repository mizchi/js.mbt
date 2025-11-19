# FFI Performance Analysis - mizchi/js

## ベンチマーク結果

### 関数呼び出しのオーバーヘッド

| 操作 | 時間 | 説明 |
|------|------|------|
| **direct FFI call (ffi_call0)** | 0.00 µs | 直接FFI呼び出し（ベースライン） |
| **JsImpl call0 method** | 0.01 µs | Traitを通した呼び出し |
| **call1 with Int** | 0.01 µs | to_js変換を含む1引数呼び出し |
| **call2 with two Ints** | 0.02 µs | 2引数呼び出し |
| **call with Array[Int] (5 elements)** | 0.04 µs | 配列のmap変換を含む |
| **call with Array[Js] (pre-converted)** | 0.02 µs | 事前変換済み配列 |

**重要な発見:**
- Array変換のオーバーヘッド: **0.04 µs vs 0.02 µs (2倍)**
- 事前に型変換した配列を使うと50%高速化

### Object操作のオーバーヘッド

| 操作 | 時間 | 説明 |
|------|------|------|
| **Object::new()** | 0.01 µs | オブジェクト生成 |
| **Object set (1 property)** | 0.01 µs | 1プロパティ設定 |
| **Object set (5 properties)** | 0.06 µs | 5プロパティ設定 |
| **Object get** | 0.01 µs | プロパティ取得 |
| **Object::keys** | 0.07 µs | キー一覧取得 |

**重要な発見:**
- プロパティ設定は線形スケール: 1個=0.01µs, 5個=0.06µs → **約0.012µs/プロパティ**
- Object::keysは比較的高コスト (0.07 µs)

### 型変換のオーバーヘッド

| 操作 | 時間 | 説明 |
|------|------|------|
| **Int to_js conversion** | 0.01 µs | unsafe_castと同等 |
| **String to_js conversion** | 0.01 µs | unsafe_castと同等 |
| **unsafe_cast Int to Js** | 0.01 µs | ベースライン |
| **from_array (5 Ints)** | 0.01 µs | 配列変換 |
| **Array map to_js (5 Ints)** | 0.01 µs | 手動map |
| **from_map (5 entries)** | 0.10 µs | Map→Object変換 |

**重要な発見:**
- `to_js()`は`unsafe_cast`と同じコスト（最適化されている）
- `from_array`は非常に高速（5要素で0.01µs）
- `from_map`は比較的高コスト（0.10µs）：各エントリでObject::setが必要

### 複雑な操作

| 操作 | 時間 | 説明 |
|------|------|------|
| **create nested object (realistic)** | 0.11 µs | ネストしたオブジェクト生成 |
| **chained method calls** | 0.07 µs | メソッドチェーン（3回） |

**重要な発見:**
- 複雑なネストオブジェクト生成: 0.11 µs
  - 内訳: Object 2個 + プロパティ設定 + from_array
- メソッドチェーンは累積的：3回呼び出しで0.07µs

## 最適化の機会

### 1. 高頻度の配列操作を最適化

**問題点:**
```moonbit
// 現状: call()は毎回配列をmapで変換
impl JsImpl with call(self, key, args) -> Js {
  ffi_call(self.to_js(), key.to_key() |> unsafe_cast, args.map(_.to_js()))
}
```

**最適化案:**
- 引数が少ない場合（1-3個）は専用関数（call1, call2, call3）を使う
- 既に`Array[Js]`の場合は変換をスキップ

**期待効果:** 5要素配列で50%高速化（0.04µs → 0.02µs）

### 2. Object::keys()の使用を減らす

**問題点:**
- Object::keys()は比較的高コスト（0.07µs）
- React element creationでObject::assign前にkeysチェックを試みたが逆効果だった

**推奨:**
- keysチェックは避ける
- 必要な場合のみ使用する

### 3. from_mapの最適化は不要

**理由:**
- from_mapは既に合理的に最適化されている（0.10µs / 5エントリ = 0.02µs/エントリ）
- Object::setの呼び出しコストが支配的

### 4. call1/call2の活用を推奨

**推奨パターン:**
```moonbit
// Good: 専用メソッドを使用
obj.call1("method", arg)

// Avoid: 配列のmap overhead
obj.call("method", [arg])
```

**効果:** 引数が少ない場合、約2倍高速

## React要素作成での教訓の適用

前回のReact最適化で学んだこと：
1. ✅ **小さなアロケーションの削除が効果的**: drag_handlers配列の削除で5-11%改善
2. ✅ **条件分岐のコストが高い**: Object::keys().length()チェックは逆効果
3. ✅ **実測が重要**: 直感的な最適化が必ずしも有効とは限らない

今回のFFI分析との整合性：
- Object::keysは0.07µsと比較的高コスト → チェック追加は逆効果
- 小さな配列削除（7要素）の効果 > keys()チェックのコスト
- 実測で検証したことが正解

## 結論

mizchi/jsのFFIは非常によく最適化されています：
- 基本的な操作は0.01-0.02µs（極めて高速）
- `to_js()`は`unsafe_cast`と同等（コンパイラ最適化済み）
- 主なボトルネック：
  1. **配列のmap変換** (避けられる場合は専用メソッドを使用)
  2. **Object::keys()** (必要な場合のみ使用)
  3. **from_map()** (避けられないコストだが、合理的な範囲)

**推奨事項:**
1. 少数の引数を持つ関数呼び出しには`call1`/`call2`を使う
2. `Object::keys()`の呼び出しを最小限にする
3. 高頻度のObject生成パターンを最適化する（React element creationの例を参照）
4. 不要な配列アロケーションを避ける

**最適化の優先順位:**
- ✅ 高: 不要な配列アロケーションの削除
- ⚠️ 中: call/call1/call2の使い分け（コード量増加とのトレードオフ）
- ❌ 低: Object::keys()によるチェック追加（逆効果の可能性）
