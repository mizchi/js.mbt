# パッケージ分割ガイド (mizchi/js → multi-module)

このドキュメントは `mizchi/js` を `moon.work` で複数モジュールに分割していく計画と、利用側の移行手順をまとめたものです。現時点では **`mizchi/js_browser`**, **`mizchi/js_deno`**, **`mizchi/js_bun`**, **`mizchi/js_webextensions`**, **`mizchi/js_node`**, **`mizchi/js_web`**, **`mizchi/js_core`**, **`mizchi/js_builtin`** の 8 モジュールが独立しています。

`src/` の領域別モジュール化は完了しました。`mizchi/js` は `js_core` + `js_builtin` に依存する meta パッケージ (re-export facade) としてリポジトリ root に残り、`mbtconv` / `internal` / `wasm` / `examples` を抱えます。

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
├── moon.work                          # workspace 定義
├── moon.mod                           # mizchi/js (facade + mbtconv/internal/wasm/examples)
├── src/                               # mizchi/js のソース
└── modules/
    ├── js_browser/                    # mizchi/js_browser
    ├── js_builtin/                    # mizchi/js_builtin
    ├── js_deno/                       # mizchi/js_deno
    ├── js_bun/                        # mizchi/js_bun
    ├── js_core/                       # mizchi/js_core
    ├── js_node/                       # mizchi/js_node
    ├── js_web/                        # mizchi/js_web
    └── js_webextensions/              # mizchi/js_webextensions
