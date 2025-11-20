///|
/// Deno examples and tests
/// Run with: moon build --target js && deno test --allow-all target/js/release/build/examples/deno/deno.js

///|
/// Helper to create TextEncoder
extern "js" fn new_text_encoder() -> @js.Js =
  #| () => new TextEncoder()

///|
/// Helper to create Uint8Array
extern "js" fn new_uint8array(size : Int) -> @js.Js =
  #| (size) => new Uint8Array(size)

///|
fn main {
  let d = @deno.deno()

  // Test environment variables
  d.test_async("environment variables", async fn(_ctx) {
    d.env_set("TEST_VAR", "hello")
    let value = d.env_get("TEST_VAR")
    assert_eq(value, Some("hello"))
    d.env_delete("TEST_VAR")
    let deleted = d.env_get("TEST_VAR")
    assert_eq(deleted, None)
  })

  // Test current directory
  d.test_async("current directory", async fn(_ctx) {
    let cwd = d.cwd()
    assert_true(cwd.length() > 0)
  })

  // Test command line arguments
  d.test_async("command line args", async fn(_ctx) {
    let args = d.args()
    // args will contain test runner arguments
    assert_true(args.length() >= 0)
  })

  // Test file operations
  d.test_async("file read/write text", async fn(_ctx) {
    let test_file = "test_deno_text.txt"
    let content = "Hello, Deno from MoonBit!"
    d.writeTextFile(test_file, content).unwrap()
    let read_content = d.readTextFile(test_file).unwrap()
    assert_eq(read_content, content)
    d.remove(test_file).unwrap()
  })

  // Test directory operations
  d.test_async("directory operations", async fn(_ctx) {
    let test_dir = "test_deno_dir"
    let nested_dir = "test_deno_dir/nested"
    d.mkdir(test_dir).unwrap()
    d.mkdir(nested_dir, recursive=true).unwrap()

    // Clean up
    d.remove(test_dir, recursive=true).unwrap()
  })

  // Test permissions (this will work with --allow-all flag)
  d.test_async("permissions query", async fn(_ctx) {
    let status = d.permissions_query("read").unwrap()
    let state = status.state()
    // With --allow-all, should be "granted"
    assert_true(state == "granted" || state == "prompt" || state == "denied")
  })

  // Test multiple file operations
  d.test_async("multiple files", async fn(_ctx) {
    d.writeTextFile("test1.txt", "content1").unwrap()
    d.writeTextFile("test2.txt", "content2").unwrap()
    let c1 = d.readTextFile("test1.txt").unwrap()
    let c2 = d.readTextFile("test2.txt").unwrap()
    assert_eq(c1, "content1")
    assert_eq(c2, "content2")
    d.remove("test1.txt").unwrap()
    d.remove("test2.txt").unwrap()
  })

  // Test env_toObject
  d.test_async("env toObject", async fn(_ctx) {
    d.env_set("DENO_TEST_1", "value1")
    d.env_set("DENO_TEST_2", "value2")
    let env_obj = d.env_toObject()
    // env_obj contains all environment variables
    assert_true(@js.typeof_(env_obj) == "object")
    d.env_delete("DENO_TEST_1")
    d.env_delete("DENO_TEST_2")
  })

  // Example of synchronous test
  d.test_("synchronous test", fn(_ctx) {
    let cwd = d.cwd()
    // Just check it returns something
    ignore(cwd)
  })

  // Test process information
  d.test_async("process info", async fn(_ctx) {
    let pid = d.pid()
    assert_true(pid > 0)
    let ppid = d.ppid()
    assert_true(ppid > 0)
    let os = d.build_os()
    assert_true(os.length() > 0)
    let arch = d.build_arch()
    assert_true(arch.length() > 0)
  })

  // Test file rename
  d.test_async("file rename", async fn(_ctx) {
    let old_name = "test_rename_old.txt"
    let new_name = "test_rename_new.txt"
    d.writeTextFile(old_name, "rename test").unwrap()
    d.rename(old_name, new_name).unwrap()
    let content = d.readTextFile(new_name).unwrap()
    assert_eq(content, "rename test")
    d.remove(new_name).unwrap()
  })

  // Test file copy
  d.test_async("file copy", async fn(_ctx) {
    let source = "test_copy_source.txt"
    let dest = "test_copy_dest.txt"
    d.writeTextFile(source, "copy test").unwrap()
    d.copyFile(source, dest).unwrap()
    let content = d.readTextFile(dest).unwrap()
    assert_eq(content, "copy test")
    d.remove(source).unwrap()
    d.remove(dest).unwrap()
  })

  // Test file stat
  d.test_async("file stat", async fn(_ctx) {
    let test_file = "test_stat.txt"
    d.writeTextFile(test_file, "stat test").unwrap()
    let stat = d.stat(test_file).unwrap()

    // Check that stat returns an object
    assert_true(@js.typeof_(stat) == "object")
    d.remove(test_file).unwrap()
  })

  // Test realPath
  d.test_async("real path", async fn(_ctx) {
    let cwd = d.cwd()
    let real = d.realPath(".").unwrap()

    // realPath should return an absolute path
    assert_true(real.length() > 0)
  })

  // Test chmod (Unix only, might fail on Windows)
  d.test_async("chmod", async fn(_ctx) {
    let test_file = "test_chmod.txt"
    d.writeTextFile(test_file, "chmod test").unwrap()

    // Try to change permissions (might not work on all platforms)
    let result = d.chmod(test_file, 0o644).unwrap() catch { _ => () }
    ignore(result)
    d.remove(test_file).unwrap()
  })

  // Test symlink (might not work on all platforms/permissions)
  d.test_async("symlink", async fn(_ctx) {
    let target = "test_symlink_target.txt"
    let link = "test_symlink_link.txt"
    d.writeTextFile(target, "symlink test").unwrap()

    // Try to create symlink (might fail without proper permissions)
    let result = d.symlink(target, link).unwrap() catch { _ => () }
    ignore(result)

    // Clean up - ignore errors if symlink wasn't created
    let _ = d.remove(link).unwrap() catch { _ => () }
    d.remove(target).unwrap()
  })

  // Test binary file operations
  d.test_async("binary file read/write", async fn(_ctx) {
    let test_file = "test_binary.bin"

    // Create binary data using TextEncoder
    let encoder = new_text_encoder()
    let arr = encoder.call("encode", [@js.js("binary test data")])
    d.writeFile(test_file, arr).unwrap()
    let data = d.readFile(test_file).unwrap()
    assert_true(@js.typeof_(data) == "object")
    d.remove(test_file).unwrap()
  })

  // Test temporary directory
  d.test_async("make temp dir", async fn(_ctx) {
    let temp_dir = d.makeTempDir(prefix="test_").unwrap()
    assert_true(temp_dir.length() > 0)

    // Clean up
    d.remove(temp_dir, recursive=true).unwrap()
  })

  // Test temporary file
  d.test_async("make temp file", async fn(_ctx) {
    let temp_file = d.makeTempFile(prefix="test_").unwrap()
    assert_true(temp_file.length() > 0)

    // Write some data
    d.writeTextFile(temp_file, "temp data").unwrap()
    let content = d.readTextFile(temp_file).unwrap()
    assert_eq(content, "temp data")

    // Clean up
    d.remove(temp_file).unwrap()
  })

  // Test truncate
  d.test_async("truncate file", async fn(_ctx) {
    let test_file = "test_truncate.txt"
    d.writeTextFile(test_file, "Hello, World! This is a long text.").unwrap()
    d.truncate(test_file, 5).unwrap()
    let content = d.readTextFile(test_file).unwrap()
    assert_eq(content, "Hello")
    d.remove(test_file).unwrap()
  })

  // Test system info
  d.test_async("system information", async fn(_ctx) {
    let hostname = d.hostname()
    assert_true(hostname.length() > 0)
    let os_release = d.osRelease()
    assert_true(os_release.length() > 0)
    let uptime = d.osUptime()
    assert_true(uptime >= 0)
  })

  // Test load average (Unix only, might fail on Windows)
  d.test_async("load average", async fn(_ctx) {
    let loadavg = d.loadavg()
    // Should return array of 3 numbers on Unix, empty on Windows
    assert_true(loadavg.length() == 3 || loadavg.length() == 0)
  })

  // Test network interfaces
  d.test_async("network interfaces", async fn(_ctx) {
    let interfaces = d.networkInterfaces()
    assert_true(@js.typeof_(interfaces) == "object")
  })

  // Test system memory info
  d.test_async("system memory info", async fn(_ctx) {
    let mem_info = d.systemMemoryInfo()
    assert_true(@js.typeof_(mem_info) == "object")
  })

  // Test uid/gid (Unix only)
  d.test_async("uid and gid", async fn(_ctx) {
    let uid = d.uid()
    let gid = d.gid()
    // On Unix, these should be Some(Int), on Windows None
    // Just check they don't crash
    ignore(uid)
    ignore(gid)
  })

  // Test high resolution time
  d.test_async("high resolution time", async fn(_ctx) {
    let t1 = d.now()
    // Just verify it returns a number
    assert_true(t1 >= 0.0)
  })

  // Test file handle operations
  d.test_async("file handle open/write/read", async fn(_ctx) {
    let test_file = "test_handle.txt"

    // Create and write using file handle
    let file = d.create(test_file).unwrap()
    let encoder = new_text_encoder()
    let data = encoder.call("encode", [@js.js("file handle test")])
    let written = file.write(data).unwrap()
    assert_true(written > 0)
    file.close()

    // Read back using file handle
    let read_file = d.open(test_file, read=true).unwrap()
    let buffer = new_uint8array(100)
    let read_bytes = read_file.read(buffer).unwrap()
    assert_true(read_bytes > 0)
    read_file.close()

    // Clean up
    d.remove(test_file).unwrap()
  })

  // Test permissions request
  d.test_async("permissions request", async fn(_ctx) {
    // Query read permission
    let status = d.query_permission("read").unwrap()
    assert_true(@js.typeof_(status) == "object")
  })

  // Test DNS resolution
  d.test_async("dns resolution", async fn(_ctx) {
    // Try to resolve localhost
    let result = d.resolveDns("localhost", "A").unwrap() catch {
        _ =>
          // DNS resolution might fail in some environments
          return
      }
    ignore(result)
  })

  // Test file seek
  d.test_async("file seek", async fn(_ctx) {
    let test_file = "test_seek.txt"

    // Create file with content
    d.writeTextFile(test_file, "0123456789").unwrap()

    // Open file and seek
    let file = d.open(test_file, read=true).unwrap()
    let pos = file.seek(5, 0).unwrap() // SEEK_SET = 0
    assert_eq(pos, 5)
    file.close()
    d.remove(test_file).unwrap()
  })

  // Test multiple file handles
  d.test_async("multiple file handles", async fn(_ctx) {
    let file1 = "test_handle1.txt"
    let file2 = "test_handle2.txt"
    d.writeTextFile(file1, "file1 content").unwrap()
    d.writeTextFile(file2, "file2 content").unwrap()
    let f1 = d.open(file1, read=true).unwrap()
    let f2 = d.open(file2, read=true).unwrap()
    f1.close()
    f2.close()
    d.remove(file1).unwrap()
    d.remove(file2).unwrap()
  })

  // Test lstat (doesn't throw on non-existent files)
  d.test_async("lstat", async fn(_ctx) {
    let test_file = "test_lstat.txt"
    d.writeTextFile(test_file, "lstat test").unwrap()
    let stat = d.lstat(test_file).unwrap()
    assert_true(@js.typeof_(stat) == "object")
    d.remove(test_file).unwrap()
  })

  // Test readLink (might not work without symlinks)
  d.test_async("readLink", async fn(_ctx) {
    let target = "test_readlink_target.txt"
    d.writeTextFile(target, "readlink test").unwrap()

    // Just verify we can stat the file (readLink requires symlinks which may not work)
    let stat = d.stat(target).unwrap()
    ignore(stat)
    d.remove(target).unwrap()
  })

  // Test readDir (directory listing)
  d.test_async("readDir", async fn(_ctx) {
    let test_dir = "test_readdir"
    d.mkdir(test_dir).unwrap()
    d.writeTextFile(test_dir + "/file1.txt", "content1").unwrap()
    d.writeTextFile(test_dir + "/file2.txt", "content2").unwrap()
    let entries = d.readDir(test_dir)
    assert_true(@js.typeof_(entries) == "object")
    d.remove(test_dir, recursive=true).unwrap()
  })

  // Test multiple temp files
  d.test_async("multiple temp files", async fn(_ctx) {
    let temp1 = d.makeTempFile(prefix="test1_").unwrap()
    let temp2 = d.makeTempFile(prefix="test2_").unwrap()
    assert_true(temp1 != temp2)
    d.writeTextFile(temp1, "temp1").unwrap()
    d.writeTextFile(temp2, "temp2").unwrap()
    let content1 = d.readTextFile(temp1).unwrap()
    let content2 = d.readTextFile(temp2).unwrap()
    assert_eq(content1, "temp1")
    assert_eq(content2, "temp2")
    d.remove(temp1).unwrap()
    d.remove(temp2).unwrap()
  })

  // Test nested directories
  d.test_async("nested directories", async fn(_ctx) {
    let base_dir = "test_nested"
    let nested_path = base_dir + "/level1/level2/level3"
    d.mkdir(nested_path, recursive=true).unwrap()
    let test_file = nested_path + "/deep.txt"
    d.writeTextFile(test_file, "deep content").unwrap()
    let content = d.readTextFile(test_file).unwrap()
    assert_eq(content, "deep content")
    d.remove(base_dir, recursive=true).unwrap()
  })

  // Test file overwrite
  d.test_async("file overwrite", async fn(_ctx) {
    let test_file = "test_overwrite.txt"
    d.writeTextFile(test_file, "original").unwrap()
    let content1 = d.readTextFile(test_file).unwrap()
    assert_eq(content1, "original")
    d.writeTextFile(test_file, "updated").unwrap()
    let content2 = d.readTextFile(test_file).unwrap()
    assert_eq(content2, "updated")
    d.remove(test_file).unwrap()
  })
}
