///|
extern "js" fn ffi_property_is_enumerable(
  obj : @core.Any,
  key : String,
) -> Bool =
  #| (obj, key) => obj.propertyIsEnumerable(key)

///|
extern "js" fn ffi_is_prototype_of(obj : @core.Any, target : @core.Any) -> Bool =
  #| (obj, target) => obj.isPrototypeOf(target)

///|
extern "js" fn ffi_object_entries(obj : @core.Any) -> Array[@core.Any] =
  #| (obj) => Object.entries(obj)

///|
extern "js" fn ffi_json_stringify(
  value : @core.Any,
  replacer : @core.Any,
  space : @core.Any,
) -> String =
  #| (value, replacer, space) => JSON.stringify(value, replacer, space)

///|
extern "js" fn ffi_has_own_property(obj : @core.Any, key : String) -> Bool =
  #| (obj, key) => obj.hasOwnProperty(key)

///|
/// JavaScript Object
#external
pub type Object

///|
pub fn Object::to_any(self : Object) -> @core.Any = "%identity"

///|
/// JS: new Object()
/// Returns Any directly - use from_map() for creating objects with initial properties
/// Example: `let obj = @js.from_map({ "key": @core.any(value) })` for typed object creation
pub extern "js" fn Object::new() -> @core.Any =
  #| () => ({})

///|
/// get the Object class
extern "js" fn object_class() -> @core.Any =
  #| () => Object

///|
/// JS: Object.keys(v)
///
/// Returns an array of a given object's own enumerable property names.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::keys(v : @core.Any) -> Array[String] {
  @core.any(object_class())._call("keys", [v]) |> @core.identity
}

///|
/// JS: Object.values(v)
///
/// Returns an array of a given object's own enumerable property values.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::values(v : @core.Any) -> Array[@core.Any] {
  @core.any(object_class())._call("values", [v]) |> @core.identity
}

///|
/// JS: Object.entries(v)
///
/// Returns an array of a given object's own enumerable property [key, value] pairs.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn Object::entries(v : @core.Any) -> Array[(String, @core.Any)] {
  let entries = ffi_object_entries(v |> @core.identity)
  entries.map(entry => {
    (@core.any(entry)["0"] |> @core.identity, @core.any(entry)["1"])
  })
}

///|
/// JS: Object.assign(target, source)
pub fn Object::assign(target : @core.Any, source : @core.Any) -> @core.Any {
  @core.any(object_class())._call("assign", [target, source])
}

///|
/// JS: Object.create(v)
pub fn Object::create(v : @core.Any) -> @core.Any {
  @core.any(object_class())._call("create", [v])
}

///|
/// JS: Object.is(a, b)
/// Determines whether two values are the same value
pub fn Object::is_(a : @core.Any, b : @core.Any) -> Bool {
  @core.any(object_class())._call("is", [a, b]) |> @core.identity
}

///|
/// JS: Object.freeze(obj)
/// Freezes an object, preventing new properties from being added and existing properties from being removed or changed
pub fn Object::freeze(obj : @core.Any) -> @core.Any {
  @core.any(object_class())._call("freeze", [obj])
}

///|
/// JS: Object.seal(obj)
/// Seals an object, preventing new properties from being added and marking all existing properties as non-configurable
pub fn Object::seal(obj : @core.Any) -> @core.Any {
  @core.any(object_class())._call("seal", [obj])
}

///|
/// JS: Object.isFrozen(obj)
/// Determines if an object is frozen
pub fn Object::isFrozen(obj : @core.Any) -> Bool {
  @core.any(object_class())._call("isFrozen", [obj]) |> @core.identity
}

///|
/// JS: Object.isSealed(obj)
/// Determines if an object is sealed
pub fn Object::isSealed(obj : @core.Any) -> Bool {
  @core.any(object_class())._call("isSealed", [obj]) |> @core.identity
}

///|
/// JS: Object.preventExtensions(obj)
/// Prevents new properties from being added to an object
pub fn Object::preventExtensions(obj : @core.Any) -> @core.Any {
  @core.any(object_class())._call("preventExtensions", [obj])
}

///|
/// JS: Object.isExtensible(obj)
/// Determines if an object is extensible
pub fn Object::isExtensible_static(obj : @core.Any) -> Bool {
  @core.any(object_class())._call("isExtensible", [obj]) |> @core.identity
}

///|
/// JS: object.propertyIsEnumerable(k)
pub fn Object::propertyIsEnumerable(self : Self, key : String) -> Bool {
  ffi_property_is_enumerable(self |> @core.identity, key |> @core.identity)
}

///|
/// JS: object.isPrototypeOf(target)
pub fn Object::isPrototypeOf(self : Self, target : @core.Any) -> Bool {
  ffi_is_prototype_of(self.to_any() |> @core.identity, target |> @core.identity)
}

