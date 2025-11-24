///|
/// Deno namespace
/// https://docs.deno.com/api/deno/

///|
#external
pub type Deno

///|
impl @js.JsImpl for Deno

///|
/// Deno global object
pub extern "js" fn deno() -> Deno =
  #| () => Deno

///| Process/Runtime APIs

///|
/// Get environment variable
pub fn Deno::env_get(self : Deno, key : String) -> String? {
  self.get("env").call("get", [@js.js(key)]) |> @js.identity_option
}

///|
/// Set environment variable
pub fn Deno::env_set(self : Deno, key : String, value : String) -> Unit {
  self.get("env").call("set", [@js.js(key), @js.js(value)]) |> ignore
}

///|
/// Delete environment variable
pub fn Deno::env_delete(self : Deno, key : String) -> Unit {
  self.get("env").call("delete", [@js.js(key)]) |> ignore
}

///|
/// Get all environment variables
pub fn Deno::env_toObject(self : Deno) -> @js.Js {
  self.get("env").call("toObject", [])
}

///|
/// Get current working directory
pub fn Deno::cwd(self : Deno) -> String {
  self.call("cwd", []) |> @js.identity
}

///|
/// Exit the process
pub fn Deno::exit(self : Deno, code? : Int) -> Unit {
  match code {
    Some(c) => self.call("exit", [@js.js(c)]) |> ignore
    None => self.call("exit", []) |> ignore
  }
}

///|
/// Get command line arguments
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Deno::args(self : Deno) -> Array[String] {
  self.get("args") |> @js.identity
}

///|
/// Get process ID
pub fn Deno::pid(self : Deno) -> Int {
  self.get("pid") |> @js.identity
}

///|
/// Get parent process ID
pub fn Deno::ppid(self : Deno) -> Int {
  self.get("ppid") |> @js.identity
}

///|
/// Get operating system
pub fn Deno::build_os(self : Deno) -> String {
  self.get("build").get("os") |> @js.identity
}

///|
/// Get architecture
pub fn Deno::build_arch(self : Deno) -> String {
  self.get("build").get("arch") |> @js.identity
}

///|
/// Read all data from stdin
pub fn Deno::stdin_read(self : Deno) -> @js.Promise[@js.Js] {
  self.get("stdin").call("read", []) |> @js.identity
}

///|
/// Write to stdout
pub fn Deno::stdout_write(self : Deno, data : @js.Js) -> @js.Promise[Int] {
  self.get("stdout").call("write", [data]) |> @js.identity
}

///|
/// Write to stderr
pub fn Deno::stderr_write(self : Deno, data : @js.Js) -> @js.Promise[Int] {
  self.get("stderr").call("write", [data]) |> @js.identity
}

///| File System APIs

///|
/// Read text file
pub fn Deno::readTextFile(self : Deno, path : String) -> @js.Promise[String] {
  self.call("readTextFile", [@js.js(path)]) |> @js.identity
}

///|
/// Write text file
pub fn Deno::writeTextFile(
  self : Deno,
  path : String,
  data : String,
) -> @js.Promise[Unit] {
  self.call("writeTextFile", [@js.js(path), @js.js(data)]) |> @js.identity
}

///|
/// Read file as Uint8Array
pub fn Deno::readFile(self : Deno, path : String) -> @js.Promise[@js.Js] {
  self.call("readFile", [@js.js(path)]) |> @js.identity
}

///|
/// Write file from Uint8Array
pub fn Deno::writeFile(
  self : Deno,
  path : String,
  data : @js.Js,
) -> @js.Promise[Unit] {
  self.call("writeFile", [@js.js(path), data]) |> @js.identity
}

///|
/// Remove file or directory
pub fn Deno::remove(
  self : Deno,
  path : String,
  recursive? : Bool,
) -> @js.Promise[Unit] {
  match recursive {
    Some(r) =>
      self.call("remove", [
        @js.js(path),
        @js.from_entries_option_cast([("recursive", Some(r))]),
      ])
      |> @js.identity
    None => self.call("remove", [@js.js(path)]) |> @js.identity
  }
}

///|
/// Create directory
pub fn Deno::mkdir(
  self : Deno,
  path : String,
  recursive? : Bool,
) -> @js.Promise[Unit] {
  match recursive {
    Some(r) =>
      self.call("mkdir", [
        @js.js(path),
        @js.from_entries_option_cast([("recursive", Some(r))]),
      ])
      |> @js.identity
    None => self.call("mkdir", [@js.js(path)]) |> @js.identity
  }
}

