///|
/// JavaScript BigInt
#external
pub type JsBigInt

///|
pub impl JsImpl for JsBigInt

///|
/// get the BigInt class
fn bigint_class() -> Js {
  unsafe_cast(globalThis().get("BigInt"))
}

///|
/// JS: BigInt(value)
pub fn JsBigInt::from_int(value : Int) -> JsBigInt {
  bigint_class().call_self([value]) |> unsafe_cast
}

///|
/// JS: BigInt(value)
pub fn JsBigInt::from_string(value : String) -> JsBigInt {
  bigint_class().call_self([value]) |> unsafe_cast
}

///|
/// JS: BigInt.asIntN(bits, bigint)
pub fn JsBigInt::asIntN(bits : Int, bigint : JsBigInt) -> JsBigInt {
  bigint_class().call2("asIntN", bits, bigint) |> unsafe_cast
}

///|
/// JS: BigInt.asUintN(bits, bigint)
pub fn JsBigInt::asUintN(bits : Int, bigint : JsBigInt) -> JsBigInt {
  bigint_class().call2("asUintN", bits, bigint) |> unsafe_cast
}

///|
/// JS: bigint.toString()
pub fn JsBigInt::to_string(self : Self) -> String {
  self.call0("toString") |> unsafe_cast
}

///|
/// JS: bigint.toString(radix)
pub fn JsBigInt::to_string_radix(self : Self, radix : Int) -> String {
  self.call1("toString", radix) |> unsafe_cast
}

///|
/// JS: bigint.valueOf()
pub fn JsBigInt::valueOf(self : Self) -> JsBigInt {
  self.call0("valueOf") |> unsafe_cast
}

///|
/// JS: a + b
pub extern "js" fn JsBigInt::add(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a + b

///|
/// JS: a - b
pub extern "js" fn JsBigInt::sub(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a - b

///|
/// JS: a * b
pub extern "js" fn JsBigInt::mul(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a * b

///|
/// JS: a / b
pub extern "js" fn JsBigInt::div(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a / b

///|
/// JS: a % b
pub extern "js" fn JsBigInt::mod(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a % b

///|
/// JS: a ** b
pub extern "js" fn JsBigInt::pow(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a ** b

///|
/// JS: a & b
pub extern "js" fn JsBigInt::bitand(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a & b

///|
/// JS: a | b
pub extern "js" fn JsBigInt::bitor(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a | b

///|
/// JS: a ^ b
pub extern "js" fn JsBigInt::bitxor(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a ^ b

///|
/// JS: a << b
pub extern "js" fn JsBigInt::shl(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a << b

///|
/// JS: a >> b
pub extern "js" fn JsBigInt::shr(a : JsBigInt, b : JsBigInt) -> JsBigInt =
  #|(a, b) => a >> b

///|
/// JS: -a
pub extern "js" fn JsBigInt::neg(a : JsBigInt) -> JsBigInt =
  #|(a) => -a

///|
/// JS: ~a
pub extern "js" fn JsBigInt::bitnot(a : JsBigInt) -> JsBigInt =
  #|(a) => ~a

///|
/// JS: a == b
pub extern "js" fn JsBigInt::equal(a : JsBigInt, b : JsBigInt) -> Bool =
  #|(a, b) => a == b

///|
/// JS: a < b
pub extern "js" fn JsBigInt::lt(a : JsBigInt, b : JsBigInt) -> Bool =
  #|(a, b) => a < b

///|
/// JS: a <= b
pub extern "js" fn JsBigInt::le(a : JsBigInt, b : JsBigInt) -> Bool =
  #|(a, b) => a <= b

///|
/// JS: a > b
pub extern "js" fn JsBigInt::gt(a : JsBigInt, b : JsBigInt) -> Bool =
  #|(a, b) => a > b

///|
/// JS: a >= b
pub extern "js" fn JsBigInt::ge(a : JsBigInt, b : JsBigInt) -> Bool =
  #|(a, b) => a >= b
