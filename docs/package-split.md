# パッケージ分割ガイド (mizchi/js → multi-module)

このドキュメントは `mizchi/js` を `moon.work` で複数モジュールに分割していく計画と、利用側の移行手順をまとめたものです。現時点では **`mizchi/js_browser`**, **`mizchi/js_deno`**, **`mizchi/js_bun`**, **`mizchi/js_webextensions`**, **`mizchi/js_node`**, **`mizchi/js_web`**, **`mizchi/js_core`**, **`mizchi/js_builtin`**, **`mizchi/js_convert`** の 9 モジュールが独立しています。

`src/` の領域別モジュール化は完了しました。`mizchi/js` は `js_core` + `js_builtin` に依存する meta パッケージ (re-export facade) で、`top.mbt` と `wasm/` だけを抱えます (`internal` / `examples` は `dev/` = `mizchi/js_dev` に移動)。他のモジュールと同じく `modules/js/` に置いてあり、**リポジトリ root に `moon.mod` はありません**。

## 背景

これまで `mizchi/js` は一つのモジュールに次のすべてを内包していました:

- `core`, `builtins/*` — JS 言語コア
- `web/*` — Web 標準 API (Blob, Streams, Fetch, ...)
- `browser/*` — Browser 専用 (DOM, Canvas, ...)
- `node/*` — Node.js 専用 (fs, http, ...)
- `deno`, `bun`, `webextensions`, `wasm`

すべて同じモジュールに同居しているため:

- 環境別の依存関係が曖昧
- フロント向けのみ使いたい利用者にも node の API が降ってくる
- バージョン / 公開単位を環境ごとに切れない

`moon.work` (MoonBit のワークスペース機能) を使い、環境ごとに別モジュールへ切り出していきます。

## 現在のワークスペース構成

```
/
├── moon.work                          # workspace 定義 (root に moon.mod は無い)
├── dev/                               # mizchi/js_dev (never published)
└── modules/
    ├── js/                            # mizchi/js (facade + wasm)
    ├── js_browser/                    # mizchi/js_browser
    ├── js_builtin/                    # mizchi/js_builtin
    ├── js_bun/                        # mizchi/js_bun
    ├── js_convert/                    # mizchi/js_convert
    ├── js_core/                       # mizchi/js_core
    ├── js_deno/                       # mizchi/js_deno
    ├── js_node/                       # mizchi/js_node
    ├── js_web/                        # mizchi/js_web
    └── js_webextensions/              # mizchi/js_webextensions
```

`moon.work`:

```
members = [
  "dev",
  "modules/js",
  "modules/js_browser",
  "modules/js_builtin",
  "modules/js_bun",
  "modules/js_convert",
  "modules/js_core",
  "modules/js_deno",
  "modules/js_node",
  "modules/js_web",
  "modules/js_webextensions",
]
```

ワークスペース内の `moon check` / `moon build` / `moon test` は全モジュールをまとめて処理します。

## 計画している分割

| 新モジュール                | 含めるもの                            | 状態 |
| --------------------------- | ------------------------------------- | ---- |
| `mizchi/js` (`modules/js`)  | facade (`top.mbt`), `wasm`            | 既存 |
| `mizchi/js_browser`         | `browser/*` (DOM, Canvas, ...), DOM 用 test_utils | **済** |
| `mizchi/js_deno`            | `deno/*` (`deno.mbt`, `permissions.mbt`, `_tests/`) | **済** |
| `mizchi/js_bun`             | `bun/*` (`bun.mbt`, `bun_test/`)      | **済** |
| `mizchi/js_webextensions`   | `webextensions/*` (chrome/runtime/tabs/storage) | **済** |
| `mizchi/js_node`            | `node/*` (fs, http, stream, ...)      | **済** |
| `mizchi/js_web`             | `web/*` (Blob, Streams, Fetch, Event, ...) | **済** |
| `mizchi/js_builtin`         | `builtins/*` (Object, Array, JSON, ...) | **済** |
| `mizchi/js_convert`         | `mbtconv` から改名 (MoonBit 値 ⇔ JS 値の変換) | **済** |
| `mizchi/js_core`            | `core` (Any, Promise, FFI 基盤)       | **済** |
| `mizchi/js_wasm` (検討中)   | `wasm` ターゲット用 entry             | 未着手 |

