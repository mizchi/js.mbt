# Bundle Size Analysis

This document analyzes the bundle size of MoonBit JavaScript output, identifying the main contributors to code size and potential optimization opportunities.

**Note:** The analyzed output is after terser DCE (Dead Code Elimination) with compress enabled. Unused code has already been removed.

## Analysis Target

**Example: aisdk** (AI SDK streaming example)
- Source: 24 lines of MoonBit (`src/examples/aisdk/main.mbt`)
- Output: 115,183 bytes (raw JS)

### Input Source Code

**main.mbt:**

```moonbit
async fn main {
  // Load environment variables
  @dotenv.config() |> ignore
  println("[ai] Starting stream...")
  // Start streaming
  let stream = @ai.stream_text(
    model=@ai.anthropic("claude-sonnet-4-20250514"),
    prompt="Count from 1 to 10, one number per line",
  )
  // Iterate over text chunks
  let text_iter = stream.text_stream()
  let stdout = @process.stdout()
  while true {
    match text_iter.next() {
      Some(chunk) => stdout.write(chunk) |> ignore
      None => break
    }
  }
  println("\n\n[ai] Stream complete!")
  // Get final usage stats
  let usage = stream.usage()
  println("Tokens used: \{usage.total_tokens.to_string()}")
}
```

**moon.pkg.json:**

```json
{
  "is-main": true,
  "import": [
    "mizchi/js",
    "mizchi/js/node/process",
    "mizchi/js/node/tty",
    "mizchi/js/npm/ai",
    "mizchi/js/npm/dotenv",
    "moonbitlang/async"
  ]
}
```

## Size Breakdown

| Category | Size | Percentage |
|----------|------|------------|
| mizchi$js bindings (excluding vtable) | 48,849 bytes | 42.4% |
| vtable inline expansion | 33,203 bytes | 28.8% |
| MoonBit runtime (core+async) | 19,875 bytes | 17.3% |
| Others (helpers/types) | 9,545 bytes | 8.3% |
| main.mbt (user code) | 2,680 bytes | 2.3% |
| Unclassified | 1,031 bytes | 0.9% |

### MoonBit Runtime Details

| Component | Size | Notes |
|-----------|------|-------|
| moonbitlang$core | 15,010 bytes | Map, Deque, Hasher, etc. |
| moonbitlang$async | 4,865 bytes | Coroutine scheduler |

### mizchi$js Binding Details

| Component | Size | Notes |
|-----------|------|-------|
| mizchi$js$npm (ai, dotenv) | 45,195 bytes | NPM package bindings |
| mizchi$js (core) | 34,534 bytes | Core JS interop |
| mizchi$js$node (process) | 2,323 bytes | Node.js bindings |

### vtable Breakdown

| Type | Count | Size per instance | Total |
|------|-------|-------------------|-------|
| JsImpl vtable (13 methods) | 48 | ~558 bytes | 26,799 bytes |
| PropertyKey vtable | 100 | ~64 bytes | 6,404 bytes |

## Key Findings

### 1. Bindings + vtable account for 71.2%

The JavaScript interop layer dominates bundle size:
- Binding logic: 48,849 bytes (42.4%)
- vtable inline expansion: 33,203 bytes (28.8%)

### 2. MoonBit runtime is relatively small (17.3%)

The core runtime includes:
- Data structures for async (Map, Deque)
- Hash functions
- Coroutine scheduler

### 3. User code is only 2.3%

24 lines of MoonBit compiles to 2,680 bytes, but the remaining 97.7% is runtime and bindings.

## Source Code Structure

### JsImpl Trait with Default Implementations

The binding layer uses a trait with default method implementations (`src/impl.mbt`):

```moonbit
pub(open) trait JsImpl {
  to_any(Self) -> Any = _
  get(Self, &PropertyKey) -> Any = _
  set(Self, &PropertyKey, &JsImpl) -> Unit = _
  call(Self, &PropertyKey, Array[&JsImpl]) -> Any = _
  call0(Self, &PropertyKey) -> Any = _
  call1(Self, &PropertyKey, &JsImpl) -> Any = _
  call2(Self, &PropertyKey, &JsImpl, &JsImpl) -> Any = _
  call_throwable(Self, &PropertyKey, Array[&JsImpl]) -> Any raise ThrowError = _
  call_self(Self, Array[&JsImpl]) -> Any = _
  call_self0(Self) -> Any = _
  call_self_throwable(Self, Array[&JsImpl]) -> Any raise ThrowError = _
  delete(Self, &PropertyKey) -> Unit = _
  hasOwnProperty(Self, &PropertyKey) -> Bool = _
}

impl JsImpl with get(self, key : &PropertyKey) -> Any {
  ffi_get(self.to_any(), key.to_key() |> identity)
}

impl JsImpl with set(self, key : &PropertyKey, val : &JsImpl) -> Unit {
  ffi_set(self.to_any(), key.to_key() |> identity, val.to_any())
}
```

