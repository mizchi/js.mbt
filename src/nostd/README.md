# nostd - Lightweight JS Interop

`@nostd` は `@js.JsImpl` trait のオーバーヘッドを削減するための軽量な JS インターロップパッケージです。

## 使い方

```moonbit
// Zero-cost type conversion
let js_val : @nostd.Any = @nostd.any(moonbit_value)
let back : MyType = js_val.cast()

// Property access
js_val["key"] = @nostd.any(value)
let prop = js_val["key"]

// Method call
let result = js_val._call("method", [@nostd.any(arg1), @nostd.any(arg2)])
```

## --nostd ビルドについて

現在、このパッケージは標準ライブラリの `Array` 型に依存しているため、`moon build --nostd` ではビルドできません。

将来的に `--nostd` でビルドできるようにするため、以下に必要な `Array` 型の実装をコメントとして残しています。
`--nostd` ビルドが必要な場合は、`nostd_for_nostd.mbt.txt` の内容を有効にしてください。

## 参考: --nostd 用の Array 実装

`nostd_for_nostd.mbt.txt` に、`--nostd` ビルドに必要な Array 型の最小実装を保存しています。
これは `~/.moon/lib/core/builtin/arraycore_js.mbt` をベースにした実装です。
