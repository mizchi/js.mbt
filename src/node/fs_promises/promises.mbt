///|
extern "js" fn fs_promises_module() -> @js.Any =
  #| () => require("node:fs/promises")

///|
#external
pub type Stat

///|
pub fn Stat::as_any(self : Stat) -> @nostd.Any = "%identity"

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
pub async fn stat(path : String) -> Stat {
  let fs = fs_promises_module()
  let promise : @js.Promise[Stat] = @js.identity(fs.call("stat", [path]))
  promise.wait()
}

///|
/// node:fs/promises.mkdir
pub async fn mkdir(path : String, recursive? : Bool) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = @js.identity(
    fs.call("mkdir", [
      path,
      @js.from_option_map({ "recursive": recursive.map(fn(x) { @js.any(x) }) }),
    ]),
  )
  promise.wait()
}

///|
/// node:fs/promises.glob
pub fn glob(
  path : String,
  cwd? : String,
  exclude? : Array[String],
  exclude_fn? : (String) -> Bool,
) -> @js.AsyncIterator[String] {
  let fs = fs_promises_module()
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
pub fn Dirent::as_any(self : Dirent) -> @nostd.Any = "%identity"

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
  let fs = fs_promises_module()
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
pub fn FileHandle::as_any(self : FileHandle) -> @nostd.Any = "%identity"

///|
pub async fn open(path : String) -> FileHandle {
  let fs = fs_promises_module()
  let promise : @js.Promise[FileHandle] = @js.identity(fs.call("open", [path]))
  promise.wait()
}

///|
#alias(read_file)
pub async fn readFile(path : String, encoding? : String = "utf-8") -> String {
  let fs = fs_promises_module()
  let promise : @js.Promise[String] = fs
    .call2("readFile", path, encoding)
    .cast()
  promise.wait()
}

///|
/// Read file asynchronously as string with encoding
/// JS: fs.promises.readFile(path, encoding)
pub async fn read_file_as_string(
  path : String,
  encoding? : String = "utf8",
) -> String {
  let fs = fs_promises_module()
  let promise : @js.Promise[String] = fs
    .call2("readFile", path, encoding)
    .cast()
  promise.wait()
}

///|
/// Read file asynchronously as Buffer
/// JS: fs.promises.readFile(path)
pub async fn read_file_as_buffer(path : String) -> @buffer.Buffer {
  let fs = fs_promises_module()
  let promise : @js.Promise[@buffer.Buffer] = @js.identity(
    fs.call("readFile", [path]),
  )
  promise.wait()
}

///|
#alias(write_file)
pub async fn writeFile(
  path : String,
  content : String,
  encoding? : String = "utf-8",
  mode? : Int = 0o666,
  flag? : String = "w",
  flush? : Bool = false,
  signal? : @js.AbortSignal,
) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = @js.identity(
    fs.call("writeFile", [
      path,
      content,
      @js.from_option_map({
        "encoding": Some(@js.any(encoding)),
        "mode": Some(@js.any(mode)),
        "flag": Some(@js.any(flag)),
        "flush": Some(@js.any(flush)),
        "signal": signal.map(fn(x) { x |> @js.identity }),
      }),
    ]),
  )
  promise.wait()
}

///|
pub async fn rename(path : String, dest : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = fs.call2("rename", path, dest).cast()
  promise.wait()
}

///|
pub async fn rm(path : String, recursive? : Bool, force? : Bool) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = @js.identity(
    fs.call("rm", [
      path,
      @js.from_option_map({
        "recursive": recursive.map(fn(x) { @js.any(x) }),
        "force": force.map(fn(x) { @js.any(x) }),
      }),
    ]),
  )
  promise.wait()
}

///|
pub async fn cp(path : String, dest : String, recursive? : Bool) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = @js.identity(
    fs.call("cp", [
      path,
      dest,
      @js.from_option_map({ "recursive": recursive.map(fn(x) { @js.any(x) }) }),
    ]),
  )
  promise.wait()
}

///| Additional File Operations

///|
/// Change file permissions
pub async fn chmod(path : String, mode : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = fs.call2("chmod", path, mode).cast()
  promise.wait()
}

///|
/// Change file owner
pub async fn chown(path : String, uid : Int, gid : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = @js.identity(
    fs.call("chown", [path, uid, gid]),
  )
  promise.wait()
}

///|
/// Create symbolic link
pub async fn symlink(target : String, path : String, type_? : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = match type_ {
    Some(t) => @js.identity(fs.call("symlink", [target, path, t]))
    None => fs.call2("symlink", target, path).cast()
  }
  promise.wait()
}

///|
/// Read symbolic link
pub async fn readlink(path : String) -> String {
  let fs = fs_promises_module()
  let promise : @js.Promise[String] = @js.identity(fs.call("readlink", [path]))
  promise.wait()
}

///|
/// Get real path
pub async fn realpath(path : String) -> String {
  let fs = fs_promises_module()
  let promise : @js.Promise[String] = @js.identity(fs.call("realpath", [path]))
  promise.wait()
}

///|
/// Truncate file
pub async fn truncate(path : String, len? : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = match len {
    Some(l) => fs.call2("truncate", path, l).cast()
    None => @js.identity(fs.call("truncate", [path]))
  }
  promise.wait()
}

///|
/// Remove directory
pub async fn rmdir(path : String, recursive? : Bool) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = @js.identity(
    fs.call("rmdir", [
      path,
      @js.from_option_map({ "recursive": recursive.map(fn(x) { @js.any(x) }) }),
    ]),
  )
  promise.wait()
}

///|
/// Check file access
pub async fn access(path : String, mode? : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = match mode {
    Some(m) => fs.call2("access", path, m).cast()
    None => @js.identity(fs.call("access", [path]))
  }
  promise.wait()
}

///|
/// Append to file
pub async fn appendFile(
  path : String,
  data : String,
  encoding? : String,
) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = match encoding {
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
  promise.wait()
}

///|
/// Copy file
pub async fn copyFile(src : String, dest : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = fs.call2("copyFile", src, dest).cast()
  promise.wait()
}

///|
/// Read directory contents
pub async fn readdir(path : String) -> Array[String] {
  let fs = fs_promises_module()
  let promise : @js.Promise[Array[String]] = @js.identity(
    fs.call("readdir", [path]),
  )
  promise.wait()
}

///|
/// Unlink (delete) file
pub async fn unlink(path : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @js.Promise[Unit] = @js.identity(fs.call("unlink", [path]))
  promise.wait()
}
