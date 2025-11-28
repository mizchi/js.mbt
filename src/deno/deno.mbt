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
  self.get("env").call1("get", @js.any(key)).cast() |> @js.identity_option
}

///|
/// Set environment variable
pub fn Deno::env_set(self : Deno, key : String, value : String) -> Unit {
  self.get("env").call2("set", @js.any(key), @js.any(value)) |> ignore
}

///|
/// Delete environment variable
pub fn Deno::env_delete(self : Deno, key : String) -> Unit {
  self.get("env").call1("delete", @js.any(key)) |> ignore
}

///|
/// Get all environment variables
pub fn Deno::env_toObject(self : Deno) -> @js.Any {
  self.get("env").call0("toObject")
}

///|
/// Get current working directory
pub fn Deno::cwd(self : Deno) -> String {
  self.call0("cwd").cast()
}

///|
/// Exit the process
pub fn Deno::exit(self : Deno, code? : Int) -> Unit {
  match code {
    Some(c) => self.call1("exit", @js.any(c)) |> ignore
    None => self.call0("exit") |> ignore
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
pub async fn Deno::stdin_read(self : Deno) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.get("stdin").call0("read").cast()
  promise.wait()
}

///|
/// Write to stdout
pub async fn Deno::stdout_write(self : Deno, data : @js.Any) -> Int {
  let promise : @js.Promise[Int] = self
    .get("stdout")
    .call1("write", data)
    .cast()
  promise.wait()
}

///|
/// Write to stderr
pub async fn Deno::stderr_write(self : Deno, data : @js.Any) -> Int {
  let promise : @js.Promise[Int] = self
    .get("stderr")
    .call1("write", data)
    .cast()
  promise.wait()
}

///| File System APIs

///|
/// Read text file
pub async fn Deno::readTextFile(self : Deno, path : String) -> String {
  let promise : @js.Promise[String] = self
    .call1("readTextFile", @js.any(path))
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
    .call2("writeTextFile", @js.any(path), @js.any(data))
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
    .call1("readFile", @js.any(path))
    .cast()
  promise.wait()
}

///|
/// Write file from Uint8Array or ArrayBuffer
pub async fn Deno::writeFile(
  self : Deno,
  path : String,
  data : &@js.JsImpl,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .call2("writeFile", @js.any(path), data)
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
      .call2(
        "remove",
        @js.any(path),
        @js.from_option_map({ "recursive": Some(@js.any(r)) }),
      )
      .cast()
    None => self.call1("remove", @js.any(path)).cast()
  }
  promise.wait()
}

///|
/// Create directory
pub async fn Deno::mkdir(self : Deno, path : String, recursive? : Bool) -> Unit {
  let promise : @js.Promise[Unit] = match recursive {
    Some(r) =>
      self
      .call2(
        "mkdir",
        @js.any(path),
        @js.from_option_map({ "recursive": Some(@js.any(r)) }),
      )
      .cast()
    None => self.call1("mkdir", @js.any(path)).cast()
  }
  promise.wait()
}

///|
/// Read directory entries
pub fn Deno::readDir(self : Deno, path : String) -> @js.Any {
  self.call1("readDir", @js.any(path))
}

///|
/// Rename/move file or directory
pub async fn Deno::rename(
  self : Deno,
  oldpath : String,
  newpath : String,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .call2("rename", @js.any(oldpath), @js.any(newpath))
    .cast()
  promise.wait()
}

///|
/// Copy file
pub async fn Deno::copyFile(self : Deno, from : String, to : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .call2("copyFile", @js.any(from), @js.any(to))
    .cast()
  promise.wait()
}

///|
/// Check if path exists
pub async fn Deno::stat(self : Deno, path : String) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.call1("stat", @js.any(path)).cast()
  promise.wait()
}

///|
/// Check if path exists (returns null if not found instead of throwing)
pub async fn Deno::lstat(self : Deno, path : String) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.call1("lstat", @js.any(path)).cast()
  promise.wait()
}

