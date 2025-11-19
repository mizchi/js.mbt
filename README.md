# @mizchi/js

js/browser/node.js bindings for Moonbit. 

```bash
$ moon add mizchi/js
```

## How to use

moon.pkg.json

```json
{
  "import": ["mizchi/js"]
}
```

## Modules

- [mizchi/js](./mizchi/js/README.md) : JavaScript Builtin API
- [mizchi/js/node](./mizchi/js/node/README.md) : Node.js API
- [mizchi/js/dom](./mizchi/js/dom/README.md) : Browser & DOM API
- [mizchi/js/cloudflare](./mizchi/js/cloudflare/README.md) : Cloudflare Worker API
- [mizchi/js/npm/*](./mizchi/js/npm/README.md) : NPM Library bindings

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

## LICENSE

MIT
