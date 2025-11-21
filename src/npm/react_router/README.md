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

```mbt
fn main {
  @js.run_async(() => try {
    // Initialize React Router API
    @react.init_react_async()
    @react_router.init_react_router_async()
    // React Router is ready to use
    ()
  } catch {
    _err => {
      @js.log("Failed to run async initialization.")
      panic()
    }
  })
  // @react_router.init_react_router_async()
  // @react_router.init_react_router_async()
}
```
