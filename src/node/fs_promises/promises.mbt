///|
using @js {trait JsImpl, type AbortSignal, type Promise, unsafe_cast}

///|
using @iterator {type AsyncIterator}

///|
#external
pub type Stat

///|
pub impl JsImpl for Stat

///|
pub fn Stat::isFile(self : Self) -> Bool {
  self.call("isFile", []) |> unsafe_cast
}

///|
pub fn Stat::isDirectory(self : Self) -> Bool {
  self.call("isDirectory", []) |> unsafe_cast
}

///|
pub fn Stat::size(self : Self) -> Int {
  unsafe_cast(self.get("size"))
}

///|
pub fn Stat::mtime_ms(self : Self) -> Float {
  let mtime = self.get("mtime")
  unsafe_cast(mtime.get("getTime").call("call", [mtime]))
}

///|
/// node:fs/promises.stat
pub fn stat(path : String) -> Promise[Stat] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("stat", [path]))
}

///|
/// node:fs/promises.mkdir
pub fn mkdir(path : String, recursive? : Bool) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let options = @js.Object::new()
  if recursive is Some(r) {
    options.set("recursive", r)
  }
  unsafe_cast(fs.call("mkdir", [path, options]))
}

///|
/// node:fs/promises.glob
pub fn glob(
  path : String,
  cwd? : String,
  exclude? : Array[String],
  exclude_fn? : (String) -> Bool,
) -> AsyncIterator[String] {
  let fs = @node.require("node:fs/promises")
  let opts = @js.Object::new()
  if cwd is Some(c) {
    opts.set("cwd", c)
  }
  if exclude is Some(e) {
    opts.set("exclude", e |> @js.from_array)
  }
  if exclude_fn is Some(f) {
    opts.set("exclude", f |> @js.from_fn1)
  }
  unsafe_cast(fs.call("glob", [path]))
}

///|
#external
pub type Dirent

///|
pub impl JsImpl for Dirent

///|
#alias(is_file)
pub fn Dirent::isFile(self : Self) -> Bool {
  self.call("isFile", []) |> unsafe_cast
}

///|
#alias(is_directory)
pub fn Dirent::isDirectory(self : Self) -> Bool {
  self.call("isDirectory", []) |> unsafe_cast
}

///|
pub fn Dirent::name(self : Self) -> String {
  unsafe_cast(self.get("name"))
}

///|
pub fn glob_with_filetype(
  path : String,
  cwd? : String,
  exclude? : Array[String],
  exclude_fn? : (String) -> Bool,
) -> AsyncIterator[Dirent] {
  let fs = @node.require("node:fs/promises")
  let opts = @js.Object::new()
  opts.set("withFileTypes", true)
  if cwd is Some(c) {
    opts.set("cwd", c)
  }
  if exclude is Some(e) {
    opts.set("exclude", e |> @js.from_array)
  }
  if exclude_fn is Some(f) {
    opts.set("exclude", f |> @js.from_fn1)
  }
  unsafe_cast(fs.call("glob", [path]))
}

///|
/// WIP
#external
pub type FileHandle

///|
pub fn open(path : String) -> Promise[FileHandle] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("open", [path]))
}

///|
#alias(read_file)
pub fn readFile(path : String, encoding? : String = "utf-8") -> Promise[String] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("readFile", [path, encoding]))
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
  signal? : AbortSignal,
) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let opts = @js.Object::new()
  opts.set("encoding", encoding)
  opts.set("mode", mode)
  opts.set("flag", flag)
  opts.set("flush", flush)
  if signal is Some(s) {
    opts.set("signal", s)
  }
  let promise = fs.call("writeFile", [path, content, opts])
  unsafe_cast(promise)
}

///|
pub fn rename(path : String, dest : String) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("rename", [path, dest]))
}

///|
pub fn rm(path : String, recursive? : Bool, force? : Bool) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let opts = @js.Object::new()
  if recursive is Some(r) {
    opts.set("recursive", r)
  }
  if force is Some(f) {
    opts.set("force", f)
  }
  let promise = fs.call("rm", [path, opts])
  unsafe_cast(promise)
}

///|
pub fn cp(path : String, dest : String, recursive? : Bool) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let opts = @js.Object::new()
  if recursive is Some(r) {
    opts.set("recursive", r)
  }
  let promise = fs.call("cp", [path, dest, opts])
  unsafe_cast(promise)
}

///| Additional File Operations

///|
/// Change file permissions
pub fn chmod(path : String, mode : Int) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("chmod", [path, mode]))
}

///|
/// Change file owner
pub fn chown(path : String, uid : Int, gid : Int) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("chown", [path, uid, gid]))
}

///|
/// Create symbolic link
pub fn symlink(
  target : String,
  path : String,
  type_? : String,
) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  match type_ {
    Some(t) => unsafe_cast(fs.call("symlink", [target, path, t]))
    None => unsafe_cast(fs.call("symlink", [target, path]))
  }
}

///|
/// Read symbolic link
pub fn readlink(path : String) -> Promise[String] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("readlink", [path]))
}

///|
/// Get real path
pub fn realpath(path : String) -> Promise[String] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("realpath", [path]))
}

///|
/// Truncate file
pub fn truncate(path : String, len? : Int) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  match len {
    Some(l) => unsafe_cast(fs.call("truncate", [path, l]))
    None => unsafe_cast(fs.call("truncate", [path]))
  }
}

///|
/// Remove directory
pub fn rmdir(path : String, recursive? : Bool) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let opts = @js.Object::new()
  if recursive is Some(r) {
    opts.set("recursive", r)
  }
  unsafe_cast(fs.call("rmdir", [path, opts]))
}

///|
/// Check file access
pub fn access(path : String, mode? : Int) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  match mode {
    Some(m) => unsafe_cast(fs.call("access", [path, m]))
    None => unsafe_cast(fs.call("access", [path]))
  }
}

///|
/// Append to file
pub fn appendFile(
  path : String,
  data : String,
  encoding? : String,
) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  match encoding {
    Some(enc) => {
      let opts = @js.Object::new()
      opts.set("encoding", enc)
      unsafe_cast(fs.call("appendFile", [path, data, opts]))
    }
    None => unsafe_cast(fs.call("appendFile", [path, data]))
  }
}

///|
/// Copy file
pub fn copyFile(src : String, dest : String) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("copyFile", [src, dest]))
}

///|
/// Read directory contents
pub fn readdir(path : String) -> Promise[Array[String]] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("readdir", [path]))
}

///|
/// Unlink (delete) file
pub fn unlink(path : String) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.call("unlink", [path]))
}
