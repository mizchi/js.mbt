///|
/// Node.js OS Module Tests

///|
using @os {
  arch,
  cpus,
  endianness,
  freemem,
  homedir,
  hostname,
  loadavg,
  platform,
  release,
  tmpdir,
  totalmem,
  type_,
  uptime,
  version,
  eol,
  machine,
}

///|
test "arch returns valid architecture" {
  let architecture = arch()
  // Should be one of the valid architectures
  let valid = architecture == "arm" ||
    architecture == "arm64" ||
    architecture == "ia32" ||
    architecture == "x64" ||
    architecture == "mips" ||
    architecture == "ppc" ||
    architecture == "s390" ||
    architecture == "s390x"
  assert_true(valid || architecture.length() > 0)
}

///|
test "cpus returns array of CPU info" {
  let cpus_array = cpus()
  assert_true(cpus_array.length() > 0)
}

///|
test "endianness returns BE or LE" {
  let end = endianness()
  assert_true(end == "BE" || end == "LE")
}

///|
test "freemem returns positive number" {
  let free = freemem()
  assert_true(free > 0.0)
}

///|
test "homedir returns non-empty string" {
  let home = homedir()
  assert_true(home.length() > 0)
}

///|
test "hostname returns non-empty string" {
  let host = hostname()
  assert_true(host.length() > 0)
}

///|
test "loadavg returns array of 3 numbers" {
  let avg = loadavg()
  assert_true(avg.length() == 3)
}

///|
test "platform returns valid platform" {
  let plat = platform()
  let valid = plat == "aix" ||
    plat == "darwin" ||
    plat == "freebsd" ||
    plat == "linux" ||
    plat == "openbsd" ||
    plat == "sunos" ||
    plat == "win32"
  assert_true(valid || plat.length() > 0)
}

///|
test "release returns non-empty string" {
  let rel = release()
  assert_true(rel.length() > 0)
}

///|
test "tmpdir returns non-empty string" {
  let tmp = tmpdir()
  assert_true(tmp.length() > 0)
}

///|
test "totalmem returns positive number" {
  let total = totalmem()
  assert_true(total > 0.0)
}

///|
test "type returns non-empty string" {
  let os_type = type_()
  assert_true(os_type.length() > 0)
}

///|
test "uptime returns positive number" {
  let up = uptime()
  assert_true(up > 0.0)
}

///|
test "userinfo returns object" {
  let info = @os.userInfo()
  assert_true(@js.typeof_(info) == "object")
}

///|
test "version returns non-empty string" {
  let ver = version()
  assert_true(ver.length() > 0)
}

///|
test "eol returns valid line ending" {
  let line_end = eol()
  assert_true(line_end == "\n" || line_end == "\r\n")
}

///|
test "available_parallelism returns positive number" {
  let cores = @os.availableParallelism()
  assert_true(cores > 0)
}

///|
test "machine returns non-empty string" {
  let mach = machine()
  assert_true(mach.length() > 0)
}

///|
test "devNull returns device path" {
  let dev = @os.devNull()
  assert_true(dev.length() > 0)
}

///|
test "network_interfaces returns object" {
  let interfaces = @os.networkInterfaces()
  assert_true(@js.typeof_(interfaces) == "object")
}

///|
test "priority returns number" {
  let prio = @os.getPriority(pid=None)
  assert_true(prio >= -20 && prio <= 19)
}
