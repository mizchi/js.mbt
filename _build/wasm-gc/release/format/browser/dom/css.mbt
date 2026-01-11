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
pub fn CSSStyleDeclaration::as_any(self : CSSStyleDeclaration) -> @core.Any = "%identity"

///|
/// Returns a CSS style declaration from a Val
pub fn css_style_from_val(val : @core.Any) -> CSSStyleDeclaration {
  @core.identity(val)
}

///|
/// Gets a CSS property value
pub fn CSSStyleDeclaration::get_property_value(
  self : Self,
  property : String,
) -> String {
  self.as_any()._call("getPropertyValue", [@core.any(property)]).cast()
}

///|
/// Sets a CSS property value
pub fn CSSStyleDeclaration::set_property(
  self : Self,
  property : String,
  value : String,
) -> Unit {
  self.as_any()._call("setProperty", [@core.any(property), @core.any(value)])
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
    @core.any(property),
    @core.any(value),
    @core.any(priority),
  ])
  |> ignore
}

///|
/// Removes a CSS property
pub fn CSSStyleDeclaration::remove_property(
  self : Self,
  property : String,
) -> String {
  self.as_any()._call("removeProperty", [@core.any(property)]).cast()
}

///|
/// Gets the priority of a CSS property
pub fn CSSStyleDeclaration::get_property_priority(
  self : Self,
  property : String,
) -> String {
  self.as_any()._call("getPropertyPriority", [@core.any(property)]).cast()
}

///|
/// CSSRule represents a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSRule
#external
pub type CSSRule

///|
pub fn CSSRule::as_any(self : CSSRule) -> @core.Any = "%identity"

///|
/// Returns the CSS text of the rule
pub fn CSSRule::css_text(self : Self) -> String {
  self.as_any()._get("cssText").cast()
}

///|
/// Sets the CSS text of the rule
pub fn CSSRule::set_css_text(self : Self, text : String) -> Unit {
  self.as_any()._set("cssText", @core.any(text)) |> ignore
}

///|
/// Returns the parent rule
pub fn CSSRule::parent_rule(self : Self) -> CSSRule? {
  let v : @core.Any = self.as_any()._get("parentRule").cast()
  v |> @core.identity_option()
}

///|
/// Returns the parent stylesheet
pub fn CSSRule::parent_stylesheet(self : Self) -> CSSStyleSheet? {
  let v : @core.Any = self.as_any()._get("parentStyleSheet").cast()
  v |> @core.identity_option()
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
pub fn CSSStyleSheet::as_any(self : CSSStyleSheet) -> @core.Any = "%identity"

///|
/// Returns the CSS rules
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/cssRules
pub fn CSSStyleSheet::cssRules(self : Self) -> @core.Any {
  self.as_any()._get("cssRules").cast()
}

///|
/// Inserts a CSS rule
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/insertRule
pub fn CSSStyleSheet::insertRule(self : Self, rule : String) -> Int {
  self.as_any()._call("insertRule", [@core.any(rule)]).cast()
}

///|
/// Inserts a CSS rule at index
pub fn CSSStyleSheet::insertRuleAt(
  self : Self,
  rule : String,
  index : Int,
) -> Int {
  self.as_any()._call("insertRule", [@core.any(rule), @core.any(index)]).cast()
}

///|
/// Deletes a CSS rule at index
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/deleteRule
pub fn CSSStyleSheet::deleteRule(self : Self, index : Int) -> Unit {
  self.as_any()._call("deleteRule", [@core.any(index)]) |> ignore
}

///|
/// Returns the owner node
pub fn CSSStyleSheet::ownerNode(self : Self) -> @core.Any? {
  let v : @core.Any = self.as_any()._get("ownerNode").cast()
  v |> @core.identity_option()
}

///|
/// Returns whether the stylesheet is disabled
pub fn CSSStyleSheet::disabled(self : Self) -> Bool {
  self.as_any()._get("disabled").cast()
}

///|
/// Sets whether the stylesheet is disabled
pub fn CSSStyleSheet::set_disabled(self : Self, disabled : Bool) -> Unit {
  self.as_any()._set("disabled", @core.any(disabled)) |> ignore
}

///|
/// Returns the stylesheet's href
pub fn CSSStyleSheet::href(self : Self) -> String? {
  let v : @core.Any = self.as_any()._get("href").cast()
  v |> @core.identity_option()
}

///|
/// Returns the stylesheet's title
pub fn CSSStyleSheet::title(self : Self) -> String? {
  let v : @core.Any = self.as_any()._get("title").cast()
  v |> @core.identity_option()
}

///|
/// Returns the stylesheet's media
pub fn CSSStyleSheet::media(self : Self) -> @core.Any {
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
pub fn MediaQueryList::as_any(self : MediaQueryList) -> @core.Any = "%identity"

///|
/// Creates a MediaQueryList from window.matchMedia
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia
#alias(match_media)
pub fn matchMedia(query : String) -> MediaQueryList {
  @core.identity(@core.global_this()._call("matchMedia", [@core.any(query)]))
}

///|
/// Adds a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/addListener
pub fn MediaQueryList::addListener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.as_any()._call("addListener", [@core.any(@js.from_fn1(listener))])
  |> ignore
}

///|
/// Removes a change listener
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/removeListener
pub fn MediaQueryList::removeListener(
  self : Self,
  listener : (MediaQueryList) -> Unit,
) -> Unit {
  self.as_any()._call("removeListener", [@core.any(@js.from_fn1(listener))])
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
    @core.any("change"),
    @core.any(@js.from_fn1(listener)),
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
    @core.any("change"),
    @core.any(@js.from_fn1(listener)),
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
  let css_obj = @core.global_this()._get("CSS")
  @core.identity(css_obj._call("escape", [@core.any(value)]))
}

///|
/// Checks if a CSS property/value is supported
/// https://developer.mozilla.org/en-US/docs/Web/API/CSS/supports
#alias(css_supports)
pub fn cssSupports(property : String, value : String) -> Bool {
  let css_obj = @core.global_this()._get("CSS")
  css_obj._call("supports", [@core.any(property), @core.any(value)]).cast()
}

///|
/// Checks if a CSS condition is supported
#alias(css_supports_condition)
pub fn cssSupportsCondition(condition : String) -> Bool {
  let css_obj = @core.global_this()._get("CSS")
  @core.identity(css_obj._call("supports", [@core.any(condition)]))
}

///|
/// Access document stylesheets
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/styleSheets
pub fn Document::styleSheets(self : Self) -> @core.Any {
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
