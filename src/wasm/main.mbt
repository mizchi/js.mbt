// main.mbt - WASM entry point and test exports
//
// Known limitations with MoonBit WASM-GC + js-string-builtins:
// - %identity for Int -> Any generates i32 instead of externref
// - Any::cast() to String causes (ref extern) vs externref mismatch
// - Int.to_string() has similar type issues

///|
fn main {
  // Entry point for WASM module
}

// ============================================
// Test: Object operations
// ============================================

///|
/// Test object creation and property access
pub fn test_object_ops() -> String {
  let obj = @core.new_object()
  obj["name"] = @core.any("MoonBit")
  obj["type"] = @core.any("language")

  // Nested object
  let nested = @core.new_object()
  nested["version"] = @core.any("latest")
  obj["meta"] = nested

  @core.json_stringify(obj)
}

// ============================================
// Test: Type checks
// ============================================

///|
/// Test null and undefined checks
pub fn test_null_undefined() -> String {
  let results = @core.new_object()

  // Test null
  let null_val = @core.null()
  results["is_null_null"] = @core.any(if @core.is_null(null_val) { "true" } else { "false" })
  results["is_nullish_null"] = @core.any(if @core.is_nullish(null_val) { "true" } else { "false" })

  // Test undefined
  let undef_val = @core.undefined()
  results["is_undefined_undef"] = @core.any(if @core.is_undefined(undef_val) { "true" } else { "false" })
  results["is_nullish_undef"] = @core.any(if @core.is_nullish(undef_val) { "true" } else { "false" })

  // Test non-null value
  let str_val = @core.any("hello")
  results["is_null_string"] = @core.any(if @core.is_null(str_val) { "true" } else { "false" })
  results["is_nullish_string"] = @core.any(if @core.is_nullish(str_val) { "true" } else { "false" })

  @core.json_stringify(results)
}

///|
/// Test object and array type checks
pub fn test_type_checks() -> String {
  let results = @core.new_object()

  // Object check
  let obj = @core.new_object()
  results["is_object_obj"] = @core.any(if @core.is_object(obj) { "true" } else { "false" })

  // Array check
  let arr = @core.new_array()
  results["is_array_arr"] = @core.any(if @core.is_array(arr) { "true" } else { "false" })
  results["is_object_arr"] = @core.any(if @core.is_object(arr) { "true" } else { "false" })

  // String check (not an object)
  let str = @core.any("test")
  results["is_object_str"] = @core.any(if @core.is_object(str) { "true" } else { "false" })

  @core.json_stringify(results)
}

// ============================================
// Test: Global access
// ============================================

///|
/// Test globalThis access
pub fn test_global_this() -> String {
  let global = @core.global_this()
  let results = @core.new_object()

  // Check if globalThis is an object
  results["is_object"] = @core.any(if @core.is_object(global) { "true" } else { "false" })

  // Access Math.PI via globalThis
  let math = global["Math"]
  results["has_math"] = @core.any(if @core.is_object(math) { "true" } else { "false" })

  @core.json_stringify(results)
}

// ============================================
// Test: Method calls
// ============================================

///|
/// Test calling JavaScript methods
pub fn test_method_calls() -> String {
  let results = @core.new_object()

  // Array push and join
  let arr = @core.new_array()
  arr._call("push", [@core.any("a")]) |> ignore
  arr._call("push", [@core.any("b")]) |> ignore
  arr._call("push", [@core.any("c")]) |> ignore

  // Join the array
  let joined = arr._call("join", [@core.any("-")])
  results["joined"] = joined

  // String methods via global
  let str = @core.any("hello world")
  let upper = str._call("toUpperCase", [])
  results["upper"] = upper

  @core.json_stringify(results)
}

// ============================================
// Test: JSON operations
// ============================================

///|
/// Test JSON parse and stringify
pub fn test_json() -> String {
  // Parse JSON string
  let parsed = @core.json_parse("{\"x\":\"one\",\"y\":\"two\"}")

  // Modify and stringify
  parsed["z"] = @core.any("three")

  @core.json_stringify(parsed)
}

// ============================================
// Legacy test (for compatibility)
// ============================================

///|
pub fn test_core() -> String {
  let obj = @core.new_object()
  obj["greeting"] = @core.any("Hello from WASM!")
  obj["language"] = @core.any("MoonBit")
  @core.json_stringify(obj)
}

///|
/// Exported function to test DOM operations from JavaScript
pub fn test_dom() -> Unit {
  console_log("test_dom called from WASM")

  // Create a div element
  let div = create_element("div")
  set_id(div, "wasm-created")
  set_text_content(div, "Created by MoonBit WASM")
  set_style(div, "padding", "10px")
  set_style(div, "background", "#f0f0f0")
  set_style(div, "border", "1px solid #ccc")
  set_style(div, "margin", "10px")

  // Append to body
  append_child(document_body(), div) |> ignore
  console_log("DOM element created successfully")
}
