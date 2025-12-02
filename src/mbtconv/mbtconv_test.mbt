///|
test "from_map converts Map to JS object" {
  let map : Map[String, @nostd.Any] = {
    "name": @nostd.any("Alice"),
    "age": @nostd.any(30),
  }
  let obj = from_map(map)
  let name : String = obj._get("name").cast()
  let age : Int = obj._get("age").cast()
  inspect(name, content="Alice")
  inspect(age, content="30")
}

///|
test "from_option_map skips None values" {
  let map : Map[String, @nostd.Any?] = {
    "name": Some(@nostd.any("Bob")),
    "email": None,
    "age": Some(@nostd.any(25)),
  }
  let obj = from_option_map(map)
  let name : String = obj._get("name").cast()
  let age : Int = obj._get("age").cast()
  let email : @nostd.Any = obj._get("email").cast()
  inspect(name, content="Bob")
  inspect(age, content="25")
  inspect(@nostd.is_undefined(email), content="true")
}

///|
test "from_option_map_or_undefined returns undefined when all None" {
  let map : Map[String, @nostd.Any?] = { "a": None, "b": None }
  let result : @nostd.Any = from_option_map_or_undefined(map).cast()
  inspect(@nostd.is_undefined(result), content="true")
}

///|
test "from_option_map_or_undefined returns object when has values" {
  let map : Map[String, @nostd.Any?] = {
    "timeout": Some(@nostd.any(5000)),
    "retries": None,
  }
  let result = from_option_map_or_undefined(map)
  let timeout : Int = result._get("timeout").cast()
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
  let name : String = obj._get("name").cast()
  let age : Double = obj._get("age").cast()
  let active : Bool = obj._get("active").cast()
  let tags : @nostd.Any = obj._get("tags").cast()
  inspect(name, content="Alice")
  inspect(age, content="30")
  inspect(active, content="true")
  inspect(@nostd.is_array(tags), content="true")
}

///|
test "to_json converts JS value to Json" {
  let obj = @nostd.Object::new()
  obj["name"] = @nostd.any("Bob")
  obj["age"] = @nostd.any(25)
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
  let arr : Array[@nostd.Any] = [@nostd.any(1), @nostd.any(2), @nostd.any(3)]
  let json = to_json(@nostd.any(arr))
  inspect(json, content="Array([Number(1), Number(2), Number(3)])")
}

///|
test "to_json handles null and undefined" {
  let null_val = @nostd.null()
  let undef_val = @nostd.undefined()
  inspect(to_json(@nostd.any(null_val)), content="Null")
  inspect(to_json(@nostd.any(undef_val)), content="Null")
}

///|
test "from_option converts Option to Any" {
  let some_val : @nostd.Any? = Some(@nostd.any(42))
  let none_val : @nostd.Any? = None
  let some_result = from_option(some_val)
  let none_result : @nostd.Any = from_option(none_val).cast()
  let n : Int = some_result.cast()
  inspect(n, content="42")
  inspect(@nostd.is_null(none_result), content="true")
}

///|
test "to_option converts Any to Option" {
  let val = @nostd.any(123)
  let null_val = @nostd.null()
  let opt1 : Int? = to_option(val)
  let opt2 : Int? = to_option(@nostd.any(null_val))
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
  let v : @nostd.Any = @mbtconv.from_json(j)
  assert_eq(@nostd.identity(v._get("items")._get_by_index(0)), 1)
  assert_eq(@nostd.identity(v._get("nested")._get("key")), "value")
}
