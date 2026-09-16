// =============================================================================
// MLGraphBuilder - graph construction
// https://www.w3.org/TR/webnn/#api-mlgraphbuilder
//
// The operator set here is the one mizchi/webnn-mbt needs to lower LiteRT and
// transformer graphs. The spec defines considerably more; `MLGraphBuilder::op`
// and `op_with_options` reach any of them without waiting for a named binding.
// =============================================================================

///|
/// Create a builder for a context.
/// https://www.w3.org/TR/webnn/#dom-mlgraphbuilder-mlgraphbuilder
pub extern "js" fn MLGraphBuilder::MLGraphBuilder(
  context : MLContext,
) -> MLGraphBuilder =
  #| (context) => new MLGraphBuilder(context)

///|
/// Whether two builders are the same object.
///
/// Operands may only be combined within the builder that made them, so a
/// higher-level API that hands operands around needs this to validate.
pub fn same_builder(lhs : MLGraphBuilder, rhs : MLGraphBuilder) -> Bool {
  ffi_same_builder(lhs, rhs)
}

///|
extern "js" fn ffi_same_builder(
  lhs : MLGraphBuilder,
  rhs : MLGraphBuilder,
) -> Bool =
  #| (lhs, rhs) => lhs === rhs

// ---- escape hatch ----------------------------------------------------------

///|
/// Call any builder operator by name with already-wrapped arguments.
///
/// For operators this module does not name yet. `builder.op("abs", [x.as_any()])`
/// is the same call `MLGraphBuilder::relu` makes internally.
pub fn MLGraphBuilder::op(
  self : MLGraphBuilder,
  operation : String,
  args : Array[@core.Any],
) -> MLOperand {
  self.as_any()._call(operation, FixedArray::from_array(args)).cast()
}

///|
/// Call any builder operator by name with a trailing options object.
///
/// `builder.op_with_options("pad", [x.as_any()], @core.from_entries([...]))`.
pub fn MLGraphBuilder::op_with_options(
  self : MLGraphBuilder,
  operation : String,
  args : Array[@core.Any],
  options : @core.Any,
) -> MLOperand {
  let all = args.copy()
  all.push(options)
  self.as_any()._call(operation, FixedArray::from_array(all)).cast()
}

// ---- inputs and constants --------------------------------------------------

///|
/// Declare a float32 graph input.
/// https://www.w3.org/TR/webnn/#dom-mlgraphbuilder-input
pub fn MLGraphBuilder::input(
  self : MLGraphBuilder,
  name : String,
  shape : Array[Int],
) -> MLOperand {
  self.input_of(name, "float32", shape)
}

///|
/// Declare a graph input of any spec data type.
pub fn MLGraphBuilder::input_of(
  self : MLGraphBuilder,
  name : String,
  data_type : String,
  shape : Array[Int],
) -> MLOperand {
  self
  .as_any()
  ._call("input", [@core.any(name), descriptor(data_type, shape)])
  .cast()
}

///|
/// A float32 constant.
/// https://www.w3.org/TR/webnn/#dom-mlgraphbuilder-constant
pub fn MLGraphBuilder::constant_float32(
  self : MLGraphBuilder,
  shape : Array[Int],
  values : Array[Float],
) -> MLOperand {
  self
  .as_any()
  ._call("constant", [descriptor("float32", shape), float32_array(values)])
  .cast()
}

///|
/// An int32 constant.
pub fn MLGraphBuilder::constant_int32(
  self : MLGraphBuilder,
  shape : Array[Int],
  values : Array[Int],
) -> MLOperand {
  self
  .as_any()
  ._call("constant", [descriptor("int32", shape), int32_array(values)])
  .cast()
}

///|
/// A constant from a raw buffer, for data types without a named helper.
pub fn MLGraphBuilder::constant_raw(
  self : MLGraphBuilder,
  data_type : String,
  shape : Array[Int],
  buffer : @core.Any,
) -> MLOperand {
  self.as_any()._call("constant", [descriptor(data_type, shape), buffer]).cast()
}

// ---- element-wise binary ---------------------------------------------------

///|
fn binary_operand(
  builder : MLGraphBuilder,
  operation : String,
  lhs : MLOperand,
  rhs : MLOperand,
) -> MLOperand {
  builder.as_any()._call(operation, [lhs.as_any(), rhs.as_any()]).cast()
}

///|
pub fn MLGraphBuilder::add(
  self : MLGraphBuilder,
  lhs : MLOperand,
  rhs : MLOperand,
) -> MLOperand {
  binary_operand(self, "add", lhs, rhs)
}

///|
pub fn MLGraphBuilder::sub(
  self : MLGraphBuilder,
  lhs : MLOperand,
  rhs : MLOperand,
) -> MLOperand {
  binary_operand(self, "sub", lhs, rhs)
}

///|
pub fn MLGraphBuilder::mul(
  self : MLGraphBuilder,
  lhs : MLOperand,
  rhs : MLOperand,
) -> MLOperand {
  binary_operand(self, "mul", lhs, rhs)
}

