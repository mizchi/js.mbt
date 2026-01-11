// JavaScript Math object
// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Math

///|
#external
pub type Math

///|
/// JS: Math.random()
pub extern "js" fn Math::random() -> Double =
  #| () => Math.random()

///|
/// JS: Math.floor(x)
pub extern "js" fn Math::floor(x : Double) -> Int =
  #| (x) => Math.floor(x)

///|
/// JS: Math.sin(x)
pub extern "js" fn Math::sin(x : Double) -> Double =
  #| (x) => Math.sin(x)

///|
/// JS: Math.cos(x)
pub extern "js" fn Math::cos(x : Double) -> Double =
  #| (x) => Math.cos(x)

///|
/// JS: Math.exp(x)
pub extern "js" fn Math::exp(x : Double) -> Double =
  #| (x) => Math.exp(x)

///|
/// JS: Math.tanh(x)
pub extern "js" fn Math::tanh(x : Double) -> Double =
  #| (x) => Math.tanh(x)

///|
/// JS: Math.sqrt(x)
pub extern "js" fn Math::sqrt(x : Double) -> Double =
  #| (x) => Math.sqrt(x)

///|
/// JS: Math.pow(base, exp)
pub extern "js" fn Math::pow(base : Double, exp : Double) -> Double =
  #| (base, exp) => Math.pow(base, exp)

///|
/// JS: Math.abs(x)
pub extern "js" fn Math::abs(x : Double) -> Double =
  #| (x) => Math.abs(x)

///|
/// JS: Math.max(...values)
pub extern "js" fn Math::max(values : Array[Double]) -> Double =
  #| (values) => Math.max(...values)

///|
/// JS: Math.min(...values)
pub extern "js" fn Math::min(values : Array[Double]) -> Double =
  #| (values) => Math.min(...values)

///|
/// JS: Math.round(x)
pub extern "js" fn Math::round(x : Double) -> Int =
  #| (x) => Math.round(x)

///|
/// JS: Math.ceil(x)
pub extern "js" fn Math::ceil(x : Double) -> Int =
  #| (x) => Math.ceil(x)

///|
/// JS: Math.log(x)
pub extern "js" fn Math::log(x : Double) -> Double =
  #| (x) => Math.log(x)

///|
/// JS: Math.tan(x)
pub extern "js" fn Math::tan(x : Double) -> Double =
  #| (x) => Math.tan(x)

///|
/// JS: Math.asin(x)
pub extern "js" fn Math::asin(x : Double) -> Double =
  #| (x) => Math.asin(x)

///|
/// JS: Math.acos(x)
pub extern "js" fn Math::acos(x : Double) -> Double =
  #| (x) => Math.acos(x)

///|
/// JS: Math.atan(x)
pub extern "js" fn Math::atan(x : Double) -> Double =
  #| (x) => Math.atan(x)

///|
/// JS: Math.atan2(y, x)
pub extern "js" fn Math::atan2(y : Double, x : Double) -> Double =
  #| (y, x) => Math.atan2(y, x)

///|
/// JS: Math.trunc(x)
pub extern "js" fn Math::trunc(x : Double) -> Double =
  #| (x) => Math.trunc(x)

///| Math Constants

///|
/// JS: Math.E - Euler's number (approximately 2.718)
pub extern "js" fn Math::e() -> Double =
  #| () => Math.E

///|
/// JS: Math.LN2 - Natural logarithm of 2 (approximately 0.693)
pub extern "js" fn Math::ln2() -> Double =
  #| () => Math.LN2

///|
/// JS: Math.LN10 - Natural logarithm of 10 (approximately 2.303)
pub extern "js" fn Math::ln10() -> Double =
  #| () => Math.LN10

///|
/// JS: Math.LOG2E - Base-2 logarithm of E (approximately 1.443)
pub extern "js" fn Math::log2e() -> Double =
  #| () => Math.LOG2E

///|
/// JS: Math.LOG10E - Base-10 logarithm of E (approximately 0.434)
pub extern "js" fn Math::log10e() -> Double =
  #| () => Math.LOG10E

///|
/// JS: Math.PI - Pi (approximately 3.14159)
pub extern "js" fn Math::pi() -> Double =
  #| () => Math.PI

///|
/// JS: Math.SQRT1_2 - Square root of 1/2 (approximately 0.707)
pub extern "js" fn Math::sqrt1_2() -> Double =
  #| () => Math.SQRT1_2

///|
/// JS: Math.SQRT2 - Square root of 2 (approximately 1.414)
pub extern "js" fn Math::sqrt2() -> Double =
  #| () => Math.SQRT2

///| Additional Math Methods

///|
/// JS: Math.sign(x)
pub extern "js" fn Math::sign(x : Double) -> Double =
  #| (x) => Math.sign(x)

///|
/// JS: Math.cbrt(x) - Cube root
pub extern "js" fn Math::cbrt(x : Double) -> Double =
  #| (x) => Math.cbrt(x)

///|
/// JS: Math.fround(x) - Round to nearest 32-bit float
pub extern "js" fn Math::fround(x : Double) -> Double =
  #| (x) => Math.fround(x)

///|
/// JS: Math.sinh(x) - Hyperbolic sine
pub extern "js" fn Math::sinh(x : Double) -> Double =
  #| (x) => Math.sinh(x)

///|
/// JS: Math.cosh(x) - Hyperbolic cosine
pub extern "js" fn Math::cosh(x : Double) -> Double =
  #| (x) => Math.cosh(x)

///|
/// JS: Math.asinh(x) - Inverse hyperbolic sine
pub extern "js" fn Math::asinh(x : Double) -> Double =
  #| (x) => Math.asinh(x)

///|
/// JS: Math.acosh(x) - Inverse hyperbolic cosine
pub extern "js" fn Math::acosh(x : Double) -> Double =
  #| (x) => Math.acosh(x)

///|
/// JS: Math.atanh(x) - Inverse hyperbolic tangent
pub extern "js" fn Math::atanh(x : Double) -> Double =
  #| (x) => Math.atanh(x)

///|
/// JS: Math.log2(x) - Base-2 logarithm
pub extern "js" fn Math::log2(x : Double) -> Double =
  #| (x) => Math.log2(x)

///|
/// JS: Math.log10(x) - Base-10 logarithm
pub extern "js" fn Math::log10(x : Double) -> Double =
  #| (x) => Math.log10(x)

///|
/// JS: Math.log1p(x) - Natural logarithm of 1 + x
pub extern "js" fn Math::log1p(x : Double) -> Double =
  #| (x) => Math.log1p(x)

///|
/// JS: Math.expm1(x) - e^x - 1
pub extern "js" fn Math::expm1(x : Double) -> Double =
  #| (x) => Math.expm1(x)

///|
/// JS: Math.clz32(x) - Count leading zeros in 32-bit binary
pub extern "js" fn Math::clz32(x : Int) -> Int =
  #| (x) => Math.clz32(x)

///|
/// JS: Math.imul(a, b) - 32-bit integer multiplication
pub extern "js" fn Math::imul(a : Int, b : Int) -> Int =
  #| (a, b) => Math.imul(a, b)

///|
/// JS: Math.hypot(...values) - Square root of sum of squares
pub extern "js" fn Math::hypot(values : Array[Double]) -> Double =
  #| (values) => Math.hypot(...values)
