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
pub fn GPU::as_any(self : GPU) -> @nostd.Any = "%identity"

///|
/// Get the GPU object from navigator
extern "js" fn ffi_navigator_gpu() -> @nostd.Any =
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
  let options = @nostd.Object::new()
  match power_preference {
    Some(p) => options._set("powerPreference", @nostd.any(p))
    None => ()
  }
  match force_fallback_adapter {
    Some(f) => options._set("forceFallbackAdapter", @nostd.any(f))
    None => ()
  }
  let promise : @js.Promise[@nostd.Any] = self
    .as_any()
    ._call("requestAdapter", [options])
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
  self.as_any()._call("getPreferredCanvasFormat", []).cast()
}

///|
/// Get WGSL language features
pub fn GPU::wgslLanguageFeatures(self : GPU) -> @nostd.Any {
  self.as_any()["wgslLanguageFeatures"].cast()
}

// =============================================================================
// GPUAdapter
// =============================================================================

///|
/// GPUAdapter - represents a GPU adapter
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUAdapter
pub(all) struct GPUAdapter {}

///|
pub fn GPUAdapter::as_any(self : GPUAdapter) -> @nostd.Any = "%identity"

///|
/// Get supported features
pub fn GPUAdapter::features(self : GPUAdapter) -> GPUSupportedFeatures {
  self.as_any()["features"].cast()
}

///|
/// Get supported limits
pub fn GPUAdapter::limits(self : GPUAdapter) -> GPUSupportedLimits {
  self.as_any()["limits"].cast()
}

///|
/// Get adapter info
pub fn GPUAdapter::info(self : GPUAdapter) -> GPUAdapterInfo {
  self.as_any()["info"].cast()
}

///|
/// Check if this is a fallback adapter
pub fn GPUAdapter::isFallbackAdapter(self : GPUAdapter) -> Bool {
  self.as_any()["isFallbackAdapter"].cast()
}

