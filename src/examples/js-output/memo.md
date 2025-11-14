# FFI を解説する

Moonbit は素晴らしい言語ですが、ライブラリが不足しています。AltJS や新しい言語が流行るには、まずラッパーライブラリや型定義を増やすのが大事だと思っています。

この記事では、moonbit js backend への　FFIを書く過程を通じて、Moonbit を学びつつ、あわよくばライブラリが増えてほしい、そういう思いで書いています。

Moonbit 自体は js だけでなく native, wasm のコードを生成できますが、実運用するには Web/ブラウザ/サーバーサイドと応用領域の広い js へ適用するのが一番手っ取り早いと考えています。

その上で、将来的に pure moonbit に寄せていって、それをクロスプラットフォーム運用できるのが理想的ですね。

## Moonbit JS FFI 入門

何ができるかを把握するために、まずこの記事を読むことを推奨します。

https://www.moonbitlang.com/pearls/moonbit-jsffi

その上で、自分が react の moonbit　バインディングを記述する過程で学んだことをまとめつつ、実際に使ったテクニックをまとめます。

この記事とは若干インターフェースが違うところがありますが、基本的にはこのパッケージで実装してある内容になります。

https://github.com/mizchi/js.mbt

この記事の内容は将来的に適用できなくなる可能性も高いのですが、基本的な概念は、そのまま適用できるはずです。

## mizchi/js.mbt の先行実装との違い

Moonbit の JS FFI の実装は、実は複数あります。

- https://github.com/moonbit-community/jmop
- https://github.com/moonbit-community/jscore
- https://mooncakes.io/docs/rami3l/js-ffi

mizchi/js.mbt は「安全性は低くてもいいからJSの生のAPIが剥き出しなラッパーが欲しい」という動機で自作したものです。結局FFIなので安全性には限界があるという認識です。

いずれのライブラリでも `--target js` かつ後述する `%identity` でキャストするのは共通してるので、相互に変換可能です。とはいえ仕組みを理解しないと怖くて使えないので、Moonbit の言語仕様を説明するのを兼ねつつ、JSを呼び出す仕組みを解説します。

## Moonbit js backend 用のビルド設定

JSバックエンドのみを想定する場合、`moon.mod.json` に次の記述をしておくと楽です。

```json
{
  ...
  "preferred-target": "js"
}
```

これで `moon build` や `moon test` のデフォルト実行ランナーが `--target js` を省略できるようになります。(デフォルトは `--target wasm-gc`)

パッケージ構成次第ですが、 `moon build --target js` を実行すると`target/js/release/build/*.js` にコードが生成されます。

JSを生成する場合, moon.pkg.json にいずれかの設定が必要です。

```json
{
  "is-main": true
}
```

もしくは、

```json
{
  "link": {
    "js": {
      "exports": ["foo"]
    }
  }
}
```

`is-main` の時は `fn main {}` をエントリポイントとして実行する関数が生成され、`link` 指定の時は exports で指定したシンボルの関数をexportして生成します。

詳細は以下の記事で確認してください

https://docs.moonbitlang.com/en/latest/toolchain/moon/package.html

この時、TypeScript の `.d.ts` も生成されます。プリミティブな値/単純な struct ならそのまま　TypeScript で呼ぶことができます。(どれぐらい自動変換されるかは後述します。)

最小構成なら次のような感じになるはずです。

```
moon.mod.json
moon.pkg.json
lib.mbt
target/js/build/release/lib.js
target/js/build/release/lib.d.ts
target/js/build/release/moonbit.d.ts # moonbit binding
```

例えばこれをそのまま js ライブラリとして使いたい場合、エントリポイントから import するだけです。

```ts
// index.ts
export { foo } from "./target/js/build/release/lib.js"
```

moonbit パッケージとして公開するなら, mooncakes.io にユーザーを作成して、自分の名前空間に応じて moon.mod.json に `{"name": "username/pkg", "version": "x.y.z"}` を指定して　`moon publish` することで公開できます。

