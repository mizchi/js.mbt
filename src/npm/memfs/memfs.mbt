///|
/// memfs bindings for MoonBit
/// https://github.com/streamich/memfs
///
/// In-memory file system with Node.js fs API.

// ============================================================
// Types
// ============================================================

///|
/// Volume - in-memory filesystem container
#external
pub type Volume

///|
pub extern "js" fn Volume::as_any(self : Volume) -> @nostd.Any =
  #| (x) => x

///|
/// MemFS - fs-compatible interface
#external
pub type MemFS

///|
pub extern "js" fn MemFS::as_any(self : MemFS) -> @nostd.Any =
  #| (x) => x

///|
/// Dirent - directory entry
#external
pub type Dirent

///|
pub extern "js" fn Dirent::as_any(self : Dirent) -> @nostd.Any =
  #| (x) => x

// ============================================================
// Module access
// ============================================================

///|
extern "js" fn memfs_module() -> @nostd.Any =
  #| () => require('memfs')

// ============================================================
// Volume constructors
// ============================================================

///|
/// Create a new empty Volume
pub fn createVolume() -> Volume {
  let mod = memfs_module()
  let volume_class = mod["Volume"]
  @nostd.new(volume_class, []).cast()
}

///|
/// Create a Volume from JSON object
/// JSON format: { "/path/to/file": "content", ... }
pub fn createVolumeFromJSON(json : @nostd.Any) -> Volume {
  let mod = memfs_module()
  mod["Volume"]._call("fromJSON", [json]).cast()
}

///|
/// Create fs interface from Volume
pub fn createFsFromVolume(vol : Volume) -> MemFS {
  let mod = memfs_module()
  mod._call("createFsFromVolume", [vol.as_any()]).cast()
}

// ============================================================
// Volume methods
// ============================================================

///|
/// Export Volume to JSON
pub fn Volume::toJSON(self : Volume) -> @nostd.Any {
  self.as_any()._call("toJSON", [])
}

///|
/// Reset Volume (clear all files)
pub fn Volume::reset(self : Volume) -> Unit {
  self.as_any()._call("reset", []) |> ignore
}

// ============================================================
// Convenience constructors
// ============================================================

///|
/// Create a new memfs instance (Volume + FS)
pub fn memfs() -> (Volume, MemFS) {
  let vol = createVolume()
  let fs = createFsFromVolume(vol)
  (vol, fs)
}

///|
/// Create memfs from initial files
/// files format: { "/path": "content", ... }
pub fn memfsFromJSON(files : @nostd.Any) -> (Volume, MemFS) {
  let vol = createVolumeFromJSON(files)
  let fs = createFsFromVolume(vol)
  (vol, fs)
}

// ============================================================
// MemFS Sync Methods
// ============================================================

///|
/// Read file content as string (UTF-8)
pub fn MemFS::readFileSync(self : MemFS, path : String) -> String {
  self
  .as_any()
  ._call("readFileSync", [@nostd.any(path), @nostd.any("utf8")])
  .cast()
}

///|
/// Read file content as buffer
pub fn MemFS::readFileSyncBuffer(self : MemFS, path : String) -> @nostd.Any {
  self.as_any()._call("readFileSync", [@nostd.any(path)])
}

///|
/// Write string content to file
pub fn MemFS::writeFileSync(self : MemFS, path : String, data : String) -> Unit {
  self.as_any()._call("writeFileSync", [@nostd.any(path), @nostd.any(data)])
  |> ignore
}

///|
/// Append string content to file
pub fn MemFS::appendFileSync(
  self : MemFS,
  path : String,
  data : String,
) -> Unit {
  self.as_any()._call("appendFileSync", [@nostd.any(path), @nostd.any(data)])
  |> ignore
}

///|
/// Check if path exists
pub fn MemFS::existsSync(self : MemFS, path : String) -> Bool {
  self.as_any()._call("existsSync", [@nostd.any(path)]).cast()
}

///|
/// Create directory
pub fn MemFS::mkdirSync(
  self : MemFS,
  path : String,
  recursive? : Bool = false,
) -> Unit {
  if recursive {
    let opts = @nostd.Object::new()
    opts["recursive"] = @nostd.any(true)
    self.as_any()._call("mkdirSync", [@nostd.any(path), opts]) |> ignore
  } else {
    self.as_any()._call("mkdirSync", [@nostd.any(path)]) |> ignore
  }
}

///|
/// Remove directory
pub fn MemFS::rmdirSync(
  self : MemFS,
  path : String,
  recursive? : Bool = false,
) -> Unit {
  if recursive {
    let opts = @nostd.Object::new()
    opts["recursive"] = @nostd.any(true)
    self.as_any()._call("rmdirSync", [@nostd.any(path), opts]) |> ignore
  } else {
    self.as_any()._call("rmdirSync", [@nostd.any(path)]) |> ignore
  }
}

///|
/// Read directory contents
pub fn MemFS::readdirSync(self : MemFS, path : String) -> Array[String] {
  self.as_any()._call("readdirSync", [@nostd.any(path)]).cast()
}

