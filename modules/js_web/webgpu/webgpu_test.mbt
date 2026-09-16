// Tests for the WebGPU bindings.
//
// There is no GPU under `moon test`, and Node has no `navigator.gpu`, so these
// cover the parts that do not need a device: the flag constants, the
// descriptor builders, the property accessors (against stand-in objects) and
// the feature-detection paths. A spy object records method calls so the
// argument marshalling can be checked too.

///|
/// Serialize a value so descriptor shapes can be asserted as a whole.
extern "js" fn json_str(v : @core.Any) -> String =
  #| (v) => JSON.stringify(v)

///|
/// An object that records every method called on it, for checking how
/// arguments are marshalled. `calls` is a list of `{name, args}`.
extern "js" fn make_spy() -> @core.Any =
  #| () => {
  #|   const calls = [];
  #|   const target = { calls };
  #|   return new Proxy(target, {
  #|     get(t, k) {
  #|       if (k in t) return t[k];
  #|       return (...args) => { t.calls.push({ name: k, args }); };
  #|     },
  #|   });
  #| }

///|
/// Build a plain object from string/number pairs, standing in for a WebGPU
/// object this environment cannot produce.
fn stub(entries : Array[(String, @core.Any)]) -> @core.Any {
  let o = @core.new_object()
  for e in entries {
    o._set(e.0, e.1)
  }
  o
}

///|
extern "js" fn js_null() -> @core.Any =
  #| () => null

///|
/// A context stub whose `getConfiguration` returns the given value.
extern "js" fn ctx_returning_configuration(v : @core.Any) -> @core.Any =
  #| (v) => ({ getConfiguration: () => v })

///|
fn spy_calls(spy : @core.Any) -> String {
  json_str(spy["calls"])
}

// =============================================================================
// Flag constants
// =============================================================================

///|
test "shader stage flags match the spec bitmasks" {
  assert_eq(SHADER_STAGE_VERTEX, 1)
  assert_eq(SHADER_STAGE_FRAGMENT, 2)
  assert_eq(SHADER_STAGE_COMPUTE, 4)
}

///|
test "map mode flags match the spec bitmasks" {
  assert_eq(MAP_MODE_READ, 1)
  assert_eq(MAP_MODE_WRITE, 2)
}

///|
test "color write flags compose into ALL" {
  assert_eq(COLOR_WRITE_RED, 1)
  assert_eq(COLOR_WRITE_GREEN, 2)
  assert_eq(COLOR_WRITE_BLUE, 4)
  assert_eq(COLOR_WRITE_ALPHA, 8)
  assert_eq(
    COLOR_WRITE_ALL,
    COLOR_WRITE_RED | COLOR_WRITE_GREEN | COLOR_WRITE_BLUE | COLOR_WRITE_ALPHA,
  )
}

///|
test "buffer and texture usage flags are distinct bits" {
  // A buffer usable as a uniform that can also be written from the CPU.
  assert_eq(BUFFER_USAGE_UNIFORM | BUFFER_USAGE_COPY_DST, 0x48)
  assert_eq(TEXTURE_USAGE_RENDER_ATTACHMENT | TEXTURE_USAGE_COPY_SRC, 0x11)
}

// =============================================================================
// GPUExtent3D
// =============================================================================

///|
test "GPUExtent3D carries only the dimensions given" {
  inspect(
    json_str(GPUExtent3D(640).as_any()),
    content=(
      #|{"width":640}
    ),
  )
  inspect(
    json_str(GPUExtent3D(640, height=480).as_any()),
    content=(
      #|{"width":640,"height":480}
    ),
  )
  inspect(
    json_str(GPUExtent3D(640, height=480, depth_or_array_layers=6).as_any()),
    content=(
      #|{"width":640,"height":480,"depthOrArrayLayers":6}
    ),
  )
}

///|
test "GPUExtent3D::from_array uses the array form" {
  inspect(
    json_str(GPUExtent3D::from_array([640, 480]).as_any()),
    content=(
      #|[640,480]
    ),
  )
}

// =============================================================================
// GPUSupportedLimits
// =============================================================================

