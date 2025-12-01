///|
/// Snapshot testing APIs
/// https://nodejs.org/api/test.html#snapshot-testing

///|
/// TestContext snapshot methods

///|
/// context.assert.snapshot(value) - Compare value against stored snapshot
pub fn TestContext::assert_snapshot(
  self : TestContext,
  value : @nostd.Any,
  message? : String,
) -> Unit {
  let assert_obj : @nostd.Any = self.as_any()["assert"]
  match message {
    Some(msg) =>
      assert_obj._call("snapshot", [value, @nostd.any(msg)]) |> ignore
    None => assert_obj._call("snapshot", [value]) |> ignore
  }
}

///|
/// context.assert.fileSnapshot(value, path) - File-based snapshot comparison
pub fn TestContext::assert_fileSnapshot(
  self : TestContext,
  value : @nostd.Any,
  path : String,
  message? : String,
) -> Unit {
  let assert_obj : @nostd.Any = self.as_any()["assert"]
  match message {
    Some(msg) =>
      assert_obj._call("fileSnapshot", [
        value,
        @nostd.any(path),
        @nostd.any(msg),
      ])
      |> ignore
    None =>
      assert_obj._call("fileSnapshot", [value, @nostd.any(path)]) |> ignore
  }
}

///|
/// snapshot module functions

///|
fn snapshot_module() -> @js.Any {
  @nostd.any(nodetest())["snapshot"].cast()
}

///|
/// setDefaultSnapshotSerializers(serializers) - Customize snapshot serialization
pub fn setDefaultSnapshotSerializers(serializers : Array[@nostd.Any]) -> Unit {
  let s : @nostd.Any = @nostd.any(snapshot_module())
  s._call("setDefaultSnapshotSerializers", [@nostd.any(serializers)]) |> ignore
}

///|
/// setResolveSnapshotPath(fn) - Custom snapshot file location
pub fn setResolveSnapshotPath(fn_ : (String) -> String) -> Unit {
  let s : @nostd.Any = @nostd.any(snapshot_module())
  s._call("setResolveSnapshotPath", [@nostd.any(@js.from_fn1(fn_))]) |> ignore
}
