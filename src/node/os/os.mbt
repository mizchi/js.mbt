///|
// Node.js OS Module
// https://nodejs.org/api/os.html

///|
using @js {type Val, trait Js, js}

///|
/// Get os module
fn os_module() -> Val {
  @node.require("node:os")
}

///| System Information

///|
/// Returns the operating system CPU architecture
///
/// # Returns
///
/// The CPU architecture: 'arm', 'arm64', 'ia32', 'mips', 'mipsel', 'ppc', 'ppc64', 's390', 's390x', 'x64'
pub fn arch() -> String {
  os_module().invoke("arch", []).cast()
}

///|
/// Returns an array of objects containing information about each logical CPU core
///
/// # Returns
///
/// An array of CPU information objects
pub fn cpus() -> Array[Val] {
  os_module().invoke("cpus", []).cast()
}

///|
/// Returns a string identifying the endianness of the CPU
///
/// # Returns
///
/// 'BE' for big endian or 'LE' for little endian
pub fn endianness() -> String {
  os_module().invoke("endianness", []).cast()
}

///|
/// Returns the amount of free system memory in bytes
pub fn freemem() -> Double {
  os_module().invoke("freemem", []).cast()
}

///|
/// Returns the home directory of the current user
pub fn homedir() -> String {
  os_module().invoke("homedir", []).cast()
}

///|
/// Returns the host name of the operating system
pub fn hostname() -> String {
  os_module().invoke("hostname", []).cast()
}

///|
/// Returns an array containing the 1, 5, and 15 minute load averages
///
/// # Returns
///
/// Load averages [1min, 5min, 15min]
pub fn loadavg() -> Array[Double] {
  os_module().invoke("loadavg", []).cast()
}

///|
/// Returns an object containing network interfaces
///
/// # Returns
///
/// An object with interface names as keys
pub fn network_interfaces() -> Val {
  os_module().invoke("networkInterfaces", [])
}

///|
/// Returns the operating system platform
///
/// # Returns
///
/// Platform: 'aix', 'darwin', 'freebsd', 'linux', 'openbsd', 'sunos', 'win32'
pub fn platform() -> String {
  os_module().invoke("platform", []).cast()
}

///|
/// Returns the operating system release
pub fn release() -> String {
  os_module().invoke("release", []).cast()
}

///|
/// Returns the operating system's default directory for temporary files
pub fn tmpdir() -> String {
  os_module().invoke("tmpdir", []).cast()
}

///|
/// Returns the total amount of system memory in bytes
pub fn totalmem() -> Double {
  os_module().invoke("totalmem", []).cast()
}

///|
/// Returns the operating system name
///
/// # Returns
///
/// OS name (e.g., 'Linux', 'Darwin', 'Windows_NT')
pub fn type_() -> String {
  os_module().invoke("type", []).cast()
}

///|
/// Returns the system uptime in seconds
pub fn uptime() -> Double {
  os_module().invoke("uptime", []).cast()
}

///|
/// Returns information about the currently effective user
///
/// # Returns
///
/// An object containing uid, gid, username, homedir, shell
pub fn userinfo() -> Val {
  os_module().invoke("userInfo", [])
}

///|
/// Returns information about the currently effective user with options
///
/// # Parameters
///
/// - `encoding`: The character encoding to use (default: 'utf8')
pub fn userinfo_with_encoding(encoding : String) -> Val {
  let options = @js.new_empty_object()
  options.set("encoding", encoding)
  os_module().invoke("userInfo", [options])
}

///|
/// Returns the operating system version
pub fn version() -> String {
  os_module().invoke("version", []).cast()
}

///| OS Constants

///|
/// Returns the operating system-specific end-of-line marker
///
/// # Returns
///
/// '\r\n' on Windows, '\n' on POSIX
pub fn eol() -> String {
  os_module().get("EOL").cast()
}

///|
/// Returns the operating system's default priority for processes
pub fn priority() -> Int {
  os_module().invoke("getPriority", []).cast()
}

///|
/// Returns the priority of the process specified by pid
pub fn get_priority(pid : Int) -> Int {
  os_module().invoke("getPriority", [pid]).cast()
}

///|
/// Sets the scheduling priority for the process
pub fn set_priority(priority : Int) -> Unit {
  os_module().invoke("setPriority", [priority]) |> ignore
}

///|
/// Sets the scheduling priority for the process specified by pid
pub fn set_priority_with_pid(pid : Int, priority : Int) -> Unit {
  os_module().invoke("setPriority", [pid, priority]) |> ignore
}

///|
/// Returns the number of logical CPU cores available
pub fn available_parallelism() -> Int {
  os_module().invoke("availableParallelism", []).cast()
}

///|
/// Returns the machine type
///
/// # Returns
///
/// Machine type (e.g., 'x86_64', 'arm64')
pub fn machine() -> String {
  os_module().invoke("machine", []).cast()
}

///|
/// Returns the device name associated with a file descriptor
///
/// # Parameters
///
/// - `fd`: File descriptor (0 = stdin, 1 = stdout, 2 = stderr)
///
/// # Returns
///
/// Device name or empty string if not a TTY
pub fn devNull() -> String {
  os_module().get("devNull").cast()
}
