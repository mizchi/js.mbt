///|
#external
pub type JSON

///|
pub fn JSON::stringify(
  v : Val,
  replacer? : Val = undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v.to_js(), replacer, space |> js)
}

///|
pub fn JSON::parse(s : String, reviver? : Val? = None) -> Val raise JsError {
  throwable(() => ffi_json_parse(s, reviver?))
}

///|
test "json_stringify" {
  let arr : Array[Int] = [1] |> unsafe_cast
  arr |> inspect(content="[1]")
  JSON::stringify(arr |> from_array, space=2)
  |> inspect(
    content=(
      #|[
      #|  1
      #|]
    ),
  )
  let v = from_map({ "key1": 123 |> js, "key2": 456 |> js, "key3": 789 |> js })
  JSON::stringify(v, space=2)
  |> inspect(
    content=(
      #|{
      #|  "key1": 123,
      #|  "key2": 456,
      #|  "key3": 789
      #|}
    ),
  )
}
