# mizchi/js/npm/react_router

## Installation

```bash
npm add react react-router
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/npm/react",
    "mizchi/js/npm/react_router"
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
