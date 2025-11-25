///|
/// CSS Typed Object Model and utilities
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS_Object_Model

///|
/// CSSStyleDeclaration represents a CSS declaration block
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration
pub(all) struct CSSStyleDeclaration {
  mut cssText : String
  length : Int
  parentRule : CSSRule?
}

///|
pub impl @js.JsImpl for CSSStyleDeclaration

///|
/// Returns a CSS style declaration from a Val
pub fn css_style_from_val(val : @js.Any) -> CSSStyleDeclaration {
  @js.identity(val)
}

///|
/// Gets a CSS property value
pub fn CSSStyleDeclaration::get_property_value(
  self : Self,
  property : String,
) -> String {
  self.call1("getPropertyValue", property).cast()
}

///|
/// Sets a CSS property value
pub fn CSSStyleDeclaration::set_property(
  self : Self,
  property : String,
  value : String,
) -> Unit {
  self.call2("setProperty", property, value).cast()
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
  self.call1("removeProperty", property).cast()
}

///|
/// Gets the priority of a CSS property
pub fn CSSStyleDeclaration::get_property_priority(
  self : Self,
  property : String,
) -> String {
  self.call1("getPropertyPriority", property).cast()
}

///|
/// CSSRule represents a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSRule
#external
pub type CSSRule

///|
pub impl @js.JsImpl for CSSRule

///|
/// Returns the CSS text of the rule
pub fn CSSRule::css_text(self : Self) -> String {
  self.get("cssText").cast()
}

///|
/// Sets the CSS text of the rule
pub fn CSSRule::set_css_text(self : Self, text : String) -> Unit {
  self.set("cssText", text) |> ignore
}

///|
/// Returns the parent rule
pub fn CSSRule::parent_rule(self : Self) -> CSSRule? {
  self.get("parentRule") |> @js.identity_option()
}

///|
/// Returns the parent stylesheet
pub fn CSSRule::parent_stylesheet(self : Self) -> CSSStyleSheet? {
  self.get("parentStyleSheet") |> @js.identity_option()
}

///|
/// Returns the rule type
pub fn CSSRule::rule_type(self : Self) -> Int {
  self.get("type").cast()
}

///|
/// CSSStyleSheet represents a stylesheet
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet
#external
pub type CSSStyleSheet

///|
pub impl @js.JsImpl for CSSStyleSheet

///|
/// Returns the CSS rules
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/cssRules
pub fn CSSStyleSheet::cssRules(self : Self) -> @js.Any {
  self.get("cssRules")
}

///|
/// Inserts a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/insertRule
pub fn CSSStyleSheet::insertRule(self : Self, rule : String) -> Int {
  self.call1("insertRule", rule).cast()
}

///|
/// Inserts a CSS rule at index
pub fn CSSStyleSheet::insertRuleAt(
  self : Self,
  rule : String,
  index : Int,
) -> Int {
  self.call2("insertRule", rule, index).cast()
}

///|
/// Deletes a CSS rule at index
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/deleteRule
pub fn CSSStyleSheet::deleteRule(self : Self, index : Int) -> Unit {
  self.call1("deleteRule", index) |> ignore
}

///|
/// Returns the owner node
pub fn CSSStyleSheet::ownerNode(self : Self) -> @js.Any? {
  self.get("ownerNode") |> @js.identity_option()
}

///|
/// Returns whether the stylesheet is disabled
pub fn CSSStyleSheet::disabled(self : Self) -> Bool {
  self.get("disabled").cast()
}

///|
/// Sets whether the stylesheet is disabled
pub fn CSSStyleSheet::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.set("disabled", disabled) |> ignore
}

///|
/// Returns the stylesheet's href
pub fn CSSStyleSheet::href(self : Self) -> String? {
  self.get("href") |> @js.identity_option()
}

///|
/// Returns the stylesheet's title
pub fn CSSStyleSheet::title(self : Self) -> String? {
  self.get("title") |> @js.identity_option()
}

///|
/// Returns the stylesheet's media
pub fn CSSStyleSheet::media(self : Self) -> @js.Any {
  self.get("media")
}

///|
/// MediaQueryList represents a media query list
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList
pub(all) struct MediaQueryList {
  media : String
  matches : Bool
}

///|
pub impl @js.JsImpl for MediaQueryList

///|
/// Creates a MediaQueryList from window.matchMedia
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia
#alias(match_media)
pub fn matchMedia(query : String) -> MediaQueryList {
  @js.identity(@js.global_this().call1("matchMedia", query))
}

///|
/// Adds a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/addListener
pub fn MediaQueryList::addListener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.call1("addListener", listener |> @js.from_fn1) |> ignore
}

///|
/// Removes a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/removeListener
pub fn MediaQueryList::removeListener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.call1("removeListener", listener |> @js.from_fn1) |> ignore
}

///|
/// Add event listener for change event
pub fn MediaQueryList::addChangeListener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self.call2("addEventListener", "change", listener |> @js.from_fn1) |> ignore
}

///|
/// Remove event listener for change event
pub fn MediaQueryList::removeChangeListener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self.call2("removeEventListener", "change", listener |> @js.from_fn1)
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
  @js.identity(css_obj.call1("escape", value))
}

///|
/// Checks if a CSS property/value is supported
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS/supports
#alias(css_supports)
pub fn cssSupports(property : String, value : String) -> Bool {
  let css_obj = @js.global_this().get("CSS")
  css_obj.call2("supports", property, value).cast()
}

///|
/// Checks if a CSS condition is supported
#alias(css_supports_condition)
pub fn cssSupportsCondition(condition : String) -> Bool {
  let css_obj = @js.global_this().get("CSS")
  @js.identity(css_obj.call1("supports", condition))
}

///|
/// Access document stylesheets
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/styleSheets
pub fn Document::styleSheets(self : Self) -> @js.Any {
  self.get("styleSheets")
}

///|
/// Create a new stylesheet
pub fn Document::createStylesheet(self : Self) -> CSSStyleSheet {
  let style = self.create_element("style")
  match self.head() {
    Some(head) => head.call1("appendChild", style) |> ignore
    None => ()
  }
  style.get("sheet").cast()
}
