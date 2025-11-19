# mizchi/js/node/child_process

## node:child_process

Child process creation and management APIs

### Asynchronous Process Creation
- [x] spawn (with options: cwd, env, stdio, shell, detached, uid, gid, timeout, killSignal)
- [x] exec (with options: cwd, env, shell, timeout, maxBuffer, killSignal, uid, gid)
- [x] execFile (with options: cwd, env, shell, timeout, maxBuffer, killSignal, uid, gid)
- [x] fork (with options: cwd, env, stdio, detached, uid, gid, execPath, execArgv)

### Synchronous Process Creation
- [x] spawnSync (with options: cwd, env, stdio, shell, input, timeout, killSignal, uid, gid)
- [x] execSync (with options: cwd, env, shell, input, timeout, maxBuffer, killSignal, uid, gid, encoding)
- [x] execFileSync (with options: cwd, env, shell, input, timeout, maxBuffer, killSignal, uid, gid, encoding)

### ChildProcess Class
- [x] ChildProcess type (extends EventEmitter)
- [x] pid - Process identifier
- [x] killed - Whether the process has been killed
- [x] exitCode - Exit code of the process
- [x] signalCode - Signal that terminated the process
- [x] stdin - Writable stream
- [x] stdout - Readable stream
- [x] stderr - Readable stream
- [x] kill(signal?) - Send signal to child
- [x] send(message) - Send IPC message
- [x] disconnect() - Close IPC channel
- [x] unref() - Prevent parent from waiting
- [x] ref() - Opposite of unref
- [x] on_stderr_data(callback) - Listen for stderr data

### Stdio Options
- [x] StdioOption enum (pipe, ignore, inherit, ipc, stream, fd)
- [x] Stdio type for configuring stdin/stdout/stderr

## Test Coverage
- 29 tests in src/node/child_process/child_process_test.mbt (synchronous APIs)
- Additional async tests in src/_tests/node_child_process_test.mbt

## Not supported

- Stream-based stdio options (work in progress)
