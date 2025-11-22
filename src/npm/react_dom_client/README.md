# mizchi/js/npm/react_dom_client

## react-dom/client

React DOM client-side rendering APIs

## Installation

```bash
npm add react react-dom
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js",
    "mizchi/js/browser/dom",
    "mizchi/js/npm/react",
    "mizchi/js/npm/react_dom_client"
  ]
}
```

## API

### Types
- [x] ReactDOMClient - Client-side rendering module
- [x] ReactDOMRoot - Root container for React tree

### Functions
- [x] dynamic_import_async() -> ReactDOMClient - Dynamic import (async)
- [x] ReactDOMClient::createRoot(container) -> ReactDOMRoot - Create root
- [x] ReactDOMRoot::render(vdom) - Render React element

## Usage

### For Browser/Vite (Dynamic Import)

```moonbit
fn main {
  @js.run_async(fn() try {
    let client = @react_dom_client.dynamic_import_async()
    let container = @dom.document().getElementById("root")
    let root = client.createRoot(container)
    root.render(my_element)
  } catch {
    err => @js.log("Error during initialization: \{err}")
  })
}
```

### For Node.js (Synchronous Require)

```moonbit
fn main {
  let client : @react_dom_client.ReactDOMClient = @node.require("react-dom/client") |> @js.unsafe_cast
  let container = @dom.document().getElementById("root")
  let root = client.createRoot(container)
  root.render(my_element)
}
```
