///|
/// get the Reflect class
fn reflect_class() -> @js.Js {
  @js.globalThis().get("Reflect")
}

///|
/// JS: Reflect.apply(target, thisArgument, argumentsList)
/// Calls a target function with arguments as specified
pub fn apply(
  target : &@js.JsImpl,
  this_argument : &@js.JsImpl,
  arguments_list : Array[@js.Js],
) -> @js.Js {
  reflect_class().call("apply", [
    target.to_js(),
    this_argument.to_js(),
    @js.from_array(arguments_list),
  ])
}

///|
/// JS: Reflect.construct(target, argumentsList, newTarget?)
/// Acts like the new operator as a function
pub fn construct(
  target : &@js.JsImpl,
  arguments_list : Array[@js.Js],
  new_target : @js.Js?,
) -> @js.Js {
  match new_target {
    Some(nt) =>
      reflect_class().call("construct", [
        target.to_js(),
        @js.from_array(arguments_list),
        nt,
      ])
    None =>
      reflect_class().call("construct", [
        target.to_js(),
        @js.from_array(arguments_list),
      ])
  }
}

///|
/// JS: Reflect.defineProperty(target, propertyKey, attributes)
/// Similar to Object.defineProperty but returns a Boolean
pub fn defineProperty(
  target : &@js.JsImpl,
  property_key : &@js.PropertyKey,
  attributes : &@js.JsImpl,
) -> Bool {
  reflect_class().call("defineProperty", [
    target.to_js(),
    property_key.to_key(),
    attributes.to_js(),
  ])
  |> @js.unsafe_cast
}

///|
/// JS: Reflect.deleteProperty(target, propertyKey)
/// Deletes a property from an object
pub fn deleteProperty(
  target : &@js.JsImpl,
  property_key : &@js.PropertyKey,
) -> Bool {
  reflect_class().call2("deleteProperty", target.to_js(), property_key.to_key())
  |> @js.unsafe_cast
}

///|
/// JS: Reflect.get(target, propertyKey, receiver?)
/// Gets a property value from an object
pub fn get(
  target : &@js.JsImpl,
  property_key : &@js.PropertyKey,
  receiver : @js.Js?,
) -> @js.Js {
  match receiver {
    Some(recv) =>
      reflect_class().call("get", [target.to_js(), property_key.to_key(), recv])
    None => reflect_class().call2("get", target.to_js(), property_key.to_key())
  }
}

///|
/// JS: Reflect.getOwnPropertyDescriptor(target, propertyKey)
/// Gets the property descriptor of an own property
pub fn getOwnPropertyDescriptor(
  target : &@js.JsImpl,
  property_key : &@js.PropertyKey,
) -> @js.Js {
  reflect_class().call("getOwnPropertyDescriptor", [
    target.to_js(),
    property_key.to_key(),
  ])
}

///|
/// JS: Reflect.getPrototypeOf(target)
/// Gets the prototype of an object
pub fn getPrototypeOf(target : &@js.JsImpl) -> @js.Js {
  reflect_class().call("getPrototypeOf", [target.to_js()])
}

///|
/// JS: Reflect.has(target, propertyKey)
/// Checks if an object has a property
pub fn has(target : &@js.JsImpl, property_key : &@js.PropertyKey) -> Bool {
  reflect_class().call2("has", target.to_js(), property_key.to_key())
  |> @js.unsafe_cast
}

///|
/// JS: Reflect.isExtensible(target)
/// Checks if an object is extensible
pub fn isExtensible(target : &@js.JsImpl) -> Bool {
  reflect_class().call("isExtensible", [target.to_js()]) |> @js.unsafe_cast
}

///|
/// JS: Reflect.ownKeys(target)
///
/// Returns an array of the target object's own property keys.
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn ownKeys(target : &@js.JsImpl) -> Array[@js.Js] {
  reflect_class().call("ownKeys", [target.to_js()]) |> @js.unsafe_cast
}

///|
/// JS: Reflect.preventExtensions(target)
/// Prevents new properties from being added to an object
pub fn preventExtensions(target : &@js.JsImpl) -> Bool {
  reflect_class().call("preventExtensions", [target.to_js()]) |> @js.unsafe_cast
}

///|
/// JS: Reflect.set(target, propertyKey, value, receiver?)
/// Sets a property value on an object
pub fn set(
  target : &@js.JsImpl,
  property_key : &@js.PropertyKey,
  value : &@js.JsImpl,
  receiver : @js.Js?,
) -> Bool {
  match receiver {
    Some(recv) =>
      reflect_class().call("set", [
        target.to_js(),
        property_key.to_key(),
        value.to_js(),
        recv,
      ])
      |> @js.unsafe_cast
    None =>
      reflect_class().call("set", [
        target.to_js(),
        property_key.to_key(),
        value.to_js(),
      ])
      |> @js.unsafe_cast
  }
}

///|
/// JS: Reflect.setPrototypeOf(target, prototype)
/// Sets the prototype of an object
pub fn setPrototypeOf(target : &@js.JsImpl, prototype : &@js.JsImpl) -> Bool {
  reflect_class().call2("setPrototypeOf", target.to_js(), prototype.to_js())
  |> @js.unsafe_cast
}
