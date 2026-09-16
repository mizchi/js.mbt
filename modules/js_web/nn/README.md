# mizchi/js_web/nn

MoonBit bindings for the [WebNN API](https://www.w3.org/TR/webnn/) — the Web
Neural Network API, `navigator.ml`.

These are the **spec-level** bindings only: graph construction, compilation,
device tensors and dispatch. Model formats, shape inference and inference
runtimes belong a layer up — see
[`mizchi/webnn-mbt`](https://github.com/mizchi/webnn-mbt), which builds a
LiteRT/TFLite runtime on top of this package.

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_web@0.13.1",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_core" @core,
  "mizchi/js_web/nn",
}
```

## Feature detection

`ml()` returns `None` where WebNN is unavailable, so it doubles as the feature
test — it does not throw off-browser.

```moonbit
///|
pub async fn context() -> @nn.MLContext? {
  guard @nn.ml() is Some(ml) else { return None }
  let options = @nn.context_options(@nn.uses_accelerated_contract(), "gpu")
  Some(ml.create_context(options))
}
```

The two-step dance with `uses_accelerated_contract` is there because the spec
replaced the `{deviceType}` context hint with a boolean `{accelerated}`, and
implementations shipped that change at different times. `context_options`
builds whichever shape the current implementation expects, so callers do not
have to care.

Contexts differ in what else they offer, and the probes report it rather than
guessing:

| Probe | Question |
|-------|----------|
| `MLContext::has_tensor_io` | Are `createTensor` / `writeTensor` / `readTensor` / `dispatch` available, or is this an older `compute()`-only build? |
| `MLContext::has_op_support_limits` | Does it report `opSupportLimits()` at all? |
| `MLContext::preferred_input_layout` | "nchw" or "nhwc" — falls back to "nchw" when unreported |
| `MLContext::supported_operators` | Which of the given candidates it supports |
| `MLContext::op_support_limits` | The whole limits object, for anything the above do not cover |

`supported_operators` returns an empty array where limits are unavailable, so
treat empty as **unknown**, not "nothing supported".

## Building and running a graph

```moonbit
///|
/// y = relu(x * w + b) over a 1x4 input, then read the result back.
pub async fn run(ctx : @nn.MLContext) -> Array[Float] {
  let builder = @nn.MLGraphBuilder(ctx)
  let x = builder.input("x", [1, 4])
  let w = builder.constant_float32([4, 4], Array::make(16, 0.5))
  let b = builder.constant_float32([1, 4], Array::make(4, 0.1))
  let y = builder.relu(builder.add(builder.matmul(x, w), b))
  let graph = builder.build("y", y)

  // device-side tensors: one writable in, one readable out
  let input = ctx.create_tensor([1, 4], true, false)
  let output = ctx.create_tensor([1, 4], false, true)
  ctx.write_tensor(input, [1.0, 2.0, 3.0, 4.0])
  ctx.dispatch_single(graph, "x", input, "y", output)
  let values = ctx.read_tensor(output)
  input.destroy()
  output.destroy()
  graph.destroy()
  values
}
```

A builder is spent once built — make a new one for the next graph. `dispatch`
returns immediately; reading an output tensor is what awaits the result.

## Operators

Named wrappers cover the set needed to lower LiteRT and transformer graphs:

| Group | Operators |
|-------|-----------|
| Binary | `add` `sub` `mul` `div` `matmul` |
| Unary | `relu` `sigmoid` `tanh` `gelu` `clamp` `softmax` |
| Shape | `reshape` `transpose` `concat` `slice` `gather` |
| Reduction | `reduce_mean` |
| Normalization | `layer_normalization` |
| Convolution | `conv2d` `max_pool2d` `average_pool2d` |

The spec defines many more. Rather than wait for a named binding, reach any of
them through the escape hatch — it is the same call the wrappers make:

```moonbit
///|
pub fn abs_and_pad(
  builder : @nn.MLGraphBuilder,
  x : @nn.MLOperand,
) -> @nn.MLOperand {
  let a = builder.op("abs", [x.as_any()])
  builder.op_with_options(
    "pad",
    [a.as_any(), @core.any([1, 1]), @core.any([1, 1])],
    @core.from_entries([("mode", @core.any("constant"))]),
  )
}
```

## Data types

The float32 path has named helpers (`input`, `constant_float32`,
`create_tensor`, `write_tensor`, `read_tensor`). For anything else there is an
`_of` / `_raw` variant that takes a spec data-type string — "float16",
"int32", "uint32", "int64", "uint64", "int8", "uint8", "int4", "uint4":

```moonbit
///|
pub fn token_ids(
  builder : @nn.MLGraphBuilder,
) -> @nn.MLOperand {
  builder.input_of("input_ids", "int32", [1, 128])
}
```

`descriptor` builds an `MLOperandDescriptor` directly if you need one. It sets
both `shape` and the older `dimensions` key, since implementations shipped that
rename at different times.

## Testing

`moon test` runs under Node, which has no `navigator.ml`, so the suite covers
what does not need an implementation: both context-option shapes, descriptor
and named-value construction, the typed-array round trips, the capability
probes, and how every builder argument is marshalled — checked against a spy
object that records the calls. Anything needing a real device has to run in a
browser.

## Reference

- [WebNN specification](https://www.w3.org/TR/webnn/)
- [MLGraphBuilder operators](https://www.w3.org/TR/webnn/#api-mlgraphbuilder)
- [WebNN Developer Preview](https://webnn.io/)

See the [User Guide](../../../docs/guide.md) for picking modules and aliases.
