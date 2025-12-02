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
pub extern "js" fn Volume::as_any(self : Volume) -> @core.Any =
  #| (x) => x

///|
/// MemFS - fs-compatible interface
#external
pub type MemFS

///|
pub extern "js" fn MemFS::as_any(self : MemFS) -> @core.Any =
  #| (x) => x

///|
/// Dirent - directory entry
#external
pub type Dirent

///|
pub extern "js" fn Dirent::as_any(self : Dirent) -> @core.Any =
  #| (x) => x

// ============================================================
// Module access
// ============================================================

///|
extern "js" fn memfs_module() -> @core.Any =
  #| () => require('memfs')

// ============================================================
// Volume constructors
// ============================================================

///|
/// Create a new empty Volume
pub fn createVolume() -> Volume {
  let mod = memfs_module()
  let volume_class = mod["Volume"]
  @core.new(volume_class, []).cast()
}

///|
/// Create a Volume from JSON object
/// JSON format: { "/path/to/file": "content", ... }
pub fn createVolumeFromJSON(json : @core.Any) -> Volume {
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
pub fn Volume::toJSON(self : Volume) -> @core.Any {
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
pub fn memfsFromJSON(files : @core.Any) -> (Volume, MemFS) {
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
  ._call("readFileSync", [@core.any(path), @core.any("utf8")])
  .cast()
}

///|
/// Read file content as buffer
pub fn MemFS::readFileSyncBuffer(self : MemFS, path : String) -> @core.Any {
  self.as_any()._call("readFileSync", [@core.any(path)])
}

///|
/// Write string content to file
pub fn MemFS::writeFileSync(self : MemFS, path : String, data : String) -> Unit {
  self.as_any()._call("writeFileSync", [@core.any(path), @core.any(data)])
  |> ignore
}

///|
/// Append string content to file
pub fn MemFS::appendFileSync(
  self : MemFS,
  path : String,
  data : String,
) -> Unit {
  self.as_any()._call("appendFileSync", [@core.any(path), @core.any(data)])
  |> ignore
}

///|
/// Check if path exists
pub fn MemFS::existsSync(self : MemFS, path : String) -> Bool {
  self.as_any()._call("existsSync", [@core.any(path)]).cast()
}

///|
/// Create directory
pub fn MemFS::mkdirSync(
  self : MemFS,
  path : String,
  recursive? : Bool = false,
) -> Unit {
  if recursive {
    let opts = @core.new_object()
    opts["recursive"] = @core.any(true)
    self.as_any()._call("mkdirSync", [@core.any(path), opts]) |> ignore
  } else {
    self.as_any()._call("mkdirSync", [@core.any(path)]) |> ignore
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
    let opts = @core.new_object()
    opts["recursive"] = @core.any(true)
    self.as_any()._call("rmdirSync", [@core.any(path), opts]) |> ignore
  } else {
    self.as_any()._call("rmdirSync", [@core.any(path)]) |> ignore
  }
}

///|
/// Read directory contents
pub fn MemFS::readdirSync(self : MemFS, path : String) -> Array[String] {
  self.as_any()._call("readdirSync", [@core.any(path)]).cast()
}

///|
/// Delete file
pub fn MemFS::unlinkSync(self : MemFS, path : String) -> Unit {
  self.as_any()._call("unlinkSync", [@core.any(path)]) |> ignore
}

///|
/// Rename/move file or directory
pub fn MemFS::renameSync(
  self : MemFS,
  old_path : String,
  new_path : String,
) -> Unit {
  self.as_any()._call("renameSync", [@core.any(old_path), @core.any(new_path)])
  |> ignore
}

///|
/// Get file/directory stats
pub fn MemFS::statSync(self : MemFS, path : String) -> @fs.Stat {
  self.as_any()._call("statSync", [@core.any(path)]).cast()
}

///|
/// Get file/directory stats (don't follow symlinks)
pub fn MemFS::lstatSync(self : MemFS, path : String) -> @fs.Stat {
  self.as_any()._call("lstatSync", [@core.any(path)]).cast()
}

///|
/// Copy file
pub fn MemFS::copyFileSync(self : MemFS, src : String, dest : String) -> Unit {
  self.as_any()._call("copyFileSync", [@core.any(src), @core.any(dest)])
  |> ignore
}

///|
/// Resolve real path
pub fn MemFS::realpathSync(self : MemFS, path : String) -> String {
  self.as_any()._call("realpathSync", [@core.any(path)]).cast()
}

///|
/// Create symbolic link
pub fn MemFS::symlinkSync(self : MemFS, target : String, path : String) -> Unit {
  self.as_any()._call("symlinkSync", [@core.any(target), @core.any(path)])
  |> ignore
}

///|
/// Read symbolic link target
pub fn MemFS::readlinkSync(self : MemFS, path : String) -> String {
  self.as_any()._call("readlinkSync", [@core.any(path)]).cast()
}

///|
/// Change file mode
pub fn MemFS::chmodSync(self : MemFS, path : String, mode : Int) -> Unit {
  self.as_any()._call("chmodSync", [@core.any(path), @core.any(mode)]) |> ignore
}

// ============================================================
// MemFS Async Methods
// ============================================================

///|
/// Read file content as string (async)
pub async fn MemFS::readFile(self : MemFS, path : String) -> String {
  let promises = self.as_any()["promises"]
  let promise : @core.Promise[String] = promises
    ._call("readFile", [@core.any(path), @core.any("utf8")])
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
  let promise : @core.Promise[Unit] = promises
    ._call("writeFile", [@core.any(path), @core.any(data)])
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
    let opts = @core.new_object()
    opts["recursive"] = @core.any(true)
    let promise : @core.Promise[Unit] = promises
      ._call("mkdir", [@core.any(path), opts])
      .cast()
    promise.wait()
  } else {
    let promise : @core.Promise[Unit] = promises
      ._call("mkdir", [@core.any(path)])
      .cast()
    promise.wait()
  }
}

///|
/// Read directory contents (async)
pub async fn MemFS::readdir(self : MemFS, path : String) -> Array[String] {
  let promises = self.as_any()["promises"]
  let promise : @core.Promise[@core.Any] = promises
    ._call("readdir", [@core.any(path)])
    .cast()
  promise.wait().cast()
}

///|
/// Delete file (async)
pub async fn MemFS::unlink(self : MemFS, path : String) -> Unit {
  let promises = self.as_any()["promises"]
  let promise : @core.Promise[Unit] = promises
    ._call("unlink", [@core.any(path)])
    .cast()
  promise.wait()
}

///|
/// Remove directory (async)
pub async fn MemFS::rmdir(self : MemFS, path : String) -> Unit {
  let promises = self.as_any()["promises"]
  let promise : @core.Promise[Unit] = promises
    ._call("rmdir", [@core.any(path)])
    .cast()
  promise.wait()
}

///|
/// Get file/directory stats (async)
pub async fn MemFS::stat(self : MemFS, path : String) -> @fs.Stat {
  let promises = self.as_any()["promises"]
  let promise : @core.Promise[@fs.Stat] = promises
    ._call("stat", [@core.any(path)])
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
  let promise : @core.Promise[Unit] = promises
    ._call("rename", [@core.any(old_path), @core.any(new_path)])
    .cast()
  promise.wait()
}
