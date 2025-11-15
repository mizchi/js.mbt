// ///|

///|
using @js {trait Js, type Val, js, unsafe_cast}

///|
using @async {type Promise, type AbortSignal, run_async}

///|
using @iterator {type AsyncIterator}

///|
pub(all) struct FsStat {
  isFile : () -> Bool
  isDirectory : () -> Bool
  size : Int
  mtime_ms : Float
}

///|
pub fn stat(path : String) -> Promise[FsStat] {
  let fs = @node.require("node:fs/promises")
  fs.invoke("stat", [path]).cast()
}

///|
pub fn mkdir(path : String, recursive? : Bool) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let options = @js.new_empty_object()
  if recursive is Some(r) {
    options.set("recursive", r)
  }
  fs.invoke("mkdir", [path, options]).cast()
}

///|
pub fn rmdir(path : String) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  fs.invoke("rmdir", [path]).cast()
}

///|
pub fn glob(
  path : String,
  cwd? : String,
  exclude? : Array[String],
  exclude_fn? : (String) -> Bool,
) -> AsyncIterator[String] {
  let fs = @node.require("node:fs/promises")
  let opts = @js.new_empty_object()
  if cwd is Some(c) {
    opts.set("cwd", c)
  }
  if exclude is Some(e) {
    opts.set("exclude", e |> js)
  }
  if exclude_fn is Some(f) {
    opts.set("exclude", f |> js)
  }
  fs.invoke("glob", [path]).cast()
}

///|
#external
pub type Dirent

///|
pub impl Js for Dirent with to_js(self) -> Val {
  self |> js
}

///|
#alias(isFile)
pub fn Dirent::is_file(self : Self) -> Bool {
  self.invoke("isFile", []) |> unsafe_cast
}

///|
#alias(isDirectory)
pub fn Dirent::is_directory(self : Self) -> Bool {
  self.invoke("isDirectory", []) |> unsafe_cast
}

///|
pub fn Dirent::name(self : Self) -> String {
  self.to_js().get("name").cast()
}

///|
pub fn glob_with_filetype(
  path : String,
  cwd? : String,
  exclude? : Array[String],
  exclude_fn? : (String) -> Bool,
) -> AsyncIterator[Dirent] {
  let fs = @node.require("node:fs/promises")
  let opts = @js.new_empty_object()
  opts["withFileTypes"] = true
  if cwd is Some(c) {
    opts.set("cwd", c)
  }
  if exclude is Some(e) {
    opts.set("exclude", e |> js)
  }
  if exclude_fn is Some(f) {
    opts.set("exclude", f |> js)
  }
  fs.invoke("glob", [path]).cast()
}

///|
/// WIP
#external
pub type FileHandle

///|
pub fn open(path : String) -> Promise[FileHandle] {
  let fs = @node.require("node:fs/promises")
  fs.invoke("open", [path]).cast()
}

///|
#alias(read_file)
pub fn readFile(path : String, encoding? : String = "utf-8") -> Promise[String] {
  let fs = @node.require("node:fs/promises")
  fs.invoke("readFile", [path, encoding]).cast()
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
  let opts = @js.new_empty_object()
  opts.set("encoding", encoding)
  opts.set("mode", mode)
  opts.set("flag", flag)
  opts.set("flush", flush)
  if signal is Some(s) {
    opts.set("signal", s)
  }
  let promise = fs.invoke("writeFile", [path, content, opts])
  promise.cast()
}

///|
pub fn rename(path : String, dest : String) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  fs.invoke("rename", [path, dest]).cast()
}

///|
pub fn rm(path : String) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let promise = fs.invoke("rm", [path])
  promise.cast()
}

///|
pub fn cp(path : String, dest : String) -> Promise[Unit] {
  let fs = @node.require("node:fs/promises")
  let promise = fs.invoke("cp", [path, dest])
  promise.cast()
}
