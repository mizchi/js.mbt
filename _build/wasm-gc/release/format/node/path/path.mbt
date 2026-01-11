///|
extern "js" fn path_module() -> @core.Any =
  #| () => require("node:path")

///|
/// path.join(...paths)
pub fn join(paths : Array[String]) -> String {
  let path_module : @core.Any = path_module() |> @core.any
  path_module._call("join", paths.map(fn(p) { @core.any(p) })).cast()
}

///|
/// Join two path segments
/// JS: path.join(a, b)
#module("node:path")
pub extern "js" fn join2(a : String, b : String) -> String = "join"

///|
/// JS: path.dirname(path)
#module("node:path")
pub extern "js" fn dirname(path : String) -> String = "dirname"

///|
/// JS: path.basename(path, suffix)
pub fn basename(path : String, suffix? : String) -> String {
  let path_module : @core.Any = path_module() |> @core.any
  match suffix {
    Some(s) =>
      path_module._call("basename", [@core.any(path), @core.any(s)]).cast()
    None => path_module._call("basename", [@core.any(path)]).cast()
  }
}

///|
/// JS: path.extname(path)
#module("node:path")
pub extern "js" fn extname(path : String) -> String = "extname"

///|
/// JS: path.isAbsolute(path)
#alias(is_absolute)
#module("node:path")
pub extern "js" fn isAbsolute(path : String) -> Bool = "isAbsolute"

///|
/// JS: path.normalize(path)
#module("node:path")
pub extern "js" fn normalize(path : String) -> String = "normalize"

///|
/// JS: path.resolve(...paths)
pub fn resolve(paths : Array[String]) -> String {
  let path_module : @core.Any = path_module() |> @core.any
  path_module._call("resolve", paths.map(fn(p) { @core.any(p) })).cast()
}

///|
/// JS: path.relative(from, to)
#module("node:path")
pub extern "js" fn relative(from : String, to : String) -> String = "relative"

///|
/// JS: path.parse(path)
#module("node:path")
pub extern "js" fn parse(path : String) -> ParsedPath = "parse"

///|
/// JS: path.format(parsed)
#module("node:path")
pub extern "js" fn format(parsed : ParsedPath) -> String = "format"

///|
pub(all) struct ParsedPath {
  root : String
  dir : String
  base : String
  ext : String
  name : String
}

///|
pub fn ParsedPath::to_any(self : ParsedPath) -> @core.Any = "%identity"

///|
pub extern "js" fn delimiter() -> String =
  #|() => require("node:path").delimiter

///|
pub extern "js" fn sep() -> String =
  #|() => require("node:path").sep

///|
#alias(to_namespaced_path)
#module("node:path")
pub extern "js" fn toNamespacedPath(path : String) -> String = "toNamespacedPath"

///|
#alias(matches_glob)
#module("node:path")
pub extern "js" fn matchesGlob(path : String, pattern : String) -> Bool = "matchesGlob"
