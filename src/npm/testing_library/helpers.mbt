///|
/// Helper to set optional value on JS object, returns true if value was set
fn[T] set_opt(obj : @core.Any, key : String, val : T?) -> Bool {
  match val {
    Some(v) => {
      obj._set(key, v |> @core.any)
      true
    }
    None => false
  }
}

///|
/// Helper to convert object to Some if any options were set, None otherwise
pub fn to_options(obj : @core.Any, has_any : Bool) -> @core.Any? {
  if has_any {
    Some(obj)
  } else {
    None
  }
}

///|
/// Helper to build MatcherOptions object for text-based queries
pub fn build_matcher_options(
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
) -> @core.Any? {
  let obj = @core.Object::new()
  let has = set_opt(obj, "exact", exact) ||
    set_opt(obj, "trim", trim) ||
    set_opt(obj, "collapseWhitespace", collapse_whitespace)
  to_options(obj, has)
}

///|
/// Helper to build SelectorMatcherOptions object for label queries
pub fn build_selector_matcher_options(
  exact? : Bool? = None,
  trim? : Bool? = None,
  collapse_whitespace? : Bool? = None,
  selector? : String? = None,
) -> @core.Any? {
  let obj = @core.Object::new()
  let has = set_opt(obj, "exact", exact) ||
    set_opt(obj, "trim", trim) ||
    set_opt(obj, "collapseWhitespace", collapse_whitespace) ||
    set_opt(obj, "selector", selector)
  to_options(obj, has)
}

///|
/// Helper to build ByRoleOptions object
pub fn build_role_options(
  name? : String? = None,
  hidden? : Bool? = None,
  selected? : Bool? = None,
  checked? : Bool? = None,
  pressed? : Bool? = None,
  expanded? : Bool? = None,
  level? : Int? = None,
  description? : String? = None,
) -> @core.Any? {
  let obj = @core.Object::new()
  let has = set_opt(obj, "name", name) ||
    set_opt(obj, "hidden", hidden) ||
    set_opt(obj, "selected", selected) ||
    set_opt(obj, "checked", checked) ||
    set_opt(obj, "pressed", pressed) ||
    set_opt(obj, "expanded", expanded) ||
    set_opt(obj, "level", level) ||
    set_opt(obj, "description", description)
  to_options(obj, has)
}
