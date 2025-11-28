# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [0.5.7] (Unreleased)

### Added

#### Preact (`npm/preact`)
- **Core Preact API** - Full Preact bindings for building UI components
  - `VNode` type for virtual DOM nodes
  - `h()` / `createElement()` - Create virtual DOM elements with props, style, ref, key support
  - `component()` - Create component elements from function components
  - `fragment()` - Create fragment elements
  - `render()` / `hydrate()` - Mount/hydrate Preact apps to DOM
  - `createContext()` / `provider()` - Context API for state sharing
  - `createRef()` / `cloneElement()` / `toChildArray()` - Utility functions
- **Preact Hooks** - All standard hooks from preact/hooks
  - `useState` / `useStateLazy` - State management
  - `useEffect` / `useLayoutEffect` - Side effects
  - `useMemo` / `useCallback` - Memoization
  - `useRef` - Mutable references
  - `useReducer` - Reducer-based state
  - `useContext` - Context consumption
  - `useId` - Unique ID generation
  - `useErrorBoundary` - Error handling
  - `useImperativeHandle` / `useDebugValue` - Advanced hooks
- **PreactNode trait** - Type-safe children (VNode, String, Int, Double, Bool, Array, Option)
- **Dynamic import** - `dynamic_import()` for async module loading
- **snake_case aliases** - All hooks have `#alias` for snake_case naming

#### Preact Testing Library (`npm/preact_testing_library`)
- **render()** - Render Preact components for testing
- **screen** - Query rendered elements (same API as React Testing Library)
  - `getBy*` / `queryBy*` / `findBy*` / `getAllBy*` / `queryAllBy*` / `findAllBy*`
  - Queries: Role, LabelText, PlaceholderText, Text, DisplayValue, AltText, Title, TestId
- **fireEvent** - Simulate user events (click, change, input, keyboard, mouse, etc.)
- **TextMatch trait** - Accept String or RegExp for text matching
- **Utilities** - `cleanup()`, `act()`, `waitFor()`, `renderHook()`
- **RenderResult** - `container()`, `baseElement()`, `debug()`, `rerender()`, `unmount()`, `asFragment()`

---

## [0.5.6]

### Added

#### React Testing Library (`npm/react_testing_library`)
- **TextMatch trait** - Queries now accept both `String` and `@regexp.RegExp` for text matching
  - Applies to all text-based queries: `getByText`, `getByLabelText`, `getByPlaceholderText`, etc.
  - Example: `screen().getByText(@regexp.RegExp::new("Hello"))` now works
- **jest-dom matchers** - Full expect/matcher API for assertions
  - `expect(element).toHaveTextContent("text")` - Assert text content (String or RegExp)
  - `expect(element).toHaveClass("class")` - Assert CSS class
  - `expect(element).toHaveAttribute("attr")` / `toHaveAttributeValue("attr", "value")`
  - `expect(element).toBeInTheDocument()` - Assert element exists in DOM
  - `expect(element).toBeVisible()` / `toBeDisabled()` / `toBeEnabled()`
  - `expect(element).toBeChecked()` / `toBeRequired()` / `toBeValid()` / `toBeInvalid()`
  - `expect(element).toHaveFocus()` / `toBeEmptyDOMElement()`
  - `expect(element).toHaveValue("value")` / `toHaveDisplayValue("value")`
  - `expect(element).toHaveStyle("css")` / `toHaveRole("role")`
  - `expect(element).toHaveAccessibleName("name")` / `toHaveAccessibleDescription("desc")`
  - `expect(element).toContainElement(child)` / `toContainHTML("<html>")`
  - Chained assertions: `expect(el)..toBeInTheDocument()..toHaveClass("btn")`
- **snake_case aliases** - All Screen queries and Expect matchers have `#alias` for snake_case
  - `getByText` → `get_by_text`, `toHaveTextContent` → `to_have_text_content`, etc.
