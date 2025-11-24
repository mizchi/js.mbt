///|
/// fs/promises API Tests (Async)

///| File operations

///|
async test "Node FS Promises: readFile and writeFile" {
  let test_file = "test_async_write.txt"
  let content = "Hello, async world!"
  let promise = @fs_promises.writeFile(test_file, content)
    .then(fn(_) { @fs_promises.readFile(test_file) })
    .then(fn(data) {
      assert_eq(data, content)
      // Cleanup
      @fs_promises.unlink(test_file)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: rename file" {
  let old_name = "test_async_rename_old.txt"
  let new_name = "test_async_rename_new.txt"
  let promise = @fs_promises.writeFile(old_name, "rename test")
    .then(fn(_) { @fs_promises.rename(old_name, new_name) })
    .then(fn(_) { @fs_promises.readFile(new_name) })
    .then(fn(data) {
      assert_eq(data, "rename test")
      // Cleanup
      @fs_promises.unlink(new_name)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: chmod changes permissions" {
  let test_file = "test_async_chmod.txt"
  let promise = @fs_promises.writeFile(test_file, "chmod test")
    .then(fn(_) { @fs_promises.chmod(test_file, 0o644) })
    .then(fn(_) { @fs_promises.stat(test_file) })
    .then(fn(stats) {
      assert_true(stats.isFile())
      // Cleanup
      @fs_promises.unlink(test_file)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: chown changes ownership" {
  let test_file = "test_async_chown.txt"
  let promise = @fs_promises.writeFile(test_file, "chown test")
    .then(fn(_) { @fs_promises.stat(test_file) })
    .then(fn(stats) {
      let uid : Int = stats.to_js().get("uid") |> @js.unsafe_cast
      let gid : Int = stats.to_js().get("gid") |> @js.unsafe_cast
      @fs_promises.chown(test_file, uid, gid)
    })
    .then(fn(_) {
      // Cleanup
      @fs_promises.unlink(test_file)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: truncate reduces file size" {
  let test_file = "test_async_truncate.txt"
  let promise = @fs_promises.writeFile(test_file, "Hello, World!")
    .then(fn(_) { @fs_promises.truncate(test_file, len=5) })
    .then(fn(_) { @fs_promises.readFile(test_file) })
    .then(fn(data) {
      assert_eq(data.length(), 5)
      // Cleanup
      @fs_promises.unlink(test_file)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: access checks file access" {
  let test_file = "test_async_access.txt"
  let promise = @fs_promises.writeFile(test_file, "access test")
    .then(fn(_) { @fs_promises.access(test_file) })
    .then(fn(_) {
      // Cleanup
      @fs_promises.unlink(test_file)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: appendFile appends content" {
  let test_file = "test_async_append.txt"
  let promise = @fs_promises.writeFile(test_file, "Hello")
    .then(fn(_) { @fs_promises.appendFile(test_file, ", World!") })
    .then(fn(_) { @fs_promises.readFile(test_file) })
    .then(fn(data) {
      assert_eq(data, "Hello, World!")
      // Cleanup
      @fs_promises.unlink(test_file)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: copyFile copies file" {
  let src = "test_async_copy_src.txt"
  let dest = "test_async_copy_dest.txt"
  let promise = @fs_promises.writeFile(src, "copy test")
    .then(fn(_) { @fs_promises.copyFile(src, dest) })
    .then(fn(_) { @fs_promises.readFile(dest) })
    .then(fn(data) {
      assert_eq(data, "copy test")
      // Cleanup
      @fs_promises.unlink(src).then(fn(_) { @fs_promises.unlink(dest) })
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: stat returns file stats" {
  let test_file = "test_async_stat.txt"
  let promise = @fs_promises.writeFile(test_file, "stat test")
    .then(fn(_) { @fs_promises.stat(test_file) })
    .then(fn(stats) {
      assert_true(stats.isFile())
      // Cleanup
      @fs_promises.unlink(test_file)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: truncate without length truncates to 0" {
  let test_file = "test_async_truncate_zero.txt"
  let promise = @fs_promises.writeFile(test_file, "This will be empty")
    .then(fn(_) { @fs_promises.truncate(test_file) })
    .then(fn(_) { @fs_promises.readFile(test_file) })
    .then(fn(data) {
      assert_eq(data.length(), 0)
      // Cleanup
      @fs_promises.unlink(test_file)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: appendFile with encoding" {
  let test_file = "test_async_append_enc.txt"
  let promise = @fs_promises.writeFile(test_file, "Hello")
    .then(fn(_) {
      @fs_promises.appendFile(test_file, ", World!", encoding="utf8")
    })
    .then(fn(_) { @fs_promises.readFile(test_file) })
    .then(fn(data) {
      assert_eq(data, "Hello, World!")
      // Cleanup
      @fs_promises.unlink(test_file)
    })
  ignore(promise.wait())
}

///| Directory operations

///|
async test "Node FS Promises: mkdir with recursive" {
  let test_dir = "test_async_nested/sub/deep"
  let promise = @fs_promises.mkdir(test_dir, recursive=true)
    .then(fn(_) { @fs_promises.stat(test_dir) })
    .then(fn(stats) {
      assert_true(stats.isDirectory())
      // Cleanup
      @fs_promises.rm("test_async_nested", recursive=true, force=true)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: rmdir removes directory" {
  let test_dir = "test_async_rmdir"
  let promise = @fs_promises.mkdir(test_dir)
    .then(fn(_) { @fs_promises.rmdir(test_dir) })
    .then(fn(_) { @js.Promise::resolve(()) })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: readdir reads directory contents" {
  let test_dir = "test_async_readdir"
  let promise = @fs_promises.mkdir(test_dir)
    .then(fn(_) { @fs_promises.writeFile("\{test_dir}/file1.txt", "test") })
    .then(fn(_) { @fs_promises.writeFile("\{test_dir}/file2.txt", "test") })
    .then(fn(_) { @fs_promises.readdir(test_dir) })
    .then(fn(files) {
      assert_eq(files.length(), 2)
      // Cleanup
      @fs_promises.rm(test_dir, recursive=true, force=true)
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: rmdir with recursive removes nested dirs" {
  let test_dir = "test_async_rmdir_recursive"
  let promise = @fs_promises.mkdir("\{test_dir}/sub", recursive=true)
    .then(fn(_) { @fs_promises.rmdir(test_dir, recursive=true) })
    .then(fn(_) { @js.Promise::resolve(()) })
  ignore(promise.wait())
}

///| Directory tree operations

///|
async test "Node FS Promises: rm with recursive and force" {
  let test_dir = "test_async_rm"
  let promise = @fs_promises.mkdir("\{test_dir}/sub", recursive=true)
    .then(fn(_) { @fs_promises.writeFile("\{test_dir}/sub/file.txt", "test") })
    .then(fn(_) { @fs_promises.rm(test_dir, recursive=true, force=true) })
    .then(fn(_) { @js.Promise::resolve(()) })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: cp with recursive" {
  let src_dir = "test_async_cp_src"
  let dest_dir = "test_async_cp_dest"
  let promise = @fs_promises.mkdir(src_dir)
    .then(fn(_) {
      @fs_promises.writeFile("\{src_dir}/file.txt", "test content")
    })
    .then(fn(_) { @fs_promises.cp(src_dir, dest_dir, recursive=true) })
    .then(fn(_) { @fs_promises.readFile("\{dest_dir}/file.txt") })
    .then(fn(data) {
      assert_eq(data, "test content")
      // Cleanup
      @fs_promises.rm(src_dir, recursive=true, force=true).then(fn(_) {
        @fs_promises.rm(dest_dir, recursive=true, force=true)
      })
    })
  ignore(promise.wait())
}

///| Symbolic link operations

///|
async test "Node FS Promises: symlink and readlink" {
  let target = "test_async_symlink_target.txt"
  let link = "test_async_symlink_link.txt"
  let promise = @fs_promises.writeFile(target, "symlink test")
    .then(fn(_) { @fs_promises.symlink(target, link) })
    .then(fn(_) { @fs_promises.readlink(link) })
    .then(fn(link_target) {
      assert_eq(link_target, target)
      // Cleanup
      @fs_promises.unlink(link).then(fn(_) { @fs_promises.unlink(target) })
    })
  ignore(promise.wait())
}

///|
async test "Node FS Promises: realpath resolves path" {
  let promise = @fs_promises.realpath(".").then(fn(real) {
    assert_true(real.length() > 0)
    @js.Promise::resolve(())
  })
  ignore(promise.wait())
}
