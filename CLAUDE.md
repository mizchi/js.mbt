# Project Agents.md Guide

This is a [MoonBit](https://docs.moonbitlang.com) project.

## MoonBit Language Reference

If you're unsure about MoonBit syntax, refer to the [MoonBit Cheatsheet](dev/examples/moonbit_cheatsheet.mbt.md) - it covers common patterns, differences from Rust, and key language features.

## Project Structure

- MoonBit packages are organized per directory, for each directory, there is a
  `moon.pkg` file listing its dependencies. Each package has its files and
  blackbox test files (common, ending in `_test.mbt`) and whitebox test files
  (ending in `_wbtest.mbt`).

- Each module has a `moon.mod` at its root with the module name, version and
  its module-level `import` list. `moon.work` at the repo root lists the
  workspace members; `moon check` / `moon build` / `moon test` process all of
  them at once.

- This repo is a workspace of 9 published modules, plus `mizchi/js_dev`
  (`dev/`) which is never published - see [dev/README.md](dev/README.md).
  `mizchi/js` is a meta package (`top.mbt` re-exports `js_core` +
  `js_builtin`) plus `wasm/`; it lives in `modules/js/` like every other
  module, so its publish archive contains only its own files:

  Indentation below means "depends on the module it hangs off":

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
    +-- mizchi/js_convert             MoonBit <-> JS value conversion
    |
    +-- mizchi/js_webextensions
    |
    +-- mizchi/js                     meta: top.mbt re-exports core +
                                      builtin; also wasm/
    |
    +-- mizchi/js_dev                 dev only, never published: bench,
                                      examples, bundle-size fixtures
  ```

  Dependencies only ever point up this tree. Adding one that points down makes
  a module cycle and `moon check` rejects it - `for "test"` imports included.

  **`mizchi/js` is a leaf: nothing in the workspace may depend on it.** It
  exists for users who want one import, and `top.mbt` is nothing but
  `pub using` re-exports. A module that reaches `@core.Promise` through
  `@js.Promise` would drag the whole facade - and its `js_convert` dependency -
  into that module's published manifest, so area modules import `js_core` and
  `js_builtin` directly.

  Watch out when removing the last use of a dependency: `moon check` reports
  package-level dead imports as `unused_package`, but it does **not** flag a
  dead `import` in `moon.mod`. Grep the package `moon.pkg` files before
  trusting a module-level dependency.

  Packaging facts worth knowing, all found with `moon package` (it writes the
  real publish archive to `_build/publish/` and needs no credentials, unlike
  `moon publish --dry-run`):

  - `moon.mod` has **no `exclude` or `files` field** - writing an `exclude`
    key makes `moon` fail to calculate the build plan. The archive is the whole
    module directory, and `source` only says where packages live inside it, so
    it cannot scope the archive either - no module here sets `source`, leaving
    packages at the module root.
  - `.moonignore` **does** work, and only for packaging - the build still
    compiles everything, so CI keeps working. Each published module has one,
    excluding `*_test.mbt`, `*_wbtest.mbt` and the `_tests/` / `bun_test/` /
    `_interop_test/` harness packages.
  - **Its patterns resolve against the workspace root, not the module.** A
    directory pattern naming a sibling - `modules/` in the repo-root
    `.moonignore`, say - silently produces an *empty* archive for every module
    under it, with `moon package` still reporting success. Keep those files to
    test globs.
  - A dead `targets:` entry is tolerated: `moon.pkg` may list test files that
    `.moonignore` removed, and the extracted archive still checks clean.
  - `.moonignore` cannot drop a `moon.mod` `import`, so a dev-only package
    that pulls a dependency still needs to move out of the published module.
    That is what `dev/` is for.
  - `moon.mod` rejects `#` comments, so notes go in a README next to it.

  This is why `mizchi/js` sits in `modules/js/` rather than at the repo root.
  While it was the root module its archive was the whole repository (~2.5MB,
  537 files - every sibling module, the lockfiles, CI config), and
  `.moonignore` could not fix that without emptying the siblings, per the rule
  above. **The repo root has no `moon.mod`** - keep it that way.

  See [docs/package-split.md](docs/package-split.md) for the layout and the
  migration notes.

## Coding convention

- MoonBit code is organized in block style, each block is separated by `///|`,
  the order of each block is irrelevant. In some refactorings, you can process
  block by block independently.

- Try to keep deprecated blocks in file called `deprecated.mbt` in each
  directory.

- **Constructors are `fn Type::Type(..)`, called as `Type(..)`.** This is
  MoonBit's canonical form since v0.10.0 (which removed the old `fn new(..)`
  syntax); v0.10.4 extended it to every type, not just structs.
  `moonbitlang/core` has already moved — there is no `StringBuilder::new`
  there any more, only `StringBuilder::StringBuilder`.

  Facts established by probing the compiler, worth not re-deriving:

  - A bare call works **through a package alias** — `@url.URL("...")`,
    `@collection.JsMap()` — and the type still works in type position, so
    `let u : @url.URL = @url.URL("...")` is fine.
  - `extern "js"` functions can be constructors:
    `pub extern "js" fn Foo::Foo(..) -> Foo = ...`.
  - Generics work, with the type parameters after `fn`:
    `pub fn[K, V] JsMap::JsMap() -> JsMap[K, V]`.
  - **A constructor must return the constructed type itself** (error 4200,
    "User-defined constructor must return the constructed type itself"). This
    is why `Object::new()` keeps its name: it returns `@core.Any`.
  - A deprecated `Type::new` shim may coexist with `Type::Type` in the same
    package. Forward the arguments as `Foo(a, b~, c?, d~)`, but note that an
    optional **with a default** (`x? : T = v`) binds a plain `T`, not an
    `Option`, so it forwards as `x~` — not `x?`. Getting this wrong is a type
    error, not a silent bug.
  - `moon check --deny-warn` promotes the deprecation warning to an error, so
    internal call sites have to move in the same change as the rename.

  Secondary factories are named `from_*` (`Response::from_body_init`,
  `URLPattern::from_object`), not `new_*`.

  One target trap: `js_core` is the only package built for **wasm-gc** as well
  as js, and it gates per-file through `options(targets: { ... })` in its
  `moon.pkg`. A new file there — `deprecated.mbt`, say — is compiled for every
  target unless you add it to that map, so a shim for a js-only type like
  `Promise` breaks `moon build --target wasm-gc` while `moon check` stays
  green. Every other package is `supported_targets = "js"`.

  Beware when grepping for constructors to migrate: `^pub fn Type::new(`
  misses both `pub extern "js" fn Type::new(` and the generic form
  `pub fn[T] Type::new(`. The generated `.mbti` files are the reliable
  inventory of what is actually public.

