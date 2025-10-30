///|
extern "js" fn ffi_import(module_name : String) -> Promise[Value] = "(moduleName) => import(moduleName)"

///|
pub fn import_module_promise(module_name : String) -> Promise[Value] {
  ffi_import(module_name)
}

///|
pub async fn import_module(module_name : String) -> Value {
  ffi_import(module_name).wait()
}

///|
test {
  run_async(() => try {
    let basename : (String) -> String = import_module("node:path")
      .get_as("basename")
    let x : String = basename("a/b/c.txt") |> identity
    assert_eq(x, "c.txt")
  } catch {
    _ => panic()
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
    let parse_args : (Value) -> Value = import_module("node:util").get_as(
        "parseArgs",
      )
    let parsed = parse_args(rawjs)
    let parsed : Parsed = Parsed::{
      help: parsed.get("values").get("help").cast(),
      out: parsed.get("values").get("out").cast(),
      rest: parsed.get("positionals").cast(),
    }
    assert_eq(parsed, Parsed::{ help: true, out: "output.txt", rest: ["vvv"] })
  } catch {
    _ => ()
  })
}

pub impl ToJs for Error with to_js(self) {
  self |> to_js
}

///|
test "fail import" {
  run_async(() => {
    let t = NodeTest::load() catch { _ => panic() }
    t.it("import failure", (_) => {
      try {
        let _ = import_module("non-existent-module")
        fail("unreachable")
      } catch {
        e => {
          let e : Value = ToJs::to_js(e)
          assert_eq(e.is_error(), true)
          let m : String = e.get("message").cast()
          assert_true(m.contains("Cannot find package 'non-existent-module'"))
        }
      }
    })
  })
}