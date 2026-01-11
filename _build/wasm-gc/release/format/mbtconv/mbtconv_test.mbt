///|
test "from_map converts Map to JS object" {
  let map : Map[String, @core.Any] = {
    "name": @core.any("Alice"),
    "age": @core.any(30),
  }
  let obj = from_map(map)
  let name : String = obj["name"].cast()
  let age : Int = obj["age"].cast()
  inspect(name, content="Alice")
  inspect(age, content="30")
}

///|
test "from_option_map skips None values" {
  let map : Map[String, @core.Any?] = {
    "name": Some(@core.any("Bob")),
    "email": None,
    "age": Some(@core.any(25)),
  }
  let obj = from_option_map(map)
  let name : String = obj["name"].cast()
  let age : Int = obj["age"].cast()
  let email : @core.Any = obj["email"].cast()
  inspect(name, content="Bob")
  inspect(age, content="25")
  inspect(@core.is_undefined(email), content="true")
}

///|
test "from_option_map_or_undefined returns undefined when all None" {
  let map : Map[String, @core.Any?] = { "a": None, "b": None }
  let result : @core.Any = from_option_map_or_undefined(map).cast()
  inspect(@core.is_undefined(result), content="true")
}

///|
test "from_option_map_or_undefined returns object when has values" {
  let map : Map[String, @core.Any?] = {
    "timeout": Some(@core.any(5000)),
    "retries": None,
  }
  let result = from_option_map_or_undefined(map)
  let timeout : Int = result["timeout"].cast()
  inspect(timeout, content="5000")
}

///|
test "from_json converts Json to JS value" {
  let json : Json = {
    "name": "Alice",
    "age": 30,
    "active": true,
    "tags": ["a", "b"],
  }
  let obj = from_json(json)
  let name : String = obj["name"].cast()
  let age : Double = obj["age"].cast()
  let active : Bool = obj["active"].cast()
  let tags : @core.Any = obj["tags"].cast()
  inspect(name, content="Alice")
  inspect(age, content="30")
  inspect(active, content="true")
  inspect(@core.is_array(tags), content="true")
}

///|
test "to_json converts JS value to Json" {
  let obj = @core.new_object()
  obj["name"] = @core.any("Bob")
  obj["age"] = @core.any(25)
  let json = to_json(obj)
  inspect(
    json,
    content=(
      #|Object({"name": String("Bob"), "age": Number(25)})
    ),
  )
}

///|
test "to_json handles arrays" {
  let arr : Array[@core.Any] = [@core.any(1), @core.any(2), @core.any(3)]
  let json = to_json(@core.any(arr))
  inspect(json, content="Array([Number(1), Number(2), Number(3)])")
}

///|
test "to_json handles null and undefined" {
  let null_val = @core.null()
  let undef_val = @core.undefined()
  inspect(to_json(@core.any(null_val)), content="Null")
  inspect(to_json(@core.any(undef_val)), content="Null")
}

///|
test "from_option converts Option to Any" {
  let some_val : @core.Any? = Some(@core.any(42))
  let none_val : @core.Any? = None
  let some_result = from_option(some_val)
  let none_result : @core.Any = from_option(none_val).cast()
  let n : Int = some_result.cast()
  inspect(n, content="42")
  inspect(@core.is_null(none_result), content="true")
}

///|
test "to_option converts Any to Option" {
  let val = @core.any(123)
  let null_val = @core.null()
  let opt1 : Int? = to_option(val)
  let opt2 : Int? = to_option(@core.any(null_val))
  inspect(opt1, content="Some(123)")
  inspect(opt2, content="None")
}

///|
test "roundtrip from_json and to_json" {
  let original : Json = {
    "string": "hello",
    "number": 42.5,
    "bool": true,
    "null": null,
    "array": [1, 2, 3],
    "nested": { "x": 1 },
  }
  let js_val = from_json(original)
  let back = to_json(js_val)
  inspect(
    back,
    content=(
      #|Object({"string": String("hello"), "number": Number(42.5), "bool": True, "null": Null, "array": Array([Number(1), Number(2), Number(3)]), "nested": Object({"x": Number(1)})})
    ),
  )
}

///|
test "JsImpl::as_any converts builtin Json to Js" {
  let j : Json = { "items": [1, 2, 3], "nested": { "key": "value" } }
  let v : @core.Any = @mbtconv.from_json(j)
  assert_eq(@core.identity(v._get("items")._get_by_index(0)), 1)
  assert_eq(@core.identity(v._get("nested")._get("key")), "value")
}

///| Struct Conversion Tests

///|
priv struct Point {
  x : Int
  y : Int
} derive(Show)

///|
fn Point::x2(self : Self) -> Int {
  self.x * 2
}

///|
/// [Test Helper] Creates a plain JS object with x and y properties.
/// Used to test @core.identity casting JS objects to MoonBit structs.
extern "js" fn test_ffi_point_new(x : Int, y : Int) -> @core.Any =
  #|(x, y) => ({ x: x, y: y })

///|
test "from builtin struct" {
  let p = Point::{ x: 10, y: 20 }
  let v : @core.Any = @core.any(p)
  assert_eq(@core.identity(v._get("x")), 10)
  assert_eq(@core.identity(v._get("y")), 20)
  inspect(p, content="{x: 10, y: 20}")
}

///|
test "identity to struct" {
  let v : @core.Any = test_ffi_point_new(5, 15)
  let p : Point = @core.identity(v)
  assert_eq(p.x, 5)
  assert_eq(p.y, 15)
  assert_eq(p.x2(), 10)
  inspect(p, content="{x: 5, y: 15}")
}

///| Function Conversion Tests

///|
test "from_fn0 converts 0-arg function to Js" {
  let greet = fn() -> String { "Hello" }
  let js_greet : @core.Any = @core.from_fn0(greet)
  assert_eq(@core.typeof_(js_greet), "function")
  let result = js_greet._invoke([])
  assert_eq(@core.identity(result), "Hello")
}

///|
test "from_fn1 converts 1-arg function to Js" {
  let double = fn(x : Int) -> Int { x * 2 }
  let js_double : @core.Any = @core.from_fn1(double)
  assert_eq(@core.typeof_(js_double), "function")
  let result = js_double._invoke([@core.any(5)])
  assert_eq(@core.identity(result), 10)
}

///|
test "from_fn2 converts 2-arg function to Js" {
  let add = fn(a : Int, b : Int) -> Int { a + b }
  let js_add : @core.Any = @core.from_fn2(add)
  assert_eq(@core.typeof_(js_add), "function")
  let result = js_add._invoke([@core.any(5), @core.any(3)])
  assert_eq(@core.identity(result), 8)
}

///|
test "from_fn3 converts 3-arg function to Js" {
  let add3 = fn(a : Int, b : Int, c : Int) -> Int { a + b + c }
  let js_add3 : @core.Any = @core.from_fn3(add3)
  assert_eq(@core.typeof_(js_add3), "function")
  let result = js_add3._invoke([@core.any(1), @core.any(2), @core.any(3)])
  assert_eq(@core.identity(result), 6)
}

///| Option Type Conversion Tests

///|
test "JsImpl for Option types" {
  let some_val : Int? = Some(42)
  let none_val : Int? = None
  let js_some : @core.Any = @core.any(some_val)
  let js_none : @core.Any = @core.any(none_val)
  assert_eq(@core.identity(js_some), 42)
  assert_true(@core.is_undefined(js_none))
}
