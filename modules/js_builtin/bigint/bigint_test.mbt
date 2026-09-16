///|
test "JsBigInt::from_int" {
  let big = JsBigInt::from_int(42)
  assert_eq(@core.typeof_(big |> @core.any), "bigint")
  assert_eq(big.to_string(), "42")
}

///|
test "JsBigInt::from_string" {
  let big = JsBigInt::from_string("123456789012345678901234567890")
  assert_eq(@core.typeof_(big |> @core.any), "bigint")
  assert_eq(big.to_string(), "123456789012345678901234567890")
}

///|
test "JsBigInt::add" {
  let a = JsBigInt::from_int(100)
  let b = JsBigInt::from_int(200)
  let result = JsBigInt::add(a, b)
  assert_eq(result.to_string(), "300")
}

///|
test "JsBigInt::sub" {
  let a = JsBigInt::from_int(500)
  let b = JsBigInt::from_int(300)
  let result = JsBigInt::sub(a, b)
  assert_eq(result.to_string(), "200")
}

///|
test "JsBigInt::mul" {
  let a = JsBigInt::from_int(123)
  let b = JsBigInt::from_int(456)
  let result = JsBigInt::mul(a, b)
  assert_eq(result.to_string(), "56088")
}

///|
test "JsBigInt::div" {
  let a = JsBigInt::from_int(100)
  let b = JsBigInt::from_int(3)
  let result = JsBigInt::div(a, b)
  assert_eq(result.to_string(), "33")
}

///|
test "JsBigInt::mod" {
  let a = JsBigInt::from_int(100)
  let b = JsBigInt::from_int(3)
  let result = JsBigInt::mod(a, b)
  assert_eq(result.to_string(), "1")
}

///|
test "JsBigInt::pow" {
  let a = JsBigInt::from_int(2)
  let b = JsBigInt::from_int(10)
  let result = JsBigInt::pow(a, b)
  assert_eq(result.to_string(), "1024")
}

///|
test "JsBigInt::neg" {
  let a = JsBigInt::from_int(42)
  let result = JsBigInt::neg(a)
  assert_eq(result.to_string(), "-42")
}

///|
test "JsBigInt::bitand" {
  let a = JsBigInt::from_int(12) // 1100
  let b = JsBigInt::from_int(10) // 1010
  let result = JsBigInt::bitand(a, b)
  assert_eq(result.to_string(), "8") // 1000
}

///|
test "JsBigInt::bitor" {
  let a = JsBigInt::from_int(12) // 1100
  let b = JsBigInt::from_int(10) // 1010
  let result = JsBigInt::bitor(a, b)
  assert_eq(result.to_string(), "14") // 1110
}

///|
test "JsBigInt::bitxor" {
  let a = JsBigInt::from_int(12) // 1100
  let b = JsBigInt::from_int(10) // 1010
  let result = JsBigInt::bitxor(a, b)
  assert_eq(result.to_string(), "6") // 0110
}

///|
test "JsBigInt::bitnot" {
  let a = JsBigInt::from_int(5)
  let result = JsBigInt::bitnot(a)
  assert_eq(result.to_string(), "-6")
}

///|
test "JsBigInt::shl" {
  let a = JsBigInt::from_int(5)
  let b = JsBigInt::from_int(2)
  let result = JsBigInt::shl(a, b)
  assert_eq(result.to_string(), "20")
}

///|
test "JsBigInt::shr" {
  let a = JsBigInt::from_int(20)
  let b = JsBigInt::from_int(2)
  let result = JsBigInt::shr(a, b)
  assert_eq(result.to_string(), "5")
}

///|
test "JsBigInt::equal" {
  let a = JsBigInt::from_int(42)
  let b = JsBigInt::from_int(42)
  let c = JsBigInt::from_int(43)
  assert_true(JsBigInt::equal(a, b))
  assert_false(JsBigInt::equal(a, c))
}

///|
test "JsBigInt::lt" {
  let a = JsBigInt::from_int(10)
  let b = JsBigInt::from_int(20)
  assert_true(JsBigInt::lt(a, b))
  assert_false(JsBigInt::lt(b, a))
  assert_false(JsBigInt::lt(a, a))
}

///|
test "JsBigInt::le" {
  let a = JsBigInt::from_int(10)
  let b = JsBigInt::from_int(20)
  assert_true(JsBigInt::le(a, b))
  assert_true(JsBigInt::le(a, a))
  assert_false(JsBigInt::le(b, a))
}

///|
test "JsBigInt::gt" {
  let a = JsBigInt::from_int(20)
  let b = JsBigInt::from_int(10)
  assert_true(JsBigInt::gt(a, b))
  assert_false(JsBigInt::gt(b, a))
  assert_false(JsBigInt::gt(a, a))
}

///|
test "JsBigInt::ge" {
  let a = JsBigInt::from_int(20)
  let b = JsBigInt::from_int(10)
  assert_true(JsBigInt::ge(a, b))
  assert_true(JsBigInt::ge(a, a))
  assert_false(JsBigInt::ge(b, a))
}

///|
test "JsBigInt::to_string_radix" {
  let big = JsBigInt::from_int(255)
  assert_eq(big.to_string_radix(16), "ff")
  assert_eq(big.to_string_radix(2), "11111111")
  assert_eq(big.to_string_radix(8), "377")
}

///|
test "JsBigInt::asIntN" {
  let big = JsBigInt::from_int(255)
  let result = JsBigInt::asIntN(8, big)
  assert_eq(result.to_string(), "-1")
}

///|
test "JsBigInt::asUintN" {
  let big = JsBigInt::from_int(255)
  let result = JsBigInt::asUintN(8, big)
  assert_eq(result.to_string(), "255")
}

///|
test "JsBigInt::valueOf" {
  let big = JsBigInt::from_int(42)
  let value = big.valueOf()
  assert_eq(value.to_string(), "42")
}

///|
test "JsBigInt large numbers" {
  let a = JsBigInt::from_string("12345678901234567890")
  let b = JsBigInt::from_string("98765432109876543210")
  let result = JsBigInt::add(a, b)
  assert_eq(result.to_string(), "111111111011111111100")
}