## 基本的なFFI

`extern "js"` で js backend の時のみ使える関数を定義します。これを含むライブラリは `--target js` の時しか実行できません。

(extern しつつマルチバックエンドなライブラリを設計する方法もありますが、複雑なのでこの記事では解説しません)

```rust

///|
extern "js" fn console_log(v : String) -> Unit =
  #|(v) => console.log(v)

fn main {
  console_log("hello")
}
```

これはイディオムとして覚えてください。

`#|` は改行できる複数行の文字リテラルで `= "(v) => console.log(v)"` と等価です。これは単に生成コードに直接埋め込まれます。

出力コード

```js
const mizchi$js$examples$js$45$output$$console_log = (v) => console.log(v);
(() => {
  mizchi$js$examples$js$45$output$$console_log("hello");
})();
```

名前空間がついて長くなっていますが、これは minify 可能な素朴なコードです。

Moonbit の String はそのままJSのStringとして生成されていることがわかります。(後で変換規則を説明します)

最初は都度生成する値を確認しながらコードを書いていきますが、慣れてくる頃には確認せずに生成コードがイメージできるようになってくるでしょう。

## `#external　type` と　`%identity` でキャストする

`#external` はFFIから受け取る参照を引き回す時の型で、JSの時は必須ではありませんが、 wasm-gc の場合は externref に変換されます。

https://developer.mozilla.org/ja/docs/WebAssembly/Guides/Understanding_the_text_format

`"%identity"` は Moonbit の特殊なビルトインです。

これを使って、任意のJSの値の型と、それをキャストする関数を用意します。

```rust

///|
#external
pub type JsValue

///|
pub fn[A, B] unsafe_cast(a : A) -> B = "%identity"

///|
fn main {
  let val : Int = 100
  let jsval : JsValue = unsafe_cast(val)
  let val2 : Int = jsval |> unsafe_cast
  let _ = val == val2
}
```

右辺の入力と左辺の型宣言で unsafe_cast の `A, B` が決まるので、任意のAをBに(不健全に)キャストする関数です。

このコードから生成されるコードです。

```js
(() => {
  const jsval = 100;
  const val2 = jsval;
  100 === val2;
})();
```

本当にこれだけで、省略していません。 unsafe_cast の `%identity` は生成コードから省かれ、値への副作用もありません。

これによって、`JsValue` は任意の値への抽象として使うことができます。
unsafe_cast の `%identity` は、静的には型チェックされないので、嘘の記述もできます。

つまりこれも型チェックが通ります。

```rust

///|
fn main {
  let val : Int = 100
  let jsval : JsValue = unsafe_cast(val)
  let val2 : String = jsval |> unsafe_cast
  let _ = val.to_string() == val2
}
```

なので、どのような値にキャストするかはFFIを書く人の自己責任です。まあ TypeScript の `null as any as number` と一緒みたいなもんですね。

FFI を書く人は、この `%identity` を使いこなす必要があります。

## 値の比較を実装する

Moonbit では `impl Eq for T with equal(self: T, other: T) -> Bool` を実装することで、`==` による値の比較が可能になります。

JsValue の参照を実装してみましょう。

```rust

///|
#external
pub type JsValue

///|
pub fn[A, B] unsafe_cast(a : A) -> B = "%identity"

///|
pub extern "js" fn new_object() -> JsValue =
  #| () => ({})

///|
extern "js" fn object_is(a : JsValue, b : JsValue) -> Bool =
  #|(a,b) => Object.is(a,b)

///|
pub impl Eq for JsValue with equal(self, other) -> Bool {
  object_is(self, other)
}

fn main {
  let obj1 = new_object()
  let obj2 = new_object()
  let _ = obj1 == obj2 // false
  let _ = obj1 == obj1 // true
}
```

生成コード

