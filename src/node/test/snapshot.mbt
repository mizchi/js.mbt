///|
/// Snapshot testing APIs
/// https://nodejs.org/api/test.html#snapshot-testing

///|
/// TestContext snapshot methods

///|
/// context.assert.snapshot(value) - Compare value against stored snapshot
pub fn TestContext::assert_snapshot(
  self : TestContext,
  value : &@js.JsImpl,
  message? : String,
) -> Unit {
  let assert_obj = self.get("assert")
  match message {
    Some(msg) => assert_obj.call2("snapshot", value.to_any(), msg) |> ignore
    None => assert_obj.call("snapshot", [value.to_any()]) |> ignore
  }
}

///|
/// context.assert.fileSnapshot(value, path) - File-based snapshot comparison
pub fn TestContext::assert_fileSnapshot(
  self : TestContext,
  value : &@js.JsImpl,
  path : String,
  message? : String,
) -> Unit {
  let assert_obj = self.get("assert")
  match message {
    Some(msg) =>
      assert_obj.call("fileSnapshot", [value.to_any(), path, msg]) |> ignore
    None => assert_obj.call2("fileSnapshot", value.to_any(), path) |> ignore
  }
}

///|
/// snapshot module functions

///|
fn snapshot_module() -> @js.Any {
  nodetest().get("snapshot")
}

///|
/// setDefaultSnapshotSerializers(serializers) - Customize snapshot serialization
pub fn setDefaultSnapshotSerializers(serializers : Array[&@js.JsImpl]) -> Unit {
  let s = snapshot_module()
  s.call("setDefaultSnapshotSerializers", [@js.from_array(serializers)])
  |> ignore
}

///|
/// setResolveSnapshotPath(fn) - Custom snapshot file location
pub fn setResolveSnapshotPath(fn_ : (String) -> String) -> Unit {
  let s = snapshot_module()
  s.call("setResolveSnapshotPath", [@js.from_fn1(fn_)]) |> ignore
}
