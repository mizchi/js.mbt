///|
/// fs/promises API Tests (Async)

///| File operations

///|
async test "Node FS Promises: readFile and writeFile" {
  let test_file = "test_async_write.txt"
  let content = "Hello, async world!"
  @fs_promises.writeFile(test_file, content)
  let data = @fs_promises.readFile(test_file)
  assert_eq(data, content)
  @fs_promises.unlink(test_file)
}

///|
async test "Node FS Promises: rename file" {
  let old_name = "test_async_rename_old.txt"
  let new_name = "test_async_rename_new.txt"
  @fs_promises.writeFile(old_name, "rename test")
  @fs_promises.rename(old_name, new_name)
  let data = @fs_promises.readFile(new_name)
  assert_eq(data, "rename test")
  @fs_promises.unlink(new_name)
}

///|
async test "Node FS Promises: chmod changes permissions" {
  let test_file = "test_async_chmod.txt"
  @fs_promises.writeFile(test_file, "chmod test")
  @fs_promises.chmod(test_file, 0o644)
  let stats = @fs_promises.stat(test_file)
  assert_true(stats.isFile())
  @fs_promises.unlink(test_file)
}

///|
async test "Node FS Promises: chown changes ownership" {
  let test_file = "test_async_chown.txt"
  @fs_promises.writeFile(test_file, "chown test")
  let stats = @fs_promises.stat(test_file)
  let uid : Int = stats.as_any().get("uid").cast()
  let gid : Int = stats.as_any().get("gid").cast()
  @fs_promises.chown(test_file, uid, gid)
  @fs_promises.unlink(test_file)
}

///|
async test "Node FS Promises: truncate reduces file size" {
  let test_file = "test_async_truncate.txt"
  @fs_promises.writeFile(test_file, "Hello, World!")
  @fs_promises.truncate(test_file, len=5)
  let data = @fs_promises.readFile(test_file)
  assert_eq(data.length(), 5)
  @fs_promises.unlink(test_file)
}

///|
async test "Node FS Promises: access checks file access" {
  let test_file = "test_async_access.txt"
  @fs_promises.writeFile(test_file, "access test")
  @fs_promises.access(test_file)
  @fs_promises.unlink(test_file)
}

///|
async test "Node FS Promises: appendFile appends content" {
  let test_file = "test_async_append.txt"
  @fs_promises.writeFile(test_file, "Hello")
  @fs_promises.appendFile(test_file, ", World!")
  let data = @fs_promises.readFile(test_file)
  assert_eq(data, "Hello, World!")
  @fs_promises.unlink(test_file)
}

///|
async test "Node FS Promises: copyFile copies file" {
  let src = "test_async_copy_src.txt"
  let dest = "test_async_copy_dest.txt"
  @fs_promises.writeFile(src, "copy test")
  @fs_promises.copyFile(src, dest)
  let data = @fs_promises.readFile(dest)
  assert_eq(data, "copy test")
  @fs_promises.unlink(src)
  @fs_promises.unlink(dest)
}

///|
async test "Node FS Promises: stat returns file stats" {
  let test_file = "test_async_stat.txt"
  @fs_promises.writeFile(test_file, "stat test")
  let stats = @fs_promises.stat(test_file)
  assert_true(stats.isFile())
  @fs_promises.unlink(test_file)
}

///|
async test "Node FS Promises: truncate without length truncates to 0" {
  let test_file = "test_async_truncate_zero.txt"
  @fs_promises.writeFile(test_file, "This will be empty")
  @fs_promises.truncate(test_file)
  let data = @fs_promises.readFile(test_file)
  assert_eq(data.length(), 0)
  @fs_promises.unlink(test_file)
}

///|
async test "Node FS Promises: appendFile with encoding" {
  let test_file = "test_async_append_enc.txt"
  @fs_promises.writeFile(test_file, "Hello")
  @fs_promises.appendFile(test_file, ", World!", encoding="utf8")
  let data = @fs_promises.readFile(test_file)
  assert_eq(data, "Hello, World!")
  @fs_promises.unlink(test_file)
}

///| Directory operations

///|
async test "Node FS Promises: mkdir with recursive" {
  let test_dir = "test_async_nested/sub/deep"
  @fs_promises.mkdir(test_dir, recursive=true)
  let stats = @fs_promises.stat(test_dir)
  assert_true(stats.isDirectory())
  @fs_promises.rm("test_async_nested", recursive=true, force=true)
}

///|
async test "Node FS Promises: rmdir removes directory" {
  let test_dir = "test_async_rmdir"
  @fs_promises.mkdir(test_dir)
  @fs_promises.rmdir(test_dir)
}

///|
async test "Node FS Promises: readdir reads directory contents" {
  let test_dir = "test_async_readdir"
  @fs_promises.mkdir(test_dir)
  @fs_promises.writeFile("\{test_dir}/file1.txt", "test")
  @fs_promises.writeFile("\{test_dir}/file2.txt", "test")
  let files = @fs_promises.readdir(test_dir)
  assert_eq(files.length(), 2)
  @fs_promises.rm(test_dir, recursive=true, force=true)
}

///|
async test "Node FS Promises: rmdir with recursive removes nested dirs" {
  let test_dir = "test_async_rmdir_recursive"
  @fs_promises.mkdir("\{test_dir}/sub", recursive=true)
  @fs_promises.rmdir(test_dir, recursive=true)
}

///| Directory tree operations

///|
async test "Node FS Promises: rm with recursive and force" {
  let test_dir = "test_async_rm"
  @fs_promises.mkdir("\{test_dir}/sub", recursive=true)
  @fs_promises.writeFile("\{test_dir}/sub/file.txt", "test")
  @fs_promises.rm(test_dir, recursive=true, force=true)
}

///|
async test "Node FS Promises: cp with recursive" {
  let src_dir = "test_async_cp_src"
  let dest_dir = "test_async_cp_dest"
  @fs_promises.mkdir(src_dir)
  @fs_promises.writeFile("\{src_dir}/file.txt", "test content")
  @fs_promises.cp(src_dir, dest_dir, recursive=true)
  let data = @fs_promises.readFile("\{dest_dir}/file.txt")
  assert_eq(data, "test content")
  @fs_promises.rm(src_dir, recursive=true, force=true)
  @fs_promises.rm(dest_dir, recursive=true, force=true)
}

///| Symbolic link operations

///|
async test "Node FS Promises: symlink and readlink" {
  let target = "test_async_symlink_target.txt"
  let link = "test_async_symlink_link.txt"
  @fs_promises.writeFile(target, "symlink test")
  @fs_promises.symlink(target, link)
  let link_target = @fs_promises.readlink(link)
  assert_eq(link_target, target)
  @fs_promises.unlink(link)
  @fs_promises.unlink(target)
}

///|
async test "Node FS Promises: realpath resolves path" {
  let real = @fs_promises.realpath(".")
  assert_true(real.length() > 0)
}
