# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### React

#### Core Features
- React 19 hooks support (`useActionState`, `useFormStatus`, `useOptimistic`)
- TypeScript-like type annotations for React hooks
- Generic `lazy_` component with full type safety
- Array[ReactNode] support in React DSL
- Comprehensive React Testing Library integration
- Utility functions: `captureOwnerStack`, `cacheSignal`, `cache`, `act`
- camelCase aliases for all React API functions
- `ComponentType` type (renamed from `ComponentFn`)

#### API Changes
- `lazy_` now accepts `() -> Promise[Js]` signature
- React Router integration improvements
- Enhanced `ReactRef` API

### Core JavaScript APIs

#### Type System & FFI
- Converted most `#external` types to `pub(all) struct` for direct field access
- Type-safe `Nullable[T]` support with comprehensive tests
- Fixed `Js?` match crashes and null vs undefined behavior
- Added `from_option` helper for `Option[T]` to `Js` conversion
- Concretized `Js` type fields to specific types
- Improved FFI Option field behavior

#### Promise API
- Added `Promise::wait()` method (replaces deprecated `Promise::unwrap()`)

#### Global Functions
- Added `parseInt`, `parseFloat`, `isFinite`

#### Collections
- Added `JsMap` and `JsSet` collection types

### Built-in Types

#### Math
- Complete Math API with all MDN functions and constants
- Converted to `#external type Math` with static methods

#### Typed Arrays
- Unified `#alias` pattern for typed arrays
- Added `Bytes` conversion utilities
- Reorganized to `builtins/typed_array`

#### Crypto
- `Crypto.getRandomValues()` with type-safe TypedArray overloads
- `Crypto.randomUUID()` support

#### Other Built-ins
- BigInt support (`builtins/bigint`)
- Collection utilities (`builtins/collection`)
- WeakMap/WeakSet (`builtins/weak`)
- RegExp improvements (`builtins/regexp`)
- Reflect API (`builtins/reflect`)
- Proxy API (`builtins/proxy`)

### Web Standard APIs

#### New Web APIs (WinterCG compatible)
- `mizchi/js/web` meta-package
- `web/console` - Console API
- `web/http` - Fetch API (Request, Response, Headers, FormData)
- `web/url` - URL, URLSearchParams, URLPattern
- `web/streams` - ReadableStream, WritableStream, TransformStream
- `web/blob` - Blob, File
- `web/encoding` - TextEncoder, TextDecoder
- `web/event` - Event, CustomEvent, MessageEvent
- `web/crypto` - SubtleCrypto, getRandomValues, randomUUID
- `web/performance` - Performance API
- `web/webassembly` - WebAssembly Module and Instance
- `web/websocket` - WebSocket API
- `web/worker` - Web Workers
- `web/message` - MessageChannel, MessagePort

#### Compression
- `CompressionStream` and `DecompressionStream` APIs

### Browser APIs

#### Reorganization
- Migrated DOM to `browser/dom` hierarchy
- Converted HTML form elements from `#external` to `pub(all) struct`

#### New Browser APIs
- `browser/indexeddb` - IndexedDB support
- `browser/canvas` - Canvas API
- `browser/file` - File API
- `browser/history` - History API
- `browser/location` - Location API
- `browser/navigator` - Navigator API
- `browser/observer` - Intersection/Mutation/Resize Observers
- `browser/storage` - localStorage/sessionStorage

#### DOM
- Improved type safety for DOM and SVG elements
- Enhanced element manipulation APIs

### Node.js APIs

#### New Modules
- `node/https` - HTTPS module
- `node/http2` - HTTP/2 module
- `node/tty` - TTY module
- `node/tls` - TLS/SSL module
- `node/readline` - Readline module
- `node/readline_promises` - Readline Promises API
- `node/stream_promises` - Stream Promises API
- `node/sqlite` - SQLite support
- `node/wasi` - WASI support

#### Improvements
- Fixed warnings in readline package
- Updated `child_process` types (`SpawnSyncResult`, `ChildProcess`)
- Enhanced `fs`, `path`, `process`, `buffer` modules
- Improved `node/util`, `node/events`, `node/net`