- **setup() with dispose pattern** - `setup()` returns dispose function for use with `defer`
  ```moonbit
  let dispose = setup()
  defer dispose()
  ```

### Changed

#### React Testing Library
- **Removed `toHaveTextContentMatch`** - Use `toHaveTextContent(@regexp.RegExp::new(...))` instead
- **Split into separate files** - `rtl.mbt`, `screen.mbt`, `fire_event.mbt`, `jest_dom_matchers.mbt`
- **Improved test setup** - Uses `@global_jsdom.register()` and dispose pattern

#### SPA Support (`browser/events`, `npm/react_router`)
- **Browser events** - Added `popstate`, `hashchange` event support
- **React Router improvements** - Enhanced SPA navigation support

### Fixed

#### Zod Codegen (`npm/zod_codegen`)
- **Trailing newlines** - Prevent extra trailing newlines in generated output

---

## [0.5.3]

### Changed

#### Zod Package
- **ZodSchema methods use `Self` type** - Changed `self : ZodSchema` to `self : Self` for cleaner method signatures
- **ZodParseError suberror type** - Added `pub suberror ZodParseError ZodError` for type-safe error handling
- **SafeParseResult is now internal** - Changed from `pub type` to `priv type`
- **`parse()` accepts `JsImpl` trait bound** - Generic type parameter for more flexible input types
- **Tests use idiomatic `try...catch...noraise` pattern** - Replaced `guard (try? ...)` with proper error handling syntax

#### AI SDK (`npm/ai`)
- **snake_case aliases** - Added `#alias(snake_case)` for all camelCase functions:
  - `generateText` → `generate_text`
  - `streamText` → `stream_text`
  - `generateObject` → `generate_object`
  - `generateObjectWithZod` → `generate_object_with_zod`
  - `generateImage` → `generate_image`
  - `embedMany` → `embed_many`
  - `cosineSimilarity` → `cosine_similarity`
  - `StreamTextResultHandle` methods: `finishReason`, `fullStream`, `fullStreamRaw`, `textStream`

#### Type Safety Improvements
- **`@js.Any` → `&@js.JsImpl`** - Improved type safety for JS interop parameters:
  - `node/buffer`: `fill`, `includes`, `indexOf`, `lastIndexOf`
  - `node/stream`: `Readable::from`, `unshift`, `Duplex::from`, `fromWeb`, `addAbortSignal`
  - `node/util`: `inspect`
  - `node/assert`: `ifError`
  - `node/tty`: `WriteStream::cursorTo`, `moveCursor`, `clearLine`, `clearScreenDown`
  - `web/streams`: `ReadableStream::from`, `pipeTo`, `pipeThrough`, `tee`

#### Node.js Child Process
- **`@js.Nullish[@js.JsError]`** - Error-first callbacks now use typed nullish errors:
  - `exec`, `execFile` callbacks
  - `on_error` uses `@js.JsError` directly

### Internal

- Skip slow PGlite tests to improve `moon test` performance
- Reorganized package.json dependencies (moved duckdb, dotenv to devDependencies, added chokidar)
- Updated examples/aisdk to use snake_case API

---

## [0.5.1]

### Added

#### NPM Package Bindings

##### AI SDK (`npm/ai`)
- **Core API** - `generateText`, `streamText` with typed results
- **generateObject** - Structured output generation with Zod schema validation
- **Embeddings** - `embed`, `embedMany` for text embeddings
- **Image Generation** - `generateImage` API support
- **Tools Support** - Type-safe tool definitions and execution
- **Streaming** - `TextStreamPart` union type for typed streaming responses
- **Loop Control** - Agent loop utilities for multi-step AI interactions
- **Provider Adapters** - OpenAI, Anthropic, Google provider support
- **Testing Utilities** - Mock providers for testing

