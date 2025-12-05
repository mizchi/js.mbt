# mizchi/js/node/fs_promises

## node:fs/promises

Promise-based asynchronous file system APIs

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/node/fs_promises"
  ]
}
```

### File Reading/Writing
- [x] readFile (with encoding)
- [x] writeFile (with options: encoding, mode, flag, flush, signal)
- [x] appendFile (with encoding)

### File/Directory Operations
- [x] stat
- [x] mkdir (with recursive option)
- [x] rename
- [x] unlink
- [x] copyFile
- [x] readdir
- [x] rm (with recursive/force options)
- [x] cp (with recursive option)

### File Permissions & Ownership
- [x] chmod
- [x] chown

### Symbolic Links
- [x] symlink (with type)
- [x] readlink
- [x] realpath

### File Operations
- [x] truncate (with length)
- [x] rmdir (with recursive option)
- [x] access (with mode)

### Advanced Features
- [x] glob (with cwd, exclude, exclude_fn)
- [x] glob_with_filetype (returns Dirent)
- [x] open (returns FileHandle, WIP)

### Types
- [x] Dirent (with isFile, isDirectory, name)
- [ ] FileHandle (WIP)

## Not supported

- Callback APIs
  - Use synchronous APIs from `mizchi/js/node/fs` if callbacks are required
