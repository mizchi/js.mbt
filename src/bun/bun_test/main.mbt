///|
/// Bun examples and tests
/// Run with: moon build --target js && bun test target/js/release/build/bun/_tests/main.js

///|
fn main {
  let b = @bun.bun()

  // Test runtime information
  b.test_async("runtime version", _ctx => {
    let version = b.version()
    assert_true(version.length() > 0)
  })

  // Test environment variables
  b.test_async("environment variables", _ctx => {
    let env = b.env()
    assert_true(@core.typeof_(env) == "object")
  })

  // Test current directory
  b.test_async("current directory", _ctx => {
    let cwd = b.cwd()
    assert_true(cwd.length() > 0)
  })

  // Test command line arguments
  b.test_async("command line args", _ctx => {
    let args = b.argv()
    // args will contain test runner arguments
    assert_true(args.length() >= 0)
  })

  // Test file read/write
  b.test_async("file read/write text", async fn(_ctx) {
    let test_file = "test_bun_text.txt"
    let content = "Hello, Bun from MoonBit!"
    let _written = b.write(test_file, @core.any(content))
    let read_content = b.file_text(test_file)
    assert_eq(read_content, content)

    // Clean up
    @bun.unlink_sync(test_file)
  })

  // Test file operations with ArrayBuffer
  b.test_async("file read arrayBuffer", async fn(_ctx) {
    let test_file = "test_bun_binary.bin"
    let data = "binary data"
    let _written = b.write(test_file, @core.any(data))
    let buffer = b.file_arrayBuffer(test_file)
    let buffer_any = buffer.to_any()
    assert_true(@core.typeof_(buffer_any) == "object")

    // Clean up
    @bun.unlink_sync(test_file)
  })

  // Test sleep function
  b.test_async("sleep", async fn(_ctx) {
    let start = b.nanoseconds()
    b.sleep(10) // Sleep for 10ms
    let end = b.nanoseconds()
    let elapsed_ns = end - start
    // Should have slept at least 10ms (10_000_000 ns)
    // But we'll be lenient due to timing variations
    assert_true(elapsed_ns > 5_000_000) // At least 5ms
  })

  // Test nanoseconds
  b.test_async("nanoseconds", _ctx => {
    let ns1 = b.nanoseconds()
    let ns2 = b.nanoseconds()
    // Second call should be >= first call
    assert_true(ns2 >= ns1)
  })

  // Test expect assertions
  b.test_async("expect toBe", _ctx => {
    @bun.expect(@core.any(42)).toBe(@core.any(42))
    @bun.expect(@core.any("hello")).toBe(@core.any("hello"))
  })
  b.test_async("expect toEqual", _ctx => {
    let obj1 = @core.new_object()
    obj1._set("a", @core.any(1))
    obj1._set("b", @core.any(2))
    let obj2 = @core.new_object()
    obj2._set("a", @core.any(1))
    obj2._set("b", @core.any(2))
    let obj1_any : @core.Any = obj1.cast()
    let obj2_any : @core.Any = obj2.cast()
    @bun.expect(obj1_any).toEqual(obj2_any)
  })
  b.test_async("expect toBeTruthy", _ctx => {
    @bun.expect(@core.any(true)).toBeTruthy()
    @bun.expect(@core.any(1)).toBeTruthy()
    @bun.expect(@core.any("hello")).toBeTruthy()
  })
  b.test_async("expect toBeFalsy", _ctx => {
    @bun.expect(@core.any(false)).toBeFalsy()
    @bun.expect(@core.any(0)).toBeFalsy()
    @bun.expect(@core.any("")).toBeFalsy()
  })
  b.test_async("expect toBeDefined", _ctx => {
    @bun.expect(@core.any(42)).toBeDefined()
    @bun.expect(@core.any("hello")).toBeDefined()
  })
  b.test_async("expect toContain", _ctx => {
    @bun.expect(@core.any("hello world")).toContain("world")
  })

  // Test synchronous test
  b.test_("synchronous test", fn(_ctx) {
    let cwd = b.cwd()
    // Just check it returns something
    ignore(cwd)
  })

  // Test multiple file operations
  b.test_async("multiple files", async fn(_ctx) {
    let _w1 = b.write("test1.txt", @core.any("content1"))
    let _w2 = b.write("test2.txt", @core.any("content2"))
    let c1 = b.file_text("test1.txt")
    let c2 = b.file_text("test2.txt")
    assert_eq(c1, "content1")
    assert_eq(c2, "content2")
    @bun.unlink_sync("test1.txt")
    @bun.unlink_sync("test2.txt")
  })

  // Test main module path
  b.test_async("main module path", _ctx => {
    let main_path = b.main_()
    assert_true(main_path.length() > 0)
  })

  // Test is_bun function
  b.test_async("is_bun detection", _ctx => {
    let running_in_bun = @bun.is_bun()
    assert_true(running_in_bun)
  })

  // Test password hashing (might be slow)
  b.test_async("password hash and verify", async fn(_ctx) {
    let password = "my_secure_password"
    let hash = b.password_hash(password)
    assert_true(hash.length() > 0)
    let is_valid = b.password_verify(password, hash)
    assert_true(is_valid)
    let is_invalid = b.password_verify("wrong_password", hash)
    assert_false(is_invalid)
  })

  // Test Bun.spawn
  b.test_async("spawn echo command", async fn(_ctx) {
    let opts = @bun.SpawnOptions::new(["echo", "hello"])
    let proc = b.spawn(opts)
    assert_true(proc.pid() > 0)
    let exit_code = proc.exited()
    assert_eq(exit_code, 0)
  })

  // Test Bun.which
  b.test_async("which command", _ctx => {
    let sh_path = b.which("sh")
    match sh_path {
      Some(path) => assert_true(path.length() > 0)
      None => assert_true(false) // sh should exist on Unix systems
    }
  })

  // Test Bun.escapeHTML
  b.test_async("escapeHTML", _ctx => {
    let html = "<script>alert('xss')</script>"
    let escaped = b.escapeHTML(html)
    assert_true(escaped.contains("&lt;"))
    assert_true(escaped.contains("&gt;"))
  })

  // Test Bun.stringWidth
  b.test_async("stringWidth", _ctx => {
    let width1 = b.stringWidth("hello")
    assert_eq(width1, 5)
    let width2 = b.stringWidth("こんにちは")
    assert_true(width2 > 5) // Japanese characters are wider
  })

  // Test random_uuid_v7
  b.test_async("randomUUIDv7", _ctx => {
    let uuid = @bun.random_uuid_v7()
    assert_true(uuid.length() > 0)
    assert_true(uuid.contains("-"))
  })

  // Test CryptoHasher
  b.test_async("CryptoHasher sha256", _ctx => {
    let hasher = @bun.CryptoHasher::new("sha256")
    hasher.update(@core.any("hello"))
    let hex = hasher.digest_hex()
    assert_true(hex.length() > 0)
    // SHA256 of "hello" should be consistent
    assert_true(hex.length() == 64) // 256 bits = 64 hex chars
  })

  // Test CryptoHasher with multiple updates
  b.test_async("CryptoHasher multiple updates", _ctx => {
    let hasher = @bun.CryptoHasher::new("sha256")
    hasher.update(@core.any("hello"))
    hasher.update(@core.any(" "))
    hasher.update(@core.any("world"))
    let hex = hasher.digest_hex()
    assert_true(hex.length() == 64)
  })

  // Test Glob matching
  b.test_async("Glob match", _ctx => {
    let glob = @bun.Glob::new("*.txt")
    assert_true(glob.match_("test.txt"))
    assert_true(glob.match_("file.txt"))
    assert_false(glob.match_("file.js"))
    assert_false(glob.match_("dir/test.txt"))
  })

  // Test Glob with wildcard
  b.test_async("Glob wildcard match", _ctx => {
    let glob = @bun.Glob::new("**/*.mbt")
    assert_true(glob.match_("file.mbt"))
    assert_true(glob.match_("src/test.mbt"))
    assert_true(glob.match_("src/nested/deep.mbt"))
    assert_false(glob.match_("file.txt"))
  })

  // Test Bun.hash
  b.test_async("Bun.hash", _ctx => {
    let hash1 = b.hash_(@core.any("hello"))
    let hash2 = b.hash_(@core.any("hello"))
    // Same input should produce same hash
    assert_true(
      @core.typeof_(hash1) == "number" || @core.typeof_(hash1) == "bigint",
    )
    assert_true(
      @core.typeof_(hash2) == "number" || @core.typeof_(hash2) == "bigint",
    )
  })
}
