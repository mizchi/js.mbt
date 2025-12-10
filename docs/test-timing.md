# Node.js Test Timing Report

Measured on 2025-12-10.

## Summary

All `@core.sleep` calls have been replaced with event-based waiting using `@core.suspend` for more reliable and faster tests.

## Optimizations Applied

### 1. `src/node/http` - ✅ Optimized
- Replaced `@core.sleep` with `@core.suspend` and server listening/close callbacks
- **Before:** 1.538s → **After:** ~0.4s

### 2. `src/node/net` - ✅ Optimized
- Replaced `@core.sleep(96)` and `@core.sleep(48)` with event-based listening
- Uses `server.listen()` callback and `once("close")` event

### 3. `src/node/stream` - ✅ Optimized
- Replaced 14 instances of `@core.sleep(16-32)` with event-based waiting
- Uses `once("finish")`, `once("close")` events on streams
- Uses `setImmediate` for synchronous completion confirmation

### 4. `src/node/events` - ✅ Optimized
- Removed unnecessary `@core.sleep` from EventEmitter tests
- EventEmitter.emit() is synchronous - no waiting needed for most tests
- Uses `setImmediate` for Promise coordination tests

## Pattern Used

```moonbit
// Before (slow, unreliable)
server.listen(0, host="127.0.0.1") |> ignore
@core.sleep(100)

// After (fast, reliable)
@core.suspend(fn(resolve, _reject) {
  server.listen(0, host="127.0.0.1", callback=() => resolve(())) |> ignore
})
```

## Test Results

- Total tests: 1292
- All passed
- Total time: ~18.5s (parallelized)
