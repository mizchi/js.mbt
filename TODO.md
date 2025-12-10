## ESM Migration (Blocked)

The following Node.js modules cannot use `#module` directive due to technical limitations:

- [ ] node:buffer - Buffer class static methods
- [ ] node:http - All functions have callbacks/optional args
- [ ] node:sqlite - Database class constructor

### `#module` Limitations

❌ Cannot use `#module`:
- **Class constructors**: `new Database()`, `new Session()`
- **Property access**: `path.delimiter`, `process.env`, `os.EOL`
- **Variadic functions**: `path.join(...args)`, `path.resolve(...args)`
- **Functions with optional args**: `readFileSync(path, encoding?)`, `mkdir(path, options?)`

---

## Known Issues

### Flaky tests with NEW_MOON=0 (2025-12-09)

**Problem**: Running `NEW_MOON=0 moon test` occasionally fails with PanicError in async driver:

**Error**:
```
$PanicError
    at $bytes_literal$0 (/Users/mizchi/.moon/lib/core/builtin/hasher.mbt:1:1)
    at *async_driver (/Users/mizchi/mizchi/js.mbt/src/core/promise.mbt:322:3)
```

**Note**: This appears to be a flaky test issue, not consistently reproducible. The error originates from the async driver in `src/core/promise.mbt:322`.

**TODO**:
- [ ] Identify which specific tests are flaky
- [ ] Investigate async driver stability with legacy moon runtime
