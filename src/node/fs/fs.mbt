// https://nodejs.org/api/fs.html
// Synchronous File System API

///|
/// Get fs module
fn fs_module() -> @js.Any {
  @node.require("node:fs")
}

///| File Reading

///|
/// Read file synchronously as Buffer
#alias(readFileSync)
pub fn read_file_sync(path : String) -> @buffer.Buffer raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call("readFileSync", [path]).cast()
  })
}

///|
/// Read file synchronously as string with encoding
pub fn read_file_sync_string(
  path : String,
  encoding : String,
) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call2("readFileSync", path, encoding) |> @js.identity
  })
}

///|
/// Read file synchronously as string with encoding
/// JS: fs.readFileSync(path, encoding)
pub fn read_file_as_string(
  path : String,
  encoding? : String = "utf8",
) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call2("readFileSync", path, encoding) |> @js.identity
  })
}

///|
/// Read file synchronously as Buffer
/// JS: fs.readFileSync(path)
pub fn read_file_as_buffer(
  path : String,
) -> @buffer.Buffer raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call("readFileSync", [path]).cast()
  })
}

///| File Writing

///|
/// Write file synchronously
#alias(write_file_sync)
pub fn writeFileSync(
  path : String,
  data : &@js.JsImpl,
) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call2("writeFileSync", path, data.to_any()) |> ignore
  })
}

///|
/// Append to file synchronously
#alias(appendFileSync)
pub fn append_file_sync(
  path : String,
  data : &@js.JsImpl,
) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call2("appendFileSync", path, data.to_any()) |> ignore
  })
}

///| File/Directory Operations

///|
/// Check if path exists
#alias(exists_sync)
pub fn existsSync(path : String) -> Bool {
  let fs = fs_module()
  fs.call1("existsSync", path) |> @js.identity
}

///|
/// Get file statistics
#alias(stat_sync)
pub fn statSync(path : String) -> Stat raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call1("statSync", path).cast()
  })
}

///|
/// Create directory synchronously
#alias(mkdir_sync)
pub fn mkdirSync(path : String, recursive? : Bool) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match recursive {
      Some(r) => {
        let opts = @js.from_map({ "recursive": r |> @js.identity })
        fs.call2("mkdirSync", path, opts) |> ignore
      }
      None => fs.call1("mkdirSync", path) |> ignore
    }
  })
}

///|
/// Delete file synchronously
#alias(unlink_sync)
pub fn unlinkSync(path : String) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call1("unlinkSync", path) |> ignore
  })
}

///|
/// Rename/move file or directory synchronously
#alias(rename_sync)
pub fn renameSync(
  old_path : String,
  new_path : String,
) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call2("renameSync", old_path, new_path) |> ignore
  })
}

///|
/// Copy file synchronously
// #alias(copyFileSync)
pub fn copyFileSync(src : String, dest : String) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call2("copyFileSync", src, dest) |> ignore
  })
}

///|
/// Read directory contents synchronously
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(readdir_sync)
pub fn readdirSync(path : String) -> Array[String] raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call1("readdirSync", path) |> @js.identity
  })
}

///|
/// Remove file or directory synchronously
#alias(rm_sync)
pub fn rmSync(
  path : String,
  recursive? : Bool,
  force? : Bool,
) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match (recursive, force) {
      (None, None) => fs.call1("rmSync", path) |> ignore
      _ =>
        fs.call2(
          "rmSync",
          path,
          @js.from_entries_option_cast([
            ("recursive", recursive),
            ("force", force),
          ]),
        )
        |> ignore
    }
  })
}

///|
pub fn createReadStream(path : String) -> @stream.Readable {
  let fs = fs_module()
  fs.call1("createReadStream", path) |> @js.identity
}

///|
pub fn createWriteStream(path : String) -> @stream.Writable {
  let fs = fs_module()
  fs.call1("createWriteStream", path) |> @js.identity
}

///| Additional File Operations

