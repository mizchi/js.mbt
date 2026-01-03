// main.mbt - WASM entry point and test exports

///|
fn main {
  // Entry point for WASM module
}

///|
/// Simple test without DOM - can run in Deno
pub fn test_core() -> String {
  // Test basic @core operations
  let obj = @core.new_object()
  obj["name"] = @core.any("MoonBit")
  obj["version"] = @core.any(1)

  // Get values back
  let name : String = obj["name"] |> @core.Any::cast()
  let version : Int = obj["version"] |> @core.Any::cast()

  // Test json_stringify
  let json = @core.json_stringify(obj)
  @core.log(@core.any("test_core: " + json))

  // Return result
  "name=" + name + ", version=" + version.to_string()
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
