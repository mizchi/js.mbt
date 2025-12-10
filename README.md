# mizchi/npm_typed

Typed npm package bindings for MoonBit, built on top of [mizchi/js](https://github.com/mizchi/js.mbt).

## Installation

```bash
moon add mizchi/js
moon add mizchi/npm_typed
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/core",
    "mizchi/npm_typed/react",
    "mizchi/npm_typed/hono"
  ]
}
```

## Available Packages

| Category | Packages | Status |
|----------|----------|--------|
| **UI Frameworks** | react, react_dom, react_dom_client, react_dom_server, react_dom_static, react_element, react_router, preact, ink, ink_ui | 🧪 Tested |
| **Web Frameworks** | hono, better_auth, helmet | 🧪 Tested |
| **AI / LLM** | ai (Vercel AI SDK), modelcontextprotocol, claude_code | 🧪 Tested |
| **Cloud Services** | client_s3 (@aws-sdk/client-s3) | 🧪 Tested |
| **Database** | pglite, duckdb, drizzle, pg | 🧪 Tested |
| **Validation** | zod, ajv | 🧪 Tested |
| **Build Tools** | terser, vite, unplugin, lighthouse, esbuild, oxc_minify | 🧪 Tested |
| **Utilities** | date_fns, semver, chalk, colorette, dotenv, chokidar, yargs, debug, jose, comlink | 🧪 Tested |
| **Testing** | testing_library, testing_library_react, testing_library_preact, testing_library_vue, puppeteer, playwright, playwright_test, vitest, jsdom, happy_dom, global_jsdom, msw, ink_testing_library | 🧪 Tested |
| **Parsing** | htmlparser2, js_yaml | 🧪 Tested |
| **Other** | simple_git, ignore, memfs, source_map, magic_string, error_stack_parser, minimatch, execa, pino | 🧪 Tested |

## Quick Start

### React Example

```moonbit
// moon.pkg.json: import mizchi/npm_typed/react, mizchi/npm_typed/react_element

fn counter(props : Unit) -> @react.Element {
  let (count, set_count) = @react.useState(0)
  @react_element.div([
    @react_element.span(["Count: \{count}"]),
    @react_element.button(on_click=fn(_) { set_count(count + 1) }, ["+"]),
  ])
}
```

### Hono Example

```moonbit
// moon.pkg.json: import mizchi/npm_typed/hono

async fn main {
  let app : @hono.Hono[Unit, Unit] = @hono.Hono::new()
  app.get("/", fn(c) { c.text("Hello, Hono!") }) |> ignore
}
```

### Zod Example

```moonbit
// moon.pkg.json: import mizchi/npm_typed/zod

fn main {
  let schema = @zod.object()
    .field("name", @zod.string())
    .field("age", @zod.number())

  let result = schema.safeParse(@core.any({ "name": "Alice", "age": 30 }))
  if result.success {
    println("Valid!")
  }
}
```

## Requirements

This package requires:

- MoonBit nightly `2025-12-09` or later for ESM `#module` directive support
- `mizchi/js` v0.9.0 or later as a peer dependency

## Related Projects

- [mizchi/js](https://github.com/mizchi/js.mbt) - Core JavaScript FFI bindings
- [@mizchi/cloudflare-mbt](https://github.com/mizchi/cloudflare.mbt) - Cloudflare Workers bindings

## LICENSE

MIT