> ※ `mizchi/js_web` は `js_browser` / `js_deno` / `js_node` の依存先なので、mooncakes への publish 順序も `mizchi/js` → `mizchi/js_web` → その他、である必要があります (`scripts/release.ts` が対応済み)。

## 利用側の移行手順 (deno / bun / webextensions)

`mizchi/js_deno`, `mizchi/js_bun`, `mizchi/js_webextensions` を依存に追加し、import を書き換えます。**移動後の package 名が変わるので、デフォルトの alias も変わる点に注意**してください:

| 旧 alias        | 新 alias              | 復元するには                                |
| --------------- | --------------------- | ------------------------------------------- |
| `@deno`         | `@js_deno`            | `"mizchi/js_deno" @deno,`                   |
| `@bun`          | `@js_bun`             | `"mizchi/js_bun" @bun,`                     |
| `@webextensions`| `@js_webextensions`   | `"mizchi/js_webextensions" @webextensions,` |

`.mbt` ソースの本体側 (`@deno.read_file_sync(...)` 等) を一切書き換えたくない場合は、明示 alias を付与してください。書き換える場合は、`@deno.` → `@js_deno.` のように検索置換で済みます。

```diff
 # moon.pkg
 import {
   "mizchi/js/core",
-  "mizchi/js/deno",
+  "mizchi/js_deno" @deno,
 }
```

それぞれの内部依存(`webextensions/chrome` → `webextensions/storage` 等)は、本リポジトリ内で `mizchi/js_webextensions/storage` のように書き換え済みです。

## 利用側の移行手順 (convert, 旧 mbtconv)

`mbtconv` は **`mizchi/js_convert` に改名**して独立モジュールになりました。
`mbt` は MoonBit プロジェクト内では冗長で、`conv` の略も開いてあります。
`core` と同じく**モジュール名の末尾が変わるので default alias は `@js_convert`
です**。短い `@convert.` で使いたい場合は明示 alias を付けてください:

```diff
 # moon.mod
 import {
+  "mizchi/js_convert@0.13.x",
   "mizchi/js@0.13.x",
 }
```

```diff
 # moon.pkg
 import {
-  "mizchi/js/mbtconv",
+  "mizchi/js_convert" @convert,
 }
```

`.mbt` 側は `@mbtconv.` を `@convert.` に置換すれば済みます (関数名は不変):

```diff
-let obj = @mbtconv.from_map(m)
+let obj = @convert.from_map(m)
```

## 利用側の移行手順 (built-ins)

`builtins/*` は `mizchi/js_builtin` に移動しました。**パッケージ名の末尾は変わらないので `@object` / `@array` / `@json` などの alias はそのまま**、import path だけ書き換えます。

```diff
 # moon.mod
 import {
+  "mizchi/js_builtin@0.13.x",
   "mizchi/js@0.13.x",
 }
```

```diff
 # moon.pkg
 import {
-  "mizchi/js/builtins/object",
-  "mizchi/js/builtins/arraybuffer",
+  "mizchi/js_builtin/object",
+  "mizchi/js_builtin/arraybuffer",
 }
```

対象 20 パッケージ: `array`, `arraybuffer`, `atomics`, `bigint`, `collection`,
`date`, `disposable`, `error`, `function`, `global`, `iterator`, `json`,
`math`, `object`, `proxy`, `reflect`, `regexp`, `string`, `symbol`, `weak`。

## 利用側の移行手順 (core)

`core` は `mizchi/js_core` に移動しました。**モジュール名の末尾が `js_core` なのでデフォルト alias が `@js_core` に変わります**。`@core.` は 8500 箇所以上あるので、ソースを書き換えずに済む**明示 alias**を使ってください:

```diff
 # moon.mod
 import {
+  "mizchi/js_core@0.13.x",
   "mizchi/js@0.13.x",
 }
```

```diff
 # moon.pkg
 import {
-  "mizchi/js/core",
+  "mizchi/js_core" @core,
 }
```

