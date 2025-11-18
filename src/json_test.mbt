///|
test "JSON::stringify" {
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
  let v = from_map({
    "key1": 123 |> safe_js,
    "key2": 456 |> safe_js,
    "key3": 789 |> safe_js,
  })
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
