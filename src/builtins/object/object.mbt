///|
extern "js" fn ffi_property_is_enumerable(
  obj : @nostd.Any,
  key : String,
) -> Bool =
  #| (obj, key) => obj.propertyIsEnumerable(key)

///|
extern "js" fn ffi_is_prototype_of(
  obj : @nostd.Any,
  target : @nostd.Any,
) -> Bool =
  #| (obj, target) => obj.isPrototypeOf(target)

///|
extern "js" fn ffi_object_entries(obj : @nostd.Any) -> Array[@nostd.Any] =
  #| (obj) => Object.entries(obj)

///|
extern "js" fn ffi_json_stringify(
  value : @nostd.Any,
  replacer : @nostd.Any,
  space : @nostd.Any,
) -> String =
  #| (value, replacer, space) => JSON.stringify(value, replacer, space)

///|
extern "js" fn ffi_has_own_property(obj : @nostd.Any, key : String) -> Bool =
  #| (obj, key) => obj.hasOwnProperty(key)

///|
/// JavaScript Object
#external
pub type Object

///|
pub fn Object::to_any(self : Object) -> @nostd.Any = "%identity"

///|
/// JS: new Object()
/// Returns Any directly - use from_map() for creating objects with initial properties
/// Example: `let obj = @js.from_map({ "key": @nostd.any(value) })` for typed object creation
pub extern "js" fn Object::new() -> @nostd.Any =
  #| () => ({})

///|
/// get the Object class
extern "js" fn object_class() -> @nostd.Any =
  #| () => Object

///|
/// JS: Object.keys(v)
///
/// Returns an array of a given object's own enumerable property names.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::keys(v : @nostd.Any) -> Array[String] {
  @nostd.any(object_class())._call("keys", [v]) |> @nostd.identity
}

///|
/// JS: Object.values(v)
///
/// Returns an array of a given object's own enumerable property values.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::values(v : @nostd.Any) -> Array[@nostd.Any] {
  @nostd.any(object_class())._call("values", [v]) |> @nostd.identity
}

///|
/// JS: Object.entries(v)
///
/// Returns an array of a given object's own enumerable property [key, value] pairs.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::entries(v : @nostd.Any) -> Array[(String, @nostd.Any)] {
  let entries = ffi_object_entries(v |> @nostd.identity)
  entries.map(entry => (
    @nostd.any(entry)["0"] |> @nostd.identity,
    @nostd.any(entry)["1"],
  ))
}

///|
/// JS: Object.assign(target, source)
pub fn Object::assign(target : @nostd.Any, source : @nostd.Any) -> @nostd.Any {
  @nostd.any(object_class())._call("assign", [target, source])
}

///|
/// JS: Object.create(v)
pub fn Object::create(v : @nostd.Any) -> @nostd.Any {
  @nostd.any(object_class())._call("create", [v])
}

///|
/// JS: Object.is(a, b)
/// Determines whether two values are the same value
pub fn Object::is_(a : @nostd.Any, b : @nostd.Any) -> Bool {
  @nostd.any(object_class())._call("is", [a, b]) |> @nostd.identity
}

///|
/// JS: Object.freeze(obj)
/// Freezes an object, preventing new properties from being added and existing properties from being removed or changed
pub fn Object::freeze(obj : @nostd.Any) -> @nostd.Any {
  @nostd.any(object_class())._call("freeze", [obj])
}

///|
/// JS: Object.seal(obj)
/// Seals an object, preventing new properties from being added and marking all existing properties as non-configurable
pub fn Object::seal(obj : @nostd.Any) -> @nostd.Any {
  @nostd.any(object_class())._call("seal", [obj])
}

///|
/// JS: Object.isFrozen(obj)
/// Determines if an object is frozen
pub fn Object::isFrozen(obj : @nostd.Any) -> Bool {
  @nostd.any(object_class())._call("isFrozen", [obj]) |> @nostd.identity
}

///|
/// JS: Object.isSealed(obj)
/// Determines if an object is sealed
pub fn Object::isSealed(obj : @nostd.Any) -> Bool {
  @nostd.any(object_class())._call("isSealed", [obj]) |> @nostd.identity
}

///|
/// JS: Object.preventExtensions(obj)
/// Prevents new properties from being added to an object
pub fn Object::preventExtensions(obj : @nostd.Any) -> @nostd.Any {
  @nostd.any(object_class())._call("preventExtensions", [obj])
}

///|
/// JS: Object.isExtensible(obj)
/// Determines if an object is extensible
pub fn Object::isExtensible_static(obj : @nostd.Any) -> Bool {
  @nostd.any(object_class())._call("isExtensible", [obj]) |> @nostd.identity
}

///|
/// JS: object.propertyIsEnumerable(k)
pub fn Object::propertyIsEnumerable(self : Self, key : String) -> Bool {
  ffi_property_is_enumerable(self |> @nostd.identity, key |> @nostd.identity)
}

///|
/// JS: object.isPrototypeOf(target)
pub fn Object::isPrototypeOf(self : Self, target : @nostd.Any) -> Bool {
  ffi_is_prototype_of(
    self.to_any() |> @nostd.identity,
    target |> @nostd.identity,
  )
}

///|
pub fn Object::hasOwnProperty(self : Self, key : String) -> Bool {
  ffi_has_own_property(self |> @nostd.identity, key |> @nostd.identity)
}

///|
/// JS: Object.isExtensible(obj)
/// Instance method that calls the static Object.isExtensible
pub fn Object::isExtensible(self : Self) -> Bool {
  @nostd.any(object_class())._call("isExtensible", [self.to_any()])
  |> @nostd.identity
}

///|
pub fn Object::to_string(self : Self) -> String {
  ffi_json_stringify(
    self.to_any() |> @nostd.identity,
    @nostd.undefined(),
    @nostd.undefined(),
  )
}

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
    descriptor["value"] = v |> @nostd.any
  }
  if writable is Some(v) {
    descriptor["writable"] = v |> @nostd.any
  }
  if enumerable is Some(v) {
    descriptor["enumerable"] = v |> @nostd.any
  }
  if configurable is Some(v) {
    descriptor["configurable"] = v |> @nostd.any
  }
  if get is Some(getter) {
    descriptor["get"] = getter |> @nostd.any
  }
  if set is Some(setter) {
    descriptor["set"] = setter |> @nostd.any
  }
  @nostd.any(object_class())._call("defineProperty", [
    obj,
    @nostd.any(prop),
    @nostd.any(descriptor),
  ])
  |> @nostd.identity
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
  |> @nostd.identity
}

///|
extern "js" fn ffi_get(obj : @nostd.Any, key : String) -> @nostd.Any =
  #| (obj, key) => obj[key]

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
  |> @nostd.identity
}

///|
/// JS: Object.getOwnPropertyNames(obj)
/// Returns an array of all own property names (including non-enumerable)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyNames
pub fn Object::getOwnPropertyNames(obj : @nostd.Any) -> Array[String] {
  @nostd.any(object_class())._call("getOwnPropertyNames", [obj])
  |> @nostd.identity
}

///|
/// JS: Object.getOwnPropertySymbols(obj)
/// Returns an array of all own symbol properties
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertySymbols
pub fn Object::getOwnPropertySymbols(obj : @nostd.Any) -> Array[@symbol.Symbol] {
  @nostd.any(object_class())._call("getOwnPropertySymbols", [obj])
  |> @nostd.identity
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
    callback(item |> @nostd.identity, index)
  }
  @nostd.any(object_class())._call("groupBy", [
    @nostd.any(items),
    @nostd.any(@nostd.from_fn2(js_callback)),
  ])
  |> @nostd.identity
}
