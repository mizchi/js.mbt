# パッケージ分割ガイド (mizchi/js → multi-module)

このドキュメントは `mizchi/js` を `moon.work` で複数モジュールに分割していく計画と、利用側の移行手順をまとめたものです。現時点では **`mizchi/js_browser`**, **`mizchi/js_deno`**, **`mizchi/js_bun`**, **`mizchi/js_webextensions`** の 4 モジュールが独立しています。

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
├── moon.mod.json                      # mizchi/js (core + builtins + web + node + ...)
├── src/                               # mizchi/js のソース
└── modules/
    ├── js_browser/                    # mizchi/js_browser
    ├── js_deno/                       # mizchi/js_deno
    ├── js_bun/                        # mizchi/js_bun
    └── js_webextensions/              # mizchi/js_webextensions
```

`moon.work`:

```
members = [
  ".",
  "modules/js_browser",
  "modules/js_bun",
  "modules/js_deno",
  "modules/js_webextensions",
]
```

ワークスペース内の `moon check` / `moon build` / `moon test` は全モジュールをまとめて処理します。

## 計画している分割

| 新モジュール                | 含めるもの                            | 状態 |
| --------------------------- | ------------------------------------- | ---- |
| `mizchi/js` (現在のルート)  | `core`, `builtins/*`, `web/*`, `node/*`, `mbtconv`, `examples`, `wasm` | 既存 |
| `mizchi/js_browser`         | `browser/*` (DOM, Canvas, ...), DOM 用 test_utils | **済** |
| `mizchi/js_deno`            | `deno/*` (`deno.mbt`, `permissions.mbt`, `_tests/`) | **済** |
| `mizchi/js_bun`             | `bun/*` (`bun.mbt`, `bun_test/`)      | **済** |
| `mizchi/js_webextensions`   | `webextensions/*` (chrome/runtime/tabs/storage) | **済** |
| `mizchi/js_node`            | `node/*` (fs, http, stream, ...)      | 未着手 |
| `mizchi/js_wasm` (検討中)   | `wasm` ターゲット用 entry             | 未着手 |

> ※ `web/*` (Blob/Streams/Fetch/Event/...) は環境非依存なので、当面 `mizchi/js` 側に残します。`web/websocket` → `node/buffer`、`web/webassembly` → `node/*` といったクロス依存は別 PR で解消してから `mizchi/js_web` として独立させる予定です。

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

`mizchi/js_node` 以降を切り出すときの手順:

1. `modules/<name>/` を作成し、`moon.mod.json` を置く

   ```json
   {
     "name": "mizchi/<name>",
     "version": "0.10.x",
     "deps": {
       "mizchi/js": "0.10.x"
     },
     "source": "src",
     "supported_targets": "js"
   }
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

5. 旧モジュールから新モジュールへ依存している箇所は循環しないか確認
   (e.g. `internal/test_utils` の DOM 部分は `mizchi/js_browser/test_utils` へ移動した)

6. `moon info` で `.mbti` を再生成、`moon check && moon test`

7. README / docs の path / package 名を追従

## クロス依存の解消メモ

現状残っている / 解消が必要なクロス依存:

- `web/websocket` → `node/buffer` (impl)
- `web/webassembly` → `node/{fs,path,process,buffer}` (test only)
- 多数の `web/*` / `webextensions/*` がルート `mizchi/js` を import (再エクスポート用)

`mizchi/js_web` を切り出す前に、これらは `ArrayBuffer/Uint8Array` 経由に書き換えたり、test 用パッケージを別出しするなどして整理します。

## 参考

- [MoonBit moon.work ドキュメント (workspace)](https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html)
- 元の議論: PR #4