##### Ink CLI (`npm/ink`, `npm/ink_ui`)
- **ink** - React-based CLI library bindings
  - Components: `Text`, `Box`, `Newline`, `Spacer`, `Static`, `Transform`
  - Layout: Flexbox-based layout with `FlexDirection`, `JustifyContent`, `AlignItems`
  - Styling: `TextWrap`, `BorderStyle`, `Overflow`, `Display` enums
  - Rendering: `render()`, `InkInstance` with `rerender`, `unmount`, `waitUntilExit`, `clear`
  - Hooks: `useInput`, `useApp`, `useFocus`, `useFocusManager`, `useStdin`, `useStdout`, `useStderr`
  - Testing: `render` testing utility with `lastFrame`, `frames`, `stdin`
- **@inkjs/ui** - UI components
  - `TextInput`, `PasswordInput`, `EmailInput`, `UncontrolledTextInput`
  - `Select`, `MultiSelect`, `ConfirmInput`
  - `Spinner`, `ProgressBar`, `StatusMessage`, `Badge`, `Alert`
  - `OrderedList`, `UnorderedList`, `ThemeProvider`
- Dynamic import for ESM compatibility

##### Model Context Protocol (`npm/modelcontextprotocol`)
- **MCP Server** - TypeScript SDK bindings for building MCP servers
- Typed handler interfaces for tools, resources, prompts

##### Zod Schema Validation (`npm/zod`)
- **Complete Zod API** - Full validation library bindings
- **DSL Convenience Functions** - `string()`, `number()`, `object()`, etc.
- **JSON Schema Conversion** - `JsonSchema::from_zod()` for schema interop
- **MoonBit Code Generator** - Generate structs from Zod schemas

##### Zod Codegen (`npm/zod_codegen`)
- **Extracted from zod package** - Separate code generation utilities
- **Nested type generation** - Handle complex nested object schemas
- **Snapshot testing** - Verify generated code with snapshots

##### Other NPM Packages
- **PGlite** (`npm/pglite`) - In-memory PostgreSQL via WASM
- **DuckDB-WASM** (`npm/duckdb`) - In-memory analytics database
- **date-fns** (`npm/date_fns`) - Date manipulation library
  - `DateArgs` trait for flexible date input (String, Int, Date)
  - Formatting: `format`, `formatISO`, `formatDistance`, `formatDistanceToNow`, `formatRelative`
  - Parsing: `parse`, `parseISO`
  - Comparison: `isBefore`, `isAfter`, `isEqual`, `isSameDay`, `isSameMonth`, `isSameYear`, `compareAsc`, `compareDesc`
  - Difference: `differenceInDays`, `differenceInMonths`, `differenceInYears`, etc.
  - Add/Subtract: `add`, `sub`, `addDays`, `subDays`, `addMonths`, etc.
  - Getters/Setters: `getYear`, `setYear`, `getMonth`, `setMonth`, etc.
  - Period: `startOfDay`, `endOfDay`, `startOfMonth`, `endOfMonth`, `startOfYear`, `endOfYear`
- **chalk** (`npm/chalk`) - Terminal styling
- **dotenv** (`npm/dotenv`) - Environment variable management
- **chokidar** (`npm/chokidar`) - File watching with typed event handlers
- **ajv** (`npm/ajv`) - JSON Schema validation

#### Object APIs
- **Object.defineProperty** - Define property with labeled arguments (`value?`, `writable?`, `enumerable?`, `configurable?`, `get?`, `set?`)
- **Object.defineProperties** - Define multiple properties at once
- **Object.getOwnPropertyDescriptor** - Get property descriptor
- **Object.getOwnPropertyDescriptors** - Get all property descriptors
- **Object.getOwnPropertyNames** - Get all property names
- **Object.getOwnPropertySymbols** - Get all symbol properties
- **Object.groupBy** - Group array elements by callback result
- **PropertyDescriptor struct** - Type-safe property descriptor representation

