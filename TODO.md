## ESM Migration Progress

Migrating to `#module` for tree-shaking support. See CLAUDE.md for usage details.

**Goal**: Eliminate all `require()` calls → `git grep 'require('` should return nothing.

### Frontend Libraries (High Priority - Tree-shaking)

- [x] react - jsx/jsxs from react/jsx-runtime
- [x] react_element - uses @react.createElementWithKey (jsx runtime internally)
- [x] react_dom_client - createRoot, hydrateRoot
- [ ] react_router - **Blocked**: RouterProvider is a component, not a function. Uses `init_global()` workaround.
- [ ] preact
- [ ] vue

### Node.js Built-ins (High Priority - ESM behavior changes)

These use `require()` which behaves differently in ESM. Migrate to `#module("node:xxx")`.

- [x] node:path - join2, dirname, extname, isAbsolute, normalize, relative, parse, format, etc.
  - Note: `join/resolve` (variadic), `delimiter/sep` (properties) still use require()
- [x] node:fs - existsSync, unlinkSync, createReadStream, createWriteStream, etc.
  - Note: Functions with optional args (readFileSync with encoding, mkdir with recursive, etc.) still use require()
- [x] node:process - cwd, chdir, exit, nextTick
  - Note: Property access (env, argv, stdin, stdout, stderr) still uses require()
- [x] node:os - arch, cpus, homedir, hostname, platform, tmpdir, totalmem, uptime, etc.
  - Note: Properties (EOL, devNull) and functions with optional args still use require()
- [x] node:module - createRequire, isBuiltin, syncBuiltinESMExports, findSourceMap, etc.
  - Note: builtinModules (property) and stripTypeScriptTypes (optional args) still use require()
- [x] node:net - isIPv4, isIPv6, isIP
  - Note: createConnection, createServer (optional args) still use require()
- [x] node:stream - addAbortSignal, isErrored, isReadable, isWritable, getDefaultHighWaterMark, etc.
  - Note: Class static methods and variadic functions still use require()
- [x] node:inspector - close, url, waitForDebugger
  - Note: Session class and open() (optional args) still use require()
- [ ] node:buffer - **Blocked**: Buffer class static methods
- [ ] node:http - **Blocked**: All functions have callbacks/optional args
- [ ] node:sqlite - **Blocked**: Database class constructor
- [ ] node:vm - runInContext, Script, etc.
- [ ] node:child_process - exec, spawn, etc.
- [ ] node:url - URL, URLSearchParams
- [ ] node:crypto - randomBytes, createHash, etc. (if exists)

### npm Libraries (High/Medium Priority)

- [x] zod - schema validation (high priority)
  - Note: `coerce_*` functions still use `require()` because `coerce` is an object, not a function export
- [ ] hono - web framework (high priority, but `new Hono()` requires workaround)
  - Migrate non-constructor parts first (middleware, context helpers, etc.)
- [ ] msw - mock service worker (high priority)
- [ ] pino - logger (high priority)
- [ ] debug - debug utility (high priority)
- [ ] semver - version parsing (high priority)
- [ ] vite - build tool (high priority)
- [ ] vitest - test runner (high priority)
- [ ] drizzle - database ORM
- [ ] jose - JWT/JWE/JWS
- [ ] date_fns - date utilities

### Testing Libraries (Low Priority - Node.js only)

- [ ] testing_library_react
- [ ] testing_library_preact

---

## Known Issues

### jose package: Async test PanicError (2025-12-08)

**Problem**: Three async tests in `src/npm/jose/jose_test.mbt` cause PanicError in async driver:
- `JWS compact sign and verify`
- `JWE compact encrypt and decrypt`
- `Generate secret key`

**Error**:
```
$PanicError
    at $bytes_literal$0 (/Users/mizchi/.moon/lib/core/builtin/hasher.mbt:1:1)
    at moonbitlang$core$option$$Option$unwrap$7$ (/Users/mizchi/.moon/lib/core/builtin/option.mbt:38:13)
```

**Temporary Fix**: Tests are commented out with `// FIXME:` comments

**Working Tests**:
- ✅ JWT sign and verify
- ✅ JWT with expiration and issuer
- ✅ base64url encode/decode
- ✅ Decode JWT without verification
- ✅ Decode protected header

**TODO**:
- [ ] Investigate root cause of async driver panic
- [ ] Fix JWS compact sign implementation (payload should be Uint8Array)
- [ ] Fix JWE compact encrypt implementation
- [ ] Re-enable commented tests after async driver issue is resolved
