///|
#external
pub type Stat

///|
pub impl @js.JsImpl for Stat

///|
pub fn Stat::isFile(self : Self) -> Bool {
  self.call0("isFile") |> @js.identity
}

///|
pub fn Stat::isDirectory(self : Self) -> Bool {
  self.call0("isDirectory") |> @js.identity
}

///|
pub fn Stat::size(self : Self) -> Int {
  self.get("size").cast()
}

///|
pub fn Stat::mtime_ms(self : Self) -> Float {
  let mtime = self.get("mtime")
  @js.identity(mtime.get("getTime").call("call", [mtime]))
}

///|
/// node:fs/promises.stat
pub fn stat(path : String) -> @js.Promise[Stat] {
  let fs = @node.require("node:fs/promises")
  @js.identity(fs.call("stat", [path]))
}

///|
/// node:fs/promises.mkdir
pub fn mkdir(path : String, recursive? : Bool) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  @js.identity(
    fs.call("mkdir", [
      path,
      @js.from_entries_option_cast([("recursive", recursive)]),
    ]),
  )
}

///|
/// node:fs/promises.glob
pub fn glob(
  path : String,
  cwd? : String,
  exclude? : Array[String],
  exclude_fn? : (String) -> Bool,
) -> @js.AsyncIterator[String] {
  let fs = @node.require("node:fs/promises")
  @js.identity(
    fs.call("glob", [
      path,
      @js.from_entries_option([
        ("cwd", cwd.map(x => x)),
        ("exclude", exclude.map(fn(x) { x |> @js.from_array })),
        ("exclude", exclude_fn.map(fn(x) { x |> @js.from_fn1 })),
      ]),
    ]),
  )
}

///|
#external
pub type Dirent

///|
pub impl @js.JsImpl for Dirent

///|
#alias(is_file)
pub fn Dirent::isFile(self : Self) -> Bool {
  self.call0("isFile") |> @js.identity
}

///|
#alias(is_directory)
pub fn Dirent::isDirectory(self : Self) -> Bool {
  self.call0("isDirectory") |> @js.identity
}

///|
pub fn Dirent::name(self : Self) -> String {
  self.get("name").cast()
}

///|
pub fn glob_with_filetype(
  path : String,
  cwd? : String,
  exclude? : Array[String],
  exclude_fn? : (String) -> Bool,
) -> @js.AsyncIterator[Dirent] {
  let fs = @node.require("node:fs/promises")
  @js.identity(
    fs.call("glob", [
      path,
      @js.from_entries_option([
        ("withFileTypes", Some(true)),
        ("cwd", cwd.map(x => x)),
        ("exclude", exclude.map(fn(x) { x |> @js.from_array })),
        ("exclude", exclude_fn.map(fn(x) { x |> @js.from_fn1 })),
      ]),
    ]),
  )
}

///|
/// WIP
#external
pub type FileHandle

///|
pub fn open(path : String) -> @js.Promise[FileHandle] {
  let fs = @node.require("node:fs/promises")
  @js.identity(fs.call("open", [path]))
}

///|
#alias(read_file)
pub fn readFile(
  path : String,
  encoding? : String = "utf-8",
) -> @js.Promise[String] {
  let fs = @node.require("node:fs/promises")
  fs.call2("readFile", path, encoding) |> @js.identity
}

///|
/// Read file asynchronously as string with encoding
/// JS: fs.promises.readFile(path, encoding)
pub fn read_file_as_string(
  path : String,
  encoding? : String = "utf8",
) -> @js.Promise[String] {
  let fs = @node.require("node:fs/promises")
  fs.call2("readFile", path, encoding) |> @js.identity
}

///|
/// Read file asynchronously as Buffer
/// JS: fs.promises.readFile(path)
pub fn read_file_as_buffer(path : String) -> @js.Promise[@buffer.Buffer] {
  let fs = @node.require("node:fs/promises")
  @js.identity(fs.call("readFile", [path]))
}

///|
#alias(write_file)
pub fn writeFile(
  path : String,
  content : String,
  encoding? : String = "utf-8",
  mode? : Int = 0o666,
  flag? : String = "w",
  flush? : Bool = false,
  signal? : @js.AbortSignal,
) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  @js.identity(
    fs.call("writeFile", [
      path,
      content,
      @js.from_entries_option([
        ("encoding", Some(encoding)),
        ("mode", Some(mode)),
        ("flag", Some(flag)),
        ("flush", Some(flush)),
        ("signal", signal.map(x => x)),
      ]),
    ]),
  )
}

///|
pub fn rename(path : String, dest : String) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  fs.call2("rename", path, dest) |> @js.identity
}

///|
pub fn rm(path : String, recursive? : Bool, force? : Bool) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  @js.identity(
    fs.call("rm", [
      path,
      @js.from_entries_option_cast([("recursive", recursive), ("force", force)]),
    ]),
  )
}

///|
pub fn cp(path : String, dest : String, recursive? : Bool) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  @js.identity(
    fs.call("cp", [
      path,
      dest,
      @js.from_entries_option_cast([("recursive", recursive)]),
    ]),
  )
}

///| Additional File Operations

///|
/// Change file permissions
pub fn chmod(path : String, mode : Int) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  fs.call2("chmod", path, mode) |> @js.identity
}

///|
/// Change file owner
pub fn chown(path : String, uid : Int, gid : Int) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  @js.identity(fs.call("chown", [path, uid, gid]))
}

///|
/// Create symbolic link
pub fn symlink(
  target : String,
  path : String,
  type_? : String,
) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  match type_ {
    Some(t) => @js.identity(fs.call("symlink", [target, path, t]))
    None => fs.call2("symlink", target, path) |> @js.identity
  }
}

///|
/// Read symbolic link
pub fn readlink(path : String) -> @js.Promise[String] {
  let fs = @node.require("node:fs/promises")
  @js.identity(fs.call("readlink", [path]))
}

///|
/// Get real path
pub fn realpath(path : String) -> @js.Promise[String] {
  let fs = @node.require("node:fs/promises")
  @js.identity(fs.call("realpath", [path]))
}

///|
/// Truncate file
pub fn truncate(path : String, len? : Int) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  match len {
    Some(l) => fs.call2("truncate", path, l) |> @js.identity
    None => @js.identity(fs.call("truncate", [path]))
  }
}

///|
/// Remove directory
pub fn rmdir(path : String, recursive? : Bool) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  @js.identity(
    fs.call("rmdir", [
      path,
      @js.from_entries_option_cast([("recursive", recursive)]),
    ]),
  )
}

///|
/// Check file access
pub fn access(path : String, mode? : Int) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  match mode {
    Some(m) => fs.call2("access", path, m) |> @js.identity
    None => @js.identity(fs.call("access", [path]))
  }
}

///|
/// Append to file
pub fn appendFile(
  path : String,
  data : String,
  encoding? : String,
) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  match encoding {
    Some(enc) =>
      @js.identity(
        fs.call("appendFile", [
          path,
          data,
          @js.from_entries_option_cast([("encoding", Some(enc))]),
        ]),
      )
    None => fs.call2("appendFile", path, data) |> @js.identity
  }
}

///|
/// Copy file
pub fn copyFile(src : String, dest : String) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  fs.call2("copyFile", src, dest) |> @js.identity
}

///|
/// Read directory contents
pub fn readdir(path : String) -> @js.Promise[Array[String]] {
  let fs = @node.require("node:fs/promises")
  @js.identity(fs.call("readdir", [path]))
}

///|
/// Unlink (delete) file
pub fn unlink(path : String) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  @js.identity(fs.call("unlink", [path]))
}
