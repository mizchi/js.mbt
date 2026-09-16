// Tests for the WebNN bindings.
//
// Node has no `navigator.ml`, so these cover what does not need a real
// implementation: the two context-option shapes, descriptor and named-value
// construction, the typed-array round trips, the capability probes, and how
// builder arguments are marshalled -- checked against a spy that records every
// method called on it.

///|
/// Serialize a value so object shapes can be asserted whole.
extern "js" fn json_str(v : @core.Any) -> String =
  #| (v) => JSON.stringify(v)

///|
/// Records every method called on it as `{name, args}` under `calls`.
extern "js" fn make_spy() -> @core.Any =
  #| () => {
  #|   const calls = [];
  #|   const target = { calls };
  #|   return new Proxy(target, {
  #|     get(t, k) {
  #|       if (k in t) return t[k];
  #|       return (...args) => { t.calls.push({ name: k, args }); return { op: k }; };
  #|     },
  #|   });
  #| }

///|
fn spy_calls(spy : @core.Any) -> String {
  json_str(spy["calls"])
}

///|
/// A context stub. `limits` is the object `opSupportLimits()` returns, or null
/// to omit the method entirely; `tensor_io` adds the MLTensor methods.
extern "js" fn context_stub(limits : @core.Any, tensor_io : Bool) -> @core.Any =
  #| (limits, tensorIo) => {
  #|   const ctx = {};
  #|   if (limits !== null) ctx.opSupportLimits = () => limits;
  #|   if (tensorIo) {
  #|     ctx.createTensor = () => Promise.resolve({ tensor: true });
  #|     ctx.writeTensor = () => {};
  #|     ctx.readTensor = () => Promise.resolve(new Float32Array([1, 2]).buffer);
  #|     ctx.dispatch = () => {};
  #|   }
  #|   return ctx;
  #| }

///|
extern "js" fn js_null() -> @core.Any =
  #| () => null

///|
fn obj(entries : Array[(String, @core.Any)]) -> @core.Any {
  let o = @core.new_object()
  for e in entries {
    o._set(e.0, e.1)
  }
  o
}

///|
/// A builder stub whose `build` resolves, so the Promise plumbing is testable.
extern "js" fn builder_stub() -> @core.Any =
  #| () => ({
  #|   calls: [],
  #|   build(outputs) { this.calls.push({ name: "build", args: [outputs] }); return Promise.resolve({ graph: true }); },
  #| })

// =============================================================================
// Feature detection
// =============================================================================

///|
test "ml() reports absence rather than throwing off-browser" {
  // Node has no navigator.ml; this must be None, not a crash.
  assert_eq(ml() is None, true)
}

///|
test "context_options builds the accelerated shape" {
  // The newer contract takes a boolean; "cpu" means not accelerated.
  inspect(
    json_str(context_options(true, "gpu")),
    content=(
      #|{"accelerated":true}
    ),
  )
  inspect(
    json_str(context_options(true, "npu")),
    content=(
      #|{"accelerated":true}
    ),
  )
  inspect(
    json_str(context_options(true, "cpu")),
    content=(
      #|{"accelerated":false}
    ),
  )
}

///|
test "context_options builds the legacy deviceType shape" {
  inspect(
    json_str(context_options(false, "gpu")),
    content=(
      #|{"deviceType":"gpu"}
    ),
  )
  inspect(
    json_str(context_options(false, "cpu")),
    content=(
      #|{"deviceType":"cpu"}
    ),
  )
}

///|
test "uses_accelerated_contract does not throw where MLContext is absent" {
  // Node has no MLContext at all, so this is the legacy answer.
  assert_eq(uses_accelerated_contract(), false)
}

// =============================================================================
// Context capabilities
// =============================================================================

///|
test "preferred_input_layout falls back to nchw" {
  let without : MLContext = context_stub(js_null(), false).cast()
  assert_eq(without.preferred_input_layout(), "nchw")
  let empty : MLContext = context_stub(obj([]), false).cast()
  assert_eq(empty.preferred_input_layout(), "nchw")
}

///|
test "preferred_input_layout reads the reported layout" {
  let ctx : MLContext = context_stub(
    obj([("preferredInputLayout", @core.any("nhwc"))]),
    false,
  ).cast()
  assert_eq(ctx.preferred_input_layout(), "nhwc")
}

