///|
/// CSS Typed Object Model and utilities
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS_Object_Model

///|
/// CSSStyleDeclaration represents a CSS declaration block
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration
#external
pub type CSSStyleDeclaration

///|
pub impl Js for CSSStyleDeclaration with to_js(self) -> Val {
  self |> js
}

///|
/// Returns a CSS style declaration from a Val
pub fn css_style_from_val(val : Val) -> CSSStyleDeclaration {
  unsafe_cast(val)
}

///|
/// Gets a CSS property value
pub fn CSSStyleDeclaration::get_property_value(
  self : Self,
  property : String,
) -> String {
  self.invoke("getPropertyValue", [property |> js]) |> unsafe_cast
}

///|
/// Sets a CSS property value
pub fn CSSStyleDeclaration::set_property(
  self : Self,
  property : String,
  value : String,
) -> Unit {
  self.invoke("setProperty", [property |> js, value |> js]) |> ignore
}

///|
/// Sets a CSS property value with priority
pub fn CSSStyleDeclaration::set_property_priority(
  self : Self,
  property : String,
  value : String,
  priority : String,
) -> Unit {
  self.invoke("setProperty", [property, value, priority]) |> ignore
}

///|
/// Removes a CSS property
pub fn CSSStyleDeclaration::remove_property(
  self : Self,
  property : String,
) -> String {
  self.invoke("removeProperty", [property |> js]) |> unsafe_cast
}

///|
/// Gets the priority of a CSS property
pub fn CSSStyleDeclaration::get_property_priority(
  self : Self,
  property : String,
) -> String {
  self.invoke("getPropertyPriority", [property |> js]) |> unsafe_cast
}

///|
/// Returns the CSS text
pub fn CSSStyleDeclaration::css_text(self : Self) -> String {
  unsafe_cast(self.to_js().get("cssText"))
}

///|
/// Sets the CSS text
pub fn CSSStyleDeclaration::set_css_text(self : Self, text : String) -> Unit {
  self.to_js().set("cssText", text |> js) |> ignore
}

///|
/// Returns the number of CSS properties
pub fn CSSStyleDeclaration::length(self : Self) -> Int {
  unsafe_cast(self.to_js().get("length"))
}

///|
/// Returns the parent CSS rule
pub fn CSSStyleDeclaration::parent_rule(self : Self) -> CSSRule? {
  self.to_js().get("parentRule") |> to_option
}

///|
/// CSSRule represents a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSRule
#external
pub type CSSRule

///|
pub impl Js for CSSRule with to_js(self) -> Val {
  self |> js
}

///|
/// Returns the CSS text of the rule
pub fn CSSRule::css_text(self : Self) -> String {
  unsafe_cast(self.to_js().get("cssText"))
}

///|
/// Sets the CSS text of the rule
pub fn CSSRule::set_css_text(self : Self, text : String) -> Unit {
  self.to_js().set("cssText", text |> js) |> ignore
}

///|
/// Returns the parent rule
pub fn CSSRule::parent_rule(self : Self) -> CSSRule? {
  self.to_js().get("parentRule") |> to_option()
}

///|
/// Returns the parent stylesheet
pub fn CSSRule::parent_stylesheet(self : Self) -> CSSStyleSheet? {
  self.to_js().get("parentStyleSheet") |> to_option()
}

///|
/// Returns the rule type
pub fn CSSRule::rule_type(self : Self) -> Int {
  unsafe_cast(self.to_js().get("type"))
}

///|
/// CSSStyleSheet represents a stylesheet
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet
#external
pub type CSSStyleSheet

///|
pub impl Js for CSSStyleSheet with to_js(self) -> Val {
  self |> js
}

///|
/// Returns the CSS rules
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/cssRules
pub fn CSSStyleSheet::css_rules(self : Self) -> Val {
  self.to_js().get("cssRules")
}

///|
/// Inserts a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/insertRule
pub fn CSSStyleSheet::insert_rule(self : Self, rule : String) -> Int {
  self.invoke("insertRule", [rule |> js]) |> unsafe_cast
}

///|
/// Inserts a CSS rule at index
pub fn CSSStyleSheet::insert_rule_at(
  self : Self,
  rule : String,
  index : Int,
) -> Int {
  self.invoke("insertRule", [rule |> js, index |> js]) |> unsafe_cast
}

///|
/// Deletes a CSS rule at index
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/deleteRule
pub fn CSSStyleSheet::delete_rule(self : Self, index : Int) -> Unit {
  self.invoke("deleteRule", [index]) |> ignore
}

///|
/// Returns the owner node
pub fn CSSStyleSheet::owner_node(self : Self) -> Val? {
  self.get("ownerNode") |> to_option()
}

///|
/// Returns whether the stylesheet is disabled
pub fn CSSStyleSheet::disabled(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("disabled"))
}

///|
/// Sets whether the stylesheet is disabled
pub fn CSSStyleSheet::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled |> js) |> ignore
}

///|
/// Returns the stylesheet's href
pub fn CSSStyleSheet::href(self : Self) -> String? {
  self.get("href") |> to_option()
}

///|
/// Returns the stylesheet's title
pub fn CSSStyleSheet::title(self : Self) -> String? {
  self.get("title") |> to_option()
}

///|
/// Returns the stylesheet's media
pub fn CSSStyleSheet::media(self : Self) -> Val {
  self.get("media")
}

///|
/// MediaQueryList represents a media query list
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList
#external
pub type MediaQueryList

///|
pub impl Js for MediaQueryList with to_js(self) -> Val {
  self |> js
}

///|
/// Creates a MediaQueryList from window.matchMedia
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia
pub fn match_media(query : String) -> MediaQueryList {
  unsafe_cast(@js.global_this().invoke("matchMedia", [query |> js]))
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
  self.invoke("addListener", [listener |> js]) |> ignore
}

///|
/// Removes a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/removeListener
pub fn MediaQueryList::remove_listener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.invoke("removeListener", [listener |> js]) |> ignore
}

///|
/// Add event listener for change event
pub fn MediaQueryList::add_change_listener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self.invoke("addEventListener", ["change" |> js, listener |> js]) |> ignore
}

///|
/// Remove event listener for change event
pub fn MediaQueryList::remove_change_listener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self.invoke("removeEventListener", ["change" |> js, listener |> js]) |> ignore
}

///|
/// CSS Helper Functions

///|
/// Escapes a CSS identifier
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS/escape
pub fn css_escape(value : String) -> String {
  let css_obj = @js.global_this().get("CSS")
  unsafe_cast(css_obj.invoke("escape", [value |> js]))
}

///|
/// Checks if a CSS property/value is supported
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS/supports
pub fn css_supports(property : String, value : String) -> Bool {
  let css_obj = @js.global_this().get("CSS")
  unsafe_cast(css_obj.invoke("supports", [property |> js, value |> js]))
}

///|
/// Checks if a CSS condition is supported
pub fn css_supports_condition(condition : String) -> Bool {
  let css_obj = @js.global_this().get("CSS")
  unsafe_cast(css_obj.invoke("supports", [condition |> js]))
}

///|
/// Access document stylesheets
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/styleSheets
pub fn Document::style_sheets(self : Self) -> Val {
  self.to_js().get("styleSheets")
}

///|
/// Create a new stylesheet
pub fn Document::create_stylesheet(self : Self) -> CSSStyleSheet {
  let style = self.create_element("style")
  match self.head() {
    Some(head) => head.invoke("appendChild", [style]) |> ignore
    None => ()
  }
  unsafe_cast(style.to_js().get("sheet"))
}