///|
/// Delete file
pub fn MemFS::unlinkSync(self : MemFS, path : String) -> Unit {
  self.as_any()._call("unlinkSync", [@nostd.any(path)]) |> ignore
}

///|
/// Rename/move file or directory
pub fn MemFS::renameSync(
  self : MemFS,
  old_path : String,
  new_path : String,
) -> Unit {
  self
  .as_any()
  ._call("renameSync", [@nostd.any(old_path), @nostd.any(new_path)])
  |> ignore
}

///|
/// Get file/directory stats
pub fn MemFS::statSync(self : MemFS, path : String) -> @fs.Stat {
  self.as_any()._call("statSync", [@nostd.any(path)]).cast()
}

///|
/// Get file/directory stats (don't follow symlinks)
pub fn MemFS::lstatSync(self : MemFS, path : String) -> @fs.Stat {
  self.as_any()._call("lstatSync", [@nostd.any(path)]).cast()
}

///|
/// Copy file
pub fn MemFS::copyFileSync(self : MemFS, src : String, dest : String) -> Unit {
  self.as_any()._call("copyFileSync", [@nostd.any(src), @nostd.any(dest)])
  |> ignore
}

///|
/// Resolve real path
pub fn MemFS::realpathSync(self : MemFS, path : String) -> String {
  self.as_any()._call("realpathSync", [@nostd.any(path)]).cast()
}

///|
/// Create symbolic link
pub fn MemFS::symlinkSync(self : MemFS, target : String, path : String) -> Unit {
  self.as_any()._call("symlinkSync", [@nostd.any(target), @nostd.any(path)])
  |> ignore
}

///|
/// Read symbolic link target
pub fn MemFS::readlinkSync(self : MemFS, path : String) -> String {
  self.as_any()._call("readlinkSync", [@nostd.any(path)]).cast()
}

///|
/// Change file mode
pub fn MemFS::chmodSync(self : MemFS, path : String, mode : Int) -> Unit {
  self.as_any()._call("chmodSync", [@nostd.any(path), @nostd.any(mode)])
  |> ignore
}

// ============================================================
// MemFS Async Methods
// ============================================================

///|
/// Read file content as string (async)
pub async fn MemFS::readFile(self : MemFS, path : String) -> String {
  let promises = self.as_any()["promises"]
  let promise : @nostd.Promise[String] = promises
    ._call("readFile", [@nostd.any(path), @nostd.any("utf8")])
    .cast()
  promise.wait()
}

///|
/// Write string content to file (async)
pub async fn MemFS::writeFile(
  self : MemFS,
  path : String,
  data : String,
) -> Unit {
  let promises = self.as_any()["promises"]
  let promise : @nostd.Promise[Unit] = promises
    ._call("writeFile", [@nostd.any(path), @nostd.any(data)])
    .cast()
  promise.wait()
}

///|
/// Create directory (async)
pub async fn MemFS::mkdir(
  self : MemFS,
  path : String,
  recursive? : Bool = false,
) -> Unit {
  let promises = self.as_any()["promises"]
  if recursive {
    let opts = @nostd.Object::new()
    opts["recursive"] = @nostd.any(true)
    let promise : @nostd.Promise[Unit] = promises
      ._call("mkdir", [@nostd.any(path), opts])
      .cast()
    promise.wait()
  } else {
    let promise : @nostd.Promise[Unit] = promises
      ._call("mkdir", [@nostd.any(path)])
      .cast()
    promise.wait()
  }
}

///|
/// Read directory contents (async)
pub async fn MemFS::readdir(self : MemFS, path : String) -> Array[String] {
  let promises = self.as_any()["promises"]
  let promise : @nostd.Promise[@nostd.Any] = promises
    ._call("readdir", [@nostd.any(path)])
    .cast()
  promise.wait().cast()
}

///|
/// Delete file (async)
pub async fn MemFS::unlink(self : MemFS, path : String) -> Unit {
  let promises = self.as_any()["promises"]
  let promise : @nostd.Promise[Unit] = promises
    ._call("unlink", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Remove directory (async)
pub async fn MemFS::rmdir(self : MemFS, path : String) -> Unit {
  let promises = self.as_any()["promises"]
  let promise : @nostd.Promise[Unit] = promises
    ._call("rmdir", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Get file/directory stats (async)
pub async fn MemFS::stat(self : MemFS, path : String) -> @fs.Stat {
  let promises = self.as_any()["promises"]
  let promise : @nostd.Promise[@fs.Stat] = promises
    ._call("stat", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Rename/move file or directory (async)
pub async fn MemFS::rename(
  self : MemFS,
  old_path : String,
  new_path : String,
) -> Unit {
  let promises = self.as_any()["promises"]
  let promise : @nostd.Promise[Unit] = promises
    ._call("rename", [@nostd.any(old_path), @nostd.any(new_path)])
    .cast()
  promise.wait()
}