///|
/// Read directory entries
pub fn Deno::readDir(self : Deno, path : String) -> @js.Js {
  self.call("readDir", [@js.js(path)])
}

///|
/// Rename/move file or directory
pub fn Deno::rename(
  self : Deno,
  oldpath : String,
  newpath : String,
) -> @js.Promise[Unit] {
  self.call("rename", [@js.js(oldpath), @js.js(newpath)]) |> @js.identity
}

///|
/// Copy file
pub fn Deno::copyFile(
  self : Deno,
  from : String,
  to : String,
) -> @js.Promise[Unit] {
  self.call("copyFile", [@js.js(from), @js.js(to)]) |> @js.identity
}

///|
/// Check if path exists
pub fn Deno::stat(self : Deno, path : String) -> @js.Promise[@js.Js] {
  self.call("stat", [@js.js(path)]) |> @js.identity
}

///|
/// Check if path exists (returns null if not found instead of throwing)
pub fn Deno::lstat(self : Deno, path : String) -> @js.Promise[@js.Js] {
  self.call("lstat", [@js.js(path)]) |> @js.identity
}

///|
/// Read link target
pub fn Deno::readLink(self : Deno, path : String) -> @js.Promise[String] {
  self.call("readLink", [@js.js(path)]) |> @js.identity
}

///|
/// Create symbolic link
pub fn Deno::symlink(
  self : Deno,
  target : String,
  path : String,
) -> @js.Promise[Unit] {
  self.call("symlink", [@js.js(target), @js.js(path)]) |> @js.identity
}

///|
/// Change file permissions (Unix only)
pub fn Deno::chmod(self : Deno, path : String, mode : Int) -> @js.Promise[Unit] {
  self.call("chmod", [@js.js(path), @js.js(mode)]) |> @js.identity
}

///|
/// Get real path (resolves symlinks)
pub fn Deno::realPath(self : Deno, path : String) -> @js.Promise[String] {
  self.call("realPath", [@js.js(path)]) |> @js.identity
}

///|
/// Truncate or extend a file to specified length
pub fn Deno::truncate(
  self : Deno,
  name : String,
  len : Int,
) -> @js.Promise[Unit] {
  self.call("truncate", [@js.js(name), @js.js(len)]) |> @js.identity
}

///|
/// Make temporary directory
pub fn Deno::makeTempDir(self : Deno, prefix? : String) -> @js.Promise[String] {
  match prefix {
    Some(p) =>
      self.call("makeTempDir", [
        @js.from_entries_option_cast([("prefix", Some(p))]),
      ])
      |> @js.identity
    None => self.call("makeTempDir", []) |> @js.identity
  }
}

///|
/// Make temporary file
pub fn Deno::makeTempFile(self : Deno, prefix? : String) -> @js.Promise[String] {
  match prefix {
    Some(p) =>
      self.call("makeTempFile", [
        @js.from_entries_option_cast([("prefix", Some(p))]),
      ])
      |> @js.identity
    None => self.call("makeTempFile", []) |> @js.identity
  }
}

///|
/// Get hostname
pub fn Deno::hostname(self : Deno) -> String {
  self.call("hostname", []) |> @js.identity
}

///|
/// Get OS release version
pub fn Deno::osRelease(self : Deno) -> String {
  self.call("osRelease", []) |> @js.identity
}

///|
/// Get OS uptime in seconds
pub fn Deno::osUptime(self : Deno) -> Int {
  self.call("osUptime", []) |> @js.identity
}

///|
/// Get system load average (Unix only)
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Deno::loadavg(self : Deno) -> Array[Double] {
  self.call("loadavg", []) |> @js.identity
}

///|
/// Get network interfaces
pub fn Deno::networkInterfaces(self : Deno) -> @js.Js {
  self.call("networkInterfaces", [])
}

///|
/// Get system memory info
pub fn Deno::systemMemoryInfo(self : Deno) -> @js.Js {
  self.call("systemMemoryInfo", [])
}

///|
/// Get user ID (Unix only)
pub fn Deno::uid(self : Deno) -> Int? {
  self.call("uid", []) |> @js.identity_option
}

///|
/// Get group ID (Unix only)
pub fn Deno::gid(self : Deno) -> Int? {
  self.call("gid", []) |> @js.identity_option
}