///|
pub fn MLGraphBuilder::div(
  self : MLGraphBuilder,
  lhs : MLOperand,
  rhs : MLOperand,
) -> MLOperand {
  binary_operand(self, "div", lhs, rhs)
}

///|
pub fn MLGraphBuilder::matmul(
  self : MLGraphBuilder,
  lhs : MLOperand,
  rhs : MLOperand,
) -> MLOperand {
  binary_operand(self, "matmul", lhs, rhs)
}

// ---- element-wise unary ----------------------------------------------------

///|
fn unary_operand(
  builder : MLGraphBuilder,
  operation : String,
  input : MLOperand,
) -> MLOperand {
  builder.as_any()._call(operation, [input.as_any()]).cast()
}

///|
pub fn MLGraphBuilder::relu(
  self : MLGraphBuilder,
  input : MLOperand,
) -> MLOperand {
  unary_operand(self, "relu", input)
}

///|
pub fn MLGraphBuilder::sigmoid(
  self : MLGraphBuilder,
  input : MLOperand,
) -> MLOperand {
  unary_operand(self, "sigmoid", input)
}

///|
pub fn MLGraphBuilder::tanh(
  self : MLGraphBuilder,
  input : MLOperand,
) -> MLOperand {
  unary_operand(self, "tanh", input)
}

///|
pub fn MLGraphBuilder::gelu(
  self : MLGraphBuilder,
  input : MLOperand,
) -> MLOperand {
  unary_operand(self, "gelu", input)
}

///|
extern "js" fn ffi_clamp_options(minimum : Float, maximum : Float) -> @core.Any =
  #| (minValue, maxValue) => ({ minValue, maxValue })

///|
pub fn MLGraphBuilder::clamp(
  self : MLGraphBuilder,
  input : MLOperand,
  minimum : Float,
  maximum : Float,
) -> MLOperand {
  self
  .as_any()
  ._call("clamp", [input.as_any(), ffi_clamp_options(minimum, maximum)])
  .cast()
}

///|
pub fn MLGraphBuilder::softmax(
  self : MLGraphBuilder,
  input : MLOperand,
  axis : Int,
) -> MLOperand {
  self.as_any()._call("softmax", [input.as_any(), @core.any(axis)]).cast()
}

// ---- shape manipulation ----------------------------------------------------

///|
pub fn MLGraphBuilder::reshape(
  self : MLGraphBuilder,
  input : MLOperand,
  shape : Array[Int],
) -> MLOperand {
  self.as_any()._call("reshape", [input.as_any(), @core.any(shape)]).cast()
}

///|
extern "js" fn ffi_transpose_options(
  permutation : FixedArray[Int],
) -> @core.Any =
  #| (permutation) => ({ permutation })

///|
pub fn MLGraphBuilder::transpose(
  self : MLGraphBuilder,
  input : MLOperand,
  permutation : Array[Int],
) -> MLOperand {
  self
  .as_any()
  ._call("transpose", [
    input.as_any(),
    ffi_transpose_options(FixedArray::from_array(permutation)),
  ])
  .cast()
}

///|
pub fn MLGraphBuilder::concat(
  self : MLGraphBuilder,
  inputs : Array[MLOperand],
  axis : Int,
) -> MLOperand {
  let operands = inputs.map(fn(input) { input.as_any() })
  self.as_any()._call("concat", [@core.any(operands), @core.any(axis)]).cast()
}

///|
pub fn MLGraphBuilder::slice(
  self : MLGraphBuilder,
  input : MLOperand,
  starts : Array[Int],
  sizes : Array[Int],
) -> MLOperand {
  self
  .as_any()
  ._call("slice", [input.as_any(), @core.any(starts), @core.any(sizes)])
  .cast()
}

///|
extern "js" fn ffi_gather_options(axis : Int) -> @core.Any =
  #| (axis) => ({ axis })

///|
pub fn MLGraphBuilder::gather(
  self : MLGraphBuilder,
  input : MLOperand,
  indices : MLOperand,
  axis : Int,
) -> MLOperand {
  self
  .as_any()
  ._call("gather", [input.as_any(), indices.as_any(), ffi_gather_options(axis)])
  .cast()
}

// ---- reductions ------------------------------------------------------------

///|
extern "js" fn ffi_reduce_options(
  axes : FixedArray[Int],
  keep_dimensions : Bool,
) -> @core.Any =
  #| (axes, keepDimensions) => ({ axes, keepDimensions })

///|
pub fn MLGraphBuilder::reduce_mean(
  self : MLGraphBuilder,
  input : MLOperand,
  axes : Array[Int],
  keep_dimensions : Bool,
) -> MLOperand {
  self
  .as_any()
  ._call("reduceMean", [
    input.as_any(),
    ffi_reduce_options(FixedArray::from_array(axes), keep_dimensions),
  ])
  .cast()
}

// ---- normalization ---------------------------------------------------------

///|
extern "js" fn ffi_layer_normalization_options(
  scale : @core.Any,
  bias : @core.Any,
  axes : FixedArray[Int],
  epsilon : Float,
) -> @core.Any =
  #| (scale, bias, axes, epsilon) => ({ scale, bias, axes, epsilon })

