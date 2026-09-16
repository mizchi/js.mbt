# User Guide

`mizchi/js` is not one library. Since **0.13.0** it is nine MoonBit modules,
and you depend only on the ones your target actually has.

A Cloudflare Worker does not need `node:fs`. A CLI does not need the DOM.
Before 0.13.0 you got both either way.

- [Pick your modules](#pick-your-modules)
- [The module map](#the-module-map)
- [Installing](#installing)
- [Two rules about dependencies](#two-rules-about-dependencies)
- [Aliases](#aliases)
- [Constructors](#constructors)
- [The `mizchi/js` shortcut](#the-mizchijs-shortcut)
- [Recipes](#recipes)
- [Migrating from 0.12.x](#migrating-from-012x)

## Pick your modules

| I am building | Add these |
| ------------- | --------- |
| Anything at all | `mizchi/js_core` — `Any`, `Promise`, `Nullable`, the raw FFI |
| …and I touch JS built-ins (`Object`, `JSON`, `Date`, `RegExp`, …) | `+ mizchi/js_builtin` |
| A Worker / edge function (`fetch`, `Request`, `Response`, streams) | `+ mizchi/js_web` |
| A Node.js program (`fs`, `http`, `path`, `child_process`, …) | `+ mizchi/js_node` |
| A browser app (DOM, canvas, IndexedDB, `localStorage`, …) | `+ mizchi/js_browser` |
| A Deno program | `+ mizchi/js_deno` |
| A Bun program | `+ mizchi/js_bun` |
| A browser extension (`chrome.*` / `browser.*`) | `+ mizchi/js_webextensions` |
| Passing `Map` / `Json` / `Option` / `Result` across the FFI boundary | `+ mizchi/js_convert` |

You do not have to list the modules those pull in themselves — see
[Two rules about dependencies](#two-rules-about-dependencies).

## The module map

Indentation means "depends on the module it hangs off".

```
mizchi/js_core                    Any, Promise, Nullable, raw FFI
  |
  +-- mizchi/js_builtin           Object, Array, JSON, RegExp, Date, ...
  |     |
  |     +-- mizchi/js_web         fetch, URL, Streams, Blob, WebSocket, ...
  |     |     |
  |     |     +-- mizchi/js_node
  |     |     +-- mizchi/js_browser
  |     |     +-- mizchi/js_deno
  |     |
  |     +-- mizchi/js_bun
  |
  +-- mizchi/js_convert           MoonBit <-> JS value conversion
  |
  +-- mizchi/js_webextensions
  |
  +-- mizchi/js                   meta: re-exports js_core + js_builtin
```

| Module | Packages |
| ------ | -------- |
| `mizchi/js_core` | the module root — import it as `mizchi/js_core` |
| `mizchi/js_builtin` | `array` `arraybuffer` `atomics` `bigint` `collection` `date` `disposable` `error` `function` `global` `iterator` `json` `math` `object` `proxy` `reflect` `regexp` `string` `symbol` `weak` |
| `mizchi/js_web` | `blob` `console` `crypto` `encoding` `event` `file` `http` `message` `performance` `streams` `trusted_types` `url` `webassembly` `webgpu` `websocket` `worker` |
| `mizchi/js_node` | `assert` `assert_strict` `async_hooks` `buffer` `child_process` `dns` `events` `fs` `fs_promises` `http` `http2` `https` `inspector` `module` `net` `os` `path` `process` `readline` `readline_promises` `sqlite` `stream` `stream_promises` `test` `tls` `tty` `url` `util` `v8` `vm` `wasi` `worker_threads` `zlib` |
| `mizchi/js_browser` | `canvas` `dom` `history` `indexeddb` `location` `navigation` `navigator` `observer` `serviceworker` `storage` `test_utils` |
| `mizchi/js_deno` | the module root |
| `mizchi/js_bun` | the module root |
| `mizchi/js_webextensions` | `chrome` `runtime` `storage` `tabs` |
| `mizchi/js_convert` | the module root |
| `mizchi/js` | the module root (re-exports), plus `wasm` |

Every module also lives in this repo under `modules/<name>/`, with its own
README listing the APIs it binds.

## Installing

```bash
moon add mizchi/js_core
moon add mizchi/js_web      # only what you need
```

That writes into your **`moon.mod`**:

```
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_web@0.13.0",
}
```

Then import the packages you use in the relevant **`moon.pkg`**:

```
import {
  "mizchi/js_core" @core,
  "mizchi/js_web/http",
}
```

> `moon.mod` / `moon.pkg` are the current manifest names. If you are coming
> from an older setup with `moon.mod.json` / `moon.pkg.json`, those are gone.

## Two rules about dependencies

**1. Transitive modules resolve on their own.** `mizchi/js_browser` depends on
`js_web`, which depends on `js_builtin`, which depends on `js_core`. You do not
list any of those:

```
# moon.mod -- enough to use every mizchi/js_browser package
import {
  "mizchi/js_browser@0.13.0",
}
```

**2. Declare every module you import from directly.** The moment a `moon.pkg`
names a package, that package's module has to be in your `moon.mod` — even if
something else already pulls it in. So this fails:

```
# moon.mod
import { "mizchi/js_browser@0.13.0" }

# moon.pkg
import {
  "mizchi/js_browser/dom",
  "mizchi/js_web/http",   # <-- js_web is not declared
}
```

```
Error: Failed to calculate build plan
  ... but its containing module is not imported by <your module>,
      thus cannot be imported by its package
```

Add `"mizchi/js_web@0.13.0"` to `moon.mod` and it builds.

The rule runs the other way too: `moon check` reports an import you do not use
as `unused_package`, and `moon check --deny-warn` fails on it. List exactly
what the package touches — every snippet below does.

## Aliases

A package's default alias is its **last path segment**:

| Import | Alias |
| ------ | ----- |
| `"mizchi/js_web/http"` | `@http` |
| `"mizchi/js_builtin/json"` | `@json` |
| `"mizchi/js_browser/dom"` | `@dom` |
| `"mizchi/js_core"` | `@js_core` |
| `"mizchi/js_convert"` | `@js_convert` |

The two module-root packages are the awkward ones, because the last segment is
the whole module name. Give them an explicit alias:

```
import {
  "mizchi/js_core" @core,
  "mizchi/js_convert" @convert,
}
```

Now you write `@core.Any` and `@convert.from_map(...)`. Everything else keeps
the alias it always had — `@http`, `@json`, `@dom`, `@fs` — so only the import
path changes when you upgrade.

## Constructors

Constructing a value uses the **type's own name**, not `::new`:

```moonbit
///|
pub fn examples() -> @regexp.RegExp {
  let _ = @url.URL("https://example.com/a?b=1") catch { _ => panic() }
  let _ : @collection.JsMap[String, Int] = @collection.JsMap()
  @regexp.RegExp("^a+$", flags="i")
}
```

This is MoonBit's canonical constructor form — a function named
`Type::Type(..)`, which you then call as `Type(..)`. It works through a package
alias (`@url.URL(..)`), it works with generics (`@collection.JsMap()`), and the
type keeps working in type position (`let u : @url.URL = @url.URL(..)`).

The older `Type::new(..)` spelling still compiles, as a deprecated alias:

```diff
-let re = @regexp.RegExp::new("^a+$", flags="i")
+let re = @regexp.RegExp("^a+$", flags="i")
```

Two caveats worth knowing:

- `moon check --deny-warn` turns the deprecation warning into an error, so if
  you build with that flag you need to update at upgrade time rather than
  whenever you get round to it.
- **`@object.Object::new()` is the one that keeps `::new`.** A `Type::Type`
  constructor has to return the type itself, and this one returns `@core.Any`
  so you can use the result without a cast.

Secondary factories read as `from_*` rather than `new_*` —
`@http.Response::from_body_init(..)`, `@url.URLPattern::from_object(..)`,
`@streams.TransformStream::identity()`.

## The `mizchi/js` shortcut

If you want one import rather than two, `mizchi/js` re-exports all of
`js_core` and `js_builtin`:

```
# moon.mod
import { "mizchi/js@0.13.0" }

# moon.pkg
import { "mizchi/js" @js }
```

```moonbit
let v : @js.Any = @js.any(1)
let m : @js.JsMap[String, @js.Any] = @js.JsMap()
```

It is a facade and nothing else — 212 lines of `pub using` re-exports. Reach
for it when convenience beats precision. For a library you publish, prefer
depending on `js_core` / `js_builtin` directly so your own consumers are not
handed the whole surface.

`mizchi/js` also carries `wasm`, the wasm-gc target entry point (see
[wasm-gc-usage.md](wasm-gc-usage.md)).

## Recipes

### Cloudflare Worker / edge function

```
# moon.mod
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_web@0.13.0",
}
```

```
# moon.pkg
import {
  "mizchi/js_core" @core,
  "mizchi/js_web/http",
}
```

```moonbit
///|
pub fn handle(req : @http.Request) -> @http.Response {
  let _ : @core.Any = req.as_any()
  let headers = @core.from_entries([
    ("content-type", @core.identity("text/plain")),
  ])
  @http.Response(body="hello", status=200, headers~)
}
```

Binary bodies go through `Response::from_body_init`, which takes any `BodyInit`
(`ArrayBuffer`, a typed array, `Blob`, `ReadableStream`, `FormData`, …) rather
than a `String`.

### Node.js program

```
# moon.mod
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_node@0.13.0",
}
```

```
# moon.pkg
import {
  "mizchi/js_core" @core,
  "mizchi/js_node/fs",
  "mizchi/js_node/path",
}
```

`js_node` pulls in `js_web` and `js_builtin` for you — `streams`, `event`,
`url` and the built-ins are reachable once you declare those modules too, but
you only need to declare them if you import their packages yourself.

### Browser app

```
# moon.mod
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_browser@0.13.0",
}
```

```
# moon.pkg
import {
  "mizchi/js_core" @core,
  "mizchi/js_browser/dom",
}
```

```moonbit
///|
pub fn mount() -> Unit {
  let doc = @dom.window().document()
  let el = doc.createElement("div")
  el.as_node().setTextContent("hi")
  el.as_any()._set("title", @core.any("tooltip")) |> ignore
  doc.body().unwrap().as_element().append(el.as_node())
}
```

### Deno / Bun

```
# moon.mod
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_deno@0.13.0",   # or mizchi/js_bun
}
```

```
# moon.pkg
import {
  "mizchi/js_core" @core,
  "mizchi/js_deno" @deno,    # module root -- give it an alias
}
```

### Browser extension

```
# moon.mod
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_webextensions@0.13.0",
}
```

```
# moon.pkg
import {
  "mizchi/js_core" @core,
  "mizchi/js_webextensions/tabs",
  "mizchi/js_webextensions/storage",
}
```

## Migrating from 0.12.x

In 0.12.x everything was one module, so every import began `mizchi/js/`. The
package names at the end of the path are unchanged — only the prefix moves, and
only your manifests and import paths need editing, not your MoonBit code.

| 0.12.x | 0.13.0 |
| ------ | ------ |
| `mizchi/js/core` | `mizchi/js_core` |
| `mizchi/js/builtins/<pkg>` | `mizchi/js_builtin/<pkg>` |
| `mizchi/js/web/<pkg>` | `mizchi/js_web/<pkg>` |
| `mizchi/js/node/<pkg>` | `mizchi/js_node/<pkg>` |
| `mizchi/js/browser/<pkg>` | `mizchi/js_browser/<pkg>` |
| `mizchi/js/browser/file` | **`mizchi/js_web/file`** |
| `mizchi/js/deno` | `mizchi/js_deno` |
| `mizchi/js/bun` | `mizchi/js_bun` |
| `mizchi/js/webextensions/<pkg>` | `mizchi/js_webextensions/<pkg>` |
| `mizchi/js/mbtconv` | **`mizchi/js_convert`** |

Three of those need more than a prefix swap:

- **`file` moved to `js_web`,** not `js_browser`. `File` extends `Blob` and
  `blob` has always been in `js_web`; neither `File` nor `FileReader` is
  browser-only (Deno, Bun, Node 20+ and Workers all have them). The `@file`
  alias is unchanged.
- **`mbtconv` is now `js_convert`.** `@mbtconv.` becomes `@convert.` if you use
  the explicit alias; the function names are untouched:
  ```diff
  -let obj = @mbtconv.from_map(m)
  +let obj = @convert.from_map(m)
  ```
- **`core` and `mbtconv`/`convert` are module roots,** so their default alias
  becomes the module name (`@js_core`, `@js_convert`). Add an explicit alias to
  keep `@core.` / `@convert.` and leave your sources alone — see
  [Aliases](#aliases).

For the blow-by-blow, including why each split landed where it did, see
[package-split.md](package-split.md).

## Toolchain

Developed and CI-tested against:

```
moon 0.1.20260915
moonc v0.10.13
```

CI tracks the latest MoonBit release, so a recent toolchain is the supported
configuration. 0.13.0 uses `moonbitlang/async@0.20.5`.
