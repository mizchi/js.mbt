# @mizchi/js

Moonbit js libraries (for my self yet)

```bash
$ moon add mizchi/js
```

```json
{
  "import": [
    "mizchi/js/js",
    "mizchi/js/dom",
    "mizchi/js/react",
    "mizchi/js/react/element"
  ]
}
```

## mizchi/js/js

```mbt
let obj = @js.new_object()
obj["xxx"] = 1
let v: Int = obj.get("xxx") |> @js.identity
```

## mizchi/js/dom

```mbt
let root = @dom.document().query_selector("#root").unwrap()
root.add_event_listener("click", ev => {
  ev.prenent_default();
  @js.log(root)
});
```

## mizchi/js/react

We are designing the API to be intuitive for React users, even if it means compromising on some aspects of safety.

```mbt
using @react {
  type Component,
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

let counter: Component[CounterProps] = component(props => {
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
})

fn main {
  run_async(async fn() noraise {
    let client = init_react_client() catch {
      _err => {
        log("Failed to initialize React.")
        return ()
      }
    }
    let root = @dom.document().query_selector("#app").unwrap()

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

## Prior Art

- https://mooncakes.io/docs/rami3l/js-ffi
- https://github.com/moonbit-community/jmop

## LICENSE

MIT