///| Network APIs

///|
/// Open a network connection (TCP)
pub fn Deno::connect(
  self : Self,
  hostname : String,
  port : Int,
) -> @js.Promise[@js.Js] {
  self.call("connect", [
    @js.from_entries([("hostname", hostname), ("port", port)]),
  ])
  |> @js.identity
}

///|
/// Listen on a network address (TCP server)
pub fn Deno::listen(self : Deno, hostname : String, port : Int) -> @js.Js {
  self.call("listen", [
    @js.from_entries([("hostname", hostname), ("port", port)]),
  ])
}

///|
/// Resolve DNS hostname to IP addresses
pub fn Deno::resolveDns(
  self : Deno,
  query : String,
  recordType : String,
) -> @js.Promise[@js.Js] {
  self.call("resolveDns", [@js.js(query), @js.js(recordType)])
  |> @js.identity
}

///| HTTP Server APIs

///|
/// Serve HTTP requests (simplified version)
pub fn Deno::serve(self : Deno, port : Int, handler : @js.Js) -> @js.Js {
  self.call1("serve", @js.from_entries([("port", port), ("handler", handler)]))
}

///| Permissions APIs

///|
/// Request permission
pub fn Deno::request_permission(
  self : Self,
  name : String,
) -> @js.Promise[@js.Js] {
  self.get("permissions").call1("request", @js.from_entries([("name", name)]))
  |> @js.identity
}

///|
/// Query permission status
pub fn Deno::query_permission(
  self : Deno,
  name : String,
) -> @js.Promise[@js.Js] {
  self.get("permissions").call1("query", @js.from_entries([("name", name)]))
  |> @js.identity
}

///|
/// Revoke permission
pub fn Deno::revoke_permission(
  self : Deno,
  name : String,
) -> @js.Promise[@js.Js] {
  self.get("permissions").call1("revoke", @js.from_entries([("name", name)]))
  |> @js.identity
}

///| Time and Performance APIs

///|
/// Get high resolution time (uses performance.now())
pub extern "js" fn Deno::now(self : Deno) -> Double =
  #| (self) => performance.now()

///| File Handle APIs

///|
#external
pub type FsFile

///|
impl @js.JsImpl for FsFile

///|
/// Open a file
pub fn Deno::open(
  self : Deno,
  path : String,
  create? : Bool,
  write? : Bool,
  read? : Bool,
) -> @js.Promise[FsFile] {
  self.call("open", [
    @js.js(path),
    @js.from_entries_option_cast([
      ("create", create),
      ("write", write),
      ("read", read),
    ]),
  ])
  |> @js.identity
}

///|
/// Create a file
pub fn Deno::create(self : Deno, path : String) -> @js.Promise[FsFile] {
  self.call("create", [@js.js(path)]) |> @js.identity
}

///|
/// Close file handle
pub fn FsFile::close(self : FsFile) -> Unit {
  self.call("close", []) |> ignore
}

///|
/// Read from file
pub fn FsFile::read(self : FsFile, buffer : @js.Js) -> @js.Promise[Int] {
  self.call("read", [buffer]) |> @js.identity
}

///|
/// Write to file
pub fn FsFile::write(self : FsFile, data : @js.Js) -> @js.Promise[Int] {
  self.call("write", [data]) |> @js.identity
}

///|
/// Seek file position
pub fn FsFile::seek(
  self : FsFile,
  offset : Int,
  whence : Int,
) -> @js.Promise[Int] {
  self.call("seek", [@js.js(offset), @js.js(whence)]) |> @js.identity
}

///| Test APIs

///|
#external
pub type TestContext

///|
pub impl @js.JsImpl for TestContext

///|
/// Deno.test(name, fn)
pub fn Deno::test_(
  self : Deno,
  name : String,
  f : (TestContext) -> Unit,
) -> Unit {
  self.call("test", [@js.js(name), @js.from_fn1(f)]) |> ignore
}

///|
/// Deno.test(name, async fn)
pub fn Deno::test_async(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  self.call("test", [@js.js(name), @js.promisify1(f) |> @js.from_fn1]) |> ignore
}

///|
/// Deno.test with options (simplified - use only for testing async functions with basic options)
pub fn Deno::test_only(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  self.call("test", [
    @js.from_entries([
      ("name", name),
      ("only", true),
      ("fn", @js.promisify1(f) |> @js.from_fn1),
    ]),
  ])
  |> ignore
}
