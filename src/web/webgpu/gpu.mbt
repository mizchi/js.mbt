///|
/// WebGPU API
/// https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API

// =============================================================================
// GPU - Entry point
// =============================================================================

///|
/// GPU interface - entry point for WebGPU
/// https://developer.mozilla.org/en-US/docs/Web/API/GPU
pub(all) struct GPU {}

///|
pub impl @js.JsImpl for GPU

///|
/// Get the GPU object from navigator
extern "js" fn ffi_navigator_gpu() -> @js.Any =
  #| () => navigator.gpu

///|
/// Get the GPU object (returns None if WebGPU is not supported)
pub fn gpu() -> GPU? {
  let g = ffi_navigator_gpu()
  if @js.is_undefined(g) {
    None
  } else {
    Some(g.cast())
  }
}

///|
/// Request a GPUAdapter
/// https://developer.mozilla.org/en-US/docs/Web/API/GPU/requestAdapter
pub async fn GPU::requestAdapter(
  self : GPU,
  power_preference? : String,
  force_fallback_adapter? : Bool,
) -> GPUAdapter? {
  let options = @js.Object::new()
  match power_preference {
    Some(p) => options.set("powerPreference", p)
    None => ()
  }
  match force_fallback_adapter {
    Some(f) => options.set("forceFallbackAdapter", f)
    None => ()
  }
  let promise : @js.Promise[@js.Any] = self
    .call("requestAdapter", [options.to_any()])
    .cast()
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Get the preferred canvas format
/// https://developer.mozilla.org/en-US/docs/Web/API/GPU/getPreferredCanvasFormat
pub fn GPU::getPreferredCanvasFormat(self : GPU) -> String {
  self.call0("getPreferredCanvasFormat").cast()
}

///|
/// Get WGSL language features
pub fn GPU::wgslLanguageFeatures(self : GPU) -> @js.Any {
  self.get("wgslLanguageFeatures")
}

// =============================================================================
// GPUAdapter
// =============================================================================

///|
/// GPUAdapter - represents a GPU adapter
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUAdapter
pub(all) struct GPUAdapter {}

///|
pub impl @js.JsImpl for GPUAdapter

///|
/// Get supported features
pub fn GPUAdapter::features(self : GPUAdapter) -> GPUSupportedFeatures {
  self.get("features").cast()
}

///|
/// Get supported limits
pub fn GPUAdapter::limits(self : GPUAdapter) -> GPUSupportedLimits {
  self.get("limits").cast()
}

///|
/// Get adapter info
pub fn GPUAdapter::info(self : GPUAdapter) -> GPUAdapterInfo {
  self.get("info").cast()
}

///|
/// Check if this is a fallback adapter
pub fn GPUAdapter::isFallbackAdapter(self : GPUAdapter) -> Bool {
  self.get("isFallbackAdapter").cast()
}

///|
/// Request a GPUDevice from this adapter
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUAdapter/requestDevice
pub async fn GPUAdapter::requestDevice(
  self : GPUAdapter,
  label? : String,
  required_features? : Array[String],
  required_limits? : @js.Any,
) -> GPUDevice? {
  let descriptor = @js.Object::new()
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  match required_features {
    Some(features) => {
      let arr = @js.JsArray::from(features.map(fn(f) { @js.any(f) }))
      descriptor.set("requiredFeatures", arr)
    }
    None => ()
  }
  match required_limits {
    Some(limits) => descriptor.set("requiredLimits", limits)
    None => ()
  }
  let promise : @js.Promise[@js.Any] = self
    .call("requestDevice", [descriptor.to_any()])
    .cast()
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

// =============================================================================
// GPUDevice
// =============================================================================

///|
/// GPUDevice - the main interface for WebGPU operations
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice
pub(all) struct GPUDevice {}

///|
pub impl @js.JsImpl for GPUDevice

///|
/// Get the device label
pub fn GPUDevice::label(self : GPUDevice) -> String {
  self.get("label").cast()
}

///|
/// Set the device label
pub fn GPUDevice::set_label(self : GPUDevice, label : String) -> Unit {
  self.set("label", label)
}

///|
/// Get supported features
pub fn GPUDevice::features(self : GPUDevice) -> GPUSupportedFeatures {
  self.get("features").cast()
}

///|
/// Get supported limits
pub fn GPUDevice::limits(self : GPUDevice) -> GPUSupportedLimits {
  self.get("limits").cast()
}

///|
/// Get the device queue
pub fn GPUDevice::queue(self : GPUDevice) -> GPUQueue {
  self.get("queue").cast()
}

///|
/// Get the lost promise
pub fn GPUDevice::lost(self : GPUDevice) -> @js.Promise[GPUDeviceLostInfo] {
  self.get("lost").cast()
}

///|
/// Destroy the device
pub fn GPUDevice::destroy(self : GPUDevice) -> Unit {
  self.call0("destroy") |> ignore
}

///|
/// Create a buffer
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createBuffer
pub fn GPUDevice::createBuffer(
  self : GPUDevice,
  size : Int,
  usage : Int,
  label? : String,
  mapped_at_creation? : Bool,
) -> GPUBuffer {
  let descriptor = @js.Object::new()
  descriptor.set("size", size)
  descriptor.set("usage", usage)
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  match mapped_at_creation {
    Some(m) => descriptor.set("mappedAtCreation", m)
    None => ()
  }
  self.call("createBuffer", [descriptor.to_any()]).cast()
}

///|
/// Create a texture
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createTexture
pub fn GPUDevice::createTexture(
  self : GPUDevice,
  size : GPUExtent3D,
  format : String,
  usage : Int,
  label? : String,
  mip_level_count? : Int,
  sample_count? : Int,
  dimension? : String,
  view_formats? : Array[String],
) -> GPUTexture {
  let descriptor = @js.Object::new()
  descriptor.set("size", size)
  descriptor.set("format", format)
  descriptor.set("usage", usage)
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  match mip_level_count {
    Some(m) => descriptor.set("mipLevelCount", m)
    None => ()
  }
  match sample_count {
    Some(s) => descriptor.set("sampleCount", s)
    None => ()
  }
  match dimension {
    Some(d) => descriptor.set("dimension", d)
    None => ()
  }
  match view_formats {
    Some(vf) => {
      let arr = @js.JsArray::from(vf.map(fn(f) { @js.any(f) }))
      descriptor.set("viewFormats", arr)
    }
    None => ()
  }
  self.call("createTexture", [descriptor.to_any()]).cast()
}

///|
/// Create a shader module
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createShaderModule
pub fn GPUDevice::createShaderModule(
  self : GPUDevice,
  code : String,
  label? : String,
) -> GPUShaderModule {
  let descriptor = @js.Object::new()
  descriptor.set("code", code)
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  self.call("createShaderModule", [descriptor.to_any()]).cast()
}

///|
/// Create a sampler
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createSampler
pub fn GPUDevice::createSampler(
  self : GPUDevice,
  label? : String,
  address_mode_u? : String,
  address_mode_v? : String,
  address_mode_w? : String,
  mag_filter? : String,
  min_filter? : String,
  mipmap_filter? : String,
  lod_min_clamp? : Double,
  lod_max_clamp? : Double,
  compare? : String,
  max_anisotropy? : Int,
) -> GPUSampler {
  let descriptor = @js.Object::new()
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  match address_mode_u {
    Some(m) => descriptor.set("addressModeU", m)
    None => ()
  }
  match address_mode_v {
    Some(m) => descriptor.set("addressModeV", m)
    None => ()
  }
  match address_mode_w {
    Some(m) => descriptor.set("addressModeW", m)
    None => ()
  }
  match mag_filter {
    Some(f) => descriptor.set("magFilter", f)
    None => ()
  }
  match min_filter {
    Some(f) => descriptor.set("minFilter", f)
    None => ()
  }
  match mipmap_filter {
    Some(f) => descriptor.set("mipmapFilter", f)
    None => ()
  }
  match lod_min_clamp {
    Some(l) => descriptor.set("lodMinClamp", l)
    None => ()
  }
  match lod_max_clamp {
    Some(l) => descriptor.set("lodMaxClamp", l)
    None => ()
  }
  match compare {
    Some(c) => descriptor.set("compare", c)
    None => ()
  }
  match max_anisotropy {
    Some(a) => descriptor.set("maxAnisotropy", a)
    None => ()
  }
  self.call("createSampler", [descriptor.to_any()]).cast()
}

///|
/// Create a command encoder
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createCommandEncoder
pub fn GPUDevice::createCommandEncoder(
  self : GPUDevice,
  label? : String,
) -> GPUCommandEncoder {
  let descriptor = @js.Object::new()
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  self.call("createCommandEncoder", [descriptor.to_any()]).cast()
}

///|
/// Create a bind group layout
pub fn GPUDevice::createBindGroupLayout(
  self : GPUDevice,
  entries : @js.Any,
  label? : String,
) -> GPUBindGroupLayout {
  let descriptor = @js.Object::new()
  descriptor.set("entries", entries)
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  self.call("createBindGroupLayout", [descriptor.to_any()]).cast()
}

///|
/// Create a bind group
pub fn GPUDevice::createBindGroup(
  self : GPUDevice,
  layout : GPUBindGroupLayout,
  entries : @js.Any,
  label? : String,
) -> GPUBindGroup {
  let descriptor = @js.Object::new()
  descriptor.set("layout", layout)
  descriptor.set("entries", entries)
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  self.call("createBindGroup", [descriptor.to_any()]).cast()
}

///|
/// Create a pipeline layout
pub fn GPUDevice::createPipelineLayout(
  self : GPUDevice,
  bind_group_layouts : Array[GPUBindGroupLayout],
  label? : String,
) -> GPUPipelineLayout {
  let descriptor = @js.Object::new()
  let arr = @js.JsArray::from(bind_group_layouts.map(fn(l) { l.to_any() }))
  descriptor.set("bindGroupLayouts", arr)
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  self.call("createPipelineLayout", [descriptor.to_any()]).cast()
}

///|
/// Create a render pipeline
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createRenderPipeline
pub fn GPUDevice::createRenderPipeline(
  self : GPUDevice,
  descriptor : @js.Any,
) -> GPURenderPipeline {
  self.call("createRenderPipeline", [descriptor]).cast()
}

///|
/// Create a compute pipeline
pub fn GPUDevice::createComputePipeline(
  self : GPUDevice,
  descriptor : @js.Any,
) -> GPUComputePipeline {
  self.call("createComputePipeline", [descriptor]).cast()
}

///|
/// Push an error scope
pub fn GPUDevice::pushErrorScope(self : GPUDevice, filter : String) -> Unit {
  self.call("pushErrorScope", [filter]) |> ignore
}

///|
/// Pop an error scope
pub async fn GPUDevice::popErrorScope(self : GPUDevice) -> GPUError? {
  let promise : @js.Promise[@js.Any] = self.call0("popErrorScope").cast()
  let result = promise.wait()
  if @js.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

// =============================================================================
// GPUBuffer
// =============================================================================

///|
/// GPUBuffer - represents a block of memory for GPU operations
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUBuffer
pub(all) struct GPUBuffer {}

///|
pub impl @js.JsImpl for GPUBuffer

///|
/// Buffer usage flags
pub const BUFFER_USAGE_MAP_READ : Int = 0x0001

///|
pub const BUFFER_USAGE_MAP_WRITE : Int = 0x0002

///|
pub const BUFFER_USAGE_COPY_SRC : Int = 0x0004

///|
pub const BUFFER_USAGE_COPY_DST : Int = 0x0008

///|
pub const BUFFER_USAGE_INDEX : Int = 0x0010

///|
pub const BUFFER_USAGE_VERTEX : Int = 0x0020

///|
pub const BUFFER_USAGE_UNIFORM : Int = 0x0040

///|
pub const BUFFER_USAGE_STORAGE : Int = 0x0080

///|
pub const BUFFER_USAGE_INDIRECT : Int = 0x0100

///|
pub const BUFFER_USAGE_QUERY_RESOLVE : Int = 0x0200

///|
/// Get buffer size
pub fn GPUBuffer::size(self : GPUBuffer) -> Int {
  self.get("size").cast()
}

///|
/// Get buffer usage
pub fn GPUBuffer::usage(self : GPUBuffer) -> Int {
  self.get("usage").cast()
}

///|
/// Get buffer map state
pub fn GPUBuffer::mapState(self : GPUBuffer) -> String {
  self.get("mapState").cast()
}

///|
/// Get buffer label
pub fn GPUBuffer::label(self : GPUBuffer) -> String {
  self.get("label").cast()
}

///|
/// Map the buffer for reading/writing
pub async fn GPUBuffer::mapAsync(
  self : GPUBuffer,
  mode : Int,
  offset? : Int,
  size? : Int,
) -> Unit {
  let promise : @js.Promise[Unit] = match (offset, size) {
    (None, None) => self.call("mapAsync", [mode]).cast()
    (Some(o), None) => self.call2("mapAsync", mode, o).cast()
    (Some(o), Some(s)) => self.call("mapAsync", [mode, o, s]).cast()
    (None, Some(s)) => self.call("mapAsync", [mode, 0, s]).cast()
  }
  promise.wait()
}

///|
/// Get mapped range as ArrayBuffer
pub fn GPUBuffer::getMappedRange(
  self : GPUBuffer,
  offset? : Int,
  size? : Int,
) -> @js.ArrayBuffer {
  match (offset, size) {
    (None, None) => self.call0("getMappedRange").cast()
    (Some(o), None) => self.call("getMappedRange", [o]).cast()
    (Some(o), Some(s)) => self.call2("getMappedRange", o, s).cast()
    (None, Some(s)) => self.call2("getMappedRange", 0, s).cast()
  }
}

///|
/// Unmap the buffer
pub fn GPUBuffer::unmap(self : GPUBuffer) -> Unit {
  self.call0("unmap") |> ignore
}

///|
/// Destroy the buffer
pub fn GPUBuffer::destroy(self : GPUBuffer) -> Unit {
  self.call0("destroy") |> ignore
}

// =============================================================================
// GPUTexture
// =============================================================================

///|
/// GPUTexture - represents a texture for GPU operations
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUTexture
pub(all) struct GPUTexture {}

///|
pub impl @js.JsImpl for GPUTexture

///|
/// Texture usage flags
pub const TEXTURE_USAGE_COPY_SRC : Int = 0x01

///|
pub const TEXTURE_USAGE_COPY_DST : Int = 0x02

///|
pub const TEXTURE_USAGE_TEXTURE_BINDING : Int = 0x04

///|
pub const TEXTURE_USAGE_STORAGE_BINDING : Int = 0x08

///|
pub const TEXTURE_USAGE_RENDER_ATTACHMENT : Int = 0x10

///|
/// Get texture width
pub fn GPUTexture::width(self : GPUTexture) -> Int {
  self.get("width").cast()
}

///|
/// Get texture height
pub fn GPUTexture::height(self : GPUTexture) -> Int {
  self.get("height").cast()
}

///|
/// Get texture depth or array layers
pub fn GPUTexture::depthOrArrayLayers(self : GPUTexture) -> Int {
  self.get("depthOrArrayLayers").cast()
}

///|
/// Get texture format
pub fn GPUTexture::format(self : GPUTexture) -> String {
  self.get("format").cast()
}

///|
/// Get mip level count
pub fn GPUTexture::mipLevelCount(self : GPUTexture) -> Int {
  self.get("mipLevelCount").cast()
}

///|
/// Get sample count
pub fn GPUTexture::sampleCount(self : GPUTexture) -> Int {
  self.get("sampleCount").cast()
}

///|
/// Get texture dimension
pub fn GPUTexture::dimension(self : GPUTexture) -> String {
  self.get("dimension").cast()
}

///|
/// Get texture usage
pub fn GPUTexture::usage(self : GPUTexture) -> Int {
  self.get("usage").cast()
}

///|
/// Create a texture view
pub fn GPUTexture::createView(
  self : GPUTexture,
  format? : String,
  dimension? : String,
  aspect? : String,
  base_mip_level? : Int,
  mip_level_count? : Int,
  base_array_layer? : Int,
  array_layer_count? : Int,
  label? : String,
) -> GPUTextureView {
  let descriptor = @js.Object::new()
  match format {
    Some(f) => descriptor.set("format", f)
    None => ()
  }
  match dimension {
    Some(d) => descriptor.set("dimension", d)
    None => ()
  }
  match aspect {
    Some(a) => descriptor.set("aspect", a)
    None => ()
  }
  match base_mip_level {
    Some(b) => descriptor.set("baseMipLevel", b)
    None => ()
  }
  match mip_level_count {
    Some(m) => descriptor.set("mipLevelCount", m)
    None => ()
  }
  match base_array_layer {
    Some(b) => descriptor.set("baseArrayLayer", b)
    None => ()
  }
  match array_layer_count {
    Some(a) => descriptor.set("arrayLayerCount", a)
    None => ()
  }
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  self.call("createView", [descriptor.to_any()]).cast()
}

///|
/// Destroy the texture
pub fn GPUTexture::destroy(self : GPUTexture) -> Unit {
  self.call0("destroy") |> ignore
}

// =============================================================================
// GPUTextureView
// =============================================================================

///|
/// GPUTextureView - a view into a texture
pub(all) struct GPUTextureView {}

///|
pub impl @js.JsImpl for GPUTextureView

///|
pub fn GPUTextureView::label(self : GPUTextureView) -> String {
  self.get("label").cast()
}

// =============================================================================
// GPUQueue
// =============================================================================

///|
/// GPUQueue - command queue for GPU operations
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUQueue
pub(all) struct GPUQueue {}

///|
pub impl @js.JsImpl for GPUQueue

///|
/// Submit command buffers to the queue
pub fn GPUQueue::submit(
  self : GPUQueue,
  command_buffers : Array[GPUCommandBuffer],
) -> Unit {
  let arr = @js.JsArray::from(command_buffers.map(fn(cb) { cb.to_any() }))
  self.call("submit", [arr.to_any()]) |> ignore
}

///|
/// Write data to a buffer
pub fn GPUQueue::writeBuffer(
  self : GPUQueue,
  buffer : GPUBuffer,
  buffer_offset : Int,
  data : @js.Any,
  data_offset? : Int,
  size? : Int,
) -> Unit {
  match (data_offset, size) {
    (None, None) =>
      self.call("writeBuffer", [buffer.to_any(), buffer_offset, data]) |> ignore
    (Some(do_), None) =>
      self.call("writeBuffer", [buffer.to_any(), buffer_offset, data, do_])
      |> ignore
    (Some(do_), Some(s)) =>
      self.call("writeBuffer", [buffer.to_any(), buffer_offset, data, do_, s])
      |> ignore
    (None, Some(s)) =>
      self.call("writeBuffer", [buffer.to_any(), buffer_offset, data, 0, s])
      |> ignore
  }
}

///|
/// Write data to a texture
pub fn GPUQueue::writeTexture(
  self : GPUQueue,
  destination : @js.Any,
  data : @js.Any,
  data_layout : @js.Any,
  size : GPUExtent3D,
) -> Unit {
  self.call("writeTexture", [destination, data, data_layout, size.to_any()])
  |> ignore
}

///|
/// Get a promise that resolves when all submitted work is done
pub async fn GPUQueue::onSubmittedWorkDone(self : GPUQueue) -> Unit {
  let promise : @js.Promise[Unit] = self.call0("onSubmittedWorkDone").cast()
  promise.wait()
}

// =============================================================================
// GPUCommandEncoder
// =============================================================================

///|
/// GPUCommandEncoder - encodes GPU commands
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUCommandEncoder
pub(all) struct GPUCommandEncoder {}

///|
pub impl @js.JsImpl for GPUCommandEncoder

///|
pub fn GPUCommandEncoder::label(self : GPUCommandEncoder) -> String {
  self.get("label").cast()
}

///|
/// Begin a render pass
pub fn GPUCommandEncoder::beginRenderPass(
  self : GPUCommandEncoder,
  descriptor : @js.Any,
) -> GPURenderPassEncoder {
  self.call("beginRenderPass", [descriptor]).cast()
}

///|
/// Begin a compute pass
pub fn GPUCommandEncoder::beginComputePass(
  self : GPUCommandEncoder,
  label? : String,
) -> GPUComputePassEncoder {
  let descriptor = @js.Object::new()
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  self.call("beginComputePass", [descriptor.to_any()]).cast()
}

///|
/// Copy buffer to buffer
pub fn GPUCommandEncoder::copyBufferToBuffer(
  self : GPUCommandEncoder,
  source : GPUBuffer,
  source_offset : Int,
  destination : GPUBuffer,
  destination_offset : Int,
  size : Int,
) -> Unit {
  self.call("copyBufferToBuffer", [
    source.to_any(),
    source_offset,
    destination.to_any(),
    destination_offset,
    size,
  ])
  |> ignore
}

///|
/// Copy buffer to texture
pub fn GPUCommandEncoder::copyBufferToTexture(
  self : GPUCommandEncoder,
  source : @js.Any,
  destination : @js.Any,
  copy_size : GPUExtent3D,
) -> Unit {
  self.call("copyBufferToTexture", [source, destination, copy_size.to_any()])
  |> ignore
}

///|
/// Copy texture to buffer
pub fn GPUCommandEncoder::copyTextureToBuffer(
  self : GPUCommandEncoder,
  source : @js.Any,
  destination : @js.Any,
  copy_size : GPUExtent3D,
) -> Unit {
  self.call("copyTextureToBuffer", [source, destination, copy_size.to_any()])
  |> ignore
}

///|
/// Copy texture to texture
pub fn GPUCommandEncoder::copyTextureToTexture(
  self : GPUCommandEncoder,
  source : @js.Any,
  destination : @js.Any,
  copy_size : GPUExtent3D,
) -> Unit {
  self.call("copyTextureToTexture", [source, destination, copy_size.to_any()])
  |> ignore
}

///|
/// Clear a buffer
pub fn GPUCommandEncoder::clearBuffer(
  self : GPUCommandEncoder,
  buffer : GPUBuffer,
  offset? : Int,
  size? : Int,
) -> Unit {
  match (offset, size) {
    (None, None) => self.call("clearBuffer", [buffer.to_any()]) |> ignore
    (Some(o), None) => self.call2("clearBuffer", buffer.to_any(), o) |> ignore
    (Some(o), Some(s)) =>
      self.call("clearBuffer", [buffer.to_any(), o, s]) |> ignore
    (None, Some(s)) =>
      self.call("clearBuffer", [buffer.to_any(), 0, s]) |> ignore
  }
}

///|
/// Finish encoding and return command buffer
pub fn GPUCommandEncoder::finish(
  self : GPUCommandEncoder,
  label? : String,
) -> GPUCommandBuffer {
  let descriptor = @js.Object::new()
  match label {
    Some(l) => descriptor.set("label", l)
    None => ()
  }
  self.call("finish", [descriptor.to_any()]).cast()
}

// =============================================================================
// GPUCommandBuffer
// =============================================================================

///|
/// GPUCommandBuffer - contains encoded GPU commands
pub(all) struct GPUCommandBuffer {}

///|
pub impl @js.JsImpl for GPUCommandBuffer

///|
pub fn GPUCommandBuffer::label(self : GPUCommandBuffer) -> String {
  self.get("label").cast()
}

// =============================================================================
// GPURenderPassEncoder
// =============================================================================

///|
/// GPURenderPassEncoder - encodes render pass commands
pub(all) struct GPURenderPassEncoder {}

///|
pub impl @js.JsImpl for GPURenderPassEncoder

///|
/// Set the render pipeline
pub fn GPURenderPassEncoder::setPipeline(
  self : GPURenderPassEncoder,
  pipeline : GPURenderPipeline,
) -> Unit {
  self.call("setPipeline", [pipeline.to_any()]) |> ignore
}

///|
/// Set a bind group
pub fn GPURenderPassEncoder::setBindGroup(
  self : GPURenderPassEncoder,
  index : Int,
  bind_group : GPUBindGroup,
) -> Unit {
  self.call2("setBindGroup", index, bind_group.to_any()) |> ignore
}

///|
/// Set vertex buffer
pub fn GPURenderPassEncoder::setVertexBuffer(
  self : GPURenderPassEncoder,
  slot : Int,
  buffer : GPUBuffer,
  offset? : Int,
  size? : Int,
) -> Unit {
  match (offset, size) {
    (None, None) =>
      self.call2("setVertexBuffer", slot, buffer.to_any()) |> ignore
    (Some(o), None) =>
      self.call("setVertexBuffer", [slot, buffer.to_any(), o]) |> ignore
    (Some(o), Some(s)) =>
      self.call("setVertexBuffer", [slot, buffer.to_any(), o, s]) |> ignore
    (None, Some(s)) =>
      self.call("setVertexBuffer", [slot, buffer.to_any(), 0, s]) |> ignore
  }
}

///|
/// Set index buffer
pub fn GPURenderPassEncoder::setIndexBuffer(
  self : GPURenderPassEncoder,
  buffer : GPUBuffer,
  format : String,
  offset? : Int,
  size? : Int,
) -> Unit {
  match (offset, size) {
    (None, None) =>
      self.call2("setIndexBuffer", buffer.to_any(), format) |> ignore
    (Some(o), None) =>
      self.call("setIndexBuffer", [buffer.to_any(), format, o]) |> ignore
    (Some(o), Some(s)) =>
      self.call("setIndexBuffer", [buffer.to_any(), format, o, s]) |> ignore
    (None, Some(s)) =>
      self.call("setIndexBuffer", [buffer.to_any(), format, 0, s]) |> ignore
  }
}

///|
/// Draw primitives
pub fn GPURenderPassEncoder::draw(
  self : GPURenderPassEncoder,
  vertex_count : Int,
  instance_count? : Int,
  first_vertex? : Int,
  first_instance? : Int,
) -> Unit {
  match (instance_count, first_vertex, first_instance) {
    (None, None, None) => self.call("draw", [vertex_count]) |> ignore
    (Some(ic), None, None) => self.call2("draw", vertex_count, ic) |> ignore
    (Some(ic), Some(fv), None) =>
      self.call("draw", [vertex_count, ic, fv]) |> ignore
    (Some(ic), Some(fv), Some(fi)) =>
      self.call("draw", [vertex_count, ic, fv, fi]) |> ignore
    (None, Some(fv), fi) =>
      match fi {
        Some(f) => self.call("draw", [vertex_count, 1, fv, f]) |> ignore
        None => self.call("draw", [vertex_count, 1, fv]) |> ignore
      }
    (Some(ic), None, Some(fi)) =>
      self.call("draw", [vertex_count, ic, 0, fi]) |> ignore
    (None, None, Some(fi)) =>
      self.call("draw", [vertex_count, 1, 0, fi]) |> ignore
  }
}

///|
/// Draw indexed primitives
pub fn GPURenderPassEncoder::drawIndexed(
  self : GPURenderPassEncoder,
  index_count : Int,
  instance_count? : Int,
  first_index? : Int,
  base_vertex? : Int,
  first_instance? : Int,
) -> Unit {
  match (instance_count, first_index, base_vertex, first_instance) {
    (None, None, None, None) =>
      self.call("drawIndexed", [index_count]) |> ignore
    (Some(ic), None, None, None) =>
      self.call2("drawIndexed", index_count, ic) |> ignore
    (Some(ic), Some(fi), None, None) =>
      self.call("drawIndexed", [index_count, ic, fi]) |> ignore
    (Some(ic), Some(fi), Some(bv), None) =>
      self.call("drawIndexed", [index_count, ic, fi, bv]) |> ignore
    (Some(ic), Some(fi), Some(bv), Some(fii)) =>
      self.call("drawIndexed", [index_count, ic, fi, bv, fii]) |> ignore
    _ => self.call("drawIndexed", [index_count]) |> ignore
  }
}

///|
/// Set viewport
pub fn GPURenderPassEncoder::setViewport(
  self : GPURenderPassEncoder,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
  min_depth : Double,
  max_depth : Double,
) -> Unit {
  self.call("setViewport", [x, y, width, height, min_depth, max_depth])
  |> ignore
}

///|
/// Set scissor rect
pub fn GPURenderPassEncoder::setScissorRect(
  self : GPURenderPassEncoder,
  x : Int,
  y : Int,
  width : Int,
  height : Int,
) -> Unit {
  self.call("setScissorRect", [x, y, width, height]) |> ignore
}

///|
/// Set blend constant
pub fn GPURenderPassEncoder::setBlendConstant(
  self : GPURenderPassEncoder,
  color : @js.Any,
) -> Unit {
  self.call("setBlendConstant", [color]) |> ignore
}

///|
/// Set stencil reference
pub fn GPURenderPassEncoder::setStencilReference(
  self : GPURenderPassEncoder,
  reference : Int,
) -> Unit {
  self.call("setStencilReference", [reference]) |> ignore
}

///|
/// End the render pass
pub fn GPURenderPassEncoder::end(self : GPURenderPassEncoder) -> Unit {
  self.call0("end") |> ignore
}

// =============================================================================
// GPUComputePassEncoder
// =============================================================================

///|
/// GPUComputePassEncoder - encodes compute pass commands
pub(all) struct GPUComputePassEncoder {}

///|
pub impl @js.JsImpl for GPUComputePassEncoder

///|
/// Set the compute pipeline
pub fn GPUComputePassEncoder::setPipeline(
  self : GPUComputePassEncoder,
  pipeline : GPUComputePipeline,
) -> Unit {
  self.call("setPipeline", [pipeline.to_any()]) |> ignore
}

///|
/// Set a bind group
pub fn GPUComputePassEncoder::setBindGroup(
  self : GPUComputePassEncoder,
  index : Int,
  bind_group : GPUBindGroup,
) -> Unit {
  self.call2("setBindGroup", index, bind_group.to_any()) |> ignore
}

///|
/// Dispatch workgroups
pub fn GPUComputePassEncoder::dispatchWorkgroups(
  self : GPUComputePassEncoder,
  workgroup_count_x : Int,
  workgroup_count_y? : Int,
  workgroup_count_z? : Int,
) -> Unit {
  match (workgroup_count_y, workgroup_count_z) {
    (None, None) =>
      self.call("dispatchWorkgroups", [workgroup_count_x]) |> ignore
    (Some(y), None) =>
      self.call2("dispatchWorkgroups", workgroup_count_x, y) |> ignore
    (Some(y), Some(z)) =>
      self.call("dispatchWorkgroups", [workgroup_count_x, y, z]) |> ignore
    (None, Some(z)) =>
      self.call("dispatchWorkgroups", [workgroup_count_x, 1, z]) |> ignore
  }
}

///|
/// Dispatch workgroups indirect
pub fn GPUComputePassEncoder::dispatchWorkgroupsIndirect(
  self : GPUComputePassEncoder,
  indirect_buffer : GPUBuffer,
  indirect_offset : Int,
) -> Unit {
  self.call2(
    "dispatchWorkgroupsIndirect",
    indirect_buffer.to_any(),
    indirect_offset,
  )
  |> ignore
}

///|
/// End the compute pass
pub fn GPUComputePassEncoder::end(self : GPUComputePassEncoder) -> Unit {
  self.call0("end") |> ignore
}

// =============================================================================
// GPURenderPipeline
// =============================================================================

///|
/// GPURenderPipeline - render pipeline configuration
pub(all) struct GPURenderPipeline {}

///|
pub impl @js.JsImpl for GPURenderPipeline

///|
pub fn GPURenderPipeline::label(self : GPURenderPipeline) -> String {
  self.get("label").cast()
}

///|
/// Get the bind group layout at an index
pub fn GPURenderPipeline::getBindGroupLayout(
  self : GPURenderPipeline,
  index : Int,
) -> GPUBindGroupLayout {
  self.call("getBindGroupLayout", [index]).cast()
}

// =============================================================================
// GPUComputePipeline
// =============================================================================

///|
/// GPUComputePipeline - compute pipeline configuration
pub(all) struct GPUComputePipeline {}

///|
pub impl @js.JsImpl for GPUComputePipeline

///|
pub fn GPUComputePipeline::label(self : GPUComputePipeline) -> String {
  self.get("label").cast()
}

///|
/// Get the bind group layout at an index
pub fn GPUComputePipeline::getBindGroupLayout(
  self : GPUComputePipeline,
  index : Int,
) -> GPUBindGroupLayout {
  self.call("getBindGroupLayout", [index]).cast()
}

// =============================================================================
// GPUShaderModule
// =============================================================================

///|
/// GPUShaderModule - compiled shader code
pub(all) struct GPUShaderModule {}

///|
pub impl @js.JsImpl for GPUShaderModule

///|
pub fn GPUShaderModule::label(self : GPUShaderModule) -> String {
  self.get("label").cast()
}

///|
/// Get compilation info
pub async fn GPUShaderModule::getCompilationInfo(
  self : GPUShaderModule,
) -> GPUCompilationInfo {
  let promise : @js.Promise[GPUCompilationInfo] = self
    .call0("getCompilationInfo")
    .cast()
  promise.wait()
}

// =============================================================================
// GPUSampler
// =============================================================================

///|
/// GPUSampler - texture sampling configuration
pub(all) struct GPUSampler {}

///|
pub impl @js.JsImpl for GPUSampler

///|
pub fn GPUSampler::label(self : GPUSampler) -> String {
  self.get("label").cast()
}

// =============================================================================
// GPUBindGroup
// =============================================================================

///|
/// GPUBindGroup - group of resources bound together
pub(all) struct GPUBindGroup {}

///|
pub impl @js.JsImpl for GPUBindGroup

///|
pub fn GPUBindGroup::label(self : GPUBindGroup) -> String {
  self.get("label").cast()
}

// =============================================================================
// GPUBindGroupLayout
// =============================================================================

///|
/// GPUBindGroupLayout - layout of a bind group
pub(all) struct GPUBindGroupLayout {}

///|
pub impl @js.JsImpl for GPUBindGroupLayout

///|
pub fn GPUBindGroupLayout::label(self : GPUBindGroupLayout) -> String {
  self.get("label").cast()
}

// =============================================================================
// GPUPipelineLayout
// =============================================================================

///|
/// GPUPipelineLayout - layout of pipeline bind groups
pub(all) struct GPUPipelineLayout {}

///|
pub impl @js.JsImpl for GPUPipelineLayout

///|
pub fn GPUPipelineLayout::label(self : GPUPipelineLayout) -> String {
  self.get("label").cast()
}

// =============================================================================
// Supporting types
// =============================================================================

///|
/// GPUSupportedFeatures - set of supported GPU features
pub(all) struct GPUSupportedFeatures {}

///|
pub impl @js.JsImpl for GPUSupportedFeatures

///|
/// Check if a feature is supported
pub fn GPUSupportedFeatures::has(
  self : GPUSupportedFeatures,
  feature : String,
) -> Bool {
  self.call("has", [feature]).cast()
}

///|
/// GPUSupportedLimits - supported GPU limits
pub(all) struct GPUSupportedLimits {}

///|
pub impl @js.JsImpl for GPUSupportedLimits

///|
/// Get max texture dimension 1D
pub fn GPUSupportedLimits::maxTextureDimension1D(
  self : GPUSupportedLimits,
) -> Int {
  self.get("maxTextureDimension1D").cast()
}

///|
/// Get max texture dimension 2D
pub fn GPUSupportedLimits::maxTextureDimension2D(
  self : GPUSupportedLimits,
) -> Int {
  self.get("maxTextureDimension2D").cast()
}

///|
/// Get max texture dimension 3D
pub fn GPUSupportedLimits::maxTextureDimension3D(
  self : GPUSupportedLimits,
) -> Int {
  self.get("maxTextureDimension3D").cast()
}

///|
/// Get max buffer size
pub fn GPUSupportedLimits::maxBufferSize(self : GPUSupportedLimits) -> Int {
  self.get("maxBufferSize").cast()
}

///|
/// Get max bind groups
pub fn GPUSupportedLimits::maxBindGroups(self : GPUSupportedLimits) -> Int {
  self.get("maxBindGroups").cast()
}

///|
/// GPUAdapterInfo - information about the GPU adapter
pub(all) struct GPUAdapterInfo {}

///|
pub impl @js.JsImpl for GPUAdapterInfo

///|
/// Get vendor name
pub fn GPUAdapterInfo::vendor(self : GPUAdapterInfo) -> String {
  self.get("vendor").cast()
}

///|
/// Get architecture
pub fn GPUAdapterInfo::architecture(self : GPUAdapterInfo) -> String {
  self.get("architecture").cast()
}

///|
/// Get device name
pub fn GPUAdapterInfo::device(self : GPUAdapterInfo) -> String {
  self.get("device").cast()
}

///|
/// Get description
pub fn GPUAdapterInfo::description(self : GPUAdapterInfo) -> String {
  self.get("description").cast()
}

///|
/// GPUDeviceLostInfo - information about a lost device
pub(all) struct GPUDeviceLostInfo {}

///|
pub impl @js.JsImpl for GPUDeviceLostInfo

///|
/// Get the reason for device loss
pub fn GPUDeviceLostInfo::reason(self : GPUDeviceLostInfo) -> String {
  self.get("reason").cast()
}

///|
/// Get the message
pub fn GPUDeviceLostInfo::message(self : GPUDeviceLostInfo) -> String {
  self.get("message").cast()
}

///|
/// GPUError - base type for GPU errors
pub(all) struct GPUError {}

///|
pub impl @js.JsImpl for GPUError

///|
/// Get error message
pub fn GPUError::message(self : GPUError) -> String {
  self.get("message").cast()
}

///|
/// GPUCompilationInfo - shader compilation info
pub(all) struct GPUCompilationInfo {}

///|
pub impl @js.JsImpl for GPUCompilationInfo

///|
/// Get compilation messages
pub fn GPUCompilationInfo::messages(self : GPUCompilationInfo) -> @js.JsArray {
  self.get("messages").cast()
}

///|
/// GPUCompilationMessage - a single compilation message
pub(all) struct GPUCompilationMessage {}

///|
pub impl @js.JsImpl for GPUCompilationMessage

///|
/// Get message text
pub fn GPUCompilationMessage::message(self : GPUCompilationMessage) -> String {
  self.get("message").cast()
}

///|
/// Get message type (error, warning, info)
pub fn GPUCompilationMessage::type_(self : GPUCompilationMessage) -> String {
  self.get("type").cast()
}

///|
/// Get line number
pub fn GPUCompilationMessage::lineNum(self : GPUCompilationMessage) -> Int {
  self.get("lineNum").cast()
}

///|
/// Get line position
pub fn GPUCompilationMessage::linePos(self : GPUCompilationMessage) -> Int {
  self.get("linePos").cast()
}

// =============================================================================
// GPUExtent3D - helper for size specifications
// =============================================================================

///|
/// GPUExtent3D - represents 3D extents
pub(all) struct GPUExtent3D {}

///|
pub impl @js.JsImpl for GPUExtent3D

///|
/// Create GPUExtent3D from width, height, depth
pub fn GPUExtent3D::new(
  width : Int,
  height? : Int,
  depth_or_array_layers? : Int,
) -> GPUExtent3D {
  let obj = @js.Object::new()
  obj.set("width", width)
  match height {
    Some(h) => obj.set("height", h)
    None => ()
  }
  match depth_or_array_layers {
    Some(d) => obj.set("depthOrArrayLayers", d)
    None => ()
  }
  obj.to_any().cast()
}

///|
/// Create GPUExtent3D from an array [width, height?, depthOrArrayLayers?]
pub fn GPUExtent3D::from_array(arr : Array[Int]) -> GPUExtent3D {
  @js.JsArray::from(arr.map(fn(x) { @js.any(x) })).to_any().cast()
}