///|
test "limit accessors read their spec-named properties" {
  let limits : GPUSupportedLimits = stub([
    ("maxTextureDimension2D", @core.any(8192)),
    ("maxBindGroups", @core.any(4)),
    ("maxComputeWorkgroupSizeX", @core.any(256)),
    ("maxStorageBuffersInFragmentStage", @core.any(8)),
    ("minUniformBufferOffsetAlignment", @core.any(256)),
    ("maxInterStageShaderVariables", @core.any(16)),
  ]).cast()
  assert_eq(limits.maxTextureDimension2D(), 8192)
  assert_eq(limits.maxBindGroups(), 4)
  assert_eq(limits.maxComputeWorkgroupSizeX(), 256)
  assert_eq(limits.maxStorageBuffersInFragmentStage(), 8)
  assert_eq(limits.minUniformBufferOffsetAlignment(), 256)
  assert_eq(limits.maxInterStageShaderVariables(), 16)
}

///|
test "GPUSupportedLimits::get reaches limits without a named accessor" {
  let limits : GPUSupportedLimits = stub([
    ("maxInterStageShaderComponents", @core.any(60)),
  ]).cast()
  // the deprecated limit has no accessor of its own
  assert_eq(limits.get("maxInterStageShaderComponents"), Some(60))
  // and an unreported limit reads as None rather than 0
  assert_eq(limits.get("maxTextureDimension3D"), None)
}

// =============================================================================
// The GPUError hierarchy
// =============================================================================

///|
test "GPUError::kind degrades to Unknown where the classes are absent" {
  // Node has no GPUValidationError etc., so the instanceof guards must not
  // throw -- they report Unknown instead.
  let err : GPUError = stub([("message", @core.any("bad bind group"))]).cast()
  assert_eq(err.kind(), Unknown)
  assert_eq(err.message(), "bad bind group")
  assert_eq(err.as_validation_error() is None, true)
  assert_eq(err.as_out_of_memory_error() is None, true)
  assert_eq(err.as_internal_error() is None, true)
}

///|
test "GPUErrorKind values are comparable and matchable" {
  assert_eq(GPUErrorKind::Validation, GPUErrorKind::Validation)
  assert_eq(GPUErrorKind::Validation == GPUErrorKind::Internal, false)
  // callers can match on the kind, which needs the constructors to be public
  let described = match GPUErrorKind::OutOfMemory {
    Validation => "validation"
    OutOfMemory => "out-of-memory"
    Internal => "internal"
    Unknown => "unknown"
  }
  assert_eq(described, "out-of-memory")
}

///|
test "GPUPipelineError exposes message and reason" {
  let e = GPUPipelineError::from_any(
    stub([
      ("message", @core.any("entry point not found")),
      ("reason", @core.any("validation")),
    ]),
  )
  match e {
    Some(err) => {
      assert_eq(err.message(), "entry point not found")
      assert_eq(err.reason(), "validation")
    }
    None => fail("expected a GPUPipelineError")
  }
  assert_eq(GPUPipelineError::from_any(@core.undefined()) is None, true)
}

///|
test "uncaptured error events unwrap to the error" {
  let ev : GPUUncapturedErrorEvent = stub([
    ("error", stub([("message", @core.any("oom"))])),
  ]).cast()
  assert_eq(ev.error().message(), "oom")
}

///|
test "set_onuncapturederror installs a handler that receives the error" {
  let spy = make_spy()
  let device : GPUDevice = spy.cast()
  let seen = []
  device.set_onuncapturederror(ev => seen.push(ev.error().message()))
  // invoke the installed handler the way the browser would
  let handler = spy["onuncapturederror"]
  handler._call("call", [
    @core.undefined(),
    stub([("error", stub([("message", @core.any("validation failed"))]))]),
  ])
  |> ignore
  assert_eq(seen, ["validation failed"])
}

// =============================================================================
// GPUQuerySet
// =============================================================================

///|
test "GPUQuerySet accessors" {
  let qs : GPUQuerySet = stub([
    ("type", @core.any("timestamp")),
    ("count", @core.any(2)),
    ("label", @core.any("frame timing")),
  ]).cast()
  assert_eq(qs.type_(), "timestamp")
  assert_eq(qs.count(), 2)
  assert_eq(qs.label(), "frame timing")
}

///|
test "createQuerySet builds the descriptor" {
  let spy = make_spy()
  let device : GPUDevice = spy.cast()
  let _ = device.createQuerySet("occlusion", 8)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"createQuerySet","args":[{"type":"occlusion","count":8}]}]
    ),
  )
}

