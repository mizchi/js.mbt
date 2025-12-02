///|
test "importModule returns module" {
  // Just verify the module can be imported
  // Full initialization requires complex setup
  @nostd.typeof_(@node.require("@duckdb/duckdb-wasm")) |> assert_eq("object")
}

///|
test "module has required exports" {
  let mod = @node.require("@duckdb/duckdb-wasm")
  // Check that key exports exist
  @nostd.typeof_(mod._get("AsyncDuckDB")) |> assert_eq("function")
  @nostd.typeof_(mod._get("ConsoleLogger")) |> assert_eq("function")
}
