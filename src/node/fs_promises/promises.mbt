///|
extern "js" fn fs_promises_module() -> @nostd.Any =
  #| () => require("node:fs/promises")

///|
#external
pub type Stat

///|
pub fn Stat::as_any(self : Stat) -> @nostd.Any = "%identity"

///|
// pub impl @js.JsImpl for Stat

///|
pub fn Stat::isFile(self : Self) -> Bool {
  self.as_any()._call("isFile", []).cast()
}

///|
pub fn Stat::isDirectory(self : Self) -> Bool {
  self.as_any()._call("isDirectory", []).cast()
}

///|
pub fn Stat::size(self : Self) -> Int {
  self.as_any()._get("size").cast()
}

///|
pub fn Stat::mtime_ms(self : Self) -> Float {
  let mtime = self.as_any()._get("mtime")
  @js.identity(mtime._get("getTime")._call("call", [mtime]))
}

///|
/// node:fs/promises.stat
pub async fn stat(path : String) -> Stat {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Stat] = fs
    ._call("stat", [path |> @nostd.identity])
    .cast()
  promise.wait()
}

///|
/// node:fs/promises.mkdir
pub async fn mkdir(path : String, recursive? : Bool) -> Unit {
  let fs = fs_promises_module()
  let opts : @nostd.Any = @mbtconv.from_option_map({
    "recursive": recursive.map(fn(x) { @nostd.any(x) }),
  }).cast()
  let promise : @nostd.Promise[Unit] = fs
    ._call("mkdir", [path |> @nostd.any, opts |> @nostd.any])
    .cast()
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
  let exclude_opt : @nostd.Any? = match (exclude, exclude_fn) {
    (Some(arr), _) => Some(@nostd.identity(arr |> @js.from_array))
    (None, Some(f)) => Some(@nostd.identity(f |> @js.from_fn1))
    (None, None) => None
  }
  let opts : @nostd.Any = @mbtconv.from_option_map({
    "cwd": cwd.map(fn(x) { @nostd.any(x) }),
    "exclude": exclude_opt,
  }).cast()
  fs._call("glob", [path |> @nostd.any, opts |> @nostd.any]).cast()
}

///|
#external
pub type Dirent

///|
pub fn Dirent::as_any(self : Dirent) -> @nostd.Any = "%identity"

///|
// pub impl @js.JsImpl for Dirent

///|
#alias(is_file)
pub fn Dirent::isFile(self : Self) -> Bool {
  self.as_any()._call("isFile", []).cast()
}

///|
#alias(is_directory)
pub fn Dirent::isDirectory(self : Self) -> Bool {
  self.as_any()._call("isDirectory", []).cast()
}

///|
pub fn Dirent::name(self : Self) -> String {
  self.as_any()._get("name").cast()
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
  let exclude_opt : @nostd.Any? = match (exclude, exclude_fn) {
    (Some(arr), _) => Some(@nostd.identity(arr |> @js.from_array))
    (None, Some(f)) => Some(@nostd.identity(f |> @js.from_fn1))
    (None, None) => None
  }
  let opts : @nostd.Any = @mbtconv.from_option_map({
    "withFileTypes": Some(@nostd.any(true)),
    "cwd": cwd.map(fn(x) { @nostd.any(x) }),
    "exclude": exclude_opt,
  }).cast()
  fs._call("glob", [path |> @nostd.any, opts |> @nostd.any]).cast()
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
  let promise : @nostd.Promise[FileHandle] = fs
    ._call("open", [path |> @nostd.identity])
    .cast()
  promise.wait()
}

///|
#alias(read_file)
pub async fn readFile(path : String, encoding? : String = "utf-8") -> String {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[String] = fs
    ._call("readFile", [path |> @nostd.any, encoding |> @nostd.any])
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
  let promise : @nostd.Promise[String] = fs
    ._call("readFile", [path |> @nostd.any, encoding |> @nostd.any])
    .cast()
  promise.wait()
}

///|
/// Read file asynchronously as Buffer
/// JS: fs.promises.readFile(path)
pub async fn read_file_as_buffer(path : String) -> @buffer.Buffer {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[@buffer.Buffer] = @js.identity(
    fs._call("readFile", [path |> @nostd.any]),
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
  let opts : @nostd.Any = @mbtconv.from_option_map({
    "encoding": Some(@nostd.any(encoding)),
    "mode": Some(@nostd.any(mode)),
    "flag": Some(@nostd.any(flag)),
    "flush": Some(@nostd.any(flush)),
    "signal": signal.map(fn(x) { x |> @js.identity }),
  }).cast()
  let promise : @nostd.Promise[
    Unit,
    // @nostd.identity(
  ] = fs
    ._call("writeFile", [
      path |> @nostd.any,
      content |> @nostd.any,
      opts |> @nostd.any,
    ])
    .cast()
  // )
  promise.wait()
}

///|
pub async fn rename(path : String, dest : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Unit] = fs
    ._call("rename", [path |> @nostd.any, dest |> @nostd.any])
    .cast()
  promise.wait()
}