///|
test "createQuerySet includes a label when given" {
  let spy = make_spy()
  let device : GPUDevice = spy.cast()
  let _ = device.createQuerySet("timestamp", 2, label="timing")
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"createQuerySet","args":[{"type":"timestamp","count":2,"label":"timing"}]}]
    ),
  )
}

///|
test "resolveQuerySet passes its arguments positionally" {
  let spy = make_spy()
  let encoder : GPUCommandEncoder = spy.cast()
  let qs : GPUQuerySet = stub([]).cast()
  let dest : GPUBuffer = stub([("size", @core.any(64))]).cast()
  encoder.resolveQuerySet(qs, 0, 2, dest, 16)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"resolveQuerySet","args":[{},0,2,{"size":64},16]}]
    ),
  )
}

// =============================================================================
// GPUCanvasContext
// =============================================================================

///|
test "GPUCanvasContext::from_any rejects a missing context" {
  assert_eq(GPUCanvasContext::from_any(@core.undefined()) is None, true)
  assert_eq(GPUCanvasContext::from_any(js_null()) is None, true)
  assert_eq(GPUCanvasContext::from_any(stub([])) is Some(_), true)
}

///|
test "configure sends only the options provided" {
  let spy = make_spy()
  let ctx : GPUCanvasContext = spy.cast()
  let device : GPUDevice = stub([("kind", @core.any("device"))]).cast()
  ctx.configure(device, "bgra8unorm")
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"configure","args":[{"device":{"kind":"device"},"format":"bgra8unorm"}]}]
    ),
  )
}

///|
test "configure passes usage, view formats and tone mapping" {
  let spy = make_spy()
  let ctx : GPUCanvasContext = spy.cast()
  let device : GPUDevice = stub([]).cast()
  ctx.configure(
    device,
    "rgba16float",
    usage=TEXTURE_USAGE_RENDER_ATTACHMENT | TEXTURE_USAGE_COPY_SRC,
    view_formats=["rgba16float"],
    color_space="display-p3",
    alpha_mode="premultiplied",
    tone_mapping_mode="extended",
  )
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"configure","args":[{"device":{},"format":"rgba16float","usage":17,"viewFormats":["rgba16float"],"colorSpace":"display-p3","alphaMode":"premultiplied","toneMapping":{"mode":"extended"}}]}]
    ),
  )
}

///|
test "getConfiguration distinguishes unconfigured from configured" {
  let unconfigured : GPUCanvasContext = ctx_returning_configuration(js_null()).cast()
  assert_eq(unconfigured.getConfiguration() is None, true)
  let configured : GPUCanvasContext = ctx_returning_configuration(
    stub([("format", @core.any("bgra8unorm"))]),
  ).cast()
  match configured.getConfiguration() {
    Some(c) =>
      inspect(
        json_str(c),
        content=(
          #|{"format":"bgra8unorm"}
        ),
      )
    None => fail("expected a configuration")
  }
}

///|
test "unconfigure forwards with no arguments" {
  let spy = make_spy()
  let ctx : GPUCanvasContext = spy.cast()
  ctx.unconfigure()
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"unconfigure","args":[]}]
    ),
  )
}

// =============================================================================
// Render bundles
// =============================================================================

///|
test "createRenderBundleEncoder builds the descriptor" {
  let spy = make_spy()
  let device : GPUDevice = spy.cast()
  let _ = device.createRenderBundleEncoder(
    ["bgra8unorm"],
    depth_stencil_format="depth24plus",
    sample_count=4,
  )
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"createRenderBundleEncoder","args":[{"colorFormats":["bgra8unorm"],"depthStencilFormat":"depth24plus","sampleCount":4}]}]
    ),
  )
}

///|
test "setBindGroup omits dynamic offsets unless given" {
  let spy = make_spy()
  let enc : GPURenderBundleEncoder = spy.cast()
  let bg : GPUBindGroup = stub([]).cast()
  enc.setBindGroup(0, bg)
  enc.setBindGroup(1, bg, dynamic_offsets=[0, 256])
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"setBindGroup","args":[0,{}]},{"name":"setBindGroup","args":[1,{},[0,256]]}]
    ),
  )
}

///|
test "render pass setBindGroup takes dynamic offsets too" {
  let spy = make_spy()
  let pass : GPURenderPassEncoder = spy.cast()
  let bg : GPUBindGroup = stub([]).cast()
  pass.setBindGroup(0, bg, dynamic_offsets=[128])
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"setBindGroup","args":[0,{},[128]]}]
    ),
  )
}

