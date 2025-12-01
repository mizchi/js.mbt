///|
/// JavaScript BigInt

///|
#external
pub type JsBigInt

///|
/// Note: Keep JsImpl for backward compatibility with code expecting &JsImpl
pub impl @js.JsImpl for JsBigInt

///|
pub fn JsBigInt::as_any(self : JsBigInt) -> @nostd.Any = "%identity"

///|
/// JS: BigInt(value)
pub extern "js" fn JsBigInt::from_int(value : Int) -> JsBigInt =
  #|(value) => BigInt(value)

///|
/// JS: BigInt(value)
pub extern "js" fn JsBigInt::from_string(value : String) -> JsBigInt =
  #|(value) => BigInt(value)

///|
/// JS: BigInt.asIntN(bits, bigint)
pub extern "js" fn JsBigInt::asIntN(bits : Int, bigint : JsBigInt) -> JsBigInt =
  #|(bits, bigint) => BigInt.asIntN(bits, bigint)

///|
/// JS: BigInt.asUintN(bits, bigint)
pub extern "js" fn JsBigInt::asUintN(bits : Int, bigint : JsBigInt) -> JsBigInt =
  #|(bits, bigint) => BigInt.asUintN(bits, bigint)

///|
/// JS: bigint.toString()
pub extern "js" fn JsBigInt::to_string(self : JsBigInt) -> String =
  #|(self) => self.toString()

///|
/// JS: bigint.toString(radix)
pub extern "js" fn JsBigInt::to_string_radix(
  self : JsBigInt,
  radix : Int,
) -> String =
  #|(self, radix) => self.toString(radix)

///|
/// JS: bigint.valueOf()
pub extern "js" fn JsBigInt::valueOf(self : JsBigInt) -> JsBigInt =
  #|(self) => self.valueOf()

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