///|
/// Request a GPUDevice from this adapter
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUAdapter/requestDevice
pub async fn GPUAdapter::requestDevice(
  self : GPUAdapter,
  label? : String,
  required_features? : Array[String],
  required_limits? : @nostd.Any,
) -> GPUDevice? {
  let descriptor = @nostd.Object::new()
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  match required_features {
    Some(features) => {
      let arr = @js.from_array(features)
      descriptor._set("requiredFeatures", @nostd.any(arr))
    }
    None => ()
  }
  match required_limits {
    Some(limits) => descriptor._set("requiredLimits", limits)
    None => ()
  }
  let promise : @js.Promise[@nostd.Any] = self
    .as_any()
    ._call("requestDevice", [descriptor])
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
pub fn GPUDevice::as_any(self : GPUDevice) -> @nostd.Any = "%identity"

///|
/// Get the device label
pub fn GPUDevice::label(self : GPUDevice) -> String {
  self.as_any()["label"].cast()
}

///|
/// Set the device label
pub fn GPUDevice::set_label(self : GPUDevice, label : String) -> Unit {
  self.as_any()._set("label", @nostd.any(label))
}

///|
/// Get supported features
pub fn GPUDevice::features(self : GPUDevice) -> GPUSupportedFeatures {
  self.as_any()["features"].cast()
}

///|
/// Get supported limits
pub fn GPUDevice::limits(self : GPUDevice) -> GPUSupportedLimits {
  self.as_any()["limits"].cast()
}

///|
/// Get the device queue
pub fn GPUDevice::queue(self : GPUDevice) -> GPUQueue {
  self.as_any()["queue"].cast()
}

///|
/// Get the lost promise
pub fn GPUDevice::lost(self : GPUDevice) -> @js.Promise[GPUDeviceLostInfo] {
  self.as_any()["lost"].cast()
}

///|
/// Destroy the device
pub fn GPUDevice::destroy(self : GPUDevice) -> Unit {
  self.as_any()._call("destroy", []) |> ignore
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
  let descriptor = @nostd.Object::new()
  descriptor._set("size", @nostd.any(size))
  descriptor._set("usage", @nostd.any(usage))
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  match mapped_at_creation {
    Some(m) => descriptor._set("mappedAtCreation", @nostd.any(m))
    None => ()
  }
  self.as_any()._call("createBuffer", [descriptor]).cast()
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
  let descriptor = @nostd.Object::new()
  descriptor._set("size", @nostd.any(size))
  descriptor._set("format", @nostd.any(format))
  descriptor._set("usage", @nostd.any(usage))
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  match mip_level_count {
    Some(m) => descriptor._set("mipLevelCount", @nostd.any(m))
    None => ()
  }
  match sample_count {
    Some(s) => descriptor._set("sampleCount", @nostd.any(s))
    None => ()
  }
  match dimension {
    Some(d) => descriptor._set("dimension", @nostd.any(d))
    None => ()
  }
  match view_formats {
    Some(vf) => {
      let arr = @js.from_array(vf)
      descriptor._set("viewFormats", @nostd.any(arr))
    }
    None => ()
  }
  self.as_any()._call("createTexture", [descriptor]).cast()
}

///|
/// Create a shader module
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createShaderModule
pub fn GPUDevice::createShaderModule(
  self : GPUDevice,
  code : String,
  label? : String,
) -> GPUShaderModule {
  let descriptor = @nostd.Object::new()
  descriptor._set("code", @nostd.any(code))
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  self.as_any()._call("createShaderModule", [descriptor]).cast()
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
  let descriptor = @nostd.Object::new()
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  match address_mode_u {
    Some(m) => descriptor._set("addressModeU", @nostd.any(m))
    None => ()
  }
  match address_mode_v {
    Some(m) => descriptor._set("addressModeV", @nostd.any(m))
    None => ()
  }
  match address_mode_w {
    Some(m) => descriptor._set("addressModeW", @nostd.any(m))
    None => ()
  }
  match mag_filter {
    Some(f) => descriptor._set("magFilter", @nostd.any(f))
    None => ()
  }
  match min_filter {
    Some(f) => descriptor._set("minFilter", @nostd.any(f))
    None => ()
  }
  match mipmap_filter {
    Some(f) => descriptor._set("mipmapFilter", @nostd.any(f))
    None => ()
  }
  match lod_min_clamp {
    Some(l) => descriptor._set("lodMinClamp", @nostd.any(l))
    None => ()
  }
  match lod_max_clamp {
    Some(l) => descriptor._set("lodMaxClamp", @nostd.any(l))
    None => ()
  }
  match compare {
    Some(c) => descriptor._set("compare", @nostd.any(c))
    None => ()
  }
  match max_anisotropy {
    Some(a) => descriptor._set("maxAnisotropy", @nostd.any(a))
    None => ()
  }
  self.as_any()._call("createSampler", [descriptor]).cast()
}

///|
/// Create a command encoder
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createCommandEncoder
pub fn GPUDevice::createCommandEncoder(
  self : GPUDevice,
  label? : String,
) -> GPUCommandEncoder {
  let descriptor = @nostd.Object::new()
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  self.as_any()._call("createCommandEncoder", [descriptor]).cast()
}

///|
/// Create a bind group layout
pub fn GPUDevice::createBindGroupLayout(
  self : GPUDevice,
  entries : @nostd.Any,
  label? : String,
) -> GPUBindGroupLayout {
  let descriptor = @nostd.Object::new()
  descriptor._set("entries", entries)
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  self.as_any()._call("createBindGroupLayout", [descriptor]).cast()
}

///|
/// Create a bind group
pub fn GPUDevice::createBindGroup(
  self : GPUDevice,
  layout : GPUBindGroupLayout,
  entries : @nostd.Any,
  label? : String,
) -> GPUBindGroup {
  let descriptor = @nostd.Object::new()
  descriptor._set("layout", @nostd.any(layout))
  descriptor._set("entries", entries)
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  self.as_any()._call("createBindGroup", [descriptor]).cast()
}

///|
/// Create a pipeline layout
pub fn GPUDevice::createPipelineLayout(
  self : GPUDevice,
  bind_group_layouts : Array[GPUBindGroupLayout],
  label? : String,
) -> GPUPipelineLayout {
  let descriptor = @nostd.Object::new()
  let arr = @js.from_array(bind_group_layouts)
  descriptor._set("bindGroupLayouts", @nostd.any(arr))
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  self.as_any()._call("createPipelineLayout", [descriptor]).cast()
}

///|
/// Create a render pipeline
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createRenderPipeline
pub fn GPUDevice::createRenderPipeline(
  self : GPUDevice,
  descriptor : @nostd.Any,
) -> GPURenderPipeline {
  self.as_any()._call("createRenderPipeline", [descriptor]).cast()
}

///|
/// Create a compute pipeline
pub fn GPUDevice::createComputePipeline(
  self : GPUDevice,
  descriptor : @nostd.Any,
) -> GPUComputePipeline {
  self.as_any()._call("createComputePipeline", [descriptor]).cast()
}

///|
/// Push an error scope
pub fn GPUDevice::pushErrorScope(self : GPUDevice, filter : String) -> Unit {
  self.as_any()._call("pushErrorScope", [@nostd.any(filter)]) |> ignore
}

///|
/// Pop an error scope
pub async fn GPUDevice::popErrorScope(self : GPUDevice) -> GPUError? {
  let promise : @js.Promise[@nostd.Any] = self
    .as_any()
    ._call("popErrorScope", [])
    .cast()
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
pub fn GPUBuffer::as_any(self : GPUBuffer) -> @nostd.Any = "%identity"

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
  self.as_any()["size"].cast()
}

///|
/// Get buffer usage
pub fn GPUBuffer::usage(self : GPUBuffer) -> Int {
  self.as_any()["usage"].cast()
}

///|
/// Get buffer map state
pub fn GPUBuffer::mapState(self : GPUBuffer) -> String {
  self.as_any()["mapState"].cast()
}

///|
/// Get buffer label
pub fn GPUBuffer::label(self : GPUBuffer) -> String {
  self.as_any()["label"].cast()
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
    (None, None) => self.as_any()._call("mapAsync", [@nostd.any(mode)]).cast()
    (Some(o), None) =>
      self.as_any()._call("mapAsync", [@nostd.any(mode), @nostd.any(o)]).cast()
    (Some(o), Some(s)) =>
      self
      .as_any()
      ._call("mapAsync", [@nostd.any(mode), @nostd.any(o), @nostd.any(s)])
      .cast()
    (None, Some(s)) =>
      self
      .as_any()
      ._call("mapAsync", [@nostd.any(mode), @nostd.any(0), @nostd.any(s)])
      .cast()
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
    (None, None) => self.as_any()._call("getMappedRange", []).cast()
    (Some(o), None) =>
      self.as_any()._call("getMappedRange", [@nostd.any(o)]).cast()
    (Some(o), Some(s)) =>
      self
      .as_any()
      ._call("getMappedRange", [@nostd.any(o), @nostd.any(s)])
      .cast()
    (None, Some(s)) =>
      self
      .as_any()
      ._call("getMappedRange", [@nostd.any(0), @nostd.any(s)])
      .cast()
  }
}

