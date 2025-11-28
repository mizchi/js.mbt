///|
/// Tests for MoonBit LSP Client

///|
test "path_to_uri converts file path to URI" {
  let uri = path_to_uri("/Users/test/project/src/main.mbt")
  inspect(uri.has_prefix("file:///"), content="true")
  inspect(uri.contains("main.mbt"), content="true")
}

///|
test "uri_to_path converts URI to file path" {
  let path = uri_to_path("file:///Users/test/project/src/main.mbt")
  inspect(path, content="/Users/test/project/src/main.mbt")
}

///|
test "Position::to_json creates correct JSON" {
  let pos = Position::{ line: 10, character: 5 }
  let json = pos.to_json()
  let line : Int = json.get("line").cast()
  let character : Int = json.get("character").cast()
  inspect(line, content="10")
  inspect(character, content="5")
}

///|
test "Position::from_json parses JSON correctly" {
  let json = @js.from_map({ "line": @js.any(20), "character": @js.any(15) })
  let pos = Position::from_json(json)
  inspect(pos.line, content="20")
  inspect(pos.character, content="15")
}

///|
test "Range::to_json creates correct JSON" {
  let range = Range::{
    start: { line: 1, character: 0 },
    end_: { line: 1, character: 10 },
  }
  let json = range.to_json()
  let start = json.get("start")
  let end = json.get("end")
  let start_line : Int = start.get("line").cast()
  let end_char : Int = end.get("character").cast()
  inspect(start_line, content="1")
  inspect(end_char, content="10")
}

///|
test "Location::from_json parses correctly" {
  let json = @js.from_map({
    "uri": @js.any("file:///test.mbt"),
    "range": @js.from_map({
      "start": @js.from_map({ "line": @js.any(10), "character": @js.any(5) }),
      "end": @js.from_map({ "line": @js.any(10), "character": @js.any(15) }),
    }),
  })
  let loc = Location::from_json(json)
  inspect(loc.uri, content="file:///test.mbt")
  inspect(loc.range.start.line, content="10")
  inspect(loc.range.end_.character, content="15")
}

///|
test "TextEdit::from_json parses correctly" {
  let json = @js.from_map({
    "range": @js.from_map({
      "start": @js.from_map({ "line": @js.any(5), "character": @js.any(0) }),
      "end": @js.from_map({ "line": @js.any(5), "character": @js.any(10) }),
    }),
    "newText": @js.any("new_text"),
  })
  let edit = TextEdit::from_json(json)
  inspect(edit.new_text, content="new_text")
  inspect(edit.range.start.line, content="5")
}