///|
test "has_op_support_limits and op_support_limits agree" {
  let without : MLContext = context_stub(js_null(), false).cast()
  assert_eq(without.has_op_support_limits(), false)
  assert_eq(without.op_support_limits() is None, true)
  let with_limits : MLContext = context_stub(obj([("conv2d", obj([]))]), false).cast()
  assert_eq(with_limits.has_op_support_limits(), true)
  match with_limits.op_support_limits() {
    Some(limits) =>
      inspect(
        json_str(limits),
        content=(
          #|{"conv2d":{}}
        ),
      )
    None => fail("expected limits")
  }
}

///|
test "has_tensor_io requires all four methods" {
  let without : MLContext = context_stub(js_null(), false).cast()
  assert_eq(without.has_tensor_io(), false)
  let with_io : MLContext = context_stub(js_null(), true).cast()
  assert_eq(with_io.has_tensor_io(), true)
}

///|
test "supported_operators filters the candidates it is given" {
  let ctx : MLContext = context_stub(
    obj([("conv2d", obj([])), ("relu", obj([]))]),
    false,
  ).cast()
  assert_eq(ctx.supported_operators(["conv2d", "relu", "gelu"]), [
    "conv2d", "relu",
  ])
}

///|
test "supported_operators is empty, meaning unknown, without limits" {
  let ctx : MLContext = context_stub(js_null(), false).cast()
  assert_eq(ctx.supported_operators(["conv2d"]), [])
}

// =============================================================================
// Descriptors and named values
// =============================================================================

///|
test "descriptor sets both shape and the legacy dimensions key" {
  inspect(
    json_str(descriptor("float32", [1, 3, 224, 224])),
    content=(
      #|{"dataType":"float32","shape":[1,3,224,224],"dimensions":[1,3,224,224]}
    ),
  )
}

///|
test "descriptor omits usage flags unless set" {
  inspect(
    json_str(descriptor("int32", [2])),
    content=(
      #|{"dataType":"int32","shape":[2],"dimensions":[2]}
    ),
  )
  inspect(
    json_str(descriptor("int32", [2], writable=true)),
    content=(
      #|{"dataType":"int32","shape":[2],"dimensions":[2],"writable":true}
    ),
  )
  inspect(
    json_str(descriptor("int32", [2], writable=true, readable=true)),
    content=(
      #|{"dataType":"int32","shape":[2],"dimensions":[2],"writable":true,"readable":true}
    ),
  )
}

///|
test "named_values pairs names with values positionally" {
  inspect(
    json_str(named_values(["a", "b"], [@core.any(1), @core.any("x")])),
    content=(
      #|{"a":1,"b":"x"}
    ),
  )
  inspect(
    json_str(named_values([], [])),
    content=(
      #|{}
    ),
  )
}

// =============================================================================
// Typed array round trips
// =============================================================================

///|
test "float32 values round-trip through a Float32Array" {
  let values : Array[Float] = [1.5, -2.25, 0.0]
  assert_eq(float32_values(float32_array(values)), values)
}

///|
test "int32 values round-trip through an Int32Array" {
  assert_eq(int32_values(int32_array([1, -2, 3])), [1, -2, 3])
}

///|
test "float32_array produces a real Float32Array" {
  let values : Array[Float] = [1.0, 2.0]
  inspect(
    json_str(float32_array(values)),
    content=(
      #|{"0":1,"1":2}
    ),
  )
}

// =============================================================================
// Graph builder argument marshalling
// =============================================================================

///|
test "input declares a float32 operand" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let _ = builder.input("x", [1, 4])
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"input","args":["x",{"dataType":"float32","shape":[1,4],"dimensions":[1,4]}]}]
    ),
  )
}

///|
test "input_of declares another data type" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let _ = builder.input_of("ids", "int32", [1, 8])
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"input","args":["ids",{"dataType":"int32","shape":[1,8],"dimensions":[1,8]}]}]
    ),
  )
}

///|
test "constants carry their descriptor and buffer" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let weights : Array[Float] = [1.0, 2.0]
  let _ = builder.constant_float32([2], weights)
  let _ = builder.constant_int32([2], [3, 4])
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"constant","args":[{"dataType":"float32","shape":[2],"dimensions":[2]},{"0":1,"1":2}]},{"name":"constant","args":[{"dataType":"int32","shape":[2],"dimensions":[2]},{"0":3,"1":4}]}]
    ),
  )
}

