///|
/// JavaScript Reflect API
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect
#external
pub type Reflect

///|
/// JS: Reflect.apply(target, thisArgument, argumentsList)
/// Calls a target function with arguments as specified
pub extern "js" fn Reflect::apply(
  target : @core.Any,
  this_argument : @core.Any,
  arguments_list : Array[@core.Any],
) -> @core.Any =
  #| (target, thisArg, args) => Reflect.apply(target, thisArg, args)

///|
/// JS: Reflect.construct(target, argumentsList, newTarget?)
/// Acts like the new operator as a function
pub fn Reflect::construct(
  target : @core.Any,
  arguments_list : Array[@core.Any],
  new_target : @core.Any?,
) -> @core.Any {
  match new_target {
    Some(nt) =>
      @core.global_this()["Reflect"]._call("construct", [
        target,
        @core.any(arguments_list),
        nt,
      ])
    None =>
      @core.global_this()["Reflect"]._call("construct", [
        target,
        @core.any(arguments_list),
      ])
  }
}

///|
/// JS: Reflect.defineProperty(target, propertyKey, attributes)
/// Similar to Object.defineProperty but returns a Boolean
pub extern "js" fn Reflect::defineProperty(
  target : @core.Any,
  property_key : @core.Any,
  attributes : @core.Any,
) -> Bool =
  #| (target, key, attrs) => Reflect.defineProperty(target, key, attrs)

///|
/// JS: Reflect.deleteProperty(target, propertyKey)
/// Deletes a property from an object
pub extern "js" fn Reflect::deleteProperty(
  target : @core.Any,
  property_key : @core.Any,
) -> Bool =
  #| (target, key) => Reflect.deleteProperty(target, key)

///|
/// JS: Reflect.get(target, propertyKey, receiver?)
/// Gets a property value from an object
pub fn Reflect::get(
  target : @core.Any,
  property_key : @core.Any,
  receiver : @core.Any?,
) -> @core.Any {
  match receiver {
    Some(recv) =>
      @core.global_this()["Reflect"]._call("get", [target, property_key, recv])
    None =>
      @core.global_this()["Reflect"]._call("get", [target, property_key])
  }
}

///|
/// JS: Reflect.getOwnPropertyDescriptor(target, propertyKey)
/// Gets the property descriptor of an own property
pub extern "js" fn Reflect::getOwnPropertyDescriptor(
  target : @core.Any,
  property_key : @core.Any,
) -> @core.Any =
  #| (target, key) => Reflect.getOwnPropertyDescriptor(target, key)

///|
/// JS: Reflect.getPrototypeOf(target)
/// Gets the prototype of an object
pub extern "js" fn Reflect::getPrototypeOf(target : @core.Any) -> @core.Any =
  #| (target) => Reflect.getPrototypeOf(target)

///|
/// JS: Reflect.has(target, propertyKey)
/// Checks if an object has a property
pub extern "js" fn Reflect::has(
  target : @core.Any,
  property_key : @core.Any,
) -> Bool =
  #| (target, key) => Reflect.has(target, key)

///|
/// JS: Reflect.isExtensible(target)
/// Checks if an object is extensible
pub extern "js" fn Reflect::isExtensible(target : @core.Any) -> Bool =
  #| (target) => Reflect.isExtensible(target)

///|
/// JS: Reflect.ownKeys(target)
///
/// Returns an array of the target object's own property keys.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub extern "js" fn Reflect::ownKeys(target : @core.Any) -> Array[@core.Any] =
  #| (target) => Reflect.ownKeys(target)

///|
/// JS: Reflect.preventExtensions(target)
/// Prevents new properties from being added to an object
pub extern "js" fn Reflect::preventExtensions(target : @core.Any) -> Bool =
  #| (target) => Reflect.preventExtensions(target)

///|
/// JS: Reflect.set(target, propertyKey, value, receiver?)
/// Sets a property value on an object
pub fn Reflect::set(
  target : @core.Any,
  property_key : @core.Any,
  value : @core.Any,
  receiver : @core.Any?,
) -> Bool {
  match receiver {
    Some(recv) =>
      @core
      .global_this()["Reflect"]
      ._call("set", [target, property_key, value, recv])
      .cast()
    None =>
      @core
      .global_this()["Reflect"]
      ._call("set", [target, property_key, value])
      .cast()
  }
}

///|
/// JS: Reflect.setPrototypeOf(target, prototype)
/// Sets the prototype of an object
pub extern "js" fn Reflect::setPrototypeOf(
  target : @core.Any,
  prototype : @core.Any,
) -> Bool =
  #| (target, proto) => Reflect.setPrototypeOf(target, proto)