```js
const mizchi$js$examples$js$45$output$$object_is = (v,k) => Object.is(v, k);
const mizchi$js$examples$js$45$output$$new_object = () => ({});
function moonbitlang$core$builtin$$Eq$equal$0$(self, other) {
  return mizchi$js$examples$js$45$output$$object_is(self, other);
}
(() => {
  const obj1 = mizchi$js$examples$js$45$output$$new_object();
  const obj2 = mizchi$js$examples$js$45$output$$new_object();
  moonbitlang$core$builtin$$Eq$equal$0$(obj1, obj2);
  moonbitlang$core$builtin$$Eq$equal$0$(obj1, obj1);
})();
```

FFI から生成された obj1 と obj2 を Object.is を使って比較するコードになっています。

Moonbitにはプリミティブとして存在しない　`undefined` を生成するコードを追加してみましょう。

```rust

///|
pub extern "js" fn undefined() -> JsValue =
  #| () => undefined

///|
pub extern "js" fn null_() -> JsValue =
  #| () => null

///|
pub extern "js" fn JsValue::is_undefined(self : Self) -> Bool =
  #| (v) => v === undefined

///|
pub extern "js" fn JsValue::is_null(self : Self) -> Bool =
  #| (v) => v === null

///|
fn main {
  let v = undefined()
  let _ = v.is_undefined() // true
}
```

FFI は getter として実装することはできません。

## Show の　to_string を実装する

Moonbit 上で `println()`　や `inspect()` に渡すには、 Show trait を実装する必要があります。Moonbit の trait は Rust の trait と似せて設計されています。

`undefined` と `null` 以外の場合は `value.toString()` を渡すようにします。

```rust

///|
pub impl Show for JsValue with output(self, logger) {
  logger.write_string(self.to_string())
}

extern "js" fn ffi_to_string(v: JsValue) -> String =
  # (v) => v.toString()

///|
pub impl Show for JsValue with to_string(self) {
  if self.is_undefined() {
    "undefined"
  } else if self.is_null() {
    "null"
  } else {
    ffi_to_string(self)
  }
}
```

## Moonbit が生成する値を観察する

Moonbit => JS へのFFIの対応表は以下です。

```
String =>	string
Bool	=> boolean
Int, UInt, Float, Double =>	number
BigInt	=> bigint
Bytes	=> Uint8Array
Array[T] =>	Array<T>
Function =>	Function
```

これらの型は変換不要で、そのままJSに渡しても構いません。

実際に動かして観察してみましょう。`println()` は Moonbit の to_string を通して実行されるので、JSとしての値の詳細が調べ辛いのですが、console.log に直接渡すことで実際の値を表示することができます。

次のような関数を定義することで、FFI経由で console.log と同じ出力を得ることができます。

```rust
extern "js" fn ffi_console_log(v : Array[JsValue]) -> Unit =
  #|(obj) => console.log(...obj)

///|
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> unsafe_cast])
}
```

任意のTを unsafe_cast を通して、そのまま表示します。これでMoonbit内でどのようなインスタンスになってるかが確認できます。

```rust

///|
fn main {
  struct Point {
    x : Int
    y : Int
  }
  log("hello")
  log(1)
  log(3.14)
  log(true)
  let b1 : Bytes = b"abcd"
  log(b1)
  log(fn() {  })
  log([1, 2, 3])
  log(Point::{ x: 10, y: 20 })
  let mut maybe_value : Int? = Some(42)
  log(maybe_value)
  maybe_value = None
  log(maybe_value)
}
```

この出力

```
hello
1
3.14
true
Uint8Array(4) [ 97, 98, 99, 100 ]
[Function (anonymous)]
[ 1, 2, 3 ]
{ x: 10, y: 20 }
42
undefined
```

struct も対応しているのが偉いですね。

つまり、これらのプリミティブは JS と　Moonbit で等価に扱って良いことになります。

## 直接変換できないオブジェクト

これら以外のオブジェクト、例えば　enum, Map, Result, Json は　Moonbit 上の内部表現がそのまま露出します。

