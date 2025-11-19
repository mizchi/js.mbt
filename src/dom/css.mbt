///|
/// CSS Typed Object Model and utilities
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS_Object_Model

///|
/// CSSStyleDeclaration represents a CSS declaration block
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration
#external
pub type CSSStyleDeclaration

///|
pub impl JsImpl for CSSStyleDeclaration

///|
/// Returns a CSS style declaration from a Val
pub fn css_style_from_val(val : Js) -> CSSStyleDeclaration {
  unsafe_cast(val)
}

///|
/// Gets a CSS property value
pub fn CSSStyleDeclaration::get_property_value(
  self : Self,
  property : String,
) -> String {
  self.call("getPropertyValue", [property]) |> unsafe_cast
}

///|
/// Sets a CSS property value
pub fn CSSStyleDeclaration::set_property(
  self : Self,
  property : String,
  value : String,
) -> Unit {
  self.call("setProperty", [property, value]) |> ignore
}

///|
/// Sets a CSS property value with priority
pub fn CSSStyleDeclaration::set_property_priority(
  self : Self,
  property : String,
  value : String,
  priority : String,
) -> Unit {
  self.call("setProperty", [property, value, priority]) |> ignore
}

///|
/// Removes a CSS property
pub fn CSSStyleDeclaration::remove_property(
  self : Self,
  property : String,
) -> String {
  self.call("removeProperty", [property]) |> unsafe_cast
}

///|
/// Gets the priority of a CSS property
pub fn CSSStyleDeclaration::get_property_priority(
  self : Self,
  property : String,
) -> String {
  self.call("getPropertyPriority", [property]) |> unsafe_cast
}

///|
/// Returns the CSS text
pub fn CSSStyleDeclaration::css_text(self : Self) -> String {
  unsafe_cast(self.get("cssText"))
}

///|
/// Sets the CSS text
pub fn CSSStyleDeclaration::set_css_text(self : Self, text : String) -> Unit {
  self.set("cssText", text) |> ignore
}

///|
/// Returns the number of CSS properties
pub fn CSSStyleDeclaration::length(self : Self) -> Int {
  unsafe_cast(self.get("length"))
}

///|
/// Returns the parent CSS rule
pub fn CSSStyleDeclaration::parent_rule(self : Self) -> CSSRule? {
  self.get("parentRule") |> @js.unsafe_cast_option
}

///|
/// CSSRule represents a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSRule
#external
pub type CSSRule

///|
pub impl JsImpl for CSSRule

///|
/// Returns the CSS text of the rule
pub fn CSSRule::css_text(self : Self) -> String {
  unsafe_cast(self.get("cssText"))
}

///|
/// Sets the CSS text of the rule
pub fn CSSRule::set_css_text(self : Self, text : String) -> Unit {
  self.set("cssText", text) |> ignore
}

///|
/// Returns the parent rule
pub fn CSSRule::parent_rule(self : Self) -> CSSRule? {
  self.get("parentRule") |> @js.unsafe_cast_option()
}

///|
/// Returns the parent stylesheet
pub fn CSSRule::parent_stylesheet(self : Self) -> CSSStyleSheet? {
  self.get("parentStyleSheet") |> @js.unsafe_cast_option()
}

///|
/// Returns the rule type
pub fn CSSRule::rule_type(self : Self) -> Int {
  unsafe_cast(self.get("type"))
}

///|
/// CSSStyleSheet represents a stylesheet
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet
#external
pub type CSSStyleSheet

///|
pub impl JsImpl for CSSStyleSheet

///|
/// Returns the CSS rules
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/cssRules
pub fn CSSStyleSheet::css_rules(self : Self) -> Js {
  self.get("cssRules")
}

///|
/// Inserts a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/insertRule
pub fn CSSStyleSheet::insert_rule(self : Self, rule : String) -> Int {
  self.call("insertRule", [rule]) |> unsafe_cast
}

