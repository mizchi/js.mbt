// =============================================================================
// GPURenderBundle / GPURenderBundleEncoder - pre-recorded draw commands
// https://developer.mozilla.org/en-US/docs/Web/API/GPURenderBundle
//
// A bundle records a sequence of render commands once and replays it in any
// number of later render passes, which is how you avoid re-encoding the same
// draws every frame.
// =============================================================================

///|
/// A recorded, replayable sequence of render commands.
#external
pub type GPURenderBundle

///|
pub fn GPURenderBundle::as_any(self : GPURenderBundle) -> @core.Any = "%identity"

///|
pub fn GPURenderBundle::label(self : GPURenderBundle) -> String {
  self.as_any()["label"].cast()
}

///|
/// Records the commands that make up a `GPURenderBundle`.
#external
pub type GPURenderBundleEncoder

///|
pub fn GPURenderBundleEncoder::as_any(
  self : GPURenderBundleEncoder,
) -> @core.Any = "%identity"

///|
pub fn GPURenderBundleEncoder::label(self : GPURenderBundleEncoder) -> String {
  self.as_any()["label"].cast()
}

///|
/// Create a bundle encoder.
///
/// `color_formats` must match the render passes the bundle will be replayed
/// in; so must `depth_stencil_format` and `sample_count` when given.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createRenderBundleEncoder
pub fn GPUDevice::createRenderBundleEncoder(
  self : GPUDevice,
  color_formats : Array[String],
  depth_stencil_format? : String,
  sample_count? : Int,
  depth_read_only? : Bool,
  stencil_read_only? : Bool,
  label? : String,
) -> GPURenderBundleEncoder {
  let descriptor = @core.new_object()
  descriptor._set("colorFormats", @core.any(color_formats))
  match depth_stencil_format {
    Some(f) => descriptor._set("depthStencilFormat", @core.any(f))
    None => ()
  }
  match sample_count {
    Some(c) => descriptor._set("sampleCount", @core.any(c))
    None => ()
  }
  match depth_read_only {
    Some(d) => descriptor._set("depthReadOnly", @core.any(d))
    None => ()
  }
  match stencil_read_only {
    Some(s) => descriptor._set("stencilReadOnly", @core.any(s))
    None => ()
  }
  match label {
    Some(l) => descriptor._set("label", @core.any(l))
    None => ()
  }
  self.as_any()._call("createRenderBundleEncoder", [descriptor]).cast()
}

///|
/// Finish recording and produce the bundle.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPURenderBundleEncoder/finish
pub fn GPURenderBundleEncoder::finish(
  self : GPURenderBundleEncoder,
  label? : String,
) -> GPURenderBundle {
  let descriptor = @core.new_object()
  match label {
    Some(l) => descriptor._set("label", @core.any(l))
    None => ()
  }
  self.as_any()._call("finish", [descriptor]).cast()
}

// ---- recording commands ----------------------------------------------------

///|
pub fn GPURenderBundleEncoder::setPipeline(
  self : GPURenderBundleEncoder,
  pipeline : GPURenderPipeline,
) -> Unit {
  self.as_any()._call("setPipeline", [pipeline.as_any()]) |> ignore
}

///|
/// Bind a bind group, optionally with dynamic offsets for its dynamically
/// offset buffer bindings.
pub fn GPURenderBundleEncoder::setBindGroup(
  self : GPURenderBundleEncoder,
  index : Int,
  bind_group : GPUBindGroup,
  dynamic_offsets? : Array[Int],
) -> Unit {
  match dynamic_offsets {
    Some(offsets) =>
      self
      .as_any()
      ._call("setBindGroup", [
        @core.any(index),
        bind_group.as_any(),
        @core.any(offsets),
      ])
      |> ignore
    None =>
      self
      .as_any()
      ._call("setBindGroup", [@core.any(index), bind_group.as_any()])
      |> ignore
  }
}

///|
pub fn GPURenderBundleEncoder::setVertexBuffer(
  self : GPURenderBundleEncoder,
  slot : Int,
  buffer : GPUBuffer,
  offset? : Int,
  size? : Int,
) -> Unit {
  let args = [@core.any(slot), buffer.as_any()]
  match offset {
    Some(o) => args.push(@core.any(o))
    None => ()
  }
  match size {
    Some(s) => {
      if offset is None {
        args.push(@core.any(0))
      }
      args.push(@core.any(s))
    }
    None => ()
  }
  self.as_any()._call("setVertexBuffer", FixedArray::from_array(args)) |> ignore
}

///|
/// `index_format` is "uint16" or "uint32".
pub fn GPURenderBundleEncoder::setIndexBuffer(
  self : GPURenderBundleEncoder,
  buffer : GPUBuffer,
  index_format : String,
  offset? : Int,
  size? : Int,
) -> Unit {
  let args = [buffer.as_any(), @core.any(index_format)]
  match offset {
    Some(o) => args.push(@core.any(o))
    None => ()
  }
  match size {
    Some(s) => {
      if offset is None {
        args.push(@core.any(0))
      }
      args.push(@core.any(s))
    }
    None => ()
  }
  self.as_any()._call("setIndexBuffer", FixedArray::from_array(args)) |> ignore
}

///|
pub fn GPURenderBundleEncoder::draw(
  self : GPURenderBundleEncoder,
  vertex_count : Int,
  instance_count? : Int,
  first_vertex? : Int,
  first_instance? : Int,
) -> Unit {
  self
  .as_any()
  ._call("draw", [
    @core.any(vertex_count),
    @core.any(instance_count.unwrap_or(1)),
    @core.any(first_vertex.unwrap_or(0)),
    @core.any(first_instance.unwrap_or(0)),
  ])
  |> ignore
}

///|
pub fn GPURenderBundleEncoder::drawIndexed(
  self : GPURenderBundleEncoder,
  index_count : Int,
  instance_count? : Int,
  first_index? : Int,
  base_vertex? : Int,
  first_instance? : Int,
) -> Unit {
  self
  .as_any()
  ._call("drawIndexed", [
    @core.any(index_count),
    @core.any(instance_count.unwrap_or(1)),
    @core.any(first_index.unwrap_or(0)),
    @core.any(base_vertex.unwrap_or(0)),
    @core.any(first_instance.unwrap_or(0)),
  ])
  |> ignore
}

///|
/// Draw with the parameters read from a buffer rather than passed here.
pub fn GPURenderBundleEncoder::drawIndirect(
  self : GPURenderBundleEncoder,
  indirect_buffer : GPUBuffer,
  indirect_offset : Int,
) -> Unit {
  self
  .as_any()
  ._call("drawIndirect", [indirect_buffer.as_any(), @core.any(indirect_offset)])
  |> ignore
}

///|
/// Indexed draw with the parameters read from a buffer.
pub fn GPURenderBundleEncoder::drawIndexedIndirect(
  self : GPURenderBundleEncoder,
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

///|
/// Replay one or more bundles in this render pass.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPURenderPassEncoder/executeBundles
pub fn GPURenderPassEncoder::executeBundles(
  self : GPURenderPassEncoder,
  bundles : Array[GPURenderBundle],
) -> Unit {
  self.as_any()._call("executeBundles", [@core.any(bundles)]) |> ignore
}
