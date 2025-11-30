///|
/// get the Reflect class
fn reflect_class() -> @nostd.Any {
  @nostd.global_this()["Reflect"]
}

///|
/// JS: Reflect.apply(target, thisArgument, argumentsList)
/// Calls a target function with arguments as specified
pub fn apply(
  target : @nostd.Any,
  this_argument : @nostd.Any,
  arguments_list : Array[@nostd.Any],
) -> @nostd.Any {
  reflect_class()._call("apply", [
    target,
    this_argument,
    @nostd.any(arguments_list),
  ])
}

///|
/// JS: Reflect.construct(target, argumentsList, newTarget?)
/// Acts like the new operator as a function
pub fn construct(
  target : @nostd.Any,
  arguments_list : Array[@nostd.Any],
  new_target : @nostd.Any?,
) -> @nostd.Any {
  match new_target {
    Some(nt) =>
      reflect_class()._call("construct", [
        target,
        @nostd.any(arguments_list),
        nt,
      ])
    None =>
      reflect_class()._call("construct", [target, @nostd.any(arguments_list)])
  }
}

///|
/// JS: Reflect.defineProperty(target, propertyKey, attributes)
/// Similar to Object.defineProperty but returns a Boolean
pub fn defineProperty(
  target : @nostd.Any,
  property_key : @nostd.Any,
  attributes : @nostd.Any,
) -> Bool {
  reflect_class()
  ._call("defineProperty", [target, property_key, attributes])
  .cast()
}

///|
/// JS: Reflect.deleteProperty(target, propertyKey)
/// Deletes a property from an object
pub fn deleteProperty(target : @nostd.Any, property_key : @nostd.Any) -> Bool {
  reflect_class()._call("deleteProperty", [target, property_key]).cast()
}

///|
/// JS: Reflect.get(target, propertyKey, receiver?)
/// Gets a property value from an object
pub fn get(
  target : @nostd.Any,
  property_key : @nostd.Any,
  receiver : @nostd.Any?,
) -> @nostd.Any {
  match receiver {
    Some(recv) => reflect_class()._call("get", [target, property_key, recv])
    None => reflect_class()._call("get", [target, property_key])
  }
}

///|
/// JS: Reflect.getOwnPropertyDescriptor(target, propertyKey)
/// Gets the property descriptor of an own property
pub fn getOwnPropertyDescriptor(
  target : @nostd.Any,
  property_key : @nostd.Any,
) -> @nostd.Any {
  reflect_class()._call("getOwnPropertyDescriptor", [target, property_key])
}

///|
/// JS: Reflect.getPrototypeOf(target)
/// Gets the prototype of an object
pub fn getPrototypeOf(target : @nostd.Any) -> @nostd.Any {
  reflect_class()._call("getPrototypeOf", [target])
}

///|
/// JS: Reflect.has(target, propertyKey)
/// Checks if an object has a property
pub fn has(target : @nostd.Any, property_key : @nostd.Any) -> Bool {
  reflect_class()._call("has", [target, property_key]).cast()
}

///|
/// JS: Reflect.isExtensible(target)
/// Checks if an object is extensible
pub fn isExtensible(target : @nostd.Any) -> Bool {
  reflect_class()._call("isExtensible", [target]).cast()
}

///|
/// JS: Reflect.ownKeys(target)
///
/// Returns an array of the target object's own property keys.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn ownKeys(target : @nostd.Any) -> Array[@nostd.Any] {
  reflect_class()._call("ownKeys", [target]).cast()
}

///|
/// JS: Reflect.preventExtensions(target)
/// Prevents new properties from being added to an object
pub fn preventExtensions(target : @nostd.Any) -> Bool {
  reflect_class()._call("preventExtensions", [target]).cast()
}

///|
/// JS: Reflect.set(target, propertyKey, value, receiver?)
/// Sets a property value on an object
pub fn set(
  target : @nostd.Any,
  property_key : @nostd.Any,
  value : @nostd.Any,
  receiver : @nostd.Any?,
) -> Bool {
  match receiver {
    Some(recv) =>
      reflect_class()._call("set", [target, property_key, value, recv]).cast()
    None => reflect_class()._call("set", [target, property_key, value]).cast()
  }
}

///|
/// JS: Reflect.setPrototypeOf(target, prototype)
/// Sets the prototype of an object
pub fn setPrototypeOf(target : @nostd.Any, prototype : @nostd.Any) -> Bool {
  reflect_class()._call("setPrototypeOf", [target, prototype]).cast()
}
