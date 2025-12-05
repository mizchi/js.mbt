///|
extern "js" fn fs_promises_module() -> @core.Any =
  #| () => require("node:fs/promises")

///|
#external
pub type Stat

///|
pub fn Stat::as_any(self : Stat) -> @core.Any = "%identity"

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
  @core.identity(mtime._get("getTime")._call("call", [mtime]))
}

///|
/// node:fs/promises.stat
pub async fn stat(path : String) -> Stat {
  let fs = fs_promises_module()
  let promise : @core.Promise[Stat] = fs
    ._call("stat", [path |> @core.identity])
    .cast()
  promise.wait()
}

///|
/// node:fs/promises.mkdir
pub async fn mkdir(path : String, recursive? : Bool) -> Unit {
  let fs = fs_promises_module()
  let entries : Array[(String, @core.Any)] = []
  if recursive is Some(v) {
    entries.push(("recursive", @core.any(v)))
  }
  let opts : @core.Any = @core.from_entries(entries).cast()
  let promise : @core.Promise[Unit] = fs
    ._call("mkdir", [path |> @core.any, opts |> @core.any])
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
  let exclude_opt : @core.Any? = match (exclude, exclude_fn) {
    (Some(arr), _) => Some(@core.identity(arr |> @core.any))
    (None, Some(f)) => Some(@core.identity(f |> @js.from_fn1))
    (None, None) => None
  }
  let entries : Array[(String, @core.Any)] = []
  if cwd is Some(v) {
    entries.push(("cwd", @core.any(v)))
  }
  if exclude_opt is Some(v) {
    entries.push(("exclude", v))
  }
  let opts : @core.Any = @core.from_entries(entries).cast()
  fs._call("glob", [path |> @core.any, opts |> @core.any]).cast()
}

///|
#external
pub type Dirent

///|
pub fn Dirent::as_any(self : Dirent) -> @core.Any = "%identity"

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
  let exclude_opt : @core.Any? = match (exclude, exclude_fn) {
    (Some(arr), _) => Some(@core.identity(arr |> @core.any))
    (None, Some(f)) => Some(@core.identity(f |> @js.from_fn1))
    (None, None) => None
  }
  let entries : Array[(String, @core.Any)] = []
  entries.push(("withFileTypes", @core.any(true)))
  if cwd is Some(v) {
    entries.push(("cwd", @core.any(v)))
  }
  if exclude_opt is Some(v) {
    entries.push(("exclude", v))
  }
  let opts : @core.Any = @core.from_entries(entries).cast()
  fs._call("glob", [path |> @core.any, opts |> @core.any]).cast()
}

///|
/// WIP
#external
pub type FileHandle

///|
pub fn FileHandle::as_any(self : FileHandle) -> @core.Any = "%identity"

///|
pub async fn open(path : String) -> FileHandle {
  let fs = fs_promises_module()
  let promise : @core.Promise[FileHandle] = fs
    ._call("open", [path |> @core.identity])
    .cast()
  promise.wait()
}

///|
#alias(read_file)
pub async fn readFile(path : String, encoding? : String = "utf-8") -> String {
  let fs = fs_promises_module()
  let promise : @core.Promise[String] = fs
    ._call("readFile", [path |> @core.any, encoding |> @core.any])
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
  let promise : @core.Promise[String] = fs
    ._call("readFile", [path |> @core.any, encoding |> @core.any])
    .cast()
  promise.wait()
}