### FFI Definitions

The FFI layer (`src/ffi.mbt`) provides simple JavaScript operations:

```moonbit
extern "js" fn ffi_get(obj : Any, key : String) -> Any =
  #| (obj, key) => obj[key]

extern "js" fn ffi_set(obj : Any, key : String, value : Any) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

extern "js" fn ffi_call0(obj : Any, key : String) -> Any =
  #| (obj, key) => obj[key]()

extern "js" fn ffi_call1(obj : Any, key : String, arg1 : Any) -> Any =
  #| (obj, key, arg1) => obj[key](arg1)
```

## Main Issues

### Issue 1: vtable Inline Expansion (Biggest Impact)

When using trait objects (`&JsImpl`), the compiler generates a vtable for each call site.
Every JS value operation creates a vtable object inline:

```javascript
// Current: 558 bytes per instance
{
  self: value,
  method_0: mizchi$js$$JsImpl$to_any$9$,
  method_1: mizchi$js$$JsImpl$get$9$,
  method_2: mizchi$js$$JsImpl$set$9$,
  // ... 10 more methods
  method_12: mizchi$js$$JsImpl$hasOwnProperty$9$
}
```

This 13-method vtable is expanded inline 48 times.

**Example from generated code:**

```javascript
// A simple promise.then().catch() generates ~400 bytes:
mizchi$js$$JsImpl$call1$9$(
  mizchi$js$$JsImpl$call1$15$(self,
    { self: "then", method_0: mizchi$js$$PropertyKey$to_key$3$ },
    { self: _cont, method_0: ..., method_1: ..., ..., method_12: ... }
  ),
  { self: "catch", method_0: mizchi$js$$PropertyKey$to_key$3$ },
  { self: _err_cont, method_0: ..., method_1: ..., ..., method_12: ... }
);
```

### Issue 2: PropertyKey Wrapping

Simple string keys are wrapped in objects:

```javascript
// Current: 64 bytes
{ self: "model", method_0: mizchi$js$$PropertyKey$to_key$3$ }

// Could be: 7 bytes
"model"
```

## Optimization Opportunities

### 1. vtable Sharing (Potential: -26.7%)

Share vtable objects instead of inline expansion:

```javascript
// Define once
const JsImpl$vtable$9 = {
  method_0: mizchi$js$$JsImpl$to_any$9$,
  method_1: mizchi$js$$JsImpl$get$9$,
  // ...
};

// Use reference
{ self: value, ...JsImpl$vtable$9 }
// or
{ self: value, $v: JsImpl$vtable$9 }
```

**Estimated savings: ~30,763 bytes (26.7%)**

### 2. Direct FFI for Simple Operations

For simple property access/calls, generate direct code:

```javascript
// Current
mizchi$js$$JsImpl$get$9$(obj, { self: "key", method_0: ... })

// Optimized
obj["key"]
```

### 3. Eliminate PropertyKey Wrapper

Pass strings directly instead of wrapping:

```javascript
// Current
{ self: "key", method_0: mizchi$js$$PropertyKey$to_key$3$ }

// Optimized
"key"
```

## Optimization Priority

1. **vtable sharing** - Highest impact, 28.8% of bundle
2. **PropertyKey simplification** - 5.6% of bundle
3. **Direct FFI generation** - Reduces binding code complexity
4. **Runtime tree-shaking** - Remove unused Map/Set operations

## Running the Analysis

```bash
# Build examples
moon build --target js

# Generate size report with output files
./scripts/check_sizes.ts --output-files

# Run analysis script
node tmp/analyze_size.js
```

## Related Files

- `scripts/check_sizes.ts` - Bundle size measurement tool
- `tmp/check-sizes/*/` - Output files for inspection
- `.bundle_size_baseline.json` - Size baseline for comparison
