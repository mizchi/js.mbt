///|

///|
/// Test basic WebAssembly module compilation and instantiation
test "WebAssembly module from bytes" {
  // Read the add.wasm file from project root using Node.js APIs
  let cwd = @process.cwd()
  let wasm_path = @path.join([cwd, "fixtures/add.wasm"])
  let buffer = @fs.read_file_sync(wasm_path)
  // Buffer is a Uint8Array, so we can cast it directly
  let bytes : @typedarray.Uint8Array = buffer.to_js() |> @js.identity

  // Validate the bytes
  let is_valid = validate(bytes)
  inspect(is_valid, content="true")

  // Compile module
  let wasm_module = WebAssemblyModule::from_bytes(bytes)
  inspect(wasm_module.to_js() |> @js.typeof_(), content="object")

  // Instantiate
  let instance = WebAssemblyInstance::from_module(wasm_module, None)
  inspect(instance.to_js() |> @js.typeof_(), content="object")

  // Get exports and call add function
  let exports = instance.exports()
  let add_func = exports.get("add")
  let result : Int = add_func.call_self([5, 3]) |> @js.identity
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
  inspect(@js.typeof_(memory.to_js()), content="object")

  // Get the buffer
  let buffer = memory.buffer()
  let view = @typedarray.Uint8Array::from_array_buffer(buffer)

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
  inspect(table.to_js() |> @js.typeof_(), content="object")

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
    @js.js(42),
  )
  inspect(global.to_js() |> @js.typeof_(), content="object")

  // Get the value
  let value : Int = global.value() |> @js.identity
  inspect(value, content="42")

  // Set a new value
  global.set_value(100 |> @js.js())
  let new_value : Int = global.value() |> @js.identity
  inspect(new_value, content="100")
}

///|
/// Test WebAssembly Global immutable
test "WebAssembly Global immutable" {
  // Create an immutable f64 global
  let global = WebAssemblyGlobal::new(
    { value: "f64", mutable: false },
    @js.js(3.14),
  )
  inspect(@js.typeof_(global.to_js()), content="object")

  // Get the value
  let value : Double = global.value() |> @js.identity
  inspect(value, content="3.14")
}
