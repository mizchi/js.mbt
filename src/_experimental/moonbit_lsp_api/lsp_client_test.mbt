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
  let line : Int = json._get("line").cast()
  let character : Int = json._get("character").cast()
  inspect(line, content="10")
  inspect(character, content="5")
}

///|
test "Position::from_json parses JSON correctly" {
  let json = @nostd.from_entries([
    ("line", @nostd.any(20)),
    ("character", @nostd.any(15)),
  ]).cast()
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
  let start = json._get("start")
  let end = json._get("end")
  let start_line : Int = start._get("line").cast()
  let end_char : Int = end._get("character").cast()
  inspect(start_line, content="1")
  inspect(end_char, content="10")
}

///|
test "Location::from_json parses correctly" {
  let json = @nostd.from_entries([
    ("uri", @nostd.any("file:///test.mbt")),
    (
      "range",
      @nostd.from_entries([
        (
          "start",
          @nostd.from_entries([
            ("line", @nostd.any(10)),
            ("character", @nostd.any(5)),
          ]).cast(),
        ),
        (
          "end",
          @nostd.from_entries([
            ("line", @nostd.any(10)),
            ("character", @nostd.any(15)),
          ]).cast(),
        ),
      ]).cast(),
    ),
  ]).cast()
  let loc = Location::from_json(json)
  inspect(loc.uri, content="file:///test.mbt")
  inspect(loc.range.start.line, content="10")
  inspect(loc.range.end_.character, content="15")
}

///|
test "TextEdit::from_json parses correctly" {
  let json = @nostd.from_entries([
    (
      "range",
      @nostd.from_entries([
        (
          "start",
          @nostd.from_entries([
            ("line", @nostd.any(5)),
            ("character", @nostd.any(0)),
          ]).cast(),
        ),
        (
          "end",
          @nostd.from_entries([
            ("line", @nostd.any(5)),
            ("character", @nostd.any(10)),
          ]).cast(),
        ),
      ]).cast(),
    ),
    ("newText", @nostd.any("new_text")),
  ]).cast()
  let edit = TextEdit::from_json(json)
  inspect(edit.new_text, content="new_text")
  inspect(edit.range.start.line, content="5")
}
