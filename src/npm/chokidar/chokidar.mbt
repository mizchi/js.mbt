///|
/// Chokidar - Efficient file watching library
/// See: https://github.com/paulmillr/chokidar

///|
/// FSWatcher type - File system watcher instance
#external
pub type FSWatcher

///|
pub impl @js.JsImpl for FSWatcher

///|
/// Watch options for configuring file system watching
pub(all) struct WatchOptions {
  persistent : Bool?
  ignored : @js.Js?
  ignoreInitial : Bool?
  followSymlinks : Bool?
  cwd : String?
  disableGlobbing : Bool?
  usePolling : Bool?
  interval : Int?
  binaryInterval : Int?
  alwaysStat : Bool?
  depth : Int?
  awaitWriteFinish : @js.Js?
  ignorePermissionErrors : Bool?
  atomic_ : Bool?
} derive(Show)

///| Core API Functions - FFI

///|
/// FFI: watch
extern "js" fn ffi_watch(paths : @js.Js, options : @js.Js) -> @js.Js =
  #| (paths, options) => {
  #|   const chokidar = require('chokidar');
  #|   return chokidar.watch(paths, options);
  #| }

///| Public API

///|
/// Create a file system watcher
/// JS: chokidar.watch(paths, options)
/// See: https://github.com/paulmillr/chokidar#api
pub fn watch(
  paths : @js.Js,
  persistent? : Bool,
  ignored? : @js.Js,
  ignoreInitial? : Bool,
  followSymlinks? : Bool,
  cwd? : String,
  disableGlobbing? : Bool,
  usePolling? : Bool,
  interval? : Int,
  binaryInterval? : Int,
  alwaysStat? : Bool,
  depth? : Int,
  awaitWriteFinish? : @js.Js,
  ignorePermissionErrors? : Bool,
  atomic_? : Bool,
) -> FSWatcher {
  let options = @js.Object::new()
  match persistent {
    Some(v) => options.set("persistent", @js.js(v))
    None => ()
  }
  match ignored {
    Some(v) => options.set("ignored", v)
    None => ()
  }
  match ignoreInitial {
    Some(v) => options.set("ignoreInitial", @js.js(v))
    None => ()
  }
  match followSymlinks {
    Some(v) => options.set("followSymlinks", @js.js(v))
    None => ()
  }
  match cwd {
    Some(v) => options.set("cwd", @js.js(v))
    None => ()
  }
  match disableGlobbing {
    Some(v) => options.set("disableGlobbing", @js.js(v))
    None => ()
  }
  match usePolling {
    Some(v) => options.set("usePolling", @js.js(v))
    None => ()
  }
  match interval {
    Some(v) => options.set("interval", @js.js(v))
    None => ()
  }
  match binaryInterval {
    Some(v) => options.set("binaryInterval", @js.js(v))
    None => ()
  }
  match alwaysStat {
    Some(v) => options.set("alwaysStat", @js.js(v))
    None => ()
  }
  match depth {
    Some(v) => options.set("depth", @js.js(v))
    None => ()
  }
  match awaitWriteFinish {
    Some(v) => options.set("awaitWriteFinish", v)
    None => ()
  }
  match ignorePermissionErrors {
    Some(v) => options.set("ignorePermissionErrors", @js.js(v))
    None => ()
  }
  match atomic_ {
    Some(v) => options.set("atomic", @js.js(v))
    None => ()
  }
  @js.unsafe_cast(ffi_watch(paths, options.to_js()))
}

///| FSWatcher Methods

///|
/// Add files or directories to watch
/// JS: watcher.add(paths)
pub fn FSWatcher::add(self : FSWatcher, paths : @js.Js) -> FSWatcher {
  @js.unsafe_cast(self.call("add", [paths]))
}

///|
/// Stop watching files or directories
/// JS: watcher.unwatch(paths)
pub fn FSWatcher::unwatch(self : FSWatcher, paths : @js.Js) -> FSWatcher {
  @js.unsafe_cast(self.call("unwatch", [paths]))
}

///|
/// Close the watcher and remove all listeners
/// JS: watcher.close()
pub async fn FSWatcher::close(self : FSWatcher) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("close", []))
  promise.wait()
}

///|
/// Get object of watched paths
/// JS: watcher.getWatched()
pub fn FSWatcher::getWatched(self : FSWatcher) -> @js.Js {
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
  callback : @js.Js,
) -> FSWatcher {
  @js.unsafe_cast(self.call("on", [@js.js(event), callback]))
}

///|
/// Remove event listener
/// JS: watcher.off(event, callback)
pub fn FSWatcher::off(
  self : FSWatcher,
  event : String,
  callback : @js.Js,
) -> FSWatcher {
  @js.unsafe_cast(self.call("off", [@js.js(event), callback]))
}
