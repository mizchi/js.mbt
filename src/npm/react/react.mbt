///|
/// React.Element
#external
pub type Element

///|
pub fn Element::as_any(self : Element) -> @core.Any = "%identity"

///|
#alias(h)
pub fn createElement(
  tag : String,
  children : Array[&ReactNode],
  props? : Map[String, @core.Any],
  style? : Map[String, String],
  ref_? : ReactRef[@dom.Element],
  key? : String,
) -> Element {
  jsx_tag(tag, children, props?, style?, ref_?, key?)
}

///|
/// Internal FFI to create React element
/// Directly create a React element with given tag, props, and children.
pub fn createElementDirect(
  tag : String,
  props : @core.Any,
  children : @core.Any,
) -> Element {
  props["children"] = children
  let key_val : @core.Any = @core.undefined()
  ffi_jsx(@core.any(tag), props, key_val).cast()
}

///|
/// Create React element with props only (no children) - for void elements like <input>
pub fn createElementRaw(tag : @core.Any, props : @core.Any) -> Element {
  let key_val : @core.Any = @core.undefined()
  ffi_jsx(tag, props, key_val).cast()
}

///|
/// Create React element with props and key - key is passed as 3rd argument to jsx runtime
pub fn createElementWithKey(
  tag : @core.Any,
  props : @core.Any,
  key : String?,
) -> Element {
  let key_val : @core.Any = match key {
    Some(k) => @core.any(k)
    None => @core.undefined()
  }
  ffi_jsx(tag, props, key_val).cast()
}
