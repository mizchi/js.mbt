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
pub fn ParseArgsOption::as_any(self : ParseArgsOption) -> @core.Any {
  match self {
    Boolean(short~, ..) =>
      @mbtconv.from_map({
        "type": @core.any("boolean"),
        "short": @core.any(short),
      })
    String(short~, multiple~, default~, ..) =>
      @mbtconv.from_option_map({
        "type": Some(@core.any("string")),
        "short": Some(@core.any(short)),
        "multiple": Some(@core.any(multiple)),
        "default": default.map(fn(x) { @core.any(x) }),
      })
  }
}

///|
pub(all) struct ParseArgsResult {
  values : Map[String, @core.Any]
  positionals : Array[String]
  tokens : Array[@core.Any]?
}

///|
#alias(parse_args)
pub fn parseArgs(
  args~ : Array[String],
  options~ : Array[ParseArgsOption],
  allow_positionals? : Bool = false,
  // tokens?: Bool = false,
) -> ParseArgsResult {
  let opts_obj : @core.Any = if options.is_empty() {
    @core.any(@core.Object::new())
  } else {
    let o : @core.Any = @core.any(@core.Object::new())
    for opt in options {
      o[opt.key()] = opt.as_any()
    }
    o
  }
  let result : @core.Any = @mbtconv.from_map({
    "args": @core.any(args),
    "options": opts_obj,
    "allowPositionals": @core.any(allow_positionals),
  })
  // result["tokens"] = tokens
  let r : @core.Any = util().as_any()["parseArgs"]._invoke([result])
  let values : Map[String, @core.Any] = {}
  let result_keys : Array[String] = @core.Object::keys(r["values"])
  for k in result_keys {
    values[k] = r["values"][k].cast()
  }
  ParseArgsResult::{
    values,
    positionals: r["positionals"].cast(),
    tokens: None,
  }
}
