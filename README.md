# @mizchi/js

Moonbit js libraries (for my use)

```bash
$ moon add mizchi/js
```

### JS bindings for Moonbit.

- `mizchi/js` : Core JS bindings
  - get(), set(), unsafe_cast(), invoke(), instanceof(), etc.
  - All Api uses `#external type @js.Val` and `trait @js.Js`
- `mizchi/js/async` : async with
  - `Promise`
- `mizchi/js/dom` : DOM and Browser API
  - `Document`, `Element`, `Event`, `Node`, `Window`, etc.
- `mizchi/js/console` :
  - `console:*`
- `mizchi/js/regexp` : `RegExp`
- `mizchi/js/timer` : `setTimeout`, `setInterval`, `clearTimeout`, `clearInterval`, etc
- `mizchi/js/weak`:
  - `WeakMap`, `WeakSet`, `FinalizationRegistry`
- `mizchi/js/url` :
  - `URL`, `URLSearchParams`, `URLPattern`
- `mizchi/js/http` : Network API
  - `fetch`, `Request`, `Response`
- `mizchi/js/worker` : Worker and MessageChannel API

### Node.js binding

- [x] `mizchi/js/node` : Node.js global API
  - `require`, `__dirname`, `__filename`, `Buffer`, etc.
- [x] `mizchi/js/node/fs` : `node:fs`
  - Partially tested
- [x] `mizchi/js/node/os` : `node:os`
  - Partially tested
- [x] `mizchi/js/node/path` : `node:path`
- [x] `mizchi/js/node/process` : `node:process`
  - Partially tested
- [x] `mizchi/js/node/util` : `node:util`
- [x] `mizchi/js/node/test` : `node:test`
- [x] `mizchi/js/node/child_process` : `node:child_process`
  - Not tested
- [x] `mizchi/js/node/events` : `node:events`
- [ ] `mizchi/js/node/http` : `node:http`
  - Not tested

### Node.js Library bindings

- `mizchi/js/npm/react` : React
- `mizchi/js/npm/react_router` : react-router (only BrowserRouter yet)
- `mizchi/js/npm/react_testing_library` : react-testing-library

### Cloudflare Workers binding

- `mizchi/js/cloudflare` : Cloudflare Workers API
  - [ ] ``Not fully tested yet

## mizchi/js

moon.pkg.json

```json
{
  "import": ["mizchi/js"]
}
```

```mbt
fn main {
  let obj = @js.Object::new()
  obj.set("xxx", js(42))
  let v: Int = obj.get("xxx") |> @js.unsafe_cast
}
```

## Prior Art

- https://mooncakes.io/docs/rami3l/js-ffi
- https://github.com/moonbit-community/jmop

## LICENSE

MIT
