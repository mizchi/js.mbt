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
impl @js.JsImpl for ParseArgsOption with to_js(self) -> @js.Any {
  match self {
    Boolean(short~, ..) =>
      @js.from_entries([("type", "boolean"), ("short", short)])
    String(short~, multiple~, default~, ..) =>
      @js.from_entries_option([
        ("type", Some("string")),
        ("short", Some(short)),
        ("multiple", Some(multiple)),
        ("default", default.map(x => x)),
      ])
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
      o.set(opt.key(), opt.to_js())
    }
    o
  }
  let result = @js.from_entries([
    ("args", args |> @js.from_array),
    ("options", opts_obj),
    ("allowPositionals", allow_positionals),
  ])
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