```rust
fn main {
  enum Color {
    Red = 0
    Green
    Blue
  }
  enum Color2 {
    RGB(r~ : Int, g~ : Int, b~ : Int)
    HSL(h~ : Int, s~ : Int, l~ : Int)
  }
  let result : Result[Int, String] = Ok(42)
  log(result)
  log(Color::Red)
  log(Color2::RGB(r=255, g=0, b=128))
  let show : &Show = "hello"
  log(show)
  let map = { "one": 1, "two": 2, "three": 3 }
  log(map)
  let json : Json = {
    "name": "Alice",
    "age": 30,
    "isStudent": false,
    "scores": [85, 90, 95],
    "address": { "street": "123 Main St", "city": "Wonderland" },
  }
  log(json)
}
```

このコードの出力

```js
Result$Ok$0$ { _0: 42 }
0
$36$mizchi$47$js$47$examples$47$js$45$output$46$42$main$46$Color2$RGB {
  _0: 255,
  _1: 0,
  _2: 128
}
{
  self: 'hello',
  method_0: [Function: moonbitlang$core$builtin$$Show$output$1$],
  method_1: [Function: moonbitlang$core$builtin$$Show$to_string$1$]
}
{
  entries: [
    {
      prev: -1,
      next: [Object],
      psl: 0,
      hash: -2070437188,
      key: 'one',
      value: 1
    },
    {
      prev: 3,
      next: undefined,
      psl: 1,
      hash: 1567499352,
      key: 'three',
      value: 3
    },
    undefined,
    {
      prev: 0,
      next: [Object],
      psl: 0,
      hash: -909868157,
      key: 'two',
      value: 2
    }
  ],
  size: 3,
  capacity: 4,
  capacity_mask: 3,
  grow_at: 3,
  head: {
    prev: -1,
    next: {
      prev: 0,
      next: [Object],
      psl: 0,
      hash: -909868157,
      key: 'two',
      value: 2
    },
    psl: 0,
    hash: -2070437188,
    key: 'one',
    value: 1
  },
  tail: 1
}
$64$moonbitlang$47$core$47$builtin$46$Json$Object {
  _0: {
    entries: [
      [Object],  undefined,
      [Object],  [Object],
      [Object],  undefined,
      undefined, [Object]
    ],
    size: 5,
    capacity: 8,
    capacity_mask: 7,
    grow_at: 6,
    head: {
      prev: -1,
      next: [Object],
      psl: 0,
      hash: 241819907,
      key: 'name',
      value: [$64$moonbitlang$47$core$47$builtin$46$Json$String]
    },
    tail: 2
  }
}
```

これらは FFI 経由では直接渡さないほうがいいでしょう。

- enum: const な enum の時のみ定数の出力となり、それ以外は Moonbit のオブジェクトとしてラップされています。
- パラメータ付き enum はキー名が保存されていません
- trait オブジェクトは `{self: value, method_0:..., method_1: ...}` のような形式になります。
- Map 型は Moonbit の内部で保持するオブジェクトになります。
- Json 型は Moonbit の Json 実装として内部表現です。


## JsValue に get, set, 関数呼び出しを実装する

呼び出す関数ごとに都度 `extern "js"` を書いてもいいですが、関数ごとに　extern で文字列リテラルを大量に書くことなってしまいます。またAPIが足りない時の脱出ハッチも用意したいですね。

とりあえずJSの値に対する基本的な操作、プロパティアクセス(`o[k]`)、プロパティーへの代入`o[k]=v`、関数呼び出し　`o[k](...args)` を定義します。

```rust

///|
#alias("_[_]")
pub extern "js" fn JsValue::get(self : Self, key : String) -> JsValue =
  #| (o,k) => o[k]

///|
#alias("_[_]=_")
pub extern "js" fn JsValue::set(
  self : Self,
  key : String,
  value : JsValue,
) -> Unit =
  #| (o,k,v) => o[k] = v

///|
pub extern "js" fn JsValue::call(self : Self, args : Array[JsValue]) -> JsValue =
  #| (v, a) => v(...a)

///|
pub extern "js" fn JsValue::call_method(
  self : Self,
  key : String,
  args : Array[JsValue],
) -> JsValue =
  #| (o, k, a) => o[k](...a)

///|
fn main {
  let p = new_object()
  p["x"] = 10 |> unsafe_cast
  p["y"] = 20 |> unsafe_cast
  log(p) // => { x: 10, y: 20 }
  log(p["y"]) // => 20
  log(p.call_method("hasOwnProperty", ["x" |> unsafe_cast])) // => true
}
```

