///|
test "JsIterator::drop" {
  let arr = @core.any([1, 2, 3, 4, 5])
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr)
  let dropped = iter.drop(2)
  let result = dropped.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="3")
  inspect(result[1], content="4")
  inspect(result[2], content="5")
}

///|
test "JsIterator::take" {
  let arr = @core.any([1, 2, 3, 4, 5])
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr)
  let taken = iter.take(3)
  let result = taken.toArray()
  inspect(result.length(), content="3")
  inspect(result[0], content="1")
  inspect(result[1], content="2")
  inspect(result[2], content="3")
}

///|
test "JsIterator::drop and take combined" {
  let arr = @core.any([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
  let iter : @js.JsIterator[Int] = @js.JsIterator::from(arr)
  let result = iter.drop(2).take(5).toArray()
  inspect(result.length(), content="5")
  inspect(result[0], content="2")
  inspect(result[4], content="6")
}

///|
test "ThrowError Show trait" {
  let result = try? throwable(fn() {
    @core.global_this()._call("nonexistentMethod", [])
  })
  match result {
    Err(throw_err) => {
      let str = throw_err.to_string()
      assert_true(str.length() > 0)
    }
    Ok(_) => fail("Expected error")
  }
}
