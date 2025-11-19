// https://nodejs.org/api/fs.html
// Synchronous File System API

///|
/// Get fs module
fn fs_module() -> Js {
  @node.require("node:fs")
}

///| File Reading

///|
/// Read file synchronously as Buffer
#alias(readFileSync)
pub fn read_file_sync(path : String) -> Buffer {
  let fs = fs_module()
  fs.call("readFileSync", [path]) |> unsafe_cast
}

///|
/// Read file synchronously as string with encoding
pub fn read_file_sync_string(path : String, encoding : String) -> String {
  let fs = fs_module()
  fs.call("readFileSync", [path, encoding]) |> unsafe_cast
}

///| File Writing

///|
/// Write file synchronously
#alias(write_file_sync)
pub fn writeFileSync(path : String, data : &JsImpl) -> Unit {
  let fs = fs_module()
  fs.call("writeFileSync", [path, data.to_js()]) |> ignore
}

///|
/// Append to file synchronously
#alias(appendFileSync)
pub fn append_file_sync(path : String, data : &JsImpl) -> Unit {
  let fs = fs_module()
  fs.call("appendFileSync", [path, data.to_js()]) |> ignore
}

///| File/Directory Operations

///|
/// Check if path exists
#alias(exists_sync)
pub fn existsSync(path : String) -> Bool {
  let fs = fs_module()
  fs.call("existsSync", [path]) |> unsafe_cast
}

///|
/// Get file statistics
#alias(stat_sync)
pub fn statSync(path : String) -> Js {
  let fs = fs_module()
  fs.call("statSync", [path])
}

///|
/// Create directory synchronously
#alias(mkdir_sync)
pub fn mkdirSync(path : String, recursive? : Bool) -> Unit {
  let fs = fs_module()
  match recursive {
    Some(r) => {
      let opts = @js.from_map({ "recursive": r |> unsafe_cast })
      fs.call("mkdirSync", [path, opts]) |> ignore
    }
    None => fs.call("mkdirSync", [path]) |> ignore
  }
}

///|
/// Delete file synchronously
#alias(unlink_sync)
pub fn unlinkSync(path : String) -> Unit {
  let fs = fs_module()
  fs.call("unlinkSync", [path]) |> ignore
}

///|
/// Rename/move file or directory synchronously
#alias(rename_sync)
pub fn renameSync(old_path : String, new_path : String) -> Unit {
  let fs = fs_module()
  fs.call("renameSync", [old_path, new_path]) |> ignore
}

///|
/// Copy file synchronously
// #alias(copyFileSync)
pub fn copyFileSync(src : String, dest : String) -> Unit {
  let fs = fs_module()
  fs.call("copyFileSync", [src, dest]) |> ignore
}

///|
/// Read directory contents synchronously
#alias(readdir_sync)
pub fn readdirSync(path : String) -> Array[String] {
  let fs = fs_module()
  fs.call("readdirSync", [path]) |> unsafe_cast
}

///|
/// Remove file or directory synchronously
#alias(rm_sync)
pub fn rmSync(path : String, recursive? : Bool, force? : Bool) -> Unit {
  let fs = fs_module()
  match (recursive, force) {
    (Some(r), Some(f)) => {
      let options = @js.Object::new()
      options.set("recursive", r)
      options.set("force", f)
      fs.call("rmSync", [path, options]) |> ignore
    }
    (Some(r), None) => {
      let options = @js.Object::new()
      options.set("recursive", r)
      fs.call("rmSync", [path, options]) |> ignore
    }
    (None, Some(f)) => {
      let options = @js.Object::new()
      options.set("force", f)
      fs.call("rmSync", [path, options]) |> ignore
    }
    (None, None) => fs.call("rmSync", [path]) |> ignore
  }
}

///|
pub fn createReadStream(path : String) -> @stream.Readable {
  let fs = fs_module()
  fs.call("createReadStream", [path]) |> unsafe_cast
}

///|
pub fn createWriteStream(path : String) -> @stream.Writable {
  let fs = fs_module()
  fs.call("createWriteStream", [path]) |> unsafe_cast
}

///| Additional File Operations

