///| Math tests

///|
test "Math::random returns value between 0 and 1" {
  let r = Math::random()
  assert_true(r >= 0.0)
  assert_true(r < 1.0)
}

///|
test "Math::floor rounds down" {
  assert_eq(Math::floor(4.7), 4)
  assert_eq(Math::floor(4.2), 4)
  assert_eq(Math::floor(-4.2), -5)
}

///|
test "Math::ceil rounds up" {
  assert_eq(Math::ceil(4.2), 5)
  assert_eq(Math::ceil(4.7), 5)
  assert_eq(Math::ceil(-4.7), -4)
}

///|
test "Math::round rounds to nearest integer" {
  assert_eq(Math::round(4.5), 5)
  assert_eq(Math::round(4.4), 4)
  assert_eq(Math::round(-4.5), -4)
}

///|
test "Math::abs returns absolute value" {
  assert_eq(Math::abs(5.0), 5.0)
  assert_eq(Math::abs(-5.0), 5.0)
  assert_eq(Math::abs(0.0), 0.0)
}

///|
test "Math::sqrt calculates square root" {
  assert_eq(Math::sqrt(9.0), 3.0)
  assert_eq(Math::sqrt(16.0), 4.0)
  assert_eq(Math::sqrt(2.0), 1.4142135623730951)
}

///|
test "Math::pow calculates power" {
  assert_eq(Math::pow(2.0, 3.0), 8.0)
  assert_eq(Math::pow(5.0, 2.0), 25.0)
  assert_eq(Math::pow(2.0, 0.0), 1.0)
}

///|
test "Math::max returns maximum value" {
  assert_eq(Math::max([1.0, 5.0, 3.0]), 5.0)
  assert_eq(Math::max([10.0, -5.0, 20.0]), 20.0)
}

///|
test "Math::min returns minimum value" {
  assert_eq(Math::min([1.0, 5.0, 3.0]), 1.0)
  assert_eq(Math::min([10.0, -5.0, 20.0]), -5.0)
}

///|
test "Math::sin calculates sine" {
  assert_eq(Math::sin(0.0), 0.0)
  let result = Math::sin(3.141592653589793 / 2.0) // π/2
  assert_true(result > 0.999 && result < 1.001)
}

///|
test "Math::cos calculates cosine" {
  assert_eq(Math::cos(0.0), 1.0)
  let result = Math::cos(3.141592653589793) // π
  assert_true(result > -1.001 && result < -0.999)
}

///|
test "Math::tan calculates tangent" {
  assert_eq(Math::tan(0.0), 0.0)
  let result = Math::tan(3.141592653589793 / 4.0) // π/4
  assert_true(result > 0.999 && result < 1.001)
}

///|
test "Math::asin calculates arcsine" {
  assert_eq(Math::asin(0.0), 0.0)
  let result = Math::asin(1.0)
  assert_true(result > 1.57 && result < 1.58) // ≈ π/2
}

///|
test "Math::acos calculates arccosine" {
  let result = Math::acos(1.0)
  assert_eq(result, 0.0)
  let result2 = Math::acos(0.0)
  assert_true(result2 > 1.57 && result2 < 1.58) // ≈ π/2
}

///|
test "Math::atan calculates arctangent" {
  assert_eq(Math::atan(0.0), 0.0)
  let result = Math::atan(1.0)
  assert_true(result > 0.78 && result < 0.79) // ≈ π/4
}

///|
test "Math::atan2 calculates arctangent of quotient" {
  assert_eq(Math::atan2(0.0, 1.0), 0.0)
  let result = Math::atan2(1.0, 1.0)
  assert_true(result > 0.78 && result < 0.79) // ≈ π/4
}

///|
test "Math::exp calculates exponential" {
  assert_eq(Math::exp(0.0), 1.0)
  let result = Math::exp(1.0) // e
  assert_true(result > 2.71 && result < 2.72)
}

///|
test "Math::log calculates natural logarithm" {
  assert_eq(Math::log(1.0), 0.0)
  let e = 2.718281828459045
  let result = Math::log(e)
  assert_true(result > 0.999 && result < 1.001)
}

///|
test "Math::tanh calculates hyperbolic tangent" {
  assert_eq(Math::tanh(0.0), 0.0)
  let result = Math::tanh(1.0)
  assert_true(result > 0.76 && result < 0.77)
}

///|
test "Math::trunc truncates decimal part" {
  assert_eq(Math::trunc(4.9), 4.0)
  assert_eq(Math::trunc(4.1), 4.0)
  assert_eq(Math::trunc(-4.9), -4.0)
  assert_eq(Math::trunc(-4.1), -4.0)
}

///| Math Constants Tests

///|
test "Math::e returns Euler's number" {
  let e = Math::e()
  assert_true(e > 2.71 && e < 2.72)
}