///|
/// Unmap the buffer
pub fn GPUBuffer::unmap(self : GPUBuffer) -> Unit {
  self.as_any()._call("unmap", []) |> ignore
}

///|
/// Destroy the buffer
pub fn GPUBuffer::destroy(self : GPUBuffer) -> Unit {
  self.as_any()._call("destroy", []) |> ignore
}

// =============================================================================
// GPUTexture
// =============================================================================

///|
/// GPUTexture - represents a texture for GPU operations
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUTexture
pub(all) struct GPUTexture {}

///|
pub fn GPUTexture::as_any(self : GPUTexture) -> @nostd.Any = "%identity"

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
  self.as_any()["width"].cast()
}

///|
/// Get texture height
pub fn GPUTexture::height(self : GPUTexture) -> Int {
  self.as_any()["height"].cast()
}

///|
/// Get texture depth or array layers
pub fn GPUTexture::depthOrArrayLayers(self : GPUTexture) -> Int {
  self.as_any()["depthOrArrayLayers"].cast()
}

///|
/// Get texture format
pub fn GPUTexture::format(self : GPUTexture) -> String {
  self.as_any()["format"].cast()
}

///|
/// Get mip level count
pub fn GPUTexture::mipLevelCount(self : GPUTexture) -> Int {
  self.as_any()["mipLevelCount"].cast()
}

///|
/// Get sample count
pub fn GPUTexture::sampleCount(self : GPUTexture) -> Int {
  self.as_any()["sampleCount"].cast()
}

///|
/// Get texture dimension
pub fn GPUTexture::dimension(self : GPUTexture) -> String {
  self.as_any()["dimension"].cast()
}

///|
/// Get texture usage
pub fn GPUTexture::usage(self : GPUTexture) -> Int {
  self.as_any()["usage"].cast()
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
  let descriptor = @nostd.Object::new()
  match format {
    Some(f) => descriptor._set("format", @nostd.any(f))
    None => ()
  }
  match dimension {
    Some(d) => descriptor._set("dimension", @nostd.any(d))
    None => ()
  }
  match aspect {
    Some(a) => descriptor._set("aspect", @nostd.any(a))
    None => ()
  }
  match base_mip_level {
    Some(b) => descriptor._set("baseMipLevel", @nostd.any(b))
    None => ()
  }
  match mip_level_count {
    Some(m) => descriptor._set("mipLevelCount", @nostd.any(m))
    None => ()
  }
  match base_array_layer {
    Some(b) => descriptor._set("baseArrayLayer", @nostd.any(b))
    None => ()
  }
  match array_layer_count {
    Some(a) => descriptor._set("arrayLayerCount", @nostd.any(a))
    None => ()
  }
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  self.as_any()._call("createView", [descriptor]).cast()
}

///|
/// Destroy the texture
pub fn GPUTexture::destroy(self : GPUTexture) -> Unit {
  self.as_any()._call("destroy", []) |> ignore
}

// =============================================================================
// GPUTextureView
// =============================================================================

///|
/// GPUTextureView - a view into a texture
pub(all) struct GPUTextureView {}

///|
pub fn GPUTextureView::as_any(self : GPUTextureView) -> @nostd.Any = "%identity"

///|
pub fn GPUTextureView::label(self : GPUTextureView) -> String {
  self.as_any()["label"].cast()
}

// =============================================================================
// GPUQueue
// =============================================================================

///|
/// GPUQueue - command queue for GPU operations
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUQueue
pub(all) struct GPUQueue {}

