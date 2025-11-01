///|
/// Dynamically import a module asynchronously
/// import(module_name)
pub fn import_(module_name : String) -> Promise[Val] {
  @js.dynamic_import(module_name) |> unsafe_cast()
}

///|
pub async fn import_async(module_name : String) -> Val {
  import_(module_name).unwrap()
}
