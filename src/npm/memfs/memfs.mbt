///|
/// memfs bindings for MoonBit
/// https://github.com/streamich/memfs
///
/// In-memory file system with Node.js fs API.

///| Types

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

///|
/// Stats - file/directory statistics
#external
pub type Stats

///|
pub impl @js.JsImpl for Stats

///| Volume FFI

///|
extern "js" fn ffi_create_volume() -> Volume =
  #| () => new (require('memfs').Volume)()

///|
extern "js" fn ffi_create_volume_from_json(json : @js.Any) -> Volume =
  #| (json) => require('memfs').Volume.fromJSON(json)

///|
extern "js" fn ffi_create_fs_from_volume(vol : Volume) -> MemFS =
  #| (vol) => require('memfs').createFsFromVolume(vol)

///|
extern "js" fn ffi_volume_to_json(vol : Volume) -> @js.Any =
  #| (vol) => vol.toJSON()

///|
extern "js" fn ffi_volume_reset(vol : Volume) -> Unit =
  #| (vol) => vol.reset()

///| Volume Methods

///|
/// Create a new empty Volume
pub fn createVolume() -> Volume {
  ffi_create_volume()
}

///|
/// Create a Volume from JSON object
/// JSON format: { "/path/to/file": "content", ... }
pub fn createVolumeFromJSON(json : @js.Any) -> Volume {
  ffi_create_volume_from_json(json)
}

///|
/// Create fs interface from Volume
pub fn createFsFromVolume(vol : Volume) -> MemFS {
  ffi_create_fs_from_volume(vol)
}

///|
/// Export Volume to JSON
pub fn Volume::toJSON(self : Volume) -> @js.Any {
  ffi_volume_to_json(self)
}

///|
/// Reset Volume (clear all files)
pub fn Volume::reset(self : Volume) -> Unit {
  ffi_volume_reset(self)
}

///| Convenience constructor

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

///| MemFS Sync Methods

///|
extern "js" fn ffi_read_file_sync(fs : MemFS, path : String) -> String =
  #| (fs, path) => fs.readFileSync(path, 'utf8')

///|
extern "js" fn ffi_read_file_sync_buffer(fs : MemFS, path : String) -> @js.Any =
  #| (fs, path) => fs.readFileSync(path)

///|
extern "js" fn ffi_write_file_sync(
  fs : MemFS,
  path : String,
  data : String,
) -> Unit =
  #| (fs, path, data) => fs.writeFileSync(path, data)

///|
extern "js" fn ffi_append_file_sync(
  fs : MemFS,
  path : String,
  data : String,
) -> Unit =
  #| (fs, path, data) => fs.appendFileSync(path, data)

///|
extern "js" fn ffi_exists_sync(fs : MemFS, path : String) -> Bool =
  #| (fs, path) => fs.existsSync(path)

///|
extern "js" fn ffi_mkdir_sync(fs : MemFS, path : String) -> Unit =
  #| (fs, path) => fs.mkdirSync(path)

///|
extern "js" fn ffi_mkdir_sync_recursive(fs : MemFS, path : String) -> Unit =
  #| (fs, path) => fs.mkdirSync(path, { recursive: true })

///|
extern "js" fn ffi_rmdir_sync(fs : MemFS, path : String) -> Unit =
  #| (fs, path) => fs.rmdirSync(path)

///|
extern "js" fn ffi_rmdir_sync_recursive(fs : MemFS, path : String) -> Unit =
  #| (fs, path) => fs.rmdirSync(path, { recursive: true })

///|
extern "js" fn ffi_readdir_sync(fs : MemFS, path : String) -> @js.Any =
  #| (fs, path) => fs.readdirSync(path)

///|
extern "js" fn ffi_unlink_sync(fs : MemFS, path : String) -> Unit =
  #| (fs, path) => fs.unlinkSync(path)

///|
extern "js" fn ffi_rename_sync(
  fs : MemFS,
  old_path : String,
  new_path : String,
) -> Unit =
  #| (fs, oldPath, newPath) => fs.renameSync(oldPath, newPath)

///|
extern "js" fn ffi_stat_sync(fs : MemFS, path : String) -> Stats =
  #| (fs, path) => fs.statSync(path)

///|
extern "js" fn ffi_lstat_sync(fs : MemFS, path : String) -> Stats =
  #| (fs, path) => fs.lstatSync(path)

///|
extern "js" fn ffi_copy_file_sync(
  fs : MemFS,
  src : String,
  dest : String,
) -> Unit =
  #| (fs, src, dest) => fs.copyFileSync(src, dest)

