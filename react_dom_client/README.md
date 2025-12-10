# mizchi/npm_typed/react_dom_client

React DOM client-side rendering APIs (react-dom/client).

## Installation

```bash
moon add mizchi/js
moon add mizchi/npm_typed
npm install react react-dom
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/browser/dom",
    "mizchi/npm_typed/react",
    "mizchi/npm_typed/react_dom_client"
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
