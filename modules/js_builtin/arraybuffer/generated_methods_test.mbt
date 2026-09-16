///| Test auto-generated TypedArray inheritance methods
/// These tests verify that TypedArray methods can be called directly
/// on concrete types like Uint8Array without casting to TypedArray first.

///|
test "Uint8Array can call inherited methods directly" {
  let arr = Uint8Array::from_array([1, 2, 3, 4, 5])

  // length メソッドをキャストなしで呼べる
  inspect(arr.length(), content="5")

  // byteLength メソッド
  inspect(arr.byteLength(), content="5")

  // byteOffset メソッド
  inspect(arr.byteOffset(), content="0")

  // indexOf メソッド
  inspect(arr.indexOf(3), content="2")

  // join メソッド
  inspect(arr.join(separator="-"), content="1-2-3-4-5")

  // includes メソッド
  inspect(arr.includes(3), content="true")
  inspect(arr.includes(10), content="false")
}

///|
test "Int32Array can call inherited methods directly" {
  let arr = @arraybuffer.Int32Array::{
    buffer: @arraybuffer.ArrayBuffer::new(20),
    byteLength: 20,
    byteOffset: 0,
    length: 5,
  }

  // length メソッド
  inspect(arr.length(), content="5")

  // byteLength メソッド
  inspect(arr.byteLength(), content="20")
}

///|
test "Float64Array can call inherited methods directly" {
  let arr = @arraybuffer.Float64Array::{
    buffer: @arraybuffer.ArrayBuffer::new(40),
    byteLength: 40,
    byteOffset: 0,
    length: 5,
  }

  // length メソッド
  inspect(arr.length(), content="5")

  // byteLength メソッド
  inspect(arr.byteLength(), content="40")
}
