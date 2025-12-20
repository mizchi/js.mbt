// Tests for tsnize

///|
test "parse enum mbti" {
  let content =
    #|package "test"
    #|
    #|pub enum Status {
    #|  Pending
    #|  Active
    #|  Done
    #|}
    #|
  let mbti = parse_mbti(content, "test.mbti")
  inspect(mbti.package_name, content="test")
  inspect(mbti.sigs.length(), content="1")
}

///|
test "generate dts from enum" {
  let content =
    #|package "test"
    #|
    #|pub enum Status {
    #|  Pending
    #|  Active
    #|  Done
    #|}
    #|
  let mbti = parse_mbti(content, "test.mbti")
  let dts = generate_dts(mbti)
  inspect(dts.contains("Status_Pending"), content="true")
  inspect(dts.contains("Status_Active"), content="true")
  inspect(dts.contains("Status_Done"), content="true")
  inspect(dts.contains("$tag: \"Pending\""), content="true")
}

///|
test "generate dts from struct" {
  let content =
    #|package "test"
    #|
    #|pub struct User {
    #|  name : String
    #|  age : Int
    #|}
    #|
  let mbti = parse_mbti(content, "test.mbti")
  let dts = generate_dts(mbti)
  inspect(dts.contains("interface User"), content="true")
  inspect(dts.contains("name: string"), content="true")
  inspect(dts.contains("age: number"), content="true")
}

///|
test "generate dts from tuple variant enum" {
  let content =
    #|package "test"
    #|
    #|pub enum MyResult {
    #|  Ok(String)
    #|  Err(String)
    #|}
    #|
  let mbti = parse_mbti(content, "test.mbti")
  let dts = generate_dts(mbti)
  inspect(dts.contains("MyResult_Ok"), content="true")
  inspect(dts.contains("MyResult_Err"), content="true")
  inspect(dts.contains("$0: string"), content="true")
}

///|
test "parse real mbti content" {
  let content =
    #|package "test"
    #|
    #|fn[T] any(T) -> Any
    #|
  let mbti = parse_mbti(content, "test.mbti")
  inspect(mbti.package_name, content="test")
  inspect(mbti.sigs.length(), content="1")
}

///|
test "generate dts with generics" {
  let content =
    #|package "test"
    #|
    #|fn[T] any(T) -> Any
    #|
  let mbti = parse_mbti(content, "test.mbti")
  let dts = generate_dts(mbti)
  inspect(dts.contains("export function any<T>"), content="true")
}
