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
fn OriginalPosition::from_any(obj : @core.Any) -> OriginalPosition {
  {
    source: obj["source"].cast(),
    line: obj["line"].cast(),
    column: obj["column"].cast(),
    name: obj["name"].cast(),
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
pub extern "js" fn SourceMapConsumer::as_any(
  self : SourceMapConsumer,
) -> @core.Any =
  #| (x) => x

///|
/// Create a SourceMapConsumer from a source map JSON string
pub async fn SourceMapConsumer::from_json(json : String) -> SourceMapConsumer {
  ffi_create_consumer(json).wait().cast()
}

///|
extern "js" fn ffi_create_consumer(json : String) -> @core.Promise[@core.Any] =
  #|async (json) => {
  #|  const { SourceMapConsumer } = await import('source-map');
  #|  const rawMap = JSON.parse(json);
  #|  return new SourceMapConsumer(rawMap);
  #|}

///|
/// Create a SourceMapConsumer from a raw source map object
pub async fn SourceMapConsumer::from_raw(
  raw_map : @core.Any,
) -> SourceMapConsumer {
  ffi_create_consumer_raw(raw_map).wait().cast()
}

///|
extern "js" fn ffi_create_consumer_raw(
  raw_map : @core.Any,
) -> @core.Promise[@core.Any] =
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
  let pos = @core.new_object()
  pos["line"] = @core.any(line)
  pos["column"] = @core.any(column)
  let result = self.as_any()._call("originalPositionFor", [pos])
  OriginalPosition::from_any(result)
}

///|
/// Get all sources in the source map
pub fn SourceMapConsumer::sources(self : SourceMapConsumer) -> Array[String] {
  self.as_any()["sources"].cast()
}

///|
/// Get source content for a source file
pub fn SourceMapConsumer::sourceContentFor(
  self : SourceMapConsumer,
  source : String,
) -> String? {
  self.as_any()._call("sourceContentFor", [@core.any(source)]).cast()
}

///|
/// Iterate over each mapping
pub fn SourceMapConsumer::eachMapping(
  self : SourceMapConsumer,
  callback : (Mapping) -> Unit,
) -> Unit {
  ffi_each_mapping(self.as_any(), fn(
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
  consumer : @core.Any,
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
  self.as_any()._call("destroy", []) |> ignore
}

///|
/// SourceMapGenerator - creates source maps
#external
pub type SourceMapGenerator

///|
pub extern "js" fn SourceMapGenerator::as_any(
  self : SourceMapGenerator,
) -> @core.Any =
  #| (x) => x

///|
/// Create a new SourceMapGenerator
pub fn SourceMapGenerator::new(
  file? : String,
  sourceRoot? : String,
) -> SourceMapGenerator {
  let js_opts = @core.new_object()
  match file {
    Some(f) => js_opts["file"] = @core.any(f)
    None => ()
  }
  match sourceRoot {
    Some(sr) => js_opts["sourceRoot"] = @core.any(sr)
    None => ()
  }
  ffi_create_generator(js_opts).cast()
}

///|
extern "js" fn ffi_create_generator(options : @core.Any) -> @core.Any =
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
  let mapping = @core.new_object()
  let gen = @core.new_object()
  gen["line"] = @core.any(generated.line)
  gen["column"] = @core.any(generated.column)
  mapping["generated"] = gen
  match original {
    Some(orig) => {
      let orig_obj = @core.new_object()
      orig_obj["line"] = @core.any(orig.line)
      orig_obj["column"] = @core.any(orig.column)
      mapping["original"] = orig_obj
    }
    None => ()
  }
  match source {
    Some(s) => mapping["source"] = @core.any(s)
    None => ()
  }
  match name {
    Some(n) => mapping["name"] = @core.any(n)
    None => ()
  }
  self.as_any()._call("addMapping", [mapping]) |> ignore
}

///|
/// Set source content for a source file
pub fn SourceMapGenerator::setSourceContent(
  self : SourceMapGenerator,
  source : String,
  content : String,
) -> Unit {
  self
  .as_any()
  ._call("setSourceContent", [@core.any(source), @core.any(content)])
  |> ignore
}

///|
/// Generate the source map as a JSON string
pub fn SourceMapGenerator::toJSON(self : SourceMapGenerator) -> String {
  self.as_any()._call("toString", []).cast()
}

///|
/// Generate the source map as an object
pub fn SourceMapGenerator::toObject(self : SourceMapGenerator) -> @core.Any {
  self.as_any()._call("toJSON", [])
}
