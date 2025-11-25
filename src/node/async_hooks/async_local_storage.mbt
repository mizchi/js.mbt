///|
/// AsyncLocalStorage provides a way to store data throughout the lifetime of a web request
/// or any other asynchronous duration. It is similar to thread-local storage in other languages.
/// https://nodejs.org/api/async_context.html#class-asynclocalstorage

///|
extern "js" fn async_local_storage_constructor() -> @js.Any =
  #| () => require("async_hooks").AsyncLocalStorage

///|
/// AsyncLocalStorage class for managing async context with type safety
#external
pub type AsyncLocalStorage[T]

///|
pub impl[T] @js.JsImpl for AsyncLocalStorage[T]

///|
/// Create a new AsyncLocalStorage instance
pub fn[T] AsyncLocalStorage::new() -> AsyncLocalStorage[T] {
  @js.identity(@js.new_(async_local_storage_constructor(), []))
}

///|
/// Run a function synchronously within a context
/// https://nodejs.org/api/async_context.html#asynclocalstoragerunstore-callback-args
pub fn[T : @js.JsImpl] AsyncLocalStorage::run(
  self : AsyncLocalStorage[T],
  store : T,
  callback : () -> Unit,
) -> Unit {
  self.call2("run", store, callback |> @js.from_fn0) |> @js.identity
}

///|
/// Run a function synchronously outside of a context
/// https://nodejs.org/api/async_context.html#asynclocalstorageexitcallback-args
pub fn[T] AsyncLocalStorage::exit(
  self : AsyncLocalStorage[T],
  callback : () -> Unit,
) -> Unit {
  self.call("exit", [callback |> @js.from_fn0]).cast()
}

///|
/// Returns the current store. If called outside of an asynchronous context, it returns undefined.
/// https://nodejs.org/api/async_context.html#asynclocalstoragegetstore
pub fn[T] AsyncLocalStorage::getStore(self : AsyncLocalStorage[T]) -> T? {
  self.call0("getStore") |> @js.identity_option()
}

///|
/// Transitions into the context for the remainder of the current synchronous execution
/// https://nodejs.org/api/async_context.html#asynclocalstoragenterwithstore
pub fn[T : @js.JsImpl] AsyncLocalStorage::enterWith(
  self : AsyncLocalStorage[T],
  store : T,
) -> Unit {
  self.call("enterWith", [store]).cast()
}

///|
/// Disables the instance of AsyncLocalStorage
/// https://nodejs.org/api/async_context.html#asynclocalstoragedisable
pub fn[T] AsyncLocalStorage::disable(self : AsyncLocalStorage[T]) -> Unit {
  self.call0("disable") |> @js.identity
}