これで `.mbt` ソース中の `@core.Any` / `@core.any(...)` などは一切書き換え不要です。

`mizchi/js_core` 自身の blackbox テスト (`*_test.mbt`) も同じ方法で alias を復元しています — 自パッケージを `for "test"` で明示 alias 付き import できます:

```
# modules/js_core/moon.pkg
import {
  "moonbitlang/async",
  "mizchi/js_core" @core,
} for "test"
```

## 利用側の移行手順 (Web 標準 API)

`web/*` は `mizchi/js_web` に移動しました。`@fetch` / `@url` / `@streams` などのソース中の alias は**そのまま**で、import path だけ書き換えます。

```diff
 # moon.mod
 import {
   "mizchi/js@0.13.x",
+  "mizchi/js_web@0.13.x",
 }
```

```diff
 # moon.pkg
 import {
   "mizchi/js/core",
-  "mizchi/js/web/http",
-  "mizchi/js/web/url",
+  "mizchi/js_web/http",
+  "mizchi/js_web/url",
 }
```

対象 15 パッケージ: `blob`, `console`, `crypto`, `encoding`, `event`, `http`,
`message`, `performance`, `streams`, `trusted_types`, `url`, `webassembly`,
`webgpu`, `websocket`, `worker`。

`mizchi/js_node` / `mizchi/js_browser` / `mizchi/js_deno` が内部で
`mizchi/js_web` に依存している分については、`moon.mod` への追加は**不要**です
(透過依存は自動で解決されます。`mizchi/js_browser` だけ宣言した状態で
`mizchi/js_browser/dom` が使えることを実測済み)。

追加が必要なのは、自分の `moon.pkg` が `mizchi/js_web/*` を**直接** import
する場合です。その場合は他のモジュールが引いていても宣言が必要で、無いと
build plan の計算に失敗します:

```
... but its containing module is not imported by <your module>,
    thus cannot be imported by its package
```

利用側から見た全体の手引きは [guide.md](guide.md) にあります。

## 利用側の移行手順 (node API)

`node/*` は `mizchi/js_node` に移動しました。`moon.mod` の `import` に追加し、`moon.pkg` の import path を書き換えます。**package 名の末尾は変わらないので、`@fs` / `@path` などのソース中の alias は書き換え不要**です。

```diff
 # moon.mod
 import {
   "mizchi/js@0.13.x",
+  "mizchi/js_node@0.13.x",
 }
```

```diff
 # moon.pkg
 import {
   "mizchi/js/core",
-  "mizchi/js/node/fs",
-  "mizchi/js/node/path",
+  "mizchi/js_node/fs",
+  "mizchi/js_node/path",
 }
```

対象は `mizchi/js/node/<name>` → `mizchi/js_node/<name>` の一括置換で済みます (`assert`, `assert_strict`, `async_hooks`, `buffer`, `child_process`, `dns`, `events`, `fs`, `fs_promises`, `http`, `http2`, `https`, `inspector`, `module`, `net`, `os`, `path`, `process`, `readline`, `readline_promises`, `sqlite`, `stream`, `stream_promises`, `test`, `tls`, `tty`, `url`, `util`, `v8`, `vm`, `wasi`, `worker_threads`, `zlib`)。ルートの `mizchi/js/node` 自体 (`timers` / `cjs` / `esm` の re-export) は `mizchi/js_node` になります。

### 破壊的変更: `WebSocket::send_buffer`

`web/websocket` が `node/buffer` に依存していたため、`WebSocket::send_buffer(@buffer.Buffer)` を `WebSocket::send_uint8array(@arraybuffer.Uint8Array)` に置き換えました。Node の `Buffer` は `Uint8Array` のサブクラスなのでそのまま渡せます:

```diff
- ws.send_buffer(buf)
+ ws.send_uint8array(buf.as_any().cast())
```

## 利用側の移行手順 (browser API)

### 1. 依存に `mizchi/js_browser` を追加

`moon.mod`:

```diff
 import {
   "mizchi/js_core@0.13.x",
+  "mizchi/js_browser@0.13.x",
 }
```

### 2. import を書き換え

