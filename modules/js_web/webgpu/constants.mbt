// =============================================================================
// Flag namespaces
//
// WebGPU exposes these as static members on the GPU* namespace objects
// (GPUShaderStage.VERTEX and so on). They are plain bitmask constants, so they
// are bound as constants here rather than through FFI -- the buffer and
// texture usage flags in gpu.mbt follow the same convention.
// =============================================================================

// ---- GPUShaderStage --------------------------------------------------------
// https://developer.mozilla.org/en-US/docs/Web/API/GPUShaderStage

///|
/// Bind group entry is visible to the vertex stage.
pub const SHADER_STAGE_VERTEX : Int = 0x1

///|
/// Bind group entry is visible to the fragment stage.
pub const SHADER_STAGE_FRAGMENT : Int = 0x2

///|
/// Bind group entry is visible to the compute stage.
pub const SHADER_STAGE_COMPUTE : Int = 0x4

// ---- GPUMapMode ------------------------------------------------------------
// https://developer.mozilla.org/en-US/docs/Web/API/GPUMapMode

///|
/// Map a buffer for reading. Pass to `GPUBuffer::mapAsync`; the buffer must
/// have been created with `BUFFER_USAGE_MAP_READ`.
pub const MAP_MODE_READ : Int = 0x1

///|
/// Map a buffer for writing. Pass to `GPUBuffer::mapAsync`; the buffer must
/// have been created with `BUFFER_USAGE_MAP_WRITE`.
pub const MAP_MODE_WRITE : Int = 0x2

// ---- GPUColorWrite ---------------------------------------------------------
// https://developer.mozilla.org/en-US/docs/Web/API/GPUColorWrite

///|
/// Write the red channel.
pub const COLOR_WRITE_RED : Int = 0x1

///|
/// Write the green channel.
pub const COLOR_WRITE_GREEN : Int = 0x2

///|
/// Write the blue channel.
pub const COLOR_WRITE_BLUE : Int = 0x4

///|
/// Write the alpha channel.
pub const COLOR_WRITE_ALPHA : Int = 0x8

///|
/// Write every channel -- red, green, blue and alpha.
pub const COLOR_WRITE_ALL : Int = 0xF