///|
/// Read file asynchronously as Buffer
/// JS: fs.promises.readFile(path)
pub async fn read_file_as_buffer(path : String) -> @buffer.Buffer {
  let fs = fs_promises_module()
  let promise : @core.Promise[@buffer.Buffer] = @core.identity(
    fs._call("readFile", [path |> @core.any]),
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
  let entries : Array[(String, @core.Any)] = []
  entries.push(("encoding", @core.any(encoding)))
  entries.push(("mode", @core.any(mode)))
  entries.push(("flag", @core.any(flag)))
  entries.push(("flush", @core.any(flush)))
  if signal is Some(v) {
    entries.push(("signal", v |> @core.identity))
  }
  let opts : @core.Any = @core.from_entries(entries).cast()
  let promise : @core.Promise[
    Unit,
    // @core.identity(
  ] = fs
    ._call("writeFile", [
      path |> @core.any,
      content |> @core.any,
      opts |> @core.any,
    ])
    .cast()
  // )
  promise.wait()
}

///|
pub async fn rename(path : String, dest : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @core.Promise[Unit] = fs
    ._call("rename", [path |> @core.any, dest |> @core.any])
    .cast()
  promise.wait()
}

///|
pub async fn rm(path : String, recursive? : Bool, force? : Bool) -> Unit {
  let fs = fs_promises_module()
  let entries : Array[(String, @core.Any)] = []
  if recursive is Some(v) {
    entries.push(("recursive", @core.any(v)))
  }
  if force is Some(v) {
    entries.push(("force", @core.any(v)))
  }
  let opts : @core.Any = @core.from_entries(entries).cast()
  let promise : @core.Promise[Unit] = fs
    ._call("rm", [path |> @core.any, opts |> @core.any])
    .cast()
  promise.wait()
}

///|
pub async fn cp(path : String, dest : String, recursive? : Bool) -> Unit {
  let fs = fs_promises_module()
  let entries : Array[(String, @core.Any)] = []
  if recursive is Some(v) {
    entries.push(("recursive", @core.any(v)))
  }
  let opts : @core.Any = @core.from_entries(entries).cast()
  let promise : @core.Promise[Unit] = @core.identity(
    fs._call("cp", [path |> @core.any, dest |> @core.any, opts |> @core.any]),
  )
  promise.wait()
}

///| Additional File Operations

///|
/// Change file permissions
pub async fn chmod(path : String, mode : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @core.Promise[Unit] = fs
    ._call("chmod", [path |> @core.any, mode |> @core.any])
    .cast()
  promise.wait()
}

///|
/// Change file owner
pub async fn chown(path : String, uid : Int, gid : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @core.Promise[Unit] = @core.identity(
    fs._call("chown", [path |> @core.any, uid |> @core.any, gid |> @core.any]),
  )
  promise.wait()
}

///|
/// Create symbolic link
pub async fn symlink(target : String, path : String, type_? : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @core.Promise[Unit] = match type_ {
    Some(t) =>
      @core.identity(
        fs._call("symlink", [
          target |> @core.any,
          path |> @core.any,
          t |> @core.any,
        ]),
      )
    None => fs._call("symlink", [target |> @core.any, path |> @core.any]).cast()
  }
  promise.wait()
}

///|
/// Read symbolic link
pub async fn readlink(path : String) -> String {
  let fs = fs_promises_module()
  let promise : @core.Promise[String] = @core.identity(
    fs._call("readlink", [path |> @core.any]),
  )
  promise.wait()
}

///|
/// Get real path
pub async fn realpath(path : String) -> String {
  let fs = fs_promises_module()
  let promise : @core.Promise[String] = @core.identity(
    fs._call("realpath", [path |> @core.any]),
  )
  promise.wait()
}

///|
/// Truncate file
pub async fn truncate(path : String, len? : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @core.Promise[Unit] = match len {
    Some(l) => fs._call("truncate", [path |> @core.any, l |> @core.any]).cast()
    None => @core.identity(fs._call("truncate", [path |> @core.any]))
  }
  promise.wait()
}

///|
/// Remove directory
pub async fn rmdir(path : String, recursive? : Bool) -> Unit {
  let fs = fs_promises_module()
  let entries : Array[(String, @core.Any)] = []
  if recursive is Some(v) {
    entries.push(("recursive", @core.any(v)))
  }
  let opts : @core.Any = @core.from_entries(entries).cast()
  let promise : @core.Promise[Unit] = fs
    ._call("rmdir", [path |> @core.any, opts |> @core.any])
    .cast()
  promise.wait()
}

///|
/// Check file access
pub async fn access(path : String, mode? : Int) -> Unit {
  let fs = fs_promises_module()
  let promise : @core.Promise[Unit] = match mode {
    Some(m) => fs._call("access", [path |> @core.any, m |> @core.any]).cast()
    None => @core.identity(fs._call("access", [path |> @core.any]))
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
  let promise : @core.Promise[Unit] = match encoding {
    Some(enc) => {
      let opts : @core.Any = @core.from_entries([("encoding", @core.any(enc))]).cast()
      @core.identity(
        fs._call("appendFile", [
          path |> @core.any,
          data |> @core.any,
          opts |> @core.any,
        ]),
      )
    }
    None =>
      fs._call("appendFile", [path |> @core.any, data |> @core.any]).cast()
  }
  promise.wait()
}

///|
/// Copy file
pub async fn copyFile(src : String, dest : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @core.Promise[Unit] = fs
    ._call("copyFile", [src |> @core.any, dest |> @core.any])
    .cast()
  promise.wait()
}

///|
/// Read directory contents
pub async fn readdir(path : String) -> Array[String] {
  let fs = fs_promises_module()
  let promise : @core.Promise[Array[String]] = @core.identity(
    fs._call("readdir", [path |> @core.any]),
  )
  promise.wait()
}

///|
/// Unlink (delete) file
pub async fn unlink(path : String) -> Unit {
  let fs = fs_promises_module()
  let promise : @core.Promise[Unit] = @core.identity(
    fs._call("unlink", [path |> @core.any]),
  )
  promise.wait()
}
