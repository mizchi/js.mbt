# FFI Performance Analysis - mizchi/js

## Benchmark Results

### Function Call Overhead

| Operation | Time | Description |
|-----------|------|-------------|
| **direct FFI call (ffi_call0)** | 0.00 µs | Direct FFI invocation (baseline) |
| **JsImpl call0 method** | 0.01 µs | Call through trait |
| **call1 with Int** | 0.01 µs | Single argument call with to_js conversion |
| **call2 with two Ints** | 0.02 µs | Two argument call |
| **call with Array[Int] (5 elements)** | 0.04 µs | Array with map conversion |
| **call with Array[Js] (pre-converted)** | 0.02 µs | Pre-converted array |

**Key Findings:**
- Array conversion overhead: **0.04 µs vs 0.02 µs (2x slower)**
- Pre-converting arrays to `Array[Js]` yields 50% speedup

### Object Operation Overhead

| Operation | Time | Description |
|-----------|------|-------------|
| **Object::new()** | 0.01 µs | Object creation |
| **Object set (1 property)** | 0.01 µs | Set single property |
| **Object set (5 properties)** | 0.06 µs | Set 5 properties |
| **Object get** | 0.01 µs | Property access |
| **Object::keys** | 0.07 µs | Get object keys |

**Key Findings:**
- Property setting scales linearly: 1 prop = 0.01µs, 5 props = 0.06µs → **~0.012µs per property**
- Object::keys is relatively expensive (0.07 µs)

### Type Conversion Overhead

| Operation | Time | Description |
|-----------|------|-------------|
| **Int to_js conversion** | 0.01 µs | Same as identity |
| **String to_js conversion** | 0.01 µs | Same as identity |
| **identity Int to Js** | 0.01 µs | Baseline |
| **from_array (5 Ints)** | 0.01 µs | Array conversion |
| **Array map to_js (5 Ints)** | 0.01 µs | Manual map |
| **from_map (5 entries)** | 0.10 µs | Map→Object conversion |

**Key Findings:**
- `to_js()` has same cost as `identity` (compiler optimized)
- `from_array` is very fast (0.01µs for 5 elements)
- `from_map` is relatively expensive (0.10µs): requires Object::set per entry

### Complex Operations

| Operation | Time | Description |
|-----------|------|-------------|
| **create nested object (realistic)** | 0.11 µs | Nested object creation |
| **chained method calls** | 0.07 µs | Method chain (3 calls) |

**Key Findings:**
- Complex nested object creation: 0.11 µs
  - Breakdown: 2 Objects + property sets + from_array
- Method chaining is cumulative: 3 calls = 0.07µs

## Optimization Opportunities

### 1. Optimize High-Frequency Array Operations

**Problem:**
```moonbit
// Current: call() converts array via map every time
impl JsImpl with call(self, key, args) -> Js {
  ffi_call(self.to_js(), key.to_key() |> identity, args.map(_.to_js()))
}
```

**Optimization Strategy:**
- Use specialized functions (call1, call2, call3) for small argument counts
- Skip conversion when already `Array[Js]`

**Expected Impact:** 50% speedup for 5-element arrays (0.04µs → 0.02µs)

### 2. Minimize Object::keys() Usage

**Problem:**
- Object::keys() is relatively expensive (0.07µs)
- Attempted optimization in React element creation (keys check before Object::assign) was counterproductive

**Recommendation:**
- Avoid keys checks
- Use only when absolutely necessary

### 3. from_map Optimization Not Needed

**Rationale:**
- from_map is already reasonably optimized (0.10µs / 5 entries = 0.02µs/entry)
- Object::set call cost is dominant

### 4. Prefer call1/call2 When Possible

**Recommended Pattern:**
```moonbit
// Good: Use specialized methods
obj.call1("method", arg)

// Avoid: Array map overhead
obj.call("method", [arg])
```

**Impact:** ~2x faster for small argument counts

## Lessons Applied from React Element Creation

Lessons learned from previous React optimization:
1. ✅ **Small allocation removal is effective**: Removing drag_handlers array yielded 5-11% improvement
2. ✅ **Conditional checks are expensive**: Object::keys().length() check was counterproductive
3. ✅ **Measurement is critical**: Intuitive optimizations don't always work

Consistency with FFI analysis:
- Object::keys costs 0.07µs (relatively expensive) → adding checks is counterproductive
- Small array removal (7 elements) benefit > keys() check cost
- Validation through measurement was correct

## Conclusions

The mizchi/js FFI is very well optimized:
- Basic operations are 0.01-0.02µs (extremely fast)
- `to_js()` equals `identity` (compiler optimized)
- Main bottlenecks:
  1. **Array map conversion** (use specialized methods when avoidable)
  2. **Object::keys()** (use only when necessary)
  3. **from_map()** (unavoidable cost, but reasonable)

**Recommendations:**
1. Use `call1`/`call2` for function calls with few arguments
2. Minimize `Object::keys()` calls
3. Optimize high-frequency Object creation patterns (see React element creation example)
4. Avoid unnecessary array allocations

**Optimization Priority:**
- ✅ High: Remove unnecessary array allocations
- ⚠️ Medium: Use call/call1/call2 appropriately (tradeoff with code size)
- ❌ Low: Add Object::keys() checks (likely counterproductive)

## Benchmark Details

All benchmarks were run using MoonBit's `moon bench` command with the following methodology:
- Target: JavaScript
- Mode: Release build
- Each benchmark runs multiple iterations to establish statistical significance
- Results show mean time ± standard deviation with min/max range

### Test Environment
- File: `src/js_bench.mbt`
- Package: `mizchi/js`
- Total benchmarks: 21
- All tests passed

### Benchmark Categories

1. **Function Call Overhead** (6 tests): Measures FFI call overhead and argument conversion costs
2. **Object Operations** (5 tests): Measures object creation and property manipulation
3. **Type Conversions** (7 tests): Measures conversion costs between MoonBit and JavaScript types
4. **Complex Operations** (2 tests): Measures realistic usage patterns
5. **Utility Operations** (1 test): Measures type checking operations

## Related Optimizations

See also:
- `benchmark_results.md` - React element creation optimization results
- `element_bench.mbt` - React element benchmarks showing real-world application of these principles
