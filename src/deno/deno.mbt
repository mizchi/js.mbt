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
  self.get("env").call("get", [@js.any(key)]).cast() |> @js.identity_option
}

///|
/// Set environment variable
pub fn Deno::env_set(self : Deno, key : String, value : String) -> Unit {
  self.get("env").call("set", [@js.any(key), @js.any(value)]) |> ignore
}

///|
/// Delete environment variable
pub fn Deno::env_delete(self : Deno, key : String) -> Unit {
  self.get("env").call("delete", [@js.any(key)]) |> ignore
}

///|
/// Get all environment variables
pub fn Deno::env_toObject(self : Deno) -> @js.Any {
  self.get("env").call("toObject", [])
}

///|
/// Get current working directory
pub fn Deno::cwd(self : Deno) -> String {
  self.call("cwd", []).cast()
}

///|
/// Exit the process
pub fn Deno::exit(self : Deno, code? : Int) -> Unit {
  match code {
    Some(c) => self.call("exit", [@js.any(c)]) |> ignore
    None => self.call("exit", []) |> ignore
  }
}

///|
/// Get command line arguments
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Deno::args(self : Deno) -> Array[String] {
  self.get("args").cast()
}

///|
/// Get process ID
pub fn Deno::pid(self : Deno) -> Int {
  self.get("pid").cast()
}

///|
/// Get parent process ID
pub fn Deno::ppid(self : Deno) -> Int {
  self.get("ppid").cast()
}

///|
/// Get operating system
pub fn Deno::build_os(self : Deno) -> String {
  self.get("build").get("os").cast()
}

///|
/// Get architecture
pub fn Deno::build_arch(self : Deno) -> String {
  self.get("build").get("arch").cast()
}

///|
/// Read all data from stdin
pub fn Deno::stdin_read(self : Deno) -> @js.Promise[@js.Any] {
  self.get("stdin").call("read", []).cast()
}

///|
/// Write to stdout
pub fn Deno::stdout_write(self : Deno, data : @js.Any) -> @js.Promise[Int] {
  self.get("stdout").call("write", [data]).cast()
}

///|
/// Write to stderr
pub fn Deno::stderr_write(self : Deno, data : @js.Any) -> @js.Promise[Int] {
  self.get("stderr").call("write", [data]).cast()
}

///| File System APIs

///|
/// Read text file
pub fn Deno::readTextFile(self : Deno, path : String) -> @js.Promise[String] {
  self.call("readTextFile", [@js.any(path)]).cast()
}

///|
/// Write text file
pub fn Deno::writeTextFile(
  self : Deno,
  path : String,
  data : String,
) -> @js.Promise[Unit] {
  self.call("writeTextFile", [@js.any(path), @js.any(data)]).cast()
}

///|
/// Read file as Uint8Array
pub fn Deno::readFile(self : Deno, path : String) -> @js.Promise[@js.Any] {
  self.call("readFile", [@js.any(path)]).cast()
}

///|
/// Write file from Uint8Array
pub fn Deno::writeFile(
  self : Deno,
  path : String,
  data : @js.Any,
) -> @js.Promise[Unit] {
  self.call("writeFile", [@js.any(path), data]).cast()
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
      self
      .call("remove", [
        @js.any(path),
        @js.from_option_map({ "recursive": Some(@js.any(r)) }),
      ])
      .cast()
    None => self.call("remove", [@js.any(path)]).cast()
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
      self
      .call("mkdir", [
        @js.any(path),
        @js.from_option_map({ "recursive": Some(@js.any(r)) }),
      ])
      .cast()
    None => self.call("mkdir", [@js.any(path)]).cast()
  }
}

///|
/// Read directory entries
pub fn Deno::readDir(self : Deno, path : String) -> @js.Any {
  self.call("readDir", [@js.any(path)])
}

