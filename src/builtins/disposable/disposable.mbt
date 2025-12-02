///|
/// DisposableStack - Synchronous resource management
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DisposableStack
#external
pub type DisposableStack

///|
pub fn DisposableStack::to_any(self : DisposableStack) -> @core.Any = "%identity"

///|
extern "js" fn ffi_new_disposable_stack() -> DisposableStack =
  #| () => new DisposableStack()

///|
/// Create a new DisposableStack
pub fn DisposableStack::new() -> DisposableStack {
  ffi_new_disposable_stack()
}

///|
/// Check if the stack has been disposed
/// JS: stack.disposed
pub fn DisposableStack::disposed(self : DisposableStack) -> Bool {
  self.to_any()["disposed"].cast()
}

///|
/// Register a value implementing the disposable protocol
/// JS: stack.use(value)
pub fn[T] DisposableStack::use_(self : DisposableStack, value : T) -> T {
  self.to_any()._call("use", [@core.any(value)]).cast()
}

///|
/// Register a value with a custom disposal function
/// JS: stack.adopt(value, disposer)
pub fn[T] DisposableStack::adopt(
  self : DisposableStack,
  value : T,
  disposer : (T) -> Unit,
) -> T {
  self
  .to_any()
  ._call("adopt", [@core.any(value), @core.any(@core.from_fn1(disposer))])
  .cast()
}

///|
/// Register a callback to execute when the stack is disposed
/// JS: stack.defer(callback)
pub fn DisposableStack::defer_(
  self : DisposableStack,
  callback : () -> Unit,
) -> Unit {
  self.to_any()._call("defer", [@core.any(@core.from_fn0(callback))]) |> ignore
}

///|
/// Dispose all registered resources in reverse order
/// JS: stack.dispose()
pub fn DisposableStack::dispose(self : DisposableStack) -> Unit {
  self.to_any()._call("dispose", []) |> ignore
}

///|
/// Move all resources to a new DisposableStack
/// JS: stack.move()
pub fn DisposableStack::move_(self : DisposableStack) -> DisposableStack {
  self.to_any()._call("move", []).cast()
}

///|
/// AsyncDisposableStack - Asynchronous resource management
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AsyncDisposableStack
#external
pub type AsyncDisposableStack

///|
pub fn AsyncDisposableStack::to_any(self : AsyncDisposableStack) -> @core.Any = "%identity"

///|
extern "js" fn ffi_new_async_disposable_stack() -> AsyncDisposableStack =
  #| () => new AsyncDisposableStack()

///|
/// Create a new AsyncDisposableStack
pub fn AsyncDisposableStack::new() -> AsyncDisposableStack {
  ffi_new_async_disposable_stack()
}

///|
/// Check if the stack has been disposed
/// JS: stack.disposed
pub fn AsyncDisposableStack::disposed(self : AsyncDisposableStack) -> Bool {
  self.to_any()["disposed"].cast()
}

///|
/// Register a value implementing the async disposable protocol
/// JS: stack.use(value)
pub fn[T] AsyncDisposableStack::use_(
  self : AsyncDisposableStack,
  value : T,
) -> T {
  self.to_any()._call("use", [@core.any(value)]).cast()
}

///|
/// Register a value with a custom async disposal function
/// JS: stack.adopt(value, disposer)
pub fn[T] AsyncDisposableStack::adopt(
  self : AsyncDisposableStack,
  value : T,
  disposer : (T) -> Unit,
) -> T {
  self
  .to_any()
  ._call("adopt", [@core.any(value), @core.any(@core.from_fn1(disposer))])
  .cast()
}

///|
/// Register a callback to execute when the stack is disposed
/// JS: stack.defer(callback)
pub fn AsyncDisposableStack::defer_(
  self : AsyncDisposableStack,
  callback : () -> Unit,
) -> Unit {
  self.to_any()._call("defer", [@core.any(@core.from_fn0(callback))]) |> ignore
}

///|
/// Dispose all registered resources in reverse order (async)
/// JS: await stack.disposeAsync()
pub async fn AsyncDisposableStack::disposeAsync(
  self : AsyncDisposableStack,
) -> Unit {
  let promise : @core.Promise[Unit] = self
    .to_any()
    ._call("disposeAsync", [])
    .cast()
  promise.wait()
}

///|
/// Move all resources to a new AsyncDisposableStack
/// JS: stack.move()
pub fn AsyncDisposableStack::move_(
  self : AsyncDisposableStack,
) -> AsyncDisposableStack {
  self.to_any()._call("move", []).cast()
}
