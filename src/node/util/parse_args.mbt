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
pub fn ParseArgsOption::as_any(self : ParseArgsOption) -> @nostd.Any {
  match self {
    Boolean(short~, ..) =>
      @mbtconv.from_map({
        "type": @nostd.any("boolean"),
        "short": @nostd.any(short),
      })
    String(short~, multiple~, default~, ..) =>
      @mbtconv.from_option_map({
        "type": Some(@nostd.any("string")),
        "short": Some(@nostd.any(short)),
        "multiple": Some(@nostd.any(multiple)),
        "default": default.map(fn(x) { @nostd.any(x) }),
      })
  }
}

///|
pub(all) struct ParseArgsResult {
  values : Map[String, @nostd.Any]
  positionals : Array[String]
  tokens : Array[@nostd.Any]?
}

///|
#alias(parse_args)
pub fn parseArgs(
  args~ : Array[String],
  options~ : Array[ParseArgsOption],
  allow_positionals? : Bool = false,
  // tokens?: Bool = false,
) -> ParseArgsResult {
  let opts_obj : @nostd.Any = if options.is_empty() {
    @nostd.any(@nostd.Object::new())
  } else {
    let o : @nostd.Any = @nostd.any(@nostd.Object::new())
    for opt in options {
      o[opt.key()] = opt.as_any()
    }
    o
  }
  let result : @nostd.Any = @mbtconv.from_map({
    "args": @nostd.any(args),
    "options": opts_obj,
    "allowPositionals": @nostd.any(allow_positionals),
  })
  // result["tokens"] = tokens
  let r : @nostd.Any = util().as_any()["parseArgs"]._invoke([result])
  let values : Map[String, @nostd.Any] = {}
  let result_keys : Array[String] = @nostd.Object::keys(r["values"])
  for k in result_keys {
    values[k] = r["values"][k].cast()
  }
  ParseArgsResult::{
    values,
    positionals: r["positionals"].cast(),
    tokens: None,
  }
}
