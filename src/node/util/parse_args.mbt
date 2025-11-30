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
impl @js.JsImpl for ParseArgsOption with as_any(self) -> @js.Any {
  match self {
    Boolean(short~, ..) =>
      @js.from_map({ "type": @js.any("boolean"), "short": @js.any(short) })
    String(short~, multiple~, default~, ..) =>
      @js.from_option_map({
        "type": Some(@js.any("string")),
        "short": Some(@js.any(short)),
        "multiple": Some(@js.any(multiple)),
        "default": default.map(fn(x) { @js.any(x) }),
      })
  }
}

///|
pub(all) struct ParseArgsResult {
  values : Map[String, @js.Any]
  positionals : Array[String]
  tokens : Array[@js.Any]?
}

///|
#alias(parse_args)
pub fn parseArgs(
  args~ : Array[String],
  options~ : Array[ParseArgsOption],
  allow_positionals? : Bool = false,
  // tokens?: Bool = false,
) -> ParseArgsResult {
  let opts_obj = if options.is_empty() {
    @js.Object::new()
  } else {
    let o = @js.Object::new()
    for opt in options {
      o.set(opt.key(), opt.as_any())
    }
    o
  }
  let result = @js.from_map({
    "args": args |> @js.from_array,
    "options": opts_obj.as_any(),
    "allowPositionals": @js.any(allow_positionals),
  })
  // result["tokens"] = tokens
  let r : @js.Any = @js.identity(util().get("parseArgs").call_self([result]))
  let values : Map[String, @js.Any] = {}
  let result_keys = r.get("values") |> @js.Object::keys
  for k in result_keys {
    values[k] = @js.identity(r.get("values").get(k))
  }
  ParseArgsResult::{
    values,
    positionals: r.get("positionals").cast(),
    tokens: None,
  }
}