```diff
 # moon.pkg
 import {
   "mizchi/js",
   "mizchi/js/core",
-  "mizchi/js/browser/dom",
+  "mizchi/js_browser/dom",
-  "mizchi/js/browser/canvas",
+  "mizchi/js_browser/canvas",
 }
```

対象パッケージ:

| 旧パス                              | 新パス                          |
| ----------------------------------- | ------------------------------- |
| `mizchi/js/browser/canvas`          | `mizchi/js_browser/canvas`          |
| `mizchi/js/browser/dom`             | `mizchi/js_browser/dom`             |
| `mizchi/js/browser/file`            | **`mizchi/js_web/file`**            |
| `mizchi/js/browser/history`         | `mizchi/js_browser/history`         |
| `mizchi/js/browser/indexeddb`       | `mizchi/js_browser/indexeddb`       |
| `mizchi/js/browser/location`        | `mizchi/js_browser/location`        |
| `mizchi/js/browser/navigation`      | `mizchi/js_browser/navigation`      |
| `mizchi/js/browser/navigator`       | `mizchi/js_browser/navigator`       |
| `mizchi/js/browser/observer`        | `mizchi/js_browser/observer`        |
| `mizchi/js/browser/serviceworker`   | `mizchi/js_browser/serviceworker`   |
| `mizchi/js/browser/storage`         | `mizchi/js_browser/storage`         |

`.mbt` ソース内の `@dom.` 等のエイリアスは変更不要です(import path だけ書き換えればそのまま動きます)。

`file` だけ移動先が `js_browser` ではなく `js_web` です。`File` は `Blob` の
派生で `blob` は元から `js_web` にあり、`File` / `FileReader` はどちらも
Deno / Bun / Node 20+ / Workers にある = `js_web` の線引きに乗るためです。
`@file.` のエイリアスは (最後のパスセグメントが同じなので) そのままです。

### 3. DOM テストヘルパ

`@test_utils.create_happy_window()` / `@test_utils.global_jsdom_register()` を使っていた場合は、import 元が `mizchi/js/internal/test_utils` から `mizchi/js_browser/test_utils` に変わります:

```diff
 import {
-  "mizchi/js/internal/test_utils",
+  "mizchi/js_browser/test_utils",
 } for "test"
```

`mizchi/js/internal/test_utils` には `timeout`/`retry`/`wait_for` などの環境非依存ヘルパだけが残ります。

### 4. ビルド出力パスの変更

`moon.work` 化で build artifact が **モジュール名で名前空間化** されます。スクリプトや CI が直接パスを参照している場合は更新が必要です:

| 旧パス                                                         | 新パス                                                                |
| -------------------------------------------------------------- | --------------------------------------------------------------------- |
| `target/js/release/build/deno/_tests/_tests.js`                | `target/js/release/build/mizchi/js_deno/_tests/_tests.js`             |
| `target/js/release/build/bun/bun_test/bun_test.js`             | `target/js/release/build/mizchi/js_bun/bun_test/bun_test.js`          |
| `target/js/release/build/mbtconv/_interop_test/_interop_test.js` | `target/js/release/build/mizchi/js_convert/_interop_test/_interop_test.js` |
| `target/wasm-gc/release/build/wasm/wasm.wasm`                  | `target/wasm-gc/release/build/mizchi/js/wasm/wasm.wasm`               |

本リポジトリ内では `deno.jsonc`, `.justfile`, `.github/workflows/*.yaml`, `modules/js/wasm/test_deno.ts`, `modules/js/wasm/test_happydom.ts`, `scripts/check_sizes.ts` 等を新パスへ更新済みです。

## 開発者向け: 新モジュールを追加する手順

`mizchi/js_web` 以降を切り出すときの手順:

0. **先に逆向きのクロス依存を消す。** 切り出す対象 `X` に対して `mizchi/js` 側から
   `X` への import が 1 つでも残っているとモジュール循環になり `moon check` が通りません
   (`for "test"` の import も同じ)。`moon.pkg` を grep して洗い出します:

   ```bash
   grep -rn '"mizchi/js/<X>' $(find src -name moon.pkg) | grep -v "^src/<X>/"
   ```

