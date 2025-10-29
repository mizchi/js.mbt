///|
extern "js" fn ffi_import_module(module_name : String) -> Promise[Value] = "(moduleName) => import(moduleName)"

///|
pub async fn import_module(module_name : String, specifier? : String) -> Value {
  if specifier is Some(v) {
    let mod = ffi_import_module(module_name).wait()
    return mod.get(v) |> identity
  } else {
    return ffi_import_module(module_name).wait()
  }
}

///|
test {
  run_async(() => try {
    let basename : (String) -> String = import_module(
        "node:path",
        specifier="basename",
      )
      |> identity
    let x : String = basename("a/b/c.txt") |> identity
    assert_eq(x, "c.txt")
  } catch {
    _ => ()
  })
}

///|
test {
  struct Parsed {
    help : Bool
    out : String
    rest : Array[String]
  } derive(Eq, Show)
  run_async(() => try {
    let json : Json = {
      "args": ["-h", "-o", "output.txt", "vvv"],
      "allowPositionals": true,
      "options": {
        "out": { "type": "string", "short": "o", "description": "Output file" },
        "help": { "type": "boolean", "short": "h", "description": "Show help" },
      },
    }
    let rawjs = ToJs::to_js(json)
    // log(rawjs)
    let parse_args : (Value) -> Value = import_module(
        "node:util",
        specifier="parseArgs",
      )
      |> identity
    let parsed = parse_args(rawjs)
    // log(parsed)
    let parsed : Parsed = Parsed::{
      help: parsed.get("values").get("help") |> identity,
      out: parsed.get("values").get("out") |> identity,
      rest: parsed.get("positionals") |> identity,
    }
    assert_eq(parsed, Parsed::{ help: true, out: "output.txt", rest: ["vvv"] })
  } catch {
    _ => ()
  })
}
