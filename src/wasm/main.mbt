// main.mbt - WASM entry point and test exports

///|
fn main {
  // Entry point for WASM module
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
