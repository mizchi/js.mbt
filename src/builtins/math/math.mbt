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
