///|
pub type Component[T] = (T) -> Element

///|
/// render component
/// JS: React.createElement(component, props, ...children)
#alias(c)
pub fn[T] component(
  tag : Component[T],
  props : T,
  children? : Array[&ReactNode] = [],
  key? : String,
) -> Element {
  let tag = @core.any(tag)
  let children = @core.any(children.map(_.to_react_node()))
  let val : @core.Any = @core.any(props)
  // Handle key: if props is undefined/null (e.g. Unit), create a new object
  if key is Some(key) {
    if @core.is_nullish(val) {
      let obj = @core.Object::new()
      obj["key"] = @core.any(key)
      return ffi_create_element(tag, obj, children).cast()
    }
    val["key"] = @core.any(key)
  }
  ffi_create_element(tag, val, children).cast()
}

///|
/// JS: <React.Fragment key=...>{children}</React.Fragment>
pub fn strict_mode(children : Array[&ReactNode]) -> Element {
  let tag = @core.any(get_strict_mode())
  let children = @core.any(children.map(_.to_react_node()))
  ffi_create_element(tag, @core.undefined(), children).cast()
}

///|
/// JS: <React.Fragment key=...>{children}</React.Fragment>
pub fn fragment(children : Array[&ReactNode], key? : String) -> Element {
  let tag = @core.any(get_fragment())
  let children = @core.any(children.map(_.to_react_node()))
  let val = @core.Object::new()
  if key is Some(key) {
    val["key"] = @core.any(key)
  }
  ffi_create_element(tag, val, children).cast()
}

///|
/// JS: <React.Suspense fallback=...>{children}</React.Suspense>
pub fn suspense(children : Array[&ReactNode], fallback~ : Element) -> Element {
  let tag = get_suspense()
  let children = @core.any(children.map(_.to_react_node()))
  let props = @core.Object::new()
  props["fallback"] = fallback.as_any()
  ffi_create_element(tag, props, children).cast()
}

///|
/// React.Provider
/// JS: <Context.Provider value=...>{children}</Context.Provider>
pub fn[T] provider(
  tag : Context[T],
  children : Array[&ReactNode],
  value~ : T,
) -> Element {
  let children = @core.any(children.map(_.to_react_node()))
  let props = @core.Object::new()
  props["value"] = @core.any(value)
  ffi_create_element(tag.as_any(), props, children).cast()
}
