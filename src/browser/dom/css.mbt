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
pub fn CSSStyleDeclaration::as_any(self : CSSStyleDeclaration) -> @nostd.Any = "%identity"

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
  self.as_any()._call("getPropertyValue", [@nostd.any(property)]).cast()
}

///|
/// Sets a CSS property value
pub fn CSSStyleDeclaration::set_property(
  self : Self,
  property : String,
  value : String,
) -> Unit {
  self.as_any()._call("setProperty", [@nostd.any(property), @nostd.any(value)])
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
  .as_any()
  ._call("setProperty", [
    @nostd.any(property),
    @nostd.any(value),
    @nostd.any(priority),
  ])
  |> ignore
}

///|
/// Removes a CSS property
pub fn CSSStyleDeclaration::remove_property(
  self : Self,
  property : String,
) -> String {
  self.as_any()._call("removeProperty", [@nostd.any(property)]).cast()
}

///|
/// Gets the priority of a CSS property
pub fn CSSStyleDeclaration::get_property_priority(
  self : Self,
  property : String,
) -> String {
  self.as_any()._call("getPropertyPriority", [@nostd.any(property)]).cast()
}

///|
/// CSSRule represents a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSRule
#external
pub type CSSRule

///|
pub fn CSSRule::as_any(self : CSSRule) -> @nostd.Any = "%identity"

///|
/// Returns the CSS text of the rule
pub fn CSSRule::css_text(self : Self) -> String {
  self.as_any()._get("cssText").cast()
}

///|
/// Sets the CSS text of the rule
pub fn CSSRule::set_css_text(self : Self, text : String) -> Unit {
  self.as_any()._set("cssText", @nostd.any(text)) |> ignore
}

///|
/// Returns the parent rule
pub fn CSSRule::parent_rule(self : Self) -> CSSRule? {
  let v : @js.Any = self.as_any()._get("parentRule").cast()
  v |> @js.identity_option()
}

///|
/// Returns the parent stylesheet
pub fn CSSRule::parent_stylesheet(self : Self) -> CSSStyleSheet? {
  let v : @js.Any = self.as_any()._get("parentStyleSheet").cast()
  v |> @js.identity_option()
}

///|
/// Returns the rule type
pub fn CSSRule::rule_type(self : Self) -> Int {
  self.as_any()._get("type").cast()
}

///|
/// CSSStyleSheet represents a stylesheet
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet
#external
pub type CSSStyleSheet

///|
pub fn CSSStyleSheet::as_any(self : CSSStyleSheet) -> @nostd.Any = "%identity"

///|
/// Returns the CSS rules
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/cssRules
pub fn CSSStyleSheet::cssRules(self : Self) -> @js.Any {
  self.as_any()._get("cssRules").cast()
}

///|
/// Inserts a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/insertRule
pub fn CSSStyleSheet::insertRule(self : Self, rule : String) -> Int {
  self.as_any()._call("insertRule", [@nostd.any(rule)]).cast()
}

///|
/// Inserts a CSS rule at index
pub fn CSSStyleSheet::insertRuleAt(
  self : Self,
  rule : String,
  index : Int,
) -> Int {
  self
  .as_any()
  ._call("insertRule", [@nostd.any(rule), @nostd.any(index)])
  .cast()
}

///|
/// Deletes a CSS rule at index
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/deleteRule
pub fn CSSStyleSheet::deleteRule(self : Self, index : Int) -> Unit {
  self.as_any()._call("deleteRule", [@nostd.any(index)]) |> ignore
}

///|
/// Returns the owner node
pub fn CSSStyleSheet::ownerNode(self : Self) -> @js.Any? {
  let v : @js.Any = self.as_any()._get("ownerNode").cast()
  v |> @js.identity_option()
}

///|
/// Returns whether the stylesheet is disabled
pub fn CSSStyleSheet::disabled(self : Self) -> Bool {
  self.as_any()._get("disabled").cast()
}

///|
/// Sets whether the stylesheet is disabled
pub fn CSSStyleSheet::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.as_any()._set("disabled", @nostd.any(disabled)) |> ignore
}

///|
/// Returns the stylesheet's href
pub fn CSSStyleSheet::href(self : Self) -> String? {
  let v : @js.Any = self.as_any()._get("href").cast()
  v |> @js.identity_option()
}

///|
/// Returns the stylesheet's title
pub fn CSSStyleSheet::title(self : Self) -> String? {
  let v : @js.Any = self.as_any()._get("title").cast()
  v |> @js.identity_option()
}

///|
/// Returns the stylesheet's media
pub fn CSSStyleSheet::media(self : Self) -> @js.Any {
  self.as_any()._get("media").cast()
}

///|
/// MediaQueryList represents a media query list
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList
pub(all) struct MediaQueryList {
  media : String
  matches : Bool
}

///|
pub fn MediaQueryList::as_any(self : MediaQueryList) -> @nostd.Any = "%identity"

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
  self.as_any()._call("addListener", [@nostd.any(@js.from_fn1(listener))])
  |> ignore
}

///|
/// Removes a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/removeListener
pub fn MediaQueryList::removeListener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.as_any()._call("removeListener", [@nostd.any(@js.from_fn1(listener))])
  |> ignore
}

///|
/// Add event listener for change event
pub fn MediaQueryList::addChangeListener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self
  .as_any()
  ._call("addEventListener", [
    @nostd.any("change"),
    @nostd.any(@js.from_fn1(listener)),
  ])
  |> ignore
}

///|
/// Remove event listener for change event
pub fn MediaQueryList::removeChangeListener(
  self : Self,
  listener : (Event) -> Unit,
) -> Unit {
  self
  .as_any()
  ._call("removeEventListener", [
    @nostd.any("change"),
    @nostd.any(@js.from_fn1(listener)),
  ])
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
  self.as_any()._get("styleSheets").cast()
}

///|
/// Create a new stylesheet
pub fn Document::createStylesheet(self : Self) -> CSSStyleSheet {
  let style = self.create_element("style")
  match self.head() {
    Some(head) => head.as_node().appendChild(style.as_node()) |> ignore
    None => ()
  }
  style.as_any()._get("sheet").cast()
}
