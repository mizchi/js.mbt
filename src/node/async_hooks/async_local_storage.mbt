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
pub fn[T] AsyncLocalStorage::as_any(self : AsyncLocalStorage[T]) -> @nostd.Any = "%identity"

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
  self
  .as_any()
  ._call("run", [
    @nostd.any(store.as_any()),
    @nostd.any(callback |> @js.from_fn0),
  ])
  |> ignore
}

///|
/// Run a function synchronously outside of a context
/// https://nodejs.org/api/async_context.html#asynclocalstorageexitcallback-args
pub fn[T] AsyncLocalStorage::exit(
  self : AsyncLocalStorage[T],
  callback : () -> Unit,
) -> Unit {
  self.as_any()._call("exit", [@nostd.any(callback |> @js.from_fn0)]) |> ignore
}

///|
/// Returns the current store. If called outside of an asynchronous context, it returns undefined.
/// https://nodejs.org/api/async_context.html#asynclocalstoragegetstore
pub fn[T] AsyncLocalStorage::getStore(self : AsyncLocalStorage[T]) -> T? {
  self.as_any()._call("getStore", []) |> @nostd.identity_option()
}

///|
/// Transitions into the context for the remainder of the current synchronous execution
/// https://nodejs.org/api/async_context.html#asynclocalstoragenterwithstore
pub fn[T : @js.JsImpl] AsyncLocalStorage::enterWith(
  self : AsyncLocalStorage[T],
  store : T,
) -> Unit {
  self.as_any()._call("enterWith", [@nostd.any(store.as_any())]) |> ignore
}

///|
/// Disables the instance of AsyncLocalStorage
/// https://nodejs.org/api/async_context.html#asynclocalstoragedisable
pub fn[T] AsyncLocalStorage::disable(self : AsyncLocalStorage[T]) -> Unit {
  self.as_any()._call("disable", []) |> ignore
}
