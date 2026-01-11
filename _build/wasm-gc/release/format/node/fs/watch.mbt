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
  ._call("on", [@core.any(event), @core.any(@core.from_fn2(listener))])
  .cast()
}

///|
/// Internal: watch via #module
#module("node:fs")
extern "js" fn internal_watch(filename : String) -> FSWatcher = "watch"

///|
/// Internal: watch with listener via #module
#module("node:fs")
extern "js" fn internal_watch_with_listener(
  filename : String,
  listener : @core.Any,
) -> FSWatcher = "watch"

///|
/// Internal: watch with options via #module
#module("node:fs")
extern "js" fn internal_watch_with_options(
  filename : String,
  options : @core.Any,
) -> FSWatcher = "watch"

///|
/// Internal: watch with options and listener via #module
#module("node:fs")
extern "js" fn internal_watch_full(
  filename : String,
  options : @core.Any,
  listener : @core.Any,
) -> FSWatcher = "watch"

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
  let has_options = not(persistent is None) ||
    not(recursive is None) ||
    not(encoding is None)
  if has_options {
    let entries : Array[(String, @core.Any)] = []
    if persistent is Some(v) {
      entries.push(("persistent", @core.any(v)))
    }
    if recursive is Some(v) {
      entries.push(("recursive", @core.any(v)))
    }
    if encoding is Some(v) {
      entries.push(("encoding", @core.any(v)))
    }
    let options = @core.from_entries(entries)
    match listener {
      Some(l) =>
        internal_watch_full(filename, options, @core.any(@core.from_fn2(l)))
      None => internal_watch_with_options(filename, options)
    }
  } else {
    match listener {
      Some(l) =>
        internal_watch_with_listener(filename, @core.any(@core.from_fn2(l)))
      None => internal_watch(filename)
    }
  }
}
