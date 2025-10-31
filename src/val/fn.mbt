///|
pub(all) struct Fn0[R](() -> R)
pub(all) struct Fn1[A, R]((A) -> R)
pub(all) struct Fn2[A, B, R]((A, B) -> R)
pub(all) struct Fn3[A, B, C, R]((A, B, C) -> R)

pub impl[R] Js for Fn0[R] with to_js(self) {
  self |> js
}
pub impl[A, R] Js for Fn1[A, R] with to_js(self) {
  self |> js
}
pub impl[A, B, R] Js for Fn2[A, B, R] with to_js(self) {
  self |> js
}
pub impl[A, B, C, R] Js for Fn3[A, B, C, R] with to_js(self) {
  self |> js
}

extern "js" fn ffi_wrap_fn(
  f: Val,
  ok: (Val) -> Unit,
  err: (Val) -> Unit,
) -> Unit =
  #|(f, ok, err) => {
  #|  try {
  #|    ok(f())
  #|  } catch(e) {
  #|    err(e)
  #|  }
  #|}

fn[T] wrap_fn_sync(f: () -> T) -> T raise {
  let mut v : Result[T, Val] = Err(undefined())
  let ok = (r) => v = Ok(r |> unsafe_cast)
  let err = (e) => v = Err(e)
  ffi_wrap_fn(unsafe_cast(f), ok, err)
  match v {
    Ok(result) => result
    Err(e) => raise JsError(e |> unsafe_cast)
  }
}

///|
pub fn[R] Fn0::call_raise(f : Self[R]) -> R raise {
  wrap_fn_sync(() => f())
}

pub fn[A, R] Fn1::call_raise(f: Self[A, R], a: A) -> R raise {
  wrap_fn_sync(() => f(a))
}

pub fn[A, B, R] Fn2::call_raise(f: Self[A, B, R], a: A, b: B) -> R raise {
  wrap_fn_sync(() => f(a, b))
}

pub fn[A, B, C, R] Fn3::call_raise(f: Self[A, B, C, R], a: A, b: B, c: C) -> R raise {
  wrap_fn_sync(() => f(a, b, c))
}

test "cast and call" {
  let f = fn() { 42 }
  let f2: Fn0[Int]  = f |> unsafe_cast
  f2() |> assert_eq(42)
  f2.0() |> assert_eq(42)
  f2.call_raise() |> assert_eq(42)
}

test "Fn0" {
  let tos: Fn0[String] = global_this().get("toString").cast()
  let f = tos.call_raise()
  assert_eq(f, "[object Undefined]")

  let now: Fn0[Int] = global_this().get("__nothing").cast()
  guard (try? now.call_raise()) is Err(JsError(_))
}

test "Fn1" {
  let parse_int: Fn1[String, Int] = global_this().get("parseInt").cast()
  assert_eq(parse_int("41") , 41)
  let fail: Fn1[String, Int] = global_this().get("__nothing").cast()
  guard (try? fail.call_raise("arg")) is Err(JsError(_))
}

test "Fn2" {
  let imul: Fn2[Int, Int, Int] = global_this().get("Math").get("imul").cast()
  assert_eq(imul(2, 2) , 4)
}

test "Tuple to args" {
  let t = (1, 2, 3)
  let v = new_array()
  v.call_method("push", [js(t.0) |> js]) |> ignore
  v.call_method("push", [js(t.1) |> js]) |> ignore
  v.call_method("push", [js(t.2) |> js]) |> ignore
  let resumed: Array[Int] = v.cast()
  assert_eq(resumed, [1, 2, 3])
}
