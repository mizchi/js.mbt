///|
using @js {type Val, js, trait Js}

///|
pub fn join(path1 : String, path2 : String) -> String {
  let path = @node.require("node:path")
  path.call_method("join", [path1, path2]).cast()
}

///|
pub fn dirname(path : String) -> String {
  let path_module = @node.require("node:path")
  path_module.call_method("dirname", [path]).cast()
}

///|
pub fn basename(path : String, suffix? : String) -> String {
  let path_module = @node.require("node:path")
  match suffix {
    Some(s) => path_module.call_method("basename", [path, s]).cast()
    None => path_module.call_method("basename", [path]).cast()
  }
}

///|
pub fn extname(path : String) -> String {
  let path_module = @node.require("node:path")
  path_module.call_method("extname", [path]).cast()
}

///|
#alias(is_absolute)
pub fn isAbsolute(path : String) -> Bool {
  let path_module = @node.require("node:path")
  path_module.call_method("isAbsolute", [path]).cast()
}

///|
pub fn normalize(path : String) -> String {
  let path_module = @node.require("node:path")
  path_module.call_method("normalize", [path]).cast()
}

///|
pub fn resolve(paths : Array[String]) -> String {
  let path_module = @node.require("node:path")
  let resolve_fn = path_module.get("resolve")
  let paths_js = js("[]")
  let mut i = 0
  while i < paths.length() {
    paths_js.call_method("push", [paths[i]]) |> ignore
    i = i + 1
  }
  resolve_fn.call_method("apply", [path_module, paths_js]).cast()
}

///|
pub fn relative(from : String, to : String) -> String {
  let path_module = @node.require("node:path")
  path_module.call_method("relative", [from, to]).cast()
}

///|
pub fn parse(path : String) -> ParsedPath {
  let path_module = @node.require("node:path")
  path_module.call_method("parse", [path]).cast()
}

///|
pub fn format(path_obj : ParsedPath) -> String {
  let path_module = @node.require("node:path")
  path_module.call_method("format", [path_obj]).cast()
}

///|
#external
pub type ParsedPath

///|
pub impl Js for ParsedPath with to_js(self) -> Val {
  self |> js
}

///|
pub fn ParsedPath::root(self : Self) -> String {
  self.to_js().get("root").cast()
}

///|
pub fn ParsedPath::dir(self : Self) -> String {
  self.to_js().get("dir").cast()
}

///|
pub fn ParsedPath::base(self : Self) -> String {
  self.to_js().get("base").cast()
}

///|
pub fn ParsedPath::ext(self : Self) -> String {
  self.to_js().get("ext").cast()
}

///|
pub fn ParsedPath::name(self : Self) -> String {
  self.to_js().get("name").cast()
}

///|
pub fn ParsedPath::new(
  root? : String = "",
  dir? : String = "",
  base? : String = "",
  ext? : String = "",
  name? : String = "",
) -> ParsedPath {
  let obj = @js.new_empty_object()
  obj.set("root", root)
  obj.set("dir", dir)
  obj.set("base", base)
  obj.set("ext", ext)
  obj.set("name", name)
  obj.cast()
}

///|
test "node:path join and dirname" {
  let path = join("foo", "bar/baz.txt")
  assert_eq(path, "foo/bar/baz.txt")
  let dir = dirname(path)
  assert_eq(dir, "foo/bar")
}

///|
test "node:path basename and extname" {
  let path = "foo/bar/baz.txt"
  assert_eq(basename(path), "baz.txt")
  assert_eq(basename(path, suffix=".txt"), "baz")
  assert_eq(extname(path), ".txt")
}

///|
test "node:path isAbsolute" {
  assert_eq(isAbsolute("/foo/bar"), true)
  assert_eq(isAbsolute("foo/bar"), false)
}

///|
test "node:path normalize" {
  assert_eq(normalize("foo/bar//baz"), "foo/bar/baz")
  assert_eq(normalize("foo/bar/../baz"), "foo/baz")
}

///|
test "node:path relative" {
  let rel = relative("/data/orandea/test/aaa", "/data/orandea/impl/bbb")
  assert_eq(rel, "../../impl/bbb")
}
