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
  @react_router.init_react_router_async()
}
```
