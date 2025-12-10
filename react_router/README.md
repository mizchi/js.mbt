# mizchi/npm_typed/react_router

MoonBit bindings for [React Router](https://reactrouter.com/).

## Installation

```bash
moon add mizchi/js
moon add mizchi/npm_typed
npm install react react-router
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/npm_typed/react",
    "mizchi/npm_typed/react_router"
  ]
}
```

## Usage

```moonbit
fn main {
  @js.run_async(fn() try {
    // Initialize React and React Router APIs
    @react.dynamic_import_async()
    @react_router.dynamic_import_async()
    // React Router is ready to use
  } catch {
    err => @js.log("Error during initialization: \{err}")
  })
}
```
