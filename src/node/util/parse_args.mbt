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
      @mbtconv.from_map({
        "type": @nostd.any("boolean"),
        "short": @nostd.any(short),
      }).cast()
    String(short~, multiple~, default~, ..) =>
      @mbtconv.from_option_map({
        "type": Some(@nostd.any("string")),
        "short": Some(@nostd.any(short)),
        "multiple": Some(@nostd.any(multiple)),
        "default": default.map(fn(x) { @nostd.any(x) }),
      }).cast()
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
  let result : @js.Any = @mbtconv.from_map({
    "args": @nostd.any(args),
    "options": @nostd.any(opts_obj.as_any()),
    "allowPositionals": @nostd.any(allow_positionals),
  }).cast()
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