///|
pub fn GPUQueue::as_any(self : GPUQueue) -> @nostd.Any = "%identity"

///|
/// Submit command buffers to the queue
pub fn GPUQueue::submit(
  self : GPUQueue,
  command_buffers : Array[GPUCommandBuffer],
) -> Unit {
  let arr = @js.from_array(command_buffers)
  self.as_any()._call("submit", [@nostd.any(arr)]) |> ignore
}

///|
/// Write data to a buffer
pub fn GPUQueue::writeBuffer(
  self : GPUQueue,
  buffer : GPUBuffer,
  buffer_offset : Int,
  data : @nostd.Any,
  data_offset? : Int,
  size? : Int,
) -> Unit {
  match (data_offset, size) {
    (None, None) =>
      self
      .as_any()
      ._call("writeBuffer", [buffer.as_any(), @nostd.any(buffer_offset), data])
      |> ignore
    (Some(do_), None) =>
      self
      .as_any()
      ._call("writeBuffer", [
        buffer.as_any(),
        @nostd.any(buffer_offset),
        data,
        @nostd.any(do_),
      ])
      |> ignore
    (Some(do_), Some(s)) =>
      self
      .as_any()
      ._call("writeBuffer", [
        buffer.as_any(),
        @nostd.any(buffer_offset),
        data,
        @nostd.any(do_),
        @nostd.any(s),
      ])
      |> ignore
    (None, Some(s)) =>
      self
      .as_any()
      ._call("writeBuffer", [
        buffer.as_any(),
        @nostd.any(buffer_offset),
        data,
        @nostd.any(0),
        @nostd.any(s),
      ])
      |> ignore
  }
}

///|
/// Write data to a texture
pub fn GPUQueue::writeTexture(
  self : GPUQueue,
  destination : @nostd.Any,
  data : @nostd.Any,
  data_layout : @nostd.Any,
  size : GPUExtent3D,
) -> Unit {
  self
  .as_any()
  ._call("writeTexture", [destination, data, data_layout, @nostd.any(size)])
  |> ignore
}

///|
/// Get a promise that resolves when all submitted work is done
pub async fn GPUQueue::onSubmittedWorkDone(self : GPUQueue) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("onSubmittedWorkDone", [])
    .cast()
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
pub fn GPUCommandEncoder::as_any(self : GPUCommandEncoder) -> @nostd.Any = "%identity"

///|
pub fn GPUCommandEncoder::label(self : GPUCommandEncoder) -> String {
  self.as_any()["label"].cast()
}

///|
/// Begin a render pass
pub fn GPUCommandEncoder::beginRenderPass(
  self : GPUCommandEncoder,
  descriptor : @nostd.Any,
) -> GPURenderPassEncoder {
  self.as_any()._call("beginRenderPass", [descriptor]).cast()
}

///|
/// Begin a compute pass
pub fn GPUCommandEncoder::beginComputePass(
  self : GPUCommandEncoder,
  label? : String,
) -> GPUComputePassEncoder {
  let descriptor = @nostd.Object::new()
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  self.as_any()._call("beginComputePass", [descriptor]).cast()
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
  self
  .as_any()
  ._call("copyBufferToBuffer", [
    source.as_any(),
    @nostd.any(source_offset),
    destination.as_any(),
    @nostd.any(destination_offset),
    @nostd.any(size),
  ])
  |> ignore
}

///|
/// Copy buffer to texture
pub fn GPUCommandEncoder::copyBufferToTexture(
  self : GPUCommandEncoder,
  source : @nostd.Any,
  destination : @nostd.Any,
  copy_size : GPUExtent3D,
) -> Unit {
  self
  .as_any()
  ._call("copyBufferToTexture", [source, destination, @nostd.any(copy_size)])
  |> ignore
}

///|
/// Copy texture to buffer
pub fn GPUCommandEncoder::copyTextureToBuffer(
  self : GPUCommandEncoder,
  source : @nostd.Any,
  destination : @nostd.Any,
  copy_size : GPUExtent3D,
) -> Unit {
  self
  .as_any()
  ._call("copyTextureToBuffer", [source, destination, @nostd.any(copy_size)])
  |> ignore
}

///|
/// Copy texture to texture
pub fn GPUCommandEncoder::copyTextureToTexture(
  self : GPUCommandEncoder,
  source : @nostd.Any,
  destination : @nostd.Any,
  copy_size : GPUExtent3D,
) -> Unit {
  self
  .as_any()
  ._call("copyTextureToTexture", [source, destination, @nostd.any(copy_size)])
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
    (None, None) =>
      self.as_any()._call("clearBuffer", [buffer.as_any()]) |> ignore
    (Some(o), None) =>
      self.as_any()._call("clearBuffer", [buffer.as_any(), @nostd.any(o)])
      |> ignore
    (Some(o), Some(s)) =>
      self
      .as_any()
      ._call("clearBuffer", [buffer.as_any(), @nostd.any(o), @nostd.any(s)])
      |> ignore
    (None, Some(s)) =>
      self
      .as_any()
      ._call("clearBuffer", [buffer.as_any(), @nostd.any(0), @nostd.any(s)])
      |> ignore
  }
}

