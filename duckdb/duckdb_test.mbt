///|
test "importModule returns module" {
  // Just verify the module can be imported
  // Full initialization requires complex setup
  @core.typeof_(@node.require("@duckdb/duckdb-wasm")) |> assert_eq("object")
}

///|
test "module has required exports" {
  let mod = @node.require("@duckdb/duckdb-wasm")
  // Check that key exports exist
  @core.typeof_(mod._get("AsyncDuckDB")) |> assert_eq("function")
  @core.typeof_(mod._get("ConsoleLogger")) |> assert_eq("function")
}