アクセス、代入、プロパティ呼び出しが可能になりました。

これは対象が呼び出し可能なオブジェクトかの検証を全くしていません。厳密にやるなら `JsValue` だけでなく、`JsObject`, `JsFunction` のような external な型を別途用意してもいいのですが、ライブラリ内部用の実装かつ、脱出ハッチのAPIとしては十分と考えます。

あとはこれらの関数を使って JS の大体のオブジェクトを操作して、ライブラリや環境へのバインディングを実装していきます。

### 例: Math.sqrt を呼ぶ

globalThis から Math オブジェクトを参照して、その sqrt 関数を呼びます。

```rust

///|
pub extern "js" fn global_this() -> JsValue =
  #| () => globalThis

///|
fn main {
  let r = global_this().get("Math").call_method("sqrt", [16 |> unsafe_cast])
  log(r) // 4
}
```

### node　環境で fs.readFileSync() を呼ぶ例

`moon run --target js` は node.js 環境で動いているので `require()`　関数を呼ぶことで外部モジュールが手に入ります。(この時、node_modulesにnode_modulesに依存します)

```rust

///|
pub extern "js" fn require(name : String) -> JsValue =
  #| (name) => require(name)

///|
fn main {
  // 関数にキャストする
  let readFileSync : (String, String) -> String = require("node:fs").get(
      "readFileSync",
    )
    |> unsafe_cast
  let content = readFileSync("moon.mod.json", "utf-8")
  log(content)
}
```

これで基本的なMoonbit<=>JSバインディングが実装できます。

### trait で JsValue への変換を実装する

unsafe_cast　を多用してもいいですが、 JsValue にキャストする trait を作っておくと便利です。

```rust

///|
pub(open) trait ToJs {
  to_js(Self) -> JsValue
}

///|
/// String に to_js を実装する例
pub impl ToJs for String with to_js(self) -> Val {
  self |> unsafe_cast
}

///|
/// 自分で作った型に ToJs を実装する例
struct MyStruct {
  value : Int
}

///|
pub impl ToJs for MyStruct with to_js(self) {
  self.value |> unsafe_cast
}

///|
/// ToJs trait を実装した構造体を JsValue に変換するヘルパ関数
pub fn js(val: &ToJs) -> JsValue {
  val.to_js()
}
// let v = js("hello")
// let v2 = js(MyStruct::{value: 1})
```

https://github.com/mizchi/js.mbt/blob/main/src/trait.mbt

あとはこの　`to_js` を通して、先に実装した call_method を呼ぶようにすると、楽に実装できます。

querySelector へのバインディングを実装する例です。

```rust

///|
#external
pub type Element

///|
pub impl ToJs for Element with to_js(self) -> JsValue {
  self |> unsafe_cast
}

///|
pub fn Element::query_selector(self : Self, selector : String) -> Self? {
  self.to_js().call_method("querySelector", [selector |> unsafe_cast]) |> unsafe_cast
}
```

unsafe_cast だらけですが、これはもう仕方ないと割り切っています。
初期の TypeScript も any だらけでしたし、大事なのは最終的なライブラリの使用者から見て自然な型がついてること、そしてAPIが不足した時に詰まないように脱出ハッチがある、ということです。

どれぐらい厳密にキャストするかは、実装者のセンス次第です。後付けの jsonschema や　TypeScript も同じような問題はありますね。

## 一旦まとめ

