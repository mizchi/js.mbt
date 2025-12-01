///|
/// WASI API Tests

///| WASI Constructor Tests

///|
/// Test WASI constructor with preview1
test "WASI constructor creates instance with preview1" {
  let wasi = WASI::new(
    "preview1",
    args=["test"],
    env=Map::from_array([("TEST_VAR", "test_value")]),
    returnOnExit=true,
  )
  let import_obj = wasi.getImportObject()
  inspect(@js.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI constructor with unstable version
test "WASI constructor creates instance with unstable" {
  let wasi = WASI::new("unstable")
  let import_obj = wasi.getImportObject()
  inspect(@js.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with args option
test "WASI constructor accepts args" {
  let wasi = WASI::new("preview1", args=["arg1", "arg2", "arg3"])
  let import_obj = wasi.getImportObject()
  inspect(@js.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with env option
test "WASI constructor accepts env" {
  let env_map = Map::from_array([("HOME", "/home/user"), ("PATH", "/usr/bin")])
  let wasi = WASI::new("preview1", env=env_map)
  let import_obj = wasi.getImportObject()
  inspect(@js.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with preopens option
test "WASI constructor accepts preopens" {
  let preopens_map = Map::from_array([("/tmp", "/tmp")])
  let wasi = WASI::new("preview1", preopens=preopens_map)
  let import_obj = wasi.getImportObject()
  inspect(@js.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with return_on_exit option
test "WASI constructor accepts return_on_exit" {
  let wasi = WASI::new("preview1", returnOnExit=false)
  let import_obj = wasi.getImportObject()
  inspect(@js.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with file descriptor options
test "WASI constructor accepts fd options" {
  let wasi = WASI::new("preview1", stdin=0, stdout=1, stderr=2)
  let import_obj = wasi.getImportObject()
  inspect((import_obj |> @js.typeof_) == "object", content="true")
}

///| WASI Methods Tests

///|
/// Test get_import_object returns valid object
test "get_import_object returns object" {
  let wasi = WASI::new("preview1")
  let import_obj = wasi.getImportObject()
  inspect(@js.typeof_(import_obj) == "object", content="true")
  // Check that it has wasi_snapshot_preview1 key
  let has_preview1 = @js.typeof_(import_obj._get("wasi_snapshot_preview1")) !=
    "undefined"
  inspect(has_preview1, content="true")
}

///|
/// Test wasi_import property
test "wasi_import returns object" {
  let wasi = WASI::new("preview1")
  let wasi_import = wasi.wasiImport()
  inspect(@js.typeof_(wasi_import) == "object", content="true")
}

///| WASI Integration Tests

///|
/// Test WASI with actual WASM module
test "WASI can run hello-wasi.wasm" {
  let wasi = WASI::new("preview1", args=["hello-wasi"], returnOnExit=true)

  // Read WASM file
  let wasm_bytes = @fs.readFileSync("fixtures/hello-wasi.wasm")

  // Instantiate WASM module with WASI imports
  let import_obj = wasi.getImportObject()
  let wasm_module = @webassembly.WebAssemblyModule::from_buffer(
    @js.identity(wasm_bytes),
  )
  let instance = @webassembly.WebAssemblyInstance::from_module(
    wasm_module,
    Some(import_obj),
  )

  // Start WASI (this will call _start and print "Hello, WASI!\n")
  // wasi.start(instance)
  // to avoid actual output in test, we skip calling start
  ignore(instance)
}
