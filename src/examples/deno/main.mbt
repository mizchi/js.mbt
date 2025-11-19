///|
/// Deno examples and tests
/// Run with: moon build --target js && deno test --allow-all target/js/release/build/examples/deno/deno.js

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
}
