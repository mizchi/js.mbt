# mizchi/npm_typed/react_dom_server

React DOM server-side rendering APIs (react-dom/server).

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
    "mizchi/js/web/streams",
    "mizchi/js/node",
    "mizchi/npm_typed/react",
    "mizchi/npm_typed/react_dom_server"
  ]
}
```

## API

### Functions
- [x] renderToString(element) -> String - Render to HTML string (synchronous)
- [x] renderToReadableStream(element) -> Promise[ReadableStream] - Render to stream (asynchronous)

## Usage

### Synchronous Rendering

```moonbit
let element = createElement("div", ["Hello, World!"])
let html = renderToString(element)
// html: "<div>Hello, World!</div>"
```

### Streaming Rendering

```moonbit
let element = createElement("div", ["Hello, World!"])
let stream = renderToReadableStream(element).unwrap()
let reader = stream.getReader()
// Read chunks from stream
```

## Test Coverage
Tests in src/_tests/react_dom_test.mbt
