///|
/// Chokidar - Efficient file watching library
/// See: https://github.com/paulmillr/chokidar

///|
/// Event name enum for file system events
pub enum EventName {
  Add
  AddDir
  Change
  Unlink
  UnlinkDir
} derive(Show, Eq)

///|
pub fn EventName::from_string(s : String) -> EventName? {
  match s {
    "add" => Some(Add)
    "addDir" => Some(AddDir)
    "change" => Some(Change)
    "unlink" => Some(Unlink)
    "unlinkDir" => Some(UnlinkDir)
    _ => None
  }
}

///|
pub fn EventName::to_string(self : EventName) -> String {
  match self {
    Add => "add"
    AddDir => "addDir"
    Change => "change"
    Unlink => "unlink"
    UnlinkDir => "unlinkDir"
  }
}

///|
/// FSWatcher type - File system watcher instance
#external
pub type FSWatcher

///|
pub extern "js" fn FSWatcher::as_any(self : FSWatcher) -> @core.Any =
  #| (x) => x

///| Core API Functions - FFI

///|
/// FFI: watch
extern "js" fn ffi_watch(paths : @core.Any, options : @core.Any) -> @core.Any =
  #| (paths, options) => {
  #|   const chokidar = require('chokidar');
  #|   return chokidar.watch(paths, options);
  #| }

///| Public API

///|
/// Internal implementation for watch
fn watch_impl(
  paths : @core.Any,
  persistent? : Bool,
  ignored? : @core.Any,
  ignoreInitial? : Bool,
  followSymlinks? : Bool,
  cwd? : String,
  disableGlobbing? : Bool,
  usePolling? : Bool,
  interval? : Int,
  binaryInterval? : Int,
  alwaysStat? : Bool,
  depth? : Int,
  awaitWriteFinish? : @core.Any,
  ignorePermissionErrors? : Bool,
  atomic_? : Bool,
) -> FSWatcher {
  let options = @core.new_object()
  if persistent is Some(v) {
    options["persistent"] = @core.any(v)
  }
  if ignored is Some(v) {
    options["ignored"] = v
  }
  if ignoreInitial is Some(v) {
    options["ignoreInitial"] = @core.any(v)
  }
  if followSymlinks is Some(v) {
    options["followSymlinks"] = @core.any(v)
  }
  if cwd is Some(v) {
    options["cwd"] = @core.any(v)
  }
  if disableGlobbing is Some(v) {
    options["disableGlobbing"] = @core.any(v)
  }
  if usePolling is Some(v) {
    options["usePolling"] = @core.any(v)
  }
  if interval is Some(v) {
    options["interval"] = @core.any(v)
  }
  if binaryInterval is Some(v) {
    options["binaryInterval"] = @core.any(v)
  }
  if alwaysStat is Some(v) {
    options["alwaysStat"] = @core.any(v)
  }
  if depth is Some(v) {
    options["depth"] = @core.any(v)
  }
  if awaitWriteFinish is Some(v) {
    options["awaitWriteFinish"] = v
  }
  if ignorePermissionErrors is Some(v) {
    options["ignorePermissionErrors"] = @core.any(v)
  }
  if atomic_ is Some(v) {
    options["atomic"] = @core.any(v)
  }
  @core.identity(ffi_watch(paths, options))
}

///|
/// Create a file system watcher for a single path
/// JS: chokidar.watch(path, options)
/// See: https://github.com/paulmillr/chokidar#api
pub fn watch(
  path : String,
  persistent? : Bool,
  ignored? : @core.Any,
  ignoreInitial? : Bool,
  followSymlinks? : Bool,
  cwd? : String,
  disableGlobbing? : Bool,
  usePolling? : Bool,
  interval? : Int,
  binaryInterval? : Int,
  alwaysStat? : Bool,
  depth? : Int,
  awaitWriteFinish? : @core.Any,
  ignorePermissionErrors? : Bool,
  atomic_? : Bool,
) -> FSWatcher {
  watch_impl(
    @core.any(path),
    persistent?,
    ignored?,
    ignoreInitial?,
    followSymlinks?,
    cwd?,
    disableGlobbing?,
    usePolling?,
    interval?,
    binaryInterval?,
    alwaysStat?,
    depth?,
    awaitWriteFinish?,
    ignorePermissionErrors?,
    atomic_?,
  )
}

///|
/// Create a file system watcher for multiple paths
/// JS: chokidar.watch(paths, options)
/// See: https://github.com/paulmillr/chokidar#api
pub fn watch_paths(
  paths : Array[String],
  persistent? : Bool,
  ignored? : @core.Any,
  ignoreInitial? : Bool,
  followSymlinks? : Bool,
  cwd? : String,
  disableGlobbing? : Bool,
  usePolling? : Bool,
  interval? : Int,
  binaryInterval? : Int,
  alwaysStat? : Bool,
  depth? : Int,
  awaitWriteFinish? : @core.Any,
  ignorePermissionErrors? : Bool,
  atomic_? : Bool,
) -> FSWatcher {
  watch_impl(
    paths |> @core.identity,
    persistent?,
    ignored?,
    ignoreInitial?,
    followSymlinks?,
    cwd?,
    disableGlobbing?,
    usePolling?,
    interval?,
    binaryInterval?,
    alwaysStat?,
    depth?,
    awaitWriteFinish?,
    ignorePermissionErrors?,
    atomic_?,
  )
}

