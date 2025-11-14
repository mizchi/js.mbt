///|
#external
pub type JsValue

///|
pub fn[T] JsValue::cast(self : JsValue) -> T = "%identity"

///|
pub fn[A, B] unsafe_cast(a : A) -> B = "%identity"

///|
pub fn[A] js(a : A) -> JsValue = "%identity"

///|
extern "js" fn object_is(a : JsValue, b : JsValue) -> Bool =
  #| (v,k) => Object.is(v, k)

///|
pub impl Eq for JsValue with equal(self, other) -> Bool {
  object_is(self, other)
}

///|
pub impl Show for JsValue with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for JsValue with to_string(self) {
  if self == undefined() {
    "undefined"
  } else {
    self.call_method("toString", []).cast()
  }
}

///|
#alias("_[_]")
pub extern "js" fn JsValue::get(self : Self, key : String) -> JsValue =
  #| (v,k) => v[k]

///|
#alias("_[_]=_")
pub extern "js" fn JsValue::set(
  self : Self,
  key : String,
  value : JsValue,
) -> Unit =
  #| (o,k,v) => o[k] = v

///|
pub extern "js" fn JsValue::call(self : Self, args : Array[JsValue]) -> JsValue =
  #| (v, a) => v(...a)

///|
pub extern "js" fn JsValue::call_method(
  self : Self,
  key : String,
  args : Array[JsValue],
) -> JsValue =
  #| (v, key, a) => v[key](...a)

///|
pub extern "js" fn undefined() -> JsValue =
  #| () => undefined

///|
pub extern "js" fn JsValue::is_undefined(self : Self) -> Bool =
  #| (v) => v === undefined

///|
pub extern "js" fn new_object() -> JsValue =
  #| () => ({})

///|
extern "js" fn ffi_console_log(v : Array[JsValue]) -> Unit =
  #|(obj) => console.log(...obj)

///|
pub fn[T] log(v : T) -> Unit {
  ffi_console_log([v |> unsafe_cast])
}

///|
test {
  let v1 : JsValue = js(42)
  let v2 : JsValue = js(42)
  assert_eq(v1, v2)
  let v : Int = v1.cast()
  assert_eq(v, 42)
  let obj = new_object()
  obj.set("key", js("value"))
  obj.call_method("hasOwnProperty", [js("key")]).cast() |> assert_true
  let val : String = obj.get("key").cast()
  assert_eq(val, "value")
}

///|
// fn main {
//   log("string")
//   log({ "key": "value" })
// }

///|

///|
// fn main {
//   enum Color {
//     Red = 0
//     Green
//     Blue
//   }
//   enum Color2 {
//     RGB(r~ : Int, g~ : Int, b~ : Int)
//     HSL(h~ : Int, s~ : Int, l~ : Int)
//   }
//   let result : Result[Int, String] = Ok(42)
//   log(result)
//   log(Color::Red)
//   log(Color2::RGB(r=255, g=0, b=128))
//   let show : &Show = "hello"
//   log(show)
//   let map = { "one": 1, "two": 2, "three": 3 }
//   log(map)
//   let json : Json = {
//     "name": "Alice",
//     "age": 30,
//     "isStudent": false,
//     "scores": [85, 90, 95],
//     "address": { "street": "123 Main St", "city": "Wonderland" },
//   }
//   log(json)
// }
pub fn from_builtin_map(m : Map[String, JsValue]) -> JsValue {
  let obj = new_object()
  for k, v in m {
    obj.set(k, v)
  }
  obj
}

///|
pub extern "js" fn global_this() -> JsValue =
  #| () => globalThis

///|
pub extern "js" fn require(name : String) -> JsValue =
  #| (name) => require(name)

///|
// fn main {
//   let r = require("node:fs").get()
// }

///|
/// `run_async` spawn a new coroutine and execute an async function in it
fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
/// `suspend` will suspend the execution of the current coroutine.
/// The suspension will be handled by a callback passed to `suspend`
async fn[T, E : Error] suspend(
  // `f` is a callback for handling suspension
  f : (
    // the first parameter of `f` is used to resume the execution of the coroutine normally
    (T) -> Unit,
    // the second parameter of `f` is used to cancel the execution of the current coroutine
    // by throwing an error at suspension point
    (E) -> Unit,
  ) -> Unit,
) -> T raise E = "%async.suspend"

