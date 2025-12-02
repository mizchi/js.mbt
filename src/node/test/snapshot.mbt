///|
/// Snapshot testing APIs
/// https://nodejs.org/api/test.html#snapshot-testing

///|
/// TestContext snapshot methods

///|
/// context.assert.snapshot(value) - Compare value against stored snapshot
pub fn TestContext::assert_snapshot(
  self : TestContext,
  value : @core.Any,
  message? : String,
) -> Unit {
  let assert_obj : @core.Any = self.as_any()["assert"]
  match message {
    Some(msg) => assert_obj._call("snapshot", [value, @core.any(msg)]) |> ignore
    None => assert_obj._call("snapshot", [value]) |> ignore
  }
}

///|
/// context.assert.fileSnapshot(value, path) - File-based snapshot comparison
pub fn TestContext::assert_fileSnapshot(
  self : TestContext,
  value : @core.Any,
  path : String,
  message? : String,
) -> Unit {
  let assert_obj : @core.Any = self.as_any()["assert"]
  match message {
    Some(msg) =>
      assert_obj._call("fileSnapshot", [value, @core.any(path), @core.any(msg)])
      |> ignore
    None => assert_obj._call("fileSnapshot", [value, @core.any(path)]) |> ignore
  }
}

///|
/// snapshot module functions

///|
fn snapshot_module() -> @core.Any {
  @core.any(nodetest())["snapshot"].cast()
}

///|
/// setDefaultSnapshotSerializers(serializers) - Customize snapshot serialization
pub fn setDefaultSnapshotSerializers(serializers : Array[@core.Any]) -> Unit {
  let s : @core.Any = @core.any(snapshot_module())
  s._call("setDefaultSnapshotSerializers", [@core.any(serializers)]) |> ignore
}

///|
/// setResolveSnapshotPath(fn) - Custom snapshot file location
pub fn setResolveSnapshotPath(fn_ : (String) -> String) -> Unit {
  let s : @core.Any = @core.any(snapshot_module())
  s._call("setResolveSnapshotPath", [@core.any(@js.from_fn1(fn_))]) |> ignore
}