- 簡単な型なら TypeScript の型定義付きでJSを生成できる
- `#external type MyType` で FFI の外側の値を表現できる
- get/set/関数呼び出し のような JSのプリミティブなFFIを定義しておくと、その組み合わせで任意のJS操作が実現できる
- 最後は気合いで `%identity` でキャストする(だけ)
- 一度正しくキャストしてしまえば Moonbit の綺麗な世界で操作できる

とはいえ、書いていると言語の機能不足を感じることがあります。以下は FFIの記述に対して、自分が今認識してる課題です。

- `extern "js" fn` に対してジェネリクスを使えない
- trait に型パラメータが使えない (Rust の impl where 相当がない)
- 可変長引数が表現できない
- TSから変換しようとすると Union 型がないので、enum でキャストし直す必要がある。
- FFIのレスポンスを struct にマッピングする時、FFIセーフなオブジェクトかどうかを制限するディレクティブがない(`#external struct` 的なものがない)
- プロパティ名に　`type`, `ref` のような予約語が衝突しがちで、そのためにキャストする手間が増える
- unsafe_cast は &Show のような trait化されたオブジェクト `{self: value, method_0: ...}`もそのまま通してしまう。(trait境界を設定できない)

----

## 発展編: 例外と非同期

例外と非同期に踏み込むと、まず Moonbit に慣れないと理解が難しくなります。仕様も安定していないので、覚悟を決めて挑みましょう。

js.mbt の mizchi/js/async に相当する部分です。

https://github.com/mizchi/js.mbt/tree/main/src/async

## 例外と非同期の仕様

まず、Moonbit の非同期の表現方法を抑えましょう。

https://docs.moonbitlang.com/en/latest/language/async-experimental.html

```rust

///|
/// `run_async` spawn a new coroutine and execute an async function in it
fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
/// `suspend` will suspend the execution of the current coroutine.
/// The suspension will be handled by a callback passed to `suspend`
async fn[T, E : Error] suspend(
  // `f` is a callback for handling suspension
  f : (
    // the first parameter of `f` is used to resume the execution of the coroutine normally
    (T) -> Unit,
    // the second parameter of `f` is used to cancel the execution of the current coroutine
    // by throwing an error at suspension point
    (E) -> Unit,
  ) -> Unit,
) -> T raise E = "%async.suspend"

///|
#external
type JSTimer

///|
extern "js" fn js_set_timeout(f : () -> Unit, duration~ : Int) -> JSTimer =
  #| (f, duration) => setTimeout(f, duration)

///|
async fn sleep(duration : Int) -> Unit raise {
  suspend(fn(resume_ok, _resume_err) {
    js_set_timeout(duration~, fn() { resume_ok(()) }) |> ignore
  })
}

fn main {
  run_async(() => {
    log("Start sleeping...")
    sleep(1000) catch {
      e => log("Sleep error: " + e.to_string())
    }
    log("Awake!")
  })
}
/// Start sleeping...
/// Awake!
```

`%async.suspend` と `%async.run` を特定の形でラップして呼び出す形式になっています。(例外導入時にここのインターフェースが変わって動かなくなったことがあるので、一応注意してください)

suspend は　JS の `new Promise((resolve, reject) => {...})` に似たインターフェースだと思うと、理解しやすいと思います。

出力コードのうち、非同期関連の部分を見てみます。

