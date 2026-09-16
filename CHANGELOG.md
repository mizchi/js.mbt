# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed — constructors are now `Type(..)`, not `Type::new(..)`

MoonBit unified custom constructors on the `fn Type::Type(..)` form (removed
the old `fn new(..)` syntax in v0.10.0, extended `Type::Type` to every type in
v0.10.4), and `moonbitlang/core` has already moved — `StringBuilder::new` is
gone there, `StringBuilder::StringBuilder` is what remains. This release brings
the bindings in line.

**69 constructors** now have a canonical `Type::Type(..)` form, callable
without the type prefix — including through a package alias:

```diff
-let u = @url.URL::new("https://example.com")
+let u = @url.URL("https://example.com")

-let re = @regexp.RegExp::new("^a+$", flags="i")
+let re = @regexp.RegExp("^a+$", flags="i")

-let m : @collection.JsMap[String, Int] = @collection.JsMap::new()
+let m : @collection.JsMap[String, Int] = @collection.JsMap()
```

Nothing is removed. All **73** old `::new` spellings still work as
`#deprecated` aliases, collected in a `deprecated.mbt` per package, so 0.13.x
code keeps compiling — with a warning telling you the new spelling. Note that
`moon check --deny-warn` treats that warning as an error, so projects using
that flag need to migrate at upgrade time.

Three secondary factories were renamed to match, old names kept as deprecated
aliases:

| Old | New |
| --- | --- |
| `Response::new_with_body(..)` | `Response::from_body_init(..)` |
| `URLPattern::newFromObject(..)` | `URLPattern::from_object(..)` |
| `TransformStream::new_identity()` | `TransformStream::identity()` |

`Request::new_with_init(url, init)` folded into the constructor as an optional
argument — `Request(url, init~)` — and is deprecated.

Two things deliberately did **not** change:

- **`Object::new()` keeps its name.** A `Type::Type` constructor must return
  the constructed type itself (MoonBit error 4200), and this one returns
  `@core.Any` so its result is usable without a cast.
- **Package aliases are untouched.** `@url`, `@http`, `@regexp` and the rest
  work exactly as before; only the constructor spelling moves.

### Fixed — opaque handle types were erased at runtime

**`mizchi/js_web/webgpu` did not work at all, and part of
`mizchi/js_web/trusted_types` did not either.**

Both declared their opaque JS handles as zero-field structs
(`pub(all) struct GPUDevice {}`). MoonBit treats a zero-field struct as
zero-sized, so the value is erased when a function *returns* one — every such
function handed back `undefined`. That meant `gpu()`, `requestAdapter()`,
`createBuffer()`, `getCurrentTexture()`, `trusted_types()`,
`createPolicy()` and `createHTML()` all returned nothing usable.

It hid well because a cast in and straight back out within one function is
inlined and appears to work; only a real function boundary loses the value.
The package had no tests, so nothing caught it.

All 43 affected declarations across `webgpu`, `trusted_types` and two `dom`
event types (`ChangeEvent`, `ScrollEvent`, where the bug was latent) are now
`#external pub type`, which round-trips correctly. In the generated
interfaces this shows up as `pub(all) struct X {}` becoming
`#external pub type X`; the methods are unchanged, and constructing these
handles was never meaningful, so no working code changes.

### Added — WebGPU brought up to the current spec

All 35 `GPU*` interfaces are now bound, up from 25. New: `GPUCanvasContext`
(so you can actually render to a canvas), `GPUQuerySet`, `GPURenderBundle`,
`GPURenderBundleEncoder`, `GPUExternalTexture`, and the error hierarchy —
`GPUValidationError`, `GPUOutOfMemoryError`, `GPUInternalError`,
`GPUPipelineError`, `GPUUncapturedErrorEvent`.

- `GPUError::kind()` discriminates the concrete subtype in one FFI hop and
  reports `Unknown` rather than throwing where the classes are absent;
  `as_validation_error` / `as_out_of_memory_error` / `as_internal_error`
  narrow.
- `GPUDevice::set_onuncapturederror` — the practical way to see validation
  failures, since WebGPU reports them asynchronously.
- `GPUSupportedLimits` grew from 5 accessors to all 34 spec limits, plus
  `get(name)` for anything unnamed (such as the deprecated
  `maxInterStageShaderComponents`).
- `GPUAdapterInfo` gained `isFallbackAdapter` and the optional
  `subgroupMinSize` / `subgroupMaxSize`.
- `GPUShaderStage`, `GPUMapMode` and `GPUColorWrite` flags as
  `SHADER_STAGE_*`, `MAP_MODE_*`, `COLOR_WRITE_*` constants.
- Async pipeline creation (`createRenderPipelineAsync`,
  `createComputePipelineAsync`), indirect draws, occlusion queries,
  `resolveQuerySet`, `copyExternalImageToTexture`, `executeBundles` and debug
  markers on all three encoder types.
- `setBindGroup` on the render pass, compute pass and bundle encoders takes an
  optional `dynamic_offsets`.

