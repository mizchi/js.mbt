// =============================================================================
// WebNN - Web Neural Network API
// https://www.w3.org/TR/webnn/
//
// Entry point, context and tensor I/O. Graph construction is in builder.mbt.
//
// These are the spec-level bindings, absorbed from mizchi/webnn-mbt so that
// the standard surface lives alongside the other web APIs and higher-level
// runtimes can share it.
// =============================================================================

///|
/// `navigator.ml` — the entry point to WebNN.
/// https://www.w3.org/TR/webnn/#ml
#external
pub type ML

///|
/// A compiled execution context, bound to a device.
/// https://www.w3.org/TR/webnn/#mlcontext
#external
pub type MLContext

///|
/// Builds a computational graph.
/// https://www.w3.org/TR/webnn/#mlgraphbuilder
#external
pub type MLGraphBuilder

///|
/// A node in a graph under construction.
/// https://www.w3.org/TR/webnn/#mloperand
#external
pub type MLOperand

///|
/// A compiled graph, ready to dispatch.
/// https://www.w3.org/TR/webnn/#mlgraph
#external
pub type MLGraph

///|
/// Device-side memory for graph inputs and outputs.
/// https://www.w3.org/TR/webnn/#mltensor
#external
pub type MLTensor

///|
pub fn ML::as_any(self : ML) -> @core.Any = "%identity"

///|
pub fn MLContext::as_any(self : MLContext) -> @core.Any = "%identity"

///|
pub fn MLGraphBuilder::as_any(self : MLGraphBuilder) -> @core.Any = "%identity"

///|
pub fn MLOperand::as_any(self : MLOperand) -> @core.Any = "%identity"

///|
pub fn MLGraph::as_any(self : MLGraph) -> @core.Any = "%identity"

///|
pub fn MLTensor::as_any(self : MLTensor) -> @core.Any = "%identity"

// ---- entry point -----------------------------------------------------------

///|
extern "js" fn ffi_navigator_ml() -> @core.Any =
  #| () => navigator.ml

