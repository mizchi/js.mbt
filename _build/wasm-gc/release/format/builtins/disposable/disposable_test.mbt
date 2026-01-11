///| DisposableStack tests

///|
test "DisposableStack: new and disposed" {
  let stack = @disposable.DisposableStack::new()
  assert_false(stack.disposed())
  stack.dispose()
  assert_true(stack.disposed())
}

///|
test "DisposableStack: defer_ executes on dispose" {
  let stack = @disposable.DisposableStack::new()
  let mut called = false
  stack.defer_(fn() { called = true })
  assert_false(called)
  stack.dispose()
  assert_true(called)
}

///|
test "DisposableStack: defer_ executes in reverse order" {
  let stack = @disposable.DisposableStack::new()
  let order : Array[Int] = []
  stack.defer_(fn() { order.push(1) })
  stack.defer_(fn() { order.push(2) })
  stack.defer_(fn() { order.push(3) })
  stack.dispose()
  // Should execute in reverse order: 3, 2, 1
  assert_eq(order[0], 3)
  assert_eq(order[1], 2)
  assert_eq(order[2], 1)
}

///|
test "DisposableStack: adopt registers custom disposer" {
  let stack = @disposable.DisposableStack::new()
  let mut disposed_value : Int = 0
  let value = stack.adopt(42, fn(v) { disposed_value = v })
  assert_eq(value, 42)
  assert_eq(disposed_value, 0)
  stack.dispose()
  assert_eq(disposed_value, 42)
}

///|
test "DisposableStack: move_ transfers resources" {
  let stack1 = @disposable.DisposableStack::new()
  let mut called = false
  stack1.defer_(fn() { called = true })
  let stack2 = stack1.move_()
  // Original stack is now disposed (but resources not executed)
  assert_true(stack1.disposed())
  assert_false(called)
  // New stack has the resources
  assert_false(stack2.disposed())
  stack2.dispose()
  assert_true(called)
}

///| AsyncDisposableStack tests

///|
async test "AsyncDisposableStack: new and disposed" {
  let stack = @disposable.AsyncDisposableStack::new()
  assert_false(stack.disposed())
  stack.disposeAsync()
  assert_true(stack.disposed())
}

///|
async test "AsyncDisposableStack: defer_ executes on disposeAsync" {
  let stack = @disposable.AsyncDisposableStack::new()
  let mut called = false
  stack.defer_(fn() { called = true })
  assert_false(called)
  stack.disposeAsync()
  assert_true(called)
}

///|
async test "AsyncDisposableStack: defer_ executes in reverse order" {
  let stack = @disposable.AsyncDisposableStack::new()
  let order : Array[Int] = []
  stack.defer_(fn() { order.push(1) })
  stack.defer_(fn() { order.push(2) })
  stack.defer_(fn() { order.push(3) })
  stack.disposeAsync()
  // Should execute in reverse order: 3, 2, 1
  assert_eq(order[0], 3)
  assert_eq(order[1], 2)
  assert_eq(order[2], 1)
}

///|
async test "AsyncDisposableStack: adopt registers custom disposer" {
  let stack = @disposable.AsyncDisposableStack::new()
  let mut disposed_value : Int = 0
  let value = stack.adopt(42, fn(v) { disposed_value = v })
  assert_eq(value, 42)
  assert_eq(disposed_value, 0)
  stack.disposeAsync()
  assert_eq(disposed_value, 42)
}

///|
async test "AsyncDisposableStack: move_ transfers resources" {
  let stack1 = @disposable.AsyncDisposableStack::new()
  let mut called = false
  stack1.defer_(fn() { called = true })
  let stack2 = stack1.move_()
  // Original stack is now disposed (but resources not executed)
  assert_true(stack1.disposed())
  assert_false(called)
  // New stack has the resources
  assert_false(stack2.disposed())
  stack2.disposeAsync()
  assert_true(called)
}
