///|
/// Deno namespace
/// https://docs.deno.com/api/deno/

///|
#external
pub type Deno

///|
pub fn Deno::as_any(self : Deno) -> @nostd.Any = "%identity"

///|
/// Deno global object
pub extern "js" fn deno() -> Deno =
  #| () => Deno

///| Process/Runtime APIs

///|
/// Get environment variable
pub fn Deno::env_get(self : Deno, key : String) -> String? {
  self.as_any()["env"]._call("get", [@nostd.any(key)]).cast()
  |> @nostd.identity_option
}

///|
/// Set environment variable
pub fn Deno::env_set(self : Deno, key : String, value : String) -> Unit {
  self.as_any()["env"]._call("set", [@nostd.any(key), @nostd.any(value)])
  |> ignore
}

///|
/// Delete environment variable
pub fn Deno::env_delete(self : Deno, key : String) -> Unit {
  self.as_any()["env"]._call("delete", [@nostd.any(key)]) |> ignore
}

///|
/// Get all environment variables
pub fn Deno::env_toObject(self : Deno) -> @nostd.Any {
  self.as_any()["env"]._call("toObject", []).cast()
}

///|
/// Get current working directory
pub fn Deno::cwd(self : Deno) -> String {
  self.as_any()._call("cwd", []).cast()
}

///|
/// Exit the process
pub fn Deno::exit(self : Deno, code? : Int) -> Unit {
  match code {
    Some(c) => self.as_any()._call("exit", [@nostd.any(c)]) |> ignore
    None => self.as_any()._call("exit", []) |> ignore
  }
}

///|
/// Get command line arguments
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Deno::args(self : Deno) -> Array[String] {
  self.as_any()["args"].cast()
}

///|
/// Get process ID
pub fn Deno::pid(self : Deno) -> Int {
  self.as_any()["pid"].cast()
}

///|
/// Get parent process ID
pub fn Deno::ppid(self : Deno) -> Int {
  self.as_any()["ppid"].cast()
}

///|
/// Get operating system
pub fn Deno::build_os(self : Deno) -> String {
  self.as_any()["build"]["os"].cast()
}

///|
/// Get architecture
pub fn Deno::build_arch(self : Deno) -> String {
  self.as_any()["build"]["arch"].cast()
}

///|
/// Read all data from stdin
pub async fn Deno::stdin_read(self : Deno) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self.as_any()["stdin"]
    ._call("read", [])
    .cast()
  promise.wait()
}

///|
/// Write to stdout
pub async fn Deno::stdout_write(self : Deno, data : @nostd.Any) -> Int {
  let data_any : @nostd.Any = data.cast()
  let promise : @js.Promise[Int] = self.as_any()["stdout"]
    ._call("write", [data_any])
    .cast()
  promise.wait()
}

///|
/// Write to stderr
pub async fn Deno::stderr_write(self : Deno, data : @nostd.Any) -> Int {
  let data_any : @nostd.Any = data.cast()
  let promise : @js.Promise[Int] = self.as_any()["stderr"]
    ._call("write", [data_any])
    .cast()
  promise.wait()
}

///| File System APIs