///|
/// Finish encoding and return command buffer
pub fn GPUCommandEncoder::finish(
  self : GPUCommandEncoder,
  label? : String,
) -> GPUCommandBuffer {
  let descriptor = @nostd.Object::new()
  match label {
    Some(l) => descriptor._set("label", @nostd.any(l))
    None => ()
  }
  self.as_any()._call("finish", [descriptor]).cast()
}

// =============================================================================
// GPUCommandBuffer
// =============================================================================

///|
/// GPUCommandBuffer - contains encoded GPU commands
pub(all) struct GPUCommandBuffer {}

///|
pub fn GPUCommandBuffer::as_any(self : GPUCommandBuffer) -> @nostd.Any = "%identity"

///|
pub fn GPUCommandBuffer::label(self : GPUCommandBuffer) -> String {
  self.as_any()["label"].cast()
}

// =============================================================================
// GPURenderPassEncoder
// =============================================================================

///|
/// GPURenderPassEncoder - encodes render pass commands
pub(all) struct GPURenderPassEncoder {}

///|
pub fn GPURenderPassEncoder::as_any(self : GPURenderPassEncoder) -> @nostd.Any = "%identity"

///|
/// Set the render pipeline
pub fn GPURenderPassEncoder::setPipeline(
  self : GPURenderPassEncoder,
  pipeline : GPURenderPipeline,
) -> Unit {
  self.as_any()._call("setPipeline", [pipeline.as_any()]) |> ignore
}

///|
/// Set a bind group
pub fn GPURenderPassEncoder::setBindGroup(
  self : GPURenderPassEncoder,
  index : Int,
  bind_group : GPUBindGroup,
) -> Unit {
  self.as_any()._call("setBindGroup", [@nostd.any(index), bind_group.as_any()])
  |> ignore
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
      self
      .as_any()
      ._call("setVertexBuffer", [@nostd.any(slot), buffer.as_any()])
      |> ignore
    (Some(o), None) =>
      self
      .as_any()
      ._call("setVertexBuffer", [
        @nostd.any(slot),
        buffer.as_any(),
        @nostd.any(o),
      ])
      |> ignore
    (Some(o), Some(s)) =>
      self
      .as_any()
      ._call("setVertexBuffer", [
        @nostd.any(slot),
        buffer.as_any(),
        @nostd.any(o),
        @nostd.any(s),
      ])
      |> ignore
    (None, Some(s)) =>
      self
      .as_any()
      ._call("setVertexBuffer", [
        @nostd.any(slot),
        buffer.as_any(),
        @nostd.any(0),
        @nostd.any(s),
      ])
      |> ignore
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
      self
      .as_any()
      ._call("setIndexBuffer", [buffer.as_any(), @nostd.any(format)])
      |> ignore
    (Some(o), None) =>
      self
      .as_any()
      ._call("setIndexBuffer", [
        buffer.as_any(),
        @nostd.any(format),
        @nostd.any(o),
      ])
      |> ignore
    (Some(o), Some(s)) =>
      self
      .as_any()
      ._call("setIndexBuffer", [
        buffer.as_any(),
        @nostd.any(format),
        @nostd.any(o),
        @nostd.any(s),
      ])
      |> ignore
    (None, Some(s)) =>
      self
      .as_any()
      ._call("setIndexBuffer", [
        buffer.as_any(),
        @nostd.any(format),
        @nostd.any(0),
        @nostd.any(s),
      ])
      |> ignore
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
    (None, None, None) =>
      self.as_any()._call("draw", [@nostd.any(vertex_count)]) |> ignore
    (Some(ic), None, None) =>
      self.as_any()._call("draw", [@nostd.any(vertex_count), @nostd.any(ic)])
      |> ignore
    (Some(ic), Some(fv), None) =>
      self
      .as_any()
      ._call("draw", [@nostd.any(vertex_count), @nostd.any(ic), @nostd.any(fv)])
      |> ignore
    (Some(ic), Some(fv), Some(fi)) =>
      self
      .as_any()
      ._call("draw", [
        @nostd.any(vertex_count),
        @nostd.any(ic),
        @nostd.any(fv),
        @nostd.any(fi),
      ])
      |> ignore
    (None, Some(fv), fi) =>
      match fi {
        Some(f) =>
          self
          .as_any()
          ._call("draw", [
            @nostd.any(vertex_count),
            @nostd.any(1),
            @nostd.any(fv),
            @nostd.any(f),
          ])
          |> ignore
        None =>
          self
          .as_any()
          ._call("draw", [
            @nostd.any(vertex_count),
            @nostd.any(1),
            @nostd.any(fv),
          ])
          |> ignore
      }
    (Some(ic), None, Some(fi)) =>
      self
      .as_any()
      ._call("draw", [
        @nostd.any(vertex_count),
        @nostd.any(ic),
        @nostd.any(0),
        @nostd.any(fi),
      ])
      |> ignore
    (None, None, Some(fi)) =>
      self
      .as_any()
      ._call("draw", [
        @nostd.any(vertex_count),
        @nostd.any(1),
        @nostd.any(0),
        @nostd.any(fi),
      ])
      |> ignore
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
      self.as_any()._call("drawIndexed", [@nostd.any(index_count)]) |> ignore
    (Some(ic), None, None, None) =>
      self
      .as_any()
      ._call("drawIndexed", [@nostd.any(index_count), @nostd.any(ic)])
      |> ignore
    (Some(ic), Some(fi), None, None) =>
      self
      .as_any()
      ._call("drawIndexed", [
        @nostd.any(index_count),
        @nostd.any(ic),
        @nostd.any(fi),
      ])
      |> ignore
    (Some(ic), Some(fi), Some(bv), None) =>
      self
      .as_any()
      ._call("drawIndexed", [
        @nostd.any(index_count),
        @nostd.any(ic),
        @nostd.any(fi),
        @nostd.any(bv),
      ])
      |> ignore
    (Some(ic), Some(fi), Some(bv), Some(fii)) =>
      self
      .as_any()
      ._call("drawIndexed", [
        @nostd.any(index_count),
        @nostd.any(ic),
        @nostd.any(fi),
        @nostd.any(bv),
        @nostd.any(fii),
      ])
      |> ignore
    _ => self.as_any()._call("drawIndexed", [@nostd.any(index_count)]) |> ignore
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
  self
  .as_any()
  ._call("setViewport", [
    @nostd.any(x),
    @nostd.any(y),
    @nostd.any(width),
    @nostd.any(height),
    @nostd.any(min_depth),
    @nostd.any(max_depth),
  ])
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
  self
  .as_any()
  ._call("setScissorRect", [
    @nostd.any(x),
    @nostd.any(y),
    @nostd.any(width),
    @nostd.any(height),
  ])
  |> ignore
}

