// Object.defineProperty and related APIs
// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty

///|
/// Property descriptor returned by Object.getOwnPropertyDescriptor
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
pub(all) struct PropertyDescriptor {
  /// The value associated with the property (data descriptors only)
  value : @nostd.Any?
  /// true if the value can be changed with an assignment operator (data descriptors only)
  writable : Bool?
  /// true if the property shows up during enumeration
  enumerable : Bool?
  /// true if the property descriptor can be changed and deleted from the object
  configurable : Bool?
  /// A function serving as a getter for the property (accessor descriptors only)
  get : (() -> @nostd.Any)?
  /// A function serving as a setter for the property (accessor descriptors only)
  set : ((@nostd.Any) -> Unit)?
}

///|
/// JS: Object.defineProperty(obj, prop, descriptor)
/// Defines a new property directly on an object, or modifies an existing property
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
pub fn Object::defineProperty(
  obj : @nostd.Any,
  prop : String,
  value? : @nostd.Any,
  writable? : Bool,
  enumerable? : Bool,
  configurable? : Bool,
  get? : () -> @nostd.Any,
  set? : (@nostd.Any) -> Unit,
) -> @nostd.Any {
  let descriptor = Object::new()
  if value is Some(v) {
    descriptor["value"] = v |> any
  }
  if writable is Some(v) {
    descriptor["writable"] = v |> any
  }
  if enumerable is Some(v) {
    descriptor["enumerable"] = v |> any
  }
  if configurable is Some(v) {
    descriptor["configurable"] = v |> any
  }
  if get is Some(getter) {
    descriptor["get"] = getter |> any
  }
  if set is Some(setter) {
    descriptor["set"] = setter |> any
  }
  @nostd.any(object_class())._call("defineProperty", [
    obj,
    @nostd.any(prop),
    @nostd.any(descriptor),
  ])
  |> identity
}

///|
/// JS: Object.defineProperties(obj, props)
/// Defines new or modifies existing properties directly on an object
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperties
pub fn Object::defineProperties(
  obj : @nostd.Any,
  props : @nostd.Any,
) -> @nostd.Any {
  @nostd.any(object_class())._call("defineProperties", [obj, @nostd.any(props)])
  |> identity
}

///|
/// JS: Object.getOwnPropertyDescriptor(obj, prop)
/// Returns a property descriptor for an own property
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptor
pub fn Object::getOwnPropertyDescriptor(
  obj : @nostd.Any,
  prop : String,
) -> PropertyDescriptor? {
  let desc : @nostd.Any = @nostd.any(object_class())._call(
    "getOwnPropertyDescriptor",
    [obj, @nostd.any(prop)],
  )
  if @nostd.is_nullish(desc) {
    None
  } else {
    Some({
      value: if ffi_has_own_property(desc, "value") {
        Some(ffi_get(desc, "value"))
      } else {
        None
      },
      writable: if ffi_has_own_property(desc, "writable") {
        Some(ffi_get(desc, "writable").cast())
      } else {
        None
      },
      enumerable: if ffi_has_own_property(desc, "enumerable") {
        Some(ffi_get(desc, "enumerable").cast())
      } else {
        None
      },
      configurable: if ffi_has_own_property(desc, "configurable") {
        Some(ffi_get(desc, "configurable").cast())
      } else {
        None
      },
      get: if ffi_has_own_property(desc, "get") {
        Some(ffi_get(desc, "get").cast())
      } else {
        None
      },
      set: if ffi_has_own_property(desc, "set") {
        Some(ffi_get(desc, "set").cast())
      } else {
        None
      },
    })
  }
}

///|
/// JS: Object.getOwnPropertyDescriptors(obj)
/// Returns all own property descriptors of an object
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptors
pub fn Object::getOwnPropertyDescriptors(obj : @nostd.Any) -> @nostd.Any {
  @nostd.any(object_class())._call("getOwnPropertyDescriptors", [obj])
  |> identity
}

///|
/// JS: Object.getOwnPropertyNames(obj)
/// Returns an array of all own property names (including non-enumerable)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyNames
pub fn Object::getOwnPropertyNames(obj : @nostd.Any) -> Array[String] {
  @nostd.any(object_class())._call("getOwnPropertyNames", [obj]) |> identity
}

///|
/// JS: Object.getOwnPropertySymbols(obj)
/// Returns an array of all own symbol properties
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertySymbols
pub fn Object::getOwnPropertySymbols(obj : @nostd.Any) -> Array[Symbol] {
  @nostd.any(object_class())._call("getOwnPropertySymbols", [obj]) |> identity
}

///|
/// JS: Object.groupBy(items, callbackFn)
/// Groups the elements of an iterable according to the string values returned by a callback function
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/groupBy
pub fn[T] Object::groupBy(
  items : Array[T],
  callback : (T, Int) -> String,
) -> @nostd.Any {
  let js_callback : (@nostd.Any, Int) -> String = fn(item, index) {
    callback(item |> identity, index)
  }
  @nostd.any(object_class())._call("groupBy", [
    @nostd.any(items),
    @nostd.any(from_fn2(js_callback)),
  ])
  |> identity
}
