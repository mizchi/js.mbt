// Builtin type conversions to JS
// This file measures the overhead of converting MoonBit builtin types to JS

///|
extern "js" fn console_log(v : @nostd.Any) -> Unit =
  #| (v) => console.log(v)

///|
/// Convert MoonBit Map[String, Any] to JS Object
pub fn from_map(map : Map[String, @nostd.Any]) -> @nostd.Any {
  let obj = @nostd.Object::new()
  for k, v in map {
    obj[k] = v
  }
  obj
}

///|
/// Convert Json to JS Any
pub fn from_json(json : Json) -> @nostd.Any {
  match json {
    Null => @nostd.null()
    True => @nostd.any(true)
    False => @nostd.any(false)
    Number(n, ..) => @nostd.any(n)
    String(s) => @nostd.any(s)
    Array(arr) => {
      let js_arr : Array[@nostd.Any] = []
      for item in arr {
        js_arr.push(from_json(item))
      }
      @nostd.any(js_arr)
    }
    Object(map) => {
      let obj = @nostd.Object::new()
      for k, v in map {
        obj[k] = from_json(v)
      }
      obj
    }
  }
}

///|
/// Convert @immut/array.T to JS Array
pub fn[T] from_immut_array(arr : @immut/array.T[T]) -> @nostd.Any {
  let js_arr : Array[T] = []
  arr.each(fn(item) { js_arr.push(item) })
  @nostd.any(js_arr)
}

///|
/// Convert HashSet to JS Array
pub fn[T] from_set(set : @hashset.HashSet[T]) -> @nostd.Any {
  let js_arr : Array[T] = []
  set.each(fn(item) { js_arr.push(item) })
  @nostd.any(js_arr)
}

///|
/// Convert @immut/hashmap.HashMap to JS Object
pub fn[V] from_immut_map(map : @immut/hashmap.HashMap[String, V]) -> @nostd.Any {
  let obj = @nostd.Object::new()
  map.each(fn(k, v) { obj[k] = @nostd.any(v) })
  obj
}

///|
fn main {
  // Map
  let map : Map[String, @nostd.Any] = { "a": @nostd.any(1) }
  console_log(from_map(map))

  // Json
  let json : Json = { "b": 2 }
  console_log(from_json(json))

  // @immut/array
  let immut_arr = @immut/array.from_array([1, 2, 3])
  console_log(from_immut_array(immut_arr))

  // HashSet
  let set = @hashset.from_array([4, 5, 6])
  console_log(from_set(set))

  // @immut/hashmap
  let immut_map = @immut/hashmap.from_array([("c", 3)])
  console_log(from_immut_map(immut_map))
}
