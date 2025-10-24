// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Math/trunc

///|
#external
pub type Math

///|
pub extern "js" fn Math::random() -> Double =
  #| () => Math.random()

///|
pub extern "js" fn Math::floor(x : Double) -> Int =
  #| (x) => Math.floor(x)

///|
pub extern "js" fn Math::sin(max : Double) -> Double =
  #| (max) => Math.sin(max)

///|
pub extern "js" fn Math::cos(max : Double) -> Double =
  #| (max) => Math.cos(max)

///|
pub extern "js" fn Math::exp(x : Double) -> Double =
  #| (x) => Math.exp(x)

///|
pub extern "js" fn Math::tanh(x : Double) -> Double =
  #| (x) => Math.tanh(x)

///|
pub extern "js" fn Math::sqrt(max : Double) -> Double =
  #| (max) => Math.sqrt(max)

///|
pub extern "js" fn Math::pow(base : Double, exp : Double) -> Double =
  #| (base, exp) => Math.pow(base, exp)

///|
pub extern "js" fn Math::abs(x : Double) -> Double =
  #| (x) => Math.abs(x)

///|
pub extern "js" fn Math::max(a : Double, b : Double) -> Double =
  #| (a, b) => Math.max(a, b)

///|
pub extern "js" fn Math::min(a : Double, b : Double) -> Double =
  #| (a, b) => Math.min(a, b)

///|
pub extern "js" fn Math::round(x : Double) -> Int =
  #| (x) => Math.round(x)

///|
pub extern "js" fn Math::ceil(x : Double) -> Int =
  #| (x) => Math.ceil(x)

///|
pub extern "js" fn Math::log(x : Double) -> Double =
  #| (x) => Math.log(x)

///|
pub extern "js" fn Math::tan(x : Double) -> Double =
  #| (x) => Math.tan(x)

///|
pub extern "js" fn Math::asin(x : Double) -> Double =
  #| (x) => Math.asin(x)

///|
pub extern "js" fn Math::acos(x : Double) -> Double =
  #| (x) => Math.acos(x)
  #|

///|
pub extern "js" fn Math::atan(x : Double) -> Double =
  #| (x) => Math.atan(x)

///|
pub extern "js" fn Math::atan2(y : Double, x : Double) -> Double =
  #| (y, x) => Math.atan2(y, x)

///|
pub extern "js" fn Math::trunc(x : Double) -> Double =
  #| (x) => Math.trunc(x);
