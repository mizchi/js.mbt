///| Context API for global state management

///|

///| This provides a simple Context API similar to React's Context API,

///| allowing components to share values without passing props through every level.

///|
/// Check if a property exists on an object
extern "js" fn has_property(obj : @core.Any, key : String) -> Bool =
  #| (obj, key) => key in obj

///|
/// Get next available context ID
fn get_next_context_id() -> Int {
  let global : @core.Any = @global.globalThis()
  let storage_key = "__moonbit_context_id"
  let has_storage : Bool = has_property(global, storage_key)
  if has_storage {
    let current : Int = global._get(storage_key).cast()
    global._set(storage_key, @core.any(current + 1))
    current
  } else {
    global._set(storage_key, @core.any(1))
    0
  }
}

///|
/// Create a new JavaScript Map
extern "js" fn new_map() -> @core.Any =
  #| () => new Map()

///|
/// Get global context storage Map
fn get_context_storage() -> @core.Any {
  let global : @core.Any = @global.globalThis()
  let storage_key = "__moonbit_context_storage"
  let has_storage : Bool = has_property(global, storage_key)
  if has_storage {
    global._get(storage_key)
  } else {
    let map = new_map()
    global._set(storage_key, map)
    map
  }
}

///|
/// Context type - holds a unique ID and default value
pub struct Context[T] {
  id : Int
  default_value : T
}

///| Create a new context with a default value

///|

///| Example:

///| ```

///| let ThemeContext = create_context("light")

///|
/// ```
pub fn[T] create_context(default_value : T) -> Context[T] {
  let id = get_next_context_id()
  { id, default_value }
}

///| Set the current value for a context

///|

///| This is similar to using a Provider in React.

///| The value will be available to all subsequent get_context() calls

///| until it is changed or cleared.

///|

///| Example:

///| ```

///| set_context(ThemeContext, "dark")

///|
/// ```
pub fn[T] set_context(context : Context[T], value : T) -> Unit {
  let storage = get_context_storage()
  storage._call("set", [@core.any(context.id), @core.any(value)]) |> ignore
}

///| Get the current value for a context

///|

///| Returns the value set by set_context(), or the default value

///| if no value has been set.

///|

///| Example:

///| ```

///| let theme = get_context(ThemeContext)

///|
/// ```
pub fn[T] get_context(context : Context[T]) -> T {
  let storage = get_context_storage()
  let has : Bool = storage._call("has", [@core.any(context.id)]).cast()
  if has {
    storage._call("get", [@core.any(context.id)]).cast()
  } else {
    context.default_value
  }
}

///| Clear the value for a context, reverting to default

///|

///| Example:

///| ```

///| clear_context(ThemeContext)

///|
/// ```
pub fn[T] clear_context(context : Context[T]) -> Unit {
  let storage = get_context_storage()
  storage._call("delete", [@core.any(context.id)]) |> ignore
}
