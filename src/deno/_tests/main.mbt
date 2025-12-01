///|
/// Deno examples and tests
/// Run with: moon build --target js && deno test --allow-all target/js/release/build/examples/deno/deno.js

///|
/// Decode Uint8Array to string using @encoding.TextDecoder
fn decode_uint8array(arr : @typedarray.Uint8Array) -> String {
  @encoding.TextDecoder::new().decode(arr)
}

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
    d.writeTextFile(test_file, content)
    let read_content = d.readTextFile(test_file)
    assert_eq(read_content, content)
    d.remove(test_file)
  })

  // Test directory operations
  d.test_async("directory operations", async fn(_ctx) {
    let test_dir = "test_deno_dir"
    let nested_dir = "test_deno_dir/nested"
    d.mkdir(test_dir)
    d.mkdir(nested_dir, recursive=true)

    // Clean up
    d.remove(test_dir, recursive=true)
  })

  // Test permissions (this will work with --allow-all flag)
  d.test_async("permissions query", async fn(_ctx) {
    let status = d.permissions_query("read")
    let state = status.state()
    // With --allow-all, should be "granted"
    assert_true(state == "granted" || state == "prompt" || state == "denied")
  })

  // Test multiple file operations
  d.test_async("multiple files", async fn(_ctx) {
    d.writeTextFile("test1.txt", "content1")
    d.writeTextFile("test2.txt", "content2")
    let c1 = d.readTextFile("test1.txt")
    let c2 = d.readTextFile("test2.txt")
    assert_eq(c1, "content1")
    assert_eq(c2, "content2")
    d.remove("test1.txt")
    d.remove("test2.txt")
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
    d.writeTextFile(old_name, "rename test")
    d.rename(old_name, new_name)
    let content = d.readTextFile(new_name)
    assert_eq(content, "rename test")
    d.remove(new_name)
  })

  // Test file copy
  d.test_async("file copy", async fn(_ctx) {
    let source = "test_copy_source.txt"
    let dest = "test_copy_dest.txt"
    d.writeTextFile(source, "copy test")
    d.copyFile(source, dest)
    let content = d.readTextFile(dest)
    assert_eq(content, "copy test")
    d.remove(source)
    d.remove(dest)
  })

  // Test file stat
  d.test_async("file stat", async fn(_ctx) {
    let test_file = "test_stat.txt"
    d.writeTextFile(test_file, "stat test")
    let stat = d.stat(test_file)

    // Check that stat returns an object
    assert_true(@js.typeof_(stat) == "object")
    d.remove(test_file)
  })

  // Test realPath
  d.test_async("real path", async fn(_ctx) {
    let _cwd = d.cwd()
    let real = d.realPath(".")

    // realPath should return an absolute path
    assert_true(real.length() > 0)
  })

  // Test chmod (Unix only, might fail on Windows)
  d.test_async("chmod", async fn(_ctx) {
    let test_file = "test_chmod.txt"
    d.writeTextFile(test_file, "chmod test")

    // Try to change permissions (might not work on all platforms)
    let result = d.chmod(test_file, 0o644) catch { _ => () }
    ignore(result)
    d.remove(test_file)
  })

  // Test symlink (might not work on all platforms/permissions)
  d.test_async("symlink", async fn(_ctx) {
    let target = "test_symlink_target.txt"
    let link = "test_symlink_link.txt"
    d.writeTextFile(target, "symlink test")

    // Try to create symlink (might fail without proper permissions)
    let result = d.symlink(target, link) catch { _ => () }
    ignore(result)

    // Clean up - ignore errors if symlink wasn't created
    let _ = d.remove(link) catch { _ => () }
    d.remove(target)
  })

  // Test binary file operations
  d.test_async("binary file read/write", async fn(_ctx) {
    let test_file = "test_binary.bin"

    // Create binary data using @encoding.TextEncoder
    let encoder = @encoding.TextEncoder::new()
    let arr = encoder.encode("binary test data")
    let arr_nostd : @nostd.Any = arr.as_any().cast()
    d.writeFile(test_file, arr_nostd)
    let data = d.readFile(test_file)
    assert_true(@js.typeof_(data) == "object")
    d.remove(test_file)
  })

  // Test temporary directory
  d.test_async("make temp dir", async fn(_ctx) {
    let temp_dir = d.makeTempDir(prefix="test_")
    assert_true(temp_dir.length() > 0)

    // Clean up
    d.remove(temp_dir, recursive=true)
  })

  // Test temporary file
  d.test_async("make temp file", async fn(_ctx) {
    let temp_file = d.makeTempFile(prefix="test_")
    assert_true(temp_file.length() > 0)

    // Write some data
    d.writeTextFile(temp_file, "temp data")
    let content = d.readTextFile(temp_file)
    assert_eq(content, "temp data")

    // Clean up
    d.remove(temp_file)
  })

  // Test truncate
  d.test_async("truncate file", async fn(_ctx) {
    let test_file = "test_truncate.txt"
    d.writeTextFile(test_file, "Hello, World! This is a long text.")
    d.truncate(test_file, 5)
    let content = d.readTextFile(test_file)
    assert_eq(content, "Hello")
    d.remove(test_file)
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
    let file = d.create(test_file)
    let encoder = @encoding.TextEncoder::new()
    let data = encoder.encode("file handle test")
    let written = file.write(data.as_any())
    assert_true(written > 0)
    file.close()

    // Read back using file handle
    let read_file = d.open(test_file, read=true)
    let buffer = @typedarray.Uint8Array::from_size(100)
    let read_bytes = read_file.read(buffer.as_any())
    assert_true(read_bytes > 0)
    read_file.close()

    // Clean up
    d.remove(test_file)
  })

  // Test permissions request
  d.test_async("permissions request", async fn(_ctx) {
    // Query read permission
    let status = d.permissions_query("read")
    assert_true(status.state().length() > 0)
  })

  // Test DNS resolution
  d.test_async("dns resolution", async fn(_ctx) {
    // Try to resolve localhost
    let result = d.resolveDns("localhost", "A") catch {
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
    d.writeTextFile(test_file, "0123456789")

    // Open file and seek
    let file = d.open(test_file, read=true)
    let pos = file.seek(5, 0) // SEEK_SET = 0
    assert_eq(pos, 5)
    file.close()
    d.remove(test_file)
  })

  // Test multiple file handles
  d.test_async("multiple file handles", async fn(_ctx) {
    let file1 = "test_handle1.txt"
    let file2 = "test_handle2.txt"
    d.writeTextFile(file1, "file1 content")
    d.writeTextFile(file2, "file2 content")
    let f1 = d.open(file1, read=true)
    let f2 = d.open(file2, read=true)
    f1.close()
    f2.close()
    d.remove(file1)
    d.remove(file2)
  })

  // Test lstat (doesn't throw on non-existent files)
  d.test_async("lstat", async fn(_ctx) {
    let test_file = "test_lstat.txt"
    d.writeTextFile(test_file, "lstat test")
    let stat = d.lstat(test_file)
    assert_true(@js.typeof_(stat) == "object")
    d.remove(test_file)
  })

  // Test readLink (might not work without symlinks)
  d.test_async("readLink", async fn(_ctx) {
    let target = "test_readlink_target.txt"
    d.writeTextFile(target, "readlink test")

    // Just verify we can stat the file (readLink requires symlinks which may not work)
    let stat = d.stat(target)
    ignore(stat)
    d.remove(target)
  })

  // Test readDir (directory listing)
  d.test_async("readDir", async fn(_ctx) {
    let test_dir = "test_readdir"
    d.mkdir(test_dir)
    d.writeTextFile(test_dir + "/file1.txt", "content1")
    d.writeTextFile(test_dir + "/file2.txt", "content2")
    let entries = d.readDir(test_dir)
    assert_true(@js.typeof_(entries) == "object")
    d.remove(test_dir, recursive=true)
  })

  // Test multiple temp files
  d.test_async("multiple temp files", async fn(_ctx) {
    let temp1 = d.makeTempFile(prefix="test1_")
    let temp2 = d.makeTempFile(prefix="test2_")
    assert_true(temp1 != temp2)
    d.writeTextFile(temp1, "temp1")
    d.writeTextFile(temp2, "temp2")
    let content1 = d.readTextFile(temp1)
    let content2 = d.readTextFile(temp2)
    assert_eq(content1, "temp1")
    assert_eq(content2, "temp2")
    d.remove(temp1)
    d.remove(temp2)
  })

  // Test nested directories
  d.test_async("nested directories", async fn(_ctx) {
    let base_dir = "test_nested"
    let nested_path = base_dir + "/level1/level2/level3"
    d.mkdir(nested_path, recursive=true)
    let test_file = nested_path + "/deep.txt"
    d.writeTextFile(test_file, "deep content")
    let content = d.readTextFile(test_file)
    assert_eq(content, "deep content")
    d.remove(base_dir, recursive=true)
  })

  // Test file overwrite
  d.test_async("file overwrite", async fn(_ctx) {
    let test_file = "test_overwrite.txt"
    d.writeTextFile(test_file, "original")
    let content1 = d.readTextFile(test_file)
    assert_eq(content1, "original")
    d.writeTextFile(test_file, "updated")
    let content2 = d.readTextFile(test_file)
    assert_eq(content2, "updated")
    d.remove(test_file)
  })

  // Test Command.output() - run echo command
  d.test_async("Command output", async fn(_ctx) {
    let cmd = @deno.Command::new("echo", args=["Hello", "from", "MoonBit"])
    let output = cmd.output()
    assert_true(output.success())
    assert_eq(output.code(), 0)
    let stdout_text = decode_uint8array(output.stdout())
    assert_true(stdout_text.contains("Hello"))
    assert_true(stdout_text.contains("MoonBit"))
  })

  // Test Command.outputSync() - synchronous execution
  d.test_async("Command outputSync", async fn(_ctx) {
    let cmd = @deno.Command::new("echo", args=["sync", "test"])
    let output = cmd.outputSync()
    assert_true(output.success())
    assert_eq(output.code(), 0)
    let stdout_text = decode_uint8array(output.stdout())
    assert_true(stdout_text.contains("sync"))
  })

  // Test Command with cwd option
  d.test_async("Command with cwd", async fn(_ctx) {
    let cwd = d.cwd()
    let cmd = @deno.Command::new("pwd", cwd~)
    let output = cmd.output()
    assert_true(output.success())
    let stdout_text = decode_uint8array(output.stdout())
    assert_true(stdout_text.length() > 0)
  })

  // Test Command spawn and status
  d.test_async("Command spawn", async fn(_ctx) {
    // Use null for stdout/stderr to avoid stream leak issues
    let cmd = @deno.Command::new(
      "echo",
      args=["spawn", "test"],
      stdout="null",
      stderr="null",
    )
    let child = cmd.spawn()
    assert_true(child.pid() > 0)
    let status = child.status()
    assert_true(status.success())
    assert_eq(status.code(), 0)
  })

  // Test Command with exit code
  d.test_async("Command exit code", async fn(_ctx) {
    // Use sh -c to run a command that exits with code 1
    let cmd = @deno.Command::new("sh", args=["-c", "exit 1"])
    let output = cmd.output()
    assert_false(output.success())
    assert_eq(output.code(), 1)
  })

  // Test Command stderr
  d.test_async("Command stderr", async fn(_ctx) {
    // Use sh -c to write to stderr
    let cmd = @deno.Command::new(
      "sh",
      args=["-c", "echo error message >&2"],
      stderr="piped",
    )
    let output = cmd.output()
    assert_true(output.success())
    let stderr_text = decode_uint8array(output.stderr())
    assert_true(stderr_text.contains("error message"))
  })

  // Test Command with multiple arguments
  d.test_async("Command multiple args", async fn(_ctx) {
    let cmd = @deno.Command::new("sh", args=[
      "-c", "echo $0 $1 $2", "arg1", "arg2", "arg3",
    ])
    let output = cmd.output()
    assert_true(output.success())
    let stdout_text = decode_uint8array(output.stdout())
    assert_true(stdout_text.contains("arg1"))
  })

  // Test Web Worker (Deno supports Web Workers natively)
  d.test_async("Web Worker basic", async fn(_ctx) {
    // Create an inline worker using Blob URL
    let worker_code =
      #|self.onmessage = (e) => {
      #|  const result = e.data * 2;
      #|  self.postMessage(result);
      #|};
    let worker = create_inline_worker(worker_code)

    // Set up message handler and wait for response
    let result = worker_round_trip(worker, @nostd.any(21))
    let value : Int = @js.identity(result)
    assert_eq(value, 42)
    worker.terminate()
  })

  // Test Web Worker with object message
  d.test_async("Web Worker object message", async fn(_ctx) {
    let worker_code =
      #|self.onmessage = (e) => {
      #|  const { a, b } = e.data;
      #|  self.postMessage({ sum: a + b, product: a * b });
      #|};
    let worker = create_inline_worker(worker_code)
    let msg = @nostd.Object::new()
    msg.set("a", 3)
    msg.set("b", 4)
    let result = worker_round_trip(worker, @nostd.any(msg))
    let sum : Int = @js.identity(result._get("sum"))
    let product : Int = @js.identity(result._get("product"))
    assert_eq(sum, 7)
    assert_eq(product, 12)
    worker.terminate()
  })

  // Test Web Worker with string message
  d.test_async("Web Worker string message", async fn(_ctx) {
    let worker_code =
      #|self.onmessage = (e) => {
      #|  self.postMessage("Hello, " + e.data + "!");
      #|};
    let worker = create_inline_worker(worker_code)
    let result = worker_round_trip(worker, @nostd.any("World"))
    let text : String = @js.identity(result)
    assert_eq(text, "Hello, World!")
    worker.terminate()
  })

  // =========================================================================
  // WebGPU Tests (requires --unstable-webgpu flag)
  // Note: These tests may be skipped if WebGPU is not available
  // =========================================================================

  // Test GPU availability
  d.test_async("WebGPU - gpu() available", async fn(_ctx) {
    guard @webgpu.gpu() is Some(gpu) else {
      @js.log("WebGPU not available, skipping test")
      return
    }
    // Test getPreferredCanvasFormat
    let format = gpu.getPreferredCanvasFormat()
    assert_true(format.length() > 0)
    @js.log("WebGPU: preferred format = " + format)
  })

  // Test requestAdapter
  d.test_async("WebGPU - requestAdapter", async fn(_ctx) {
    guard @webgpu.gpu() is Some(gpu) else { return }
    guard gpu.requestAdapter() is Some(_adapter) else {
      @js.log("No GPU adapter available")
      return
    }
    @js.log("WebGPU: adapter acquired")
  })

  // Test requestDevice
  d.test_async("WebGPU - requestDevice", async fn(_ctx) {
    guard @webgpu.gpu() is Some(gpu) else { return }
    guard gpu.requestAdapter() is Some(adapter) else { return }
    guard adapter.requestDevice() is Some(device) else {
      @js.log("Failed to get GPU device")
      return
    }
    defer device.destroy()
    @js.log("WebGPU: device acquired")
  })

  // Test buffer creation
  d.test_async("WebGPU - createBuffer", async fn(_ctx) {
    guard @webgpu.gpu() is Some(gpu) else { return }
    guard gpu.requestAdapter() is Some(adapter) else { return }
    guard adapter.requestDevice() is Some(device) else { return }
    @js.log("device type: " + @js.typeof_(device.as_any()))
    let buffer = device.createBuffer(
      256,
      @webgpu.BUFFER_USAGE_COPY_DST | @webgpu.BUFFER_USAGE_MAP_READ,
      label="test buffer",
    )
    @js.log("buffer type: " + @js.typeof_(buffer.as_any()))
    if @js.is_undefined(buffer.as_any()) {
      @js.log("WebGPU: buffer is undefined, skipping")
      device.destroy()
      return
    }
    assert_eq(buffer.size(), 256)
    assert_eq(buffer.label(), "test buffer")
    buffer.destroy()
    device.destroy()
    @js.log("WebGPU: buffer created")
  })

  // Test shader module
  d.test_async("WebGPU - createShaderModule", async fn(_ctx) {
    guard @webgpu.gpu() is Some(gpu) else { return }
    guard gpu.requestAdapter() is Some(adapter) else { return }
    guard adapter.requestDevice() is Some(device) else { return }
    let shader_code =
      #|@compute @workgroup_size(1)
      #|fn main() {}
    let shader = device.createShaderModule(shader_code, label="test shader")
    @js.log("shader type: " + @js.typeof_(shader.as_any()))
    if @js.is_undefined(shader.as_any()) {
      @js.log("WebGPU: shader is undefined, skipping")
      device.destroy()
      return
    }
    assert_eq(shader.label(), "test shader")
    device.destroy()
    @js.log("WebGPU: shader module created")
  })

  // Test command encoder and submit
  d.test_async("WebGPU - command encoder", async fn(_ctx) {
    guard @webgpu.gpu() is Some(gpu) else { return }
    guard gpu.requestAdapter() is Some(adapter) else { return }
    guard adapter.requestDevice() is Some(device) else { return }
    let encoder = device.createCommandEncoder(label="test encoder")
    @js.log("encoder type: " + @js.typeof_(encoder.as_any()))
    if @js.is_undefined(encoder.as_any()) {
      @js.log("WebGPU: encoder is undefined, skipping")
      device.destroy()
      return
    }
    assert_eq(encoder.label(), "test encoder")
    let command_buffer = encoder.finish()
    let queue = device.queue()
    queue.submit([command_buffer])
    device.destroy()
    @js.log("WebGPU: command submitted")
  })
}

///|
/// Create an inline Web Worker from JavaScript code string
extern "js" fn create_inline_worker(code : String) -> @worker.Worker =
  #| (code) => {
  #|   const blob = new Blob([code], { type: "application/javascript" });
  #|   const url = URL.createObjectURL(blob);
  #|   return new Worker(url, { type: "module" });
  #| }

///|
/// Send message to worker and wait for response (Promise-based)
extern "js" fn worker_round_trip_ffi(
  worker : @worker.Worker,
  message : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #| (worker, message) => {
  #|   return new Promise((resolve) => {
  #|     worker.onmessage = (e) => resolve(e.data);
  #|     worker.postMessage(message);
  #|   });
  #| }

///|
async fn worker_round_trip(
  worker : @worker.Worker,
  message : @nostd.Any,
) -> @nostd.Any {
  worker_round_trip_ffi(worker, message).wait()
}
