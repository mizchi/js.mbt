// Object.defineProperty and related APIs
// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty

///|
/// Property descriptor returned by Object.getOwnPropertyDescriptor
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
pub(all) struct PropertyDescriptor {
  /// The value associated with the property (data descriptors only)
  value : Any?
  /// true if the value can be changed with an assignment operator (data descriptors only)
  writable : Bool?
  /// true if the property shows up during enumeration
  enumerable : Bool?
  /// true if the property descriptor can be changed and deleted from the object
  configurable : Bool?
  /// A function serving as a getter for the property (accessor descriptors only)
  get : (() -> Any)?
  /// A function serving as a setter for the property (accessor descriptors only)
  set : ((Any) -> Unit)?
}

///|
extern "js" fn ffi_set_property(obj : Any, key : String, value : Any) -> Unit =
  #|(obj, key, value) => { obj[key] = value; }

///|
/// JS: Object.defineProperty(obj, prop, descriptor)
/// Defines a new property directly on an object, or modifies an existing property
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
pub fn Object::defineProperty(
  obj : &JsImpl,
  prop : &PropertyKey,
  value? : Any,
  writable? : Bool,
  enumerable? : Bool,
  configurable? : Bool,
  get? : () -> Any,
  set? : (Any) -> Unit,
) -> Any {
  let descriptor = Object::new()
  if value is Some(v) {
    ffi_set_property(descriptor, "value", v)
  }
  if writable is Some(v) {
    ffi_set_property(descriptor, "writable", v |> any)
  }
  if enumerable is Some(v) {
    ffi_set_property(descriptor, "enumerable", v |> any)
  }
  if configurable is Some(v) {
    ffi_set_property(descriptor, "configurable", v |> any)
  }
  if get is Some(getter) {
    ffi_set_property(descriptor, "get", getter |> identity)
  }
  if set is Some(setter) {
    ffi_set_property(descriptor, "set", setter |> identity)
  }
  object_class().call("defineProperty", [
    obj.as_any(),
    prop.to_key(),
    descriptor,
  ])
}

///|
/// JS: Object.defineProperties(obj, props)
/// Defines new or modifies existing properties directly on an object
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperties
pub fn Object::defineProperties(obj : &JsImpl, props : Any) -> Any {
  object_class().call2("defineProperties", obj.as_any(), props)
}

///|
/// JS: Object.getOwnPropertyDescriptor(obj, prop)
/// Returns a property descriptor for an own property
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptor
pub fn Object::getOwnPropertyDescriptor(
  obj : &JsImpl,
  prop : &PropertyKey,
) -> PropertyDescriptor? {
  let desc : Any = object_class().call2(
    "getOwnPropertyDescriptor",
    obj.as_any(),
    prop.to_key(),
  )
  if is_nullish(desc) {
    None
  } else {
    Some({
      value: if desc.hasOwnProperty("value") {
        Some(desc.get("value"))
      } else {
        None
      },
      writable: if desc.hasOwnProperty("writable") {
        Some(desc.get("writable") |> identity)
      } else {
        None
      },
      enumerable: if desc.hasOwnProperty("enumerable") {
        Some(desc.get("enumerable") |> identity)
      } else {
        None
      },
      configurable: if desc.hasOwnProperty("configurable") {
        Some(desc.get("configurable") |> identity)
      } else {
        None
      },
      get: if desc.hasOwnProperty("get") {
        Some(desc.get("get") |> identity)
      } else {
        None
      },
      set: if desc.hasOwnProperty("set") {
        Some(desc.get("set") |> identity)
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
pub fn Object::getOwnPropertyDescriptors(obj : &JsImpl) -> Any {
  object_class().call1("getOwnPropertyDescriptors", obj.as_any())
}

///|
/// JS: Object.getOwnPropertyNames(obj)
/// Returns an array of all own property names (including non-enumerable)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyNames
pub fn Object::getOwnPropertyNames(obj : &JsImpl) -> Array[String] {
  object_class().call1("getOwnPropertyNames", obj.as_any()) |> identity
}

///|
/// JS: Object.getOwnPropertySymbols(obj)
/// Returns an array of all own symbol properties
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertySymbols
pub fn Object::getOwnPropertySymbols(obj : &JsImpl) -> Array[Symbol] {
  object_class().call1("getOwnPropertySymbols", obj.as_any()) |> identity
}

///|
/// JS: Object.groupBy(items, callbackFn)
/// Groups the elements of an iterable according to the string values returned by a callback function
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/groupBy
pub fn[T : JsImpl] Object::groupBy(
  items : Array[T],
  callback : (T, Int) -> String,
) -> Any {
  let js_callback : (Any, Int) -> String = fn(item, index) {
    callback(item |> identity, index)
  }
  object_class().call2("groupBy", items |> from_array, from_fn2(js_callback))
}
