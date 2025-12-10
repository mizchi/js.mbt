# mizchi/npm_typed/react

MoonBit bindings for [React](https://react.dev/).

## Installation

```bash
moon add mizchi/js
moon add mizchi/npm_typed
npm install react
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/core",
    "mizchi/js/browser/dom",
    "mizchi/npm_typed/react"
  ]
}
```

We are designing the API to be intuitive for React users, even if it means compromising on some aspects of safety.

## Usage

```moonbit
fn main {
  @js.run_async(fn() try {
    @react.dynamic_import_async()
    // React is ready to use
  } catch {
    err => @js.log("Error during React initialization: \{err}")
  })
}
```

## Example

```moonbit
using @react {
  type Context,
  h,
  c,
  component,
  use_effect,
  use_state,
  use_context,
}

using @react_element {
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
    let root = match @dom.document().querySelector("#app") {
      Some(el) => el
      None => {
        log("Root element not found")
        return ()
      }
    }
    client
    .create_root(root)
    .render(c(counter, { initial: 42 }))
  })
}
```

## Hooks Support

- [x] useState
- [x] useRef
- [x] useContext / createContext
- [x] useReducer
- [x] useActionState
- [x] useMemo
- [x] useEffect
- [x] startTransition
- [x] fragment (Fragment)
- [x] suspense (Suspense)
- [ ] useSyncExternalStore
