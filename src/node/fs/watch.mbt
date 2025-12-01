///| File System Watcher

///|
#external
pub type FSWatcher

///|
pub fn FSWatcher::as_any(self : FSWatcher) -> @nostd.Any = "%identity"

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
  ._call("on", [@nostd.any(event), @nostd.any(@js.from_fn2(listener))])
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
  let fs : @nostd.Any = fs_module() |> @nostd.any
  let has_options = not(persistent is None) ||
    not(recursive is None) ||
    not(encoding is None)
  if has_options {
    let map : Map[String, @nostd.Any] = {
      let m = Map::new()
      match persistent {
        Some(p) => m.set("persistent", @nostd.any(p))
        None => ()
      }
      match recursive {
        Some(r) => m.set("recursive", @nostd.any(r))
        None => ()
      }
      match encoding {
        Some(e) => m.set("encoding", @nostd.any(e))
        None => ()
      }
      m
    }
    let options : @nostd.Any = @mbtconv.from_map(map) |> @nostd.any
    match listener {
      Some(l) =>
        fs
        ._call("watch", [
          @nostd.any(filename),
          options,
          @nostd.any(@js.from_fn2(l)),
        ])
        .cast()
      None =>
        fs._call("watch", [@nostd.any(filename), options]).cast()
    }
  } else {
    match listener {
      Some(l) =>
        fs
        ._call("watch", [@nostd.any(filename), @nostd.any(@js.from_fn2(l))])
        .cast()
      None => fs._call("watch", [@nostd.any(filename)]).cast()
    }
  }
}
