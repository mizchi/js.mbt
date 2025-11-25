# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [0.5.0] - 2025-11-25

### Breaking Changes

#### Type System Changes
- **`@js.Js` → `@js.Any`** - Renamed core JavaScript interop type
  - All `Js` type references must be updated to `Any`
  - Affects all FFI function signatures and type annotations
  - Migration: Replace `@js.Js` with `@js.Any` throughout your codebase

- **`to_js()` → `to_any()`** - Renamed JsImpl trait method
  - The `JsImpl` trait method `to_js()` is now `to_any()`
  - Aligns with the `Js` → `Any` type rename
  - Migration: Replace `.to_js()` with `.to_any()` in your code

- **`@js.js()` → `@js.any()`** - Renamed standalone conversion function
  - The global function `@js.js()` is now `@js.any()`
  - Used for converting values to the `Any` type
  - Migration: Replace `@js.js(value)` with `@js.any(value)`

- **`unsafe_cast` → `identity`** - Renamed unsafe type conversion function
  - `@js.unsafe_cast()` is now `@js.identity()`
  - Used for FFI conversions between MoonBit and JavaScript types
  - Migration: Replace `unsafe_cast` with `identity` in FFI code

- **Introduced `Js::cast()` method** - New type-safe casting method
  - Added for cleaner type conversions in FFI boundaries
  - Preferred over `identity` for explicit type casts
  - Usage: `value.cast()` instead of `identity(value)`

### Added

- **`Js::cast()` method** - Type-safe casting for JavaScript values
- **Test stability checker** (`scripts/check_test.ts`)
  - Detect flaky tests by running multiple iterations
  - Progress display and diff tracking
  - Proper Ctrl-C handling and cleanup
- **`run_promise()` function** - Cancellable promise execution support
- **Struct-based FFI types** - Converted getter-heavy types to `pub(all) struct`
  - CloudFlare: `CloudflareRequest`, `DurableObjectId`, `DurableObjectStub`, `DurableObjectState`
  - Node.js: `SourceMap`, `SourceMapEntry`
  - Hono: `HonoRequest`
  - Direct field access instead of getter methods for better ergonomics

### Changed

- **Async test infrastructure improvements**
  - Migrated to `moonbitlang/async` with `async test` format
  - Added `defer` resource cleanup for servers and connections
  - Improved resource management to prevent test hangs
  - Proper cleanup of event listeners and network resources
  - Re-enabled previously disabled async tests for web streams, http, and message APIs

- **Promise API improvements**
  - Integration with `moonbitlang/async/js_async`
  - Better interoperability with MoonBit's async system

- **FFI type improvements**
  - Converted getter-heavy external types to `pub(all) struct`
  - Simplified method calls: removed redundant `to_any()` conversions
  - Better type safety with direct field access
  - CloudFlare example code updated to use direct field access (e.g., `req.url` instead of `req.url()`)

### Fixed

- **Test stability issues**
  - Added defer cleanup for HTTP server tests
  - Fixed event listener cleanup to prevent process hanging
  - Converted setTimeout tests to Promise-based synchronization
  - Improved async test resource management

### Improved

- **Test coverage**
  - Added tests for `Nullish::to_option()` covering null, undefined, and actual values
  - Added error handling tests for all promisify functions (promisify0-3)
  - Achieved 100% coverage on `src/any.mbt`
  - Improved coverage on `src/async.mbt` (67% improvement)
  - Total: 1493 tests passing

### Internal

- **Refactoring**
  - Simplified IncomingMessage with from_callback helper
  - Merged promise tests and removed using declarations
  - Used Set.symmetricDifference for test comparison

## [0.4.0] - 2025-11-24

### Added

#### Node.js APIs
- **node:worker_threads** - Worker threads API implementation
  - `Worker` class with labeled optional parameters
  - Worker methods: `postMessage()`, `terminate()`, `ref_()`, `unref()`, `threadId()`
  - `MessagePort` class with `postMessage()`, `start()`, `close()`
  - Global functions: `isMainThread()`, `parentPort()`, `workerData()`, `threadId()`
  - EventEmitter support for Worker and MessagePort
  - Stream support: `stdin()`, `stdout()`, `stderr()`

- **node:async_hooks** - AsyncLocalStorage implementation
  - Generic type `AsyncLocalStorage[T]` for type-safe async context
  - Methods: `new()`, `run()`, `exit()`, `getStore()`, `enterWith()`, `disable()`
  - Comprehensive test coverage (7 tests)

#### Core APIs
- **queueMicrotask()** - Queue microtask for execution
  - FFI binding with `#alias(queue_microtask)` for snake_case

- **MessageEvent** - Web messaging event implementation
  - Implemented as `pub(all) struct` with EventTargetImpl
  - Fields: `data`, `origin`, `lastEventId`, `ports`

#### Error Handling
- **URL::new**, **atob**, **btoa** now raise exceptions
  - Changed to `-> T raise ThrowError` signature
  - Wrapped FFI calls with `@js.throwable()`
  - Added exception tests with `try?` pattern

### Changed

#### Breaking Changes
- **Renamed package**: `message_channel` → `message`
  - Updated imports: `mizchi/js/web/message_channel` → `mizchi/js/web/message`
  - Updated all references in documentation and code

- **Renamed package**: `typed_array` → `typedarray`
  - Updated imports: `mizchi/js/builtins/typed_array` → `mizchi/js/builtins/typedarray`
  - All references updated across 35 files

### Fixed
- Worker script paths now require `./` prefix for relative paths
  - Fixes `ERR_WORKER_PATH` error in Node.js Worker

- threadId FFI function now returns Int directly
  - Fixed trait object casting issue with dedicated FFI binding

### Testing
- Added async tests for worker_threads (basic operations only)
- Worker creation tests temporarily disabled due to async timing issues
- threadId test skipped due to FFI casting investigation

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
- Reorganized to `builtins/typedarray`

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

## Migration Guide

### From v0.4.0 to v0.5.0

#### Update Type References

Replace all `@js.Js` with `@js.Any`:

```moonbit
// Before (v0.4.0)
fn my_function(value : @js.Js) -> @js.Js {
  value
}

extern "js" fn ffi_call() -> @js.Js = #|() => {}

// After (v0.5.0)
fn my_function(value : @js.Any) -> @js.Any {
  value
}

extern "js" fn ffi_call() -> @js.Any = #|() => {}
```

#### Update method and function names

Replace `to_js()` with `to_any()` and `@js.js()` with `@js.any()`:

```moonbit
// Before (v0.4.0)
let js_val = my_object.to_js()
let converted = @js.js(value)

// After (v0.5.0)
let js_val = my_object.to_any()
let converted = @js.any(value)
```

#### Replace unsafe_cast with identity

```moonbit
// Before (v0.4.0)
let result = @js.unsafe_cast(value)

// After (v0.5.0)
let result = @js.identity(value)
```

#### Use cast() for explicit conversions

```moonbit
// Preferred pattern in v0.5.0
let typed_value : MyType = js_value.cast()

// Also valid
let typed_value : MyType = @js.identity(js_value)
```

### From v0.2.0 to v0.4.0

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

The current version is **v0.5.0**, which includes breaking changes to the core type system (`@js.Js` → `@js.Any`) and FFI utilities (`unsafe_cast` → `identity`).

For detailed API documentation, see the README.md files in each package directory.