`GPUBuffer::mapSync` is deliberately not bound — it is experimental,
worker-only and Chromium-only. `GPUAdapter::requestAdapterInfo` stays absent:
the spec removed it in favour of the synchronous `info` property.

The package went from **no tests to 35**, covering the flag values, descriptor
shapes, accessors and feature-detection paths against stand-in objects, since
`moon test` has no GPU. It also gained a README.

### Fixed

- Several module READMEs documented constructors that do not exist
  (`Headers::new`, `URLSearchParams::new`, `CustomEvent::new`,
  `MessageEvent::new`). Plain `.md` files are not compiled, so these went
  unnoticed; they are corrected against the generated `.mbti` interfaces.

## [0.13.0] - 2026-09-15

**This release splits the library into nine modules so you can depend on only
what your target has.** A Worker no longer drags in `node:fs`; a CLI no longer
drags in the DOM.

Start here: **[docs/guide.md](docs/guide.md)** — which modules to pick,
aliases, per-runtime recipes, and the full migration table.

### Migrating from 0.12.x

Every import used to begin `mizchi/js/`. The package name at the end of the
path is unchanged, so only your manifests and import paths need editing — not
your MoonBit code.

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

Three need more than a prefix swap:

- **`file` went to `js_web`, not `js_browser`** — `File` extends `Blob`, and
  neither it nor `FileReader` is browser-only.
- **`mbtconv` is now `js_convert`** — `@mbtconv.` becomes `@convert.`; the
  function names are untouched.
- **`core` and `convert` are module roots**, so their default alias is now the
  module name (`@js_core`, `@js_convert`). Add an explicit alias to keep your
  sources unchanged:
  ```
  # moon.pkg
  import {
    "mizchi/js_core" @core,
    "mizchi/js_convert" @convert,
  }
  ```

Prefer one import over precision? `mizchi/js` still re-exports all of
`js_core` + `js_builtin`.

The rest of this entry is the detail, including why each piece landed where it
did.

### Added

