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

### For Browser/Vite (Dynamic Import)

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

### For Node.js (Synchronous Require)

```moonbit
fn main {
  // Initialize React API
  let react_module = @node.require("react")
  @react.init_react_api(react_module)
  
  // Initialize React Router API (manually set to globalThis)
  let react_router_module = @node.require("react-router")
  globalThis().set("__ReactRouterApi", react_router_module)
  // React Router is ready to use
}
```

**Note**: The `__ReactRouterApi` key is an implementation detail and may change in future versions.
