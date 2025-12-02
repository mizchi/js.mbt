///| File System Watcher

///|
#external
pub type FSWatcher

///|
pub fn FSWatcher::as_any(self : FSWatcher) -> @core.Any = "%identity"

///|
/// Close the watcher
/// JS: watcher.close()
pub fn FSWatcher::close(self : Self) -> Unit {
  self.as_any()._call("close", []) |> ignore
}

///|
/// Add event listener to watcher
/// JS: watcher.on(event, listener)
pub fn FSWatcher::on(
  self : Self,
  event : String,
  listener : (String, String) -> Unit,
) -> Self {
  self
  .as_any()
  ._call("on", [@core.any(event), @core.any(@js.from_fn2(listener))])
  .cast()
}

///|
/// Watch for changes on filename
/// JS: fs.watch(filename, options?, listener?)
pub fn watch(
  filename : String,
  persistent? : Bool,
  recursive? : Bool,
  encoding? : String,
  listener? : (String, String) -> Unit,
) -> FSWatcher {
  let fs : @core.Any = fs_module() |> @core.any
  let has_options = not(persistent is None) ||
    not(recursive is None) ||
    not(encoding is None)
  if has_options {
    let map : Map[String, @core.Any] = {
      let m = Map::new()
      match persistent {
        Some(p) => m.set("persistent", @core.any(p))
        None => ()
      }
      match recursive {
        Some(r) => m.set("recursive", @core.any(r))
        None => ()
      }
      match encoding {
        Some(e) => m.set("encoding", @core.any(e))
        None => ()
      }
      m
    }
    let options : @core.Any = @mbtconv.from_map(map) |> @core.any
    match listener {
      Some(l) =>
        fs
        ._call("watch", [
          @core.any(filename),
          options,
          @core.any(@js.from_fn2(l)),
        ])
        .cast()
      None => fs._call("watch", [@core.any(filename), options]).cast()
    }
  } else {
    match listener {
      Some(l) =>
        fs
        ._call("watch", [@core.any(filename), @core.any(@js.from_fn2(l))])
        .cast()
      None => fs._call("watch", [@core.any(filename)]).cast()
    }
  }
}