///|
/// Set blend constant
pub fn GPURenderPassEncoder::setBlendConstant(
  self : GPURenderPassEncoder,
  color : @nostd.Any,
) -> Unit {
  self.as_any()._call("setBlendConstant", [color]) |> ignore
}

///|
/// Set stencil reference
pub fn GPURenderPassEncoder::setStencilReference(
  self : GPURenderPassEncoder,
  reference : Int,
) -> Unit {
  self.as_any()._call("setStencilReference", [@nostd.any(reference)]) |> ignore
}

///|
/// End the render pass
pub fn GPURenderPassEncoder::end(self : GPURenderPassEncoder) -> Unit {
  self.as_any()._call("end", []) |> ignore
}

// =============================================================================
// GPUComputePassEncoder
// =============================================================================

///|
/// GPUComputePassEncoder - encodes compute pass commands
pub(all) struct GPUComputePassEncoder {}

///|
pub fn GPUComputePassEncoder::as_any(
  self : GPUComputePassEncoder,
) -> @nostd.Any = "%identity"

///|
/// Set the compute pipeline
pub fn GPUComputePassEncoder::setPipeline(
  self : GPUComputePassEncoder,
  pipeline : GPUComputePipeline,
) -> Unit {
  self.as_any()._call("setPipeline", [pipeline.as_any()]) |> ignore
}

///|
/// Set a bind group
pub fn GPUComputePassEncoder::setBindGroup(
  self : GPUComputePassEncoder,
  index : Int,
  bind_group : GPUBindGroup,
) -> Unit {
  self.as_any()._call("setBindGroup", [@nostd.any(index), bind_group.as_any()])
  |> ignore
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
      self.as_any()._call("dispatchWorkgroups", [@nostd.any(workgroup_count_x)])
      |> ignore
    (Some(y), None) =>
      self
      .as_any()
      ._call("dispatchWorkgroups", [
        @nostd.any(workgroup_count_x),
        @nostd.any(y),
      ])
      |> ignore
    (Some(y), Some(z)) =>
      self
      .as_any()
      ._call("dispatchWorkgroups", [
        @nostd.any(workgroup_count_x),
        @nostd.any(y),
        @nostd.any(z),
      ])
      |> ignore
    (None, Some(z)) =>
      self
      .as_any()
      ._call("dispatchWorkgroups", [
        @nostd.any(workgroup_count_x),
        @nostd.any(1),
        @nostd.any(z),
      ])
      |> ignore
  }
}

///|
/// Dispatch workgroups indirect
pub fn GPUComputePassEncoder::dispatchWorkgroupsIndirect(
  self : GPUComputePassEncoder,
  indirect_buffer : GPUBuffer,
  indirect_offset : Int,
) -> Unit {
  self
  .as_any()
  ._call("dispatchWorkgroupsIndirect", [
    indirect_buffer.as_any(),
    @nostd.any(indirect_offset),
  ])
  |> ignore
}