///|
extern "js" fn ffi_wrap_call(
  op : () -> JsValue,
  on_ok : (JsValue) -> Unit,
  on_error : (JsValue) -> Unit,
) -> Unit =
  #| (op, on_ok, on_error) => { try { on_ok(op()); } catch (e) { on_error(e); } }

///|
suberror JsError JsValue

///|
pub fn JsValue::call_method_raise(
  self : JsValue,
  key : String,
  args : Array[JsValue],
) -> JsValue raise JsError {
  let mut res : Result[JsValue, JsValue] = Ok(undefined())
  let op = () => self.call_method(key, args)
  ffi_wrap_call(op, fn(v) { res = Ok(v) }, fn(e) { res = Err(e |> unsafe_cast) })
  match res {
    Ok(v) => v
    Err(e) => raise JsError(e)
  }
}

///|
pub extern "js" fn ffi_promise_new(
  on_fulfilled : (JsValue) -> Unit,
  on_rejected? : (JsValue) -> Unit,
) -> Promise[JsValue] =
  #|(ok, err) => new Promise(ok, err)

///|
pub extern "js" fn ffi_promise_then(
  promise : Promise[JsValue],
  on_fulfilled : (JsValue) -> Unit,
  on_rejected? : (JsValue) -> Unit,
) -> Promise[JsValue] =
  #|(p, ok, err) => p.then(ok).catch(err)

///|
#external
pub type Promise[T]

///|
pub fn[T] Promise::new(
  resolve : (T) -> Unit,
  reject? : (JsValue) -> Unit,
) -> Promise[T] {
  ffi_promise_new(fn(v) { resolve(v |> unsafe_cast) }, on_rejected=fn(e) {
    if reject is Some(reject) {
      reject(e |> unsafe_cast)
    }
  })
  |> unsafe_cast
}

///|
pub async fn[A] Promise::unwrap(
  self : Self[A],
  // resolve : (A) -> Promise[B] raise,
) -> Promise[A] raise JsError {
  suspend((resume_ok, resume_err) => ffi_promise_then(
      self |> unsafe_cast,
      v => resume_ok(v |> unsafe_cast) |> ignore,
      on_rejected=e => resume_err(JsError(e |> unsafe_cast)) |> ignore,
    )
    |> ignore)
}

///|
extern "js" fn lazy_double(v : Int) -> Promise[Int] =
  #| (v) => new Promise((resolve) => setTimeout(() => resolve(v*2), 100))

///|
fn main {
  run_async(() => try {
    let v : Int = lazy_double(21).unwrap() |> unsafe_cast
    assert_eq(v, 42)
  } catch {
    e => log(e)
  })
  // try undefined().call_method_raise("nonExistentMethod", []) |> ignore catch {
  //   JsError(e) => log("Caught JsError: " + e.to_string())
  // }
  // run_async(() => {
  //   log("Start sleeping...")
  //   sleep(1000) catch {
  //     e => log("Sleep error: " + e.to_string())
  //   }
  //   log("Awake!")
  // })
  // let readFileSync : (String, String) -> String = require("node:fs").get(
  //     "readFileSync",
  //   )
  //   |> unsafe_cast
  // let content = readFileSync("moon.mod.json", "utf-8")
  // log(content)
  // // let p = new_object()
  // p["x"] = 10 |> unsafe_cast
  // p["y"] = 20 |> unsafe_cast
  // log(p)
  // log(p["y"])
  // log(p.call_method("hasOwnProperty", ["x" |> unsafe_cast]))
  // struct Point {
  //   x : Int
  //   y : Int
  // }
  // log("hello")
  // log(1)
  // log(3.14)
  // log(true)
  // let b1 : Bytes = b"abcd"
  // log(b1)
  // log(fn() {  })
  // log([1, 2, 3])
  // log(Point::{ x: 10, y: 20 })
  // let mut maybe_value : Int? = Some(42)
  // log(maybe_value)
  // maybe_value = None
  // log(maybe_value)
}
