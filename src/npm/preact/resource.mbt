///|
/// Async Resource - Simple reactive data fetching for Preact
/// Uses signals to store data and loading/error states separately

///|
/// Resource type - stores data in a signal with separate loading flag
pub struct Resource[T] {
  data : Signal[T?]
  is_loading : Signal[Bool]
  error : Signal[@nostd.Any?]
  refetch : () -> Unit
}

///|
/// Get value or None
pub fn[T] Resource::try_value(self : Resource[T]) -> T? {
  self.data.value
}

///|
/// Get value (throws if not ready)
pub fn[T] Resource::value(self : Resource[T]) -> T {
  match self.data.value {
    Some(v) => v
    None =>
      if self.is_loading.value {
        abort("Resource is still loading")
      } else {
        abort("Resource has error")
      }
  }
}

///|
/// Check if loading
pub fn[T] Resource::loading(self : Resource[T]) -> Bool {
  self.is_loading.value
}

///|
/// Check if has error
pub fn[T] Resource::has_error(self : Resource[T]) -> Bool {
  self.error.value is Some(_)
}

///|
/// Get error if any
pub fn[T] Resource::get_error(self : Resource[T]) -> @nostd.Any? {
  self.error.value
}

///|
/// Refetch the resource
pub fn[T] Resource::refetch(self : Resource[T]) -> Unit {
  (self.refetch)()
}

///|
/// Create a resource from an async fetcher function
pub fn[T] createResource(fetcher : () -> @nostd.Promise[T]) -> Resource[T] {
  let data : Signal[T?] = signal(None)
  let is_loading : Signal[Bool] = signal(true)
  let error : Signal[@nostd.Any?] = signal(None)
  let do_fetch : () -> Unit = fn() {
    is_loading.value = true
    error.value = None
    let promise = fetcher()
    ffi_promise_then_catch(
      @nostd.any(promise),
      fn(value) {
        data.value = Some(value.cast())
        is_loading.value = false
      },
      fn(err) {
        error.value = Some(err)
        is_loading.value = false
      },
    )
  }
  // Start initial fetch
  do_fetch()
  { data, is_loading, error, refetch: do_fetch }
}

///|
extern "js" fn ffi_promise_then_catch(
  promise : @nostd.Any,
  on_resolve : (@nostd.Any) -> Unit,
  on_reject : (@nostd.Any) -> Unit,
) -> Unit =
  #|(p, resolve, reject) => p.then(resolve).catch(reject)
