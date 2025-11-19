# mizchi/js/node/fs

## node:fs

Synchronous file system APIs

### File Reading/Writing
- [x] readFileSync (as Buffer)
- [x] read_file_sync_string (with encoding)
- [x] writeFileSync
- [x] appendFileSync

### File/Directory Operations
- [x] existsSync
- [x] statSync
- [x] mkdirSync (with recursive option)
- [x] unlinkSync
- [x] renameSync
- [x] copyFileSync
- [x] readdirSync
- [x] rmSync (with recursive/force options)

### File Permissions & Ownership
- [x] chmodSync
- [x] chownSync

### Symbolic Links
- [x] symlinkSync
- [x] readlinkSync
- [x] realpathSync

### File Operations
- [x] truncateSync
- [x] rmdirSync (with recursive option)
- [x] accessSync (with mode)
- [x] cpSync (with recursive option)

### File Descriptors
- [x] openSync
- [x] closeSync
- [x] readSync (with position)
- [x] writeSync (with position)

### Streams
- [x] createReadStream
- [x] createWriteStream

### Constants
- [x] fs_F_OK (file exists)
- [x] fs_R_OK (read permission)
- [x] fs_W_OK (write permission)
- [x] fs_X_OK (execute permission)

## Not supported

- Callback APIs
  - Use `mizchi/js/node/fs_promises` for Promise-based APIs
