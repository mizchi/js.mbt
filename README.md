# @mizchi/js

Moonbit js libraries (for my use)

```bash
$ moon add mizchi/js
```

### JS bindings for Moonbit.

- `mizchi/js` : Core JS bindings
  - get(), set(), unsafe_cast(), invoke(), instanceof(), etc.
  - All Api uses `#external type @js.Val` and `trait @js.Js`
- `mizchi/js/async` : async with `Promise`
- `mizchi/js/dom` : DOM and Browser API
  - `Document`, `Element`, `Event`, `Node`, `Window`, etc.
- `mizchi/js/console` :
  - `console:*`
- `mizchi/js/regexp` : `RegExp`
- `mizchi/js/timer` : `setTimeout`, `setInterval`, `clearTimeout`, `clearInterval`, etc
- `mizchi/js/worker` : Worker and MessageChannel API
- `mizchi/js/http` : Network API
  - `fetch`, `Request`, `Response`
- `mizchi/js/weak`:
  - `WeakMap`, `WeakSet`, `FinalizationRegistry`
- `mizchi/js/url` :
  - `URL`, `URLSearchParams`, `URLPattern`

### Node.js binding

- `mizchi/js/node` : Node.js API
- `mizchi/js/node/fs` : `node:fs`
- `mizchi/js/node/path` : `node:path`
- `mizchi/js/node/process` : `node:process`
- `mizchi/js/node/util` : `node:util`
- `mizchi/js/node/test` : `node:test`
- `mizchi/js/node/child_process` : `node:child_process`

### Node.js Library bindings

- `mizchi/js/npm/react` : React
- `mizchi/js/npm/react_router` : react-router (only BrowserRouter yet)
- `mizchi/js/npm/react_testing_library` : react-testing-library

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

## mizchi/js/dom

```mbt
let doc = @dom.document()
match doc.query_selector("#root") {
  Some(root) => {
    root.add_event_listener("click", fn(ev) {
      ev.prevent_default()
      @js.log(root)
    })
  }
  None => ()
}
```

## mizchi/js/npm/react

We are designing the API to be intuitive for React users, even if it means compromising on some aspects of safety.

```mbt
using @react {
  type Context,
  h,
  c,
  component,
  use_effect,
  use_state,
  use_context,
}

using @element {
  div,
  button
}

struct CounterProps {
  initial: Int
}

fn counter(props: CounterProps) -> @react.Element {
  let (cnt, set_cnt) = use_state(props.initial)
  fragment([
    // factory
    h("h1", id="counter", [
      "counter"
    ]),
    // element
    button(type_="button", on_click=(_)=>set_cnt(cnt + 1), [
      cnt.to_string()
    ])
  ])
}

fn main {
  run_async(async fn() noraise {
    let client = init_react_client() catch {
      _err => {
        log("Failed to initialize React.")
        return ()
      }
    }
    let root = match @dom.document().query_selector("#app") {
      Some(el) => el
      None => {
        log("Root element not found")
        return ()
      }
    }

    client
    .create_root(root)
    .render(c(counter, CounterProps::{ initial: 42 }))
  })
}
```

entrypoint

```html
<script type="module" src="./target/js/release/build/main/main.js"></script>
```

- [x] use_state
- [x] use_ref
- [x] use_context / create_context
- [x] use_reducer
- [x] use_memo
- [x] use_effect
- [x] use_action_state
- [x] start_transition
- [x] fragment
- [x] suspense
- [x] render

## mizchi/js/npm/react_router

## mizchi/js/npm/react_testing_library

## Prior Art

- https://mooncakes.io/docs/rami3l/js-ffi
- https://github.com/moonbit-community/jmop

## LICENSE

MIT
