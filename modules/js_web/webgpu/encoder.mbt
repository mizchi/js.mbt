// =============================================================================
// Additions to the encoder types: debug markers, indirect draws and async
// pipeline creation.
// =============================================================================

// ---- async pipeline creation -----------------------------------------------

///|
/// Create a render pipeline without blocking on shader compilation.
///
/// Prefer this over `createRenderPipeline` when the pipeline is not needed
/// this frame: the synchronous form can stall while shaders compile. Rejection
/// carries a `GPUPipelineError`.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createRenderPipelineAsync
pub async fn GPUDevice::createRenderPipelineAsync(
  self : GPUDevice,
  descriptor : @core.Any,
) -> GPURenderPipeline {
  let promise : @core.Promise[@core.Any] = self
    .as_any()
    ._call("createRenderPipelineAsync", [descriptor])
    .cast()
  promise.wait().cast()
}

///|
/// Create a compute pipeline without blocking on shader compilation.
/// Rejection carries a `GPUPipelineError`.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createComputePipelineAsync
pub async fn GPUDevice::createComputePipelineAsync(
  self : GPUDevice,
  descriptor : @core.Any,
) -> GPUComputePipeline {
  let promise : @core.Promise[@core.Any] = self
    .as_any()
    ._call("createComputePipelineAsync", [descriptor])
    .cast()
  promise.wait().cast()
}

///|
/// Information about the adapter this device came from.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/adapterInfo
pub fn GPUDevice::adapterInfo(self : GPUDevice) -> GPUAdapterInfo {
  self.as_any()["adapterInfo"].cast()
}

// ---- indirect draws --------------------------------------------------------

///|
/// Draw with the vertex and instance counts read from a buffer rather than
/// passed here. The buffer needs `BUFFER_USAGE_INDIRECT`.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPURenderPassEncoder/drawIndirect
pub fn GPURenderPassEncoder::drawIndirect(
  self : GPURenderPassEncoder,
  indirect_buffer : GPUBuffer,
  indirect_offset : Int,
) -> Unit {
  self
  .as_any()
  ._call("drawIndirect", [indirect_buffer.as_any(), @core.any(indirect_offset)])
  |> ignore
}

///|
/// Indexed draw with its parameters read from a buffer.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPURenderPassEncoder/drawIndexedIndirect
pub fn GPURenderPassEncoder::drawIndexedIndirect(
  self : GPURenderPassEncoder,
  indirect_buffer : GPUBuffer,
  indirect_offset : Int,
) -> Unit {
  self
  .as_any()
  ._call("drawIndexedIndirect", [
    indirect_buffer.as_any(),
    @core.any(indirect_offset),
  ])
  |> ignore
}

// ---- debug markers ---------------------------------------------------------
//
// These name regions of work so they show up in a GPU debugger such as
// Chrome's WebGPU DevTools panel. They have no effect otherwise.

///|
/// Open a labelled debug group on a command encoder.
pub fn GPUCommandEncoder::pushDebugGroup(
  self : GPUCommandEncoder,
  group_label : String,
) -> Unit {
  self.as_any()._call("pushDebugGroup", [@core.any(group_label)]) |> ignore
}

///|
/// Close the most recently opened debug group.
pub fn GPUCommandEncoder::popDebugGroup(self : GPUCommandEncoder) -> Unit {
  self.as_any()._call("popDebugGroup", []) |> ignore
}

///|
/// Insert a single labelled marker.
pub fn GPUCommandEncoder::insertDebugMarker(
  self : GPUCommandEncoder,
  marker_label : String,
) -> Unit {
  self.as_any()._call("insertDebugMarker", [@core.any(marker_label)]) |> ignore
}

///|
/// Open a labelled debug group on a render pass.
pub fn GPURenderPassEncoder::pushDebugGroup(
  self : GPURenderPassEncoder,
  group_label : String,
) -> Unit {
  self.as_any()._call("pushDebugGroup", [@core.any(group_label)]) |> ignore
}

///|
/// Close the most recently opened debug group.
pub fn GPURenderPassEncoder::popDebugGroup(self : GPURenderPassEncoder) -> Unit {
  self.as_any()._call("popDebugGroup", []) |> ignore
}

///|
/// Insert a single labelled marker.
pub fn GPURenderPassEncoder::insertDebugMarker(
  self : GPURenderPassEncoder,
  marker_label : String,
) -> Unit {
  self.as_any()._call("insertDebugMarker", [@core.any(marker_label)]) |> ignore
}

///|
/// Open a labelled debug group on a compute pass.
pub fn GPUComputePassEncoder::pushDebugGroup(
  self : GPUComputePassEncoder,
  group_label : String,
) -> Unit {
  self.as_any()._call("pushDebugGroup", [@core.any(group_label)]) |> ignore
}

///|
/// Close the most recently opened debug group.
pub fn GPUComputePassEncoder::popDebugGroup(
  self : GPUComputePassEncoder,
) -> Unit {
  self.as_any()._call("popDebugGroup", []) |> ignore
}

///|
/// Insert a single labelled marker.
pub fn GPUComputePassEncoder::insertDebugMarker(
  self : GPUComputePassEncoder,
  marker_label : String,
) -> Unit {
  self.as_any()._call("insertDebugMarker", [@core.any(marker_label)]) |> ignore
}

// ---- adapter info additions ------------------------------------------------

///|
/// Whether this adapter is a fallback (software) adapter.
///
/// This replaces `GPUAdapter::isFallbackAdapter`, which the spec moved onto
/// the info object.
pub fn GPUAdapterInfo::isFallbackAdapter(self : GPUAdapterInfo) -> Bool {
  self.as_any()["isFallbackAdapter"].cast()
}

///|
/// Smallest subgroup size the adapter supports, or `None` if it does not
/// report subgroup sizes.
///
/// Worth checking when a shader hardcodes a subgroup width -- see the
/// "subgroups" feature.
pub fn GPUAdapterInfo::subgroupMinSize(self : GPUAdapterInfo) -> Int? {
  let v = self.as_any()["subgroupMinSize"]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Largest subgroup size the adapter supports, or `None` if it does not
/// report subgroup sizes.
pub fn GPUAdapterInfo::subgroupMaxSize(self : GPUAdapterInfo) -> Int? {
  let v = self.as_any()["subgroupMaxSize"]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}
