# NPM Library Bindings

MoonBit bindings for popular npm packages.

> **Note**: These bindings require installing the corresponding npm packages.
>
> ```bash
> # Example: Install React dependencies
> npm install react react-dom
>
> # Example: Install Hono
> npm install hono
> ```

## Supported Packages

### UI Frameworks

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [react](react/) | `react` | 🧪 Tested | Core React API |
| [react_element](react_element/) | - | 🧪 Tested | Typed HTML elements for React |
| [react_dom](react_dom/) | `react-dom` | 🧪 Tested | React DOM |
| [react_dom_client](react_dom_client/) | `react-dom/client` | 🧪 Tested | Client-side rendering |
| [react_dom_server](react_dom_server/) | `react-dom/server` | 🧪 Tested | Server-side rendering |
| [react_dom_static](react_dom_static/) | `react-dom/static` | 🧪 Tested | Static rendering |
| [react_router](react_router/) | `react-router` | 🧪 Tested | Client-side routing |
| [react_testing_library](react_testing_library/) | `@testing-library/react` | 🧪 Tested | React testing utilities |
| [preact](preact/) | `preact` | 🧪 Tested | Lightweight React alternative |
| [preact_testing_library](preact_testing_library/) | `@testing-library/preact` | 🧪 Tested | Preact testing utilities |
| [ink](ink/) | `ink` | 🧪 Tested | React for CLI apps |
| [ink_ui](ink_ui/) | `@inkjs/ui` | 🧪 Tested | Ink UI components |

### Web Frameworks

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [hono](hono/) | `hono` | 🧪 Tested | Fast web framework, middleware support |
| [better_auth](better_auth/) | `better-auth` | 🧪 Tested | Authentication library |

### AI / LLM

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [ai](ai/) | `ai` (Vercel AI SDK) | 🧪 Tested | AI/LLM integration |
| [modelcontextprotocol](modelcontextprotocol/) | `@modelcontextprotocol/sdk` | 🧪 Tested | MCP server/client |

### Cloud Services

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [client_s3](client_s3/) | `@aws-sdk/client-s3` | 🧪 Tested | S3-compatible storage (AWS, GCS, R2, MinIO) |

### Database

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [pglite](pglite/) | `@electric-sql/pglite` | 🧪 Tested | Embedded PostgreSQL |
| [duckdb](duckdb/) | `@duckdb/duckdb-wasm` | 🧪 Tested | Analytical database |

### Validation / Schema

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [zod](zod/) | `zod` | 🧪 Tested | Schema validation |
| [zod_codegen](zod_codegen/) | - | 🧪 Tested | Zod code generator |
| [ajv](ajv/) | `ajv` | 🧪 Tested | JSON Schema validator |

### Build Tools

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [terser](terser/) | `terser` | 🧪 Tested | JavaScript minifier |

### Utilities

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [date_fns](date_fns/) | `date-fns` | 🧪 Tested | Date manipulation |
| [semver](semver/) | `semver` | 🧪 Tested | Semantic versioning |
| [chalk](chalk/) | `chalk` | 🧪 Tested | Terminal styling |
| [dotenv](dotenv/) | `dotenv` | 🧪 Tested | Environment variables |
| [chokidar](chokidar/) | `chokidar` | 🧪 Tested | File watching |

### Testing / Development

| Package | npm | Status | Note |
|---------|-----|--------|------|
| [vitest](vitest/) | `vitest` | 🚧 Partial | Test runner |
| [puppeteer](puppeteer/) | `puppeteer` | 🧪 Tested | Browser automation |
| [global_jsdom](global_jsdom/) | `global-jsdom` | 🧪 Tested | JSDOM for testing |
| [vite](vite/) | `vite` | 🧪 Tested | Build tool integration |

## Status Legend

- 🧪 **Tested**: Comprehensive test coverage
- 🚧 **Partial**: Core functionality implemented
- 🤖 **AI Generated**: Needs testing

## Dynamic Import Usage

Until MoonBit adds native ESM support, use `dynamic_import_async()` for frontend packages:

```moonbit
fn main {
  @js.run_async(fn() try {
    @react.dynamic_import_async()
    @react_dom_client.dynamic_import_async()
    // Modules ready to use
  } catch {
    err => @js.log("Error: \{err}")
  })
}
```
