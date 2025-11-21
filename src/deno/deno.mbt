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
  self.get("env").call("get", [@js.js(key)]) |> @js.unsafe_cast_option
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
pub fn Deno::env_toObject(self : Deno) -> Js {
  self.get("env").call("toObject", [])
}

///|
/// Get current working directory
pub fn Deno::cwd(self : Deno) -> String {
  self.call("cwd", []) |> @js.unsafe_cast
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
  self.get("args") |> @js.unsafe_cast
}

///|
/// Get process ID
pub fn Deno::pid(self : Deno) -> Int {
  self.get("pid") |> @js.unsafe_cast
}

///|
/// Get parent process ID
pub fn Deno::ppid(self : Deno) -> Int {
  self.get("ppid") |> @js.unsafe_cast
}

///|
/// Get operating system
pub fn Deno::build_os(self : Deno) -> String {
  self.get("build").get("os") |> @js.unsafe_cast
}

///|
/// Get architecture
pub fn Deno::build_arch(self : Deno) -> String {
  self.get("build").get("arch") |> @js.unsafe_cast
}

///|
/// Read all data from stdin
pub fn Deno::stdin_read(self : Deno) -> Promise[Js] {
  self.get("stdin").call("read", []) |> @js.unsafe_cast
}

///|
/// Write to stdout
pub fn Deno::stdout_write(self : Deno, data : Js) -> Promise[Int] {
  self.get("stdout").call("write", [data]) |> @js.unsafe_cast
}

///|
/// Write to stderr
pub fn Deno::stderr_write(self : Deno, data : Js) -> Promise[Int] {
  self.get("stderr").call("write", [data]) |> @js.unsafe_cast
}

///| File System APIs

///|
/// Read text file
pub fn Deno::readTextFile(self : Deno, path : String) -> Promise[String] {
  self.call("readTextFile", [@js.js(path)]) |> @js.unsafe_cast
}

///|
/// Write text file
pub fn Deno::writeTextFile(
  self : Deno,
  path : String,
  data : String,
) -> Promise[Unit] {
  self.call("writeTextFile", [@js.js(path), @js.js(data)]) |> @js.unsafe_cast
}

///|
/// Read file as Uint8Array
pub fn Deno::readFile(self : Deno, path : String) -> Promise[Js] {
  self.call("readFile", [@js.js(path)]) |> @js.unsafe_cast
}

///|
/// Write file from Uint8Array
pub fn Deno::writeFile(self : Deno, path : String, data : Js) -> Promise[Unit] {
  self.call("writeFile", [@js.js(path), data]) |> @js.unsafe_cast
}

///|
/// Remove file or directory
pub fn Deno::remove(
  self : Deno,
  path : String,
  recursive? : Bool,
) -> Promise[Unit] {
  match recursive {
    Some(r) =>
      self.call("remove", [
        @js.js(path),
        @js.from_entries_option_cast([("recursive", Some(r))]),
      ])
      |> @js.unsafe_cast
    None => self.call("remove", [@js.js(path)]) |> @js.unsafe_cast
  }
}

///|
/// Create directory
pub fn Deno::mkdir(
  self : Deno,
  path : String,
  recursive? : Bool,
) -> Promise[Unit] {
  match recursive {
    Some(r) =>
      self.call("mkdir", [
        @js.js(path),
        @js.from_entries_option_cast([("recursive", Some(r))]),
      ])
      |> @js.unsafe_cast
    None => self.call("mkdir", [@js.js(path)]) |> @js.unsafe_cast
  }
}

///|
/// Read directory entries
pub fn Deno::readDir(self : Deno, path : String) -> Js {
  self.call("readDir", [@js.js(path)])
}

///|
/// Rename/move file or directory
pub fn Deno::rename(
  self : Deno,
  oldpath : String,
  newpath : String,
) -> Promise[Unit] {
  self.call("rename", [@js.js(oldpath), @js.js(newpath)]) |> @js.unsafe_cast
}

///|
/// Copy file
pub fn Deno::copyFile(self : Deno, from : String, to : String) -> Promise[Unit] {
  self.call("copyFile", [@js.js(from), @js.js(to)]) |> @js.unsafe_cast
}

///|
/// Check if path exists
pub fn Deno::stat(self : Deno, path : String) -> Promise[Js] {
  self.call("stat", [@js.js(path)]) |> @js.unsafe_cast
}

///|
/// Check if path exists (returns null if not found instead of throwing)
pub fn Deno::lstat(self : Deno, path : String) -> Promise[Js] {
  self.call("lstat", [@js.js(path)]) |> @js.unsafe_cast
}

///|
/// Read link target
pub fn Deno::readLink(self : Deno, path : String) -> Promise[String] {
  self.call("readLink", [@js.js(path)]) |> @js.unsafe_cast
}

///|
/// Create symbolic link
pub fn Deno::symlink(
  self : Deno,
  target : String,
  path : String,
) -> Promise[Unit] {
  self.call("symlink", [@js.js(target), @js.js(path)]) |> @js.unsafe_cast
}

///|
/// Change file permissions (Unix only)
pub fn Deno::chmod(self : Deno, path : String, mode : Int) -> Promise[Unit] {
  self.call("chmod", [@js.js(path), @js.js(mode)]) |> @js.unsafe_cast
}

///|
/// Get real path (resolves symlinks)
pub fn Deno::realPath(self : Deno, path : String) -> Promise[String] {
  self.call("realPath", [@js.js(path)]) |> @js.unsafe_cast
}