## Opaque JS handles: never a zero-field struct

An opaque handle onto a JS object must be declared

```moonbit
///|
#external
pub type GPUDevice
```

and **never** as a zero-field struct:

```moonbit
///|
pub(all) struct GPUDevice {} // WRONG -- silently erases the value
```

MoonBit treats a zero-field struct as zero-sized, so the value is dropped
when a function **returns** one. Every `-> GPUDevice` then hands back
`undefined`, and the `%identity` `as_any` gives `undefined` too. This is how
the whole `webgpu` package came to be non-functional before 0.14: `gpu()`,
`requestAdapter()`, `createBuffer()` all returned nothing.

Two reasons it hides:

- Casting in and straight back out **within one function** is inlined and
  works, so a quick check looks fine. Only a real function boundary loses it.
- `moon check` is perfectly happy; the types line up. Nothing but a runtime
  test catches it.

So when binding a JS object, write a test that calls a function returning the
handle and reads a property back through it. `grep -nE '^pub(\(all\))? struct
[A-Za-z0-9_]+ \{\}'` finds the bad pattern.

## Tooling

- `moon fmt` is used to format your code properly.

- `moon info` is used to update the generated interface of the package, each
  package has a generated interface file `.mbti`, it is a brief formal
  description of the package. If nothing in `.mbti` changes, this means your
  change does not bring the visible changes to the external package users, it is
  typically a safe refactoring.

- In the last step, run `moon info && moon fmt` to update the interface and
  format the code. Check the diffs of `.mbti` file to see if the changes are
  expected.

- Run `moon test` to check the test is passed. MoonBit supports snapshot
  testing, so when your changes indeed change the behavior of the code, you
  should run `moon test --update` to update the snapshot.

- You can run `moon check` to check the code is linted correctly.

- When writing tests, you are encouraged to use `inspect` and run
  `moon test --update` to update the snapshots, only use assertions like
  `assert_eq` when you are in some loops where each snapshot may vary. You can
  use `moon coverage analyze > uncovered.log` to see which parts of your code
  are not covered by tests.
- `moon coverage analyze --package pkgName` is also useful to see the coverage of a
  specific package.
- CLAUDE.md has some small tasks that are easy for AI to pick up, agent is
  welcome to finish the tasks and check the box when you are done

## Testing

```bash
moon test
moon build

# Deno-side tests. Each task builds the profile its tests need, so they work
# from a clean tree:
deno task test:deno      # mizchi/js_deno integration bundle (debug build)
deno task test:convert   # mizchi/js_convert TS tests (release build)
deno task test:all       # both
```

Bare `deno test -A` only picks up `test.include` from `deno.jsonc` (the
`js_deno` bundle) and assumes the debug build already exists - prefer the
tasks above.

### Async Test Resource Management

When writing `async test` that creates servers or network resources (HTTP, HTTPS, HTTP/2, Net), **ALWAYS** use `defer` immediately after resource creation to ensure proper cleanup:

```moonbit
async test "Server test example" {
  let server = createServer()
  defer server.close() |> ignore  // REQUIRED: Add this immediately after creation

  // Test code here...
}

async test "Socket test example" {
  let socket = createConnection()
  defer socket.destroy() |> ignore  // REQUIRED: Add this immediately after creation

  // Test code here...
}
```