#### React
- **ErrorBoundary component** - DSL-friendly error boundary with `children~`, `fallback?`, `on_error?` parameters
- **hydrateRoot** - Client-side hydration API
- **createPortal** - Portal rendering support
- **react-dom/static** - Static rendering APIs
- Replace `EmptyProps` with `Unit` for props-less components

#### WebGPU API (Experimental)
- **`web/webgpu`** - Comprehensive WebGPU bindings
  - Core: `GPU`, `GPUAdapter`, `GPUDevice`
  - Resources: `GPUBuffer`, `GPUTexture`, `GPUTextureView`
  - Commands: `GPUQueue`, `GPUCommandEncoder`, `GPUCommandBuffer`
  - Passes: `GPURenderPassEncoder`, `GPUComputePassEncoder`
  - Pipelines: `GPURenderPipeline`, `GPUComputePipeline`
  - Other: `GPUShaderModule`, `GPUSampler`, `GPUBindGroup`, `GPUBindGroupLayout`
  - Buffer/Texture usage flag constants

#### Node.js APIs
- **`node/assert_strict`** - Strict assertion mode module
  - `equal()` uses `===` comparison (maps to `strictEqual`)
  - `deepEqual()` uses strict comparison (maps to `deepStrictEqual`)
- **assert module extensions** - Added missing functions:
  - `deepStrictEqual()`, `notDeepStrictEqual()`, `ifError()`

#### Core
- **`Any::get_property`** and **`Any::set_property`** - Property access methods with `_[_]` operator aliases

### Testing
- Added WebGPU tests for Deno with graceful skipping for unsupported environments
- Added Web Worker tests for Deno runtime
- Comprehensive AI SDK type tests

---

## [0.5.0] - 2025-11-25

### Breaking Changes

#### Async Function Conversion
- **Promise-returning functions → `async fn`** - Major API change for async operations
  - Functions that returned `@js.Promise[T]` now return `T` directly using `async fn`
  - Callers no longer need `.wait()` - values are awaited automatically
  - Migration: Remove `.wait()` calls from affected function results

  **Affected packages:**
  - `web/http`: `fetch`, `fetch_request`, `Request::json/text/arraybuffer/blob/bytes`, `Response::json/text/formData/bytes`
  - `web/crypto`: All `SubtleCrypto` methods (`encrypt`, `decrypt`, `sign`, `verify`, `digest`, `generateKey`, `importKey`, `exportKey`, `wrapKey`, `unwrapKey`, `deriveKey`, `deriveBits`)
  - `web/streams`: `ReadableStream::cancel/pipeTo`, `ReadableStreamDefaultReader::read`, `WritableStream::abort/close`, `WritableStreamDefaultWriter::write/close`
  - `web/blob`: `Blob::arrayBuffer/text`
  - `browser/dom`: `CustomElementRegistry::whenDefined`, `Window::fetch`, `HTMLCanvasElement::toBlob`
  - `browser/canvas`: `createImageBitmapRect`, `OffscreenCanvas::convertToBlob`
  - `browser/file`: `File::arrayBuffer/text`
  - `npm/hono`: `ClientEndpoint::get_/post_/put_/delete_/patch_`
  - `npm/react`: `act`
  - `npm/react_dom_server`: `renderToReadableStream`
  - `npm/react_testing_library`: All `Screen::findBy*` and `Screen::findAllBy*` methods

  ```moonbit
  // Before (v0.4.0)
  let response = fetch("https://example.com", method_="GET").wait()
  let json = response.json().wait()

  // After (v0.5.0)
  let response = fetch("https://example.com", method_="GET")
  let json = response.json()
  ```

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