1. `modules/<name>/` を作成し、`moon.mod` を置く

   依存に書くのは**実体のあるモジュールだけ**です。`mizchi/js@0.13.x` は
   書きません (facade は葉なので、ワークスペース内から依存してはいけません)。
   必要なものだけ並べてください:

   ```
   name = "mizchi/<name>"

   version = "0.13.x"

   import {
     "mizchi/js_core@0.13.x",
     "mizchi/js_builtin@0.13.x",
     "mizchi/js_web@0.13.x",
   }

   preferred_target = "js"
   ```

   `source` は書きません。既定 (モジュール root) のままにして、パッケージを
   `modules/<name>/<pkg>/` に直接置きます。`source = "src"` にしても publish
   アーカイブの範囲は変わらないので (アーカイブはモジュールディレクトリ全体)、
   階層を一段増やす意味がありません。

   書いたあと、本当に全部使っているか確認すること。`moon check` は
   `moon.pkg` の未使用 import は `unused_package` で報告しますが、
   `moon.mod` の未使用 import は報告しません。

2. `moon.work` に member として追加

   ```
   members = [
     "dev",
     "modules/js",
     "modules/js_browser",
     "modules/<name>",
   ]
   ```

3. 旧 `src/<env>/*` を `modules/<name>/*` へ `git mv`

4. 全 `moon.pkg` 内の `mizchi/js/<env>/X` → `mizchi/<name>/X` を一括置換

5. **相対パスに依存したテストを直す。** member module のテストは
   **そのモジュールのディレクトリ**を CWD として実行されるため、リポジトリルート
   相対のパス (`package.json`, `fixtures/*.wasm` 等) は解決できなくなります。
   テスト内で一時ファイルを作るか、fixture を埋め込んで自己完結させます。

6. `moon info --target js` で `.mbti` を再生成、`moon fmt`、`moon check --deny-warn && moon test`

7. README / docs / CHANGELOG の path / package 名を追従

## クロス依存の解消メモ

### 解消済み

- `web/websocket` → `node/buffer` (impl) — `WebSocket::send_buffer` を
  `send_uint8array(@arraybuffer.Uint8Array)` に置き換え
- `web/webassembly` → `node/{fs,path,process,buffer}` (test only) —
  `fixtures/add.wasm` (71B) をテストに `Bytes` リテラルとして埋め込み
- `node/wasi` → `fixtures/hello-wasi.wasm` (test only) —
  同様に埋め込み。ファイルシステム経由での読み込みをやめた

- `web/*` 7 パッケージ (`blob`, `event`, `http`, `worker`, `webgpu`, `websocket`,
  `streams`) → ルートの `mizchi/js` facade (`@js.Promise`, `@js.from_fn1`,
  `@js.AbortSignal` 等) — 実体のあるパッケージを直接 import するよう書き換え:

  | 旧 (facade 経由)  | 新 (実体)                | 実体のパッケージ                |
  | ----------------- | ------------------------ | ------------------------------- |
  | `@js.Promise`     | `@core.Promise`          | `mizchi/js_core`                |
  | `@js.run_async`   | `@core.run_async`        | `mizchi/js_core`                |
  | `@js.from_fn1`    | `@core.from_fn1`         | `mizchi/js_core`                |
  | `@js.any`         | `@core.any`              | `mizchi/js_core`                |
  | `@js.log`         | `@core.log`              | `mizchi/js_core`                |
  | `@js.AbortSignal` | `@js_async.AbortSignal`  | `moonbitlang/async/js_async`    |
  | `@js.JsArray`     | `@array.JsArray`         | `mizchi/js_builtin/array`       |

  `.mbti` は型の**正規パッケージ**を記録しているため、この書き換えでは
  `.mbti` に差分が出ません (= 公開 API に影響しない純粋なリファクタ)。