///|
/// The `navigator.ml` object, or `None` where WebNN is unavailable.
///
/// This doubles as the feature test — it does not throw off-browser.
pub fn ml() -> ML? {
  let value = ffi_navigator_ml()
  if @core.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Whether this implementation takes the newer `{accelerated}` context option
/// rather than the older `{deviceType}`.
///
/// The spec replaced the `deviceType` hint with a boolean `accelerated`, and
/// implementations shipped the change at different times, so a caller that
/// wants to work on both has to ask. `context_options` builds whichever shape
/// applies.
pub fn uses_accelerated_contract() -> Bool {
  ffi_uses_accelerated_contract()
}

///|
extern "js" fn ffi_uses_accelerated_contract() -> Bool =
  #| () => typeof MLContext !== "undefined" && "accelerated" in MLContext.prototype

///|
/// Build the options object for `ML::create_context`, in whichever shape this
/// implementation expects. `device_type` takes "cpu", "gpu" or "npu".
pub fn context_options(
  accelerated_contract : Bool,
  device_type : String,
) -> @core.Any {
  ffi_context_options(accelerated_contract, device_type)
}

///|
extern "js" fn ffi_context_options(
  accelerated_contract : Bool,
  device_type : String,
) -> @core.Any =
  #| (acceleratedContract, deviceType) => acceleratedContract
  #|   ? { accelerated: deviceType !== "cpu" }
  #|   : { deviceType }

///|
/// Create a context. Pass options from `context_options`, or your own object.
/// https://www.w3.org/TR/webnn/#dom-ml-createcontext
pub async fn ML::create_context(self : ML, options : @core.Any) -> MLContext {
  let promise : @core.Promise[MLContext] = self
    .as_any()
    ._call("createContext", [options])
    .cast()
  promise.wait()
}

// ---- context capabilities --------------------------------------------------

///|
/// The layout the implementation prefers for 4-D inputs, "nchw" or "nhwc".
///
/// Falls back to "nchw" where `opSupportLimits` is unavailable.
pub fn MLContext::preferred_input_layout(self : MLContext) -> String {
  ffi_preferred_input_layout(self)
}

///|
extern "js" fn ffi_preferred_input_layout(context : MLContext) -> String =
  #| (context) =>
  #|   typeof context.opSupportLimits === "function"
  #|     ? (context.opSupportLimits().preferredInputLayout ?? "nchw")
  #|     : "nchw"

///|
/// Whether this context reports operator support limits at all.
pub fn MLContext::has_op_support_limits(self : MLContext) -> Bool {
  ffi_has_op_support_limits(self)
}

///|
extern "js" fn ffi_has_op_support_limits(context : MLContext) -> Bool =
  #| (context) => typeof context.opSupportLimits === "function"

///|
/// The whole `opSupportLimits()` object, or `None` where unsupported.
///
/// Use this to read limits `supported_operators` does not cover — data-type
/// support per operand, rank limits, and so on.
/// https://www.w3.org/TR/webnn/#dom-mlcontext-opsupportlimits
pub fn MLContext::op_support_limits(self : MLContext) -> @core.Any? {
  if self.has_op_support_limits() {
    Some(self.as_any()._call("opSupportLimits", []))
  } else {
    None
  }
}

///|
/// Whether this context has the `MLTensor` I/O methods — `createTensor`,
/// `writeTensor`, `readTensor` and `dispatch`.
///
/// Older implementations only had the `compute()` path, so a runtime that
/// wants to use device-side tensors has to check.
pub fn MLContext::has_tensor_io(self : MLContext) -> Bool {
  ffi_has_tensor_io(self)
}

///|
extern "js" fn ffi_has_tensor_io(context : MLContext) -> Bool =
  #| (context) =>
  #|   typeof context.createTensor === "function" &&
  #|   typeof context.writeTensor === "function" &&
  #|   typeof context.readTensor === "function" &&
  #|   typeof context.dispatch === "function"

///|
/// Which of `candidates` this context reports as supported.
///
/// Returns an empty array where `opSupportLimits` is unavailable, so treat an
/// empty result as "unknown" rather than "nothing supported".
pub fn MLContext::supported_operators(
  self : MLContext,
  candidates : Array[String],
) -> Array[String] {
  Array::from_fixed_array(
    ffi_supported_operators(self, FixedArray::from_array(candidates)),
  )
}

///|
extern "js" fn ffi_supported_operators(
  context : MLContext,
  candidates : FixedArray[String],
) -> FixedArray[String] =
  #| (context, candidates) => {
  #|   if (typeof context.opSupportLimits !== "function") return [];
  #|   const limits = context.opSupportLimits();
  #|   return candidates.filter((name) => limits[name] !== undefined);
  #| }

///|
/// Release the context and everything created from it.
/// https://www.w3.org/TR/webnn/#dom-mlcontext-destroy
pub fn MLContext::destroy(self : MLContext) -> Unit {
  self.as_any()._call("destroy", []) |> ignore
}

// ---- typed array helpers ---------------------------------------------------

///|
/// Wrap values in a `Float32Array`, the form WebNN takes for float32 data.
pub fn float32_array(values : Array[Float]) -> @core.Any {
  ffi_float32_array(FixedArray::from_array(values))
}

///|
extern "js" fn ffi_float32_array(values : FixedArray[Float]) -> @core.Any =
  #| (values) => new Float32Array(values)

///|
/// Read a buffer back as float32 values.
pub fn float32_values(buffer : @core.Any) -> Array[Float] {
  Array::from_fixed_array(ffi_float32_values(buffer))
}

///|
extern "js" fn ffi_float32_values(buffer : @core.Any) -> FixedArray[Float] =
  #| (buffer) => Array.from(new Float32Array(buffer))

///|
/// Wrap values in an `Int32Array`.
pub fn int32_array(values : Array[Int]) -> @core.Any {
  ffi_int32_array(FixedArray::from_array(values))
}

///|
extern "js" fn ffi_int32_array(values : FixedArray[Int]) -> @core.Any =
  #| (values) => new Int32Array(values)

///|
/// Read a buffer back as int32 values.
pub fn int32_values(buffer : @core.Any) -> Array[Int] {
  Array::from_fixed_array(ffi_int32_values(buffer))
}

///|
extern "js" fn ffi_int32_values(buffer : @core.Any) -> FixedArray[Int] =
  #| (buffer) => Array.from(new Int32Array(buffer))

// ---- operand descriptors ---------------------------------------------------

///|
/// Build an `MLOperandDescriptor`.
///
/// `data_type` is a spec data-type string — "float32", "float16", "int32",
/// "uint32", "int64", "uint64", "int8", "uint8", "int4" or "uint4".
/// `writable` and `readable` are the `MLTensor` usage flags; they are only
/// meaningful for `create_tensor` and are omitted when false.
///
/// Both `shape` and the older `dimensions` key are set, since implementations
/// shipped the rename at different times.
/// https://www.w3.org/TR/webnn/#dictdef-mloperanddescriptor
pub fn descriptor(
  data_type : String,
  shape : Array[Int],
  writable? : Bool = false,
  readable? : Bool = false,
) -> @core.Any {
  ffi_descriptor(data_type, FixedArray::from_array(shape), writable, readable)
}

///|
extern "js" fn ffi_descriptor(
  data_type : String,
  shape : FixedArray[Int],
  writable : Bool,
  readable : Bool,
) -> @core.Any =
  #| (dataType, shape, writable, readable) => ({
  #|   dataType,
  #|   shape,
  #|   dimensions: shape,
  #|   ...(writable ? { writable: true } : {}),
  #|   ...(readable ? { readable: true } : {}),
  #| })

// ---- tensor I/O ------------------------------------------------------------

///|
/// Allocate a device-side float32 tensor.
///
/// `writable` lets the CPU write into it, `readable` lets the CPU read it
/// back; a graph input usually wants the former and an output the latter.
/// Requires `has_tensor_io`.
/// https://www.w3.org/TR/webnn/#dom-mlcontext-createtensor
pub async fn MLContext::create_tensor(
  self : MLContext,
  shape : Array[Int],
  writable : Bool,
  readable : Bool,
) -> MLTensor {
  self.create_tensor_of("float32", shape, writable, readable)
}

///|
/// Allocate a device-side tensor of any spec data type.
pub async fn MLContext::create_tensor_of(
  self : MLContext,
  data_type : String,
  shape : Array[Int],
  writable : Bool,
  readable : Bool,
) -> MLTensor {
  let promise : @core.Promise[MLTensor] = self
    .as_any()
    ._call("createTensor", [descriptor(data_type, shape, writable~, readable~)])
    .cast()
  promise.wait()
}

///|
/// Write float32 values into a tensor.
/// https://www.w3.org/TR/webnn/#dom-mlcontext-writetensor
pub fn MLContext::write_tensor(
  self : MLContext,
  tensor : MLTensor,
  values : Array[Float],
) -> Unit {
  self.as_any()._call("writeTensor", [tensor.as_any(), float32_array(values)])
  |> ignore
}

///|
/// Write an arbitrary buffer source into a tensor — a typed array or
/// `ArrayBuffer` of any type.
pub fn MLContext::write_tensor_raw(
  self : MLContext,
  tensor : MLTensor,
  data : @core.Any,
) -> Unit {
  self.as_any()._call("writeTensor", [tensor.as_any(), data]) |> ignore
}

///|
/// Read a tensor back as float32 values.
/// https://www.w3.org/TR/webnn/#dom-mlcontext-readtensor
pub async fn MLContext::read_tensor(
  self : MLContext,
  tensor : MLTensor,
) -> Array[Float] {
  float32_values(self.read_tensor_raw(tensor))
}

///|
/// Read a tensor back as a raw `ArrayBuffer`, for data that is not float32.
pub async fn MLContext::read_tensor_raw(
  self : MLContext,
  tensor : MLTensor,
) -> @core.Any {
  let promise : @core.Promise[@core.Any] = self
    .as_any()
    ._call("readTensor", [tensor.as_any()])
    .cast()
  promise.wait()
}

///|
/// Release a tensor.
/// https://www.w3.org/TR/webnn/#dom-mltensor-destroy
pub fn MLTensor::destroy(self : MLTensor) -> Unit {
  self.as_any()._call("destroy", []) |> ignore
}

// ---- dispatch --------------------------------------------------------------

///|
extern "js" fn ffi_named_values(
  names : FixedArray[String],
  values : FixedArray[@core.Any],
) -> @core.Any =
  #| (names, values) => Object.fromEntries(
  #|   names.map((name, index) => [name, values[index]]),
  #| )

///|
/// Build a `{ name: value }` object, the shape WebNN uses for named graph
/// inputs and outputs.
pub fn named_values(
  names : Array[String],
  values : Array[@core.Any],
) -> @core.Any {
  ffi_named_values(
    FixedArray::from_array(names),
    FixedArray::from_array(values),
  )
}

///|
/// Run a graph with one input and one output.
/// https://www.w3.org/TR/webnn/#dom-mlcontext-dispatch
pub fn MLContext::dispatch_single(
  self : MLContext,
  graph : MLGraph,
  input_name : String,
  input : MLTensor,
  output_name : String,
  output : MLTensor,
) -> Unit {
  self.dispatch_many(graph, [input_name], [input], [output_name], [output])
}

///|
/// Run a graph with named inputs and outputs.
///
/// `dispatch` returns immediately; read an output tensor to await the result.
/// https://www.w3.org/TR/webnn/#dom-mlcontext-dispatch
pub fn MLContext::dispatch_many(
  self : MLContext,
  graph : MLGraph,
  input_names : Array[String],
  inputs : Array[MLTensor],
  output_names : Array[String],
  outputs : Array[MLTensor],
) -> Unit {
  let input_values = inputs.map(fn(input) { input.as_any() })
  let output_values = outputs.map(fn(output) { output.as_any() })
  self
  .as_any()
  ._call("dispatch", [
    graph.as_any(),
    named_values(input_names, input_values),
    named_values(output_names, output_values),
  ])
  |> ignore
}

///|
/// Release a compiled graph.
/// https://www.w3.org/TR/webnn/#dom-mlgraph-destroy
pub fn MLGraph::destroy(self : MLGraph) -> Unit {
  self.as_any()._call("destroy", []) |> ignore
}
