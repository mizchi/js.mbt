# mizchi/js_web/webgpu

MoonBit bindings for the [WebGPU API](https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API).

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
  "mizchi/js_web/webgpu",
}
```

## Coverage

All 35 `GPU*` interfaces in the spec are bound:

| Area | Types |
|------|-------|
| Entry point | `GPU`, `GPUAdapter`, `GPUAdapterInfo` |
| Device | `GPUDevice`, `GPUSupportedFeatures`, `GPUSupportedLimits` |
| Canvas | `GPUCanvasContext` |
| Resources | `GPUBuffer`, `GPUTexture`, `GPUTextureView`, `GPUSampler`, `GPUShaderModule`, `GPUExternalTexture` |
| Pipelines | `GPURenderPipeline`, `GPUComputePipeline`, `GPUPipelineLayout`, `GPUBindGroup`, `GPUBindGroupLayout` |
| Commands | `GPUCommandEncoder`, `GPUCommandBuffer`, `GPUQueue`, `GPURenderPassEncoder`, `GPUComputePassEncoder`, `GPURenderBundle`, `GPURenderBundleEncoder` |
| Queries | `GPUQuerySet` |
| Errors | `GPUError`, `GPUValidationError`, `GPUOutOfMemoryError`, `GPUInternalError`, `GPUPipelineError`, `GPUUncapturedErrorEvent`, `GPUDeviceLostInfo`, `GPUCompilationInfo`, `GPUCompilationMessage` |

Flag constants are bound as plain `Int` constants rather than namespace
objects: `BUFFER_USAGE_*`, `TEXTURE_USAGE_*`, `SHADER_STAGE_*`, `MAP_MODE_*`
and `COLOR_WRITE_*`.

Not bound:

- **`GPUBuffer.mapSync()`** — experimental, worker-only, and Chromium-only as
  of Chrome 145. Use `mapAsync`.
- **Pipeline and bind group layout descriptors** are passed as `@core.Any`
  rather than typed structs. They are deeply nested and change often, so they
  are built with `@core.from_entries` / `@core.new_object`.

`GPUAdapter::requestAdapterInfo()` is deliberately absent — it was removed
from the spec in favour of the synchronous `GPUAdapter::info` property, which
is what `GPUAdapter::info()` binds.

## Getting a device

```moonbit
///|
pub async fn init_device() -> @webgpu.GPUDevice? {
  guard @webgpu.gpu() is Some(gpu) else { return None }
  guard gpu.requestAdapter() is Some(adapter) else { return None }
  adapter.requestDevice()
}
```

`gpu()` returns `None` where WebGPU is unavailable, so this is also the
feature test — it does not throw off-browser.

## Rendering to a canvas

`GPUCanvasContext` comes from `canvas.getContext("webgpu")`. Canvas elements
live in [`mizchi/js_browser`](../../js_browser/README.md), which depends on
this module rather than the other way round, so the context is handed over as
a raw value:

```moonbit
///|
pub fn setup(
  canvas : @core.Any,
  device : @webgpu.GPUDevice,
  gpu : @webgpu.GPU,
) -> @webgpu.GPUTexture? {
  let raw = canvas._call("getContext", [@core.any("webgpu")])
  guard @webgpu.GPUCanvasContext::from_any(raw) is Some(ctx) else { return None }
  ctx.configure(device, gpu.getPreferredCanvasFormat())
  // one texture per frame -- do not cache it
  Some(ctx.getCurrentTexture())
}
```

## Seeing errors

Most WebGPU calls report failures asynchronously, so they never raise. Install
an uncaptured-error handler, or bracket a suspect section in an error scope:

```moonbit
///|
pub fn watch_errors(device : @webgpu.GPUDevice) -> Unit {
  device.set_onuncapturederror(ev => {
    let err = ev.error()
    let kind = match err.kind() {
      Validation => "validation"
      OutOfMemory => "out-of-memory"
      Internal => "internal"
      Unknown => "unknown"
    }
    println("webgpu \{kind} error: \{err.message()}")
  })
}
```

```moonbit
///|
pub async fn checked(device : @webgpu.GPUDevice) -> String? {
  device.pushErrorScope("validation")
  // ... do the suspect work ...
  match device.popErrorScope() {
    Some(err) => Some(err.message())
    None => None
  }
}
```

## Limits

Every limit in the spec has an accessor, and `get` reaches anything not named
explicitly — including the deprecated `maxInterStageShaderComponents`:

```moonbit
///|
pub fn describe(device : @webgpu.GPUDevice) -> String {
  let limits = device.limits()
  let workgroup = limits.maxComputeInvocationsPerWorkgroup()
  let buffer = limits.maxBufferSize()
  "workgroup=\{workgroup} buffer=\{buffer}"
}
```

Subgroup sizes live on the adapter info and are optional, since not every
implementation reports them:

```moonbit
///|
pub fn subgroups(info : @webgpu.GPUAdapterInfo) -> String {
  match (info.subgroupMinSize(), info.subgroupMaxSize()) {
    (Some(lo), Some(hi)) => "subgroups \{lo}..\{hi}"
    _ => "subgroup size not reported"
  }
}
```

## Reference

- [MDN: WebGPU API](https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API)
- [WebGPU specification](https://www.w3.org/TR/webgpu/)
- [WGSL specification](https://www.w3.org/TR/WGSL/)

See the [User Guide](../../../docs/guide.md) for picking modules and aliases.