///|
pub fn Object::hasOwnProperty(self : Self, key : String) -> Bool {
  ffi_has_own_property(self |> @core.identity, key |> @core.identity)
}

///|
/// JS: Object.isExtensible(obj)
/// Instance method that calls the static Object.isExtensible
pub fn Object::isExtensible(self : Self) -> Bool {
  @core.any(object_class())._call("isExtensible", [self.to_any()])
  |> @core.identity
}

///|
pub fn Object::to_string(self : Self) -> String {
  ffi_json_stringify(
    self.to_any() |> @core.identity,
    @core.undefined(),
    @core.undefined(),
  )
}

// Object.defineProperty and related APIs
// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty

///|
/// Property descriptor returned by Object.getOwnPropertyDescriptor
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
pub(all) struct PropertyDescriptor {
  /// The value associated with the property (data descriptors only)
  value : @core.Any?
  /// true if the value can be changed with an assignment operator (data descriptors only)
  writable : Bool?
  /// true if the property shows up during enumeration
  enumerable : Bool?
  /// true if the property descriptor can be changed and deleted from the object
  configurable : Bool?
  /// A function serving as a getter for the property (accessor descriptors only)
  get : (() -> @core.Any)?
  /// A function serving as a setter for the property (accessor descriptors only)
  set : ((@core.Any) -> Unit)?
}

///|
/// JS: Object.defineProperty(obj, prop, descriptor)
/// Defines a new property directly on an object, or modifies an existing property
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
pub fn Object::defineProperty(
  obj : @core.Any,
  prop : String,
  value? : @core.Any,
  writable? : Bool,
  enumerable? : Bool,
  configurable? : Bool,
  get? : () -> @core.Any,
  set? : (@core.Any) -> Unit,
) -> @core.Any {
  let descriptor = Object::new()
  if value is Some(v) {
    descriptor["value"] = v |> @core.any
  }
  if writable is Some(v) {
    descriptor["writable"] = v |> @core.any
  }
  if enumerable is Some(v) {
    descriptor["enumerable"] = v |> @core.any
  }
  if configurable is Some(v) {
    descriptor["configurable"] = v |> @core.any
  }
  if get is Some(getter) {
    descriptor["get"] = getter |> @core.any
  }
  if set is Some(setter) {
    descriptor["set"] = setter |> @core.any
  }
  @core.any(object_class())._call("defineProperty", [
    obj,
    @core.any(prop),
    @core.any(descriptor),
  ])
  |> @core.identity
}

///|
/// JS: Object.defineProperties(obj, props)
/// Defines new or modifies existing properties directly on an object
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperties
pub fn Object::defineProperties(
  obj : @core.Any,
  props : @core.Any,
) -> @core.Any {
  @core.any(object_class())._call("defineProperties", [obj, @core.any(props)])
  |> @core.identity
}

///|
extern "js" fn ffi_get(obj : @core.Any, key : String) -> @core.Any =
  #| (obj, key) => obj[key]

///|
/// JS: Object.getOwnPropertyDescriptor(obj, prop)
/// Returns a property descriptor for an own property
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptor
pub fn Object::getOwnPropertyDescriptor(
  obj : @core.Any,
  prop : String,
) -> PropertyDescriptor? {
  let desc : @core.Any = @core.any(object_class())._call(
    "getOwnPropertyDescriptor",
    [obj, @core.any(prop)],
  )
  if @core.is_nullish(desc) {
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
pub fn Object::getOwnPropertyDescriptors(obj : @core.Any) -> @core.Any {
  @core.any(object_class())._call("getOwnPropertyDescriptors", [obj])
  |> @core.identity
}

///|
/// JS: Object.getOwnPropertyNames(obj)
/// Returns an array of all own property names (including non-enumerable)
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyNames
pub fn Object::getOwnPropertyNames(obj : @core.Any) -> Array[String] {
  @core.any(object_class())._call("getOwnPropertyNames", [obj])
  |> @core.identity
}

///|
/// JS: Object.getOwnPropertySymbols(obj)
/// Returns an array of all own symbol properties
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertySymbols
pub fn Object::getOwnPropertySymbols(obj : @core.Any) -> Array[@symbol.Symbol] {
  @core.any(object_class())._call("getOwnPropertySymbols", [obj])
  |> @core.identity
}

///|
/// JS: Object.groupBy(items, callbackFn)
/// Groups the elements of an iterable according to the string values returned by a callback function
/// https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object/groupBy
pub fn[T] Object::groupBy(
  items : Array[T],
  callback : (T, Int) -> String,
) -> @core.Any {
  let js_callback : (@core.Any, Int) -> String = fn(item, index) {
    callback(item |> @core.identity, index)
  }
  @core.any(object_class())._call("groupBy", [
    @core.any(items),
    @core.any(@core.from_fn2(js_callback)),
  ])
  |> @core.identity
}
