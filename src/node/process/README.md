# mizchi/js/node/process

## node:process

Process information and control

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/node/process"
  ]
}
```

### Process Information
- [x] argv - Command line arguments
- [x] execArgv - Node-specific command line options
- [x] execPath - Path to Node.js executable
- [x] env - Environment variables
- [x] pid - Process ID
- [x] ppid - Parent process ID
- [x] platform - Operating system platform
- [x] arch - CPU architecture
- [x] version - Node.js version
- [x] versions - Node.js and dependency versions

### Working Directory
- [x] cwd() - Get current working directory
- [x] chdir(directory) - Change working directory

### Standard Streams
- [x] stdin - Standard input stream
- [x] stdout - Standard output stream
- [x] stderr - Standard error stream

### Process Control
- [x] exit(code?) - Exit process
- [x] abort() - Abort process
- [x] kill(pid, signal?) - Send signal to process

### Resource Usage
- [x] memoryUsage() - Memory usage statistics
- [x] cpuUsage(previousValue?) - CPU usage statistics
- [x] uptime() - Process uptime in seconds

### User/Group
- [x] getuid() - Get user ID
- [x] getgid() - Get group ID
- [x] setuid(id) - Set user ID
- [x] setgid(id) - Set group ID

### Other
- [x] nextTick(callback, args...) - Schedule callback
- [x] hrtime(time?) - High-resolution time
