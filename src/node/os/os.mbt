///|
// Node.js OS Module
// https://nodejs.org/api/os.html

///|
/// os_module kept for property access (EOL, devNull) and functions with optional args
extern "js" fn os_module() -> @core.Any =
  #| () => require("node:os")

///|
#module("node:os")
extern "js" fn internal_arch() -> String = "arch"

///|
#module("node:os")
extern "js" fn internal_cpus() -> Array[CpuInfo] = "cpus"

///|
#module("node:os")
extern "js" fn internal_endianness() -> String = "endianness"

///|
#module("node:os")
extern "js" fn internal_freemem() -> Double = "freemem"

///|
#module("node:os")
extern "js" fn internal_homedir() -> String = "homedir"

///|
#module("node:os")
extern "js" fn internal_hostname() -> String = "hostname"

///|
#module("node:os")
extern "js" fn internal_loadavg() -> Array[Double] = "loadavg"

///|
#module("node:os")
extern "js" fn internal_network_interfaces() -> @core.Any = "networkInterfaces"

///|
#module("node:os")
extern "js" fn internal_platform() -> String = "platform"

///|
#module("node:os")
extern "js" fn internal_release() -> String = "release"

///|
#module("node:os")
extern "js" fn internal_tmpdir() -> String = "tmpdir"

///|
#module("node:os")
extern "js" fn internal_totalmem() -> Double = "totalmem"

///|
#module("node:os")
extern "js" fn internal_type() -> String = "type"

///|
#module("node:os")
extern "js" fn internal_uptime() -> Double = "uptime"

///|
#module("node:os")
extern "js" fn internal_user_info() -> UserInfo = "userInfo"

///|
#module("node:os")
extern "js" fn internal_version() -> String = "version"

///|
#module("node:os")
extern "js" fn internal_available_parallelism() -> Int = "availableParallelism"

///|
#module("node:os")
extern "js" fn internal_machine() -> String = "machine"

///|
/// CPU information returned by cpus()
#external
pub type CpuInfo

///|
pub fn CpuInfo::to_any(self : CpuInfo) -> @core.Any = "%identity"

///|
/// Get the CPU model name
pub fn CpuInfo::model(self : CpuInfo) -> String {
  self.to_any()["model"].cast()
}

///|
/// Get the CPU speed in MHz
pub fn CpuInfo::speed(self : CpuInfo) -> Int {
  self.to_any()["speed"].cast()
}

///|
/// Get user CPU time in milliseconds
pub fn CpuInfo::times_user(self : CpuInfo) -> Int {
  self.to_any()["times"]["user"].cast()
}

///|
/// Get nice CPU time in milliseconds
pub fn CpuInfo::times_nice(self : CpuInfo) -> Int {
  self.to_any()["times"]["nice"].cast()
}

///|
/// Get system CPU time in milliseconds
pub fn CpuInfo::times_sys(self : CpuInfo) -> Int {
  self.to_any()["times"]["sys"].cast()
}

///|
/// Get idle CPU time in milliseconds
pub fn CpuInfo::times_idle(self : CpuInfo) -> Int {
  self.to_any()["times"]["idle"].cast()
}

///|
/// Get IRQ CPU time in milliseconds
pub fn CpuInfo::times_irq(self : CpuInfo) -> Int {
  self.to_any()["times"]["irq"].cast()
}

///|
/// User information returned by userInfo()
#external
pub type UserInfo

///|
pub fn UserInfo::to_any(self : UserInfo) -> @core.Any = "%identity"

///|
/// Get the username
pub fn UserInfo::username(self : UserInfo) -> String {
  self.to_any()["username"].cast()
}

///|
/// Get the user ID (uid)
pub fn UserInfo::uid(self : UserInfo) -> Int {
  self.to_any()["uid"].cast()
}

///|
/// Get the group ID (gid)
pub fn UserInfo::gid(self : UserInfo) -> Int {
  self.to_any()["gid"].cast()
}

