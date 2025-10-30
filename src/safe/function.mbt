///|
pub struct Fn0[R](() -> R)

///|
pub impl[R] ToJs for Fn0[R] with to_js(self) {
  self.0 |> @js.to_js
}

///|
test "Fn0" {
  let f = Fn0(() => 42)
  let v : Int = f.to_js().call([]) |> identity
  assert_eq(v, f())
}

// #external
// pub type Fn1[A, R]

// pub impl[A, R] ToJs for Fn1[A, R] with to_js(self) -> @js.Value {
//   self |> @js.to_js
// }

// #external
// pub type Fn2[A, B, R]
// pub impl[A, B, R] ToJs for Fn2[A, B, R] with to_js(self) -> Value {
//   self |> @js.to_js
// }
// #external
// pub type Fn3[A, B, C, R]
// pub impl[A, B, C, R] ToJs for Fn3[A, B, C, R] with to_js(self) -> Value {
//   self |> @js.to_js
// }

///|
#external
pub type AsyncFn0[R]

///|
pub impl[R] ToJs for AsyncFn0[R] with to_js(self) {
  self |> @js.to_js
}

///|
pub fn[R] AsyncFn0::from(f : async () -> R) -> AsyncFn0[R] {
  @js.to_promise_fn0(f) |> identity
}

///|
pub fn[R] AsyncFn0::call(self : AsyncFn0[R]) -> Promise[R] {
  self.to_js().call([]) |> identity
}

///|
test "AsyncFn0 with cast" {
  let f : AsyncFn0[Int] = AsyncFn0::from(() => 42)
  @js.run_async(() => {
    let p : @js.Promise[Int] = f.to_js().call([]) |> identity
    let v : Int = p.wait() catch { _ => panic() }
    guard v == 42
  })
}

// #external
// pub type AsyncFn1[A, R]
// pub impl[A, R] ToJs for AsyncFn1[A, R] with to_js(self) -> @js.Value {
//   self |> @js.to_js
// }
// #external
// pub type AsyncFn2[A, B, R]
// pub impl[A, B, R] ToJs for AsyncFn2[A, B, R] with to_js(self) -> @js.Value {
//   self |> @js.to_js
// }
// #external
// pub type AsyncFn3[A, B, C, R]
// pub impl[A, B, C, R] ToJs for AsyncFn3[A, B, C, R] with to_js(self) -> @js.Value {
//   self |> @js.to_js
// }
