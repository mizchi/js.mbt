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
