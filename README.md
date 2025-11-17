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
  
  // invoke method
  // JS: const has_world = obj.hasOwnProperty("world")
  let has_world: Bool = obj.invoke("hasOwnProperty", ["world"]) |> @js.unsafe_cast
}
```

### Create your own bindings:

```mbt
using @js {
  type Js,
  unsafe_cast,
}

#external
pub type MyType

impl Js for MyType

pub fn MyType::myMethod(self: Self, arg: String) -> Int {
  self.invoke("myMethod", [arg]) |> unsafe_cast
}
```

See escape hatch pattern in [docs/moonbit-js-ffi.md](./docs/moonbit-js-ffi.md)

---

Modules

## Moonbit JS bindings

- `mizchi/js` : Core JS bindings
  - get(), set(), unsafe_cast(), invoke(), instanceof(), etc.
  - All Api uses `#external type @js.Val` and `trait @js.Js`
- `mizchi/js/promise` : async bindings with Moonbit async
  - `Promise`
- `mizchi/js/arraybuffer`
  - `ArrayBuffer`, `SharedArrayBuffer`, `DataView`, and TypedArrays
- `mizchi/js/regexp` : `RegExp`
- `mizchi/js/timer` : `setTimeout`, `setInterval`, `clearTimeout`, `clearInterval`, etc
- `mizchi/js/worker` : Worker and MessageChannel API
- `mizchi/js/console` :
  - `console:*`
- `mizchi/js/webassembly` : `WebAssembly` API
- `mizchi/js/weak`:
  - `WeakMap`, `WeakSet`, `WeakRef`, `FinalizationRegistry`
- `mizchi/js/url` :
  - `URL`, `URLSearchParams`, `URLPattern`
- `mizchi/js/http` : Network API
  - `fetch`, `Request`, `Response`

Not yet

- [ ] `Performance` API

## DOM bindings

- `mizchi/js/dom`
  - `Document`, `Element`, `Event`, `Node`, `Window`, etc.
  - [ ] indexed db
  - [ ] ServiceWorker
  - [ ] WebSocket
  - [ ] SSE

## Node.js binding

Caution: Node.js bindings are not fully tested yet. In near future, we split Node.js bindings into a separate package.

- [x] `mizchi/js/node` : Node.js global API
  - `require`, etc.
- [x] `mizchi/js/node/buffer` : `Buffer`
- [x] `mizchi/js/node/fs` : `node:fs`
- [x] `mizchi/js/node/fs/promises` : `node:fs/promises`
- [x] `mizchi/js/node/path` : `node:path`
- [x] `mizchi/js/node/util` : `node:fs/util`
- [x] `mizchi/js/node/os` : `node:os`
- [x] `mizchi/js/node/sqlite` : `node:sqlite`
- [x] `mizchi/js/node/module` : `node:module`
- [x] `mizchi/js/node/process` : `node:process`
- [x] `mizchi/js/node/v8` : `node:v8`
- [x] `mizchi/js/node/events` : `node:events`
  - [x] `EventEmitter`
- [x] `mizchi/js/node/util` : `node:util`
  - [x] `util.inspect`
  - [x] `util.parseArgs`
- [x] `mizchi/js/node/child_process` : `node:child_process`
- [x] `mizchi/js/node/test` : `node:test`
  - We use async testing instead of `async test` in Moonbit
- [x] `node:stream`
  - Partially tested
- [x] `node:wasi`

Not yet

- [ ] `node:vm`
- [ ] `node:worker_threads`
- [ ] `node:net`
- [ ] `node:domain`
- [ ] `node:http`
- [ ] `node:https`
- [ ] `node:http2`
- [ ] `node:dns`
- [ ] `node:net`
- [ ] `node:repl`
- [ ] `node:tty`
- [ ] `node:dgram`
- [ ] `node:zlib`
- [ ] `node:permissions`

Not planned

- `node:querystring`
  - Use `URLSearchParams` instead.
- `node:crypto`
  - Use Web Crypto API instead.
- `node:string_decoder`
  - Use TextDecoder/TextEncoder instead.

## Node.js Library bindings

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
