// https://nodejs.org/api/fs.html
// Synchronous File System API

///|
/// Get fs module
extern "js" fn fs_module() -> @core.Any =
  #| () => require("node:fs")

///| File Reading

///|
/// Read file synchronously as Buffer
#alias(readFileSync)
pub fn read_file_sync(path : String) -> @buffer.Buffer raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("readFileSync", [@core.any(path)]).cast()
  })
}

///|
/// Read file synchronously as string with encoding
pub fn read_file_sync_string(
  path : String,
  encoding : String,
) -> String raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("readFileSync", [@core.any(path), @core.any(encoding)]).cast()
  })
}

///|
/// Read file synchronously as string with encoding
/// JS: fs.readFileSync(path, encoding)
pub fn read_file_as_string(
  path : String,
  encoding? : String = "utf8",
) -> String raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("readFileSync", [@core.any(path), @core.any(encoding)]).cast()
  })
}

///|
/// Read file synchronously as Buffer
/// JS: fs.readFileSync(path)
pub fn read_file_as_buffer(
  path : String,
) -> @buffer.Buffer raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("readFileSync", [@core.any(path)]).cast()
  })
}

///| File Writing

///|
/// Write file synchronously
#alias(write_file_sync)
pub fn writeFileSync(
  path : String,
  data : @core.Any,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("writeFileSync", [@core.any(path), data]) |> ignore
  })
}

///|
/// Append to file synchronously
#alias(appendFileSync)
pub fn append_file_sync(
  path : String,
  data : @core.Any,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("appendFileSync", [@core.any(path), data]) |> ignore
  })
}

///| File/Directory Operations

///|
/// Check if path exists
#alias(exists_sync)
pub fn existsSync(path : String) -> Bool {
  let fs : @core.Any = fs_module() |> @core.any
  fs._call("existsSync", [@core.any(path)]).cast()
}

///|
/// Get file statistics
#alias(stat_sync)
pub fn statSync(path : String) -> Stat raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("statSync", [@core.any(path)]).cast()
  })
}

///|
/// Create directory synchronously
#alias(mkdir_sync)
pub fn mkdirSync(path : String, recursive? : Bool) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    match recursive {
      Some(r) => {
        let opts : @core.Any = @core.from_entries([("recursive", @core.any(r))])
        fs._call("mkdirSync", [@core.any(path), opts]) |> ignore
      }
      None => fs._call("mkdirSync", [@core.any(path)]) |> ignore
    }
  })
}

///|
/// Delete file synchronously
#alias(unlink_sync)
pub fn unlinkSync(path : String) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("unlinkSync", [@core.any(path)]) |> ignore
  })
}

///|
/// Rename/move file or directory synchronously
#alias(rename_sync)
pub fn renameSync(
  old_path : String,
  new_path : String,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("renameSync", [@core.any(old_path), @core.any(new_path)]) |> ignore
  })
}

///|
/// Copy file synchronously
// #alias(copyFileSync)
pub fn copyFileSync(src : String, dest : String) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("copyFileSync", [@core.any(src), @core.any(dest)]) |> ignore
  })
}

///|
/// Read directory contents synchronously
///
/// Note: The returned array is a snapshot and should be treated as immutable.
#alias(readdir_sync)
pub fn readdirSync(path : String) -> Array[String] raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("readdirSync", [@core.any(path)]).cast()
  })
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
    let fs : @core.Any = fs_module() |> @core.any
    match (recursive, force) {
      (None, None) => fs._call("rmSync", [@core.any(path)]) |> ignore
      _ => {
        let entries : Array[(String, @core.Any)] = []
        if recursive is Some(v) {
          entries.push(("recursive", @core.any(v)))
        }
        if force is Some(v) {
          entries.push(("force", @core.any(v)))
        }
        let opts = @core.from_entries(entries)
        fs._call("rmSync", [@core.any(path), opts]) |> ignore
      }
    }
  })
}

///|
pub fn createReadStream(path : String) -> @stream.Readable {
  let fs : @core.Any = fs_module() |> @core.any
  fs._call("createReadStream", [@core.any(path)]).cast()
}