**Rules:**
- Place `defer` statement **immediately after** resource creation (server, socket, etc.)
- This applies to all async tests in:
  - `modules/js_node/http/*_test.mbt`
  - `modules/js_node/https/*_test.mbt`
  - `modules/js_node/http2/*_test.mbt`
  - `modules/js_node/net/*_test.mbt`
- The `defer` ensures cleanup even if the test fails or times out
- You may still call explicit cleanup (e.g., `server.close(callback=...)`) for verification purposes, but `defer` is mandatory for safety

**Test Stability:**
- Use `./scripts/check_flaky.ts` to verify test stability
- Run multiple times to identify flaky tests: `./scripts/check_flaky.ts 10 12000`
- All tests should consistently pass without timeouts

## MoonBit to JavaScript Type Mapping

### Primitive Types (Zero-cost)

| MoonBit Type | JavaScript Type |
|--------------|-----------------|
| `String` | `string` |
| `Bool` | `boolean` |
| `Int`, `UInt`, `Float`, `Double` | `number` |
| `BigInt` | `bigint` |
| `Bytes` | `Uint8Array` |
| `FixedArray[T]` | `Array<T>` |
| `Array[T]` | `Array<T>` |
| Function Type | `Function` |

### Arrays in `extern "js"` signatures

`Array[T]` is **deprecated in FFI signatures** (warning `0020`) - its runtime
representation is an implementation detail. Use `FixedArray[T]` in every
`extern "js"` declaration instead:

```moonbit
///|
/// The extern always uses FixedArray ...
extern "js" fn ffi_object_keys(obj : Any) -> FixedArray[String] =
  #| (obj) => Object.keys(obj)

///|
/// ... and the public wrapper keeps the friendlier `Array[T]`.
pub fn object_keys(obj : Any) -> Array[String] {
  Array::from_fixed_array(ffi_object_keys(obj))
}
```

Conventions used in this repo:

- **Argument positions** on public FFI functions take `FixedArray[T]` directly.
  Array literals (`Math::max([1.0, 2.0])`, `obj._call("f", [a, b])`) work
  unchanged and stay zero-cost; pass a runtime-built `Array` with
  `FixedArray::from_array(arr[:])`.
- **Return positions** keep `Array[T]` in the public API, converting with
  `Array::from_fixed_array` in a thin non-extern wrapper (the same pattern
  `moonbitlang/core` uses in `@env`).

### Collection Type Conversion Overhead (minified)

| MoonBit Type | Conversion | Overhead |
|--------------|------------|----------|
| `Array[T]` | `%identity` | +31B (zero-cost) |
| `HashSet[T]` | iterate + push | +4.6KB |
| `Map[String, T]` | iterate + set | +6.2KB |
| `Json` | recursive match | +6.9KB |
| `@immut/array.T[T]` | iterate + push | +7.2KB |
| `@immut/hashmap.HashMap` | iterate + set | +11.6KB |

See [docs/runtime-cost.md](docs/runtime-cost.md) for detailed analysis.

## ESM Migration with `#module`

This project is migrating to ESM imports using MoonBit's `#module` directive for better tree-shaking and smaller bundle sizes.

### Usage

```moonbit
///|
/// Import a function from an npm package
#module("react/jsx-runtime")
extern "js" fn ffi_jsx(
  tag : @core.Any,
  props : @core.Any,
  key : @core.Any,
) -> @core.Any = "jsx"

///|
/// Import from a specific package path
#module("react")
extern "js" fn ffi_use_state(initial : @core.Any) -> @core.Any = "useState"
```

### Limitations

Due to `extern "js"` constraints, `#module` can only be applied to **functions**:

- ✅ Functions with fixed arguments (hooks, utilities, etc.)
- ❌ Components (React components are objects/classes)
- ❌ Constants/Symbols (Fragment, StrictMode, delimiter, sep, etc.)
- ❌ Classes (new Hono(), new Database(), etc.)
- ❌ Variadic functions (path.join(...paths), path.resolve(...paths)) - no auto-spread

For non-function exports, use one of these workarounds:

1. **Symbol.for** for React symbols:
```moonbit
extern "js" fn ffi_react_fragment() -> @core.Any =
  #| () => Symbol.for('react.fragment')
```

2. **Dynamic import with global** for components (e.g., RouterProvider):
```moonbit
extern "js" fn import_react_router() -> @js.Promise[@core.Any] =
  #|() => import("react-router")

pub async fn init_global() -> Unit {
  let v = import_react_router().wait()
  @global.global_this()._set("__ReactRouterApi", v)
}
```

### Migration Priority

Prioritize frontend libraries for tree-shaking benefits:
1. react, react_element, react_dom_client (high impact)
2. preact, vue (frontend frameworks)
3. Server-side libraries (lower priority)