///|
/// Truncate or extend a file to specified length
pub fn Deno::truncate(self : Deno, name : String, len : Int) -> Promise[Unit] {
  self.call("truncate", [@js.js(name), @js.js(len)]) |> @js.unsafe_cast
}

///|
/// Make temporary directory
pub fn Deno::makeTempDir(self : Deno, prefix? : String) -> Promise[String] {
  match prefix {
    Some(p) =>
      self.call("makeTempDir", [
        @js.from_entries_option_cast([("prefix", Some(p))]),
      ])
      |> @js.unsafe_cast
    None => self.call("makeTempDir", []) |> @js.unsafe_cast
  }
}

///|
/// Make temporary file
pub fn Deno::makeTempFile(self : Deno, prefix? : String) -> Promise[String] {
  match prefix {
    Some(p) =>
      self.call("makeTempFile", [
        @js.from_entries_option_cast([("prefix", Some(p))]),
      ])
      |> @js.unsafe_cast
    None => self.call("makeTempFile", []) |> @js.unsafe_cast
  }
}

///|
/// Get hostname
pub fn Deno::hostname(self : Deno) -> String {
  self.call("hostname", []) |> @js.unsafe_cast
}

///|
/// Get OS release version
pub fn Deno::osRelease(self : Deno) -> String {
  self.call("osRelease", []) |> @js.unsafe_cast
}

///|
/// Get OS uptime in seconds
pub fn Deno::osUptime(self : Deno) -> Int {
  self.call("osUptime", []) |> @js.unsafe_cast
}

///|
/// Get system load average (Unix only)
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Deno::loadavg(self : Deno) -> Array[Double] {
  self.call("loadavg", []) |> @js.unsafe_cast
}

///|
/// Get network interfaces
pub fn Deno::networkInterfaces(self : Deno) -> Js {
  self.call("networkInterfaces", [])
}

///|
/// Get system memory info
pub fn Deno::systemMemoryInfo(self : Deno) -> Js {
  self.call("systemMemoryInfo", [])
}

///|
/// Get user ID (Unix only)
pub fn Deno::uid(self : Deno) -> Int? {
  self.call("uid", []) |> @js.unsafe_cast_option
}

///|
/// Get group ID (Unix only)
pub fn Deno::gid(self : Deno) -> Int? {
  self.call("gid", []) |> @js.unsafe_cast_option
}

///| Network APIs

///|
/// Open a network connection (TCP)
pub fn Deno::connect(self : Self, hostname : String, port : Int) -> Promise[Js] {
  self.call("connect", [
    @js.from_entries([("hostname", hostname), ("port", port)]),
  ])
  |> @js.unsafe_cast
}

///|
/// Listen on a network address (TCP server)
pub fn Deno::listen(self : Deno, hostname : String, port : Int) -> Js {
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
) -> Promise[Js] {
  self.call("resolveDns", [@js.js(query), @js.js(recordType)])
  |> @js.unsafe_cast
}

///| HTTP Server APIs

///|
/// Serve HTTP requests (simplified version)
pub fn Deno::serve(self : Deno, port : Int, handler : Js) -> Js {
  self.call1("serve", @js.from_entries([("port", port), ("handler", handler)]))
}

///| Permissions APIs

///|
/// Request permission
pub fn Deno::request_permission(self : Self, name : String) -> Promise[Js] {
  self.get("permissions").call1("request", @js.from_entries([("name", name)]))
  |> @js.unsafe_cast
}

///|
/// Query permission status
pub fn Deno::query_permission(self : Deno, name : String) -> Promise[Js] {
  self.get("permissions").call1("query", @js.from_entries([("name", name)]))
  |> @js.unsafe_cast
}

///|
/// Revoke permission
pub fn Deno::revoke_permission(self : Deno, name : String) -> Promise[Js] {
  self.get("permissions").call1("revoke", @js.from_entries([("name", name)]))
  |> @js.unsafe_cast
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
) -> Promise[FsFile] {
  self.call("open", [
    @js.js(path),
    @js.from_entries_option_cast([
      ("create", create),
      ("write", write),
      ("read", read),
    ]),
  ])
  |> @js.unsafe_cast
}

///|
/// Create a file
pub fn Deno::create(self : Deno, path : String) -> Promise[FsFile] {
  self.call("create", [@js.js(path)]) |> @js.unsafe_cast
}

///|
/// Close file handle
pub fn FsFile::close(self : FsFile) -> Unit {
  self.call("close", []) |> ignore
}

///|
/// Read from file
pub fn FsFile::read(self : FsFile, buffer : Js) -> Promise[Int] {
  self.call("read", [buffer]) |> @js.unsafe_cast
}

///|
/// Write to file
pub fn FsFile::write(self : FsFile, data : Js) -> Promise[Int] {
  self.call("write", [data]) |> @js.unsafe_cast
}

///|
/// Seek file position
pub fn FsFile::seek(self : FsFile, offset : Int, whence : Int) -> Promise[Int] {
  self.call("seek", [@js.js(offset), @js.js(whence)]) |> @js.unsafe_cast
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
  self.call("test", [@js.js(name), promisify1(f) |> @js.from_fn1]) |> ignore
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
      ("fn", promisify1(f) |> @js.from_fn1),
    ]),
  ])
  |> ignore
}
