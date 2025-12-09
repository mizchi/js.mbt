## ESM Migration Progress

Migrating to `#module` for tree-shaking support. See CLAUDE.md for usage details.

### Frontend Libraries (High Priority - Tree-shaking)

- [x] react - jsx/jsxs from react/jsx-runtime
- [x] react_element - uses @react.createElementWithKey (jsx runtime internally)
- [ ] react_dom_client - createRoot, hydrateRoot
- [ ] react_router - **Blocked**: RouterProvider is a component, not a function. Uses `init_global()` workaround.
- [ ] preact
- [ ] vue

### Node.js Built-ins (High Priority - ESM behavior changes)

These use `require()` which behaves differently in ESM. Migrate to `#module("node:xxx")`.

- [ ] node:fs - readFileSync, writeFileSync, etc.
- [ ] node:path - join, resolve, dirname, etc.
- [ ] node:process - env, cwd, argv, etc.
- [ ] node:vm - runInContext, Script, etc.
- [ ] node:child_process - exec, spawn, etc.
- [ ] node:url - URL, URLSearchParams
- [ ] node:buffer - Buffer
- [ ] node:os - platform, homedir, etc.
- [ ] node:crypto - randomBytes, createHash, etc. (if exists)

### npm Libraries (High/Medium Priority)

- [ ] zod - schema validation (high priority)
- [ ] hono - web framework (high priority, but `new Hono()` requires workaround)
  - Migrate non-constructor parts first (middleware, context helpers, etc.)
- [ ] drizzle - database ORM
- [ ] jose - JWT/JWE/JWS
- [ ] date_fns - date utilities

### Testing Libraries (Low Priority - Node.js only)

- [ ] testing_library_react
- [ ] testing_library_preact
- [ ] vitest

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
