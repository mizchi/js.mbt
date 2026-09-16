# mizchi/js_node/os

## node:os

Operating system utilities

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_node@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_node/os",
}
```

### System Information
- [x] arch() - CPU architecture
- [x] cpus() - CPU information array
- [x] endianness() - Endianness ('BE' or 'LE')
- [x] freemem() - Free memory in bytes
- [x] homedir() - User home directory
- [x] hostname() - System hostname
- [x] loadavg() - Load average [1, 5, 15 min]
- [x] networkInterfaces() - Network interfaces
- [x] platform() - Operating system platform
- [x] release() - OS release version
- [x] tmpdir() - Temporary directory
- [x] totalmem() - Total memory in bytes
- [x] type() - Operating system type
- [x] uptime() - System uptime in seconds
- [x] userInfo(options?) - Current user information
- [x] version() - OS version string

### Constants
- [x] EOL - End-of-line marker
- [x] devNull - Path to null device
