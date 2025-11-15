///|
/// WASI API Tests

///|
using @js {js}

///| WASI Constructor Tests

///|
/// Test WASI constructor with preview1
test "WASI constructor creates instance with preview1" {
  let wasi = WASI::new({
    version: "preview1",
    args: Some(["test"]),
    env: Some(Map::from_array([("TEST_VAR", "test_value")])),
    preopens: None,
    return_on_exit: Some(true),
    stdin: None,
    stdout: None,
    stderr: None,
  })
  let import_obj = wasi.get_import_object()
  inspect(import_obj.type_of() == "object", content="true")
}

///|
/// Test WASI constructor with unstable version
test "WASI constructor creates instance with unstable" {
  let wasi = WASI::new({
    version: "unstable",
    args: None,
    env: None,
    preopens: None,
    return_on_exit: None,
    stdin: None,
    stdout: None,
    stderr: None,
  })
  let import_obj = wasi.get_import_object()
  inspect(import_obj.type_of() == "object", content="true")
}

///|
/// Test WASI with args option
test "WASI constructor accepts args" {
  let wasi = WASI::new({
    version: "preview1",
    args: Some(["arg1", "arg2", "arg3"]),
    env: None,
    preopens: None,
    return_on_exit: None,
    stdin: None,
    stdout: None,
    stderr: None,
  })
  let import_obj = wasi.get_import_object()
  inspect(import_obj.type_of() == "object", content="true")
}

///|
/// Test WASI with env option
test "WASI constructor accepts env" {
  let env_map = Map::from_array([("HOME", "/home/user"), ("PATH", "/usr/bin")])
  let wasi = WASI::new({
    version: "preview1",
    args: None,
    env: Some(env_map),
    preopens: None,
    return_on_exit: None,
    stdin: None,
    stdout: None,
    stderr: None,
  })
  let import_obj = wasi.get_import_object()
  inspect(import_obj.type_of() == "object", content="true")
}

///|
/// Test WASI with preopens option
test "WASI constructor accepts preopens" {
  let preopens_map = Map::from_array([("/tmp", "/tmp")])
  let wasi = WASI::new({
    version: "preview1",
    args: None,
    env: None,
    preopens: Some(preopens_map),
    return_on_exit: None,
    stdin: None,
    stdout: None,
    stderr: None,
  })
  let import_obj = wasi.get_import_object()
  inspect(import_obj.type_of() == "object", content="true")
}

///|
/// Test WASI with return_on_exit option
test "WASI constructor accepts return_on_exit" {
  let wasi = WASI::new({
    version: "preview1",
    args: None,
    env: None,
    preopens: None,
    return_on_exit: Some(false),
    stdin: None,
    stdout: None,
    stderr: None,
  })
  let import_obj = wasi.get_import_object()
  inspect(import_obj.type_of() == "object", content="true")
}

///|
/// Test WASI with file descriptor options
test "WASI constructor accepts fd options" {
  let wasi = WASI::new({
    version: "preview1",
    args: None,
    env: None,
    preopens: None,
    return_on_exit: None,
    stdin: Some(0),
    stdout: Some(1),
    stderr: Some(2),
  })
  let import_obj = wasi.get_import_object()
  inspect(import_obj.type_of() == "object", content="true")
}

///| WASI Methods Tests

///|
/// Test get_import_object returns valid object
test "get_import_object returns object" {
  let wasi = WASI::new({
    version: "preview1",
    args: None,
    env: None,
    preopens: None,
    return_on_exit: None,
    stdin: None,
    stdout: None,
    stderr: None,
  })
  let import_obj = wasi.get_import_object()
  inspect(import_obj.type_of() == "object", content="true")
  // Check that it has wasi_snapshot_preview1 key
  let has_preview1 = import_obj.get("wasi_snapshot_preview1").type_of() !=
    "undefined"
  inspect(has_preview1, content="true")
}

///|
/// Test wasi_import property
test "wasi_import returns object" {
  let wasi = WASI::new({
    version: "preview1",
    args: None,
    env: None,
    preopens: None,
    return_on_exit: None,
    stdin: None,
    stdout: None,
    stderr: None,
  })
  let wasi_import = wasi.wasi_import()
  inspect(wasi_import.type_of() == "object", content="true")
}

///| WASI Integration Tests

///|
/// Test WASI with actual WASM module
test "WASI can run hello-wasi.wasm" {
  let wasi = WASI::new({
    version: "preview1",
    args: Some(["hello-wasi"]),
    env: None,
    preopens: None,
    return_on_exit: Some(true),
    stdin: None,
    stdout: None,
    stderr: None,
  })

  // Read WASM file
  let fs = @node.require("node:fs")
  let wasm_bytes = fs.call_method("readFileSync", [
    "fixtures/hello-wasi.wasm" |> js,
  ])

  // Instantiate WASM module with WASI imports
  let import_obj = wasi.get_import_object()
  let wasm_module = @webassembly.WebAssemblyModule::from_buffer(
    wasm_bytes.cast(),
  )
  let instance = @webassembly.WebAssemblyInstance::from_module(
    wasm_module,
    Some(import_obj),
  )

  // Start WASI (this will call _start and print "Hello, WASI!\n")
  wasi.start(instance)
  inspect(true, content="true")
}