///|
/// Rename/move file or directory
pub fn Deno::rename(
  self : Deno,
  oldpath : String,
  newpath : String,
) -> @js.Promise[Unit] {
  self.call("rename", [@js.any(oldpath), @js.any(newpath)]).cast()
}

///|
/// Copy file
pub fn Deno::copyFile(
  self : Deno,
  from : String,
  to : String,
) -> @js.Promise[Unit] {
  self.call("copyFile", [@js.any(from), @js.any(to)]).cast()
}

///|
/// Check if path exists
pub fn Deno::stat(self : Deno, path : String) -> @js.Promise[@js.Any] {
  self.call("stat", [@js.any(path)]).cast()
}

///|
/// Check if path exists (returns null if not found instead of throwing)
pub fn Deno::lstat(self : Deno, path : String) -> @js.Promise[@js.Any] {
  self.call("lstat", [@js.any(path)]).cast()
}

///|
/// Read link target
pub fn Deno::readLink(self : Deno, path : String) -> @js.Promise[String] {
  self.call("readLink", [@js.any(path)]).cast()
}

///|
/// Create symbolic link
pub fn Deno::symlink(
  self : Deno,
  target : String,
  path : String,
) -> @js.Promise[Unit] {
  self.call("symlink", [@js.any(target), @js.any(path)]).cast()
}

///|
/// Change file permissions (Unix only)
pub fn Deno::chmod(self : Deno, path : String, mode : Int) -> @js.Promise[Unit] {
  self.call("chmod", [@js.any(path), @js.any(mode)]).cast()
}

///|
/// Get real path (resolves symlinks)
pub fn Deno::realPath(self : Deno, path : String) -> @js.Promise[String] {
  self.call("realPath", [@js.any(path)]).cast()
}

///|
/// Truncate or extend a file to specified length
pub fn Deno::truncate(
  self : Deno,
  name : String,
  len : Int,
) -> @js.Promise[Unit] {
  self.call("truncate", [@js.any(name), @js.any(len)]).cast()
}

///|
/// Make temporary directory
pub fn Deno::makeTempDir(self : Deno, prefix? : String) -> @js.Promise[String] {
  match prefix {
    Some(p) =>
      self
      .call("makeTempDir", [@js.from_option_map({ "prefix": Some(@js.any(p)) })])
      .cast()
    None => self.call("makeTempDir", []).cast()
  }
}

///|
/// Make temporary file
pub fn Deno::makeTempFile(self : Deno, prefix? : String) -> @js.Promise[String] {
  match prefix {
    Some(p) =>
      self
      .call("makeTempFile", [
        @js.from_option_map({ "prefix": Some(@js.any(p)) }),
      ])
      .cast()
    None => self.call("makeTempFile", []).cast()
  }
}

///|
/// Get hostname
pub fn Deno::hostname(self : Deno) -> String {
  self.call("hostname", []).cast()
}

///|
/// Get OS release version
pub fn Deno::osRelease(self : Deno) -> String {
  self.call("osRelease", []).cast()
}

///|
/// Get OS uptime in seconds
pub fn Deno::osUptime(self : Deno) -> Int {
  self.call("osUptime", []).cast()
}

///|
/// Get system load average (Unix only)
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Deno::loadavg(self : Deno) -> Array[Double] {
  self.call("loadavg", []).cast()
}

///|
/// Get network interfaces
pub fn Deno::networkInterfaces(self : Deno) -> @js.Any {
  self.call("networkInterfaces", [])
}

///|
/// Get system memory info
pub fn Deno::systemMemoryInfo(self : Deno) -> @js.Any {
  self.call("systemMemoryInfo", [])
}

///|
/// Get user ID (Unix only)
pub fn Deno::uid(self : Deno) -> Int? {
  self.call("uid", []).cast() |> @js.identity_option
}

///|
/// Get group ID (Unix only)
pub fn Deno::gid(self : Deno) -> Int? {
  self.call("gid", []).cast() |> @js.identity_option
}

