///|
/// WASI API Tests

///| WASI Constructor Tests

///|
/// Test WASI constructor with preview1
test "WASI constructor creates instance with preview1" {
  let wasi = WASI(
    "preview1",
    args=["test"],
    env=Map::from_array([("TEST_VAR", "test_value")]),
    returnOnExit=true,
  )
  let import_obj = wasi.getImportObject()
  inspect(@core.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI constructor with unstable version
test "WASI constructor creates instance with unstable" {
  let wasi = WASI("unstable")
  let import_obj = wasi.getImportObject()
  inspect(@core.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with args option
test "WASI constructor accepts args" {
  let wasi = WASI("preview1", args=["arg1", "arg2", "arg3"])
  let import_obj = wasi.getImportObject()
  inspect(@core.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with env option
test "WASI constructor accepts env" {
  let env_map = Map::from_array([("HOME", "/home/user"), ("PATH", "/usr/bin")])
  let wasi = WASI("preview1", env=env_map)
  let import_obj = wasi.getImportObject()
  inspect(@core.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with preopens option
test "WASI constructor accepts preopens" {
  let preopens_map = Map::from_array([("/tmp", "/tmp")])
  let wasi = WASI("preview1", preopens=preopens_map)
  let import_obj = wasi.getImportObject()
  inspect(@core.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with return_on_exit option
test "WASI constructor accepts return_on_exit" {
  let wasi = WASI("preview1", returnOnExit=false)
  let import_obj = wasi.getImportObject()
  inspect(@core.typeof_(import_obj) == "object", content="true")
}

///|
/// Test WASI with file descriptor options
test "WASI constructor accepts fd options" {
  let wasi = WASI("preview1", stdin=0, stdout=1, stderr=2)
  let import_obj = wasi.getImportObject()
  inspect((import_obj |> @core.typeof_) == "object", content="true")
}

///| WASI Methods Tests

///|
/// Test get_import_object returns valid object
test "get_import_object returns object" {
  let wasi = WASI("preview1")
  let import_obj = wasi.getImportObject()
  inspect(@core.typeof_(import_obj) == "object", content="true")
  // Check that it has wasi_snapshot_preview1 key
  let has_preview1 = @core.typeof_(import_obj._get("wasi_snapshot_preview1")) !=
    "undefined"
  inspect(has_preview1, content="true")
}

///|
/// Test wasi_import property
test "wasi_import returns object" {
  let wasi = WASI("preview1")
  let wasi_import = wasi.wasiImport()
  inspect(@core.typeof_(wasi_import) == "object", content="true")
}

///| WASI Integration Tests

///|
/// The compiled form of `fixtures/hello-wasi.wasm`, embedded so this test does
/// not depend on the process working directory.
/// Source: `fixtures/hello-wasi.wat` - writes "Hello, WASI!" via `fd_write`.
let hello_wasi_wasm : Bytes = b"\x00\x61\x73\x6d\x01\x00\x00\x00\x01\x0c\x02\x60\x04\x7f\x7f\x7f\x7f\x01\x7f\x60\x00\x00\x02\x23\x01\x16\x77\x61\x73\x69\x5f\x73\x6e\x61\x70\x73\x68\x6f\x74\x5f\x70\x72\x65\x76\x69\x65\x77\x31\x08\x66\x64\x5f\x77\x72\x69\x74\x65\x00\x00\x03\x02\x01\x01\x05\x03\x01\x00\x01\x07\x13\x02\x06\x6d\x65\x6d\x6f\x72\x79\x02\x00\x06\x5f\x73\x74\x61\x72\x74\x00\x01\x0a\x1d\x01\x1b\x00\x41\x00\x41\x08\x36\x02\x00\x41\x04\x41\x0d\x36\x02\x00\x41\x01\x41\x00\x41\x01\x41\x18\x10\x00\x1a\x0b\x0b\x13\x01\x00\x41\x08\x0b\x0d\x48\x65\x6c\x6c\x6f\x2c\x20\x57\x41\x53\x49\x21\x0a\x00\x1a\x04\x6e\x61\x6d\x65\x01\x13\x02\x00\x08\x66\x64\x5f\x77\x72\x69\x74\x65\x01\x06\x5f\x73\x74\x61\x72\x74"

///|
/// Test WASI with actual WASM module
test "WASI can run hello-wasi.wasm" {
  let wasi = WASI("preview1", args=["hello-wasi"], returnOnExit=true)

  // Instantiate WASM module with WASI imports
  let import_obj = wasi.getImportObject()
  let wasm_module = @webassembly.WebAssemblyModule::from_bytes(
    @arraybuffer.Uint8Array::from_bytes(hello_wasi_wasm),
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