- `js_browser` / `js_deno` / `js_webextensions` の 11 パッケージ →
  同じく `mizchi/js` facade。当初は「下流からの参照なので循環せず、そのままで
  問題ない」と判断していましたが、**循環しないことと依存として妥当なことは別**
  でした。実際に使われていたのは `Promise` `Nullable` `any` `run_async`
  `suspend` `from_fn0/1/2` の 8 シンボルだけで、全部 `js_core` の中身です。
  つまり 3 モジュールが、再エクスポート殻を経由して `js_core` に届くためだけに
  meta パッケージ全体 (とその `js_convert` 依存) を publish 時の manifest に
  抱えていました。87 箇所を `@core.` に書き換えて解消し、こちらも `.mbti`
  差分ゼロです。

  | モジュール          | パッケージ                                                                  |
  | ------------------- | --------------------------------------------------------------------------- |
  | `js_browser`        | `dom`, `canvas`, `file`, `indexeddb`, `navigation`, `observer`, `serviceworker` |
  | `js_deno`           | `_tests`                                                                    |
  | `js_webextensions`  | `runtime`, `tabs`, `storage`                                                |

- `js_web` / `js_node` / `js_bun` の `moon.mod` に残っていた
  `"mizchi/js@0.13.0"` — パッケージ側の import は既に無く、宣言だけが死んで
  いました。`moon check` は package レベルの未使用 import を `unused_package`
  で報告しますが、**`moon.mod` の未使用 import は報告しません**。依存を外す
  ときは `moon.pkg` を grep して確認すること。

### `mizchi/js` に残しているもの

`src/` の領域別モジュール化はこれで完了で、残る中身は意図的に `mizchi/js`
(`modules/js/`) に置いたままにしています:

- `top.mbt` — `js_core` + `js_builtin` を re-export する facade。
  `mizchi/js` をこの meta パッケージとして維持する方針で決着しました。
- `wasm/` — wasm-gc ターゲットの動作確認用 entry。`mizchi/js_wasm` として
  切り出さず、このままにする方針です (`docs/wasm-gc-usage.md` 参照)。

`src/internal` と `src/examples` は `mizchi/js_dev` (`dev/`) に移しました。
`moon.mod` に `exclude` / `files` がなく (`exclude` キーを書くと moon が build
plan の計算に失敗する)、`source = "src"` の下は**全部利用者に配布される**ため、
dev 専用のものを publish される木の中に置けないからです:

| 移動後                 | 移動元                             | 中身                              |
| ---------------------- | ---------------------------------- | --------------------------------- |
| `dev/bench`        | `mizchi/js` `src/internal/bench`   | `js_convert` のバンドルサイズ bench |
| `dev/examples`     | `mizchi/js` `src/examples`         | `.mbt.md` のドキュメント           |
| `dev/size/*`       | `mizchi/js_core` `src/_tests/size*` | バンドルサイズ計測 14 パッケージ   |

`src/internal/test_utils` は削除しました。分割前は `src/node` のテストが使って
いましたが、`js_node` 独立後は import 元がゼロで、機能は CLAUDE.md の
「Async Test Resource Management」(`defer`) に置き換わっています。

これにより `mizchi/js` の `moon.mod` から `js_convert` が外れました。唯一の
import 元が `src/internal/bench` だったため、看板パッケージの利用者全員が
ベンチのために `js_convert` を install していました。

`mizchi/js_dev` は `moon.work` のメンバーなので `moon check` / `moon test` の
対象ですが、`scripts/release.ts` の publish 対象リスト (ハードコード) には
入っていないので、ここに何を置いても release に漏れません。

### 配布アーカイブの制御 (`.moonignore`)

`moon package` を使うと**認証情報なしで実際の publish アーカイブを
`_build/publish/` に書き出せる**ので、何が配布されるか実測できます
(`moon publish --dry-run` は認証情報を要求します)。分かったことを並べると:

- `moon.mod` に `exclude` / `files` は**ない**。`exclude` キーを書くと moon が
  build plan の計算に失敗する。`source = "src"` はパッケージの置き場所を指す
  だけで、**アーカイブの範囲は制御しない**
- **`.moonignore` は効く**。しかも publish 専用で build には影響しないので、
  CI はテストハーネスをそのままコンパイルし続ける。各公開モジュールに1枚置き、
  `*_test.mbt` / `*_wbtest.mbt` と `_tests/` / `bun_test/` / `_interop_test/`
  を除外している
