///|
/// Web Trusted Types API - TrustedHTML
/// https://developer.mozilla.org/en-US/docs/Web/API/TrustedHTML
///
/// TrustedHTML represents a string that can be safely inserted into HTML injection sinks.
/// It cannot be created directly - use TrustedTypePolicy.create_html() instead.
pub(all) struct TrustedHTML {}

///|
pub fn TrustedHTML::as_any(self : TrustedHTML) -> @core.Any = "%identity"

///|
/// Returns the sanitized HTML string
pub fn TrustedHTML::to_string(self : TrustedHTML) -> String {
  self.as_any()._call("toString", []).cast()
}

///|
/// Returns a JSON representation of the stored data
#alias(to_json)
pub fn TrustedHTML::toJSON(self : TrustedHTML) -> String {
  self.as_any()._call("toJSON", []).cast()
}

///|
/// Web Trusted Types API - TrustedTypePolicy
/// https://developer.mozilla.org/en-US/docs/Web/API/TrustedTypePolicy
///
/// TrustedTypePolicy defines a group of functions for creating trusted type objects.
pub(all) struct TrustedTypePolicy {}

///|
pub fn TrustedTypePolicy::as_any(self : TrustedTypePolicy) -> @core.Any = "%identity"

///|
/// Returns the name of the policy
pub fn TrustedTypePolicy::name(self : TrustedTypePolicy) -> String {
  self.as_any()["name"].cast()
}

///|
/// Creates a TrustedHTML object from the given input string
#alias(create_html)
pub fn TrustedTypePolicy::createHTML(
  self : TrustedTypePolicy,
  input : String,
) -> TrustedHTML {
  self.as_any()._call("createHTML", [@core.any(input)]).cast()
}

///|
/// Creates a TrustedHTML object with additional arguments
#alias(create_html_with_args)
pub fn TrustedTypePolicy::createHTMLWithArgs(
  self : TrustedTypePolicy,
  input : String,
  args : Array[@core.Any],
) -> TrustedHTML {
  let all_args = [@core.any(input)]
  for arg in args {
    all_args.push(arg)
  }
  self.as_any()._call("createHTML", all_args).cast()
}

///|
/// Web Trusted Types API - TrustedTypePolicyFactory
/// https://developer.mozilla.org/en-US/docs/Web/API/TrustedTypePolicyFactory
///
/// TrustedTypePolicyFactory creates policies and verifies Trusted Type objects.
/// Access via the global `trustedTypes` object.
pub(all) struct TrustedTypePolicyFactory {}

///|
pub fn TrustedTypePolicyFactory::as_any(
  self : TrustedTypePolicyFactory,
) -> @core.Any = "%identity"

///|
/// Get the global trustedTypes object
extern "js" fn ffi_trusted_types() -> @core.Any =
  #|() => globalThis.trustedTypes

///|
/// Returns the global TrustedTypePolicyFactory (trustedTypes)
pub fn trusted_types() -> TrustedTypePolicyFactory {
  ffi_trusted_types().cast()
}

///|
/// Policy options for creating a TrustedTypePolicy
pub(all) struct TrustedTypePolicyOptions {
  /// Function to sanitize and create TrustedHTML
  create_html : ((String) -> String)?
}

///|
/// Create default policy options
pub fn TrustedTypePolicyOptions::new(
  create_html? : ((String) -> String)? = None,
) -> TrustedTypePolicyOptions {
  { create_html, }
}

///|
extern "js" fn ffi_create_policy(
  factory : @core.Any,
  name : String,
  options : @core.Any,
) -> @core.Any =
  #|(factory, name, options) => factory.createPolicy(name, options)

///|
/// Creates a TrustedTypePolicy object
#alias(create_policy)
pub fn TrustedTypePolicyFactory::createPolicy(
  self : TrustedTypePolicyFactory,
  name : String,
  options : TrustedTypePolicyOptions,
) -> TrustedTypePolicy {
  let policy_options : Array[(String, @core.Any)] = []
  if options.create_html is Some(fn_) {
    policy_options.push(("createHTML", @core.any(fn_)))
  }
  ffi_create_policy(self.as_any(), name, @core.from_entries(policy_options)).cast()
}

///|
/// Returns the default policy or None if not set
#alias(default_policy)
pub fn TrustedTypePolicyFactory::defaultPolicy(
  self : TrustedTypePolicyFactory,
) -> TrustedTypePolicy? {
  let v = self.as_any()["defaultPolicy"]
  if @core.is_nullish(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Returns true if the value is a TrustedHTML object
#alias(is_html)
pub fn TrustedTypePolicyFactory::isHTML(
  self : TrustedTypePolicyFactory,
  value : @core.Any,
) -> Bool {
  self.as_any()._call("isHTML", [value]).cast()
}

///|
/// Returns the empty TrustedHTML object
#alias(empty_html)
pub fn TrustedTypePolicyFactory::emptyHTML(
  self : TrustedTypePolicyFactory,
) -> TrustedHTML {
  self.as_any()["emptyHTML"].cast()
}

///|
/// Returns the input as TrustedHTML if allowed by the default policy
#alias(get_attribute_type)
pub fn TrustedTypePolicyFactory::getAttributeType(
  self : TrustedTypePolicyFactory,
  tag_name : String,
  attribute : String,
  element_ns? : String,
  attr_ns? : String,
) -> String? {
  let args : Array[@core.Any] = [@core.any(tag_name), @core.any(attribute)]
  if element_ns is Some(ns) {
    args.push(@core.any(ns))
    if attr_ns is Some(ans) {
      args.push(@core.any(ans))
    }
  }
  let result = self.as_any()._call("getAttributeType", args)
  if @core.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Returns the property type for the given element and property
#alias(get_property_type)
pub fn TrustedTypePolicyFactory::getPropertyType(
  self : TrustedTypePolicyFactory,
  tag_name : String,
  property : String,
  element_ns? : String,
) -> String? {
  let args : Array[@core.Any] = [@core.any(tag_name), @core.any(property)]
  if element_ns is Some(ns) {
    args.push(@core.any(ns))
  }
  let result = self.as_any()._call("getPropertyType", args)
  if @core.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}
