// https://nodejs.org/api/fs.html
// Synchronous File System API

///|
/// Internal: existsSync via #module
#module("node:fs")
extern "js" fn internal_exists_sync(path : String) -> Bool = "existsSync"

///|
/// Internal: readFileSync via #module (returns Buffer)
#module("node:fs")
extern "js" fn internal_read_file_sync(path : String) -> @buffer.Buffer = "readFileSync"

///|
/// Internal: readFileSync with encoding via #module (ESM compatible)
#module("node:fs")
extern "js" fn internal_read_file_sync_string(
  path : String,
  encoding : String,
) -> String = "readFileSync"

///|
/// Internal: readdirSync via #module (ESM compatible)
#module("node:fs")
extern "js" fn internal_readdir_sync(path : String) -> Array[String] = "readdirSync"

///|
/// Internal: unlinkSync via #module
#module("node:fs")
extern "js" fn internal_unlink_sync(path : String) -> Unit = "unlinkSync"

///|
/// Internal: readlinkSync via #module
#module("node:fs")
extern "js" fn internal_readlink_sync(path : String) -> String = "readlinkSync"

///|
/// Internal: realpathSync via #module
#module("node:fs")
extern "js" fn internal_realpath_sync(path : String) -> String = "realpathSync"

///|
/// Internal: closeSync via #module
#module("node:fs")
extern "js" fn internal_close_sync(fd : Int) -> Unit = "closeSync"

///|
/// Internal: createReadStream via #module
#module("node:fs")
extern "js" fn internal_create_read_stream(path : String) -> @stream.Readable = "createReadStream"

///|
/// Internal: createWriteStream via #module
#module("node:fs")
extern "js" fn internal_create_write_stream(path : String) -> @stream.Writable = "createWriteStream"

///|
/// Internal: mkdirSync via #module (basic, no options)
#module("node:fs")
extern "js" fn internal_mkdir_sync(path : String) -> Unit = "mkdirSync"

///|
/// Internal: mkdirSync with options via #module
#module("node:fs")
extern "js" fn internal_mkdir_sync_opts(
  path : String,
  opts : @core.Any,
) -> Unit = "mkdirSync"

///|
/// Internal: writeFileSync via #module
#module("node:fs")
extern "js" fn internal_write_file_sync(
  path : String,
  data : @core.Any,
) -> Unit = "writeFileSync"

///|
/// Internal: statSync via #module
#module("node:fs")
extern "js" fn internal_stat_sync(path : String) -> Stat = "statSync"

///|
/// Internal: renameSync via #module
#module("node:fs")
extern "js" fn internal_rename_sync(
  old_path : String,
  new_path : String,
) -> Unit = "renameSync"

///|
/// Internal: copyFileSync via #module
#module("node:fs")
extern "js" fn internal_copy_file_sync(src : String, dest : String) -> Unit = "copyFileSync"

///|
/// Internal: rmSync basic via #module
#module("node:fs")
extern "js" fn internal_rm_sync(path : String) -> Unit = "rmSync"

///|
/// Internal: rmSync with options via #module
#module("node:fs")
extern "js" fn internal_rm_sync_opts(path : String, opts : @core.Any) -> Unit = "rmSync"

///| File Reading

///|
/// Read file synchronously as Buffer
#alias(readFileSync)
pub fn read_file_sync(path : String) -> @buffer.Buffer raise @core.ThrowError {
  @core.throwable(fn() { internal_read_file_sync(path) })
}

// ///|
// #module("node:fs")
// fn internal_read_file_sync2(path : String) -> @buffer.Buffer = "readFileSync"

///|
/// Read file synchronously as string with encoding
pub fn read_file_sync_string(
  path : String,
  encoding : String,
) -> String raise @core.ThrowError {
  @core.throwable(fn() { internal_read_file_sync_string(path, encoding) })
}

///|
/// Read file synchronously as string with encoding
/// JS: fs.readFileSync(path, encoding)
pub fn read_file_as_string(
  path : String,
  encoding? : String = "utf8",
) -> String raise @core.ThrowError {
  @core.throwable(fn() { internal_read_file_sync_string(path, encoding) })
}

///|
/// Read file synchronously as Buffer
/// JS: fs.readFileSync(path)
pub fn read_file_as_buffer(
  path : String,
) -> @buffer.Buffer raise @core.ThrowError {
  @core.throwable(fn() { internal_read_file_sync(path) })
}

///| File Writing

///|
/// Write file synchronously
#alias(write_file_sync)
pub fn writeFileSync(
  path : String,
  data : @core.Any,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() { internal_write_file_sync(path, data) })
}

///|
/// Internal: appendFileSync via #module
#module("node:fs")
extern "js" fn internal_append_file_sync(
  path : String,
  data : @core.Any,
) -> Unit = "appendFileSync"

///|
/// Append to file synchronously
#alias(appendFileSync)
pub fn append_file_sync(
  path : String,
  data : @core.Any,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() { internal_append_file_sync(path, data) })
}

///| File/Directory Operations

