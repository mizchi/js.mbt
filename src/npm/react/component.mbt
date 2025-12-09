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
  let children_arr = @core.any(children.map(_.to_react_node()))
  let val : @core.Any = @core.any(props)
  // Handle key: if props is undefined/null (e.g. Unit), create a new object
  if @core.is_nullish(val) {
    let obj = @core.new_object()
    if key is Some(key) {
      obj["key"] = @core.any(key)
    }
    if not(children.is_empty()) {
      obj["children"] = children_arr
    }
    return ffi_create_element(tag, obj).cast()
  }
  if key is Some(key) {
    val["key"] = @core.any(key)
  }
  // Only set children if explicitly provided (non-empty)
  // This preserves props.children when user passes children in props directly
  if not(children.is_empty()) {
    val["children"] = children_arr
  }
  ffi_create_element(tag, val).cast()
}

///|
/// JS: <React.Fragment key=...>{children}</React.Fragment>
pub fn strict_mode(children : Array[&ReactNode]) -> Element {
  let tag = @core.any(get_strict_mode())
  let children_arr = @core.any(children.map(_.to_react_node()))
  let props = @core.new_object()
  props["children"] = children_arr
  ffi_create_element(tag, props).cast()
}

///|
/// JS: <React.Fragment key=...>{children}</React.Fragment>
pub fn fragment(children : Array[&ReactNode], key? : String) -> Element {
  let tag = @core.any(get_fragment())
  let children_arr = @core.any(children.map(_.to_react_node()))
  let val = @core.new_object()
  if key is Some(key) {
    val["key"] = @core.any(key)
  }
  val["children"] = children_arr
  ffi_create_element(tag, val).cast()
}

///|
/// JS: <React.Suspense fallback=...>{children}</React.Suspense>
pub fn suspense(children : Array[&ReactNode], fallback~ : Element) -> Element {
  let tag = get_suspense()
  let children_arr = @core.any(children.map(_.to_react_node()))
  let props = @core.new_object()
  props["fallback"] = fallback.as_any()
  props["children"] = children_arr
  ffi_create_element(tag, props).cast()
}

///|
/// React.Provider
/// JS: <Context.Provider value=...>{children}</Context.Provider>
pub fn[T] provider(
  tag : Context[T],
  children : Array[&ReactNode],
  value~ : T,
) -> Element {
  let children_arr = @core.any(children.map(_.to_react_node()))
  let props = @core.new_object()
  props["value"] = @core.any(value)
  props["children"] = children_arr
  ffi_create_element(tag.as_any(), props).cast()
}
