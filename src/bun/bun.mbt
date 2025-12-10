///|
/// Bun namespace
/// https://bun.sh/docs/api

///|
#external
pub type Bun

///|
pub fn Bun::as_any(self : Bun) -> @core.Any = "%identity"

///|
/// Bun global object
pub extern "js" fn bun() -> Bun =
  #| () => Bun

///| Runtime Information

///|
/// Get Bun version
pub fn Bun::version(self : Bun) -> String {
  self.as_any()["version"].cast()
}

///|
/// Get Bun revision
pub fn Bun::revision(self : Bun) -> String {
  self.as_any()["revision"].cast()
}

///| Environment Variables

///|
/// Get environment variable
pub fn Bun::env_get(self : Bun, key : String) -> String? {
  self.as_any()["env"][key].cast() |> @core.identity_option
}

///|
/// Get all environment variables as an object
pub fn Bun::env(self : Bun) -> @core.Any {
  self.as_any()["env"].cast()
}

///| File Operations

///|
/// Read a file as text
pub async fn Bun::file_text(self : Bun, path : String) -> String {
  let file = self.as_any()._call("file", [@core.any(path)])
  let promise : @core.Promise[String] = file._call("text", []).cast()
  promise.wait()
}

///|
/// Read a file as ArrayBuffer
pub async fn Bun::file_arrayBuffer(
  self : Bun,
  path : String,
) -> @arraybuffer.ArrayBuffer {
  let file = self.as_any()._call("file", [@core.any(path)])
  let promise : @core.Promise[@arraybuffer.ArrayBuffer] = file
    ._call("arrayBuffer", [])
    .cast()
  promise.wait()
}

///|
/// Write data to a file
pub async fn Bun::write(self : Bun, path : String, data : @core.Any) -> Int {
  let promise : @core.Promise[Int] = self
    .as_any()
    ._call("write", [@core.any(path), data])
    .cast()
  promise.wait()
}

///| Process APIs

///|
/// Get current working directory (Bun.cwd is a property, not a function)
pub fn Bun::cwd(self : Bun) -> String {
  self.as_any()["cwd"].cast()
}

///|
/// Get command line arguments
extern "js" fn ffi_get_argv() -> Array[String] =
  #| () => process.argv

///|
/// Get command line arguments (excluding the binary and script path)
pub fn Bun::argv(self : Bun) -> Array[String] {
  ignore(self)
  ffi_get_argv()
}

///|
/// Get the main module path
/// NOTE: If you define `::main`, `moon coverage analyze` will fail
/// https://github.com/moonbitlang/moonbit-docs/issues/1071
pub fn Bun::main_(self : Bun) -> String {
  self.as_any()["main"].cast()
}

///|
/// Exit the process
pub fn Bun::exit(self : Bun, code? : Int) -> Unit {
  match code {
    Some(c) => self.as_any()._call("exit", [@core.any(c)]) |> ignore
    None => self.as_any()._call("exit", []) |> ignore
  }
}

///| Test APIs

///|
#external
pub type TestContext

///|
pub fn TestContext::as_any(self : TestContext) -> @core.Any = "%identity"

///|
/// Get the test name
pub fn TestContext::name(self : TestContext) -> String {
  self.as_any()["name"].cast()
}