///|
/// Read link target
pub async fn Deno::readLink(self : Deno, path : String) -> String {
  let promise : @js.Promise[String] = self
    .call1("readLink", @js.any(path))
    .cast()
  promise.wait()
}

///|
/// Create symbolic link
pub async fn Deno::symlink(self : Deno, target : String, path : String) -> Unit {
  let promise : @js.Promise[Unit] = self
    .call2("symlink", @js.any(target), @js.any(path))
    .cast()
  promise.wait()
}

///|
/// Change file permissions (Unix only)
pub async fn Deno::chmod(self : Deno, path : String, mode : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .call2("chmod", @js.any(path), @js.any(mode))
    .cast()
  promise.wait()
}

///|
/// Get real path (resolves symlinks)
pub async fn Deno::realPath(self : Deno, path : String) -> String {
  let promise : @js.Promise[String] = self
    .call1("realPath", @js.any(path))
    .cast()
  promise.wait()
}

///|
/// Truncate or extend a file to specified length
pub async fn Deno::truncate(self : Deno, name : String, len : Int) -> Unit {
  let promise : @js.Promise[Unit] = self
    .call2("truncate", @js.any(name), @js.any(len))
    .cast()
  promise.wait()
}

///|
/// Make temporary directory
pub async fn Deno::makeTempDir(self : Deno, prefix? : String) -> String {
  let promise : @js.Promise[String] = match prefix {
    Some(p) =>
      self
      .call1("makeTempDir", @js.from_option_map({ "prefix": Some(@js.any(p)) }))
      .cast()
    None => self.call0("makeTempDir").cast()
  }
  promise.wait()
}

///|
/// Make temporary file
pub async fn Deno::makeTempFile(self : Deno, prefix? : String) -> String {
  let promise : @js.Promise[String] = match prefix {
    Some(p) =>
      self
      .call1(
        "makeTempFile",
        @js.from_option_map({ "prefix": Some(@js.any(p)) }),
      )
      .cast()
    None => self.call0("makeTempFile").cast()
  }
  promise.wait()
}

///|
/// Get hostname
pub fn Deno::hostname(self : Deno) -> String {
  self.call0("hostname").cast()
}

///|
/// Get OS release version
pub fn Deno::osRelease(self : Deno) -> String {
  self.call0("osRelease").cast()
}

///|
/// Get OS uptime in seconds
pub fn Deno::osUptime(self : Deno) -> Int {
  self.call0("osUptime").cast()
}

///|
/// Get system load average (Unix only)
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Deno::loadavg(self : Deno) -> Array[Double] {
  self.call0("loadavg").cast()
}

///|
/// Get network interfaces
pub fn Deno::networkInterfaces(self : Deno) -> @js.Any {
  self.call0("networkInterfaces")
}

///|
/// Get system memory info
pub fn Deno::systemMemoryInfo(self : Deno) -> @js.Any {
  self.call0("systemMemoryInfo")
}

///|
/// Get user ID (Unix only)
pub fn Deno::uid(self : Deno) -> Int? {
  self.call0("uid").cast() |> @js.identity_option
}

///|
/// Get group ID (Unix only)
pub fn Deno::gid(self : Deno) -> Int? {
  self.call0("gid").cast() |> @js.identity_option
}

///| Network APIs

///|
/// Open a network connection (TCP)
pub async fn Deno::connect(
  self : Self,
  hostname : String,
  port : Int,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call1(
      "connect",
      @js.from_map({ "hostname": @js.any(hostname), "port": @js.any(port) }),
    )
    .cast()
  promise.wait()
}

///|
/// Listen on a network address (TCP server)
pub fn Deno::listen(self : Deno, hostname : String, port : Int) -> @js.Any {
  self.call1(
    "listen",
    @js.from_map({ "hostname": @js.any(hostname), "port": @js.any(port) }),
  )
}