- **パターンはモジュールではなくワークスペース root 基準で解決される。**
  root の `.moonignore` に `modules/` のような兄弟を指すディレクトリパターンを
  書くと、配下の全モジュールのアーカイブが**空**になる。しかも
  `moon package` は成功したと表示する。だからこのファイルはテスト用の
  glob だけに留める
- 死んだ `targets:` エントリは許容される。`.moonignore` で消えたテスト
  ファイルが `moon.pkg` の `targets:` に残っていても、展開したアーカイブは
  clean に `moon check` を通る
- `.moonignore` は `moon.mod` の `import` を落とせない。dev 専用パッケージが
  依存を引いている場合は、モジュールの外に出すしかない (それがこの `dev/`)

削減量 (テストコード除外後):

| モジュール          | 前        | 後      | 削減 |
| ------------------- | --------- | ------- | ---- |
| `js_core`           | 146,654   | 61,475  | 58%  |
| `js_deno`           | 53,892    | 32,466  | 40%  |
| `js_builtin`        | 319,656   | 201,969 | 37%  |
| `js_convert`        | 88,154    | 61,392  | 30%  |
| `js_bun`            | 27,177    | 19,589  | 28%  |
| `js_node`           | 512,536   | 371,887 | 27%  |
| `js_web`            | 280,864   | 207,158 | 26%  |
| `js_browser`        | 1,072,776 | 971,196 | 9%   |
| `js_webextensions`  | 36,226    | 36,226  | 0%   |

`js_webextensions` はテストを持たないので変化なしです。

### `mizchi/js` を root から `modules/js/` へ移した理由

`moon package` はモジュールディレクトリ配下を丸ごと固めます。`mizchi/js` が
リポジトリ root のモジュールだった間、そのアーカイブは**リポジトリ全体**
(約 2.5MB / 537 ファイル) でした。`modules/js_browser/...` `modules/js_node/...`
`pnpm-lock.yaml` `deno.lock` `moon.work` `CHANGELOG.md` まで入っていました。

`.moonignore` では直せません。root に `modules/` を書くと上記のルールで
兄弟モジュールのアーカイブが空になるためです。そこで `mizchi/js` を
`modules/js/` に移し、**リポジトリ root からは `moon.mod` を無くしました**。
これでアーカイブが自分のディレクトリに限定されます。

モジュール名・パッケージパス (`mizchi/js`) は変わらないので、利用側から見て
破壊的変更ではありません。

### 現在の依存階層

インデントは「ぶら下がっている先のモジュールに依存する」を意味します:

```
mizchi/js_core                      Any, Promise, Nullable, raw FFI
  |
  +-- mizchi/js_builtin             Object, Array, JSON, RegExp, ...
  |     |
  |     +-- mizchi/js_web           fetch, URL, Streams, ...
  |     |     |
  |     |     +-- mizchi/js_node
  |     |     +-- mizchi/js_browser
  |     |     +-- mizchi/js_deno
  |     |
  |     +-- mizchi/js_bun
  |
  +-- mizchi/js_convert             Map/Json/Option/Result <-> Any
  |
  +-- mizchi/js_webextensions
  |
  +-- mizchi/js                     facade: js_core + js_builtin を re-export
                                    + internal / wasm / examples
```

**`mizchi/js` は葉です。ワークスペース内のどのモジュールもこれに依存しては
いけません。** 1 つの import で済ませたいユーザ向けの入口で、`src/top.mbt` は
`pub using` の再エクスポートしかありません。ここを経由すると、その
モジュールの publish manifest に facade と `js_convert` が丸ごと乗ります。

publish は上の依存順でなければならないため、`scripts/release.ts` が
`js_core` → `js_builtin` → `mizchi/js` → `js_web` → その他 の順に
対応済みです (各段階の間に `moon update`)。`mizchi/js` が葉になった今、
これを `js_web` より前に置く必要はもうありませんが、順序としては安全側なので
そのままにしています。

`js_node -> js_web` (streams, event, url, webassembly) と
`js_browser -> js_web` (blob, event, http, message, worker) はこの階層に
沿っているので問題ありません。

## 参考

- [MoonBit moon.work ドキュメント (workspace)](https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html)
- 元の議論: PR #4
