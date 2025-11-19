///|
pub(all) enum ParseArgsOption {
  Boolean(key~ : String, short~ : String)
  String(key~ : String, short~ : String, multiple~ : Bool, default~ : String?)
}

///|
pub fn ParseArgsOption::key(self : ParseArgsOption) -> String {
  match self {
    Boolean(key~, ..) => key
    String(key~, ..) => key
  }
}

///|
impl JsImpl for ParseArgsOption with to_js(self) -> Js {
  match self {
    Boolean(short~, ..) => {
      let obj = @js.Object::new()
      obj.set("type", "boolean")
      obj.set("short", short)
      obj.to_js()
    }
    String(short~, multiple~, default~, ..) => {
      let obj = @js.Object::new()
      obj.set("type", "string")
      obj.set("short", short)
      obj.set("multiple", multiple)
      obj.set("default", default)
      obj.to_js()
    }
  }
}

///|
pub(all) struct ParseArgsResult {
  values : Map[String, Js]
  positionals : Array[String]
  tokens : Array[Js]?
}

///|
#alias(parse_args)
pub fn parseArgs(
  args~ : Array[String],
  options~ : Array[ParseArgsOption],
  allow_positionals? : Bool = false,
  // tokens?: Bool = false,
) -> ParseArgsResult {
  let result = @js.JsArray::new()
  result.set("args", args |> @js.from_array)
  result.set(
    "options",
    if options.is_empty() {
      @js.Object::new()
    } else {
      let o = @js.Object::new()
      for opt in options {
        o.set(opt.key(), opt.to_js())
      }
      o
    },
  )
  result.set("allowPositionals", allow_positionals)
  // result["tokens"] = tokens
  let r : Js = unsafe_cast(util().get("parseArgs").call_self([result]))
  let values : Map[String, Js] = {}
  let result_keys = r.get("values") |> @js.Object::keys
  for k in result_keys {
    values[k] = unsafe_cast(r.get("values").get(k))
  }
  ParseArgsResult::{
    values,
    positionals: unsafe_cast(r.get("positionals")),
    tokens: None,
  }
}
