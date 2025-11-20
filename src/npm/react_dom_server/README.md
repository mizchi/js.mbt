# mizchi/js/npm/react_dom_server

## react-dom/server

React DOM server-side rendering APIs

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
    "mizchi/js/stream",
    "mizchi/js/node",
    "mizchi/js/npm/react",
    "mizchi/js/npm/react_dom_server"
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
