docs/xplat-build.md

# MoonBit クロスターゲットビルド

MoonBitで複数ターゲット（JS, WASM, Native）に対応したライブラリを作成する方法。

## ファイル構成パターン

```
mylib/
├── mylib.mbt            # 共通インターフェース（全ターゲット共通）
├── mylib_js.mbt         # JS専用実装
├── mylib_wasm.mbt       # WASM専用実装 (wasm, wasm-gc)
├── mylib_native.mbt     # Native専用実装 (native, llvm)
├── mylib_native.c       # Native用Cスタブ（必要な場合）
└── moon.pkg.json        # ターゲット設定
```

## moon.pkg.json の設定

```json
{
    "import": [
        "moonbitlang/x/internal/ffi"
    ],
    "targets": {
        "mylib_wasm.mbt": ["wasm", "wasm-gc"],
        "mylib_js.mbt": ["js"],
        "mylib_native.mbt": ["native", "llvm"]
    },
    "native-stub": ["mylib_native.c"]
}
```

### 設定項目

| フィールド | 説明 |
|-----------|------|
| `targets` | ファイル名をキー、対象ターゲット配列を値とするマッピング |
| `native-stub` | Native/LLVMビルド時に使用するCスタブファイル |

### 利用可能なターゲット名

| ターゲット | 説明 |
|-----------|------|
| `js` | JavaScript |
| `wasm` | WebAssembly |
| `wasm-gc` | WebAssembly GC |
| `native` | ネイティブ |
| `llvm` | LLVM |

## アーキテクチャパターン

### 1. 共通ファイル (mylib.mbt)

公開APIを定義し、内部実装関数を呼び出す:

```moonbit

///|
pub(all) suberror MyError String derive(Show)

///|
pub fn do_something(input : String) -> String raise MyError {
  do_something_internal(input)  // ターゲット別に実装
}
```

### 2. ターゲット別実装

各ターゲットファイルで `*_internal` 関数を実装する。

## FFI実装例

### JS用 (mylib_js.mbt)

```moonbit

///|
extern "js" fn read_file_ffi(path : String) -> Int =
  #| function(path) {
  #|   var fs = require('fs');
  #|   try {
  #|     const content = fs.readFileSync(path);
  #|     globalThis.fileContent = content;
  #|     return 0;
  #|   } catch (error) {
  #|     globalThis.errorMessage = error.message;
  #|     return -1;
  #|   }
  #| }

///|
extern "js" fn get_file_content_ffi() -> Bytes =
  #| function() {
  #|   return globalThis.fileContent;
  #| }

///|
fn do_something_internal(input : String) -> String raise MyError {
  // JS固有の実装
}
```

### WASM用 (mylib_wasm.mbt)

```moonbit

///|
using @ffi {type XExternString}

///|
fn my_func_ffi(input : XExternString) -> Int = "__moonbit_mylib_unstable" "my_func"

///|
fn do_something_internal(input : String) -> String raise MyError {
  let res = my_func_ffi(@ffi.string_to_extern(input))
  guard res != -1 else { raise MyError("failed") }
  // ...
}
```

### Native用 (mylib_native.mbt)

```moonbit

///|
#external
priv type Handler

///|
#borrow(input)
extern "C" fn my_func_ffi(input : Bytes) -> Int = "mylib_my_func_ffi"

///|
fn do_something_internal(input : String) -> String raise MyError {
  let res = my_func_ffi(@ffi.mbt_string_to_utf8_bytes(input, true))
  guard res != -1 else { raise MyError("failed") }
  // ...
}
```

### Native Cスタブ (mylib_native.c)

```c
#include <stdio.h>

int mylib_my_func_ffi(const char* input) {
    // C実装
    return 0;
}
```

## ビルドコマンド

```bash
# 型チェック（全ターゲット）
moon check

# 特定ターゲット向けビルド
moon build --target js
moon build --target wasm
moon build --target wasm-gc
moon build --target native

# テスト
moon test --target js
moon test --target wasm-gc
```

## 参考

- [moonbitlang/x/fs](https://github.com/moonbitlang/x/tree/main/fs) - 公式のクロスターゲット実装例