- **`Response::new_with_body` for non-`String` bodies** (`mizchi/js_web/http`,
  contributed by @useiichi in #6). `Response::new` types its body as `String`,
  which fits the common text case but makes binary bodies unrepresentable —
  bytes cannot ride a UTF-16 `String` — so serving an `ArrayBuffer` (an image
  proxied through a Worker, say) meant dropping the whole handler into raw
  `extern "js"`. The new constructor takes `body? : @core.Any` and so accepts
  any `BodyInit`: `ArrayBuffer`, a `TypedArray`, `Blob`, `ReadableStream`,
  `FormData`, `URLSearchParams`. This mirrors `RequestInit`, whose `body` was
  already `@core.Any`. `Response::new` is behaviorally unchanged; the eight-arm
  option dispatch both constructors share moved into `new_dispatch`.

- **`ShadowRoot::getElementById`** (`mizchi/js_browser/dom`, contributed by
  @useiichi in #7). Returns `Element?`, with the `get_element_by_id` alias.
  Elements inside a shadow tree are invisible to `Document::getElementById`, so
  Web-Component and island code had no typed lookup; `ShadowRoot` bound
  `activeElement` and `elementFromPoint` but not the everyday one.

- **`HTMLInputElement::files`** (`mizchi/js_browser/dom`, contributed by
  @useiichi in #7). Returns `Array[@file.File]`, empty when nothing is selected
  and when `files` is `null` on a non-file input. `@file.File` and `FileReader`
  were already bound, but there was no typed road to the selection itself. The
  `dom` package now imports the `file` package; the two do not form a cycle,
  since `file` imports only `js_core`, `js_web/blob` and
  `js_builtin/arraybuffer`. (`file` itself moved to `mizchi/js_web` later in
  this release — see below.)

### Fixed

- **`check-env` CI could not run the Deno tests.** `deno.jsonc` was pointed at
  the *debug* build (`_build/js/debug/build/mizchi/js_deno/_tests/_tests.js`)
  while the workflow only ran `moon build --target js --release`, so
  `deno test -A` failed on a missing module. Deno-side tests are now driven by
  tasks that build the profile they need, and `check-env` calls them:

  ```
  deno task test:deno      # mizchi/js_deno integration bundle (debug build)
  deno task test:convert   # mizchi/js_convert TS tests (release build)
  deno task test:all       # both
  ```

  This also wires up the `js_convert` TypeScript tests (`interop.test.ts` +
  `types.test.ts`, 38 tests), which were never picked up by `deno test -A`
  because they are not in `test.include` — and could not be added to it,
  since `interop.test.ts` needs the release build while the configured
  include targets the debug build.

  `just test-deno` / `just test-convert` and the `Testing` section of
  `CLAUDE.md` now point at the tasks too.

### Changed

- **`source = "src"` dropped from every module; packages now sit at the module
  root.** `modules/js_web/src/http/` → `modules/js_web/http/`, and the same for
  all ten modules. Not a breaking change and not even a visible one: a
  package's path is relative to the source root either way, so every package
  is still `mizchi/js_web/http` and friends. `moon info` produces no `.mbti`
  content diff, only renames.

  `source` was buying an extra directory level for nothing. It does not scope
  the publish archive (the archive is the whole module directory — that is what
  forced the `mizchi/js` move below), so its only effect was the nesting.

  Follow-on edits: `readme` in each `moon.mod` (`src/README.md` → `README.md`),
  the 26 paths in `scripts/inheritance-config.ts`, `deno.jsonc`, `.justfile`,
  `package.json`, `.github/workflows/check.yaml`, and the README / docs links.
  `modules/js/wasm`'s `.ts` and `.html` helpers lost one `../` hop. Two
  already-broken relative links in `dev/examples/browser_examples.mbt.md` were
  repaired while passing through.

- **`mizchi/js` moved from the repo root to `modules/js/`.** Not a breaking
  change: the module name and every package path (`mizchi/js`) are unchanged,
  so consumers need no edits. What changes is what gets published.

  `moon package` archives the whole module directory, and no `source` setting
  scopes it — so while `mizchi/js` *was* the repo-root module, its
  archive was the entire repository: **2,525,463 bytes across 537 files**,
  including every sibling module's source, `pnpm-lock.yaml`, `deno.lock`,
  `moon.work`, `CHANGELOG.md` and the CI config. `.moonignore` could not fix
  it, because a `modules/` pattern in the repo-root file empties the siblings'
  archives instead (see the note above).

  Now: **94,580 bytes across 16 files** — `moon.mod`, `top.mbt`, `moon.pkg`,
  the two `.mbti` files, `README.mbt.md` and `wasm/*`. A 96% reduction, and
  nothing in it that isn't the module's own.

  The repo root no longer has a `moon.mod`; `moon.work` lists `modules/js`
  like any other member. `readme` now points at `README.mbt.md`, the
  module's own README, since the repo-root `README.md` no longer travels with
  it. `wasm`'s `.ts`/`.html` helpers had their `../` depth corrected, and the
  `moon build` / `deno run` invocations in `.github/workflows/check.yaml`,
  `.justfile` and `package.json` now say `modules/js/wasm`. The build
  output path is unchanged (`mizchi/js/wasm` derives from the module name, not
  the directory), and `moon info` produced only renamed `.mbti` files.

- **Test code no longer ships in the published packages.** Each published
  module gained a `.moonignore` excluding `*_test.mbt`, `*_wbtest.mbt` and the
  `_tests/` / `bun_test/` / `_interop_test/` harness packages. `.moonignore`
  applies to `moon publish` only — the build still compiles everything, so CI
  keeps running the harnesses from the repo.

  | module | before | after | |
  |---|---|---|---|
  | `js_core` | 146,654 B | 61,475 B | −58% |
  | `js_deno` | 53,892 B | 32,466 B | −40% |
  | `js_builtin` | 319,656 B | 201,969 B | −37% |
  | `js_convert` | 88,154 B | 61,392 B | −30% |
  | `js_bun` | 27,177 B | 19,589 B | −28% |
  | `js_node` | 512,536 B | 371,887 B | −27% |
  | `js_web` | 280,864 B | 207,158 B | −26% |
  | `js_browser` | 1,072,776 B | 971,196 B | −9% |
  | `js_webextensions` | 36,226 B | 36,226 B | no tests |

  Measured with `moon package`, which writes the real publish archive to
  `_build/publish/` and needs no credentials. Over half of `js_core`'s archive
  had been its own test suite.

  Two traps worth recording. `.moonignore` patterns resolve against the
  **workspace root, not the module**, so a directory pattern naming a sibling
  (`modules/` in the repo-root file) produces an *empty* archive for every
  module under it while `moon package` still reports success — these files are
  kept to test globs only. And `.moonignore` cannot drop a `moon.mod` `import`,
  which is why dev-only packages that pull a dependency still have to live in
  `dev/` rather than merely being ignored.

  That second trap is what forced the `mizchi/js` move described above: no
  `.moonignore` could slim the repo-root module without emptying its siblings.

- **BREAKING: `file` moved from `mizchi/js_browser` to `mizchi/js_web`.**
  `mizchi/js_browser/file` → `mizchi/js_web/file`. The `@file` alias is
  unchanged (it is the last path segment either way), so only the import path
  moves:

  ```diff
   # moon.pkg
   import {
  -  "mizchi/js_browser/file",
  +  "mizchi/js_web/file",
   }
  ```

  `File` extends `Blob`, and `blob` has always lived in `js_web` — so the two
  halves of one spec family were split across modules, and a `js_web`-only
  consumer had to depend on `js_browser` to name a `File`. Neither `File` nor
  `FileReader` is browser-specific: both are present in Deno, Bun, Node 20+
  and Workers, which is exactly the WinterCG line `js_web` draws.

  `js_browser/dom` is the only in-repo importer and follows the move, so
  `HTMLInputElement::files` now returns `Array[@js_web/file.File]`. Nothing
  about the types themselves changed.

- **Dev-only packages moved out of the published modules, into `mizchi/js_dev`.**
  `moon.mod` has no `exclude` or `files` field — an `exclude` key makes `moon`
  fail to calculate the build plan — so everything under a published module's
  module ships to consumers, and benchmarks, bundle-size fixtures and the
  literate examples were all inside published trees. The new `dev/`
  workspace member holds them and is never published; `scripts/release.ts`
  publishes a hardcoded list that does not include it.

  | moved to | from | what |
  |---|---|---|
  | `dev/bench` | `mizchi/js` `src/internal/bench` | bundle-size bench |
  | `dev/examples` | `mizchi/js` `src/examples` | the `.mbt.md` docs |
  | `dev/size/*` | `mizchi/js_core` `src/_tests/size*` | 14 size fixtures |

  Two consequences worth calling out. `js_convert` leaves the root `moon.mod`:
  `src/internal/bench` was its only importer, so every consumer of the headline
  `mizchi/js` had been installing `js_convert` to satisfy a benchmark. And
  `mizchi/js` now publishes `top.mbt` plus `wasm/` and nothing else —
  previously the facade was about 5% of what shipped.

  `wasm/` stays in `mizchi/js` as previously decided, and
  `js_browser/src/test_utils` stays put: `dom`'s blackbox tests import it, and
  it is plausibly useful to consumers writing happy-dom tests.

- **Deleted the dead `src/internal/test_utils` package.** Zero importers
  anywhere. Before the split, `src/node`'s tests used its `timeout` / `retry`
  helpers; once `js_node` became its own module that import would have been a
  cycle, so those tests moved to the `defer` pattern and the package was left
  behind, shipping inside `mizchi/js` ever since. The 13 tests removed with it
  were all tests of those helpers themselves, so the suite goes 1410 → 1397
  with no loss of coverage of shipped code.

- **`mizchi/js` is now a leaf: no other module in the workspace depends on it.**
  Six published manifests shrink as a result. Nothing about the public API
  changes — `moon info` produces a zero-line `.mbti` diff across the whole
  workspace — but the dependency graph the documentation described was not the
  one the code had.

  - `js_browser` (7 packages), `js_deno` (1) and `js_webextensions` (3) reached
    `js_core` *through* the facade. The entire usage was eight symbols —
    `Promise`, `Nullable`, `any`, `run_async`, `suspend`, `from_fn0`/`1`/`2` —
    all of them `js_core`'s, and `top.mbt` is 212 lines of nothing but
    `pub using` re-exports. So three modules carried the whole meta package,
    and its `js_convert` dependency, to reach a module they already imported.
    87 call sites now say `@core.` and the facade import is gone.
  - `js_web`, `js_node` and `js_bun` declared `mizchi/js` in `moon.mod` with no
    package importing it — a dead declaration that survived the split because
    `moon check` reports package-level dead imports as `unused_package` but
    says nothing about a dead `import` in `moon.mod`.

  `scripts/release.ts` still publishes `mizchi/js` before `js_web` and the
  runtime modules. That ordering is no longer required, but it is the safe
  side, so it is left alone.

- **BREAKING: `mbtconv` split out and renamed to `mizchi/js_convert`.** The
  MoonBit ⇔ JavaScript value conversion helpers (`from_map`, `from_json`,
  `to_json`, `from_option_map`, the `Convertible` trait and the runtime type
  inspection used by the bench suite) are now their own module, depending only
  on `mizchi/js_core`.

  The name changed with the move. `mbt` is redundant inside a MoonBit project,
  and `conv` was an abbreviation for no reason; `convert` is the word this
  package's own README already used. It also lines up with the plain-noun
  pattern of its siblings — `js_core` → `@core`, `js_web` → `@web`,
  `js_convert` → `@convert`.

  Like `js_core`, the module's last path segment sets the default alias
  (`@js_convert`), so import it with an explicit alias for the short form:

  ```diff
   # moon.pkg
   import {
  -  "mizchi/js/mbtconv",
  +  "mizchi/js_convert" @convert,
   }
  ```

  In `.mbt` sources, `@mbtconv.` becomes `@convert.` — the function names are
  unchanged:

  ```diff
  -let obj = @mbtconv.from_map(m)
  +let obj = @convert.from_map(m)
  ```

  The `deno task` and `just` recipe follow: `test:convert` → `test:convert`,
  `just test-convert` → `just test-convert`.

- **BREAKING: `builtins/*` split out into `mizchi/js_builtin`.** All 20
  built-in object packages (`array`, `arraybuffer`, `atomics`, `bigint`,
  `collection`, `date`, `disposable`, `error`, `function`, `global`,
  `iterator`, `json`, `math`, `object`, `proxy`, `reflect`, `regexp`,
  `string`, `symbol`, `weak`) moved out of `mizchi/js`. Package names are
  unchanged, so `@object` / `@array` / `@json` aliases keep working:

  ```diff
   # moon.pkg
   import {
  -  "mizchi/js/builtins/object",
  +  "mizchi/js_builtin/object",
   }
  ```

  `mizchi/js` stays at the repo root as a meta package re-exporting
  `js_core` + `js_builtin` through `top.mbt`, and keeps `internal/*`,
  `wasm` and `examples`.

- **BREAKING: `core` split out into `mizchi/js_core`.** The FFI foundation
  (`Any`, `Promise`, `Nullable`, the target-specific interop layer) is now its
  own module, which every other module — including the root `mizchi/js` —
  depends on.

  The module's last path segment changes the default alias from `@core` to
  `@js_core`, and there are 8500+ `@core.` references in the wild, so import
  it with an **explicit alias** and no `.mbt` source needs touching:

  ```diff
   # moon.pkg
   import {
  -  "mizchi/js/core",
  +  "mizchi/js_core" @core,
   }
  ```

  Publish order now starts with `js_core` (before the root), handled by
  `scripts/release.ts`.

- **BREAKING: `web/*` split out into `mizchi/js_web`.** All 15 Web Standard
  packages (`blob`, `console`, `crypto`, `encoding`, `event`, `http`,
  `message`, `performance`, `streams`, `trusted_types`, `url`, `webassembly`,
  `webgpu`, `websocket`, `worker`) moved out of `mizchi/js`. Package names are
  unchanged, so `@http` / `@url` / `@streams` aliases in `.mbt` sources keep
  working:

  ```diff
   # moon.pkg
   import {
  -  "mizchi/js/web/http",
  +  "mizchi/js_web/http",
   }
  ```

  `mizchi/js_node`, `mizchi/js_browser` and `mizchi/js_deno` now depend on
  `mizchi/js_web`, so it has to be published before them; `scripts/release.ts`
  does that ordering.

- **`web/*` no longer imports the `mizchi/js` facade.** The seven packages
  that reached types through the root re-export (`blob`, `event`, `http`,
  `worker`, `webgpu`, `websocket`, `streams`) now import the package that
  actually defines them - `@core.Promise` instead of `@js.Promise`,
  `@js_async.AbortSignal` instead of `@js.AbortSignal`, and so on. This is a
  prerequisite for splitting `web/*` into `mizchi/js_web`, since a facade
  that re-exports `js_web` while `js_web` imports the facade is a cycle.
  No `.mbti` changed, so there is no effect on users.

- **BREAKING: `node/*` split out into `mizchi/js_node`.** First step of
  dissolving the monolithic `src/` into per-area modules (`js_core`,
  `js_builtin`, `js_web`, `js_node`), leaving `mizchi/js` as a thin
  re-export facade. See [`docs/package-split.md`](docs/package-split.md).

  Add the module to your `moon.mod` and rewrite import paths — package names
  are unchanged, so `@fs` / `@path` / `@process` aliases in `.mbt` sources
  keep working:

  ```diff
   # moon.pkg
   import {
  -  "mizchi/js/node/fs",
  +  "mizchi/js_node/fs",
   }
  ```

  All 34 node packages moved: `assert`, `assert_strict`, `async_hooks`,
  `buffer`, `child_process`, `dns`, `events`, `fs`, `fs_promises`, `http`,
  `http2`, `https`, `inspector`, `module`, `net`, `os`, `path`, `process`,
  `readline`, `readline_promises`, `sqlite`, `stream`, `stream_promises`,
  `test`, `tls`, `tty`, `url`, `util`, `v8`, `vm`, `wasi`, `worker_threads`,
  `zlib`, plus the root `mizchi/js/node` (`timers`/`cjs`/`esm` re-exports)
  which is now `mizchi/js_node`.

- **BREAKING: `WebSocket::send_buffer` → `WebSocket::send_uint8array`.**
  `web/websocket` depended on `node/buffer` purely for this one signature,
  which would have made `js_node` a circular dependency. A Node `Buffer` is a
  `Uint8Array`, so pass one with `buffer.as_any().cast()`.

- Made `web/webassembly` and `node/wasi` tests self-contained: the `add.wasm`
  (71B) and `hello-wasi.wasm` (169B) fixtures are now embedded as `Bytes`
  literals instead of read through `node/fs`, which removes the last
  `web → node` cross-dependency and the dependency on the process working
  directory. `fs` tests that read `package.json` now create their own temp
  files, since member-module tests run with the module directory as CWD.

- **Warning-free on the latest MoonBit toolchain.** Fixed all 108 deprecation
  warnings reported by `moonc` and dropped the blanket `warnings = "-20"`
  suppression from all five workspace `moon.mod` files, so
  `moon check --deny-warn` now passes without muting deprecations.

- **BREAKING (argument positions only): `extern "js"` array parameters are now
  `FixedArray[T]`.** `Array[T]` is deprecated in JavaScript FFI signatures
  because its runtime representation is an implementation detail. Affected
  public signatures:
  - `@core`: `Any::_call`, `Any::_invoke`, `new`, `new_instance`
  - `@math`: `Math::max`, `Math::min`, `Math::hypot`
  - `@function`: `Function::apply`; `@reflect`: `Reflect::apply`
  - `@dns`: `set_servers`; `@console`: `table`; `@websocket`: `WebSocket::new`
    (`protocols?`)
  - `@js_browser/dom`: `Element::before`/`after`/`prepend`/`replaceWith`/
    `replaceChildren` and the generated `HTML*Element`/`SVG*Element`
    delegations

  Array-literal call sites (`obj._call("f", [a, b])`, `Math::max([1.0, 2.0])`)
  compile unchanged and stay zero-cost. To pass a runtime-built array, use
  `FixedArray::from_array(arr[:])`.

  Return types are unchanged: `object_keys`, `object_values`, `array_from`,
  `from_entries`, `Reflect::ownKeys`, `Object::entries`, `RegExp::split`,
  `Promise::all`/`race`/`any`/`allSettled`, `readdirSync`, `cpus`, `loadavg`,
  `process.argv`, `getHeapSpaceStatistics`, `Bun::argv`, `tabs.remove` and
  `execFile` all still use `Array[T]`, converting internally with
  `Array::from_fixed_array`.

- Migrated `inspect` to `debug_inspect` for composed values (`Option`, arrays,
  `Json`) per the `Show` → `Debug` split, and updated the affected snapshots
  (`Debug` quotes strings: `Some(hello)` → `Some("hello")`).

- Replaced deprecated `try?` with `try ... catch ... noraise` (and postfix
  `catch` where the outcome is intentionally ignored).

- Replaced `Array::new(capacity=)` with `Array(capacity=)`,
  `@immut/hashmap.from_array` with `@immut/hashmap.HashMap([...])`,
  `not(x)` with `!x`, and the implicitly promoted `SimpleStruct::from_js` /
  `Show::to_string` calls with explicit trait-qualified calls.

- Reformatted with the current `moon fmt` (trailing commas in single-line
  struct literals) and regenerated all `.mbti` interfaces.

- Minor version bump to 0.13.0 across all workspace modules. The workspace is
  now nine modules — `mizchi/js` (meta) plus `mizchi/js_core`,
  `mizchi/js_builtin`, `mizchi/js_convert`, `mizchi/js_web`, `mizchi/js_node`,
  `mizchi/js_browser`, `mizchi/js_deno`, `mizchi/js_bun` and
  `mizchi/js_webextensions`. They must be published in dependency order;
  `scripts/release.ts` does that.

## [0.12.1] - 2026-05-26

### Changed

- Reworked `README.md` to make the `mizchi/js_*` package split explicit:
  added a "Package Layout" table summarising `mizchi/js`, `mizchi/js_browser`,
  `mizchi/js_deno`, `mizchi/js_bun`, `mizchi/js_webextensions`,
  `mizchi/npm_typed`, and `mizchi/cloudflare.mbt`; removed the stale
  "future plans" note; and clarified the Runtime-Specific APIs / Project
  Status / Goals sections so each runtime points at its own module.
- Patch version bump across all workspace modules (mizchi/js,
  mizchi/js_browser, mizchi/js_deno, mizchi/js_bun, mizchi/js_webextensions).

## [0.12.0] - 2026-05-26

### Changed

- Minor version bump.

## [0.11.0] - 2026-05-26

### Changed

- **Workspace split**: Introduced `moon.work` and split environment-specific
  bindings into separate modules under `modules/`. See
  [`docs/package-split.md`](docs/package-split.md) for migration instructions
  and the planned multi-module layout.

  Modules extracted in this release:
  - `mizchi/js_browser` (was `mizchi/js/browser/*`)
  - `mizchi/js_deno` (was `mizchi/js/deno`)
  - `mizchi/js_bun` (was `mizchi/js/bun`)
  - `mizchi/js_webextensions` (was `mizchi/js/webextensions/*`)

- **`internal/test_utils`**: DOM-dependent helpers (`create_happy_window`,
  `global_jsdom_register`) moved to the new `mizchi/js_browser/test_utils`
  package. `mizchi/js/internal/test_utils` retains only the generic
  timeout/retry helpers.
- Build outputs under `_build/<target>/<profile>/build/` now nest under
  `<module>/...` (e.g. `_build/js/release/build/mizchi/js_deno/...`). Scripts
  and configs referencing build artifacts (`deno.jsonc`, `.justfile`,
  `.github/workflows/*.yaml`, `src/wasm/test_*.ts`, `scripts/check_sizes.ts`,
  ...) have been updated.
- Refreshed `inspect` snapshots affected by the latest `moonc`, which renders
  strings unquoted inside `Show` output (`Some(hello)` rather than
  `Some("hello")`).

### Migration

- `import { "mizchi/js/browser/dom" }` → `import { "mizchi/js_browser/dom" }`
  (same for `canvas`, `file`, `history`, `indexeddb`, `location`, `navigation`,
  `navigator`, `observer`, `serviceworker`, `storage`).
- `import { "mizchi/js/deno" }` → `import { "mizchi/js_deno" @deno }`
  (explicit alias keeps `@deno.` references working).
- `import { "mizchi/js/bun" }` → `import { "mizchi/js_bun" @bun }`.
- `import { "mizchi/js/webextensions" }` → `import { "mizchi/js_webextensions" @webextensions }`;
  sub-packages like `webextensions/chrome` are now `mizchi/js_webextensions/chrome`.
- Downstream modules need to add the matching new module(s) to their
  `moon.mod.json` `deps`.

## [0.10.17] - 2026-04-23

### Changed

- Updated npm and MoonBit dependencies, including `moonbitlang/async` 0.18.0
- Eliminated source warnings and aligned generated/test tooling with current MoonBit behavior
- Split shared core interop helpers into `core_interop.mbt`
- Fixed Bun sync test wrapping and wasm-gc test artifact resolution

## [0.10.16] - 2026-04-09

### Changed

- Replaced legacy `supported-targets` manifests with `supported_targets`
- Added explicit `supported_targets = "js"` to JS-only packages missing target declarations

## [0.10.6] - 2025-12-22

### Added

- **mbtconv**: Added mbti to TypeScript .d.ts converter prototype
  - Snapshot tests for TypeScript generation

### Changed

- **ESM Migration**: Replace `require` with `#module` for ESM compatibility
  - `fs` module now uses `#module` directive
  - `process` module now uses `#module` directive
  - `util` module now uses `#module` directive

## [0.10.5] - 2025-12-21

### Changed

- Version bump with ESM migration improvements

## [0.10.4] - 2025-12-20

### Added

- **ESM Support**: Add ESM support for process, fs, and util modules using `#module` directive

## [0.10.2] - 2025-12-15

### Added

- **Navigation API**: Add Navigation API implementation for browser (`@browser.Navigation`)

### Fixed

- **Storage API**: `Storage::getItem` now returns `undefined` for `None` instead of `null`

## [0.10.1] - 2025-12-12

### Added

- **Trusted Types API**: Add TrustedHTML, TrustedScript, and TrustedScriptURL types for Content Security Policy support
- **Xany Type**: Add cross-platform `Xany` type for JavaScript interop

### Fixed

- **xany**: Use non-deprecated assert syntax in tests

## [0.10.0] - 2025-12-11

### Breaking Changes

- **NPM package bindings moved to separate repository**: All `mizchi/js/npm/*` packages have been moved to [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt)

  If you are using any npm package bindings (React, Hono, AI SDK, etc.), please update your `moon.pkg.json`:

  **Before (v0.9.x and earlier):**
  ```json
  {
    "import": ["mizchi/js/npm/react", "mizchi/js/npm/hono"]
  }
  ```

  **After (v0.10.0+):**
  ```json
  {
    "import": ["mizchi/npm_typed/react", "mizchi/npm_typed/hono"]
  }
  ```

  Also add the new dependency in `moon.mod.json`:
  ```json
  {
    "deps": {
      "mizchi/npm_typed": "0.1.0"
    }
  }
  ```

- **Removed examples depending on npm packages**: Examples that required npm packages (e.g., `react_app`) have been removed from this repository. See [mizchi/npm_typed](https://github.com/mizchi/npm_typed.mbt) for updated examples.

- **DOM API changes**:
  - `CustomElementRegistry::define_` API simplified
  - `HappyWindow` unified with `Window` type

### Added

- **`TypeOf[T]` type for JavaScript constructors** (`@core.TypeOf[T]`):
  - Represents JavaScript constructor/class types (similar to TypeScript's `typeof ClassName`)
  - `TypeOf::is_instanceof(value)` - Type-safe instanceof check
  - `TypeOf::as_any()` - Convert to `@core.Any`
  - `new_instance(cls, args)` - Type-safe constructor call

- **DOM improvements**:
  - `cast_from_event_target` for DOM types - Safe upcast from EventTarget
  - `cast_from_*` upcast methods for inheritance hierarchies
  - Advanced DOM manipulation APIs for UI frameworks
  - Comprehensive DOM tests with happy-dom

- **Test utilities**:
  - `retry` function with timeout support in `test_utils`
  - Improved test stability with event-based waiting

### Changed

- **DOM**: Fixed innerHTML/outerHTML inheritance path
- **TypedArray**: Changed `UInt` to `Int` for consistency
- **Testing**: Replaced jsdom with happy-dom for DOM tests
- Updated `moonbitlang/async` dependency to 0.14.3
- Documentation uses `mbt test` / `mbt check` format for testable examples

### Removed

- `src/npm/` - All npm package bindings (React, Preact, Hono, AI SDK, etc.)
- `global_jsdom` dependency
- npm-dependent example files

### What Remains in This Repository

This repository continues to provide:

- **Core JavaScript FFI** (`mizchi/js/core`) - Type system, object manipulation, async/await
- **JavaScript Built-ins** (`mizchi/js/builtins/*`) - Object, Array, Map, Set, Date, Math, RegExp, etc.
- **Web Standard APIs** (`mizchi/js/web/*`) - fetch, URL, Streams, Crypto, WebSocket, etc.
- **Node.js APIs** (`mizchi/js/node/*`) - fs, path, process, child_process, http, etc.
- **Browser APIs** (`mizchi/js/browser/*`) - DOM, Canvas, Storage, etc.
- **Deno APIs** (`mizchi/js/deno`) - Deno runtime bindings
- **Bun APIs** (`mizchi/js/bun`) - Bun runtime bindings

## [0.8.8] - 2025-12-08

### Changed

#### MSW (Mock Service Worker) Refactoring
- **Split platform-specific code**: Separated `msw.mbt` into three modules:
  - `msw.mbt` - Common functionality (HTTP handlers, response builders)
  - `msw_node.mbt` - Node.js specific API (`SetupServer`)
  - `msw_browser.mbt` - Browser specific API (`SetupWorker`)
- **Enhanced type definitions**: Added detailed TypeScript-aligned types
  - `HttpResponse` options now support `status`, `statusText`, and `headers` parameters
  - All response functions (`json`, `text`, `html`, `xml`) now accept optional parameters
  - Added `WebSocketHandler` type for future WebSocket mocking support
- **Improved type safety**: Replaced `#external` types with `pub(all)` structs
  - `ResponseResolverInfo` now provides direct property access
  - Converted property accessor FFI functions to `pub extern "js"`
- **Simplified API**: Merged duplicate functions into single functions with optional parameters
  - Combined `json`/`jsonWithStatus` into single `json` function
  - Combined `server_listen`/`worker_start` variants

#### simple-git Refactoring
- **Enhanced type safety**: Converted `StatusResult` from `#external` to `pub(all)` struct
  - Direct field access for: `current`, `tracking`, `not_added`, `modified`, `staged`, `deleted`, `created`, `conflicted`, `ahead`, `behind`
  - Removed 10 FFI helper functions (`ffi_status_*`)
  - Kept `isClean()` as `extern "js"` (calls JavaScript method)
- **Unified FFI patterns**: Changed `as_any()` implementations from `extern "js"` to `"%identity"`
- **Comprehensive documentation**: Added detailed JSDoc comments
  - `simpleGit()`: Documented all constructor options (base_dir, binary, maxConcurrentProcesses, trimmed)
  - `commit()`: Documented message, files, and author parameters
  - `push()`: Documented remote, branch, set_upstream, force, tags options
  - `pull()`: Documented remote and branch options
  - Added usage examples for major functions

#### htmlparser2 Refactoring
- **Improved type safety**: Replaced `#external` types with `pub(all)` structs
  - `Document`, `Element`, and `Node` now support direct property access
  - Better type safety with explicit field types
- **Simplified API**: Merged duplicate functions
  - Combined `parseDocument`/`parseDocumentWithOptions`
  - Combined `createParser`/`createParserWithOptions`

### Technical Improvements
- Reduced FFI overhead by eliminating unnecessary wrapper functions
- Improved code maintainability with explicit type definitions
- Better IDE support through direct property access
- All tests passing: MSW (28), simple-git (15), htmlparser2 tests verified

## [0.8.6] - 2025-12-08

### Added

#### Bun Runtime Support
- Added comprehensive Bun runtime bindings in `src/bun/`
- Implemented Bun test runner integration with `Bun.test()` and `expect()` assertions
- All 29 tests passing successfully

#### Bun Process & Command Execution APIs
- `Bun.spawn()` - Asynchronously spawn child processes
- `Bun.spawnSync()` - Synchronously spawn child processes
- `Subprocess` type with full process management:
  - `pid()` - Get process ID
  - `exitCode()` - Get exit code
  - `stdin()`, `stdout()`, `stderr()` - Stream access
  - `kill()` - Terminate process
  - `exited()` - Wait for process completion
- `SpawnOptions` - Configure process spawn options (cmd, cwd, env, stdio)

#### Bun Utility Functions
- `Bun.which()` - Find executables in PATH
- `Bun.escapeHTML()` - HTML string sanitization
- `Bun.stringWidth()` - Calculate display width of strings (supports multi-byte characters)
- `Bun.randomUUIDv7()` - Generate UUIDv7 identifiers
- `Bun.peek()` - Inspect Promise state

#### Bun Hashing & Cryptography APIs
- `Bun.hash()` - General-purpose hashing function
- `CryptoHasher` type for streaming hash computations:
  - `CryptoHasher()` - Create hasher (sha256, sha512, md5, etc.)
  - `update()` - Add data to hash
  - `digest_hex()` - Get hex string digest
  - `digest_base64()` - Get base64 digest
  - `digest_buffer()` - Get ArrayBuffer digest

#### Bun Glob API
- `Glob` type for file pattern matching:
  - `Glob()` - Create glob pattern matcher
  - `match_()` - Test string against pattern
  - `scan()` - Scan filesystem for matching files

#### Bun File & Environment APIs
- `Bun.file()` - File operations
- `Bun.write()` - Write data to files
- `Bun.cwd` - Current working directory
- `Bun.argv()` - Command-line arguments
- `Bun.env()` - Environment variables
- `Bun.version()` - Bun version
- `Bun.revision()` - Bun revision
- `is_bun()` - Detect Bun runtime

#### Additional Bun APIs
- `Bun.sleep()` - Async sleep function
- `Bun.nanoseconds()` - High-resolution timer
- `Bun.password.hash()` / `Bun.password.verify()` - Password hashing with bcrypt
- `Bun.serve()` - HTTP server creation
- `unlink_sync()` - File deletion

### Changed
- Updated `moon.mod.json` keywords to include "bun"

### Technical Details
- Implemented proper CPS (Continuation-Passing Style) handling for async functions in Bun test runner
- All Bun bindings follow the existing pattern used in Deno bindings
- Comprehensive test coverage with 29 passing tests