```

`moon.work`:

```
members = [
  ".",
  "modules/js_browser",
  "modules/js_builtin",
  "modules/js_bun",
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
| `mizchi/js` (現在のルート)  | facade (`top.mbt`), `mbtconv`, `internal/*`, `examples`, `wasm` | 既存 |
| `mizchi/js_browser`         | `browser/*` (DOM, Canvas, ...), DOM 用 test_utils | **済** |
| `mizchi/js_deno`            | `deno/*` (`deno.mbt`, `permissions.mbt`, `_tests/`) | **済** |
| `mizchi/js_bun`             | `bun/*` (`bun.mbt`, `bun_test/`)      | **済** |
| `mizchi/js_webextensions`   | `webextensions/*` (chrome/runtime/tabs/storage) | **済** |
| `mizchi/js_node`            | `node/*` (fs, http, stream, ...)      | **済** |
| `mizchi/js_web`             | `web/*` (Blob, Streams, Fetch, Event, ...) | **済** |
| `mizchi/js_builtin`         | `builtins/*` (Object, Array, JSON, ...) | **済** |
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

## 利用側の移行手順 (built-ins)

`builtins/*` は `mizchi/js_builtin` に移動しました。**パッケージ名の末尾は変わらないので `@object` / `@array` / `@json` などの alias はそのまま**、import path だけ書き換えます。

```diff
 # moon.mod
 import {
+  "mizchi/js_builtin@0.12.x",
   "mizchi/js@0.12.x",
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
+  "mizchi/js_core@0.12.x",
   "mizchi/js@0.12.x",
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
# modules/js_core/src/moon.pkg
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
   "mizchi/js@0.12.x",
+  "mizchi/js_web@0.12.x",
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

`mizchi/js_node` / `mizchi/js_browser` / `mizchi/js_deno` を使っている場合、
それらが内部で `mizchi/js_web` に依存するため `moon.mod` への追加が必要です。

## 利用側の移行手順 (node API)

`node/*` は `mizchi/js_node` に移動しました。`moon.mod` の `import` に追加し、`moon.pkg` の import path を書き換えます。**package 名の末尾は変わらないので、`@fs` / `@path` などのソース中の alias は書き換え不要**です。

```diff
 # moon.mod
 import {
   "mizchi/js@0.12.x",
+  "mizchi/js_node@0.12.x",
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

`moon.mod.json`:

```json
{
  "deps": {
    "mizchi/js": "0.10.x",
+   "mizchi/js_browser": "0.10.x"
  }
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
| `mizchi/js/browser/file`            | `mizchi/js_browser/file`            |
| `mizchi/js/browser/history`         | `mizchi/js_browser/history`         |
| `mizchi/js/browser/indexeddb`       | `mizchi/js_browser/indexeddb`       |
| `mizchi/js/browser/location`        | `mizchi/js_browser/location`        |
| `mizchi/js/browser/navigation`      | `mizchi/js_browser/navigation`      |
| `mizchi/js/browser/navigator`       | `mizchi/js_browser/navigator`       |
| `mizchi/js/browser/observer`        | `mizchi/js_browser/observer`        |
| `mizchi/js/browser/serviceworker`   | `mizchi/js_browser/serviceworker`   |
| `mizchi/js/browser/storage`         | `mizchi/js_browser/storage`         |

`.mbt` ソース内の `@dom.` 等のエイリアスは変更不要です(import path だけ書き換えればそのまま動きます)。

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
| `target/js/release/build/mbtconv/_interop_test/_interop_test.js` | `target/js/release/build/mizchi/js/mbtconv/_interop_test/_interop_test.js` |
| `target/wasm-gc/release/build/wasm/wasm.wasm`                  | `target/wasm-gc/release/build/mizchi/js/wasm/wasm.wasm`               |

本リポジトリ内では `deno.jsonc`, `.justfile`, `.github/workflows/*.yaml`, `src/wasm/test_deno.ts`, `src/wasm/test_happydom.ts`, `scripts/check_sizes.ts` 等を新パスへ更新済みです。

## 開発者向け: 新モジュールを追加する手順

`mizchi/js_web` 以降を切り出すときの手順:

0. **先に逆向きのクロス依存を消す。** 切り出す対象 `X` に対して `mizchi/js` 側から
   `X` への import が 1 つでも残っているとモジュール循環になり `moon check` が通りません
   (`for "test"` の import も同じ)。`moon.pkg` を grep して洗い出します:

   ```bash
   grep -rn '"mizchi/js/<X>' $(find src -name moon.pkg) | grep -v "^src/<X>/"
   ```

1. `modules/<name>/` を作成し、`moon.mod` を置く

   ```
   name = "mizchi/<name>"

   version = "0.12.x"

   import {
     "mizchi/js@0.12.x",
   }

   source = "src"

   preferred_target = "js"
   ```

2. `moon.work` に member として追加

   ```
   members = [
     ".",
     "modules/js_browser",
     "modules/<name>",
   ]
   ```

3. 旧 `src/<env>/*` を `modules/<name>/src/*` へ `git mv`

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
  | `@js.Promise`     | `@core.Promise`          | `mizchi/js/core`                |
  | `@js.run_async`   | `@core.run_async`        | `mizchi/js/core`                |
  | `@js.from_fn1`    | `@core.from_fn1`         | `mizchi/js/core`                |
  | `@js.any`         | `@core.any`              | `mizchi/js/core`                |
  | `@js.log`         | `@core.log`              | `mizchi/js/core`                |
  | `@js.AbortSignal` | `@js_async.AbortSignal`  | `moonbitlang/async/js_async`    |
  | `@js.JsArray`     | `@array.JsArray`         | `mizchi/js/builtins/array`      |

  `.mbti` は型の**正規パッケージ**を記録しているため、この書き換えでは
  `.mbti` に差分が出ません (= 公開 API に影響しない純粋なリファクタ)。

  なお `js_browser` / `js_deno` / `js_webextensions` 側の facade import は
  下流モジュールからの参照なので循環せず、そのままで問題ありません。

### 残っている検討事項

- `mizchi/js` に残った `mbtconv` (MoonBit 値 ⇔ JS 値の変換) は `core` にのみ
  依存しているので、必要なら `mizchi/js_mbtconv` として独立させられます。
- `src/wasm` は wasm-gc ターゲットの動作確認用 entry です。`mizchi/js_wasm`
  として切り出すかは未定 (`docs/wasm-gc-usage.md` 参照)。
- `src/examples` はドキュメント用のチェック対象コードなので、そのままで
  問題ありません。

### 現在の依存階層

```
mizchi/js_core  <--  mizchi/js_builtin  <--  mizchi/js_web  <--  js_node
  (Any, Promise,       (Object, Array,         (fetch, URL,        js_browser
   Nullable, FFI)       JSON, RegExp, ...)      Streams, ...)      js_deno
      ^                      ^                      ^             js_bun
      |                      |                      |             js_webextensions
      +----------------------+----------------------+
                             |
                        mizchi/js  (facade: 両者を re-export)
                        + mbtconv / internal / wasm / examples
```

publish はこの依存順でなければならないため、`scripts/release.ts` が
`js_core` → `js_builtin` → `mizchi/js` → `js_web` → その他 の順に
対応済みです (各段階の間に `moon update`)。

`js_node -> js_web` (streams, event, url, webassembly) と
`js_browser -> js_web` (blob, event, http, message, worker) はこの階層に
沿っているので問題ありません。

## 参考

- [MoonBit moon.work ドキュメント (workspace)](https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html)
- 元の議論: PR #4
