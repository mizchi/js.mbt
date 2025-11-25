///|
#external
pub type Stat

///|
pub impl @js.JsImpl for Stat

///|
pub fn Stat::isFile(self : Self) -> Bool {
  self.call0("isFile").cast()
}

///|
pub fn Stat::isDirectory(self : Self) -> Bool {
  self.call0("isDirectory").cast()
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
      @js.from_option_map({ "recursive": recursive.map(fn(x) { @js.any(x) }) }),
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
  // exclude can be either an array of patterns or a function
  let exclude_opt : @js.Any? = match (exclude, exclude_fn) {
    (Some(arr), _) => Some(arr |> @js.from_array)
    (None, Some(f)) => Some(f |> @js.from_fn1)
    (None, None) => None
  }
  @js.identity(
    fs.call("glob", [
      path,
      @js.from_option_map({
        "cwd": cwd.map(fn(x) { @js.any(x) }),
        "exclude": exclude_opt,
      }),
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
  self.call0("isFile").cast()
}

///|
#alias(is_directory)
pub fn Dirent::isDirectory(self : Self) -> Bool {
  self.call0("isDirectory").cast()
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
  // exclude can be either an array of patterns or a function
  let exclude_opt : @js.Any? = match (exclude, exclude_fn) {
    (Some(arr), _) => Some(arr |> @js.from_array)
    (None, Some(f)) => Some(f |> @js.from_fn1)
    (None, None) => None
  }
  @js.identity(
    fs.call("glob", [
      path,
      @js.from_option_map({
        "withFileTypes": Some(@js.any(true)),
        "cwd": cwd.map(fn(x) { @js.any(x) }),
        "exclude": exclude_opt,
      }),
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
  fs.call2("readFile", path, encoding).cast()
}

///|
/// Read file asynchronously as string with encoding
/// JS: fs.promises.readFile(path, encoding)
pub fn read_file_as_string(
  path : String,
  encoding? : String = "utf8",
) -> @js.Promise[String] {
  let fs = @node.require("node:fs/promises")
  fs.call2("readFile", path, encoding).cast()
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
      @js.from_option_map({
        "encoding": Some(@js.any(encoding)),
        "mode": Some(@js.any(mode)),
        "flag": Some(@js.any(flag)),
        "flush": Some(@js.any(flush)),
        "signal": signal.map(fn(x) { x.to_any() }),
      }),
    ]),
  )
}

///|
pub fn rename(path : String, dest : String) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  fs.call2("rename", path, dest).cast()
}

///|
pub fn rm(path : String, recursive? : Bool, force? : Bool) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  @js.identity(
    fs.call("rm", [
      path,
      @js.from_option_map({
        "recursive": recursive.map(fn(x) { @js.any(x) }),
        "force": force.map(fn(x) { @js.any(x) }),
      }),
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
      @js.from_option_map({ "recursive": recursive.map(fn(x) { @js.any(x) }) }),
    ]),
  )
}

///| Additional File Operations

///|
/// Change file permissions
pub fn chmod(path : String, mode : Int) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  fs.call2("chmod", path, mode).cast()
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
    None => fs.call2("symlink", target, path).cast()
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
    Some(l) => fs.call2("truncate", path, l).cast()
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
      @js.from_option_map({ "recursive": recursive.map(fn(x) { @js.any(x) }) }),
    ]),
  )
}

///|
/// Check file access
pub fn access(path : String, mode? : Int) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  match mode {
    Some(m) => fs.call2("access", path, m).cast()
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
          @js.from_option_map({ "encoding": Some(@js.any(enc)) }),
        ]),
      )
    None => fs.call2("appendFile", path, data).cast()
  }
}

///|
/// Copy file
pub fn copyFile(src : String, dest : String) -> @js.Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  fs.call2("copyFile", src, dest).cast()
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
