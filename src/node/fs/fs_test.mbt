///|
/// Synchronous File System API Tests

///| File Reading Tests

///|
/// Test read_file_sync reads buffer
test "read_file_sync reads package.json" {
  let content = read_file_sync("package.json")
  inspect(@js.identity(content.get("length")) > 0, content="true")
}

///|
/// Test read_file_sync_string reads as string
test "read_file_sync_string reads package.json as utf8" {
  let content = read_file_sync_string("package.json", "utf8")
  inspect(content.contains("scripts"), content="true")
}

///| File Writing Tests

///|
/// Test write_file_sync and read_file_sync
test "write_file_sync creates file" {
  let test_file = "test_write_sync.txt"
  writeFileSync(test_file, "Hello, sync world!")
  let content = read_file_sync_string(test_file, "utf8")
  inspect(content == "Hello, sync world!", content="true")
  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test append_file_sync
test "append_file_sync appends to file" {
  let test_file = "test_append_sync.txt"
  writeFileSync(test_file, "Hello" |> @js.js)
  append_file_sync(test_file, ", World!" |> @js.js)
  let content = read_file_sync_string(test_file, "utf8")
  inspect(content == "Hello, World!", content="true")
  // Cleanup
  unlinkSync(test_file)
}

///| File/Directory Operations Tests

///|
/// Test exists_sync returns true for existing file
test "exists_sync returns true for package.json" {
  let exists = existsSync("package.json")
  inspect(exists, content="true")
}

///|
/// Test exists_sync returns false for non-existing file
test "exists_sync returns false for non-existing file" {
  let exists = existsSync("non_existing_file_12345.txt")
  inspect(exists == false, content="true")
}

///|
/// Test stat_sync returns file stats
test "stat_sync returns stats for package.json" {
  let stats = statSync("package.json")
  inspect(@js.typeof_(stats) == "object", content="true")
}

///|
/// Test mkdir_sync with recursive option
test "mkdir_sync creates nested directories" {
  let test_dir = "test_sync_nested/sub/deep"
  mkdirSync(test_dir, recursive=true)
  let exists = existsSync(test_dir)
  inspect(exists, content="true")
  // Cleanup
  rmSync("test_sync_nested", recursive=true)
}

///|
/// Test unlink_sync deletes file
test "unlink_sync deletes file" {
  let test_file = "test_unlink_sync.txt"
  writeFileSync(test_file, "delete me" |> @js.js)
  unlinkSync(test_file)
  let exists = existsSync(test_file)
  inspect(exists == false, content="true")
}

///|
/// Test rename_sync
test "rename_sync renames file" {
  let old_name = "test_rename_old.txt"
  let new_name = "test_rename_new.txt"
  writeFileSync(old_name, "rename test" |> @js.js)
  renameSync(old_name, new_name)
  let old_exists = existsSync(old_name)
  let new_exists = existsSync(new_name)
  inspect(old_exists == false, content="true")
  inspect(new_exists, content="true")
  // Cleanup
  unlinkSync(new_name)
}

///|
/// Test copy_file_sync
test "copy_file_sync copies file" {
  let src = "test_copy_src.txt"
  let dest = "test_copy_dest.txt"
  writeFileSync(src, "copy test" |> @js.js)
  copyFileSync(src, dest)
  let src_content = read_file_sync_string(src, "utf8")
  let dest_content = read_file_sync_string(dest, "utf8")
  inspect(src_content == dest_content, content="true")
  // Cleanup
  unlinkSync(src)
  unlinkSync(dest)
}

///|
/// Test readdir_sync
test "readdir_sync reads directory contents" {
  let test_dir = "test_readdir_sync"
  mkdirSync(test_dir)
  writeFileSync("\{test_dir}/file1.txt", "test" |> @js.js)
  writeFileSync("\{test_dir}/file2.txt", "test" |> @js.js)
  let files = readdirSync(test_dir)
  inspect(files.length() == 2, content="true")
  // Cleanup
  rmSync(test_dir, recursive=true)
}

///| Additional File Operations Tests

///|
/// Test chmod_sync changes file permissions
test "chmod_sync changes permissions" {
  let test_file = "test_chmod.txt"
  writeFileSync(test_file, "chmod test" |> @js.js)
  chmodSync(test_file, 0o644)
  let exists = existsSync(test_file)
  inspect(exists, content="true")
  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test realpath_sync resolves path
test "realpath_sync resolves current directory" {
  let real = realpathSync(".")
  inspect(real.length() > 0, content="true")
}

///|
/// Test truncate_sync
test "truncate_sync truncates file" {
  let test_file = "test_truncate.txt"
  writeFileSync(test_file, "Hello, World!" |> @js.js)
  truncateSync(test_file, len=5)
  let content = read_file_sync_string(test_file, "utf8")
  inspect(content.length() == 5, content="true")
  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test rmdir_sync
test "rmdir_sync removes directory" {
  let test_dir = "test_rmdir"
  mkdirSync(test_dir)
  rmdirSync(test_dir)
  let exists = existsSync(test_dir)
  inspect(exists == false, content="true")
}

///|
/// Test access_sync
test "access_sync checks file access" {
  let test_file = "test_access.txt"
  writeFileSync(test_file, "access test" |> @js.js)
  accessSync(test_file, mode=fs_R_OK())
  let exists = existsSync(test_file)
  inspect(exists, content="true")
  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test cp_sync
test "cp_sync copies directory" {
  let src_dir = "test_cp_src"
  let dest_dir = "test_cp_dest"
  mkdirSync(src_dir)
  writeFileSync("\{src_dir}/file.txt", "test" |> @js.js)
  cpSync(src_dir, dest_dir, recursive=true)
  let dest_exists = existsSync("\{dest_dir}/file.txt")
  inspect(dest_exists, content="true")
  // Cleanup
  rmSync(src_dir, recursive=true)
  rmSync(dest_dir, recursive=true)
}

///|
/// Test open_sync and close_sync
test "open_sync and close_sync work with file descriptor" {
  let test_file = "test_fd.txt"
  writeFileSync(test_file, "fd test" |> @js.js)
  let fd = openSync(test_file, "r")
  inspect(fd > 0, content="true")
  closeSync(fd)
  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test file access constants
test "file access constants are defined" {
  inspect(fs_F_OK() == 0, content="true")
  inspect(fs_R_OK() == 4, content="true")
  inspect(fs_W_OK() == 2, content="true")
  inspect(fs_X_OK() == 1, content="true")
}

///| Additional Edge Case Tests

///|
/// Test symlink_sync and readlink_sync
test "symlink_sync and readlink_sync work with symlinks" {
  let target = "test_symlink_target.txt"
  let link = "test_symlink_link.txt"
  writeFileSync(target, "symlink test" |> @js.js)
  symlinkSync(target, link)
  let link_target = readlinkSync(link)
  inspect(link_target == target, content="true")
  // Cleanup
  unlinkSync(link)
  unlinkSync(target)
}

///|
/// Test chown_sync (requires appropriate permissions)
test "chown_sync changes file ownership" {
  let test_file = "test_chown.txt"
  writeFileSync(test_file, "chown test" |> @js.js)
  let stats = statSync(test_file)
  let uid : Int = stats.get("uid") |> @js.identity
  let gid : Int = stats.get("gid") |> @js.identity
  // Set to same owner (should succeed without elevated permissions)
  chownSync(test_file, uid, gid)
  let exists = existsSync(test_file)
  inspect(exists, content="true")
  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test readSync and writeSync with file descriptors
test "readSync and writeSync work with buffers" {
  let test_file = "test_rw_sync.txt"
  let write_data = "Hello, fd world!"

  // Write using file descriptor
  let write_fd = openSync(test_file, "w")
  let write_buffer = @buffer.Buffer::from_string(write_data)
  let written = writeSync(write_fd, write_buffer, 0, write_data.length(), None)
  inspect(written == write_data.length(), content="true")
  closeSync(write_fd)

  // Read using file descriptor
  let read_fd = openSync(test_file, "r")
  let read_buffer = @buffer.Buffer::alloc(100)
  let bytes_read = readSync(read_fd, read_buffer, 0, 100, None)
  inspect(bytes_read == write_data.length(), content="true")
  closeSync(read_fd)

  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test readSync with position parameter
test "readSync with position reads from specific offset" {
  let test_file = "test_read_pos.txt"
  writeFileSync(test_file, "0123456789" |> @js.js)
  let fd = openSync(test_file, "r")
  let buffer = @buffer.Buffer::alloc(5)
  // Read 5 bytes starting from position 3
  let bytes_read = readSync(fd, buffer, 0, 5, Some(3))
  inspect(bytes_read == 5, content="true")
  closeSync(fd)

  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test writeSync with position parameter
test "writeSync with position writes to specific offset" {
  let test_file = "test_write_pos.txt"
  writeFileSync(test_file, "0000000000" |> @js.js)
  let fd = openSync(test_file, "r+")
  let buffer = @buffer.Buffer::from_string("XXX")
  // Write 3 bytes starting at position 3
  let written = writeSync(fd, buffer, 0, 3, Some(3))
  inspect(written == 3, content="true")
  closeSync(fd)
  let content = read_file_sync_string(test_file, "utf8")
  inspect(content == "000XXX0000", content="true")

  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test mkdir_sync without recursive option
test "mkdir_sync creates single directory" {
  let test_dir = "test_mkdir_single"
  mkdirSync(test_dir)
  let exists = existsSync(test_dir)
  inspect(exists, content="true")
  // Cleanup
  rmdirSync(test_dir)
}

///|
/// Test rmSync with force option
test "rmSync with force removes non-existent file without error" {
  let non_existent = "non_existent_file_xyz.txt"
  // Should not throw error with force=true
  rmSync(non_existent, force=true)
  inspect(true, content="true")
}

///|
/// Test rmSync with recursive and force options
test "rmSync with recursive and force removes directory tree" {
  let test_dir = "test_rm_recursive"
  mkdirSync("\{test_dir}/sub", recursive=true)
  writeFileSync("\{test_dir}/sub/file.txt", "test" |> @js.js)
  rmSync(test_dir, recursive=true, force=true)
  let exists = existsSync(test_dir)
  inspect(exists == false, content="true")
}

///|
/// Test truncate_sync without length parameter
test "truncate_sync without length truncates to 0" {
  let test_file = "test_truncate_zero.txt"
  writeFileSync(test_file, "This will be empty" |> @js.js)
  truncateSync(test_file)
  let content = read_file_sync_string(test_file, "utf8")
  inspect(content.length() == 0, content="true")
  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test access_sync without mode parameter
test "access_sync without mode checks file existence" {
  let test_file = "test_access_default.txt"
  writeFileSync(test_file, "access test" |> @js.js)
  accessSync(test_file)
  let exists = existsSync(test_file)
  inspect(exists, content="true")
  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test cpSync without recursive option
test "cp_sync without recursive copies single file" {
  let src = "test_cp_file_src.txt"
  let dest = "test_cp_file_dest.txt"
  writeFileSync(src, "copy file test" |> @js.js)
  cpSync(src, dest)
  let dest_exists = existsSync(dest)
  inspect(dest_exists, content="true")
  // Cleanup
  unlinkSync(src)
  unlinkSync(dest)
}

///|
/// Test openSync with mode parameter
test "open_sync with mode creates file with permissions" {
  let test_file = "test_open_mode.txt"
  let fd = openSync(test_file, "w", mode=0o644)
  inspect(fd > 0, content="true")
  closeSync(fd)
  let exists = existsSync(test_file)
  inspect(exists, content="true")
  // Cleanup
  unlinkSync(test_file)
}

///|
/// Test rmdir_sync with recursive option
test "rmdir_sync with recursive removes nested directories" {
  let test_dir = "test_rmdir_recursive"
  mkdirSync("\{test_dir}/sub", recursive=true)
  rmdirSync(test_dir, recursive=true)
  let exists = existsSync(test_dir)
  inspect(exists == false, content="true")
}

///| Error Handling Tests

///|
/// Test read_file_as_string throws ThrowError for non-existent file
test "read_file_as_string throws error for non-existent file" {
  let mut error_caught = false
  try {
    let _ = read_file_as_string("/nonexistent/file/path/12345.txt")

  } catch {
    _ => error_caught = true
  }
  inspect(error_caught, content="true")
}

///|
/// Test read_file_as_buffer throws ThrowError for non-existent file
test "read_file_as_buffer throws error for non-existent file" {
  let mut error_caught = false
  try {
    let _ = read_file_as_buffer("/nonexistent/file/path/12345.txt")

  } catch {
    _ => error_caught = true
  }
  inspect(error_caught, content="true")
}