///|
/// End the compute pass
pub fn GPUComputePassEncoder::end(self : GPUComputePassEncoder) -> Unit {
  self.as_any()._call("end", []) |> ignore
}

// =============================================================================
// GPURenderPipeline
// =============================================================================

///|
/// GPURenderPipeline - render pipeline configuration
pub(all) struct GPURenderPipeline {}

///|
pub fn GPURenderPipeline::as_any(self : GPURenderPipeline) -> @nostd.Any = "%identity"

///|
pub fn GPURenderPipeline::label(self : GPURenderPipeline) -> String {
  self.as_any()["label"].cast()
}

///|
/// Get the bind group layout at an index
pub fn GPURenderPipeline::getBindGroupLayout(
  self : GPURenderPipeline,
  index : Int,
) -> GPUBindGroupLayout {
  self.as_any()._call("getBindGroupLayout", [@nostd.any(index)]).cast()
}

// =============================================================================
// GPUComputePipeline
// =============================================================================

///|
/// GPUComputePipeline - compute pipeline configuration
pub(all) struct GPUComputePipeline {}

///|
pub fn GPUComputePipeline::as_any(self : GPUComputePipeline) -> @nostd.Any = "%identity"

///|
pub fn GPUComputePipeline::label(self : GPUComputePipeline) -> String {
  self.as_any()["label"].cast()
}

///|
/// Get the bind group layout at an index
pub fn GPUComputePipeline::getBindGroupLayout(
  self : GPUComputePipeline,
  index : Int,
) -> GPUBindGroupLayout {
  self.as_any()._call("getBindGroupLayout", [@nostd.any(index)]).cast()
}

// =============================================================================
// GPUShaderModule
// =============================================================================

///|
/// GPUShaderModule - compiled shader code
pub(all) struct GPUShaderModule {}

///|
pub fn GPUShaderModule::as_any(self : GPUShaderModule) -> @nostd.Any = "%identity"

///|
pub fn GPUShaderModule::label(self : GPUShaderModule) -> String {
  self.as_any()["label"].cast()
}

