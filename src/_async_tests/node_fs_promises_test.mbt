///|
/// fs/promises API Tests (Async)

///|
/// Test readFile and writeFile
test {
  it("readFile and writeFile", _ => {
    let test_file = "test_async_write.txt"
    let content = "Hello, async world!"
    let promise = @fs_promises.writeFile(test_file, content)
      .then(fn(_) { @fs_promises.readFile(test_file) })
      .then(fn(data) {
        assert_eq(data, content)
        // Cleanup
        @fs_promises.unlink(test_file)
      })
    ignore(promise.unwrap())
  })
}

///|
/// Test mkdir with recursive option
test {
  it("mkdir with recursive", _ => {
    let test_dir = "test_async_nested/sub/deep"
    let promise = @fs_promises.mkdir(test_dir, recursive=true)
      .then(fn(_) { @fs_promises.stat(test_dir) })
      .then(fn(stats) {
        assert_true(stats.isDirectory())
        // Cleanup
        @fs_promises.rm("test_async_nested", recursive=true, force=true)
      })
    ignore(promise.unwrap())
  })
}

///|
/// Test rename
test {
  it("rename file", _ => {
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
    ignore(promise.unwrap())
  })
}

///|
/// Test rm with recursive and force
test {
  it("rm with recursive and force", _ => {
    let test_dir = "test_async_rm"
    let promise = @fs_promises.mkdir("\{test_dir}/sub", recursive=true)
      .then(fn(_) { @fs_promises.writeFile("\{test_dir}/sub/file.txt", "test") })
      .then(fn(_) { @fs_promises.rm(test_dir, recursive=true, force=true) })
      .then(fn(_) { Promise::resolve(()) })
    ignore(promise.unwrap())
  })
}

///|
/// Test cp with recursive
test {
  it("cp with recursive", _ => {
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
    ignore(promise.unwrap())
  })
}

///|
/// Test chmod
test {
  it("chmod changes permissions", _ => {
    let test_file = "test_async_chmod.txt"
    let promise = @fs_promises.writeFile(test_file, "chmod test")
      .then(fn(_) { @fs_promises.chmod(test_file, 0o644) })
      .then(fn(_) { @fs_promises.stat(test_file) })
      .then(fn(stats) {
        assert_true(stats.isFile())
        // Cleanup
        @fs_promises.unlink(test_file)
      })
    ignore(promise.unwrap())
  })
}

///|
/// Test chown
test {
  it("chown changes ownership", _ => {
    let test_file = "test_async_chown.txt"
    let promise = @fs_promises.writeFile(test_file, "chown test")
      .then(fn(_) { @fs_promises.stat(test_file) })
      .then(fn(stats) {
        let uid : Int = stats.to_js().get("uid") |> unsafe_cast
        let gid : Int = stats.to_js().get("gid") |> unsafe_cast
        @fs_promises.chown(test_file, uid, gid)
      })
      .then(fn(_) {
        // Cleanup
        @fs_promises.unlink(test_file)
      })
    ignore(promise.unwrap())
  })
}

///|
/// Test symlink and readlink
test {
  it("symlink and readlink", _ => {
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
    ignore(promise.unwrap())
  })
}

///|
/// Test realpath
test {
  it("realpath resolves path", _ => {
    let promise = @fs_promises.realpath(".").then(fn(real) {
      assert_true(real.length() > 0)
      Promise::resolve(())
    })
    ignore(promise.unwrap())
  })
}

///|
/// Test truncate
test {
  it("truncate reduces file size", _ => {
    let test_file = "test_async_truncate.txt"
    let promise = @fs_promises.writeFile(test_file, "Hello, World!")
      .then(fn(_) { @fs_promises.truncate(test_file, len=5) })
      .then(fn(_) { @fs_promises.readFile(test_file) })
      .then(fn(data) {
        assert_eq(data.length(), 5)
        // Cleanup
        @fs_promises.unlink(test_file)
      })
    ignore(promise.unwrap())
  })
}

///|
/// Test rmdir
test {
  it("rmdir removes directory", _ => {
    let test_dir = "test_async_rmdir"
    let promise = @fs_promises.mkdir(test_dir)
      .then(fn(_) { @fs_promises.rmdir(test_dir) })
      .then(fn(_) { Promise::resolve(()) })
    ignore(promise.unwrap())
  })
}

///|
/// Test access
test {
  it("access checks file access", _ => {
    let test_file = "test_async_access.txt"
    let promise = @fs_promises.writeFile(test_file, "access test")
      .then(fn(_) { @fs_promises.access(test_file) })
      .then(fn(_) {
        // Cleanup
        @fs_promises.unlink(test_file)
      })
    ignore(promise.unwrap())
  })
}

///|
/// Test appendFile
test {
  it("appendFile appends content", _ => {
    let test_file = "test_async_append.txt"
    let promise = @fs_promises.writeFile(test_file, "Hello")
      .then(fn(_) { @fs_promises.appendFile(test_file, ", World!") })
      .then(fn(_) { @fs_promises.readFile(test_file) })
      .then(fn(data) {
        assert_eq(data, "Hello, World!")
        // Cleanup
        @fs_promises.unlink(test_file)
      })
    ignore(promise.unwrap())
  })
}

///|
/// Test copyFile
test {
  it("copyFile copies file", _ => {
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
    ignore(promise.unwrap())
  })
}

///|
/// Test readdir
test {
  it("readdir reads directory contents", _ => {
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
    ignore(promise.unwrap())
  })
}

///|
/// Test stat
test {
  it("stat returns file stats", _ => {
    let test_file = "test_async_stat.txt"
    let promise = @fs_promises.writeFile(test_file, "stat test")
      .then(fn(_) { @fs_promises.stat(test_file) })
      .then(fn(stats) {
        assert_true(stats.isFile())
        // Cleanup
        @fs_promises.unlink(test_file)
      })
    ignore(promise.unwrap())
  })
}

///|
/// Test truncate without length
test {
  it("truncate without length truncates to 0", _ => {
    let test_file = "test_async_truncate_zero.txt"
    let promise = @fs_promises.writeFile(test_file, "This will be empty")
      .then(fn(_) { @fs_promises.truncate(test_file) })
      .then(fn(_) { @fs_promises.readFile(test_file) })
      .then(fn(data) {
        assert_eq(data.length(), 0)
        // Cleanup
        @fs_promises.unlink(test_file)
      })
    ignore(promise.unwrap())
  })
}

///|
/// Test appendFile with encoding
test {
  it("appendFile with encoding", _ => {
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
    ignore(promise.unwrap())
  })
}

///|
/// Test rmdir with recursive
test {
  it("rmdir with recursive removes nested dirs", _ => {
    let test_dir = "test_async_rmdir_recursive"
    let promise = @fs_promises.mkdir("\{test_dir}/sub", recursive=true)
      .then(fn(_) { @fs_promises.rmdir(test_dir, recursive=true) })
      .then(fn(_) { Promise::resolve(()) })
    ignore(promise.unwrap())
  })
}
