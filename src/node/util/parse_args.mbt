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
impl Js for ParseArgsOption with to_js(self) -> Val {
  match self {
    Boolean(short~, ..) => {
      let obj = @js.new_empty_object()
      obj.set("type", "boolean")
      obj.set("short", short)
      obj
    }
    String(short~, multiple~, default~, ..) => {
      let obj = @js.new_empty_object()
      obj.set("type", "string")
      obj.set("short", short)
      obj.set("multiple", multiple)
      obj.set("default", default)
      obj
    }
  }
}

///|
pub(all) struct ParseArgsResult {
  values : Map[String, Val]
  positionals : Array[String]
  tokens : Array[Val]?
}

///|
pub fn parse_args(
  args~ : Array[String],
  options~ : Array[ParseArgsOption],
  allow_positionals? : Bool = false,
  // tokens?: Bool = false,
) -> ParseArgsResult {
  let result = @js.new_empty_array()
  result["args"] = args |> js
  result["options"] = if options.is_empty() {
    @js.new_empty_object()
  } else {
    let o = @js.new_empty_object()
    for opt in options {
      o.set(opt.key(), opt.to_js())
    }
    o
  }
  result["allowPositionals"] = allow_positionals
  // result["tokens"] = tokens
  let r : Val = Util::require().to_js().get("parseArgs").invoke_self([result]).cast()
  let values : Map[String, Val] = {}
  let result_keys = r.get("values") |> @js.object_keys()
  for k in result_keys {
    values[k] = r.get("values").get(k).cast()
  }
  ParseArgsResult::{
    values,
    positionals: r.get("positionals").cast(),
    tokens: None,
  }
}

///|
test "parse_args" {
  let res = parse_args(
    args=[
      "--name", "alice", "--verbose", "-k", "v", "-h", "file1.txt", "file2.txt",
    ],
    options=[
      String(key="key", short="k", multiple=false, default=None),
      String(key="name", short="n", multiple=false, default=None),
      Boolean(key="verbose", short="v"),
      Boolean(key="help", short="h"),
    ],
    allow_positionals=true,
  )
  assert_eq(res.values, {
    "key": "v" |> js,
    "name": "alice" |> js,
    "verbose": true |> js,
    "help": true |> js,
  })
  assert_eq(res.positionals, ["file1.txt", "file2.txt"])
}