///|
/// test(name, fn) - Global test function with proper Promise wrapping
/// Takes an async function (CPS style with _ctx, _cont, _err_cont)
extern "js" fn ffi_test_async(
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit =
  #| (name, f) => {
  #|   test(name, () => {
  #|     return new Promise((resolve, reject) => {
  #|       f(null, resolve, reject);
  #|     });
  #|   });
  #| }

///|
/// test(name, fn) - Global test function for sync tests
extern "js" fn ffi_test_sync(name : String, f : @core.Any) -> Unit =
  #| (name, f) => test(name, () => f(null))

///|
/// Bun.test(name, fn) - wrapper for convenience
pub fn Bun::test_(self : Bun, name : String, f : (TestContext) -> Unit) -> Unit {
  ignore(self)
  let fn_any : @core.Any = @core.from_fn1(f).cast()
  ffi_test_sync(name, fn_any)
}

///|
/// Bun.test(name, async fn) - wrapper for convenience
pub fn Bun::test_async(
  self : Bun,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  ignore(self)
  // async functions are compiled to CPS style with (_ctx, _cont, _err_cont) signature
  // Pass the CPS function directly to ffi_test_async
  ffi_test_async(name, f)
}

///|
/// expect() function for assertions
#external
pub type Expectation

///|
pub fn Expectation::as_any(self : Expectation) -> @core.Any = "%identity"

///|
/// Create an expectation
pub extern "js" fn expect(value : @core.Any) -> Expectation =
  #| (value) => expect(value)

///|
/// Assert that the value equals the expected value
pub fn Expectation::toBe(self : Expectation, expected : @core.Any) -> Unit {
  self.as_any()._call("toBe", [expected]) |> ignore
}

///|
/// Assert that the value equals the expected value (deep equality)
pub fn Expectation::toEqual(self : Expectation, expected : @core.Any) -> Unit {
  self.as_any()._call("toEqual", [expected]) |> ignore
}

///|
/// Assert that the value is truthy
pub fn Expectation::toBeTruthy(self : Expectation) -> Unit {
  self.as_any()._call("toBeTruthy", []) |> ignore
}

///|
/// Assert that the value is falsy
pub fn Expectation::toBeFalsy(self : Expectation) -> Unit {
  self.as_any()._call("toBeFalsy", []) |> ignore
}

///|
/// Assert that the value is null
pub fn Expectation::toBeNull(self : Expectation) -> Unit {
  self.as_any()._call("toBeNull", []) |> ignore
}

///|
/// Assert that the value is undefined
pub fn Expectation::toBeUndefined(self : Expectation) -> Unit {
  self.as_any()._call("toBeUndefined", []) |> ignore
}

///|
/// Assert that the value is defined (not undefined)
pub fn Expectation::toBeDefined(self : Expectation) -> Unit {
  self.as_any()._call("toBeDefined", []) |> ignore
}

///|
/// Assert that a string contains a substring
pub fn Expectation::toContain(self : Expectation, substring : String) -> Unit {
  self.as_any()._call("toContain", [@core.any(substring)]) |> ignore
}

///| HTTP Server APIs

///|
#external
pub type Server

///|
pub fn Server::as_any(self : Server) -> @core.Any = "%identity"

///|
/// Get the server port
pub fn Server::port(self : Server) -> Int {
  self.as_any()["port"].cast()
}

///|
/// Get the server hostname
pub fn Server::hostname(self : Server) -> String {
  self.as_any()["hostname"].cast()
}

///|
/// Stop the server
pub fn Server::stop(self : Server) -> Unit {
  self.as_any()._call("stop", []) |> ignore
}

///|
/// Create an HTTP server with a fetch handler
pub fn Bun::serve(
  self : Bun,
  port? : Int,
  hostname? : String,
  fetch : @core.Any,
) -> Server {
  let entries : Array[(String, @core.Any)] = []
  entries.push(("fetch", fetch))
  if port is Some(p) {
    entries.push(("port", @core.any(p)))
  }
  if hostname is Some(h) {
    entries.push(("hostname", @core.any(h)))
  }
  let opts = @core.from_entries(entries)
  self.as_any()._call("serve", [opts.cast()]).cast()
}

///| Hash and Crypto

///|
/// Hash a password using bcrypt
pub async fn Bun::password_hash(self : Bun, password : String) -> String {
  let promise : @core.Promise[String] = self.as_any()["password"]
    ._call("hash", [@core.any(password)])
    .cast()
  promise.wait()
}

///|
/// Verify a password against a hash
pub async fn Bun::password_verify(
  self : Bun,
  password : String,
  hash : String,
) -> Bool {
  let promise : @core.Promise[Bool] = self.as_any()["password"]
    ._call("verify", [@core.any(password), @core.any(hash)])
    .cast()
  promise.wait()
}

///| Other Utilities

///|
/// Sleep for a duration in milliseconds
pub async fn Bun::sleep(self : Bun, ms : Int) -> Unit {
  let promise : @core.Promise[Unit] = self
    .as_any()
    ._call("sleep", [@core.any(ms)])
    .cast()
  promise.wait()
}

///|
/// Get a high-resolution timestamp in nanoseconds
pub fn Bun::nanoseconds(self : Bun) -> Int {
  self.as_any()._call("nanoseconds", []).cast()
}

///|
/// Returns true if running in Bun
pub extern "js" fn is_bun() -> Bool =
  #| () => typeof Bun !== "undefined"

///| File System APIs (using Node.js fs module compatibility)

///|
/// Delete a file (uses Node.js fs.unlinkSync for compatibility)
pub extern "js" fn unlink_sync(path : String) -> Unit =
  #| (path) => {
  #|   const fs = require('fs');
  #|   fs.unlinkSync(path);
  #| }

///| Process & Command Execution APIs

///|
#external
pub type Subprocess

///|
pub fn Subprocess::as_any(self : Subprocess) -> @core.Any = "%identity"

///|
/// Get process ID
pub fn Subprocess::pid(self : Subprocess) -> Int {
  self.as_any()["pid"].cast()
}

///|
/// Get exit code (if process has exited)
pub fn Subprocess::exitCode(self : Subprocess) -> Int? {
  self.as_any()["exitCode"].cast() |> @core.identity_option
}

///|
/// Get stdin writer
pub fn Subprocess::stdin(self : Subprocess) -> @core.Any {
  self.as_any()["stdin"].cast()
}

///|
/// Get stdout reader
pub fn Subprocess::stdout(self : Subprocess) -> @core.Any {
  self.as_any()["stdout"].cast()
}

///|
/// Get stderr reader
pub fn Subprocess::stderr(self : Subprocess) -> @core.Any {
  self.as_any()["stderr"].cast()
}

///|
/// Kill the subprocess
pub fn Subprocess::kill(self : Subprocess, signal? : Int) -> Unit {
  match signal {
    Some(s) => self.as_any()._call("kill", [@core.any(s)]) |> ignore
    None => self.as_any()._call("kill", []) |> ignore
  }
}

///|
/// Wait for the process to exit
pub async fn Subprocess::exited(self : Subprocess) -> Int {
  let promise : @core.Promise[Int] = self.as_any()["exited"].cast()
  promise.wait()
}

///|
/// Spawn options for Bun.spawn()
pub struct SpawnOptions {
  cmd : Array[String]
  cwd : String?
  env : @core.Any?
  stdin : String?
  stdout : String?
  stderr : String?
}

///|
/// Create spawn options from command array
pub fn SpawnOptions::new(cmd : Array[String]) -> SpawnOptions {
  { cmd, cwd: None, env: None, stdin: None, stdout: None, stderr: None }
}

///|
/// Spawn a subprocess (Bun.spawn)
extern "js" fn ffi_spawn(
  cmd : @core.Any,
  cwd : @core.Any,
  env : @core.Any,
  stdin : @core.Any,
  stdout : @core.Any,
  stderr : @core.Any,
) -> Subprocess =
  #| (cmd, cwd, env, stdin, stdout, stderr) => {
  #|   const opts = {};
  #|   if (cwd !== undefined) opts.cwd = cwd;
  #|   if (env !== undefined) opts.env = env;
  #|   if (stdin !== undefined) opts.stdin = stdin;
  #|   if (stdout !== undefined) opts.stdout = stdout;
  #|   if (stderr !== undefined) opts.stderr = stderr;
  #|   return Bun.spawn(cmd, opts);
  #| }

///|
/// Convert string array to Any array
fn string_array_to_any(arr : Array[String]) -> @core.Any = "%identity"

///|
/// Spawn a subprocess
pub fn Bun::spawn(self : Bun, opts : SpawnOptions) -> Subprocess {
  ignore(self)
  let cmd_any = string_array_to_any(opts.cmd)
  ffi_spawn(
    cmd_any,
    match opts.cwd {
      Some(c) => @core.any(c)
      None => @global.undefined()
    },
    match opts.env {
      Some(e) => e
      None => @global.undefined()
    },
    match opts.stdin {
      Some(s) => @core.any(s)
      None => @global.undefined()
    },
    match opts.stdout {
      Some(s) => @core.any(s)
      None => @global.undefined()
    },
    match opts.stderr {
      Some(s) => @core.any(s)
      None => @global.undefined()
    },
  )
}

///|
/// Spawn and wait for result (similar to Bun.spawnSync)
extern "js" fn ffi_spawn_sync(
  cmd : @core.Any,
  cwd : @core.Any,
  env : @core.Any,
  stdin : @core.Any,
  stdout : @core.Any,
  stderr : @core.Any,
) -> @core.Any =
  #| (cmd, cwd, env, stdin, stdout, stderr) => {
  #|   const opts = {};
  #|   if (cwd !== undefined) opts.cwd = cwd;
  #|   if (env !== undefined) opts.env = env;
  #|   if (stdin !== undefined) opts.stdin = stdin;
  #|   if (stdout !== undefined) opts.stdout = stdout;
  #|   if (stderr !== undefined) opts.stderr = stderr;
  #|   return Bun.spawnSync(cmd, opts);
  #| }

///|
/// Spawn a subprocess synchronously
pub fn Bun::spawnSync(self : Bun, opts : SpawnOptions) -> @core.Any {
  ignore(self)
  let cmd_any = string_array_to_any(opts.cmd)
  ffi_spawn_sync(
    cmd_any,
    match opts.cwd {
      Some(c) => @core.any(c)
      None => @global.undefined()
    },
    match opts.env {
      Some(e) => e
      None => @global.undefined()
    },
    match opts.stdin {
      Some(s) => @core.any(s)
      None => @global.undefined()
    },
    match opts.stdout {
      Some(s) => @core.any(s)
      None => @global.undefined()
    },
    match opts.stderr {
      Some(s) => @core.any(s)
      None => @global.undefined()
    },
  )
}

///| Utility Functions

///|
/// Find executable in PATH (Bun.which)
pub fn Bun::which(self : Bun, bin : String) -> String? {
  self.as_any()._call("which", [@core.any(bin)]).cast() |> @core.identity_option
}

///|
/// Escape HTML string (Bun.escapeHTML)
pub fn Bun::escapeHTML(self : Bun, html : String) -> String {
  self.as_any()._call("escapeHTML", [@core.any(html)]).cast()
}

///|
/// Get string display width (Bun.stringWidth)
pub fn Bun::stringWidth(self : Bun, text : String) -> Int {
  self.as_any()._call("stringWidth", [@core.any(text)]).cast()
}

///|
/// Generate UUIDv7 (Bun.randomUUIDv7)
pub extern "js" fn random_uuid_v7() -> String =
  #| () => Bun.randomUUIDv7()

///|
/// Peek at a Promise state (Bun.peek)
pub fn Bun::peek(self : Bun, promise : @core.Any) -> @core.Any {
  self.as_any()._call("peek", [promise]).cast()
}

///| Hashing APIs

///|
/// Hash data with specified algorithm (Bun.hash)
/// Algorithms: "sha1", "sha256", "sha512", "md5", etc.
pub fn Bun::hash_(
  self : Bun,
  data : @core.Any,
  algorithm? : String,
) -> @core.Any {
  match algorithm {
    Some(alg) => self.as_any()._call("hash", [data, @core.any(alg)]).cast()
    None => self.as_any()._call("hash", [data]).cast()
  }
}

///|
#external
pub type CryptoHasher

///|
pub fn CryptoHasher::as_any(self : CryptoHasher) -> @core.Any = "%identity"

///|
/// Create a new CryptoHasher
extern "js" fn ffi_new_crypto_hasher(algorithm : String) -> CryptoHasher =
  #| (algorithm) => new Bun.CryptoHasher(algorithm)

///|
/// Create a new CryptoHasher with specified algorithm
pub fn CryptoHasher::new(algorithm : String) -> CryptoHasher {
  ffi_new_crypto_hasher(algorithm)
}

///|
/// Update hasher with data
pub fn CryptoHasher::update(self : CryptoHasher, data : @core.Any) -> Unit {
  self.as_any()._call("update", [data]) |> ignore
}

///|
/// Get digest as hex string
pub fn CryptoHasher::digest_hex(self : CryptoHasher) -> String {
  self.as_any()._call("digest", [@core.any("hex")]).cast()
}

///|
/// Get digest as base64 string
pub fn CryptoHasher::digest_base64(self : CryptoHasher) -> String {
  self.as_any()._call("digest", [@core.any("base64")]).cast()
}

///|
/// Get digest as ArrayBuffer
pub fn CryptoHasher::digest_buffer(
  self : CryptoHasher,
) -> @arraybuffer.ArrayBuffer {
  self.as_any()._call("digest", []).cast()
}

///| Glob API

///|
#external
pub type Glob

///|
pub fn Glob::as_any(self : Glob) -> @core.Any = "%identity"

///|
/// Create a new Glob matcher
extern "js" fn ffi_new_glob(pattern : String) -> Glob =
  #| (pattern) => new Bun.Glob(pattern)

///|
/// Create a Glob matcher with pattern
pub fn Glob::new(pattern : String) -> Glob {
  ffi_new_glob(pattern)
}

///|
/// Match a string against the glob pattern
pub fn Glob::match_(self : Glob, path : String) -> Bool {
  self.as_any()._call("match", [@core.any(path)]).cast()
}

///|
/// Scan files matching the glob pattern
pub fn Glob::scan(self : Glob, cwd? : String) -> @core.Any {
  match cwd {
    Some(dir) => {
      let opts = @core.from_entries([("cwd", @core.any(dir))])
      self.as_any()._call("scan", [opts.cast()]).cast()
    }
    None => self.as_any()._call("scan", []).cast()
  }
}