///|
pub fn MLGraphBuilder::layer_normalization(
  self : MLGraphBuilder,
  input : MLOperand,
  scale : MLOperand,
  bias : MLOperand,
  axes : Array[Int],
  epsilon : Float,
) -> MLOperand {
  self
  .as_any()
  ._call("layerNormalization", [
    input.as_any(),
    ffi_layer_normalization_options(
      scale.as_any(),
      bias.as_any(),
      FixedArray::from_array(axes),
      epsilon,
    ),
  ])
  .cast()
}

// ---- convolution and pooling -----------------------------------------------

///|
extern "js" fn ffi_conv2d_options(
  padding : FixedArray[Int],
  strides : FixedArray[Int],
  dilations : FixedArray[Int],
  groups : Int,
  input_layout : String,
  filter_layout : String,
) -> @core.Any =
  #| (padding, strides, dilations, groups, inputLayout, filterLayout) => ({
  #|   padding,
  #|   strides,
  #|   dilations,
  #|   groups,
  #|   inputLayout,
  #|   filterLayout,
  #| })

///|
/// `input_layout` is "nchw" or "nhwc"; `filter_layout` is "oihw", "hwio",
/// "ohwi" or "ihwo".
/// https://www.w3.org/TR/webnn/#dom-mlgraphbuilder-conv2d
pub fn MLGraphBuilder::conv2d(
  self : MLGraphBuilder,
  input : MLOperand,
  filter : MLOperand,
  padding : Array[Int],
  strides : Array[Int],
  dilations : Array[Int],
  groups : Int,
  input_layout : String,
  filter_layout : String,
) -> MLOperand {
  self
  .as_any()
  ._call("conv2d", [
    input.as_any(),
    filter.as_any(),
    ffi_conv2d_options(
      FixedArray::from_array(padding),
      FixedArray::from_array(strides),
      FixedArray::from_array(dilations),
      groups,
      input_layout,
      filter_layout,
    ),
  ])
  .cast()
}

///|
extern "js" fn ffi_pool2d_options(
  window_dimensions : FixedArray[Int],
  padding : FixedArray[Int],
  strides : FixedArray[Int],
  dilations : FixedArray[Int],
  layout : String,
) -> @core.Any =
  #| (windowDimensions, padding, strides, dilations, layout) => ({
  #|   windowDimensions,
  #|   padding,
  #|   strides,
  #|   dilations,
  #|   layout,
  #| })

///|
fn pool2d(
  builder : MLGraphBuilder,
  operation : String,
  input : MLOperand,
  window_dimensions : Array[Int],
  padding : Array[Int],
  strides : Array[Int],
  dilations : Array[Int],
  layout : String,
) -> MLOperand {
  builder
  .as_any()
  ._call(operation, [
    input.as_any(),
    ffi_pool2d_options(
      FixedArray::from_array(window_dimensions),
      FixedArray::from_array(padding),
      FixedArray::from_array(strides),
      FixedArray::from_array(dilations),
      layout,
    ),
  ])
  .cast()
}

///|
/// https://www.w3.org/TR/webnn/#dom-mlgraphbuilder-maxpool2d
pub fn MLGraphBuilder::max_pool2d(
  self : MLGraphBuilder,
  input : MLOperand,
  window_dimensions : Array[Int],
  padding : Array[Int],
  strides : Array[Int],
  dilations : Array[Int],
  layout : String,
) -> MLOperand {
  pool2d(
    self, "maxPool2d", input, window_dimensions, padding, strides, dilations, layout,
  )
}

///|
/// https://www.w3.org/TR/webnn/#dom-mlgraphbuilder-averagepool2d
pub fn MLGraphBuilder::average_pool2d(
  self : MLGraphBuilder,
  input : MLOperand,
  window_dimensions : Array[Int],
  padding : Array[Int],
  strides : Array[Int],
  dilations : Array[Int],
  layout : String,
) -> MLOperand {
  pool2d(
    self, "averagePool2d", input, window_dimensions, padding, strides, dilations,
    layout,
  )
}

// ---- compilation -----------------------------------------------------------

///|
/// Compile a graph with a single named output.
/// https://www.w3.org/TR/webnn/#dom-mlgraphbuilder-build
pub async fn MLGraphBuilder::build(
  self : MLGraphBuilder,
  output_name : String,
  output : MLOperand,
) -> MLGraph {
  self.build_many([output_name], [output])
}

///|
/// Compile a graph with several named outputs.
///
/// A builder is spent once built: make a new one for the next graph.
pub async fn MLGraphBuilder::build_many(
  self : MLGraphBuilder,
  output_names : Array[String],
  outputs : Array[MLOperand],
) -> MLGraph {
  let output_values = outputs.map(fn(output) { output.as_any() })
  let promise : @core.Promise[MLGraph] = self
    .as_any()
    ._call("build", [named_values(output_names, output_values)])
    .cast()
  promise.wait()
}