///|
test "binary operators pass both operands" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let a : MLOperand = obj([("id", @core.any("a"))]).cast()
  let b : MLOperand = obj([("id", @core.any("b"))]).cast()
  let _ = builder.add(a, b)
  let _ = builder.matmul(a, b)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"add","args":[{"id":"a"},{"id":"b"}]},{"name":"matmul","args":[{"id":"a"},{"id":"b"}]}]
    ),
  )
}

///|
test "unary operators pass one operand" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let x : MLOperand = obj([]).cast()
  let _ = builder.relu(x)
  let _ = builder.gelu(x)
  let _ = builder.tanh(x)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"relu","args":[{}]},{"name":"gelu","args":[{}]},{"name":"tanh","args":[{}]}]
    ),
  )
}

///|
test "clamp and softmax carry their options" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let x : MLOperand = obj([]).cast()
  let _ = builder.clamp(x, 0.0, 6.0)
  let _ = builder.softmax(x, 1)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"clamp","args":[{},{"minValue":0,"maxValue":6}]},{"name":"softmax","args":[{},1]}]
    ),
  )
}

///|
test "conv2d spells out its options object" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let x : MLOperand = obj([]).cast()
  let w : MLOperand = obj([]).cast()
  let _ = builder.conv2d(x, w, [1, 1, 1, 1], [1, 1], [1, 1], 1, "nhwc", "ohwi")
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"conv2d","args":[{},{},{"padding":[1,1,1,1],"strides":[1,1],"dilations":[1,1],"groups":1,"inputLayout":"nhwc","filterLayout":"ohwi"}]}]
    ),
  )
}

///|
test "pooling distinguishes max from average" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let x : MLOperand = obj([]).cast()
  let _ = builder.max_pool2d(x, [2, 2], [0, 0, 0, 0], [2, 2], [1, 1], "nhwc")
  let _ = builder.average_pool2d(
    x,
    [2, 2],
    [0, 0, 0, 0],
    [2, 2],
    [1, 1],
    "nhwc",
  )
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"maxPool2d","args":[{},{"windowDimensions":[2,2],"padding":[0,0,0,0],"strides":[2,2],"dilations":[1,1],"layout":"nhwc"}]},{"name":"averagePool2d","args":[{},{"windowDimensions":[2,2],"padding":[0,0,0,0],"strides":[2,2],"dilations":[1,1],"layout":"nhwc"}]}]
    ),
  )
}

///|
test "shape operators pass arrays through" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let x : MLOperand = obj([]).cast()
  let _ = builder.reshape(x, [1, 16])
  let _ = builder.transpose(x, [0, 2, 1])
  let _ = builder.slice(x, [0, 0], [1, 4])
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"reshape","args":[{},[1,16]]},{"name":"transpose","args":[{},{"permutation":[0,2,1]}]},{"name":"slice","args":[{},[0,0],[1,4]]}]
    ),
  )
}

///|
test "concat and gather carry axis" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let a : MLOperand = obj([("id", @core.any(1))]).cast()
  let b : MLOperand = obj([("id", @core.any(2))]).cast()
  let _ = builder.concat([a, b], 1)
  let _ = builder.gather(a, b, 0)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"concat","args":[[{"id":1},{"id":2}],1]},{"name":"gather","args":[{"id":1},{"id":2},{"axis":0}]}]
    ),
  )
}

///|
test "reduce_mean and layer_normalization carry their options" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let x : MLOperand = obj([]).cast()
  let scale : MLOperand = obj([("s", @core.any(1))]).cast()
  let bias : MLOperand = obj([("b", @core.any(1))]).cast()
  let _ = builder.reduce_mean(x, [-1], true)
  let _ = builder.layer_normalization(x, scale, bias, [-1], 1.0e-5)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"reduceMean","args":[{},{"axes":[-1],"keepDimensions":true}]},{"name":"layerNormalization","args":[{},{"scale":{"s":1},"bias":{"b":1},"axes":[-1],"epsilon":0.000009999999747378752}]}]
    ),
  )
}

// =============================================================================
// Escape hatch
// =============================================================================

