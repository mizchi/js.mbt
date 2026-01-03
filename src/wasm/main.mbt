// main.mbt - WASM entry point and test exports

///|
fn main {
  // Entry point for WASM module
}

///|
/// Simple test without DOM - can run in Deno
/// Known limitations with MoonBit WASM-GC + js-string-builtins:
/// - %identity for Int -> Any generates i32 instead of externref
/// - Any::cast() to String causes (ref extern) vs externref mismatch
/// - Int.to_string() has similar type issues
pub fn test_core() -> String {
  // Test object creation and json_stringify
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