///|
test "bundle draw calls fill in their defaults" {
  let spy = make_spy()
  let enc : GPURenderBundleEncoder = spy.cast()
  enc.draw(3)
  enc.drawIndexed(6, instance_count=2)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"draw","args":[3,1,0,0]},{"name":"drawIndexed","args":[6,2,0,0,0]}]
    ),
  )
}

///|
test "setVertexBuffer grows its argument list with offset and size" {
  let spy = make_spy()
  let enc : GPURenderBundleEncoder = spy.cast()
  let buf : GPUBuffer = stub([]).cast()
  enc.setVertexBuffer(0, buf)
  enc.setVertexBuffer(0, buf, offset=32)
  // size without offset still has to send an offset, since the parameter is
  // positional in JS
  enc.setVertexBuffer(0, buf, size=64)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"setVertexBuffer","args":[0,{}]},{"name":"setVertexBuffer","args":[0,{},32]},{"name":"setVertexBuffer","args":[0,{},0,64]}]
    ),
  )
}

///|
test "executeBundles passes an array" {
  let spy = make_spy()
  let pass : GPURenderPassEncoder = spy.cast()
  let b1 : GPURenderBundle = stub([("label", @core.any("a"))]).cast()
  pass.executeBundles([b1])
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"executeBundles","args":[[{"label":"a"}]]}]
    ),
  )
}

// =============================================================================
// External textures and debug markers
// =============================================================================

///|
test "importExternalTexture builds the descriptor" {
  let spy = make_spy()
  let device : GPUDevice = spy.cast()
  let _ = device.importExternalTexture(
    stub([("tag", @core.any("video"))]),
    color_space="srgb",
  )
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"importExternalTexture","args":[{"source":{"tag":"video"},"colorSpace":"srgb"}]}]
    ),
  )
}

///|
test "debug markers reach every encoder type" {
  let spy = make_spy()
  let enc : GPUCommandEncoder = spy.cast()
  enc.pushDebugGroup("frame")
  enc.insertDebugMarker("after upload")
  enc.popDebugGroup()
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"pushDebugGroup","args":["frame"]},{"name":"insertDebugMarker","args":["after upload"]},{"name":"popDebugGroup","args":[]}]
    ),
  )
}

///|
test "indirect draws pass the buffer and offset" {
  let spy = make_spy()
  let pass : GPURenderPassEncoder = spy.cast()
  let buf : GPUBuffer = stub([]).cast()
  pass.drawIndirect(buf, 0)
  pass.drawIndexedIndirect(buf, 16)
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"drawIndirect","args":[{},0]},{"name":"drawIndexedIndirect","args":[{},16]}]
    ),
  )
}

///|
test "occlusion queries bracket by index" {
  let spy = make_spy()
  let pass : GPURenderPassEncoder = spy.cast()
  pass.beginOcclusionQuery(3)
  pass.endOcclusionQuery()
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"beginOcclusionQuery","args":[3]},{"name":"endOcclusionQuery","args":[]}]
    ),
  )
}

// =============================================================================
// Adapter info and feature detection
// =============================================================================

///|
test "adapter info reports subgroup sizes only when present" {
  let with_subgroups : GPUAdapterInfo = stub([
    ("vendor", @core.any("example")),
    ("subgroupMinSize", @core.any(4)),
    ("subgroupMaxSize", @core.any(64)),
    ("isFallbackAdapter", @core.any(false)),
  ]).cast()
  assert_eq(with_subgroups.vendor(), "example")
  assert_eq(with_subgroups.subgroupMinSize(), Some(4))
  assert_eq(with_subgroups.subgroupMaxSize(), Some(64))
  assert_eq(with_subgroups.isFallbackAdapter(), false)
  let without : GPUAdapterInfo = stub([("vendor", @core.any("old"))]).cast()
  assert_eq(without.subgroupMinSize(), None)
  assert_eq(without.subgroupMaxSize(), None)
}

///|
test "gpu() reports absence rather than throwing off-browser" {
  // Node has no navigator.gpu; this must be None, not a crash.
  assert_eq(gpu() is None, true)
}

///|
test "GPUSupportedFeatures::has delegates to the underlying set" {
  let spy = make_spy()
  let features : GPUSupportedFeatures = spy.cast()
  let _ = features.has("timestamp-query")
  inspect(
    spy_calls(spy),
    content=(
      #|[{"name":"has","args":["timestamp-query"]}]
    ),
  )
}
