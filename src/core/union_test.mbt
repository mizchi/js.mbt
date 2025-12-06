///| Test Union types

///| Union2 tests

///|
test "Union2::from and to_any" {
  let value : @core.Any = @core.any(42)
  let union : Union2[Int, String] = Union2::from(value)
  let back : @core.Any = union.to_any()
  let result : Int = @core.identity(back)
  inspect(result, content="42")
}

///|
test "Union2::to0 converts to first type" {
  let value : @core.Any = @core.any(100)
  let union : Union2[Int, String] = Union2::from(value)
  let result : Int = union.to0()
  inspect(result, content="100")
}

///|
test "Union2::to1 converts to second type" {
  let value : @core.Any = @core.any("hello")
  let union : Union2[Int, String] = Union2::from(value)
  let result : String = union.to1()
  inspect(result, content="hello")
}

///| Union3 tests

///|
test "Union3::from and to_any" {
  let value : @core.Any = @core.any(42)
  let union : Union3[Int, String, Bool] = Union3::from(value)
  let back : @core.Any = union.to_any()
  let result : Int = @core.identity(back)
  inspect(result, content="42")
}

///|
test "Union3::to0 converts to first type" {
  let value : @core.Any = @core.any(100)
  let union : Union3[Int, String, Bool] = Union3::from(value)
  let result : Int = union.to0()
  inspect(result, content="100")
}

///|
test "Union3::to1 converts to second type" {
  let value : @core.Any = @core.any("world")
  let union : Union3[Int, String, Bool] = Union3::from(value)
  let result : String = union.to1()
  inspect(result, content="world")
}

///|
test "Union3::to2 converts to third type" {
  let value : @core.Any = @core.any(true)
  let union : Union3[Int, String, Bool] = Union3::from(value)
  let result : Bool = union.to2()
  inspect(result, content="true")
}

///| Union4 tests

///|
test "Union4::from and to_any" {
  let value : @core.Any = @core.any(42)
  let union : Union4[Int, String, Bool, Double] = Union4::from(value)
  let back : @core.Any = union.to_any()
  let result : Int = @core.identity(back)
  inspect(result, content="42")
}

///|
test "Union4::to0 converts to first type" {
  let value : @core.Any = @core.any(200)
  let union : Union4[Int, String, Bool, Double] = Union4::from(value)
  let result : Int = union.to0()
  inspect(result, content="200")
}

///|
test "Union4::to1 converts to second type" {
  let value : @core.Any = @core.any("test")
  let union : Union4[Int, String, Bool, Double] = Union4::from(value)
  let result : String = union.to1()
  inspect(result, content="test")
}

///|
test "Union4::to2 converts to third type" {
  let value : @core.Any = @core.any(false)
  let union : Union4[Int, String, Bool, Double] = Union4::from(value)
  let result : Bool = union.to2()
  inspect(result, content="false")
}

///|
test "Union4::to3 converts to fourth type" {
  let value : @core.Any = @core.any(3.14)
  let union : Union4[Int, String, Bool, Double] = Union4::from(value)
  let result : Double = union.to3()
  inspect(result, content="3.14")
}

///| Union5 tests

///|
test "Union5::from and to_any" {
  let value : @core.Any = @core.any(42)
  let union : Union5[Int, String, Bool, Double, Array[Int]] = Union5::from(
    value,
  )
  let back : @core.Any = union.to_any()
  let result : Int = @core.identity(back)
  inspect(result, content="42")
}

///|
test "Union5::to0 converts to first type" {
  let value : @core.Any = @core.any(300)
  let union : Union5[Int, String, Bool, Double, Array[Int]] = Union5::from(
    value,
  )
  let result : Int = union.to0()
  inspect(result, content="300")
}

///|
test "Union5::to1 converts to second type" {
  let value : @core.Any = @core.any("union5")
  let union : Union5[Int, String, Bool, Double, Array[Int]] = Union5::from(
    value,
  )
  let result : String = union.to1()
  inspect(result, content="union5")
}

///|
test "Union5::to2 converts to third type" {
  let value : @core.Any = @core.any(true)
  let union : Union5[Int, String, Bool, Double, Array[Int]] = Union5::from(
    value,
  )
  let result : Bool = union.to2()
  inspect(result, content="true")
}

///|
test "Union5::to3 converts to fourth type" {
  let value : @core.Any = @core.any(2.718)
  let union : Union5[Int, String, Bool, Double, Array[Int]] = Union5::from(
    value,
  )
  let result : Double = union.to3()
  inspect(result, content="2.718")
}

///|
test "Union5::to4 converts to fifth type" {
  let arr = [1, 2, 3]
  let value : @core.Any = @core.any(arr)
  let union : Union5[Int, String, Bool, Double, Array[Int]] = Union5::from(
    value,
  )
  let result : Array[Int] = union.to4()
  inspect(result.length(), content="3")
}