///|
/// Read text file
pub async fn Deno::readTextFile(self : Deno, path : String) -> String {
  let promise : @js.Promise[String] = self
    .as_any()
    ._call("readTextFile", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Write text file
pub async fn Deno::writeTextFile(
  self : Deno,
  path : String,
  data : String,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("writeTextFile", [@nostd.any(path), @nostd.any(data)])
    .cast()
  promise.wait()
}

///|
/// Read file as Uint8Array
pub async fn Deno::readFile(
  self : Deno,
  path : String,
) -> @typedarray.Uint8Array {
  let promise : @js.Promise[@typedarray.Uint8Array] = self
    .as_any()
    ._call("readFile", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Write file from Uint8Array or ArrayBuffer
pub async fn Deno::writeFile(
  self : Deno,
  path : String,
  data : @nostd.Any,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("writeFile", [@nostd.any(path), data])
    .cast()
  promise.wait()
}

///|
/// Remove file or directory
pub async fn Deno::remove(
  self : Deno,
  path : String,
  recursive? : Bool,
) -> Unit {
  let promise : @js.Promise[Unit] = match recursive {
    Some(r) =>
      self
      .as_any()
      ._call("remove", [
        @nostd.any(path),
        @mbtconv.from_option_map({ "recursive": Some(@nostd.any(r)) }).cast(),
      ])
      .cast()
    None => self.as_any()._call("remove", [@nostd.any(path)]).cast()
  }
  promise.wait()
}

///|
/// Create directory
pub async fn Deno::mkdir(self : Deno, path : String, recursive? : Bool) -> Unit {
  let promise : @js.Promise[Unit] = match recursive {
    Some(r) =>
      self
      .as_any()
      ._call("mkdir", [
        @nostd.any(path),
        @mbtconv.from_option_map({ "recursive": Some(@nostd.any(r)) }).cast(),
      ])
      .cast()
    None => self.as_any()._call("mkdir", [@nostd.any(path)]).cast()
  }
  promise.wait()
}

///|
/// Read directory entries
pub fn Deno::readDir(self : Deno, path : String) -> @nostd.Any {
  self.as_any()._call("readDir", [@nostd.any(path)]).cast()
}

///|
/// Rename/move file or directory
pub async fn Deno::rename(
  self : Deno,
  oldpath : String,
  newpath : String,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("rename", [@nostd.any(oldpath), @nostd.any(newpath)])
    .cast()
  promise.wait()
}

///|
/// Copy file
pub async fn Deno::copyFile(self : Deno, from : String, to : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("copyFile", [@nostd.any(from), @nostd.any(to)])
    .cast()
  promise.wait()
}

///|
/// Check if path exists
pub async fn Deno::stat(self : Deno, path : String) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self
    .as_any()
    ._call("stat", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Check if path exists (returns null if not found instead of throwing)
pub async fn Deno::lstat(self : Deno, path : String) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self
    .as_any()
    ._call("lstat", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Read link target
pub async fn Deno::readLink(self : Deno, path : String) -> String {
  let promise : @js.Promise[String] = self
    .as_any()
    ._call("readLink", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Create symbolic link
pub async fn Deno::symlink(self : Deno, target : String, path : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("symlink", [@nostd.any(target), @nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Change file permissions (Unix only)
pub async fn Deno::chmod(self : Deno, path : String, mode : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("chmod", [@nostd.any(path), @nostd.any(mode)])
    .cast()
  promise.wait()
}

///|
/// Get real path (resolves symlinks)
pub async fn Deno::realPath(self : Deno, path : String) -> String {
  let promise : @js.Promise[String] = self
    .as_any()
    ._call("realPath", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Truncate or extend a file to specified length
pub async fn Deno::truncate(self : Deno, name : String, len : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("truncate", [@nostd.any(name), @nostd.any(len)])
    .cast()
  promise.wait()
}

///|
/// Make temporary directory
pub async fn Deno::makeTempDir(self : Deno, prefix? : String) -> String {
  let promise : @js.Promise[String] = match prefix {
    Some(p) =>
      self
      .as_any()
      ._call("makeTempDir", [
        @mbtconv.from_option_map({ "prefix": Some(@nostd.any(p)) }).cast(),
      ])
      .cast()
    None => self.as_any()._call("makeTempDir", []).cast()
  }
  promise.wait()
}

///|
/// Make temporary file
pub async fn Deno::makeTempFile(self : Deno, prefix? : String) -> String {
  let promise : @js.Promise[String] = match prefix {
    Some(p) =>
      self
      .as_any()
      ._call("makeTempFile", [
        @mbtconv.from_option_map({ "prefix": Some(@nostd.any(p)) }).cast(),
      ])
      .cast()
    None => self.as_any()._call("makeTempFile", []).cast()
  }
  promise.wait()
}

///|
/// Get hostname
pub fn Deno::hostname(self : Deno) -> String {
  self.as_any()._call("hostname", []).cast()
}

///|
/// Get OS release version
pub fn Deno::osRelease(self : Deno) -> String {
  self.as_any()._call("osRelease", []).cast()
}

///|
/// Get OS uptime in seconds
pub fn Deno::osUptime(self : Deno) -> Int {
  self.as_any()._call("osUptime", []).cast()
}

///|
/// Get system load average (Unix only)
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Deno::loadavg(self : Deno) -> Array[Double] {
  self.as_any()._call("loadavg", []).cast()
}

///|
/// Get network interfaces
pub fn Deno::networkInterfaces(self : Deno) -> @nostd.Any {
  self.as_any()._call("networkInterfaces", []).cast()
}

///|
/// Get system memory info
pub fn Deno::systemMemoryInfo(self : Deno) -> @nostd.Any {
  self.as_any()._call("systemMemoryInfo", []).cast()
}

///|
/// Get user ID (Unix only)
pub fn Deno::uid(self : Deno) -> Int? {
  self.as_any()._call("uid", []).cast() |> @js.identity_option
}

///|
/// Get group ID (Unix only)
pub fn Deno::gid(self : Deno) -> Int? {
  self.as_any()._call("gid", []).cast() |> @js.identity_option
}

///| Network APIs

///|
/// Open a network connection (TCP)
pub async fn Deno::connect(
  self : Self,
  hostname : String,
  port : Int,
) -> @nostd.Any {
  let opts : @nostd.Any = @mbtconv.from_map({
    "hostname": @nostd.any(hostname),
    "port": @nostd.any(port),
  }).cast()
  let promise : @js.Promise[@nostd.Any] = self
    .as_any()
    ._call("connect", [opts])
    .cast()
  promise.wait()
}

///|
/// Listen on a network address (TCP server)
pub fn Deno::listen(self : Deno, hostname : String, port : Int) -> @nostd.Any {
  let opts : @nostd.Any = @mbtconv.from_map({
    "hostname": @nostd.any(hostname),
    "port": @nostd.any(port),
  }).cast()
  self.as_any()._call("listen", [opts]).cast()
}

///|
/// Resolve DNS hostname to IP addresses
pub async fn Deno::resolveDns(
  self : Deno,
  query : String,
  recordType : String,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self
    .as_any()
    ._call("resolveDns", [@nostd.any(query), @nostd.any(recordType)])
    .cast()
  promise.wait()
}

///| HTTP Server APIs

///|
/// Serve HTTP requests (simplified version)
pub fn Deno::serve(self : Deno, port : Int, handler : @nostd.Any) -> @nostd.Any {
  let opts : @nostd.Any = @mbtconv.from_map({
    "port": @nostd.any(port),
    "handler": handler.cast(),
  }).cast()
  self.as_any()._call("serve", [opts]).cast()
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
pub fn FsFile::as_any(self : FsFile) -> @nostd.Any = "%identity"

///|
/// Open a file
pub async fn Deno::open(
  self : Deno,
  path : String,
  create? : Bool,
  write? : Bool,
  read? : Bool,
) -> FsFile {
  let opts : @nostd.Any = @mbtconv.from_option_map({
    "create": create.map(fn(x) { @nostd.any(x) }),
    "write": write.map(fn(x) { @nostd.any(x) }),
    "read": read.map(fn(x) { @nostd.any(x) }),
  }).cast()
  let promise : @js.Promise[FsFile] = self
    .as_any()
    ._call("open", [@nostd.any(path), opts])
    .cast()
  promise.wait()
}

///|
/// Create a file
pub async fn Deno::create(self : Deno, path : String) -> FsFile {
  let promise : @js.Promise[FsFile] = self
    .as_any()
    ._call("create", [@nostd.any(path)])
    .cast()
  promise.wait()
}

///|
/// Close file handle
pub fn FsFile::close(self : FsFile) -> Unit {
  self.as_any()._call("close", []) |> ignore
}

///|
/// Read from file
pub async fn FsFile::read(self : FsFile, buffer : @nostd.Any) -> Int {
  let buffer_any : @nostd.Any = buffer.cast()
  let promise : @js.Promise[Int] = self
    .as_any()
    ._call("read", [buffer_any])
    .cast()
  promise.wait()
}

///|
/// Write to file
pub async fn FsFile::write(self : FsFile, data : @nostd.Any) -> Int {
  let data_any : @nostd.Any = data.cast()
  let promise : @js.Promise[Int] = self
    .as_any()
    ._call("write", [data_any])
    .cast()
  promise.wait()
}

///|
/// Seek file position
pub async fn FsFile::seek(self : FsFile, offset : Int, whence : Int) -> Int {
  let promise : @js.Promise[Int] = self
    .as_any()
    ._call("seek", [@nostd.any(offset), @nostd.any(whence)])
    .cast()
  promise.wait()
}

///| Test APIs

///|
#external
pub type TestContext

///|
pub fn TestContext::as_any(self : TestContext) -> @nostd.Any = "%identity"

///|
/// Deno.test(name, fn)
pub fn Deno::test_(
  self : Deno,
  name : String,
  f : (TestContext) -> Unit,
) -> Unit {
  let fn_any : @nostd.Any = @js.from_fn1(f).cast()
  self.as_any()._call("test", [@nostd.any(name), fn_any]) |> ignore
}

///|
/// Deno.test(name, async fn)
pub fn Deno::test_async(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  let fn_any : @nostd.Any = (@js.promisify1(f) |> @js.from_fn1).cast()
  self.as_any()._call("test", [@nostd.any(name), fn_any]) |> ignore
}

///|
/// Deno.test with options (simplified - use only for testing async functions with basic options)
pub fn Deno::test_only(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  let opts : @nostd.Any = @mbtconv.from_map({
    "name": @nostd.any(name),
    "only": @nostd.any(true),
    "fn": (@js.promisify1(f) |> @js.from_fn1).cast(),
  }).cast()
  self.as_any()._call("test", [opts]) |> ignore
}

///| Subprocess APIs (Deno.Command)

///|
/// Command type for creating subprocesses
/// https://docs.deno.com/api/deno/~/Deno.Command
#external
pub type Command

///|
pub fn Command::as_any(self : Command) -> @nostd.Any = "%identity"

///|
/// Create a new Command
/// https://docs.deno.com/api/deno/~/Deno.Command
extern "js" fn ffi_new_command(
  program : String,
  args : @nostd.Any,
  cwd : @nostd.Any,
  env : @nostd.Any,
  stdin : @nostd.Any,
  stdout : @nostd.Any,
  stderr : @nostd.Any,
) -> Command =
  #| (program, args, cwd, env, stdin, stdout, stderr) => {
  #|   const opts = {};
  #|   if (args !== undefined) opts.args = args;
  #|   if (cwd !== undefined) opts.cwd = cwd;
  #|   if (env !== undefined) opts.env = env;
  #|   if (stdin !== undefined) opts.stdin = stdin;
  #|   if (stdout !== undefined) opts.stdout = stdout;
  #|   if (stderr !== undefined) opts.stderr = stderr;
  #|   return new Deno.Command(program, opts);
  #| }

///|
/// Create a new Command to run a program
pub fn Command::new(
  program : String,
  args? : Array[String],
  cwd? : String,
  env? : @nostd.Any,
  stdin? : String,
  stdout? : String,
  stderr? : String,
) -> Command {
  ffi_new_command(
    program,
    args
    .map(fn(a) { @nostd.any(a.map(fn(s) { @nostd.any(s) })) })
    .unwrap_or(@global.undefined()),
    cwd.map(fn(c) { @nostd.any(c) }).unwrap_or(@global.undefined()),
    env.unwrap_or(@global.undefined()),
    stdin.map(fn(s) { @nostd.any(s) }).unwrap_or(@global.undefined()),
    stdout.map(fn(s) { @nostd.any(s) }).unwrap_or(@global.undefined()),
    stderr.map(fn(s) { @nostd.any(s) }).unwrap_or(@global.undefined()),
  )
}

///|
/// CommandOutput - result of Command.output()
#external
pub type CommandOutput

///|
pub fn CommandOutput::as_any(self : CommandOutput) -> @nostd.Any = "%identity"

///|
/// Get exit code from CommandOutput
pub fn CommandOutput::code(self : CommandOutput) -> Int {
  self.as_any()["code"].cast()
}

///|
/// Check if command succeeded (exit code 0)
pub fn CommandOutput::success(self : CommandOutput) -> Bool {
  self.as_any()["success"].cast()
}

///|
/// Get stdout as Uint8Array
pub fn CommandOutput::stdout(self : CommandOutput) -> @typedarray.Uint8Array {
  self.as_any()["stdout"].cast()
}

///|
/// Get stderr as Uint8Array
pub fn CommandOutput::stderr(self : CommandOutput) -> @typedarray.Uint8Array {
  self.as_any()["stderr"].cast()
}

///|
/// Get signal that terminated the process (if any)
pub fn CommandOutput::signal(self : CommandOutput) -> String? {
  self.as_any()["signal"].cast() |> @js.identity_option
}

///|
/// Execute command and collect output
/// https://docs.deno.com/api/deno/~/Deno.Command#method_output_0
pub async fn Command::output(self : Command) -> CommandOutput {
  let promise : @js.Promise[CommandOutput] = self
    .as_any()
    ._call("output", [])
    .cast()
  promise.wait()
}

///|
/// Execute command synchronously and collect output
/// https://docs.deno.com/api/deno/~/Deno.Command#method_outputSync_0
#alias(output_sync)
pub fn Command::outputSync(self : Command) -> CommandOutput {
  self.as_any()._call("outputSync", []).cast()
}

///|
/// ChildProcess - spawned subprocess
/// https://docs.deno.com/api/deno/~/Deno.ChildProcess
#external
pub type ChildProcess

///|
pub fn ChildProcess::as_any(self : ChildProcess) -> @nostd.Any = "%identity"

///|
/// Get process ID
pub fn ChildProcess::pid(self : ChildProcess) -> Int {
  self.as_any()["pid"].cast()
}

///|
/// Get stdin stream (WritableStream)
pub fn ChildProcess::stdin(self : ChildProcess) -> @nostd.Any {
  self.as_any()["stdin"].cast()
}

///|
/// Get stdout stream (ReadableStream)
pub fn ChildProcess::stdout(self : ChildProcess) -> @nostd.Any {
  self.as_any()["stdout"].cast()
}

///|
/// Get stderr stream (ReadableStream)
pub fn ChildProcess::stderr(self : ChildProcess) -> @nostd.Any {
  self.as_any()["stderr"].cast()
}

///|
/// CommandStatus - result of waiting for process
#external
pub type CommandStatus

///|
pub fn CommandStatus::as_any(self : CommandStatus) -> @nostd.Any = "%identity"

///|
/// Get exit code from CommandStatus
pub fn CommandStatus::code(self : CommandStatus) -> Int {
  self.as_any()["code"].cast()
}

///|
/// Check if command succeeded
pub fn CommandStatus::success(self : CommandStatus) -> Bool {
  self.as_any()["success"].cast()
}

///|
/// Get signal that terminated the process (if any)
pub fn CommandStatus::signal(self : CommandStatus) -> String? {
  self.as_any()["signal"].cast() |> @js.identity_option
}

///|
/// Wait for process to complete
pub async fn ChildProcess::status(self : ChildProcess) -> CommandStatus {
  let promise : @js.Promise[CommandStatus] = self.as_any()["status"].cast()
  promise.wait()
}

///|
/// Send signal to process
pub fn ChildProcess::kill(self : ChildProcess, signal? : String) -> Unit {
  match signal {
    Some(s) => self.as_any()._call("kill", [@nostd.any(s)]) |> ignore
    None => self.as_any()._call("kill", []) |> ignore
  }
}

///|
/// Prevent process from keeping event loop alive
pub fn ChildProcess::unref(self : ChildProcess) -> Unit {
  self.as_any()._call("unref", []) |> ignore
}

///|
/// Allow process to keep event loop alive (default)
pub fn ChildProcess::ref_(self : ChildProcess) -> Unit {
  self.as_any()._call("ref", []) |> ignore
}

///|
/// Spawn a subprocess
/// https://docs.deno.com/api/deno/~/Deno.Command#method_spawn_0
pub fn Command::spawn(self : Command) -> ChildProcess {
  self.as_any()._call("spawn", []).cast()
}
