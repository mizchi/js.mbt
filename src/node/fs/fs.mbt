// https://nodejs.org/api/fs.html
// Synchronous File System API

///|
/// Get fs module
extern "js" fn fs_module() -> @nostd.Any =
  #| () => require("node:fs")

///| File Reading

///|
/// Read file synchronously as Buffer
#alias(readFileSync)
pub fn read_file_sync(path : String) -> @buffer.Buffer raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("readFileSync", [@nostd.any(path)]).cast()
  })
}

///|
/// Read file synchronously as string with encoding
pub fn read_file_sync_string(
  path : String,
  encoding : String,
) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("readFileSync", [@nostd.any(path), @nostd.any(encoding)]).cast()
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
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("readFileSync", [@nostd.any(path), @nostd.any(encoding)]).cast()
  })
}

///|
/// Read file synchronously as Buffer
/// JS: fs.readFileSync(path)
pub fn read_file_as_buffer(
  path : String,
) -> @buffer.Buffer raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("readFileSync", [@nostd.any(path)]).cast()
  })
}

///| File Writing

///|
/// Write file synchronously
#alias(write_file_sync)
pub fn writeFileSync(
  path : String,
  data : @nostd.Any,
) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("writeFileSync", [@nostd.any(path), data]) |> ignore
  })
}

///|
/// Append to file synchronously
#alias(appendFileSync)
pub fn append_file_sync(
  path : String,
  data : @nostd.Any,
) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("appendFileSync", [@nostd.any(path), data]) |> ignore
  })
}

///| File/Directory Operations

///|
/// Check if path exists
#alias(exists_sync)
pub fn existsSync(path : String) -> Bool {
  let fs : @nostd.Any = fs_module() |> @nostd.any
  fs._call("existsSync", [@nostd.any(path)]).cast()
}

///|
/// Get file statistics
#alias(stat_sync)
pub fn statSync(path : String) -> Stat raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("statSync", [@nostd.any(path)]).cast()
  })
}

///|
/// Create directory synchronously
#alias(mkdir_sync)
pub fn mkdirSync(path : String, recursive? : Bool) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match recursive {
      Some(r) => {
        let opts : @nostd.Any = @nostd.from_entries([
          ("recursive", @nostd.any(r)),
        ])
        fs._call("mkdirSync", [@nostd.any(path), opts]) |> ignore
      }
      None => fs._call("mkdirSync", [@nostd.any(path)]) |> ignore
    }
  })
}

///|
/// Delete file synchronously
#alias(unlink_sync)
pub fn unlinkSync(path : String) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("unlinkSync", [@nostd.any(path)]) |> ignore
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
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("renameSync", [@nostd.any(old_path), @nostd.any(new_path)])
    |> ignore
  })
}

///|
/// Copy file synchronously
// #alias(copyFileSync)
pub fn copyFileSync(src : String, dest : String) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("copyFileSync", [@nostd.any(src), @nostd.any(dest)]) |> ignore
  })
}

///|
/// Read directory contents synchronously
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(readdir_sync)
pub fn readdirSync(path : String) -> Array[String] raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("readdirSync", [@nostd.any(path)]).cast()
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
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match (recursive, force) {
      (None, None) => fs._call("rmSync", [@nostd.any(path)]) |> ignore
      _ => {
        let opts : @nostd.Any = @mbtconv.from_option_map({
          "recursive": recursive.map(fn(x) { @nostd.any(x) }),
          "force": force.map(fn(x) { @nostd.any(x) }),
        }) |> @nostd.any
        fs._call("rmSync", [@nostd.any(path), opts]) |> ignore
      }
    }
  })
}

///|
pub fn createReadStream(path : String) -> @stream.Readable {
  let fs : @nostd.Any = fs_module() |> @nostd.any
  fs._call("createReadStream", [@nostd.any(path)]).cast()
}

///|
pub fn createWriteStream(path : String) -> @stream.Writable {
  let fs : @nostd.Any = fs_module() |> @nostd.any
  fs._call("createWriteStream", [@nostd.any(path)]).cast()
}

///| Additional File Operations