///|
test "Math::pi returns Pi" {
  let pi = Math::pi()
  assert_true(pi > 3.14 && pi < 3.15)
}

///|
test "Math::ln2 returns natural log of 2" {
  let ln2 = Math::ln2()
  assert_true(ln2 > 0.69 && ln2 < 0.70)
}

///|
test "Math::ln10 returns natural log of 10" {
  let ln10 = Math::ln10()
  assert_true(ln10 > 2.30 && ln10 < 2.31)
}

///|
test "Math::log2e returns base-2 log of E" {
  let log2e = Math::log2e()
  assert_true(log2e > 1.44 && log2e < 1.45)
}

///|
test "Math::log10e returns base-10 log of E" {
  let log10e = Math::log10e()
  assert_true(log10e > 0.43 && log10e < 0.44)
}

///|
test "Math::sqrt1_2 returns square root of 0.5" {
  let sqrt1_2 = Math::sqrt1_2()
  assert_true(sqrt1_2 > 0.70 && sqrt1_2 < 0.71)
}

///|
test "Math::sqrt2 returns square root of 2" {
  let sqrt2 = Math::sqrt2()
  assert_true(sqrt2 > 1.41 && sqrt2 < 1.42)
}

///| Additional Math Methods Tests

///|
test "Math::sign returns sign of number" {
  assert_eq(Math::sign(5.0), 1.0)
  assert_eq(Math::sign(-5.0), -1.0)
  assert_eq(Math::sign(0.0), 0.0)
}

///|
test "Math::cbrt calculates cube root" {
  assert_eq(Math::cbrt(8.0), 2.0)
  assert_eq(Math::cbrt(27.0), 3.0)
  assert_eq(Math::cbrt(-8.0), -2.0)
}

///|
test "Math::fround rounds to 32-bit float" {
  let result = Math::fround(1.337)
  assert_true(result > 1.33 && result < 1.34)
}

///|
test "Math::sinh calculates hyperbolic sine" {
  assert_eq(Math::sinh(0.0), 0.0)
  let result = Math::sinh(1.0)
  assert_true(result > 1.17 && result < 1.18)
}

///|
test "Math::cosh calculates hyperbolic cosine" {
  assert_eq(Math::cosh(0.0), 1.0)
  let result = Math::cosh(1.0)
  assert_true(result > 1.54 && result < 1.55)
}

///|
test "Math::asinh calculates inverse hyperbolic sine" {
  assert_eq(Math::asinh(0.0), 0.0)
  let result = Math::asinh(1.0)
  assert_true(result > 0.88 && result < 0.89)
}

///|
test "Math::acosh calculates inverse hyperbolic cosine" {
  assert_eq(Math::acosh(1.0), 0.0)
  let result = Math::acosh(2.0)
  assert_true(result > 1.31 && result < 1.32)
}

///|
test "Math::atanh calculates inverse hyperbolic tangent" {
  assert_eq(Math::atanh(0.0), 0.0)
  let result = Math::atanh(0.5)
  assert_true(result > 0.54 && result < 0.55)
}

///|
test "Math::log2 calculates base-2 logarithm" {
  assert_eq(Math::log2(1.0), 0.0)
  assert_eq(Math::log2(2.0), 1.0)
  assert_eq(Math::log2(8.0), 3.0)
}

///|
test "Math::log10 calculates base-10 logarithm" {
  assert_eq(Math::log10(1.0), 0.0)
  assert_eq(Math::log10(10.0), 1.0)
  assert_eq(Math::log10(100.0), 2.0)
}

///|
test "Math::log1p calculates log(1 + x)" {
  assert_eq(Math::log1p(0.0), 0.0)
  let e = 2.718281828459045
  let result = Math::log1p(e - 1.0)
  assert_true(result > 0.99 && result < 1.01)
}

///|
test "Math::expm1 calculates e^x - 1" {
  assert_eq(Math::expm1(0.0), 0.0)
  let result = Math::expm1(1.0)
  assert_true(result > 1.71 && result < 1.72)
}

///|
test "Math::clz32 counts leading zeros" {
  assert_eq(Math::clz32(1), 31)
  assert_eq(Math::clz32(4), 29)
  assert_eq(Math::clz32(1000), 22)
}

///|
test "Math::imul performs 32-bit integer multiplication" {
  assert_eq(Math::imul(2, 3), 6)
  assert_eq(Math::imul(10, 12), 120)
  assert_eq(Math::imul(-5, 12), -60)
}

///|
test "Math::hypot calculates hypotenuse" {
  assert_eq(Math::hypot([3.0, 4.0]), 5.0)
  assert_eq(Math::hypot([5.0, 12.0]), 13.0)
  let result = Math::hypot([1.0, 1.0])
  assert_true(result > 1.41 && result < 1.42)
}