///|
/// Get compilation info
pub async fn GPUShaderModule::getCompilationInfo(
  self : GPUShaderModule,
) -> GPUCompilationInfo {
  let promise : @js.Promise[GPUCompilationInfo] = self
    .as_any()
    ._call("getCompilationInfo", [])
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
pub fn GPUSampler::as_any(self : GPUSampler) -> @nostd.Any = "%identity"

///|
pub fn GPUSampler::label(self : GPUSampler) -> String {
  self.as_any()["label"].cast()
}

// =============================================================================
// GPUBindGroup
// =============================================================================

///|
/// GPUBindGroup - group of resources bound together
pub(all) struct GPUBindGroup {}

///|
pub fn GPUBindGroup::as_any(self : GPUBindGroup) -> @nostd.Any = "%identity"

///|
pub fn GPUBindGroup::label(self : GPUBindGroup) -> String {
  self.as_any()["label"].cast()
}

// =============================================================================
// GPUBindGroupLayout
// =============================================================================

///|
/// GPUBindGroupLayout - layout of a bind group
pub(all) struct GPUBindGroupLayout {}

///|
pub fn GPUBindGroupLayout::as_any(self : GPUBindGroupLayout) -> @nostd.Any = "%identity"

///|
pub fn GPUBindGroupLayout::label(self : GPUBindGroupLayout) -> String {
  self.as_any()["label"].cast()
}

// =============================================================================
// GPUPipelineLayout
// =============================================================================

///|
/// GPUPipelineLayout - layout of pipeline bind groups
pub(all) struct GPUPipelineLayout {}

///|
pub fn GPUPipelineLayout::as_any(self : GPUPipelineLayout) -> @nostd.Any = "%identity"

///|
pub fn GPUPipelineLayout::label(self : GPUPipelineLayout) -> String {
  self.as_any()["label"].cast()
}

// =============================================================================
// Supporting types
// =============================================================================

///|
/// GPUSupportedFeatures - set of supported GPU features
pub(all) struct GPUSupportedFeatures {}

///|
pub fn GPUSupportedFeatures::as_any(self : GPUSupportedFeatures) -> @nostd.Any = "%identity"

///|
/// Check if a feature is supported
pub fn GPUSupportedFeatures::has(
  self : GPUSupportedFeatures,
  feature : String,
) -> Bool {
  self.as_any()._call("has", [@nostd.any(feature)]).cast()
}

///|
/// GPUSupportedLimits - supported GPU limits
pub(all) struct GPUSupportedLimits {}

///|
pub fn GPUSupportedLimits::as_any(self : GPUSupportedLimits) -> @nostd.Any = "%identity"

///|
/// Get max texture dimension 1D
pub fn GPUSupportedLimits::maxTextureDimension1D(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxTextureDimension1D"].cast()
}

///|
/// Get max texture dimension 2D
pub fn GPUSupportedLimits::maxTextureDimension2D(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxTextureDimension2D"].cast()
}

///|
/// Get max texture dimension 3D
pub fn GPUSupportedLimits::maxTextureDimension3D(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxTextureDimension3D"].cast()
}

///|
/// Get max buffer size
pub fn GPUSupportedLimits::maxBufferSize(self : GPUSupportedLimits) -> Int {
  self.as_any()["maxBufferSize"].cast()
}

///|
/// Get max bind groups
pub fn GPUSupportedLimits::maxBindGroups(self : GPUSupportedLimits) -> Int {
  self.as_any()["maxBindGroups"].cast()
}

///|
/// GPUAdapterInfo - information about the GPU adapter
pub(all) struct GPUAdapterInfo {}

///|
pub fn GPUAdapterInfo::as_any(self : GPUAdapterInfo) -> @nostd.Any = "%identity"

///|
/// Get vendor name
pub fn GPUAdapterInfo::vendor(self : GPUAdapterInfo) -> String {
  self.as_any()["vendor"].cast()
}

///|
/// Get architecture
pub fn GPUAdapterInfo::architecture(self : GPUAdapterInfo) -> String {
  self.as_any()["architecture"].cast()
}

///|
/// Get device name
pub fn GPUAdapterInfo::device(self : GPUAdapterInfo) -> String {
  self.as_any()["device"].cast()
}

///|
/// Get description
pub fn GPUAdapterInfo::description(self : GPUAdapterInfo) -> String {
  self.as_any()["description"].cast()
}

///|
/// GPUDeviceLostInfo - information about a lost device
pub(all) struct GPUDeviceLostInfo {}

///|
pub fn GPUDeviceLostInfo::as_any(self : GPUDeviceLostInfo) -> @nostd.Any = "%identity"

///|
/// Get the reason for device loss
pub fn GPUDeviceLostInfo::reason(self : GPUDeviceLostInfo) -> String {
  self.as_any()["reason"].cast()
}

///|
/// Get the message
pub fn GPUDeviceLostInfo::message(self : GPUDeviceLostInfo) -> String {
  self.as_any()["message"].cast()
}

///|
/// GPUError - base type for GPU errors
pub(all) struct GPUError {}

///|
pub fn GPUError::as_any(self : GPUError) -> @nostd.Any = "%identity"

///|
/// Get error message
pub fn GPUError::message(self : GPUError) -> String {
  self.as_any()["message"].cast()
}

///|
/// GPUCompilationInfo - shader compilation info
pub(all) struct GPUCompilationInfo {}

///|
pub fn GPUCompilationInfo::as_any(self : GPUCompilationInfo) -> @nostd.Any = "%identity"

///|
/// Get compilation messages
pub fn GPUCompilationInfo::messages(self : GPUCompilationInfo) -> @js.JsArray {
  self.as_any()["messages"].cast()
}

///|
/// GPUCompilationMessage - a single compilation message
pub(all) struct GPUCompilationMessage {}

///|
pub fn GPUCompilationMessage::as_any(
  self : GPUCompilationMessage,
) -> @nostd.Any = "%identity"

///|
/// Get message text
pub fn GPUCompilationMessage::message(self : GPUCompilationMessage) -> String {
  self.as_any()["message"].cast()
}

///|
/// Get message type (error, warning, info)
pub fn GPUCompilationMessage::type_(self : GPUCompilationMessage) -> String {
  self.as_any()["type"].cast()
}

///|
/// Get line number
pub fn GPUCompilationMessage::lineNum(self : GPUCompilationMessage) -> Int {
  self.as_any()["lineNum"].cast()
}

///|
/// Get line position
pub fn GPUCompilationMessage::linePos(self : GPUCompilationMessage) -> Int {
  self.as_any()["linePos"].cast()
}

// =============================================================================
// GPUExtent3D - helper for size specifications
// =============================================================================

///|
/// GPUExtent3D - represents 3D extents
pub(all) struct GPUExtent3D {}

///|
pub fn GPUExtent3D::as_any(self : GPUExtent3D) -> @nostd.Any = "%identity"

///|
/// Create GPUExtent3D from width, height, depth
pub fn GPUExtent3D::new(
  width : Int,
  height? : Int,
  depth_or_array_layers? : Int,
) -> GPUExtent3D {
  let obj = @nostd.Object::new()
  obj._set("width", @nostd.any(width))
  match height {
    Some(h) => obj._set("height", @nostd.any(h))
    None => ()
  }
  match depth_or_array_layers {
    Some(d) => obj._set("depthOrArrayLayers", @nostd.any(d))
    None => ()
  }
  obj.cast()
}

///|
/// Create GPUExtent3D from an array [width, height?, depthOrArrayLayers?]
pub fn GPUExtent3D::from_array(arr : Array[Int]) -> GPUExtent3D {
  @js.from_array(arr).cast()
}
