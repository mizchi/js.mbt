///|
/// source-map - Source map parsing and generation
/// npm: source-map

///|
/// Position in generated code
pub(all) struct GeneratedPosition {
  line : Int
  column : Int
}

///|
pub fn GeneratedPosition::new(line : Int, column : Int) -> GeneratedPosition {
  { line, column }
}

///|
/// Position in original source code
pub(all) struct OriginalPosition {
  source : String?
  line : Int?
  column : Int?
  name : String?
}

///|
fn OriginalPosition::from_any(obj : @js.Any) -> OriginalPosition {
  {
    source: obj.get("source").cast(),
    line: obj.get("line").cast(),
    column: obj.get("column").cast(),
    name: obj.get("name").cast(),
  }
}

///|
pub fn OriginalPosition::is_found(self : OriginalPosition) -> Bool {
  not(self.source is None)
}

///|
pub impl Show for OriginalPosition with output(self, logger) {
  let source = self.source.unwrap_or("<unknown>")
  let line = self.line.unwrap_or(0)
  let column = self.column.unwrap_or(0)
  let name = self.name.unwrap_or("")
  logger.write_string("\{source}:\{line}:\{column}")
  if name != "" {
    logger.write_string(" (\{name})")
  }
}

///|
/// Mapping entry for source map generation
pub(all) struct Mapping {
  generated : GeneratedPosition
  original : GeneratedPosition?
  source : String?
  name : String?
}

///|
/// SourceMapConsumer - parses and queries source maps
#external
pub type SourceMapConsumer

///|
pub impl @js.JsImpl for SourceMapConsumer

///|
/// Create a SourceMapConsumer from a source map JSON string
pub async fn SourceMapConsumer::from_json(json : String) -> SourceMapConsumer {
  ffi_create_consumer(json).wait() |> @js.identity
}

///|
extern "js" fn ffi_create_consumer(json : String) -> @js.Promise[@js.Any] =
  #|async (json) => {
  #|  const { SourceMapConsumer } = await import('source-map');
  #|  const rawMap = JSON.parse(json);
  #|  return new SourceMapConsumer(rawMap);
  #|}

///|
/// Create a SourceMapConsumer from a raw source map object
pub async fn SourceMapConsumer::from_raw(
  raw_map : @js.Any,
) -> SourceMapConsumer {
  ffi_create_consumer_raw(raw_map).wait() |> @js.identity
}

///|
extern "js" fn ffi_create_consumer_raw(
  raw_map : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (rawMap) => {
  #|  const { SourceMapConsumer } = await import('source-map');
  #|  return new SourceMapConsumer(rawMap);
  #|}

///|
/// Get the original position for a generated position
pub fn SourceMapConsumer::originalPositionFor(
  self : SourceMapConsumer,
  line : Int,
  column : Int,
) -> OriginalPosition {
  let pos = @js.Object::new()
  pos.set("line", line)
  pos.set("column", column)
  let result = (self |> @js.identity : @js.Any).call("originalPositionFor", [
    pos.to_any(),
  ])
  OriginalPosition::from_any(result)
}

///|
/// Get all sources in the source map
pub fn SourceMapConsumer::sources(self : SourceMapConsumer) -> Array[String] {
  let js_sources : @js.Any = (self |> @js.identity : @js.Any).get("sources")
  js_sources |> @js.identity
}

///|
/// Get source content for a source file
pub fn SourceMapConsumer::sourceContentFor(
  self : SourceMapConsumer,
  source : String,
) -> String? {
  self.call("sourceContentFor", [source |> @js.any]).cast()
}

///|
/// Iterate over each mapping
pub fn SourceMapConsumer::eachMapping(
  self : SourceMapConsumer,
  callback : (Mapping) -> Unit,
) -> Unit {
  ffi_each_mapping(self |> @js.identity, fn(
    gen_line,
    gen_col,
    orig_line,
    orig_col,
    source,
    name,
  ) {
    let mapping : Mapping = {
      generated: { line: gen_line, column: gen_col },
      original: if orig_line >= 0 {
        Some({ line: orig_line, column: orig_col })
      } else {
        None
      },
      source,
      name,
    }
    callback(mapping)
  })
}

///|
extern "js" fn ffi_each_mapping(
  consumer : @js.Any,
  callback : (Int, Int, Int, Int, String?, String?) -> Unit,
) -> Unit =
  #|(consumer, callback) => {
  #|  consumer.eachMapping((m) => {
  #|    callback(
  #|      m.generatedLine,
  #|      m.generatedColumn,
  #|      m.originalLine ?? -1,
  #|      m.originalColumn ?? -1,
  #|      m.source ?? null,
  #|      m.name ?? null
  #|    );
  #|  });
  #|}

///|
/// Destroy the consumer (free resources)
pub fn SourceMapConsumer::destroy(self : SourceMapConsumer) -> Unit {
  let consumer : @js.Any = self |> @js.identity
  consumer.call("destroy", []) |> ignore
}

///|
/// SourceMapGenerator - creates source maps
#external
pub type SourceMapGenerator

///|
pub impl @js.JsImpl for SourceMapGenerator

///|
/// Create a new SourceMapGenerator
pub fn SourceMapGenerator::new(
  file? : String,
  sourceRoot? : String,
) -> SourceMapGenerator {
  let js_opts = @js.Object::new()
  match file {
    Some(f) => js_opts.set("file", f)
    None => ()
  }
  match sourceRoot {
    Some(sr) => js_opts.set("sourceRoot", sr)
    None => ()
  }
  ffi_create_generator(js_opts.to_any()) |> @js.identity
}

///|
extern "js" fn ffi_create_generator(options : @js.Any) -> @js.Any =
  #|(options) => {
  #|  const { SourceMapGenerator } = require('source-map');
  #|  return new SourceMapGenerator(options);
  #|}

///|
/// Add a mapping to the generator
pub fn SourceMapGenerator::addMapping(
  self : SourceMapGenerator,
  generated : GeneratedPosition,
  original? : GeneratedPosition,
  source? : String,
  name? : String,
) -> Unit {
  let mapping = @js.Object::new()
  let gen = @js.Object::new()
  gen.set("line", generated.line)
  gen.set("column", generated.column)
  mapping.set("generated", gen.to_any())
  match original {
    Some(orig) => {
      let orig_obj = @js.Object::new()
      orig_obj.set("line", orig.line)
      orig_obj.set("column", orig.column)
      mapping.set("original", orig_obj.to_any())
    }
    None => ()
  }
  match source {
    Some(s) => mapping.set("source", s)
    None => ()
  }
  match name {
    Some(n) => mapping.set("name", n)
    None => ()
  }
  let gen_any : @js.Any = self |> @js.identity
  gen_any.call("addMapping", [mapping.to_any()]) |> ignore
}

///|
/// Set source content for a source file
pub fn SourceMapGenerator::setSourceContent(
  self : SourceMapGenerator,
  source : String,
  content : String,
) -> Unit {
  let gen : @js.Any = self |> @js.identity
  gen.call("setSourceContent", [source |> @js.any, content |> @js.any])
  |> ignore
}

///|
/// Generate the source map as a JSON string
pub fn SourceMapGenerator::toJSON(self : SourceMapGenerator) -> String {
  let gen : @js.Any = self |> @js.identity
  gen.call("toString", []) |> @js.identity
}

///|
/// Generate the source map as an object
pub fn SourceMapGenerator::toObject(self : SourceMapGenerator) -> @js.Any {
  let gen : @js.Any = self |> @js.identity
  gen.call("toJSON", [])
}