///|
/// Check if path exists
#alias(exists_sync)
pub fn existsSync(path : String) -> Bool {
  internal_exists_sync(path)
}

///|
/// Get file statistics
#alias(stat_sync)
pub fn statSync(path : String) -> Stat raise @core.ThrowError {
  @core.throwable(fn() { internal_stat_sync(path) })
}

///|
/// Create directory synchronously
#alias(mkdir_sync)
pub fn mkdirSync(
  path : String,
  recursive? : Bool,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    match recursive {
      Some(r) => {
        let opts = @core.from_entries([("recursive", @core.any(r))])
        internal_mkdir_sync_opts(path, opts)
      }
      None => internal_mkdir_sync(path)
    }
  })
}

///|
/// Delete file synchronously
#alias(unlink_sync)
pub fn unlinkSync(path : String) -> Unit raise @core.ThrowError {
  @core.throwable(fn() { internal_unlink_sync(path) })
}

///|
/// Rename/move file or directory synchronously
#alias(rename_sync)
pub fn renameSync(
  old_path : String,
  new_path : String,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() { internal_rename_sync(old_path, new_path) })
}

///|
/// Copy file synchronously
// #alias(copyFileSync)
pub fn copyFileSync(src : String, dest : String) -> Unit raise @core.ThrowError {
  @core.throwable(fn() { internal_copy_file_sync(src, dest) })
}

///|
/// Read directory contents synchronously
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(readdir_sync)
pub fn readdirSync(path : String) -> Array[String] raise @core.ThrowError {
  @core.throwable(fn() { internal_readdir_sync(path) })
}

///|
/// Remove file or directory synchronously
#alias(rm_sync)
pub fn rmSync(
  path : String,
  recursive? : Bool,
  force? : Bool,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    match (recursive, force) {
      (None, None) => internal_rm_sync(path)
      _ => {
        let entries : Array[(String, @core.Any)] = []
        if recursive is Some(v) {
          entries.push(("recursive", @core.any(v)))
        }
        if force is Some(v) {
          entries.push(("force", @core.any(v)))
        }
        let opts = @core.from_entries(entries)
        internal_rm_sync_opts(path, opts)
      }
    }
  })
}

///|
pub fn createReadStream(path : String) -> @stream.Readable {
  internal_create_read_stream(path)
}

///|
pub fn createWriteStream(path : String) -> @stream.Writable {
  internal_create_write_stream(path)
}

///| Additional File Operations

///|
/// Internal: chmodSync via #module
#module("node:fs")
extern "js" fn internal_chmod_sync(path : String, mode : Int) -> Unit = "chmodSync"

///|
/// Change file permissions synchronously
#alias(chmod_sync)
pub fn chmodSync(path : String, mode : Int) -> Unit raise @core.ThrowError {
  @core.throwable(fn() { internal_chmod_sync(path, mode) })
}

///|
/// Internal: chownSync via #module
#module("node:fs")
extern "js" fn internal_chown_sync(path : String, uid : Int, gid : Int) -> Unit = "chownSync"

///|
/// Change file owner synchronously
#alias(chown_sync)
pub fn chownSync(
  path : String,
  uid : Int,
  gid : Int,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() { internal_chown_sync(path, uid, gid) })
}

///|
/// Internal: symlinkSync via #module
#module("node:fs")
extern "js" fn internal_symlink_sync(target : String, path : String) -> Unit = "symlinkSync"

///|
/// Internal: symlinkSync with type via #module
#module("node:fs")
extern "js" fn internal_symlink_sync_typed(
  target : String,
  path : String,
  type_ : String,
) -> Unit = "symlinkSync"

///|
/// Create symbolic link synchronously
#alias(symlink_sync)
pub fn symlinkSync(
  target : String,
  path : String,
  type_? : String,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    match type_ {
      Some(t) => internal_symlink_sync_typed(target, path, t)
      None => internal_symlink_sync(target, path)
    }
  })
}

///|
/// Read symbolic link synchronously
#alias(readlink_sync)
pub fn readlinkSync(path : String) -> String raise @core.ThrowError {
  @core.throwable(fn() { internal_readlink_sync(path) })
}

///|
/// Get real path synchronously
#alias(realpath_sync)
pub fn realpathSync(path : String) -> String raise @core.ThrowError {
  @core.throwable(fn() { internal_realpath_sync(path) })
}

///|
/// Internal: truncateSync via #module
#module("node:fs")
extern "js" fn internal_truncate_sync(path : String) -> Unit = "truncateSync"

///|
/// Internal: truncateSync with length via #module
#module("node:fs")
extern "js" fn internal_truncate_sync_len(path : String, len : Int) -> Unit = "truncateSync"

///|
/// Truncate file synchronously
#alias(truncate_sync)
pub fn truncateSync(path : String, len? : Int) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    match len {
      Some(l) => internal_truncate_sync_len(path, l)
      None => internal_truncate_sync(path)
    }
  })
}

///|
/// Internal: rmdirSync via #module
#module("node:fs")
extern "js" fn internal_rmdir_sync(path : String) -> Unit = "rmdirSync"