///|
/// Change file permissions synchronously
#alias(chmod_sync)
pub fn chmodSync(path : String, mode : Int) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("chmodSync", [@nostd.any(path), @nostd.any(mode)]) |> ignore
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
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("chownSync", [@nostd.any(path), @nostd.any(uid), @nostd.any(gid)])
    |> ignore
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
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match type_ {
      Some(t) =>
        fs._call("symlinkSync", [
          @nostd.any(target),
          @nostd.any(path),
          @nostd.any(t),
        ])
        |> ignore
      None =>
        fs._call("symlinkSync", [@nostd.any(target), @nostd.any(path)])
        |> ignore
    }
  })
}

///|
/// Read symbolic link synchronously
#alias(readlink_sync)
pub fn readlinkSync(path : String) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("readlinkSync", [@nostd.any(path)]).cast()
  })
}

///|
/// Get real path synchronously
#alias(realpath_sync)
pub fn realpathSync(path : String) -> String raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("realpathSync", [@nostd.any(path)]).cast()
  })
}

///|
/// Truncate file synchronously
#alias(truncate_sync)
pub fn truncateSync(path : String, len? : Int) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match len {
      Some(l) =>
        fs._call("truncateSync", [@nostd.any(path), @nostd.any(l)]) |> ignore
      None => fs._call("truncateSync", [@nostd.any(path)]) |> ignore
    }
  })
}

///|
/// Remove directory synchronously
#alias(rmdir_sync)
pub fn rmdirSync(path : String, recursive? : Bool) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match recursive {
      Some(r) => {
        let opts : @nostd.Any = @nostd.from_entries([
          ("recursive", @nostd.any(r)),
        ])
        fs._call("rmdirSync", [@nostd.any(path), opts]) |> ignore
      }
      None => fs._call("rmdirSync", [@nostd.any(path)]) |> ignore
    }
  })
}

///|
/// Check file access synchronously
#alias(access_sync)
pub fn accessSync(path : String, mode? : Int) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match mode {
      Some(m) =>
        fs._call("accessSync", [@nostd.any(path), @nostd.any(m)]) |> ignore
      None => fs._call("accessSync", [@nostd.any(path)]) |> ignore
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
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match recursive {
      Some(r) => {
        let opts : @nostd.Any = @nostd.from_entries([
          ("recursive", @nostd.any(r)),
        ])
        fs._call("cpSync", [@nostd.any(src), @nostd.any(dest), opts]) |> ignore
      }
      None =>
        fs._call("cpSync", [@nostd.any(src), @nostd.any(dest)]) |> ignore
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
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match mode {
      Some(m) =>
        fs
        ._call("openSync", [
          @nostd.any(path),
          @nostd.any(flags),
          @nostd.any(m),
        ])
        .cast()
      None =>
        fs._call("openSync", [@nostd.any(path), @nostd.any(flags)]).cast()
    }
  })
}

///|
/// Close file descriptor synchronously
#alias(close_sync)
pub fn closeSync(fd : Int) -> Unit raise @js.ThrowError {
  @js.throwable(fn() {
    let fs : @nostd.Any = fs_module() |> @nostd.any
    fs._call("closeSync", [@nostd.any(fd)]) |> ignore
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
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match position {
      Some(pos) =>
        fs
        ._call("readSync", [
          @nostd.any(fd),
          @nostd.any(buffer),
          @nostd.any(offset),
          @nostd.any(length),
          @nostd.any(pos),
        ])
        .cast()
      None =>
        fs
        ._call("readSync", [
          @nostd.any(fd),
          @nostd.any(buffer),
          @nostd.any(offset),
          @nostd.any(length),
        ])
        .cast()
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
    let fs : @nostd.Any = fs_module() |> @nostd.any
    match position {
      Some(pos) =>
        fs
        ._call("writeSync", [
          @nostd.any(fd),
          @nostd.any(buffer),
          @nostd.any(offset),
          @nostd.any(length),
          @nostd.any(pos),
        ])
        .cast()
      None =>
        fs
        ._call("writeSync", [
          @nostd.any(fd),
          @nostd.any(buffer),
          @nostd.any(offset),
          @nostd.any(length),
        ])
        .cast()
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
