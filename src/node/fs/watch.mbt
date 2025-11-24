///| File System Watcher

///|
#external
pub type FSWatcher

///|
pub impl @js.JsImpl for FSWatcher

///|
/// Close the watcher
/// JS: watcher.close()
pub fn FSWatcher::close(self : Self) -> Unit {
  self.call0("close") |> ignore
}

///|
/// Add event listener to watcher
/// JS: watcher.on(event, listener)
pub fn FSWatcher::on(
  self : Self,
  event : String,
  listener : (String, String) -> Unit,
) -> Self {
  self.call2("on", event, @js.from_fn2(listener)).cast()
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
  let fs = fs_module()
  let has_options = not(persistent is None) ||
    not(recursive is None) ||
    not(encoding is None)
  if has_options {
    let map : Map[String, @js.Js] = {
      let m = Map::new()
      match persistent {
        Some(p) => m.set("persistent", @js.identity(p))
        None => ()
      }
      match recursive {
        Some(r) => m.set("recursive", @js.identity(r))
        None => ()
      }
      match encoding {
        Some(e) => m.set("encoding", @js.identity(e))
        None => ()
      }
      m
    }
    let options = @js.from_map(map)
    match listener {
      Some(l) => fs.call("watch", [filename, options, @js.from_fn2(l)]).cast()
      None => fs.call2("watch", filename, options).cast()
    }
  } else {
    match listener {
      Some(l) => fs.call2("watch", filename, @js.from_fn2(l)).cast()
      None => fs.call1("watch", filename).cast()
    }
  }
}