```js
const mizchi$js$examples$js$45$output$$js_set_timeout = (f, duration) => setTimeout(f, duration);

function mizchi$js$examples$js$45$output$$sleep(duration, _cont, _err_cont) {
  mizchi$js$examples$js$45$output$$js_set_timeout(() => {
    _cont(undefined);
  }, duration);
}
function mizchi$js$examples$js$45$output$$_init$42$46$42$cont$124$68(_param) {}
function mizchi$js$examples$js$45$output$$_init$42$46$42$async_driver$124$69(_state) {
  let _tmp = _state;
  while (true) {
    const _state$2 = _tmp;
    if (_state$2.$tag === 0) {
      const _State_0 = _state$2;
      const _cont = _State_0._1;
      _State_0._0;
      _cont(mizchi$js$examples$js$45$output$$log$3$("Awake!"));
      return;
    } else {
      const _$42$try$47$54 = _state$2;
      const _cont = _$42$try$47$54._1;
      const _try_err = _$42$try$47$54._0;
      _tmp = new $36$mizchi$47$js$47$examples$47$js$45$output$46$42$init$46$lambda$47$67$46$State$State_0(mizchi$js$examples$js$45$output$$log$3$(`Sleep error: ${moonbitlang$core$builtin$$Show$to_string$2$(_try_err)}`), _cont);
      continue;
    }
  }
}
(() => {
  mizchi$js$examples$js$45$output$$log$3$("Start sleeping...");
  mizchi$js$examples$js$45$output$$sleep(1000, (_cont_param) => {
    mizchi$js$examples$js$45$output$$_init$42$46$42$async_driver$124$69(new $36$mizchi$47$js$47$examples$47$js$45$output$46$42$init$46$lambda$47$67$46$State$State_0(_cont_param, mizchi$js$examples$js$45$output$$_init$42$46$42$cont$124$68));
  }, (_cont_param) => {
    mizchi$js$examples$js$45$output$$_init$42$46$42$async_driver$124$69(new $36$mizchi$47$js$47$examples$47$js$45$output$46$42$init$46$lambda$47$67$46$State$_try$47$54(_cont_param, mizchi$js$examples$js$45$output$$_init$42$46$42$cont$124$68));
  });
})();
```

async 属性をつけた sleep 関数を見ると、自分で宣言した引数以外に、 `_cont`, `_err_cont` が追加されています。これによって、コールバックによる継続渡しスタイルに変換されています。

これは、通常の Moonbit の try catch と async が、JSの try catch や Promise に対応しないことを意味します。

じゃあどうするといいでしょうか。以下の記事では、Moonbit側のコールバックでラップする方法が紹介されています。

https://www.moonbitlang.com/pearls/moonbit-jsffi

これを参考に実装していきます。

```rust
extern "js" fn Error_::wrap_ffi(
  op : () -> Value,
  on_ok : (Value) -> Unit,
  on_error : (Value) -> Unit,
) -> Unit =
  #| (op, on_ok, on_error) => { try { on_ok(op()); } catch (e) { on_error(e); } }
```


### 同期例外の実装

上記の記事を今まで書いてきた JsValue に適用します。

```rust

///|
suberror JsError JsValue

///|
pub fn JsValue::call_method_raise(
  self : JsValue,
  key : String,
  args : Array[JsValue],
) -> JsValue raise JsError {
  let mut res : Result[JsValue, JsValue] = Ok(undefined())
  let op = () => self.call_method(key, args)
  ffi_wrap_call(op, fn(v) { res = Ok(v) }, fn(e) { res = Err(e |> unsafe_cast) })
  match res {
    Ok(v) => v
    Err(e) => raise JsError(e)
  }
}
fn main {
  try undefined().call_method_raise("nonExistentMethod", []) |> ignore catch {
    JsError(e) => log("Caught JsError: " + e.to_string())
  }
}
// Caught JsError: TypeError: Cannot read properties of undefined (reading 'nonExistentMethod')
```

suberror はエラー型を宣言します。これは JsValue を引数にもち、ほとんどの場合は JS の Error インスタンスになるはずです。

main で　`undefined.nonExistentMethod()` を呼び出して、わざとJS側のTypeErrorを発生させています。`Caught JsError:`　が入っているので、Moonbit側の try catch で捕捉できていることがわかります。

全部のFFI関数で `call_method_raise` を使ってraise を伝搬させながら 記述するのは大変ですが、 ある程度の panic は許容しつつ、　`JSON.parse` のようなエラーを期待するコンテキストで部分的に使用するのが良いと思います。

## async の非同意例外

JsValue 型を拡張してもいいですが、今回は新しく `type Promise[T]` を追加します。