///|
/// Resolve DNS hostname to IP addresses
pub async fn Deno::resolveDns(
  self : Deno,
  query : String,
  recordType : String,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .call2("resolveDns", @js.any(query), @js.any(recordType))
    .cast()
  promise.wait()
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
pub async fn Deno::open(
  self : Deno,
  path : String,
  create? : Bool,
  write? : Bool,
  read? : Bool,
) -> FsFile {
  let promise : @js.Promise[FsFile] = self
    .call2(
      "open",
      @js.any(path),
      @js.from_option_map({
        "create": create.map(fn(x) { @js.any(x) }),
        "write": write.map(fn(x) { @js.any(x) }),
        "read": read.map(fn(x) { @js.any(x) }),
      }),
    )
    .cast()
  promise.wait()
}

///|
/// Create a file
pub async fn Deno::create(self : Deno, path : String) -> FsFile {
  let promise : @js.Promise[FsFile] = self.call1("create", @js.any(path)).cast()
  promise.wait()
}

///|
/// Close file handle
pub fn FsFile::close(self : FsFile) -> Unit {
  self.call0("close") |> ignore
}

///|
/// Read from file
pub async fn FsFile::read(self : FsFile, buffer : @js.Any) -> Int {
  let promise : @js.Promise[Int] = self.call1("read", buffer).cast()
  promise.wait()
}

///|
/// Write to file
pub async fn FsFile::write(self : FsFile, data : @js.Any) -> Int {
  let promise : @js.Promise[Int] = self.call1("write", data).cast()
  promise.wait()
}

///|
/// Seek file position
pub async fn FsFile::seek(self : FsFile, offset : Int, whence : Int) -> Int {
  let promise : @js.Promise[Int] = self
    .call2("seek", @js.any(offset), @js.any(whence))
    .cast()
  promise.wait()
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
  self.call2("test", @js.any(name), @js.from_fn1(f)) |> ignore
}

///|
/// Deno.test(name, async fn)
pub fn Deno::test_async(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  self.call2("test", @js.any(name), @js.promisify1(f) |> @js.from_fn1) |> ignore
}

///|
/// Deno.test with options (simplified - use only for testing async functions with basic options)
pub fn Deno::test_only(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  self.call1(
    "test",
    @js.from_map({
      "name": @js.any(name),
      "only": @js.any(true),
      "fn": @js.promisify1(f) |> @js.from_fn1,
    }),
  )
  |> ignore
}

///| Subprocess APIs (Deno.Command)

///|
/// Command type for creating subprocesses
/// https://docs.deno.com/api/deno/~/Deno.Command
#external
pub type Command

///|
pub impl @js.JsImpl for Command

///|
/// Create a new Command
/// https://docs.deno.com/api/deno/~/Deno.Command
extern "js" fn ffi_new_command(
  program : String,
  args : @js.Any,
  cwd : @js.Any,
  env : @js.Any,
  stdin : @js.Any,
  stdout : @js.Any,
  stderr : @js.Any,
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
  env? : @js.Any,
  stdin? : String,
  stdout? : String,
  stderr? : String,
) -> Command {
  ffi_new_command(
    program,
    args
    .map(fn(a) { @js.from_array(a.map(fn(s) { @js.any(s) })) })
    .unwrap_or(@js.undefined()),
    cwd.map(fn(c) { @js.any(c) }).unwrap_or(@js.undefined()),
    env.unwrap_or(@js.undefined()),
    stdin.map(fn(s) { @js.any(s) }).unwrap_or(@js.undefined()),
    stdout.map(fn(s) { @js.any(s) }).unwrap_or(@js.undefined()),
    stderr.map(fn(s) { @js.any(s) }).unwrap_or(@js.undefined()),
  )
}

///|
/// CommandOutput - result of Command.output()
#external
pub type CommandOutput

///|
pub impl @js.JsImpl for CommandOutput

///|
/// Get exit code from CommandOutput
pub fn CommandOutput::code(self : CommandOutput) -> Int {
  self.get("code").cast()
}

///|
/// Check if command succeeded (exit code 0)
pub fn CommandOutput::success(self : CommandOutput) -> Bool {
  self.get("success").cast()
}

///|
/// Get stdout as Uint8Array
pub fn CommandOutput::stdout(self : CommandOutput) -> @typedarray.Uint8Array {
  self.get("stdout").cast()
}

///|
/// Get stderr as Uint8Array
pub fn CommandOutput::stderr(self : CommandOutput) -> @typedarray.Uint8Array {
  self.get("stderr").cast()
}

///|
/// Get signal that terminated the process (if any)
pub fn CommandOutput::signal(self : CommandOutput) -> String? {
  self.get("signal").cast() |> @js.identity_option
}

///|
/// Execute command and collect output
/// https://docs.deno.com/api/deno/~/Deno.Command#method_output_0
pub async fn Command::output(self : Command) -> CommandOutput {
  let promise : @js.Promise[CommandOutput] = self.call0("output").cast()
  promise.wait()
}

///|
/// Execute command synchronously and collect output
/// https://docs.deno.com/api/deno/~/Deno.Command#method_outputSync_0
#alias(output_sync)
pub fn Command::outputSync(self : Command) -> CommandOutput {
  self.call0("outputSync").cast()
}

///|
/// ChildProcess - spawned subprocess
/// https://docs.deno.com/api/deno/~/Deno.ChildProcess
#external
pub type ChildProcess

///|
pub impl @js.JsImpl for ChildProcess

///|
/// Get process ID
pub fn ChildProcess::pid(self : ChildProcess) -> Int {
  self.get("pid").cast()
}

///|
/// Get stdin stream (WritableStream)
pub fn ChildProcess::stdin(self : ChildProcess) -> @js.Any {
  self.get("stdin")
}

///|
/// Get stdout stream (ReadableStream)
pub fn ChildProcess::stdout(self : ChildProcess) -> @js.Any {
  self.get("stdout")
}

///|
/// Get stderr stream (ReadableStream)
pub fn ChildProcess::stderr(self : ChildProcess) -> @js.Any {
  self.get("stderr")
}

///|
/// CommandStatus - result of waiting for process
#external
pub type CommandStatus

///|
pub impl @js.JsImpl for CommandStatus

///|
/// Get exit code from CommandStatus
pub fn CommandStatus::code(self : CommandStatus) -> Int {
  self.get("code").cast()
}

///|
/// Check if command succeeded
pub fn CommandStatus::success(self : CommandStatus) -> Bool {
  self.get("success").cast()
}

///|
/// Get signal that terminated the process (if any)
pub fn CommandStatus::signal(self : CommandStatus) -> String? {
  self.get("signal").cast() |> @js.identity_option
}

///|
/// Wait for process to complete
pub async fn ChildProcess::status(self : ChildProcess) -> CommandStatus {
  let promise : @js.Promise[CommandStatus] = self.get("status").cast()
  promise.wait()
}

///|
/// Send signal to process
pub fn ChildProcess::kill(self : ChildProcess, signal? : String) -> Unit {
  match signal {
    Some(s) => self.call1("kill", @js.any(s)) |> ignore
    None => self.call0("kill") |> ignore
  }
}

///|
/// Prevent process from keeping event loop alive
pub fn ChildProcess::unref(self : ChildProcess) -> Unit {
  self.call0("unref") |> ignore
}

///|
/// Allow process to keep event loop alive (default)
pub fn ChildProcess::ref_(self : ChildProcess) -> Unit {
  self.call0("ref") |> ignore
}

///|
/// Spawn a subprocess
/// https://docs.deno.com/api/deno/~/Deno.Command#method_spawn_0
pub fn Command::spawn(self : Command) -> ChildProcess {
  self.call0("spawn").cast()
}
