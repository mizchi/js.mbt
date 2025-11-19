///|
/// Deno namespace
/// https://docs.deno.com/api/deno/

///|
#external
pub type Deno

///|
impl @js.JsImpl for Deno

///|
/// Deno global object
pub extern "js" fn deno() -> Deno =
  #| () => Deno

///| Process/Runtime APIs

///|
/// Get environment variable
pub fn Deno::env_get(self : Deno, key : String) -> String? {
  self.get("env").call("get", [@js.js(key)]) |> @js.unsafe_cast_option
}

///|
/// Set environment variable
pub fn Deno::env_set(self : Deno, key : String, value : String) -> Unit {
  self.get("env").call("set", [@js.js(key), @js.js(value)]) |> ignore
}

///|
/// Delete environment variable
pub fn Deno::env_delete(self : Deno, key : String) -> Unit {
  self.get("env").call("delete", [@js.js(key)]) |> ignore
}

///|
/// Get all environment variables
pub fn Deno::env_toObject(self : Deno) -> Js {
  self.get("env").call("toObject", [])
}

///|
/// Get current working directory
pub fn Deno::cwd(self : Deno) -> String {
  self.call("cwd", []) |> @js.unsafe_cast
}

///|
/// Exit the process
pub fn Deno::exit(self : Deno, code? : Int) -> Unit {
  match code {
    Some(c) => self.call("exit", [@js.js(c)]) |> ignore
    None => self.call("exit", []) |> ignore
  }
}

///|
/// Get command line arguments
pub fn Deno::args(self : Deno) -> Array[String] {
  self.get("args") |> @js.unsafe_cast
}

///| File System APIs

///|
/// Read text file
pub fn Deno::readTextFile(
  self : Deno,
  path : String,
) -> @promise.Promise[String] {
  self.call("readTextFile", [@js.js(path)]) |> @js.unsafe_cast
}

///|
/// Write text file
pub fn Deno::writeTextFile(
  self : Deno,
  path : String,
  data : String,
) -> @promise.Promise[Unit] {
  self.call("writeTextFile", [@js.js(path), @js.js(data)]) |> @js.unsafe_cast
}

///|
/// Read file as Uint8Array
pub fn Deno::readFile(self : Deno, path : String) -> @promise.Promise[Js] {
  self.call("readFile", [@js.js(path)]) |> @js.unsafe_cast
}

///|
/// Write file from Uint8Array
pub fn Deno::writeFile(
  self : Deno,
  path : String,
  data : Js,
) -> @promise.Promise[Unit] {
  self.call("writeFile", [@js.js(path), data]) |> @js.unsafe_cast
}

///|
/// Remove file or directory
pub fn Deno::remove(
  self : Deno,
  path : String,
  recursive? : Bool,
) -> @promise.Promise[Unit] {
  match recursive {
    Some(r) => {
      let opts = @js.Object::new()
      opts.set("recursive", r)
      self.call("remove", [@js.js(path), opts]) |> @js.unsafe_cast
    }
    None => self.call("remove", [@js.js(path)]) |> @js.unsafe_cast
  }
}

///|
/// Create directory
pub fn Deno::mkdir(
  self : Deno,
  path : String,
  recursive? : Bool,
) -> @promise.Promise[Unit] {
  match recursive {
    Some(r) => {
      let opts = @js.Object::new()
      opts.set("recursive", r)
      self.call("mkdir", [@js.js(path), opts]) |> @js.unsafe_cast
    }
    None => self.call("mkdir", [@js.js(path)]) |> @js.unsafe_cast
  }
}

///|
/// Read directory entries
pub fn Deno::readDir(self : Deno, path : String) -> Js {
  self.call("readDir", [@js.js(path)])
}

///| Test APIs

///|
#external
pub type TestContext

///|
pub impl @js.JsImpl for TestContext

///|
/// Deno.test(name, fn)
pub fn Deno::test_(
  self : Deno,
  name : String,
  f : (TestContext) -> Unit,
) -> Unit {
  self.call("test", [@js.js(name), @js.from_fn1(f)]) |> ignore
}

///|
/// Deno.test(name, async fn)
pub fn Deno::test_async(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  self.call("test", [@js.js(name), @promise.promisify1(f) |> @js.from_fn1])
  |> ignore
}

///|
/// Deno.test with options (simplified - use only for testing async functions with basic options)
pub fn Deno::test_only(
  self : Deno,
  name : String,
  f : async (TestContext) -> Unit,
) -> Unit {
  let opts : @js.Object = @js.Object::new()
  opts.set("name", name)
  opts.set("only", true)
  opts.set("fn", @promise.promisify1(f) |> @js.from_fn1)
  let test_fn = self.get("test")
  test_fn.call_self([opts.to_js()]) |> ignore
}
