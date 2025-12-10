///|
pub type Component[T] = (T) -> Element

///|
/// render component
/// JS: jsx(component, props, key)
#alias(c)
pub fn[T] component(
  tag : Component[T],
  props : T,
  children? : Array[&ReactNode] = [],
  key? : String,
) -> Element {
  let tag = @core.any(tag)
  let val : @core.Any = @core.any(props)
  // Handle key: if props is undefined/null (e.g. Unit), create a new object
  let obj = if @core.is_nullish(val) { @core.new_object() } else { val }
  // Only set children if explicitly provided (non-empty)
  if not(children.is_empty()) {
    let children_arr = @core.any(children.map(_.to_react_node()))
    if children.length() == 1 {
      obj["children"] = children[0].to_react_node()
    } else {
      obj["children"] = children_arr
    }
  }
  // key is passed as 3rd argument to jsx runtime
  let key_val : @core.Any = match key {
    Some(k) => @core.any(k)
    None => @core.undefined()
  }
  if children.length() <= 1 {
    ffi_jsx(tag, obj, key_val).cast()
  } else {
    ffi_jsxs(tag, obj, key_val).cast()
  }
}

///|
/// JS: jsx(React.StrictMode, {children})
pub fn strict_mode(children : Array[&ReactNode]) -> Element {
  let tag = @core.any(get_strict_mode())
  let props = @core.new_object()
  if not(children.is_empty()) {
    if children.length() == 1 {
      props["children"] = children[0].to_react_node()
    } else {
      props["children"] = @core.any(children.map(_.to_react_node()))
    }
  }
  let key_val : @core.Any = @core.undefined()
  if children.length() <= 1 {
    ffi_jsx(tag, props, key_val).cast()
  } else {
    ffi_jsxs(tag, props, key_val).cast()
  }
}

///|
/// JS: jsx(Fragment, {children}, key)
pub fn fragment(children : Array[&ReactNode], key? : String) -> Element {
  jsx_fragment(children, key?)
}

///|
/// JS: jsx(Suspense, {fallback, children})
pub fn suspense(children : Array[&ReactNode], fallback~ : Element) -> Element {
  let tag = get_suspense()
  let props = @core.new_object()
  props["fallback"] = fallback.as_any()
  if not(children.is_empty()) {
    if children.length() == 1 {
      props["children"] = children[0].to_react_node()
    } else {
      props["children"] = @core.any(children.map(_.to_react_node()))
    }
  }
  let key_val : @core.Any = @core.undefined()
  if children.length() <= 1 {
    ffi_jsx(tag, props, key_val).cast()
  } else {
    ffi_jsxs(tag, props, key_val).cast()
  }
}

///|
/// React.Provider
/// JS: jsx(Context.Provider, {value, children})
pub fn[T] provider(
  tag : Context[T],
  children : Array[&ReactNode],
  value~ : T,
) -> Element {
  let props = @core.new_object()
  props["value"] = @core.any(value)
  if not(children.is_empty()) {
    if children.length() == 1 {
      props["children"] = children[0].to_react_node()
    } else {
      props["children"] = @core.any(children.map(_.to_react_node()))
    }
  }
  let key_val : @core.Any = @core.undefined()
  if children.length() <= 1 {
    ffi_jsx(tag.as_any(), props, key_val).cast()
  } else {
    ffi_jsxs(tag.as_any(), props, key_val).cast()
  }
}
