
// trait MyTrait {
//   my_method(Self) -> Int
// }

// #external
// type Val
// fn[T] cast_to_val(v: T) -> Val = "%identity"

// struct Val2(Int)
// impl MyTrait for Val2 with my_method(self) -> Int {
//   self.0
// }

// impl MyTrait for Val with my_method(self) -> Int {
//   42
// }

// impl @js.ToJs for Val with to_js(self) {
//   100 |> @js.identity
// }

// extern "js" fn is_trait_value(v: @js.Value) -> Bool =
//   #| (v) => typeof v === "object" && v.self != null

// fn trait_to_val(v: &@js.ToJs) -> @js.Value {
//   v.to_js()
// }

// struct MyCallback((Int) -> Int)

// fn main {
//   let v = cast_to_val(123)
//   @js.log(v)

//   // raw
//   let vvv: &@js.ToJs = v |> @js.identity
//   @js.log(vvv)

//   // {self:...}
//   let vvv: &@js.ToJs = v
//   @js.log(vvv)
//   let v = is_trait_value(vvv |> @js.identity)
//   @js.log(v)

//   /// raw
//   let vvv = trait_to_val(vvv)
//   @js.log(vvv)

//   /// raw
//   // let vvv = trait_to_val2(vvv)
//   // @js.log(vvv)

//   let cb: MyCallback = x => {
//     x + 1
//   }
//   @js.log(cb)
//   let (f) = cb
//   f(10) |> @js.log
//   @js.log(f)
//   // @js.log(to_string(cb |> @js.identity))
//   // let casted = @js.Value::cast_from(cb)
//   // @js.log(casted.call([10 |> @js.identity]))
// }

fn main {
  @js.log("hello from main.mbt")
}