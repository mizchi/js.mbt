///|
/// Chokidar - Efficient file watching library
/// See: https://github.com/paulmillr/chokidar

///|
/// FSWatcher type - File system watcher instance
#external
pub type FSWatcher

///|
pub impl @js.JsImpl for FSWatcher

///| Core API Functions - FFI

///|
/// FFI: watch
extern "js" fn ffi_watch(paths : @js.Any, options : @js.Any) -> @js.Any =
  #| (paths, options) => {
  #|   const chokidar = require('chokidar');
  #|   return chokidar.watch(paths, options);
  #| }

///| Public API

///|
/// Internal implementation for watch
fn watch_impl(
  paths : @js.Any,
  persistent? : Bool,
  ignored? : @js.Any,
  ignoreInitial? : Bool,
  followSymlinks? : Bool,
  cwd? : String,
  disableGlobbing? : Bool,
  usePolling? : Bool,
  interval? : Int,
  binaryInterval? : Int,
  alwaysStat? : Bool,
  depth? : Int,
  awaitWriteFinish? : @js.Any,
  ignorePermissionErrors? : Bool,
  atomic_? : Bool,
) -> FSWatcher {
  let options = @js.Object::new()
  if persistent is Some(v) {
    options.set("persistent", @js.any(v))
  }
  if ignored is Some(v) {
    options.set("ignored", v)
  }
  if ignoreInitial is Some(v) {
    options.set("ignoreInitial", @js.any(v))
  }
  if followSymlinks is Some(v) {
    options.set("followSymlinks", @js.any(v))
  }
  if cwd is Some(v) {
    options.set("cwd", @js.any(v))
  }
  if disableGlobbing is Some(v) {
    options.set("disableGlobbing", @js.any(v))
  }
  if usePolling is Some(v) {
    options.set("usePolling", @js.any(v))
  }
  if interval is Some(v) {
    options.set("interval", @js.any(v))
  }
  if binaryInterval is Some(v) {
    options.set("binaryInterval", @js.any(v))
  }
  if alwaysStat is Some(v) {
    options.set("alwaysStat", @js.any(v))
  }
  if depth is Some(v) {
    options.set("depth", @js.any(v))
  }
  if awaitWriteFinish is Some(v) {
    options.set("awaitWriteFinish", v)
  }
  if ignorePermissionErrors is Some(v) {
    options.set("ignorePermissionErrors", @js.any(v))
  }
  if atomic_ is Some(v) {
    options.set("atomic", @js.any(v))
  }
  @js.identity(ffi_watch(paths, options.to_any()))
}

///|
/// Create a file system watcher for a single path
/// JS: chokidar.watch(path, options)
/// See: https://github.com/paulmillr/chokidar#api
pub fn watch(
  path : String,
  persistent? : Bool,
  ignored? : @js.Any,
  ignoreInitial? : Bool,
  followSymlinks? : Bool,
  cwd? : String,
  disableGlobbing? : Bool,
  usePolling? : Bool,
  interval? : Int,
  binaryInterval? : Int,
  alwaysStat? : Bool,
  depth? : Int,
  awaitWriteFinish? : @js.Any,
  ignorePermissionErrors? : Bool,
  atomic_? : Bool,
) -> FSWatcher {
  watch_impl(
    @js.any(path),
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
  ignored? : @js.Any,
  ignoreInitial? : Bool,
  followSymlinks? : Bool,
  cwd? : String,
  disableGlobbing? : Bool,
  usePolling? : Bool,
  interval? : Int,
  binaryInterval? : Int,
  alwaysStat? : Bool,
  depth? : Int,
  awaitWriteFinish? : @js.Any,
  ignorePermissionErrors? : Bool,
  atomic_? : Bool,
) -> FSWatcher {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < paths.length() {
    arr.call("push", [paths[i]]) |> ignore
    i = i + 1
  }
  watch_impl(
    arr.to_any(),
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
  @js.identity(self.call("add", [path]))
}

///|
/// Add multiple files or directories to watch
/// JS: watcher.add(paths)
pub fn FSWatcher::add_paths(
  self : FSWatcher,
  paths : Array[String],
) -> FSWatcher {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < paths.length() {
    arr.call("push", [paths[i]]) |> ignore
    i = i + 1
  }
  @js.identity(self.call("add", [arr]))
}

///|
/// Stop watching a file or directory
/// JS: watcher.unwatch(path)
pub fn FSWatcher::unwatch(self : FSWatcher, path : String) -> FSWatcher {
  @js.identity(self.call("unwatch", [path]))
}

///|
/// Stop watching multiple files or directories
/// JS: watcher.unwatch(paths)
pub fn FSWatcher::unwatch_paths(
  self : FSWatcher,
  paths : Array[String],
) -> FSWatcher {
  let arr = @js.JsArray::new()
  let mut i = 0
  while i < paths.length() {
    arr.call("push", [paths[i]]) |> ignore
    i = i + 1
  }
  @js.identity(self.call("unwatch", [arr]))
}

///|
/// Close the watcher and remove all listeners
/// JS: watcher.close()
pub async fn FSWatcher::close(self : FSWatcher) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("close", []))
  promise.wait()
}

///|
/// Get object of watched paths
/// JS: watcher.getWatched()
pub fn FSWatcher::getWatched(self : FSWatcher) -> @js.Any {
  self.call("getWatched", [])
}

///|
/// Listen for file system events
/// JS: watcher.on(event, callback)
///
/// Events: 'add', 'addDir', 'change', 'unlink', 'unlinkDir', 'ready', 'raw', 'error', 'all'
pub fn FSWatcher::on(
  self : FSWatcher,
  event : String,
  callback : @js.Any,
) -> FSWatcher {
  @js.identity(self.call("on", [@js.any(event), callback]))
}

///|
/// Remove event listener
/// JS: watcher.off(event, callback)
pub fn FSWatcher::off(
  self : FSWatcher,
  event : String,
  callback : @js.Any,
) -> FSWatcher {
  @js.identity(self.call("off", [@js.any(event), callback]))
}
