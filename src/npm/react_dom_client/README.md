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
    "mizchi/js/dom",
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
- [x] import_react_dom_client() -> Promise[ReactDOMClient] - Dynamic import
- [x] ReactDOMClient::createRoot(container) -> ReactDOMRoot - Create root
- [x] ReactDOMRoot::render(vdom) - Render React element

## Usage

```moonbit
let client = import_react_dom_client().unwrap()
let container = document.getElementById("root")
let root = client.createRoot(container)
root.render(my_element)
```