///|
extern "js" fn ffi_realpath_sync(fs : MemFS, path : String) -> String =
  #| (fs, path) => fs.realpathSync(path)

///|
extern "js" fn ffi_symlink_sync(
  fs : MemFS,
  target : String,
  path : String,
) -> Unit =
  #| (fs, target, path) => fs.symlinkSync(target, path)

///|
extern "js" fn ffi_readlink_sync(fs : MemFS, path : String) -> String =
  #| (fs, path) => fs.readlinkSync(path)

///|
extern "js" fn ffi_chmod_sync(fs : MemFS, path : String, mode : Int) -> Unit =
  #| (fs, path, mode) => fs.chmodSync(path, mode)

///| MemFS Sync Methods

///|
/// Read file content as string (UTF-8)
pub fn MemFS::readFileSync(self : MemFS, path : String) -> String {
  ffi_read_file_sync(self, path)
}

///|
/// Read file content as buffer
pub fn MemFS::readFileSyncBuffer(self : MemFS, path : String) -> @js.Any {
  ffi_read_file_sync_buffer(self, path)
}

///|
/// Write string content to file
pub fn MemFS::writeFileSync(self : MemFS, path : String, data : String) -> Unit {
  ffi_write_file_sync(self, path, data)
}

///|
/// Append string content to file
pub fn MemFS::appendFileSync(
  self : MemFS,
  path : String,
  data : String,
) -> Unit {
  ffi_append_file_sync(self, path, data)
}

///|
/// Check if path exists
pub fn MemFS::existsSync(self : MemFS, path : String) -> Bool {
  ffi_exists_sync(self, path)
}

///|
/// Create directory
pub fn MemFS::mkdirSync(
  self : MemFS,
  path : String,
  recursive? : Bool = false,
) -> Unit {
  if recursive {
    ffi_mkdir_sync_recursive(self, path)
  } else {
    ffi_mkdir_sync(self, path)
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
    ffi_rmdir_sync_recursive(self, path)
  } else {
    ffi_rmdir_sync(self, path)
  }
}

///|
/// Read directory contents
pub fn MemFS::readdirSync(self : MemFS, path : String) -> Array[String] {
  @js.identity(ffi_readdir_sync(self, path))
}

///|
/// Delete file
pub fn MemFS::unlinkSync(self : MemFS, path : String) -> Unit {
  ffi_unlink_sync(self, path)
}

///|
/// Rename/move file or directory
pub fn MemFS::renameSync(
  self : MemFS,
  old_path : String,
  new_path : String,
) -> Unit {
  ffi_rename_sync(self, old_path, new_path)
}

///|
/// Get file/directory stats
pub fn MemFS::statSync(self : MemFS, path : String) -> Stats {
  ffi_stat_sync(self, path)
}

///|
/// Get file/directory stats (don't follow symlinks)
pub fn MemFS::lstatSync(self : MemFS, path : String) -> Stats {
  ffi_lstat_sync(self, path)
}

///|
/// Copy file
pub fn MemFS::copyFileSync(self : MemFS, src : String, dest : String) -> Unit {
  ffi_copy_file_sync(self, src, dest)
}

///|
/// Resolve real path
pub fn MemFS::realpathSync(self : MemFS, path : String) -> String {
  ffi_realpath_sync(self, path)
}

///|
/// Create symbolic link
pub fn MemFS::symlinkSync(self : MemFS, target : String, path : String) -> Unit {
  ffi_symlink_sync(self, target, path)
}

///|
/// Read symbolic link target
pub fn MemFS::readlinkSync(self : MemFS, path : String) -> String {
  ffi_readlink_sync(self, path)
}

///|
/// Change file mode
pub fn MemFS::chmodSync(self : MemFS, path : String, mode : Int) -> Unit {
  ffi_chmod_sync(self, path, mode)
}

///| MemFS Async Methods

///|
extern "js" fn ffi_read_file(fs : MemFS, path : String) -> @js.Promise[String] =
  #| (fs, path) => fs.promises.readFile(path, 'utf8')

///|
extern "js" fn ffi_write_file(
  fs : MemFS,
  path : String,
  data : String,
) -> @js.Promise[Unit] =
  #| (fs, path, data) => fs.promises.writeFile(path, data)

///|
extern "js" fn ffi_mkdir(fs : MemFS, path : String) -> @js.Promise[Unit] =
  #| (fs, path) => fs.promises.mkdir(path)

///|
extern "js" fn ffi_mkdir_recursive(
  fs : MemFS,
  path : String,
) -> @js.Promise[Unit] =
  #| (fs, path) => fs.promises.mkdir(path, { recursive: true })

