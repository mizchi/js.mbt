///|
#external
pub type Deno

///|
impl @js.JsImpl for Deno

///|
extern "js" fn deno() -> Deno =
  #| () => Deno

///|
#external
pub type TestContext

///|
pub impl @js.JsImpl for TestContext

///|
/// JS: Deno.test(name: string, (t) => {})
pub fn Deno::test_(
  self : Self,
  name : String,
  f : (TestContext) -> Unit,
) -> Unit {
  deno().call("test", [name, @js.from_fn1(f)]) |> ignore
}