///|
pub async fn rm(path : String, recursive? : Bool, force? : Bool) -> Unit {
  let fs = fs_promises_module()
  let opts : @nostd.Any = @mbtconv.from_option_map({
    "recursive": recursive.map(fn(x) { @nostd.any(x) }),
    "force": force.map(fn(x) { @nostd.any(x) }),
  }).cast()
  let promise : @nostd.Promise[Unit] = fs
    ._call("rm", [path |> @nostd.any, opts |> @nostd.any])
    .cast()
  promise.wait()
}

///|
pub async fn cp(path : String, dest : String, recursive? : Bool) -> Unit {
  let fs = fs_promises_module()
  let opts : @nostd.Any = @mbtconv.from_option_map({
    "recursive": recursive.map(fn(x) { @nostd.any(x) }),
  }).cast()
  let promise : @nostd.Promise[Unit] = @js.identity(
    fs._call("cp", [path |> @nostd.any, dest |> @nostd.any, opts |> @nostd.any]),
  )
  promise.wait()
}

///| Additional File Operations

///|
/// Change file permissions
pub async fn chmod(path : String, mode : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Unit] = fs
    ._call("chmod", [path |> @nostd.any, mode |> @nostd.any])
    .cast()
  promise.wait()
}

///|
/// Change file owner
pub async fn chown(path : String, uid : Int, gid : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Unit] = @js.identity(
    fs._call("chown", [path |> @nostd.any, uid |> @nostd.any, gid |> @nostd.any]),
  )
  promise.wait()
}

///|
/// Create symbolic link
pub async fn symlink(target : String, path : String, type_? : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Unit] = match type_ {
    Some(t) =>
      @js.identity(
        fs._call("symlink", [
          target |> @nostd.any,
          path |> @nostd.any,
          t |> @nostd.any,
        ]),
      )
    None =>
      fs._call("symlink", [target |> @nostd.any, path |> @nostd.any]).cast()
  }
  promise.wait()
}

///|
/// Read symbolic link
pub async fn readlink(path : String) -> String {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[String] = @js.identity(
    fs._call("readlink", [path |> @nostd.any]),
  )
  promise.wait()
}

///|
/// Get real path
pub async fn realpath(path : String) -> String {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[String] = @js.identity(
    fs._call("realpath", [path |> @nostd.any]),
  )
  promise.wait()
}

///|
/// Truncate file
pub async fn truncate(path : String, len? : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Unit] = match len {
    Some(l) =>
      fs._call("truncate", [path |> @nostd.any, l |> @nostd.any]).cast()
    None => @js.identity(fs._call("truncate", [path |> @nostd.any]))
  }
  promise.wait()
}

///|
/// Remove directory
pub async fn rmdir(path : String, recursive? : Bool) -> Unit {
  let fs = fs_promises_module()
  let opts : @nostd.Any = @mbtconv.from_option_map({
    "recursive": recursive.map(fn(x) { @nostd.any(x) }),
  }).cast()
  let promise : @nostd.Promise[Unit] = fs
    ._call("rmdir", [path |> @nostd.any, opts |> @nostd.any])
    .cast()
  promise.wait()
}

///|
/// Check file access
pub async fn access(path : String, mode? : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Unit] = match mode {
    Some(m) => fs._call("access", [path |> @nostd.any, m |> @nostd.any]).cast()
    None => @js.identity(fs._call("access", [path |> @nostd.any]))
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
  let promise : @nostd.Promise[Unit] = match encoding {
    Some(enc) => {
      let opts : @nostd.Any = @mbtconv.from_option_map({
        "encoding": Some(@nostd.any(enc)),
      }).cast()
      @js.identity(
        fs._call("appendFile", [
          path |> @nostd.any,
          data |> @nostd.any,
          opts |> @nostd.any,
        ]),
      )
    }
    None =>
      fs._call("appendFile", [path |> @nostd.any, data |> @nostd.any]).cast()
  }
  promise.wait()
}

///|
/// Copy file
pub async fn copyFile(src : String, dest : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Unit] = fs
    ._call("copyFile", [src |> @nostd.any, dest |> @nostd.any])
    .cast()
  promise.wait()
}

///|
/// Read directory contents
pub async fn readdir(path : String) -> Array[String] {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Array[String]] = @js.identity(
    fs._call("readdir", [path |> @nostd.any]),
  )
  promise.wait()
}

///|
/// Unlink (delete) file
pub async fn unlink(path : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @nostd.Promise[Unit] = @js.identity(
    fs._call("unlink", [path |> @nostd.any]),
  )
  promise.wait()
}