///| Network APIs

///|
/// Open a network connection (TCP)
pub fn Deno::connect(
  self : Self,
  hostname : String,
  port : Int,
) -> @js.Promise[@js.Any] {
  self
  .call("connect", [
    @js.from_map({ "hostname": @js.any(hostname), "port": @js.any(port) }),
  ])
  .cast()
}

///|
/// Listen on a network address (TCP server)
pub fn Deno::listen(self : Deno, hostname : String, port : Int) -> @js.Any {
  self.call("listen", [
    @js.from_map({ "hostname": @js.any(hostname), "port": @js.any(port) }),
  ])
}

///|
/// Resolve DNS hostname to IP addresses
pub fn Deno::resolveDns(
  self : Deno,
  query : String,
  recordType : String,
) -> @js.Promise[@js.Any] {
  self.call("resolveDns", [@js.any(query), @js.any(recordType)]).cast()
}

///| HTTP Server APIs

///|
/// Serve HTTP requests (simplified version)
pub fn Deno::serve(self : Deno, port : Int, handler : @js.Any) -> @js.Any {
  self.call1(
    "serve",
    @js.from_map({ "port": @js.any(port), "handler": handler }),
  )
}

///| Permissions APIs

///|
/// Request permission
pub fn Deno::request_permission(
  self : Self,
  name : String,
) -> @js.Promise[@js.Any] {
  self
  .get("permissions")
  .call1("request", @js.from_map({ "name": @js.any(name) }))
  .cast()
}

///|
/// Query permission status
pub fn Deno::query_permission(
  self : Deno,
  name : String,
) -> @js.Promise[@js.Any] {
  self
  .get("permissions")
  .call1("query", @js.from_map({ "name": @js.any(name) }))
  .cast()
}

///|
/// Revoke permission
pub fn Deno::revoke_permission(
  self : Deno,
  name : String,
) -> @js.Promise[@js.Any] {
  self
  .get("permissions")
  .call1("revoke", @js.from_map({ "name": @js.any(name) }))
  .cast()
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
  self
  .call("open", [
    @js.any(path),
    @js.from_option_map({
      "create": create.map(fn(x) { @js.any(x) }),
      "write": write.map(fn(x) { @js.any(x) }),
      "read": read.map(fn(x) { @js.any(x) }),
    }),
  ])
  .cast()
}

///|
/// Create a file
pub fn Deno::create(self : Deno, path : String) -> @js.Promise[FsFile] {
  self.call("create", [@js.any(path)]).cast()
}

///|
/// Close file handle
pub fn FsFile::close(self : FsFile) -> Unit {
  self.call("close", []) |> ignore
}

///|
/// Read from file
pub fn FsFile::read(self : FsFile, buffer : @js.Any) -> @js.Promise[Int] {
  self.call("read", [buffer]).cast()
}

///|
/// Write to file
pub fn FsFile::write(self : FsFile, data : @js.Any) -> @js.Promise[Int] {
  self.call("write", [data]).cast()
}

///|
/// Seek file position
pub fn FsFile::seek(
  self : FsFile,
  offset : Int,
  whence : Int,
) -> @js.Promise[Int] {
  self.call("seek", [@js.any(offset), @js.any(whence)]).cast()
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
  self.call("test", [@js.any(name), @js.from_fn1(f)]) |> ignore
}

///|
/// Deno.test(name, async fn)
pub fn Deno::test_async(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  self.call("test", [@js.any(name), @js.promisify1(f) |> @js.from_fn1])
  |> ignore
}

///|
/// Deno.test with options (simplified - use only for testing async functions with basic options)
pub fn Deno::test_only(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  self.call("test", [
    @js.from_map({
      "name": @js.any(name),
      "only": @js.any(true),
      "fn": @js.promisify1(f) |> @js.from_fn1,
    }),
  ])
  |> ignore
}
