///|
extern "js" fn path_module() -> @nostd.Any =
  #| () => require("node:path")

///|
/// path.join(...paths)
pub fn join(paths : Array[String]) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("join", paths.map(fn(p) { @nostd.any(p) })).cast()
}

///|
/// Join two path segments
/// JS: path.join(a, b)
pub fn join2(a : String, b : String) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("join", [@nostd.any(a), @nostd.any(b)]).cast()
}

///|
/// JS: path.dirname(path)
pub fn dirname(path : String) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("dirname", [@nostd.any(path)]).cast()
}

///|
/// JS: path.basename(path, suffix)
pub fn basename(path : String, suffix? : String) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  match suffix {
    Some(s) =>
      path_module._call("basename", [@nostd.any(path), @nostd.any(s)]).cast()
    None => path_module._call("basename", [@nostd.any(path)]).cast()
  }
}

///|
/// JS: path.extname(path)
pub fn extname(path : String) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("extname", [@nostd.any(path)]).cast()
}

///|
/// JS: path.isAbsolute(path)
#alias(is_absolute)
pub fn isAbsolute(path : String) -> Bool {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("isAbsolute", [@nostd.any(path)]).cast()
}

///|
/// JS: path.normalize(path)
pub fn normalize(path : String) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("normalize", [@nostd.any(path)]).cast()
}

///|
/// JS: path.resolve(...paths)
pub fn resolve(paths : Array[String]) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("resolve", paths.map(fn(p) { @nostd.any(p) })).cast()
}

///|
/// JS: path.relative(from, to)
pub fn relative(from : String, to : String) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("relative", [@nostd.any(from), @nostd.any(to)]).cast()
}

///|
/// JS: path.parse(path)
pub fn parse(path : String) -> ParsedPath {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("parse", [@nostd.any(path)]) |> @nostd.identity
}

///|
/// JS: path.format(parsed)
pub fn format(parsed : ParsedPath) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("format", [parsed.to_any()]).cast()
}

///|
pub(all) struct ParsedPath {
  root : String
  dir : String
  base : String
  ext : String
  name : String
}

///|
pub fn ParsedPath::to_any(self : ParsedPath) -> @nostd.Any = "%identity"

///|
pub fn delimiter() -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module["delimiter"].cast()
}

///|
pub fn sep() -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module["sep"].cast()
}

///|
#alias(to_namespaced_path)
pub fn toNamespacedPath(path : String) -> String {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("toNamespacedPath", [@nostd.any(path)]).cast()
}

///|
#alias(matches_glob)
pub fn matchesGlob(path : String, pattern : String) -> Bool {
  let path_module : @nostd.Any = path_module() |> @nostd.any
  path_module._call("matchesGlob", [@nostd.any(path), @nostd.any(pattern)]).cast()
}
