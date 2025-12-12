///|
pub fn test_math_random() -> @xany.Xany {
  let global = @xany.global_this()
  let math = global._get("Math")
  let random_fn = math._get("random")
  random_fn._invoke([])
}

///|
fn main {
  let result = test_math_random()
  let global = @xany.global_this()
  let console = global._get("console")
  console._call("log", [@xany.Xany::of("Math.random() ="), result]) |> ignore
}