///|
pub fn createWriteStream(path : String) -> @stream.Writable {
  let fs : @core.Any = fs_module() |> @core.any
  fs._call("createWriteStream", [@core.any(path)]).cast()
}

///| Additional File Operations

///|
/// Change file permissions synchronously
#alias(chmod_sync)
pub fn chmodSync(path : String, mode : Int) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("chmodSync", [@core.any(path), @core.any(mode)]) |> ignore
  })
}

///|
/// Change file owner synchronously
#alias(chown_sync)
pub fn chownSync(
  path : String,
  uid : Int,
  gid : Int,
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("chownSync", [@core.any(path), @core.any(uid), @core.any(gid)])
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
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    match type_ {
      Some(t) =>
        fs._call("symlinkSync", [
          @core.any(target),
          @core.any(path),
          @core.any(t),
        ])
        |> ignore
      None =>
        fs._call("symlinkSync", [@core.any(target), @core.any(path)]) |> ignore
    }
  })
}

///|
/// Read symbolic link synchronously
#alias(readlink_sync)
pub fn readlinkSync(path : String) -> String raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("readlinkSync", [@core.any(path)]).cast()
  })
}

///|
/// Get real path synchronously
#alias(realpath_sync)
pub fn realpathSync(path : String) -> String raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("realpathSync", [@core.any(path)]).cast()
  })
}

///|
/// Truncate file synchronously
#alias(truncate_sync)
pub fn truncateSync(path : String, len? : Int) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    match len {
      Some(l) =>
        fs._call("truncateSync", [@core.any(path), @core.any(l)]) |> ignore
      None => fs._call("truncateSync", [@core.any(path)]) |> ignore
    }
  })
}

///|
/// Remove directory synchronously
#alias(rmdir_sync)
pub fn rmdirSync(path : String, recursive? : Bool) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    match recursive {
      Some(r) => {
        let opts : @core.Any = @core.from_entries([("recursive", @core.any(r))])
        fs._call("rmdirSync", [@core.any(path), opts]) |> ignore
      }
      None => fs._call("rmdirSync", [@core.any(path)]) |> ignore
    }
  })
}

///|
/// Check file access synchronously
#alias(access_sync)
pub fn accessSync(path : String, mode? : Int) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    match mode {
      Some(m) =>
        fs._call("accessSync", [@core.any(path), @core.any(m)]) |> ignore
      None => fs._call("accessSync", [@core.any(path)]) |> ignore
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
) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    match recursive {
      Some(r) => {
        let opts : @core.Any = @core.from_entries([("recursive", @core.any(r))])
        fs._call("cpSync", [@core.any(src), @core.any(dest), opts]) |> ignore
      }
      None => fs._call("cpSync", [@core.any(src), @core.any(dest)]) |> ignore
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
) -> Int raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    match mode {
      Some(m) =>
        fs
        ._call("openSync", [@core.any(path), @core.any(flags), @core.any(m)])
        .cast()
      None => fs._call("openSync", [@core.any(path), @core.any(flags)]).cast()
    }
  })
}

///|
/// Close file descriptor synchronously
#alias(close_sync)
pub fn closeSync(fd : Int) -> Unit raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    fs._call("closeSync", [@core.any(fd)]) |> ignore
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
) -> Int raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    match position {
      Some(pos) =>
        fs
        ._call("readSync", [
          @core.any(fd),
          @core.any(buffer),
          @core.any(offset),
          @core.any(length),
          @core.any(pos),
        ])
        .cast()
      None =>
        fs
        ._call("readSync", [
          @core.any(fd),
          @core.any(buffer),
          @core.any(offset),
          @core.any(length),
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
) -> Int raise @core.ThrowError {
  @core.throwable(fn() {
    let fs : @core.Any = fs_module() |> @core.any
    match position {
      Some(pos) =>
        fs
        ._call("writeSync", [
          @core.any(fd),
          @core.any(buffer),
          @core.any(offset),
          @core.any(length),
          @core.any(pos),
        ])
        .cast()
      None =>
        fs
        ._call("writeSync", [
          @core.any(fd),
          @core.any(buffer),
          @core.any(offset),
          @core.any(length),
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
