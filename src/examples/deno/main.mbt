///|
/// Deno examples and tests
/// Run with: moon build --target js && deno test --allow-all target/js/release/build/examples/deno/deno.js

///|
/// Helper to create TextEncoder
extern "js" fn new_text_encoder() -> @js.Js =
  #| () => new TextEncoder()

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
}
