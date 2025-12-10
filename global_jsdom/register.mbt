///|
/// JS: require("global-jsdom/register")
pub fn register() -> Unit {
  @node.require("global-jsdom/register") |> ignore
}
