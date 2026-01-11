///|

///|
/// Test basic WebAssembly module compilation and instantiation
test "WebAssembly module from bytes" {
  // Read the add.wasm file from project root using Node.js APIs
  let cwd = @process.cwd()
  let wasm_path = @path.join([cwd, "fixtures/add.wasm"])
  let buffer = @fs.read_file_sync(wasm_path)
  // Buffer is a Uint8Array, so we can cast it directly
  let bytes : @arraybuffer.Uint8Array = buffer.as_any().cast()

  // Validate the bytes
  let is_valid = validate(bytes)
  inspect(is_valid, content="true")

  // Compile module
  let wasm_module = WebAssemblyModule::from_bytes(bytes)
  inspect(@core.typeof_(wasm_module.as_any()), content="object")

  // Instantiate
  let instance = WebAssemblyInstance::from_module(wasm_module, None)
  inspect(@core.typeof_(instance.as_any()), content="object")

  // Get exports and call add function
  let exports = instance.exports()
  let add_func = exports._get("add")
  let result : Int = add_func._invoke([@core.any(5), @core.any(3)]).cast()
  inspect(result, content="8")
}

///|
/// Test WebAssembly Memory
test "WebAssembly Memory" {
  // Create a memory with 1 page (64KB)
  let memory = WebAssemblyMemory::new({
    initial: 1,
    maximum: Some(10),
    shared: false,
  })
  inspect(@core.typeof_(memory.as_any()), content="object")

  // Get the buffer
  let buffer = memory.buffer()
  let view = @arraybuffer.Uint8Array::from_array_buffer(buffer).as_typed_array()

  // Write some data
  view.set_at(0, 42)
  view.set_at(1, 43)
  inspect(view.get_at(0), content="42")
  inspect(view.get_at(1), content="43")

  // Grow the memory
  let old_size = memory.grow(1)
  inspect(old_size, content="1")
}

///|
/// Test WebAssembly Table
test "WebAssembly Table" {
  // Create a table for function references
  let table = WebAssemblyTable::new({
    element: "anyfunc",
    initial: 2,
    maximum: Some(10),
  })
  inspect(@core.typeof_(table.as_any()), content="object")

  // Check initial length
  let length = table.length()
  inspect(length, content="2")
}

///|
/// Test WebAssembly Global
test "WebAssembly Global" {
  // Create a mutable i32 global
  let global = WebAssemblyGlobal::new(
    { value: "i32", mutable: true },
    @core.any(42),
  )
  inspect(@core.typeof_(global.as_any()), content="object")

  // Get the value
  let value : Int = global.value().cast()
  inspect(value, content="42")

  // Set a new value
  global.set_value(100 |> @core.any())
  let new_value : Int = global.value().cast()
  inspect(new_value, content="100")
}

///|
/// Test WebAssembly Global immutable
test "WebAssembly Global immutable" {
  // Create an immutable f64 global
  let global = WebAssemblyGlobal::new(
    { value: "f64", mutable: false },
    @core.any(3.14),
  )
  inspect(@core.typeof_(global.as_any()), content="object")

  // Get the value
  let value : Double = global.value().cast()
  inspect(value, content="3.14")
}
