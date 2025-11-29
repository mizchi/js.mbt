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
pub impl @js.JsImpl for Volume

///|
/// MemFS - fs-compatible interface
#external
pub type MemFS

///|
pub impl @js.JsImpl for MemFS

///|
/// Dirent - directory entry
#external
pub type Dirent

///|
pub impl @js.JsImpl for Dirent

// ============================================================
// Module access
// ============================================================

///|
extern "js" fn ffi_require_memfs() -> @js.Any =
  #| () => require('memfs')

///|
fn memfs_module() -> @js.Any {
  ffi_require_memfs()
}

// ============================================================
// Volume constructors
// ============================================================

///|
/// Create a new empty Volume
pub fn createVolume() -> Volume {
  let mod = memfs_module()
  let volume_class = mod.get("Volume")
  @js.new_(volume_class, []).cast()
}

///|
/// Create a Volume from JSON object
/// JSON format: { "/path/to/file": "content", ... }
pub fn createVolumeFromJSON(json : @js.Any) -> Volume {
  let mod = memfs_module()
  mod.get("Volume").call1("fromJSON", json).cast()
}

///|
/// Create fs interface from Volume
pub fn createFsFromVolume(vol : Volume) -> MemFS {
  let mod = memfs_module()
  mod.call1("createFsFromVolume", vol).cast()
}

// ============================================================
// Volume methods
// ============================================================

///|
/// Export Volume to JSON
pub fn Volume::toJSON(self : Volume) -> @js.Any {
  self.call0("toJSON")
}

///|
/// Reset Volume (clear all files)
pub fn Volume::reset(self : Volume) -> Unit {
  self.call0("reset") |> ignore
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
pub fn memfsFromJSON(files : @js.Any) -> (Volume, MemFS) {
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
  self.call2("readFileSync", path, "utf8").cast()
}

///|
/// Read file content as buffer
pub fn MemFS::readFileSyncBuffer(self : MemFS, path : String) -> @js.Any {
  self.call1("readFileSync", path)
}

///|
/// Write string content to file
pub fn MemFS::writeFileSync(self : MemFS, path : String, data : String) -> Unit {
  self.call2("writeFileSync", path, data) |> ignore
}

///|
/// Append string content to file
pub fn MemFS::appendFileSync(
  self : MemFS,
  path : String,
  data : String,
) -> Unit {
  self.call2("appendFileSync", path, data) |> ignore
}

///|
/// Check if path exists
pub fn MemFS::existsSync(self : MemFS, path : String) -> Bool {
  self.call1("existsSync", path).cast()
}

///|
/// Create directory
pub fn MemFS::mkdirSync(
  self : MemFS,
  path : String,
  recursive? : Bool = false,
) -> Unit {
  if recursive {
    let opts = @js.Object::new()
    opts["recursive"] = true
    self.call2("mkdirSync", path, opts.to_any()) |> ignore
  } else {
    self.call1("mkdirSync", path) |> ignore
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
    let opts = @js.Object::new()
    opts["recursive"] = true
    self.call2("rmdirSync", path, opts.to_any()) |> ignore
  } else {
    self.call1("rmdirSync", path) |> ignore
  }
}

///|
/// Read directory contents
pub fn MemFS::readdirSync(self : MemFS, path : String) -> Array[String] {
  @js.identity(self.call1("readdirSync", path))
}

///|
/// Delete file
pub fn MemFS::unlinkSync(self : MemFS, path : String) -> Unit {
  self.call1("unlinkSync", path) |> ignore
}

///|
/// Rename/move file or directory
pub fn MemFS::renameSync(
  self : MemFS,
  old_path : String,
  new_path : String,
) -> Unit {
  self.call2("renameSync", old_path, new_path) |> ignore
}

///|
/// Get file/directory stats
pub fn MemFS::statSync(self : MemFS, path : String) -> @fs.Stat {
  self.call1("statSync", path).cast()
}

///|
/// Get file/directory stats (don't follow symlinks)
pub fn MemFS::lstatSync(self : MemFS, path : String) -> @fs.Stat {
  self.call1("lstatSync", path).cast()
}

///|
/// Copy file
pub fn MemFS::copyFileSync(self : MemFS, src : String, dest : String) -> Unit {
  self.call2("copyFileSync", src, dest) |> ignore
}

///|
/// Resolve real path
pub fn MemFS::realpathSync(self : MemFS, path : String) -> String {
  self.call1("realpathSync", path).cast()
}

///|
/// Create symbolic link
pub fn MemFS::symlinkSync(self : MemFS, target : String, path : String) -> Unit {
  self.call2("symlinkSync", target, path) |> ignore
}

///|
/// Read symbolic link target
pub fn MemFS::readlinkSync(self : MemFS, path : String) -> String {
  self.call1("readlinkSync", path).cast()
}

///|
/// Change file mode
pub fn MemFS::chmodSync(self : MemFS, path : String, mode : Int) -> Unit {
  self.call2("chmodSync", path, mode) |> ignore
}

// ============================================================
// MemFS Async Methods
// ============================================================

///|
/// Read file content as string (async)
pub async fn MemFS::readFile(self : MemFS, path : String) -> String {
  let promises = self.get("promises")
  let promise : @js.Promise[String] = promises
    .call2("readFile", path, "utf8")
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
  let promises = self.get("promises")
  let promise : @js.Promise[Unit] = promises
    .call2("writeFile", path, data)
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
  let promises = self.get("promises")
  if recursive {
    let opts = @js.Object::new()
    opts["recursive"] = true
    let promise : @js.Promise[Unit] = promises
      .call2("mkdir", path, opts.to_any())
      .cast()
    promise.wait()
  } else {
    let promise : @js.Promise[Unit] = promises.call1("mkdir", path).cast()
    promise.wait()
  }
}

///|
/// Read directory contents (async)
pub async fn MemFS::readdir(self : MemFS, path : String) -> Array[String] {
  let promises = self.get("promises")
  let promise : @js.Promise[@js.Any] = promises.call1("readdir", path).cast()
  @js.identity(promise.wait())
}

///|
/// Delete file (async)
pub async fn MemFS::unlink(self : MemFS, path : String) -> Unit {
  let promises = self.get("promises")
  let promise : @js.Promise[Unit] = promises.call1("unlink", path).cast()
  promise.wait()
}

///|
/// Remove directory (async)
pub async fn MemFS::rmdir(self : MemFS, path : String) -> Unit {
  let promises = self.get("promises")
  let promise : @js.Promise[Unit] = promises.call1("rmdir", path).cast()
  promise.wait()
}

///|
/// Get file/directory stats (async)
pub async fn MemFS::stat(self : MemFS, path : String) -> @fs.Stat {
  let promises = self.get("promises")
  let promise : @js.Promise[@fs.Stat] = promises.call1("stat", path).cast()
  promise.wait()
}

///|
/// Rename/move file or directory (async)
pub async fn MemFS::rename(
  self : MemFS,
  old_path : String,
  new_path : String,
) -> Unit {
  let promises = self.get("promises")
  let promise : @js.Promise[Unit] = promises
    .call2("rename", old_path, new_path)
    .cast()
  promise.wait()
}