///|
/// Get the user's shell (may be null on Windows)
pub fn UserInfo::shell(self : UserInfo) -> String? {
  let v = self.to_any()["shell"]
  if @core.is_null(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get the user's home directory
pub fn UserInfo::homedir(self : UserInfo) -> String {
  self.to_any()["homedir"].cast()
}

///| System Information

///|
/// Returns the operating system CPU architecture
///
/// # Returns
///
/// The CPU architecture: 'arm', 'arm64', 'ia32', 'mips', 'mipsel', 'ppc', 'ppc64', 's390', 's390x', 'x64'
pub fn arch() -> String {
  internal_arch()
}

///|
/// Returns an array of objects containing information about each logical CPU core
///
/// # Returns
///
/// An array of CPU information objects
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn cpus() -> Array[CpuInfo] {
  internal_cpus()
}

///|
/// Returns a string identifying the endianness of the CPU
///
/// # Returns
///
/// 'BE' for big endian or 'LE' for little endian
pub fn endianness() -> String {
  internal_endianness()
}

///|
/// Returns the amount of free system memory in bytes
pub fn freemem() -> Double {
  internal_freemem()
}

///|
/// Returns the home directory of the current user
pub fn homedir() -> String {
  internal_homedir()
}

///|
/// Returns the host name of the operating system
pub fn hostname() -> String {
  internal_hostname()
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
  internal_loadavg()
}

///|
/// Returns an object containing network interfaces
///
/// # Returns
///
/// An object with interface names as keys
#alias(network_interfaces)
pub fn networkInterfaces() -> @core.Any {
  internal_network_interfaces()
}

///|
/// Returns the operating system platform
///
/// # Returns
///
/// Platform: 'aix', 'darwin', 'freebsd', 'linux', 'openbsd', 'sunos', 'win32'
pub fn platform() -> String {
  internal_platform()
}

///|
/// Returns the operating system release
pub fn release() -> String {
  internal_release()
}

///|
/// Returns the operating system's default directory for temporary files
pub fn tmpdir() -> String {
  internal_tmpdir()
}

///|
/// Returns the total amount of system memory in bytes
pub fn totalmem() -> Double {
  internal_totalmem()
}

///|
/// Returns the operating system name
///
/// # Returns
///
/// OS name (e.g., 'Linux', 'Darwin', 'Windows_NT')
pub fn type_() -> String {
  internal_type()
}

///|
/// Returns the system uptime in seconds
pub fn uptime() -> Double {
  internal_uptime()
}

///|
/// Returns information about the currently effective user
///
/// # Returns
///
/// An object containing uid, gid, username, homedir, shell
#alias(userinfo)
pub fn userInfo() -> UserInfo {
  internal_user_info()
}

///|
/// Returns information about the currently effective user with options
///
/// # Parameters
///
/// - `encoding`: The character encoding to use (default: 'utf8')
#alias(userinfo_with_encoding)
pub fn userInfoWithEncoding(encoding : String) -> UserInfo {
  let os : @core.Any = os_module() |> @core.any
  let opts = @core.from_entries([("encoding", @core.any(encoding))])
  os._call("userInfo", [opts]) |> @core.identity
}

///|
/// Returns the operating system version
pub fn version() -> String {
  internal_version()
}

///| OS Constants

///|
/// Returns the operating system-specific end-of-line marker
///
/// # Returns
///
/// '\r\n' on Windows, '\n' on POSIX
pub fn eol() -> String {
  let os : @core.Any = os_module() |> @core.any
  os["EOL"].cast()
}

///|
/// Returns the priority of the process specified by pid
#alias(get_priority)
pub fn getPriority(pid~ : Int?) -> Int {
  let os : @core.Any = os_module() |> @core.any
  match pid {
    Some(p) => os._call("getPriority", [@core.any(p)]).cast()
    None => os._call("getPriority", []).cast()
  }
}

///|
/// Sets the scheduling priority for the process
#alias(set_priority)
pub fn setPriority(priority : Int, pid~ : Int?) -> Unit {
  let os : @core.Any = os_module() |> @core.any
  match pid {
    Some(p) =>
      os._call("setPriority", [@core.any(p), @core.any(priority)]) |> ignore
    None => os._call("setPriority", [@core.any(priority)]) |> ignore
  }
}

///|
/// Returns the number of logical CPU cores available
#alias(available_parallelism)
pub fn availableParallelism() -> Int {
  internal_available_parallelism()
}

///|
/// Returns the machine type
///
/// # Returns
///
/// Machine type (e.g., 'x86_64', 'arm64')
pub fn machine() -> String {
  internal_machine()
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
  let os : @core.Any = os_module() |> @core.any
  os["devNull"].cast()
}
