// =============================================================================
// GPUQuerySet - occlusion and timestamp queries
// https://developer.mozilla.org/en-US/docs/Web/API/GPUQuerySet
// =============================================================================

///|
/// A set of query slots, either "occlusion" or "timestamp".
#external
pub type GPUQuerySet

///|
pub fn GPUQuerySet::as_any(self : GPUQuerySet) -> @core.Any = "%identity"

///|
/// Either "occlusion" or "timestamp".
pub fn GPUQuerySet::type_(self : GPUQuerySet) -> String {
  self.as_any()["type"].cast()
}

///|
/// How many queries this set holds.
pub fn GPUQuerySet::count(self : GPUQuerySet) -> Int {
  self.as_any()["count"].cast()
}

///|
pub fn GPUQuerySet::label(self : GPUQuerySet) -> String {
  self.as_any()["label"].cast()
}

///|
/// Release the set. Using it afterwards is a validation error.
pub fn GPUQuerySet::destroy(self : GPUQuerySet) -> Unit {
  self.as_any()._call("destroy", []) |> ignore
}

///|
/// Create a query set.
///
/// `type_` is "occlusion" or "timestamp"; a timestamp set needs the
/// "timestamp-query" feature to have been requested on the device.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUDevice/createQuerySet
pub fn GPUDevice::createQuerySet(
  self : GPUDevice,
  type_ : String,
  count : Int,
  label? : String,
) -> GPUQuerySet {
  let descriptor = @core.new_object()
  descriptor._set("type", @core.any(type_))
  descriptor._set("count", @core.any(count))
  match label {
    Some(l) => descriptor._set("label", @core.any(l))
    None => ()
  }
  self.as_any()._call("createQuerySet", [descriptor]).cast()
}

///|
/// Copy query results into a buffer. The destination needs
/// `BUFFER_USAGE_QUERY_RESOLVE`, and each result is a 64-bit value.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPUCommandEncoder/resolveQuerySet
pub fn GPUCommandEncoder::resolveQuerySet(
  self : GPUCommandEncoder,
  query_set : GPUQuerySet,
  first_query : Int,
  query_count : Int,
  destination : GPUBuffer,
  destination_offset : Int,
) -> Unit {
  self
  .as_any()
  ._call("resolveQuerySet", [
    query_set.as_any(),
    @core.any(first_query),
    @core.any(query_count),
    destination.as_any(),
    @core.any(destination_offset),
  ])
  |> ignore
}

///|
/// Begin an occlusion query, writing into the slot at `query_index` of the
/// query set the render pass was started with.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPURenderPassEncoder/beginOcclusionQuery
pub fn GPURenderPassEncoder::beginOcclusionQuery(
  self : GPURenderPassEncoder,
  query_index : Int,
) -> Unit {
  self.as_any()._call("beginOcclusionQuery", [@core.any(query_index)]) |> ignore
}

///|
/// End the occlusion query started by `beginOcclusionQuery`.
/// https://developer.mozilla.org/en-US/docs/Web/API/GPURenderPassEncoder/endOcclusionQuery
pub fn GPURenderPassEncoder::endOcclusionQuery(
  self : GPURenderPassEncoder,
) -> Unit {
  self.as_any()._call("endOcclusionQuery", []) |> ignore
}
