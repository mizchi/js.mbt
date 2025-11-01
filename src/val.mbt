///|
/// unsafe js value
#external
pub type Val

///|
#inline
pub fn[T] Val::cast(self : Val) -> T = "%identity"

///|
#inline
pub fn[T] js(v : T) -> Val = "%identity"

///|
#inline
pub fn[A, B] unsafe_cast(a : A) -> B {
  js(a).cast()
}

///|
pub fn[T] Val::cast_option(self : Val) -> T? {
  if self.is_some() {
    Some(self.cast())
  } else {
    None
  }
}

///|
pub impl Show for Val with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for Val with to_string(self) {
  if self.is_array() {
    return ffi_json_stringify(self, undefined(), undefined())
  }
  if self.is_object() {
    return ffi_json_stringify(self, undefined(), undefined())
  }
  ffi_to_string(self)
}

///|
pub impl Eq for Val with equal(self, other) -> Bool {
  ffi_object_is(self, other)
}

///|
pub impl Eq for &Js with equal(self, other) -> Bool {
  ffi_object_is(self.to_js(), other.to_js())
}

///|
#alias("_[_]")
pub fn Val::get(self : Val, key : &Key) -> Val {
  ffi_get(self, key.to_key() |> unsafe_cast)
}

///|
#alias("_[_]=_")
pub fn Val::set(self : Val, key : String, value : &Js) -> Unit {
  ffi_set(self, key, value.to_js())
}

///|
#inline
pub fn Val::call(self : Self, args : Array[&Js]) -> Val {
  ffi_call(self, args.map(_.to_js()))
}

///|
pub fn Val::call_raise(self : Self, args : Array[&Js]) -> Val raise {
  wrap_fn_sync(() => self.call(args.map(_.to_js())))
}

///|
pub fn Val::call_method(self : Val, key : String, args : Array[&Js]) -> Val {
  ffi_call_method(self, key, args.map(_.to_js()))
}

///|
pub fn Val::call_method_raise(
  self : Val,
  key : String,
  args : Array[&Js],
) -> Val raise {
  wrap_fn_sync(() => ffi_call_method(self, key, args.map(_.to_js())))
}

///|
#inline
pub fn Val::delete(self : Self, k : String) -> Unit {
  ffi_delete(self, k)
}

///|
pub fn Val::has_own_property(self : Self, k : String) -> Bool {
  ffi_has_own_property(self, k)
}

///|
pub fn Val::property_is_enumerable(self : Self, k : String) -> Bool {
  ffi_property_is_enumerable(self, k)
}

///|
pub fn[T] Val::to_option(self : Self) -> T? {
  if self.is_undefined() || self.is_null() {
    None
  } else {
    Some(self.cast())
  }
}

///|
pub extern "js" fn Val::is_array(self : Self) -> Bool =
  #| (v) => Array.isArray(v)

///|
pub extern "js" fn Val::is_object(self : Self) -> Bool =
  #| (v) => typeof v === "object" && v !== null

///|
pub extern "js" fn Val::is_null(self : Self) -> Bool =
  #| (v) => v === null

///|
pub extern "js" fn Val::is_undefined(self : Self) -> Bool =
  #| (v) => v === undefined

///|
pub extern "js" fn Val::is_nan(self : Self) -> Bool =
  #| (v) => Number.isNaN(v)

///|
pub extern "js" fn Val::instance_of(self : Self, cls : Val) -> Bool =
  #| (v, cls) => v instanceof cls

///|
pub extern "js" fn Val::type_of(self : Val) -> String =
  #| (v) => typeof v

///|
pub fn Val::is_some(self : Self) -> Bool {
  !self.is_undefined() && !self.is_null()
}

///|
pub fn Val::is_none(self : Self) -> Bool {
  self.is_undefined() || self.is_null()
}

///|
pub fn stringify(
  v : &Js,
  replacer? : Val = undefined(),
  space? : Int = 2,
) -> String {
  ffi_json_stringify(v.to_js(), replacer, space |> js)
}

///|
pub fn[T] unsafe_stringify(
  v : T,
  replacer? : Val = undefined(),
  space? : Int = 2,
) -> String {
  let v : Val = unsafe_cast(v)
  stringify(v, replacer~, space~)
}

///|
/// js: new Class(args...)
pub fn new_(cls : Val, args : Array[&Js]) -> Val {
  ffi_new(cls, args.map(_.to_js()))
}

///|
/// Throw a JavaScript value
pub fn throw_(v : &Js) -> Val {
  ffi_throw(v.to_js())
}

///|
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> unsafe_cast]) |> ignore
}

// Constant Enum

///|
priv enum TestConstantEnum {
  NotFound = 404
}

///|
test "cast" {
  assert_eq(js(42), js(42))
  let v1 = js(42)
  let v2 = js(42)
  assert_eq(v1, v2)
  assert_eq(js(TestConstantEnum::NotFound), js(404))
  let s1 : String? = js("hello").cast_option()
  assert_eq(s1, Some("hello"))
  let s2 : String? = undefined().cast_option()
  assert_eq(s2, None)
}

///|
test "from struct" {
  struct Point {
    x : Int
    y : Int
  } derive(Eq, Show)
  let p = Point::{ x: 10, y: 20 }
  let v : Val = unsafe_cast(p)
  assert_eq(v.get("x").cast(), 10)
  assert_eq(v.get("y").cast(), 20)
  let casted : Point = v.cast()
  assert_eq(casted, p)
}

///|
priv enum TestEnum {
  A(value~ : Int)
} derive(Eq, Show)

///|
fn TestEnum::from_js(v : Val) -> Self raise {
  let tag : String = v.get("tag").cast()
  match tag {
    "A" => {
      let value = v.get("value")
      guard value.type_of() == "number"
      A(value=value.cast())
    }
    _ => fail("unknown tag: " + tag)
  }
}

///|
impl Js for TestEnum with to_js(self) {
  match self {
    A(value~) => {
      let obj = new_empty_object()
      obj.set("tag", "A")
      obj.set("value", value)
      obj
    }
  }
}

///|
test "from trait" {
  let v : TestEnum = A(value=123)
  let v : Val = v.to_js()
  assert_eq(v.get("tag").cast(), "A")
  assert_eq(v.get("value").cast(), 123)
  let recovered : TestEnum = TestEnum::from_js(v)
  assert_eq(recovered, A(value=123))
}

///|
test "to_string" {
  assert_eq(js(42).to_string(), "42")
  assert_eq(null_().to_string(), "null")
  assert_eq(js(true).to_string(), "true")
  assert_eq(js("hello").to_string(), "hello")
  assert_true(undefined().is_undefined())
  assert_true(null_().is_null())
  assert_eq(new_empty_object().to_string(), "{}")
  assert_eq(new_empty_array().to_string(), "[]")
  from_builtin_array([1, 2, 3]).to_string() |> assert_eq("[1,2,3]")
  let expected =
    #|{"a":1,"b":2}
  from_builtin_map({ "a": 1 |> js, "b": 2 |> js }).to_string()
  |> assert_eq(expected)
}

///|
test "stringify" {
  let arr : Array[Int] = [1] |> unsafe_cast
  arr |> inspect(content="[1]")
  unsafe_stringify(arr, space=2)
  |> inspect(
    content=(
      #|[
      #|  1
      #|]
    ),
  )
  let v = from_builtin_map({
    "key1": 123 |> js,
    "key2": 456 |> js,
    "key3": 789 |> js,
  })
  stringify(v, space=2)
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
