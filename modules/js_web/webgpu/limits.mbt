// =============================================================================
// GPUSupportedLimits - the full set of limits
// https://developer.mozilla.org/en-US/docs/Web/API/GPUSupportedLimits
//
// The type itself is declared in gpu.mbt; every limit accessor lives here.
// =============================================================================

///|
/// Read a limit by its spec name, for limits this binding does not name
/// explicitly yet, such as the deprecated `maxInterStageShaderComponents`.
/// Returns `None` when the implementation does not report the limit.
pub fn GPUSupportedLimits::get(
  self : GPUSupportedLimits,
  name : String,
) -> Int? {
  let v = self.as_any()[name]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

// ---- texture limits --------------------------------------------------------

///|
/// Maximum width of a 1D texture.
pub fn GPUSupportedLimits::maxTextureDimension1D(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxTextureDimension1D"].cast()
}

///|
/// Maximum width or height of a 2D texture.
pub fn GPUSupportedLimits::maxTextureDimension2D(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxTextureDimension2D"].cast()
}

///|
/// Maximum width, height or depth of a 3D texture.
pub fn GPUSupportedLimits::maxTextureDimension3D(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxTextureDimension3D"].cast()
}

///|
/// Maximum number of layers in a texture array.
pub fn GPUSupportedLimits::maxTextureArrayLayers(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxTextureArrayLayers"].cast()
}

// ---- bind group limits -----------------------------------------------------

///|
/// Maximum number of bind groups in a pipeline layout.
pub fn GPUSupportedLimits::maxBindGroups(self : GPUSupportedLimits) -> Int {
  self.as_any()["maxBindGroups"].cast()
}

///|
/// Maximum number of bindings allowed in a single bind group.
pub fn GPUSupportedLimits::maxBindingsPerBindGroup(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxBindingsPerBindGroup"].cast()
}

///|
/// Maximum dynamic uniform buffers per pipeline layout.
pub fn GPUSupportedLimits::maxDynamicUniformBuffersPerPipelineLayout(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxDynamicUniformBuffersPerPipelineLayout"].cast()
}

///|
/// Maximum dynamic storage buffers per pipeline layout.
pub fn GPUSupportedLimits::maxDynamicStorageBuffersPerPipelineLayout(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxDynamicStorageBuffersPerPipelineLayout"].cast()
}

// ---- per-shader-stage limits -----------------------------------------------

///|
/// Maximum sampled textures accessible in a shader stage.
pub fn GPUSupportedLimits::maxSampledTexturesPerShaderStage(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxSampledTexturesPerShaderStage"].cast()
}

///|
/// Maximum samplers accessible in a shader stage.
pub fn GPUSupportedLimits::maxSamplersPerShaderStage(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxSamplersPerShaderStage"].cast()
}

///|
/// Maximum storage buffers accessible in any shader stage.
pub fn GPUSupportedLimits::maxStorageBuffersPerShaderStage(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxStorageBuffersPerShaderStage"].cast()
}

///|
/// Maximum storage buffers in the vertex shader stage.
pub fn GPUSupportedLimits::maxStorageBuffersInVertexStage(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxStorageBuffersInVertexStage"].cast()
}

///|
/// Maximum storage buffers in the fragment shader stage.
pub fn GPUSupportedLimits::maxStorageBuffersInFragmentStage(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxStorageBuffersInFragmentStage"].cast()
}

///|
/// Maximum storage textures accessible in any shader stage.
pub fn GPUSupportedLimits::maxStorageTexturesPerShaderStage(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxStorageTexturesPerShaderStage"].cast()
}

///|
/// Maximum storage textures in the vertex shader stage.
pub fn GPUSupportedLimits::maxStorageTexturesInVertexStage(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxStorageTexturesInVertexStage"].cast()
}

///|
/// Maximum storage textures in the fragment shader stage.
pub fn GPUSupportedLimits::maxStorageTexturesInFragmentStage(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxStorageTexturesInFragmentStage"].cast()
}

///|
/// Maximum uniform buffers accessible in a shader stage.
pub fn GPUSupportedLimits::maxUniformBuffersPerShaderStage(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxUniformBuffersPerShaderStage"].cast()
}

// ---- buffer limits ---------------------------------------------------------

///|
/// Maximum byte size of a uniform buffer binding.
pub fn GPUSupportedLimits::maxUniformBufferBindingSize(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxUniformBufferBindingSize"].cast()
}

///|
/// Maximum byte size of a storage buffer binding.
pub fn GPUSupportedLimits::maxStorageBufferBindingSize(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxStorageBufferBindingSize"].cast()
}

///|
/// Minimum byte alignment for uniform buffer offsets.
pub fn GPUSupportedLimits::minUniformBufferOffsetAlignment(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["minUniformBufferOffsetAlignment"].cast()
}

///|
/// Minimum byte alignment for storage buffer offsets.
pub fn GPUSupportedLimits::minStorageBufferOffsetAlignment(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["minStorageBufferOffsetAlignment"].cast()
}

///|
/// Maximum byte size of a GPU buffer.
pub fn GPUSupportedLimits::maxBufferSize(self : GPUSupportedLimits) -> Int {
  self.as_any()["maxBufferSize"].cast()
}

// ---- vertex stage limits ---------------------------------------------------

///|
/// Maximum number of vertex buffers in a render pipeline.
pub fn GPUSupportedLimits::maxVertexBuffers(self : GPUSupportedLimits) -> Int {
  self.as_any()["maxVertexBuffers"].cast()
}

///|
/// Maximum number of vertex attributes in a render pipeline.
pub fn GPUSupportedLimits::maxVertexAttributes(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxVertexAttributes"].cast()
}

///|
/// Maximum byte stride between vertex elements.
pub fn GPUSupportedLimits::maxVertexBufferArrayStride(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxVertexBufferArrayStride"].cast()
}

///|
/// Maximum variables passed between shader stages.
///
/// Replaces the deprecated `maxInterStageShaderComponents`, which this
/// binding does not expose; read it through `get` if you still need it.
pub fn GPUSupportedLimits::maxInterStageShaderVariables(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxInterStageShaderVariables"].cast()
}

// ---- render pass limits ----------------------------------------------------

///|
/// Maximum number of color attachments in a render pass.
pub fn GPUSupportedLimits::maxColorAttachments(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxColorAttachments"].cast()
}

///|
/// Maximum bytes per color sample in a render pass.
pub fn GPUSupportedLimits::maxColorAttachmentBytesPerSample(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxColorAttachmentBytesPerSample"].cast()
}

// ---- compute stage limits --------------------------------------------------

///|
/// Maximum byte size of workgroup-shared storage.
pub fn GPUSupportedLimits::maxComputeWorkgroupStorageSize(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxComputeWorkgroupStorageSize"].cast()
}

///|
/// Maximum number of invocations in a compute workgroup.
pub fn GPUSupportedLimits::maxComputeInvocationsPerWorkgroup(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxComputeInvocationsPerWorkgroup"].cast()
}

///|
/// Maximum X dimension size of a compute workgroup.
pub fn GPUSupportedLimits::maxComputeWorkgroupSizeX(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxComputeWorkgroupSizeX"].cast()
}

///|
/// Maximum Y dimension size of a compute workgroup.
pub fn GPUSupportedLimits::maxComputeWorkgroupSizeY(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxComputeWorkgroupSizeY"].cast()
}

///|
/// Maximum Z dimension size of a compute workgroup.
pub fn GPUSupportedLimits::maxComputeWorkgroupSizeZ(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxComputeWorkgroupSizeZ"].cast()
}

///|
/// Maximum number of workgroups per dimension in a compute dispatch.
pub fn GPUSupportedLimits::maxComputeWorkgroupsPerDimension(
  self : GPUSupportedLimits,
) -> Int {
  self.as_any()["maxComputeWorkgroupsPerDimension"].cast()
}
