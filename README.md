# @mizchi/js

Moonbit js (for my self yet)

- mizchi/js/js
- mizchi/js/dom
- mizchi/js/react

## react

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
  let root = @dom.document().query_selector("#app").unwrap()
  @react.render(c(counter, CounterProps::{ initial: 42 }), root)
}
```

js entrypoint

```js
import React from "react";
import * as ReactApi from "react";
import { createRoot } from "react-dom/client";

globalThis.__ReactApi = {
  ...ReactApi,
  render(element, container) {
    const root = createRoot(container);
    root.render(element);
  },
};

await import("./target/js/release/build/examples/examples.js");
```

## Prior Art

- https://mooncakes.io/docs/rami3l/js-ffi
- https://github.com/moonbit-community/jmop

## LICENSE

MIT