///|
test "op reaches an operator with no named binding" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let x : MLOperand = obj([]).cast()
  // `abs` has no wrapper of its own
  let _ = builder.op("abs", [x.as_any()])
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"abs","args":[{}]}]
    ),
  )
}

///|
test "op_with_options appends the options object" {
  let spy = make_spy()
  let builder : MLGraphBuilder = spy.cast()
  let x : MLOperand = obj([]).cast()
  let _ = builder.op_with_options(
    "pad",
    [x.as_any(), @core.any([1, 1]), @core.any([1, 1])],
    obj([("mode", @core.any("constant"))]),
  )
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"pad","args":[{},[1,1],[1,1],{"mode":"constant"}]}]
    ),
  )
}

///|
test "same_builder compares by identity" {
  let a : MLGraphBuilder = obj([]).cast()
  let b : MLGraphBuilder = obj([]).cast()
  assert_eq(same_builder(a, a), true)
  assert_eq(same_builder(a, b), false)
}

// =============================================================================
// Promise plumbing
// =============================================================================

///|
async test "build_many names its outputs and awaits the graph" {
  let stub = builder_stub()
  let builder : MLGraphBuilder = stub.cast()
  let out : MLOperand = obj([("o", @core.any(1))]).cast()
  let graph = builder.build_many(["logits"], [out])
  inspect(
    json_str(graph.as_any()),
    content=(
      #|{"graph":true}
    ),
  )
  inspect(
    json_str(stub["calls"]),
    content=(
      #|[{"name":"build","args":[{"logits":{"o":1}}]}]
    ),
  )
}

///|
async test "build wraps the single-output case" {
  let stub = builder_stub()
  let builder : MLGraphBuilder = stub.cast()
  let out : MLOperand = obj([]).cast()
  let _ = builder.build("y", out)
  inspect(
    json_str(stub["calls"]),
    content=(
      #|[{"name":"build","args":[{"y":{}}]}]
    ),
  )
}

///|
async test "read_tensor decodes the resolved buffer as float32" {
  let ctx : MLContext = context_stub(js_null(), true).cast()
  let tensor : MLTensor = obj([]).cast()
  let values : Array[Float] = [1.0, 2.0]
  assert_eq(ctx.read_tensor(tensor), values)
}

///|
async test "create_tensor sends a descriptor with usage flags" {
  let ctx : MLContext = context_stub(js_null(), true).cast()
  let tensor = ctx.create_tensor([1, 2], true, false)
  inspect(
    json_str(tensor.as_any()),
    content=(
      #|{"tensor":true}
    ),
  )
}

// =============================================================================
// Dispatch
// =============================================================================

///|
test "dispatch_single wraps the one-in-one-out case" {
  let spy = make_spy()
  let ctx : MLContext = spy.cast()
  let graph : MLGraph = obj([("g", @core.any(1))]).cast()
  let input : MLTensor = obj([("i", @core.any(1))]).cast()
  let output : MLTensor = obj([("o", @core.any(1))]).cast()
  ctx.dispatch_single(graph, "x", input, "y", output)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"dispatch","args":[{"g":1},{"x":{"i":1}},{"y":{"o":1}}]}]
    ),
  )
}

///|
test "write_tensor converts values to a Float32Array" {
  let spy = make_spy()
  let ctx : MLContext = spy.cast()
  let tensor : MLTensor = obj([]).cast()
  let values : Array[Float] = [1.0, 2.0]
  ctx.write_tensor(tensor, values)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"writeTensor","args":[{},{"0":1,"1":2}]}]
    ),
  )
}

///|
test "destroy forwards on context, tensor and graph" {
  let spy = make_spy()
  let ctx : MLContext = spy.cast()
  ctx.destroy()
  let tensor_spy = make_spy()
  let tensor : MLTensor = tensor_spy.cast()
  tensor.destroy()
  let graph_spy = make_spy()
  let graph : MLGraph = graph_spy.cast()
  graph.destroy()
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"destroy","args":[]}]
    ),
  )
  inspect(
    spy_calls(tensor_spy),
    content=(
      #|[{"name":"destroy","args":[]}]
    ),
  )
  inspect(
    spy_calls(graph_spy),
    content=(
      #|[{"name":"destroy","args":[]}]
    ),
  )
}