///|
/// Internal: rmdirSync with options via #module
#module("node:fs")
extern "js" fn internal_rmdir_sync_opts(
  path : String,
  opts : @core.Any,
) -> Unit = "rmdirSync"

///|
/// Remove directory synchronously
#alias(rmdir_sync)
pub fn rmdirSync(
  path : String,
  recursive? : Bool,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    match recursive {
      Some(r) => {
        let opts = @core.from_entries([("recursive", @core.any(r))])
        internal_rmdir_sync_opts(path, opts)
      }
      None => internal_rmdir_sync(path)
    }
  })
}

///|
/// Internal: accessSync via #module
#module("node:fs")
extern "js" fn internal_access_sync(path : String) -> Unit = "accessSync"

///|
/// Internal: accessSync with mode via #module
#module("node:fs")
extern "js" fn internal_access_sync_mode(path : String, mode : Int) -> Unit = "accessSync"

///|
/// Check file access synchronously
#alias(access_sync)
pub fn accessSync(path : String, mode? : Int) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    match mode {
      Some(m) => internal_access_sync_mode(path, m)
      None => internal_access_sync(path)
    }
  })
}

///|
/// Internal: cpSync via #module
#module("node:fs")
extern "js" fn internal_cp_sync(src : String, dest : String) -> Unit = "cpSync"

///|
/// Internal: cpSync with options via #module
#module("node:fs")
extern "js" fn internal_cp_sync_opts(
  src : String,
  dest : String,
  opts : @core.Any,
) -> Unit = "cpSync"

///|
/// Copy file or directory synchronously
#alias(cp_sync)
pub fn cpSync(
  src : String,
  dest : String,
  recursive? : Bool,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    match recursive {
      Some(r) => {
        let opts = @core.from_entries([("recursive", @core.any(r))])
        internal_cp_sync_opts(src, dest, opts)
      }
      None => internal_cp_sync(src, dest)
    }
  })
}

///|
/// Internal: openSync via #module
#module("node:fs")
extern "js" fn internal_open_sync(path : String, flags : String) -> Int = "openSync"

///|
/// Internal: openSync with mode via #module
#module("node:fs")
extern "js" fn internal_open_sync_mode(
  path : String,
  flags : String,
  mode : Int,
) -> Int = "openSync"

///|
/// Open file descriptor synchronously
#alias(open_sync)
pub fn openSync(
  path : String,
  flags : String,
  mode? : Int,
) -> Int raise @core.ThrowError {
  @core.throwable(fn() {
    match mode {
      Some(m) => internal_open_sync_mode(path, flags, m)
      None => internal_open_sync(path, flags)
    }
  })
}

///|
/// Close file descriptor synchronously
#alias(close_sync)
pub fn closeSync(fd : Int) -> Unit raise @core.ThrowError {
  @core.throwable(fn() { internal_close_sync(fd) })
}

///|
/// Internal: readSync via #module
#module("node:fs")
extern "js" fn internal_read_sync(
  fd : Int,
  buffer : @buffer.Buffer,
  offset : Int,
  length : Int,
) -> Int = "readSync"

///|
/// Internal: readSync with position via #module
#module("node:fs")
extern "js" fn internal_read_sync_pos(
  fd : Int,
  buffer : @buffer.Buffer,
  offset : Int,
  length : Int,
  position : Int,
) -> Int = "readSync"

///|
/// Read from file descriptor synchronously
#alias(read_sync)
pub fn readSync(
  fd : Int,
  buffer : @buffer.Buffer,
  offset : Int,
  length : Int,
  position : Int?,
) -> Int raise @core.ThrowError {
  @core.throwable(fn() {
    match position {
      Some(pos) => internal_read_sync_pos(fd, buffer, offset, length, pos)
      None => internal_read_sync(fd, buffer, offset, length)
    }
  })
}

///|
/// Internal: writeSync via #module
#module("node:fs")
extern "js" fn internal_write_sync(
  fd : Int,
  buffer : @buffer.Buffer,
  offset : Int,
  length : Int,
) -> Int = "writeSync"

///|
/// Internal: writeSync with position via #module
#module("node:fs")
extern "js" fn internal_write_sync_pos(
  fd : Int,
  buffer : @buffer.Buffer,
  offset : Int,
  length : Int,
  position : Int,
) -> Int = "writeSync"

///|
/// Write to file descriptor synchronously
#alias(write_sync)
pub fn writeSync(
  fd : Int,
  buffer : @buffer.Buffer,
  offset : Int,
  length : Int,
  position : Int?,
) -> Int raise @core.ThrowError {
  @core.throwable(fn() {
    match position {
      Some(pos) => internal_write_sync_pos(fd, buffer, offset, length, pos)
      None => internal_write_sync(fd, buffer, offset, length)
    }
  })
}

///| File System Constants

///|
/// File access constants
pub fn fs_F_OK() -> Int {
  0
}

///|
pub fn fs_R_OK() -> Int {
  4
}

///|
pub fn fs_W_OK() -> Int {
  2
}

///|
pub fn fs_X_OK() -> Int {
  1
}
