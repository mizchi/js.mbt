# mizchi/npm_typed

Typed npm package bindings for MoonBit, built on top of [mizchi/js](https://github.com/mizchi/js.mbt).

Inspired by [DefinitelyTyped](https://github.com/DefinitelyTyped/DefinitelyTyped) - the repository for high quality TypeScript type definitions. This project aims to be the MoonBit equivalent, providing type-safe FFI bindings for popular npm packages.

> **Note**: These bindings require installing the corresponding npm packages.
>
> ```bash
> # Example: Install React dependencies
> npm install react react-dom
>
> # Example: Install Hono
> npm install hono
> ```

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

### UI Frameworks

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [react](react/) | `react` | 🧪 Tested | Core React API |
| [react_element](react_element/) | - | 🧪 Tested | Typed HTML elements for React |
| [react_dom](react_dom/) | `react-dom` | 🧪 Tested | React DOM |
| [react_dom_client](react_dom_client/) | `react-dom/client` | 🧪 Tested | Client-side rendering |
| [react_dom_server](react_dom_server/) | `react-dom/server` | 🧪 Tested | Server-side rendering |
| [react_dom_static](react_dom_static/) | `react-dom/static` | 🤖 AI Generated | Static rendering |
| [react_router](react_router/) | `react-router` | 🧪 Tested | Client-side routing |
| [testing_library_react](testing_library_react/) | `@testing-library/react` | 🧪 Tested | React testing utilities |
| [preact](preact/) | `preact` | 🧪 Tested | Lightweight React alternative |
| [testing_library_preact](testing_library_preact/) | `@testing-library/preact` | 🤖 AI Generated | Preact testing utilities |
| [ink](ink/) | `ink` | 🧪 Tested | React for CLI apps |
| [ink_ui](ink_ui/) | `@inkjs/ui` | 🧪 Tested | Ink UI components |

### Web Frameworks

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [hono](hono/) | `hono` | 🧪 Tested | Fast web framework, middleware support |
| [better_auth](better_auth/) | `better-auth` | 🤖 AI Generated | Authentication library |
| [helmet](helmet/) | `helmet` | 🧪 Tested | Security headers middleware |

### AI / LLM

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [ai](ai/) | `ai` (Vercel AI SDK) | 🧪 Tested | AI/LLM integration |
| [modelcontextprotocol](modelcontextprotocol/) | `@modelcontextprotocol/sdk` | 🧪 Tested | MCP server/client |
| [claude_code](claude_code/) | `@anthropic-ai/claude-code` | 🤖 AI Generated | Claude Code SDK |

### Cloud Services

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [client_s3](client_s3/) | `@aws-sdk/client-s3` | 🧪 Tested | S3-compatible storage (AWS, GCS, R2, MinIO) |

### Database

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [pglite](pglite/) | `@electric-sql/pglite` | 🧪 Tested | Embedded PostgreSQL |
| [duckdb](duckdb/) | `@duckdb/duckdb-wasm` | 🤖 AI Generated | Analytical database |
| [drizzle](drizzle/) | `drizzle-orm` | 🤖 AI Generated | TypeScript ORM (see [limitations](drizzle/README.md)) |
| [pg](pg/) | `pg` | 🤖 AI Generated | PostgreSQL client |

### Validation / Schema

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [zod](zod/) | `zod` | 🧪 Tested | Schema validation |
| [ajv](ajv/) | `ajv` | 🧪 Tested | JSON Schema validator |

### Build Tools

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [terser](terser/) | `terser` | 🧪 Tested | JavaScript minifier |
| [vite](vite/) | `vite` | 🧪 Tested | Next-gen build tool |
| [unplugin](unplugin/) | `unplugin` | 🤖 AI Generated | Unified plugin system |
| [lighthouse](lighthouse/) | `lighthouse` | 🤖 AI Generated | Web performance auditing |
| [esbuild](esbuild/) | `esbuild` | 🧪 Tested | Fast bundler |
| [oxc_minify](oxc_minify/) | `oxc-minify` | 🧪 Tested | Oxc minifier |

### Utilities

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [date_fns](date_fns/) | `date-fns` | 🧪 Tested | Date manipulation |
| [semver](semver/) | `semver` | 🧪 Tested | Semantic versioning |
| [chalk](chalk/) | `chalk` | 🧪 Tested | Terminal styling |
| [colorette](colorette/) | `colorette` | 🧪 Tested | Terminal colors |
| [dotenv](dotenv/) | `dotenv` | 🧪 Tested | Environment variables |
| [chokidar](chokidar/) | `chokidar` | 🧪 Tested | File watching |
| [yargs](yargs/) | `yargs` | 🤖 AI Generated | CLI argument parsing |
| [debug](debug/) | `debug` | 🤖 AI Generated | Debug logging |
| [jose](jose/) | `jose` | 🧪 Tested | JWT/JWE/JWS |
| [comlink](comlink/) | `comlink` | 🤖 AI Generated | Web Worker RPC |
| [simple_git](simple_git/) | `simple-git` | 🤖 AI Generated | Git operations |
| [ignore](ignore/) | `ignore` | 🤖 AI Generated | .gitignore parsing |
| [memfs](memfs/) | `memfs` | 🧪 Tested | In-memory file system |
| [minimatch](minimatch/) | `minimatch` | 🧪 Tested | Glob matching |
| [execa](execa/) | `execa` | 🧪 Tested | Process execution |
| [pino](pino/) | `pino` | 🧪 Tested | Fast logging |
| [magic_string](magic_string/) | `magic-string` | 🧪 Tested | String manipulation |

### Testing / Development

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [vitest](vitest/) | `vitest` | 🚧 Partial | Test runner |
| [puppeteer](puppeteer/) | `puppeteer` | 🧪 Tested | Browser automation |
| [playwright](playwright/) | `playwright` | 🧪 Tested | Browser automation |
| [playwright_test](playwright_test/) | `@playwright/test` | 🤖 AI Generated | Playwright test framework |
| [jsdom](jsdom/) | `jsdom` | 🧪 Tested | DOM implementation |
| [happy_dom](happy_dom/) | `happy-dom` | 🧪 Tested | Fast DOM implementation |
| [global_jsdom](global_jsdom/) | `global-jsdom` | 🧪 Tested | JSDOM for testing |
| [testing_library](testing_library/) | `@testing-library/dom` | 🧪 Tested | DOM testing utilities |
| [msw](msw/) | `msw` | 🧪 Tested | Mock Service Worker |
| [ink_testing_library](ink_testing_library/) | `ink-testing-library` | 🧪 Tested | Ink testing utilities |

### Parsing

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [htmlparser2](htmlparser2/) | `htmlparser2` | 🧪 Tested | HTML/XML parser |
| [js_yaml](js_yaml/) | `js-yaml` | 🤖 AI Generated | YAML parser |
| [source_map](source_map/) | `source-map` | 🧪 Tested | Source map utilities |
| [error_stack_parser](error_stack_parser/) | `error-stack-parser` | 🧪 Tested | Stack trace parsing |

### Status Legend

- 🧪 **Tested**: Comprehensive test coverage
- 🚧 **Partial**: Core functionality implemented
- 🤖 **AI Generated**: Needs testing

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
