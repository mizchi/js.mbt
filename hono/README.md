# Hono Bindings for MoonBit

MoonBit bindings for [Hono](https://hono.dev/), a fast and lightweight web framework.

## Features

- Hono core (routing, middleware, context)
- JSX rendering (`hono/jsx`)
- CSS-in-JS (`hono/css`)
- Cookie helpers (`hono/cookie`)
- JWT helpers (`hono/jwt`)
- CORS middleware (`hono/cors`)
- RPC client (`hono/client`)
- Testing utilities (`hono/testing`)

## Usage

### Basic Example

```moonbit
async fn main {
  let app : @hono.Hono[Unit, Unit] = @hono.Hono::new()
  app.get("/", fn(c) { c.text("Hello, Hono!") }) |> ignore
  // serve with @hono/node-server or deploy to Cloudflare Workers
}
```

### JSX with HonoJsx (Recommended)

For ESM environments, use the `HonoJsx` API which handles module initialization automatically:

```moonbit
async fn create_app() -> @hono.Hono[Unit, Unit] {
  let hono_jsx = @hono.import_hono_jsx()
  let hono_css = @hono.import_hono_css()

  let app = @hono.Hono::new()
  app.get("/", fn(c) {
    let content = hono_jsx.jsx("div", [
      hono_jsx.jsx("h1", ["Hello, World!"]),
    ])
    c.html_jsx(content)
  })
}
```

### JSX with Legacy API

The legacy API (`jsx`, `h`, `fragment`) is simpler but requires initialization in ESM:

```moonbit
async fn create_app() -> @hono.Hono[Unit, Unit] {
  // Required for ESM: initialize Fragment before using fragment()
  @hono.init_jsx_runtime()

  let app = @hono.Hono::new()
  app.get("/", fn(c) {
    let content = @hono.jsx("div", [
      @hono.jsx("h1", ["Hello, World!"]),
    ])
    c.html_jsx(content)
  })
}
```

## ESM Migration Notes

This package uses `#module` directive for ESM compatibility. Most functions work automatically, but `Fragment` requires special handling because it's a value export (not a function).

### Why `init_jsx_runtime()` is needed

- `#module` directive only works with function exports
- `Fragment` is a Symbol value exported from `hono/jsx/jsx-runtime`
- `init_jsx_runtime()` dynamically imports and stores Fragment in globalThis

### Recommendation

For new code, prefer the `HonoJsx` API which encapsulates all initialization:

```moonbit
let hono_jsx = @hono.import_hono_jsx()
hono_jsx.fragment([child1, child2])  // No manual init needed
```

## Example

See `src/examples/hono_app` for a complete example with:
- Routing
- JSX rendering
- CSS-in-JS styling
- Cookie-based authentication
- CORS middleware
