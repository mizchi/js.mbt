// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Math/trunc

///|
/// JS: Math.random()
pub extern "js" fn random() -> Double =
  #| () => Math.random()

///|
/// JS: Math.floor(x)
pub extern "js" fn floor(x : Double) -> Int =
  #| (x) => Math.floor(x)

///|
/// JS: Math.sin(max)
pub extern "js" fn sin(max : Double) -> Double =
  #| (max) => Math.sin(max)

///|
/// JS: Math.cos(max)
pub extern "js" fn cos(max : Double) -> Double =
  #| (max) => Math.cos(max)

///|
/// JS: Math.exp(x)
pub extern "js" fn exp(x : Double) -> Double =
  #| (x) => Math.exp(x)

///|
/// JS: Math.tanh(x)
pub extern "js" fn tanh(x : Double) -> Double =
  #| (x) => Math.tanh(x)

///|
/// JS: Math.sqrt(max)
pub extern "js" fn sqrt(max : Double) -> Double =
  #| (max) => Math.sqrt(max)

///|
/// JS: Math.pow(base, exp)
pub extern "js" fn pow(base : Double, exp : Double) -> Double =
  #| (base, exp) => Math.pow(base, exp)

///|
/// JS: Math.abs(x)
pub extern "js" fn abs(x : Double) -> Double =
  #| (x) => Math.abs(x)

///|
/// JS: Math.max(a, b)
pub extern "js" fn max(values : Array[Double]) -> Double =
  #| (values) => Math.max(...values)

///|
/// JS: Math.min(...values)
pub extern "js" fn min(values : Array[Double]) -> Double =
  #| (values) => Math.min(...values)

///|
/// JS: Math.round(x)
pub extern "js" fn round(x : Double) -> Int =
  #| (x) => Math.round(x)

///|
/// JS: Math.ceil(x)
pub extern "js" fn ceil(x : Double) -> Int =
  #| (x) => Math.ceil(x)

///|
/// JS: Math.log(x)
pub extern "js" fn log(x : Double) -> Double =
  #| (x) => Math.log(x)

///|
/// JS: Math.tan(x)
pub extern "js" fn tan(x : Double) -> Double =
  #| (x) => Math.tan(x)

///|
/// JS: Math.asin(x)
pub extern "js" fn asin(x : Double) -> Double =
  #| (x) => Math.asin(x)

///|
/// JS: Math.acos(x)
pub extern "js" fn acos(x : Double) -> Double =
  #| (x) => Math.acos(x)
  #|

///|
/// JS: Math.atan(x)
pub extern "js" fn atan(x : Double) -> Double =
  #| (x) => Math.atan(x)

///|
/// JS: Math.atan2(y, x)
pub extern "js" fn atan2(y : Double, x : Double) -> Double =
  #| (y, x) => Math.atan2(y, x)

///|
/// JS: Math.trunc(x)
pub extern "js" fn trunc(x : Double) -> Double =
  #| (x) => Math.trunc(x);