### NPM Package Bindings

#### Hono Web Framework
- Complete Hono framework bindings (`npm/hono`)
- Generic type parameters for Env and ExecutionContext
- Request body parsing: `parseBody()`, `blob()`
- `Context::json` with generic type support
- Hono RPC client support with `testClient`
- `Hono::new()` strict option
- snake_case aliases for all APIs
- Renderer support: `setRenderer`, `render`

#### React Ecosystem
- `npm/react` - React 19 support
- `npm/react_dom_client` - ReactDOM client
- `npm/react_dom_server` - Server-side rendering
- `npm/react_router` - React Router bindings
- `npm/react_testing_library` - Testing utilities

#### Other Packages
- `npm/semver` - Semantic versioning
- `npm/global_jsdom` - jsdom for testing
- `npm/ai` - AI SDK bindings
- `npm/modelcontextprotocol` - MCP support

### Cloudflare Workers

- Complete Cloudflare Workers platform support
- KV, D1, R2, Durable Objects bindings
- Comprehensive testing setup

### Deno Runtime

- Full Deno runtime API support
- File system operations
- Permissions API
- Deno testing utilities
- Node.js compatibility layer documentation

### Documentation

- Comprehensive README.md for all packages
- FFI guide and best practices
- Escape hatch pattern documentation
- For TypeScript Users migration guide
- Platform-specific examples
- API support status tables with emoji indicators
- WinterCG references for web standards

### Project Structure

- Reorganized package structure
  - Core: `src/`
  - Built-ins: `src/builtins/`
  - Web Standards: `src/web/`
  - Browser: `src/browser/`
  - Node.js: `src/node/`
  - NPM packages: `src/npm/`
  - Runtime-specific: `src/deno/`, `src/cloudflare/`
- Renamed `builtins_types` to `builtin_types`
- Separated concerns by frequency of use

### Testing

- Added comprehensive test coverage
- Snapshot testing with `moon test --update`
- Error handling tests
- FFI behavior tests
- Coverage analysis support
- Platform-specific E2E tests

### Breaking Changes

**Note:** This release does not maintain backward compatibility with v0.2.0. The API has been significantly refactored for better type safety and usability.

- `Promise::unwrap()` → `Promise::wait()`
- `ComponentFn` → `ComponentType`
- Most `#external` types converted to `pub(all) struct`
- `from_builtin_json` → `from_json`
- Constructors now follow `Type::new` pattern
- `Response::new` uses keyword arguments instead of options object
- Reorganized package hierarchy (dom, web APIs, etc.)

## [0.2.0] - Earlier

Initial releases and earlier changes are not documented in this changelog.

---

## Migration Guide from v0.2.0

### Type System Changes

Most types have been converted from `#external` to `pub(all) struct`, enabling direct field access:

```moonbit
// Before (v0.2.0)
let value = obj.get("field")

// After (v0.4.0)
let value = obj.field  // Direct access
```

### Promise API

```moonbit
// Before
promise.unwrap()

// After
promise.wait()
```

### Constructor Pattern

All constructors now follow the `Type::new` pattern:

```moonbit
// Consistent across all types
let obj = Object::new()
let arr = Array::new()
let promise = Promise::new(fn)
```

### Package Imports

Update your imports to reflect the new package structure:

```moonbit
// Web Standard APIs (runtime-agnostic)
import @mizchi/js/web/http       // Fetch API
import @mizchi/js/web/url        // URL API
import @mizchi/js/web/streams    // Streams API

// Browser-specific
import @mizchi/js/browser/dom    // DOM APIs

// Node.js-specific
import @mizchi/js/node/fs        // File system
import @mizchi/js/node/http      // HTTP server
```

### React

React hooks now have full TypeScript-like type annotations. Update your imports to use the new camelCase aliases if preferred:

```moonbit
// snake_case (still supported)
use_state(initial)

// camelCase (new)
useState(initial)
```

## Current Version

The current version is **v0.4.0**, representing a major refactoring and expansion of the JavaScript FFI bindings for MoonBit.

For detailed API documentation, see the README.md files in each package directory.
