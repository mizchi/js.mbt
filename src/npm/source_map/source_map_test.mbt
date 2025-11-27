///|
/// Tests for source-map package
/// Note: These tests require 'source-map' npm package to be installed

///|
/// Test SourceMapConsumer with a sample source map
async test "SourceMapConsumer::from_json and original_position_for" {
  // Sample source map (minified -> original)
  let source_map_json =
    #|{
    #|  "version": 3,
    #|  "file": "out.js",
    #|  "sources": ["foo.mbt"],
    #|  "names": ["hello"],
    #|  "mappings": "AAAA,SAASA,KACPC"
    #|}
  let consumer = @source_map.SourceMapConsumer::from_json(source_map_json)
  defer consumer.destroy()
  // Query position
  let pos = consumer.original_position_for(1, 0)
  inspect(pos.source, content="Some(\"foo.mbt\")")
  inspect(pos.line, content="Some(1)")
}

///|
/// Test SourceMapGenerator
test "SourceMapGenerator::add_mapping and to_json" {
  let gen = @source_map.SourceMapGenerator::new(options={
    file: Some("output.js"),
    source_root: None,
  })
  // Add a mapping
  gen.add_mapping(
    @source_map.GeneratedPosition::new(1, 0),
    original=@source_map.GeneratedPosition::new(1, 0),
    source="input.mbt",
    name="main",
  )
  gen.set_source_content("input.mbt", "fn main() { }")
  // Get result
  let json = gen.to_json()
  // Verify the JSON contains expected data
  assert_true(json.contains("input.mbt"))
  assert_true(json.contains("fn main()"))
}

///|
/// Test getting sources from consumer
async test "SourceMapConsumer::sources" {
  let source_map_json =
    #|{
    #|  "version": 3,
    #|  "file": "out.js",
    #|  "sources": ["a.mbt", "b.mbt"],
    #|  "names": [],
    #|  "mappings": "AAAA;ACAA"
    #|}
  let consumer = @source_map.SourceMapConsumer::from_json(source_map_json)
  defer consumer.destroy()
  let sources = consumer.sources()
  inspect(sources.length(), content="2")
  inspect(sources[0], content="a.mbt")
  inspect(sources[1], content="b.mbt")
}
