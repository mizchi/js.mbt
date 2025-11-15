///|
// Node.js OS Module
// https://nodejs.org/api/os.html

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
  unsafe_cast(os_module().invoke("arch", []))
}

///|
/// Returns an array of objects containing information about each logical CPU core
///
/// # Returns
///
/// An array of CPU information objects
pub fn cpus() -> Array[Val] {
  unsafe_cast(os_module().invoke("cpus", []))
}

///|
/// Returns a string identifying the endianness of the CPU
///
/// # Returns
///
/// 'BE' for big endian or 'LE' for little endian
pub fn endianness() -> String {
  unsafe_cast(os_module().invoke("endianness", []))
}

///|
/// Returns the amount of free system memory in bytes
pub fn freemem() -> Double {
  unsafe_cast(os_module().invoke("freemem", []))
}

///|
/// Returns the home directory of the current user
pub fn homedir() -> String {
  unsafe_cast(os_module().invoke("homedir", []))
}

///|
/// Returns the host name of the operating system
pub fn hostname() -> String {
  unsafe_cast(os_module().invoke("hostname", []))
}

///|
/// Returns an array containing the 1, 5, and 15 minute load averages
///
/// # Returns
///
/// Load averages [1min, 5min, 15min]
pub fn loadavg() -> Array[Double] {
  unsafe_cast(os_module().invoke("loadavg", []))
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
  unsafe_cast(os_module().invoke("platform", []))
}

///|
/// Returns the operating system release
pub fn release() -> String {
  unsafe_cast(os_module().invoke("release", []))
}

///|
/// Returns the operating system's default directory for temporary files
pub fn tmpdir() -> String {
  unsafe_cast(os_module().invoke("tmpdir", []))
}

///|
/// Returns the total amount of system memory in bytes
pub fn totalmem() -> Double {
  unsafe_cast(os_module().invoke("totalmem", []))
}

///|
/// Returns the operating system name
///
/// # Returns
///
/// OS name (e.g., 'Linux', 'Darwin', 'Windows_NT')
pub fn type_() -> String {
  unsafe_cast(os_module().invoke("type", []))
}

///|
/// Returns the system uptime in seconds
pub fn uptime() -> Double {
  unsafe_cast(os_module().invoke("uptime", []))
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
  unsafe_cast(os_module().invoke("version", []))
}

///| OS Constants

///|
/// Returns the operating system-specific end-of-line marker
///
/// # Returns
///
/// '\r\n' on Windows, '\n' on POSIX
pub fn eol() -> String {
  unsafe_cast(os_module().get("EOL"))
}

///|
/// Returns the operating system's default priority for processes
pub fn priority() -> Int {
  unsafe_cast(os_module().invoke("getPriority", []))
}

///|
/// Returns the priority of the process specified by pid
pub fn get_priority(pid : Int) -> Int {
  unsafe_cast(os_module().invoke("getPriority", [pid]))
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
  unsafe_cast(os_module().invoke("availableParallelism", []))
}

///|
/// Returns the machine type
///
/// # Returns
///
/// Machine type (e.g., 'x86_64', 'arm64')
pub fn machine() -> String {
  unsafe_cast(os_module().invoke("machine", []))
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
  unsafe_cast(os_module().get("devNull"))
}