///|
extern "js" fn ffi_readdir(fs : MemFS, path : String) -> @js.Promise[@js.Any] =
  #| (fs, path) => fs.promises.readdir(path)

///|
extern "js" fn ffi_unlink(fs : MemFS, path : String) -> @js.Promise[Unit] =
  #| (fs, path) => fs.promises.unlink(path)

///|
extern "js" fn ffi_rmdir(fs : MemFS, path : String) -> @js.Promise[Unit] =
  #| (fs, path) => fs.promises.rmdir(path)

///|
extern "js" fn ffi_stat(fs : MemFS, path : String) -> @js.Promise[Stats] =
  #| (fs, path) => fs.promises.stat(path)

///|
extern "js" fn ffi_rename(
  fs : MemFS,
  old_path : String,
  new_path : String,
) -> @js.Promise[Unit] =
  #| (fs, oldPath, newPath) => fs.promises.rename(oldPath, newPath)

///| MemFS Async Methods

///|
/// Read file content as string (async)
pub async fn MemFS::readFile(self : MemFS, path : String) -> String {
  ffi_read_file(self, path).wait()
}

///|
/// Write string content to file (async)
pub async fn MemFS::writeFile(
  self : MemFS,
  path : String,
  data : String,
) -> Unit {
  ffi_write_file(self, path, data).wait()
}

///|
/// Create directory (async)
pub async fn MemFS::mkdir(
  self : MemFS,
  path : String,
  recursive? : Bool = false,
) -> Unit {
  if recursive {
    ffi_mkdir_recursive(self, path).wait()
  } else {
    ffi_mkdir(self, path).wait()
  }
}

///|
/// Read directory contents (async)
pub async fn MemFS::readdir(self : MemFS, path : String) -> Array[String] {
  @js.identity(ffi_readdir(self, path).wait())
}

///|
/// Delete file (async)
pub async fn MemFS::unlink(self : MemFS, path : String) -> Unit {
  ffi_unlink(self, path).wait()
}

///|
/// Remove directory (async)
pub async fn MemFS::rmdir(self : MemFS, path : String) -> Unit {
  ffi_rmdir(self, path).wait()
}

///|
/// Get file/directory stats (async)
pub async fn MemFS::stat(self : MemFS, path : String) -> Stats {
  ffi_stat(self, path).wait()
}

///|
/// Rename/move file or directory (async)
pub async fn MemFS::rename(
  self : MemFS,
  old_path : String,
  new_path : String,
) -> Unit {
  ffi_rename(self, old_path, new_path).wait()
}

///| Stats Methods

///|
extern "js" fn ffi_stats_is_file(stats : Stats) -> Bool =
  #| (stats) => stats.isFile()

///|
extern "js" fn ffi_stats_is_directory(stats : Stats) -> Bool =
  #| (stats) => stats.isDirectory()

///|
extern "js" fn ffi_stats_is_symlink(stats : Stats) -> Bool =
  #| (stats) => stats.isSymbolicLink()

///|
extern "js" fn ffi_stats_size(stats : Stats) -> Int =
  #| (stats) => stats.size

///|
extern "js" fn ffi_stats_mode(stats : Stats) -> Int =
  #| (stats) => stats.mode

///|
extern "js" fn ffi_stats_mtime(stats : Stats) -> @js.Any =
  #| (stats) => stats.mtime

///|
extern "js" fn ffi_stats_atime(stats : Stats) -> @js.Any =
  #| (stats) => stats.atime

///|
extern "js" fn ffi_stats_ctime(stats : Stats) -> @js.Any =
  #| (stats) => stats.ctime

///| Stats Methods

///|
/// Check if this is a regular file
pub fn Stats::isFile(self : Stats) -> Bool {
  ffi_stats_is_file(self)
}

///|
/// Check if this is a directory
pub fn Stats::isDirectory(self : Stats) -> Bool {
  ffi_stats_is_directory(self)
}

///|
/// Check if this is a symbolic link
pub fn Stats::isSymbolicLink(self : Stats) -> Bool {
  ffi_stats_is_symlink(self)
}

///|
/// Get file size in bytes
pub fn Stats::size(self : Stats) -> Int {
  ffi_stats_size(self)
}

///|
/// Get file mode
pub fn Stats::mode(self : Stats) -> Int {
  ffi_stats_mode(self)
}

///|
/// Get modification time
pub fn Stats::mtime(self : Stats) -> @js.Any {
  ffi_stats_mtime(self)
}

///|
/// Get access time
pub fn Stats::atime(self : Stats) -> @js.Any {
  ffi_stats_atime(self)
}

///|
/// Get change time
pub fn Stats::ctime(self : Stats) -> @js.Any {
  ffi_stats_ctime(self)
}
