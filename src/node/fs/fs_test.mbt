///|
using @js {js, unsafe_cast}

///|
/// Synchronous File System API Tests

///| File Reading Tests

///|
/// Test read_file_sync reads buffer
test "read_file_sync reads package.json" {
  let content = read_file_sync("package.json")
  inspect(unsafe_cast(content.get("length")) > 0, content="true")
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
  writeFileSync(test_file, "Hello" |> js)
  append_file_sync(test_file, ", World!" |> js)
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
  writeFileSync(test_file, "delete me" |> js)
  unlinkSync(test_file)
  let exists = existsSync(test_file)
  inspect(exists == false, content="true")
}

///|
/// Test rename_sync
test "rename_sync renames file" {
  let old_name = "test_rename_old.txt"
  let new_name = "test_rename_new.txt"
  writeFileSync(old_name, "rename test" |> js)
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
  writeFileSync(src, "copy test" |> js)
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
  writeFileSync("\{test_dir}/file1.txt", "test" |> js)
  writeFileSync("\{test_dir}/file2.txt", "test" |> js)
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
  writeFileSync(test_file, "chmod test" |> js)
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
  writeFileSync(test_file, "Hello, World!" |> js)
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
  writeFileSync(test_file, "access test" |> js)
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
  writeFileSync("\{src_dir}/file.txt", "test" |> js)
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
  writeFileSync(test_file, "fd test" |> js)
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
