///|
using @js {trait JsImpl, type AbortSignal, unsafe_cast}

///|
using @promise {type Promise}

///|
using @iterator {type AsyncIterator}

///|
using @fs {type Stat}

///|
/// node:fs/promises.stat
pub fn stat(path : String) -> Promise[Stat] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.invoke("stat", [path]))
}

///|
/// node:fs/promises.mkdir
pub fn mkdir(path : String, recursive? : Bool) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let options = @js.Object::new()
  if recursive is Some(r) {
    options.set("recursive", r)
  }
  unsafe_cast(fs.invoke("mkdir", [path, options]))
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
  unsafe_cast(fs.invoke("glob", [path]))
}

///|
#external
pub type Dirent

///|
pub impl JsImpl for Dirent

///|
#alias(is_file)
pub fn Dirent::isFile(self : Self) -> Bool {
  self.invoke("isFile", []) |> unsafe_cast
}

///|
#alias(is_directory)
pub fn Dirent::isDirectory(self : Self) -> Bool {
  self.invoke("isDirectory", []) |> unsafe_cast
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
  unsafe_cast(fs.invoke("glob", [path]))
}

///|
/// WIP
#external
pub type FileHandle

///|
pub fn open(path : String) -> Promise[FileHandle] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.invoke("open", [path]))
}

///|
#alias(read_file)
pub fn readFile(path : String, encoding? : String = "utf-8") -> Promise[String] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.invoke("readFile", [path, encoding]))
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
  let promise = fs.invoke("writeFile", [path, content, opts])
  unsafe_cast(promise)
}

///|
pub fn rename(path : String, dest : String) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  unsafe_cast(fs.invoke("rename", [path, dest]))
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
  let promise = fs.invoke("rm", [path, opts])
  unsafe_cast(promise)
}

///|
pub fn cp(path : String, dest : String) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let promise = fs.invoke("cp", [path, dest])
  unsafe_cast(promise)
}