///|
/// Change file permissions synchronously
#alias(chmod_sync)
pub fn chmodSync(path : String, mode : Int) -> Unit {
  let fs = fs_module()
  fs.call("chmodSync", [path, mode]) |> ignore
}

///|
/// Change file owner synchronously
#alias(chown_sync)
pub fn chownSync(path : String, uid : Int, gid : Int) -> Unit {
  let fs = fs_module()
  fs.call("chownSync", [path, uid, gid]) |> ignore
}

///|
/// Create symbolic link synchronously
#alias(symlink_sync)
pub fn symlinkSync(target : String, path : String, type_? : String) -> Unit {
  let fs = fs_module()
  match type_ {
    Some(t) => fs.call("symlinkSync", [target, path, t]) |> ignore
    None => fs.call("symlinkSync", [target, path]) |> ignore
  }
}

///|
/// Read symbolic link synchronously
#alias(readlink_sync)
pub fn readlinkSync(path : String) -> String {
  let fs = fs_module()
  fs.call("readlinkSync", [path]) |> unsafe_cast
}

///|
/// Get real path synchronously
#alias(realpath_sync)
pub fn realpathSync(path : String) -> String {
  let fs = fs_module()
  fs.call("realpathSync", [path]) |> unsafe_cast
}

///|
/// Truncate file synchronously
#alias(truncate_sync)
pub fn truncateSync(path : String, len? : Int) -> Unit {
  let fs = fs_module()
  match len {
    Some(l) => fs.call("truncateSync", [path, l]) |> ignore
    None => fs.call("truncateSync", [path]) |> ignore
  }
}

///|
/// Remove directory synchronously
#alias(rmdir_sync)
pub fn rmdirSync(path : String, recursive? : Bool) -> Unit {
  let fs = fs_module()
  match recursive {
    Some(r) => {
      let opts = @js.from_map({ "recursive": r |> unsafe_cast })
      fs.call("rmdirSync", [path, opts]) |> ignore
    }
    None => fs.call("rmdirSync", [path]) |> ignore
  }
}

///|
/// Check file access synchronously
#alias(access_sync)
pub fn accessSync(path : String, mode? : Int) -> Unit {
  let fs = fs_module()
  match mode {
    Some(m) => fs.call("accessSync", [path, m]) |> ignore
    None => fs.call("accessSync", [path]) |> ignore
  }
}

///|
/// Copy file or directory synchronously
#alias(cp_sync)
pub fn cpSync(src : String, dest : String, recursive? : Bool) -> Unit {
  let fs = fs_module()
  match recursive {
    Some(r) => {
      let opts = @js.from_map({ "recursive": r |> unsafe_cast })
      fs.call("cpSync", [src, dest, opts]) |> ignore
    }
    None => fs.call("cpSync", [src, dest]) |> ignore
  }
}

///|
/// Open file descriptor synchronously
#alias(open_sync)
pub fn openSync(path : String, flags : String, mode? : Int) -> Int {
  let fs = fs_module()
  match mode {
    Some(m) => fs.call("openSync", [path, flags, m]) |> unsafe_cast
    None => fs.call("openSync", [path, flags]) |> unsafe_cast
  }
}

///|
/// Close file descriptor synchronously
#alias(close_sync)
pub fn closeSync(fd : Int) -> Unit {
  let fs = fs_module()
  fs.call("closeSync", [fd]) |> ignore
}

///|
/// Read from file descriptor synchronously
#alias(read_sync)
pub fn readSync(
  fd : Int,
  buffer : Buffer,
  offset : Int,
  length : Int,
  position : Int?,
) -> Int {
  let fs = fs_module()
  match position {
    Some(pos) =>
      fs.call("readSync", [fd, buffer, offset, length, pos]) |> unsafe_cast
    None => fs.call("readSync", [fd, buffer, offset, length]) |> unsafe_cast
  }
}

///|
/// Write to file descriptor synchronously
#alias(write_sync)
pub fn writeSync(
  fd : Int,
  buffer : Buffer,
  offset : Int,
  length : Int,
  position : Int?,
) -> Int {
  let fs = fs_module()
  match position {
    Some(pos) =>
      fs.call("writeSync", [fd, buffer, offset, length, pos]) |> unsafe_cast
    None => fs.call("writeSync", [fd, buffer, offset, length]) |> unsafe_cast
  }
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