///|
/// Inserts a CSS rule at index
pub fn CSSStyleSheet::insert_rule_at(
  self : Self,
  rule : String,
  index : Int,
) -> Int {
  self.call("insertRule", [rule, index]) |> unsafe_cast
}

///|
/// Deletes a CSS rule at index
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/deleteRule
pub fn CSSStyleSheet::delete_rule(self : Self, index : Int) -> Unit {
  self.call("deleteRule", [index]) |> ignore
}

///|
/// Returns the owner node
pub fn CSSStyleSheet::owner_node(self : Self) -> Js? {
  self.get("ownerNode") |> @js.unsafe_cast_option()
}

///|
/// Returns whether the stylesheet is disabled
pub fn CSSStyleSheet::disabled(self : Self) -> Bool {
  unsafe_cast(self.get("disabled"))
}

///|
/// Sets whether the stylesheet is disabled
pub fn CSSStyleSheet::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled) |> ignore
}

///|
/// Returns the stylesheet's href
pub fn CSSStyleSheet::href(self : Self) -> String? {
  self.get("href") |> @js.unsafe_cast_option()
}

///|
/// Returns the stylesheet's title
pub fn CSSStyleSheet::title(self : Self) -> String? {
  self.get("title") |> @js.unsafe_cast_option()
}

///|
/// Returns the stylesheet's media
pub fn CSSStyleSheet::media(self : Self) -> Js {
  self.get("media")
}

///|
/// MediaQueryList represents a media query list
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList
#external
pub type MediaQueryList

///|
pub impl JsImpl for MediaQueryList

///|
/// Creates a MediaQueryList from window.matchMedia
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia
#alias(match_media)
pub fn matchMedia(query : String) -> MediaQueryList {
  unsafe_cast(@js.global_this().call("matchMedia", [query]))
}

///|
/// Returns the media query string
pub fn MediaQueryList::media(self : Self) -> String {
  unsafe_cast(self.get("media"))
}

///|
/// Returns whether the media query matches
pub fn MediaQueryList::matches(self : Self) -> Bool {
  unsafe_cast(self.get("matches"))
}

///|
/// Adds a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/addListener
pub fn MediaQueryList::add_listener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.call("addListener", [listener |> @js.from_fn1]) |> ignore
}

///|
/// Removes a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/removeListener
pub fn MediaQueryList::remove_listener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.call("removeListener", [listener |> @js.from_fn1]) |> ignore
}

///|
/// Add event listener for change event
pub fn MediaQueryList::add_change_listener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self.call("addEventListener", ["change", listener |> @js.from_fn1]) |> ignore
}

///|
/// Remove event listener for change event
pub fn MediaQueryList::remove_change_listener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self.call("removeEventListener", ["change", listener |> @js.from_fn1])
  |> ignore
}

///|
/// CSS Helper Functions

///|
/// Escapes a CSS identifier
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS/escape
#alias(css_escape)
pub fn cssEscape(value : String) -> String {
  let css_obj = @js.global_this().get("CSS")
  unsafe_cast(css_obj.call("escape", [value]))
}

///|
/// Checks if a CSS property/value is supported
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS/supports
#alias(css_supports)
pub fn cssSupports(property : String, value : String) -> Bool {
  let css_obj = @js.global_this().get("CSS")
  unsafe_cast(css_obj.call("supports", [property, value]))
}

///|
/// Checks if a CSS condition is supported
#alias(css_supports_condition)
pub fn cssSupportsCondition(condition : String) -> Bool {
  let css_obj = @js.global_this().get("CSS")
  unsafe_cast(css_obj.call("supports", [condition]))
}

///|
/// Access document stylesheets
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/styleSheets
pub fn Document::style_sheets(self : Self) -> Js {
  self.get("styleSheets")
}

///|
/// Create a new stylesheet
pub fn Document::create_stylesheet(self : Self) -> CSSStyleSheet {
  let style = self.create_element("style")
  match self.head() {
    Some(head) => head.call("appendChild", [style]) |> ignore
    None => ()
  }
  unsafe_cast(style.get("sheet"))
}