///| FSWatcher Methods

///|
/// Add a file or directory to watch
/// JS: watcher.add(path)
pub fn FSWatcher::add(self : FSWatcher, path : String) -> FSWatcher {
  @core.identity(self.as_any()._call("add", [@core.any(path)]))
}

///|
/// Add multiple files or directories to watch
/// JS: watcher.add(paths)
pub fn FSWatcher::add_paths(
  self : FSWatcher,
  paths : Array[String],
) -> FSWatcher {
  @core.identity(self.as_any()._call("add", [paths |> @core.identity]))
}

///|
/// Stop watching a file or directory
/// JS: watcher.unwatch(path)
pub fn FSWatcher::unwatch(self : FSWatcher, path : String) -> FSWatcher {
  @core.identity(self.as_any()._call("unwatch", [@core.any(path)]))
}

///|
/// Stop watching multiple files or directories
/// JS: watcher.unwatch(paths)
pub fn FSWatcher::unwatch_paths(
  self : FSWatcher,
  paths : Array[String],
) -> FSWatcher {
  @core.identity(self.as_any()._call("unwatch", [paths |> @core.identity]))
}

///|
/// Close the watcher and remove all listeners
/// JS: watcher.close()
pub async fn FSWatcher::close(self : FSWatcher) -> Unit {
  let promise : @core.Promise[Unit] = @core.identity(
    self.as_any()._call("close", []),
  )
  promise.wait()
}

///|
/// Get object of watched paths
/// JS: watcher.getWatched()
pub fn FSWatcher::getWatched(self : FSWatcher) -> @core.Any {
  self.as_any()._call("getWatched", [])
}

///|
/// Listen for file system events
/// JS: watcher.on(event, callback)
///
/// Events: 'add', 'addDir', 'change', 'unlink', 'unlinkDir', 'ready', 'raw', 'error', 'all'
pub fn FSWatcher::on(
  self : FSWatcher,
  event : String,
  callback : @core.Any,
) -> FSWatcher {
  @core.identity(self.as_any()._call("on", [@core.any(event), callback]))
}

///|
/// Remove event listener
/// JS: watcher.off(event, callback)
pub fn FSWatcher::off(
  self : FSWatcher,
  event : String,
  callback : @core.Any,
) -> FSWatcher {
  @core.identity(self.as_any()._call("off", [@core.any(event), callback]))
}

///| Typed Event Handlers

///|
/// Listen for file add event
/// Callback receives: (path: String, stats?: fs.Stats)
pub fn FSWatcher::on_add(
  self : FSWatcher,
  callback : (String, @core.Any) -> Unit,
) -> FSWatcher {
  self.on("add", @core.from_fn2(callback))
}

///|
/// Listen for file change event
/// Callback receives: (path: String, stats?: fs.Stats)
pub fn FSWatcher::on_change(
  self : FSWatcher,
  callback : (String, @core.Any) -> Unit,
) -> FSWatcher {
  self.on("change", @core.from_fn2(callback))
}

///|
/// Listen for directory add event
/// Callback receives: (path: String, stats?: fs.Stats)
pub fn FSWatcher::on_add_dir(
  self : FSWatcher,
  callback : (String, @core.Any) -> Unit,
) -> FSWatcher {
  self.on("addDir", callback |> @core.from_fn2)
}

///|
/// Listen for file unlink (delete) event
/// Callback receives: (path: String)
pub fn FSWatcher::on_unlink(
  self : FSWatcher,
  callback : (String) -> Unit,
) -> FSWatcher {
  self.on("unlink", callback |> @core.from_fn1)
}

///|
/// Listen for directory unlink (delete) event
/// Callback receives: (path: String)
pub fn FSWatcher::on_unlink_dir(
  self : FSWatcher,
  callback : (String) -> Unit,
) -> FSWatcher {
  self.on("unlinkDir", callback |> @core.from_fn1)
}

///|
/// Listen for ready event (initial scan complete)
/// Callback receives: ()
pub fn FSWatcher::on_ready(
  self : FSWatcher,
  callback : () -> Unit,
) -> FSWatcher {
  self.on("ready", @core.identity(callback))
}

///|
/// Listen for error event
/// Callback receives: (error: Error)
pub fn FSWatcher::on_error(
  self : FSWatcher,
  callback : (@core.Any) -> Unit,
) -> FSWatcher {
  self.on("error", callback |> @core.from_fn1)
}

///|
/// Listen for all events (raw)
/// Callback receives: (eventName: String, path: String, stats?: fs.Stats)
pub fn FSWatcher::on_all_raw(
  self : FSWatcher,
  callback : (String, String, @core.Any) -> Unit,
) -> FSWatcher {
  self.on("all", callback |> @core.from_fn3)
}

///|
/// Listen for all events (typed)
/// Callback receives: (eventName: EventName, path: String, stats?: fs.Stats)
pub fn FSWatcher::on_all(
  self : FSWatcher,
  callback : (EventName, String, @core.Any) -> Unit,
) -> FSWatcher {
  let wrapped = fn(event_str : String, path : String, stats : @core.Any) {
    if EventName::from_string(event_str) is Some(event) {
      callback(event, path, stats)
    }
  }
  self.on("all", wrapped |> @core.from_fn3)
}
