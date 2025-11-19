# @mizchi/js

js/browser/node.js bindings for Moonbit. 

```bash
$ moon add mizchi/js
```

## Project Status

- I use some parts of this package in my production projects.
  - React SPA works
  - `node:fs` and `node:sqlite` work
- Many APIs are generated automatically from TypeScript definition files with AI.

## Goals

- Provide comprehensive JavaScript bindings for Moonbit
- My personal goals
  - Full Node.js/Deno Support to replace TypeScript
  - Full Browser + React Support for frontend
  - Full Cloudflare Worker Support
  - MCP server/client support

## How to use

moon.pkg.json

```json
{
  "import": ["mizchi/js"]
}
```

### Basic Usages

```mbt
fn main {
  // JS: const obj = {}
  let obj = @js.Object::new()
  // JS: obj.xxx = 42
  obj.set("xxx", 42)
  
  // get with cast
  // JS: const v = obj.xxx
  let v: Int = obj.get("xxx") |> @js.unsafe_cast
  
  // call method
  // JS: const has_world = obj.hasOwnProperty("world")
  let has_world: Bool = obj.call("hasOwnProperty", ["world"]) |> @js.unsafe_cast
}
```

### Create your own bindings:

```mbt
using @js {
  trait JsImpl,
  unsafe_cast,
}

#external
pub type MyType

impl JsImpl for MyType

pub fn MyType::myMethod(self: Self, arg: String) -> Int {
  self.call("myMethod", [arg]) |> unsafe_cast
}
```

See escape hatch pattern in [docs/moonbit-js-ffi.md](./docs/moonbit-js-ffi.md)

---

Modules

## DOM bindings

- `mizchi/js/dom`
  - `Element`
  - `HTMLElement`
  - `Event`
  - `Node`
  - `Window`
  - etc.
- `mizchi/js/dom/canvas`
  - `CanvasRenderingContext2D`
  - `ImageData`
- `mizchi/js/dom/blob`
- `mizchi/js/dom/file`
- [ ] indexedDB
- [ ] ServiceWorker
- [ ] WebSocket
- [ ] FileSystem
- [ ] WebGL
- [ ] AudioContext

## NPM Library bindings

In near future, we split these bindings into a separate package.

- `mizchi/js/npm/react`
  - React
  - `mizchi/js/npm/react/element`
    - Typed HTML elements binding for Moonbit + React`
- `mizchi/js/npm/react_dom`
  - ReactDOM
- `mizchi/js/npm/react_router`
  - Only `BrowserRouter` related api
- `mizchi/js/npm/react_testing_library`
  - react-testing-library

### Deno binding

Not yet. Use node compatible bindings instead.

### Cloudflare Workers binding

In near future, we split these bindings into a separate package.

- `mizchi/js/cloudflare` : Cloudflare Workers API
  - [ ] Not tested yet

## Prior Art

- https://mooncakes.io/docs/rami3l/js-ffi
- https://github.com/moonbit-community/jmop

## LICENSE

MIT
