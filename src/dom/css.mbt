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
  val.cast()
}

///|
/// Gets a CSS property value
pub fn CSSStyleDeclaration::get_property_value(
  self : Self,
  property : String,
) -> String {
  self.to_js().call_method("getPropertyValue", [property |> js]).cast()
}

///|
/// Sets a CSS property value
pub fn CSSStyleDeclaration::set_property(
  self : Self,
  property : String,
  value : String,
) -> Unit {
  self.to_js().call_method("setProperty", [property |> js, value |> js])
  |> ignore
}

///|
/// Sets a CSS property value with priority
pub fn CSSStyleDeclaration::set_property_priority(
  self : Self,
  property : String,
  value : String,
  priority : String,
) -> Unit {
  self
  .to_js()
  .call_method("setProperty", [property |> js, value |> js, priority |> js])
  |> ignore
}

///|
/// Removes a CSS property
pub fn CSSStyleDeclaration::remove_property(
  self : Self,
  property : String,
) -> String {
  self.to_js().call_method("removeProperty", [property |> js]).cast()
}

///|
/// Gets the priority of a CSS property
pub fn CSSStyleDeclaration::get_property_priority(
  self : Self,
  property : String,
) -> String {
  self.to_js().call_method("getPropertyPriority", [property |> js]).cast()
}

///|
/// Returns the CSS text
pub fn CSSStyleDeclaration::css_text(self : Self) -> String {
  self.to_js().get("cssText").cast()
}

///|
/// Sets the CSS text
pub fn CSSStyleDeclaration::set_css_text(self : Self, text : String) -> Unit {
  self.to_js().set("cssText", text |> js) |> ignore
}

///|
/// Returns the number of CSS properties
pub fn CSSStyleDeclaration::length(self : Self) -> Int {
  self.to_js().get("length").cast()
}

///|
/// Returns the parent CSS rule
pub fn CSSStyleDeclaration::parent_rule(self : Self) -> CSSRule? {
  self.to_js().get("parentRule").cast_option()
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
  self.to_js().get("cssText").cast()
}

///|
/// Sets the CSS text of the rule
pub fn CSSRule::set_css_text(self : Self, text : String) -> Unit {
  self.to_js().set("cssText", text |> js) |> ignore
}

///|
/// Returns the parent rule
pub fn CSSRule::parent_rule(self : Self) -> CSSRule? {
  self.to_js().get("parentRule").cast_option()
}

///|
/// Returns the parent stylesheet
pub fn CSSRule::parent_stylesheet(self : Self) -> CSSStyleSheet? {
  self.to_js().get("parentStyleSheet").cast_option()
}

///|
/// Returns the rule type
pub fn CSSRule::rule_type(self : Self) -> Int {
  self.to_js().get("type").cast()
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
  self.to_js().call_method("insertRule", [rule |> js]).cast()
}

///|
/// Inserts a CSS rule at index
pub fn CSSStyleSheet::insert_rule_at(
  self : Self,
  rule : String,
  index : Int,
) -> Int {
  self.to_js().call_method("insertRule", [rule |> js, index |> js]).cast()
}

///|
/// Deletes a CSS rule at index
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/deleteRule
pub fn CSSStyleSheet::delete_rule(self : Self, index : Int) -> Unit {
  self.to_js().call_method("deleteRule", [index |> js]) |> ignore
}

///|
/// Returns the owner node
pub fn CSSStyleSheet::owner_node(self : Self) -> Element? {
  self.to_js().get("ownerNode").cast_option()
}

///|
/// Returns whether the stylesheet is disabled
pub fn CSSStyleSheet::disabled(self : Self) -> Bool {
  self.to_js().get("disabled").cast()
}

///|
/// Sets whether the stylesheet is disabled
pub fn CSSStyleSheet::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.to_js().set("disabled", disabled |> js) |> ignore
}

///|
/// Returns the stylesheet's href
pub fn CSSStyleSheet::href(self : Self) -> String? {
  self.to_js().get("href").cast_option()
}

///|
/// Returns the stylesheet's title
pub fn CSSStyleSheet::title(self : Self) -> String? {
  self.to_js().get("title").cast_option()
}

///|
/// Returns the stylesheet's media
pub fn CSSStyleSheet::media(self : Self) -> Val {
  self.to_js().get("media")
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
  @js.global_this().call_method("matchMedia", [query |> js]).cast()
}

///|
/// Returns the media query string
pub fn MediaQueryList::media(self : Self) -> String {
  self.to_js().get("media").cast()
}

///|
/// Returns whether the media query matches
pub fn MediaQueryList::matches(self : Self) -> Bool {
  self.to_js().get("matches").cast()
}

///|
/// Adds a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/addListener
pub fn MediaQueryList::add_listener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.to_js().call_method("addListener", [listener |> js]) |> ignore
}

///|
/// Removes a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/removeListener
pub fn MediaQueryList::remove_listener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.to_js().call_method("removeListener", [listener |> js]) |> ignore
}

///|
/// Add event listener for change event
pub fn MediaQueryList::add_change_listener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self.to_js().call_method("addEventListener", ["change" |> js, listener |> js])
  |> ignore
}

///|
/// Remove event listener for change event
pub fn MediaQueryList::remove_change_listener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self
  .to_js()
  .call_method("removeEventListener", ["change" |> js, listener |> js])
  |> ignore
}

///|
/// CSS Helper Functions

///|
/// Escapes a CSS identifier
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS/escape
pub fn css_escape(value : String) -> String {
  let css_obj = @js.global_this().get("CSS")
  css_obj.call_method("escape", [value |> js]).cast()
}

///|
/// Checks if a CSS property/value is supported
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS/supports
pub fn css_supports(property : String, value : String) -> Bool {
  let css_obj = @js.global_this().get("CSS")
  css_obj.call_method("supports", [property |> js, value |> js]).cast()
}

///|
/// Checks if a CSS condition is supported
pub fn css_supports_condition(condition : String) -> Bool {
  let css_obj = @js.global_this().get("CSS")
  css_obj.call_method("supports", [condition |> js]).cast()
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
  self.head().append_child(style) |> ignore
  style.to_js().get("sheet").cast()
}