先の suspend 関数で　Promise　のコールバックをラップしていきます。
`Promise[T].unwrap()` すると `T raise JsError` となるように設計します。

(ここのコードは結構ややこしいです。最終的な main 関数をみて雰囲気を掴んでください)

```rust

///|
pub extern "js" fn ffi_promise_then(
  promise : Promise[JsValue],
  on_fulfilled : (JsValue) -> Unit,
  on_rejected? : (JsValue) -> Unit,
) -> Promise[JsValue] =
  #|(p, ok, err) => p.then(ok).catch(err)

///|
///Promise抽象
#external
pub type Promise[T]

///|
pub async fn[T] Promise::unwrap(self : Self[T]) -> T raise JsError {
  suspend((resume_ok, resume_err) => ffi_promise_then(
      self |> unsafe_cast,
      v => resume_ok(v |> unsafe_cast) |> ignore,
      on_rejected=e => resume_err(JsError(e |> unsafe_cast)) |> ignore,
    )
    |> ignore)
}

///|
/// テスト用の関数. 300ms 後に2倍の値を返す
extern "js" fn lazy_double(v : Int) -> Promise[Int] =
  #| (v) => new Promise((resolve) => setTimeout(() => resolve(v*2), 100))

///|
fn main {
  run_async(() => try {
    let v : Int = lazy_double(21).unwrap()
    assert_eq(v, 42)
  } catch {
    JsError(e) => log(e.to_string())
    _ => panic()
  })
}
```

https://github.com/moonbit-community/jmop を参考に実装しています。

### Moonbit の　async 関数を Promise 化する

JSに対してPromise化したコールバック関数を渡す必要がある時があります。
例えば React の useActionState は `useActionState(reducer: (state: S, a: Action) => Promise<S>, initial: S): [S, (action: A) => void]` で、これはそのまま async 関数を渡すのではなく、Promiseでラップしないといけません。

この時のために Moonbit の async 関数を JS の Promise 関数にラップするユーティリティ関数を用意します。

Moonbitは可変長引数がないので、3引数まで promisifyN 関数を定義しています。

```rust

///|
extern "js" fn ffi_promise_with_resolvers() -> JsValue =
  #| () => Promise.withResolvers()

///|
pub(all) struct Resolvers[T] {
  promise : Promise[T]
  resolve : (T) -> Unit
  reject : (Error) -> Unit
}

///|
pub fn[T] Promise::with_resolvers() -> Resolvers[T] {
  ffi_promise_with_resolvers() |> unsafe_cast
}

///|
pub fn[R] promisify0(f : async () -> R) -> () -> Promise[R] noraise {
  () => {
    let { promise, resolve, reject } = Promise::with_resolvers()
    run_async(() => try f() |> resolve catch {
      e => reject(e)
    })
    promise
  }
}

///|
pub fn[A, R] promisify1(f : async (A) -> R) -> (A) -> Promise[R] noraise {
  fn(a) {
    let { promise, resolve, reject } = Promise::with_resolvers()
    run_async(() => try f(a) |> resolve catch {
      e => reject(e)
    })
    promise
  }
}

///|
pub fn[A, B, R] promisify2(
  f : async (A, B) -> R,
) -> (A, B) -> Promise[R] noraise {
  (a, b) => {
    let { promise, resolve, reject } = Promise::with_resolvers()
    run_async(() => try f(a, b) |> resolve catch {
      e => reject(e)
    })
    promise
  }
}

///|
pub fn[A, B, C, R] promisify3(
  f : async (A, B, C) -> R,
) -> (A, B, C) -> Promise[R] noraise {
  (a, b, c) => {
    let { promise, resolve, reject } = Promise::with_resolvers()
    run_async(() => try f(a, b, c) |> resolve catch {
      e => reject(e)
    })
    promise
  }
}
```

本当はコールバックが raise/noraise を推論する `T raise?` を使いたかったのですが、コンパイラがクラッシュするパターンに遭遇したので、一旦 noraise としています。明示的に関数内部で try catch してください。
