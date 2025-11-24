///|
// Node.js OS Module
// https://nodejs.org/api/os.html

///|
/// Get os module
fn os_module() -> @js.Js {
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
  @js.identity(os_module().call0("arch"))
}

///|
/// Returns an array of objects containing information about each logical CPU core
///
/// # Returns
///
/// An array of CPU information objects
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn cpus() -> Array[@js.Js] {
  @js.identity(os_module().call0("cpus"))
}

///|
/// Returns a string identifying the endianness of the CPU
///
/// # Returns
///
/// 'BE' for big endian or 'LE' for little endian
pub fn endianness() -> String {
  @js.identity(os_module().call0("endianness"))
}

///|
/// Returns the amount of free system memory in bytes
pub fn freemem() -> Double {
  @js.identity(os_module().call0("freemem"))
}

///|
/// Returns the home directory of the current user
pub fn homedir() -> String {
  @js.identity(os_module().call0("homedir"))
}

///|
/// Returns the host name of the operating system
pub fn hostname() -> String {
  @js.identity(os_module().call0("hostname"))
}

///|
/// Returns an array containing the 1, 5, and 15 minute load averages
///
/// # Returns
///
/// Load averages [1min, 5min, 15min]
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn loadavg() -> Array[Double] {
  @js.identity(os_module().call0("loadavg"))
}

///|
/// Returns an object containing network interfaces
///
/// # Returns
///
/// An object with interface names as keys
#alias(network_interfaces)
pub fn networkInterfaces() -> @js.Js {
  os_module().call0("networkInterfaces")
}

///|
/// Returns the operating system platform
///
/// # Returns
///
/// Platform: 'aix', 'darwin', 'freebsd', 'linux', 'openbsd', 'sunos', 'win32'
pub fn platform() -> String {
  @js.identity(os_module().call0("platform"))
}

///|
/// Returns the operating system release
pub fn release() -> String {
  @js.identity(os_module().call0("release"))
}

///|
/// Returns the operating system's default directory for temporary files
pub fn tmpdir() -> String {
  @js.identity(os_module().call0("tmpdir"))
}

///|
/// Returns the total amount of system memory in bytes
pub fn totalmem() -> Double {
  @js.identity(os_module().call0("totalmem"))
}

///|
/// Returns the operating system name
///
/// # Returns
///
/// OS name (e.g., 'Linux', 'Darwin', 'Windows_NT')
pub fn type_() -> String {
  @js.identity(os_module().call0("type"))
}

///|
/// Returns the system uptime in seconds
pub fn uptime() -> Double {
  @js.identity(os_module().call0("uptime"))
}

///|
/// Returns information about the currently effective user
///
/// # Returns
///
/// An object containing uid, gid, username, homedir, shell
#alias(userinfo)
pub fn userInfo() -> @js.Js {
  os_module().call0("userInfo")
}

///|
/// Returns information about the currently effective user with options
///
/// # Parameters
///
/// - `encoding`: The character encoding to use (default: 'utf8')
#alias(userinfo_with_encoding)
pub fn userInfoWithEncoding(encoding : String) -> @js.Js {
  os_module().call1("userInfo", @js.from_entries([("encoding", encoding)]))
}

///|
/// Returns the operating system version
pub fn version() -> String {
  @js.identity(os_module().call0("version"))
}

///| OS Constants

///|
/// Returns the operating system-specific end-of-line marker
///
/// # Returns
///
/// '\r\n' on Windows, '\n' on POSIX
pub fn eol() -> String {
  @js.identity(os_module().get("EOL"))
}

///|
/// Returns the priority of the process specified by pid
#alias(get_priority)
pub fn getPriority(pid~ : Int?) -> Int {
  match pid {
    Some(p) => @js.identity(os_module().call("getPriority", [p]))
    None => @js.identity(os_module().call0("getPriority"))
  }
}

///|
/// Sets the scheduling priority for the process
#alias(set_priority)
pub fn setPriority(priority : Int, pid~ : Int?) -> Unit {
  match pid {
    Some(p) => os_module().call2("setPriority", p, priority) |> ignore
    None => os_module().call("setPriority", [priority]) |> ignore
  }
}

///|
/// Returns the number of logical CPU cores available
#alias(available_parallelism)
pub fn availableParallelism() -> Int {
  @js.identity(os_module().call0("availableParallelism"))
}

///|
/// Returns the machine type
///
/// # Returns
///
/// Machine type (e.g., 'x86_64', 'arm64')
pub fn machine() -> String {
  @js.identity(os_module().call0("machine"))
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
#alias(dev_null)
pub fn devNull() -> String {
  @js.identity(os_module().get("devNull"))
}
