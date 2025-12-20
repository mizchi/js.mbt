// Whitebox tests for tsnize - test with real mbti files

///|
test "parse and generate from real mbti" {
  let content =
    #|package "mizchi/js/core"
    #|
    #|fn[T] any(T) -> Any
    #|
    #|fn global_this() -> Any
    #|
    #|fn sleep(Double) -> Promise[Unit]
    #|
    #|pub(all) struct Any {
    #|}
    #|
    #|pub struct Promise[T] {
    #|}
    #|
  let mbti = parse_mbti(content, "core.mbti")
  let dts = generate_dts(mbti)

  // Check basic structure
  assert_true(dts.contains("// Generated from .mbti"))

  // Check functions
  assert_true(dts.contains("export function any<T>"))
  assert_true(dts.contains("export function globalThis"))
  assert_true(dts.contains("export function sleep"))

  // Check types
  assert_true(dts.contains("interface Any"))
  assert_true(dts.contains("interface Promise<T>"))
  println(dts)
}

///|
test "to_camel_case" {
  assert_eq(to_camel_case("hello_world"), "helloWorld")
  assert_eq(to_camel_case("get_user_name"), "getUserName")
  assert_eq(to_camel_case("simple"), "simple")
}

///|
test "char_to_upper" {
  assert_eq(char_to_upper('a'), 'A')
  assert_eq(char_to_upper('z'), 'Z')
  assert_eq(char_to_upper('A'), 'A')
  assert_eq(char_to_upper('1'), '1')
}
