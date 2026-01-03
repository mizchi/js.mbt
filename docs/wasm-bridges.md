# WASM Bridges

MoonBit WebAssembly (wasm-gc) ビルドで JavaScript と相互運用するためのブリッジ実装について。

## 概要

MoonBit は2つのビルドターゲットをサポート:

| ターゲット | extern 構文 | 文字列 | 用途 |
|------------|-------------|--------|------|
| `js` | `extern "js" fn ... = #\| ...` | ゼロコスト | ブラウザ/Node.js 直接実行 |
| `wasm-gc` | `extern "wasm" fn ... = "module" "function"` | js-string-builtins | WASM モジュールとして配布 |

## js ターゲット

```moonbit
///| JavaScript コードを直接埋め込み
pub extern "js" fn console_log(msg : Any) -> Unit =
  #| (msg) => console.log(msg)

///| プロパティアクセス
pub extern "js" fn Any::_get(self : Any, key : String) -> Any =
  #| (obj, key) => obj[key]
```

- `#|` 構文で JavaScript コードを直接記述
- ゼロオーバーヘッドで JavaScript を呼び出し
- `%identity` でゼロコスト型変換

## wasm-gc ターゲット

```moonbit
///| WASM imports を宣言（実装は JavaScript 側で提供）
extern "wasm" fn wasm_console_log(msg : ExternRef) -> Unit = "js" "console_log"

///| 公開 API
pub fn console_log(msg : ExternRef) -> Unit {
  wasm_console_log(msg)
}
```

- `"module" "function"` 形式で import を宣言
- 実装は JavaScript の import object で提供
- `ExternRef` (externref) で JavaScript オブジェクトを参照

### js-string-builtins

`moon.pkg.json` で有効化:

```json
{
  "link": {
    "wasm-gc": {
      "use-js-builtin-string": true
    }
  }
}
```

有効化すると:
- MoonBit の `String` が JavaScript の `string` として直接扱われる
- 文字列変換のオーバーヘッドがゼロに
- WASM モジュールサイズが大幅に削減

### Import Object の提供

JavaScript 側で対応する関数を提供:

```typescript
const imports = {
  js: {
    console_log: (msg) => console.log(msg),
    get_property: (obj, key) => obj[key],
    set_property: (obj, key, value) => { obj[key] = value },
    call0: (obj, name) => obj[name](),
    call1: (obj, name, a1) => obj[name](a1),
    // ...
  }
};

// V8 extension: js-string-builtins を有効化
const { instance } = await WebAssembly.instantiateStreaming(
  fetch("module.wasm"),
  imports,
  {
    builtins: ["js-string"],
    importedStringConstants: "_",
  }
);
```

## パッケージ構成例

```
src/mypackage/
├── moon.pkg.json        # targets 設定
├── types.mbt            # 共通の型定義
├── mypackage_js.mbt     # js ターゲット用実装
└── mypackage_wasm.mbt   # wasm-gc ターゲット用実装
```

```json
// moon.pkg.json
{
  "targets": {
    "mypackage_js.mbt": ["js"],
    "mypackage_wasm.mbt": ["wasm-gc"]
  },
  "link": {
    "wasm-gc": {
      "use-js-builtin-string": true
    }
  }
}
```

## 既存パッケージ

### xany (`src/xany/`)

汎用的な JavaScript 値操作:

```moonbit
// 共通インターフェース
#external
pub type Xany

// js ターゲット
pub extern "js" fn Xany::_get(self : Xany, key : String) -> Xany =
  #| (obj, key) => obj[key]

// wasm-gc ターゲット
extern "wasm" fn wasm_get(obj : Xany, key : String) -> Xany = "xany" "get"

pub fn Xany::_get(self : Xany, key : String) -> Xany {
  wasm_get(self, key)
}
```

### experiments/wasm_interop (`src/experiments/wasm_interop/`)

DOM 操作とグローバル API のラッパー:

```moonbit
// DOM 操作
pub fn create_element(tag : String) -> ExternRef {
  wasm_call1(document_ref(), "createElement", string_to_ref(tag))
}

pub fn set_text_content(el : ExternRef, text : String) -> Unit {
  set_property(el, "textContent", string_to_ref(text))
}

// グローバル API
pub fn console_log_str(msg : String) -> Unit {
  console_log(string_to_ref(msg))
}

pub fn math_random() -> Double {
  let math = get_property(global_this(), "Math")
  ref_to_double(wasm_call0(math, "random"))
}
```

## 制約と設計指針

### 固定アリティ関数

WASM の extern 関数では可変長引数が使えないため、固定アリティの関数群を定義:

```moonbit
extern "wasm" fn wasm_call0(obj : ExternRef, name : String) -> ExternRef
extern "wasm" fn wasm_call1(obj : ExternRef, name : String, a1 : ExternRef) -> ExternRef
extern "wasm" fn wasm_call2(obj : ExternRef, name : String, a1 : ExternRef, a2 : ExternRef) -> ExternRef
// ... call3, call4 など

// 配列ベースのディスパッチ
pub fn ExternRef::call(self : ExternRef, method : String, args : Array[ExternRef]) -> ExternRef {
  match args.length() {
    0 => wasm_call0(self, method)
    1 => wasm_call1(self, method, args[0])
    2 => wasm_call2(self, method, args[0], args[1])
    // ...
    _ => abort("too many arguments")
  }
}
```

### 型変換

プリミティブ型の変換関数:

```moonbit
// Int <-> ExternRef
extern "wasm" fn wasm_int_to_ref(v : Int) -> ExternRef = "js" "int_to_ref"
extern "wasm" fn wasm_ref_to_int(v : ExternRef) -> Int = "js" "ref_to_int"

// String <-> ExternRef (js-string-builtins で効率化)
extern "wasm" fn wasm_string_to_ref(v : String) -> ExternRef = "js" "string_to_ref"
extern "wasm" fn wasm_ref_to_string(v : ExternRef) -> String = "js" "ref_to_string"
```

### #external 型

JavaScript オブジェクトを表す opaque 型:

```moonbit
#external
pub type ExternRef

#external
pub type Xany
```

- `%identity` でゼロコスト変換可能
- 型安全性を保ちつつ JavaScript との境界を表現

## テスト

### Deno での実行

```bash
# ビルド
moon build --target wasm-gc src/experiments/wasm_interop

# テスト
deno run --allow-read --allow-net src/experiments/wasm_interop/run_test.ts
```

### ブラウザでの実行

```html
<script type="module">
import { createImports } from './inject.ts';

const imports = createImports();
const { instance } = await WebAssembly.instantiateStreaming(
  fetch("module.wasm"),
  imports,
  { builtins: ["js-string"], importedStringConstants: "_" }
);

instance.exports.run_all_tests();
</script>
```

## 参考リンク

- [MoonBit js-string-builtins](https://www.moonbitlang.com/blog/js-string-builtins)
- [WebAssembly JS String Builtins Proposal](https://github.com/aspect-build/aspect-workflows)
- `src/xany/` - 既存の xany パッケージ
- `src/experiments/wasm_interop/` - 実験的 DOM ラッパー
