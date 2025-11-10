///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
#external
pub type TypeScript

///|
pub impl Js for TypeScript with to_js(self) {
  self |> js
}

///|
pub fn TypeScript::require() -> Self {
  @node.require("typescript") |> unsafe_cast
}

///|
pub fn TypeScript::create_source_file(
  self : TypeScript,
  file_name : String,
  source_text : String,
  set_parent_node? : Bool = true,
  script_target? : Val = self.to_js().get("ScriptTarget").get("Latest"),
  script_kind? : Val = self.to_js().get("ScriptKind").get("TS"),
) -> Source {
  self
  .to_js()
  .get("createSourceFile")
  .call([
      file_name, source_text, script_target, // scriptTarget
       set_parent_node, // setParentNodes
       script_kind,
    ], // scriptKind
  )
  .cast()
}

///|
#external
pub type Source

///|
pub impl Js for Source with to_js(self) {
  self |> js
}

///|
pub fn Source::as_node(self : Source) -> TsNode {
  self |> unsafe_cast
}

///|
#external
pub type TsNode

///|
pub impl Js for TsNode with to_js(self) {
  self |> js
}

///|
pub fn TsNode::for_each_child(self : TsNode, cb : (TsNode) -> Unit) -> Unit {
  self.to_js().call_method("forEachChild", [cb |> js]) |> ignore
}

///|
test "typescript_create_program" {
  let ts = TypeScript::require()
  let source = ts.create_source_file("example.ts", "let x: number = 42;")
  source.as_node().for_each_child(_node => ())
}