- **`from_entries*` → `from_map` / `from_option_map`** - Removed deprecated object creation functions
  - `@js.from_entries()` removed - Use `@js.from_map()` instead
  - `@js.from_entries_option()` removed - Use `@js.from_option_map()` instead
  - `@js.from_entries_option_cast()` removed - Use `@js.from_option_map()` instead
  - `ToMapValue` trait removed
  - Migration: Replace `from_entries([("key", value)])` with `from_map({ "key": @js.any(value) })`
  - New: `@js.from_option_map_or_undefined()` returns `undefined` if all properties are `None`

- **Naming convention: camelCase for JS API wrappers** - Standardized function names
  - Functions now use camelCase (matching JS APIs), with snake_case aliases for compatibility
  - `File::array_buffer` → `File::arrayBuffer` (alias: `array_buffer`)
  - `FileReader::read_as_*` → `FileReader::readAs*` (aliases available)
  - `Response::form_data` → `Response::formData` (alias: `form_data`)
  - `MessagePort::post_message*` → `MessagePort::postMessage*` (aliases available)
  - `URLSearchParams::get_all` → `URLSearchParams::getAll` (alias: `get_all`)
  - `Worker::post_message_with_transfer` → `Worker::postMessageWithTransfer`
  - `Command::output_sync` → `Command::outputSync` (alias: `output_sync`)
  - `CloudflareContext::wait_until` → `CloudflareContext::waitUntil`
  - `CloudflareContext::pass_through_exception` → `CloudflareContext::passThroughOnException`

- **`dynamic_import_async` → `dynamic_import`** - Renamed async import functions
  - `@react.dynamic_import_async()` → `@react.dynamic_import()`
  - `@react_router.dynamic_import_async()` → `@react_router.dynamic_import()`
  - `@react_dom_client.dynamic_import_async()` → `@react_dom_client.dynamic_import()`

- **`import_react_dom_client` removed** - Use `@react_dom_client.dynamic_import()` instead

### Added

- **Deno.Command API** - Subprocess management for Deno runtime
  - `Command::new(program, args?, cwd?, env?, stdin?, stdout?, stderr?)` - Create subprocess command
  - `Command::output()` - Run command and get output (async)
  - `Command::outputSync()` - Run command synchronously
  - `Command::spawn()` - Spawn child process
  - `CommandOutput` - Output with `stdout`, `stderr`, `success`, `code`, `signal`
  - `CommandStatus` - Status with `success`, `code`, `signal`
  - `ChildProcess` - Process handle with `status()`, `pid`, `stdin`, `stdout`, `stderr`, `ref_()`, `unref()`, `kill()`
- **`Js::cast()` method** - Type-safe casting for JavaScript values
- **`@js.from_option_map_or_undefined()`** - Returns `undefined` if all properties are `None`
  - Useful for JS APIs that distinguish between missing options object and empty options
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

## Historical Changes (v0.3.0 - v0.4.0)

These features were added between v0.3.0 and v0.4.0.

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

#### Remove .wait() from async functions

All Promise-returning functions are now `async fn` and return values directly:

```moonbit
// Before (v0.4.0)
async test "fetch example" {
  let response = fetch("https://api.example.com", method_="GET").wait()
  let data = response.json().wait()
  let text = response.text().wait()
}

// After (v0.5.0)
async test "fetch example" {
  let response = fetch("https://api.example.com", method_="GET")
  let data = response.json()
  let text = response.text()
}
```

This applies to all packages listed in the "Async Function Conversion" breaking changes section above.

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

#### Replace from_entries with from_map

```moonbit
// Before (v0.4.0)
let obj = @js.from_entries([("name", "Alice"), ("age", 30)])
let opts = @js.from_entries_option([("timeout", Some(1000)), ("retries", None)])

// After (v0.5.0)
let obj = @js.from_map({ "name": @js.any("Alice"), "age": @js.any(30) })
let opts = @js.from_option_map({ "timeout": Some(@js.any(1000)), "retries": None })

// New: returns undefined if all properties are None
let opts = @js.from_option_map_or_undefined({ "timeout": None, "retries": None })
// Returns undefined instead of {}
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