///|
/// Change file permissions synchronously
#alias(chmod_sync)
pub fn chmodSync(path : String, mode : Int) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call2("chmodSync", path, mode) |> ignore
  })
}

///|
/// Change file owner synchronously
#alias(chown_sync)
pub fn chownSync(
  path : String,
  uid : Int,
  gid : Int,
) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call("chownSync", [path, uid, gid]) |> ignore
  })
}

///|
/// Create symbolic link synchronously
#alias(symlink_sync)
pub fn symlinkSync(
  target : String,
  path : String,
  type_? : String,
) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match type_ {
      Some(t) => fs.call("symlinkSync", [target, path, t]) |> ignore
      None => fs.call2("symlinkSync", target, path) |> ignore
    }
  })
}

///|
/// Read symbolic link synchronously
#alias(readlink_sync)
pub fn readlinkSync(path : String) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call1("readlinkSync", path) |> @js.identity
  })
}

///|
/// Get real path synchronously
#alias(realpath_sync)
pub fn realpathSync(path : String) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call1("realpathSync", path) |> @js.identity
  })
}

///|
/// Truncate file synchronously
#alias(truncate_sync)
pub fn truncateSync(path : String, len? : Int) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match len {
      Some(l) => fs.call2("truncateSync", path, l) |> ignore
      None => fs.call1("truncateSync", path) |> ignore
    }
  })
}

///|
/// Remove directory synchronously
#alias(rmdir_sync)
pub fn rmdirSync(path : String, recursive? : Bool) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match recursive {
      Some(r) => {
        let opts = @js.from_map({ "recursive": r |> @js.identity })
        fs.call2("rmdirSync", path, opts) |> ignore
      }
      None => fs.call1("rmdirSync", path) |> ignore
    }
  })
}

///|
/// Check file access synchronously
#alias(access_sync)
pub fn accessSync(path : String, mode? : Int) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match mode {
      Some(m) => fs.call2("accessSync", path, m) |> ignore
      None => fs.call1("accessSync", path) |> ignore
    }
  })
}

///|
/// Copy file or directory synchronously
#alias(cp_sync)
pub fn cpSync(
  src : String,
  dest : String,
  recursive? : Bool,
) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match recursive {
      Some(r) => {
        let opts = @js.from_map({ "recursive": r |> @js.identity })
        fs.call("cpSync", [src, dest, opts]) |> ignore
      }
      None => fs.call2("cpSync", src, dest) |> ignore
    }
  })
}

///|
/// Open file descriptor synchronously
#alias(open_sync)
pub fn openSync(
  path : String,
  flags : String,
  mode? : Int,
) -> Int raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match mode {
      Some(m) => fs.call("openSync", [path, flags, m]).cast()
      None => fs.call2("openSync", path, flags) |> @js.identity
    }
  })
}

///|
/// Close file descriptor synchronously
#alias(close_sync)
pub fn closeSync(fd : Int) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    fs.call1("closeSync", fd) |> ignore
  })
}

///|
/// Read from file descriptor synchronously
#alias(read_sync)
pub fn readSync(
  fd : Int,
  buffer : @buffer.Buffer,
  offset : Int,
  length : Int,
  position : Int?,
) -> Int raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match position {
      Some(pos) =>
        fs.call("readSync", [fd, buffer, offset, length, pos]) |> @js.identity
      None => fs.call("readSync", [fd, buffer, offset, length]).cast()
    }
  })
}

///|
/// Write to file descriptor synchronously
#alias(write_sync)
pub fn writeSync(
  fd : Int,
  buffer : @buffer.Buffer,
  offset : Int,
  length : Int,
  position : Int?,
) -> Int raise @js.ThrowError {
  @js.throwable(fn() {
    let fs = fs_module()
    match position {
      Some(pos) =>
        fs.call("writeSync", [fd, buffer, offset, length, pos]) |> @js.identity
      None => fs.call("writeSync", [fd, buffer, offset, length]).cast()
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
