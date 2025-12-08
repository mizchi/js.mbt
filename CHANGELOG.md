# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.8] - 2025-12-08

### Changed

#### MSW (Mock Service Worker) Refactoring
- **Split platform-specific code**: Separated `msw.mbt` into three modules:
  - `msw.mbt` - Common functionality (HTTP handlers, response builders)
  - `msw_node.mbt` - Node.js specific API (`SetupServer`)
  - `msw_browser.mbt` - Browser specific API (`SetupWorker`)
- **Enhanced type definitions**: Added detailed TypeScript-aligned types
  - `HttpResponse` options now support `status`, `statusText`, and `headers` parameters
  - All response functions (`json`, `text`, `html`, `xml`) now accept optional parameters
  - Added `WebSocketHandler` type for future WebSocket mocking support
- **Improved type safety**: Replaced `#external` types with `pub(all)` structs
  - `ResponseResolverInfo` now provides direct property access
  - Converted property accessor FFI functions to `pub extern "js"`
- **Simplified API**: Merged duplicate functions into single functions with optional parameters
  - Combined `json`/`jsonWithStatus` into single `json` function
  - Combined `server_listen`/`worker_start` variants

#### simple-git Refactoring
- **Enhanced type safety**: Converted `StatusResult` from `#external` to `pub(all)` struct
  - Direct field access for: `current`, `tracking`, `not_added`, `modified`, `staged`, `deleted`, `created`, `conflicted`, `ahead`, `behind`
  - Removed 10 FFI helper functions (`ffi_status_*`)
  - Kept `isClean()` as `extern "js"` (calls JavaScript method)
- **Unified FFI patterns**: Changed `as_any()` implementations from `extern "js"` to `"%identity"`
- **Comprehensive documentation**: Added detailed JSDoc comments
  - `simpleGit()`: Documented all constructor options (base_dir, binary, maxConcurrentProcesses, trimmed)
  - `commit()`: Documented message, files, and author parameters
  - `push()`: Documented remote, branch, set_upstream, force, tags options
  - `pull()`: Documented remote and branch options
  - Added usage examples for major functions

#### htmlparser2 Refactoring
- **Improved type safety**: Replaced `#external` types with `pub(all)` structs
  - `Document`, `Element`, and `Node` now support direct property access
  - Better type safety with explicit field types
- **Simplified API**: Merged duplicate functions
  - Combined `parseDocument`/`parseDocumentWithOptions`
  - Combined `createParser`/`createParserWithOptions`

### Technical Improvements
- Reduced FFI overhead by eliminating unnecessary wrapper functions
- Improved code maintainability with explicit type definitions
- Better IDE support through direct property access
- All tests passing: MSW (28), simple-git (15), htmlparser2 tests verified

## [0.8.6] - 2025-12-08

### Added

#### Bun Runtime Support
- Added comprehensive Bun runtime bindings in `src/bun/`
- Implemented Bun test runner integration with `Bun.test()` and `expect()` assertions
- All 29 tests passing successfully

#### Bun Process & Command Execution APIs
- `Bun.spawn()` - Asynchronously spawn child processes
- `Bun.spawnSync()` - Synchronously spawn child processes
- `Subprocess` type with full process management:
  - `pid()` - Get process ID
  - `exitCode()` - Get exit code
  - `stdin()`, `stdout()`, `stderr()` - Stream access
  - `kill()` - Terminate process
  - `exited()` - Wait for process completion
- `SpawnOptions` - Configure process spawn options (cmd, cwd, env, stdio)

#### Bun Utility Functions
- `Bun.which()` - Find executables in PATH
- `Bun.escapeHTML()` - HTML string sanitization
- `Bun.stringWidth()` - Calculate display width of strings (supports multi-byte characters)
- `Bun.randomUUIDv7()` - Generate UUIDv7 identifiers
- `Bun.peek()` - Inspect Promise state

#### Bun Hashing & Cryptography APIs
- `Bun.hash()` - General-purpose hashing function
- `CryptoHasher` type for streaming hash computations:
  - `CryptoHasher::new()` - Create hasher (sha256, sha512, md5, etc.)
  - `update()` - Add data to hash
  - `digest_hex()` - Get hex string digest
  - `digest_base64()` - Get base64 digest
  - `digest_buffer()` - Get ArrayBuffer digest

#### Bun Glob API
- `Glob` type for file pattern matching:
  - `Glob::new()` - Create glob pattern matcher
  - `match_()` - Test string against pattern
  - `scan()` - Scan filesystem for matching files

#### Bun File & Environment APIs
- `Bun.file()` - File operations
- `Bun.write()` - Write data to files
- `Bun.cwd` - Current working directory
- `Bun.argv()` - Command-line arguments
- `Bun.env()` - Environment variables
- `Bun.version()` - Bun version
- `Bun.revision()` - Bun revision
- `is_bun()` - Detect Bun runtime

#### Additional Bun APIs
- `Bun.sleep()` - Async sleep function
- `Bun.nanoseconds()` - High-resolution timer
- `Bun.password.hash()` / `Bun.password.verify()` - Password hashing with bcrypt
- `Bun.serve()` - HTTP server creation
- `unlink_sync()` - File deletion

### Changed
- Updated `moon.mod.json` keywords to include "bun"

### Technical Details
- Implemented proper CPS (Continuation-Passing Style) handling for async functions in Bun test runner
- All Bun bindings follow the existing pattern used in Deno bindings
- Comprehensive test coverage with 29 passing tests
