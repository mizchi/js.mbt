///|
/// CSS styling utilities for DOM elements
/// https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration

///|
/// Returns the computed style of an element
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/getComputedStyle
pub extern "js" fn get_computed_style(el : Element) -> Val =
  #| (el) => window.getComputedStyle(el)

///|
/// Returns the computed style with pseudo-element
pub extern "js" fn get_computed_style_with_pseudo(
  el : Element,
  pseudo_element : String,
) -> Val =
  #| (el, pseudo) => window.getComputedStyle(el, pseudo)

///|
/// Gets the inline style object of an element
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/style
pub fn Element::style(self : Self) -> Val {
  self.to_js().get("style")
}

///|
/// Sets a CSS property on the element's inline style
pub fn Element::set_style_property(
  self : Self,
  property : String,
  value : String,
) -> Unit {
  self.style().call_method("setProperty", [property |> js, value |> js])
  |> ignore
}

///|
/// Gets a CSS property value from the element's inline style
pub fn Element::get_style_property(self : Self, property : String) -> String {
  self.style().call_method("getProperty", [property |> js]).cast()
}

///|
/// Removes a CSS property from the element's inline style
pub fn Element::remove_style_property(self : Self, property : String) -> Unit {
  self.style().call_method("removeProperty", [property |> js]) |> ignore
}

///|
/// Sets a CSS property with priority (e.g., "important")
pub fn Element::set_style_property_priority(
  self : Self,
  property : String,
  value : String,
  priority : String,
) -> Unit {
  self
  .style()
  .call_method("setProperty", [property |> js, value |> js, priority |> js])
  |> ignore
}

///|
/// Gets the priority of a CSS property
pub fn Element::get_style_property_priority(
  self : Self,
  property : String,
) -> String {
  self.style().call_method("getPropertyPriority", [property |> js]).cast()
}

///|
/// Gets the full CSS text of the inline style
pub fn Element::css_text(self : Self) -> String {
  self.style().get("cssText").cast()
}

///|
/// Sets the full CSS text of the inline style
pub fn Element::set_css_text(self : Self, css : String) -> Unit {
  self.style().set("cssText", css |> js) |> ignore
}

///|
/// Gets the number of CSS properties in the inline style
pub fn Element::style_length(self : Self) -> Int {
  self.style().get("length").cast()
}

///|
/// Convenience methods for common CSS properties

///|
/// Sets the display property
pub fn Element::set_display(self : Self, value : String) -> Unit {
  self.style().set("display", value |> js) |> ignore
}

///|
/// Gets the display property
pub fn Element::get_display(self : Self) -> String {
  self.style().get("display").cast()
}

///|
/// Sets the visibility property
pub fn Element::set_visibility(self : Self, value : String) -> Unit {
  self.style().set("visibility", value |> js) |> ignore
}

///|
/// Gets the visibility property
pub fn Element::get_visibility(self : Self) -> String {
  self.style().get("visibility").cast()
}

///|
/// Sets the opacity property
pub fn Element::set_opacity(self : Self, value : Double) -> Unit {
  self.style().set("opacity", value.to_string() |> js) |> ignore
}

///|
/// Gets the opacity property
pub fn Element::get_opacity(self : Self) -> String {
  self.style().get("opacity").cast()
}

///|
/// Sets the position property
pub fn Element::set_position(self : Self, value : String) -> Unit {
  self.style().set("position", value |> js) |> ignore
}

///|
/// Gets the position property
pub fn Element::get_position(self : Self) -> String {
  self.style().get("position").cast()
}

///|
/// Sets the top property
pub fn Element::set_top(self : Self, value : String) -> Unit {
  self.style().set("top", value |> js) |> ignore
}

///|
/// Sets the left property
pub fn Element::set_left(self : Self, value : String) -> Unit {
  self.style().set("left", value |> js) |> ignore
}

///|
/// Sets the right property
pub fn Element::set_right(self : Self, value : String) -> Unit {
  self.style().set("right", value |> js) |> ignore
}

///|
/// Sets the bottom property
pub fn Element::set_bottom(self : Self, value : String) -> Unit {
  self.style().set("bottom", value |> js) |> ignore
}

///|
/// Sets the width property
pub fn Element::set_width(self : Self, value : String) -> Unit {
  self.style().set("width", value |> js) |> ignore
}

///|
/// Gets the width property
pub fn Element::get_width(self : Self) -> String {
  self.style().get("width").cast()
}

///|
/// Sets the height property
pub fn Element::set_height(self : Self, value : String) -> Unit {
  self.style().set("height", value |> js) |> ignore
}

///|
/// Gets the height property
pub fn Element::get_height(self : Self) -> String {
  self.style().get("height").cast()
}

///|
/// Sets the margin property
pub fn Element::set_margin(self : Self, value : String) -> Unit {
  self.style().set("margin", value |> js) |> ignore
}

///|
/// Sets the padding property
pub fn Element::set_padding(self : Self, value : String) -> Unit {
  self.style().set("padding", value |> js) |> ignore
}

///|
/// Sets the border property
pub fn Element::set_border(self : Self, value : String) -> Unit {
  self.style().set("border", value |> js) |> ignore
}

///|
/// Sets the background property
pub fn Element::set_background(self : Self, value : String) -> Unit {
  self.style().set("background", value |> js) |> ignore
}

///|
/// Sets the background-color property
pub fn Element::set_background_color(self : Self, value : String) -> Unit {
  self.style().set("backgroundColor", value |> js) |> ignore
}

///|
/// Gets the background-color property
pub fn Element::get_background_color(self : Self) -> String {
  self.style().get("backgroundColor").cast()
}

///|
/// Sets the color property
pub fn Element::set_color(self : Self, value : String) -> Unit {
  self.style().set("color", value |> js) |> ignore
}

///|
/// Gets the color property
pub fn Element::get_color(self : Self) -> String {
  self.style().get("color").cast()
}

///|
/// Sets the font-size property
pub fn Element::set_font_size(self : Self, value : String) -> Unit {
  self.style().set("fontSize", value |> js) |> ignore
}

///|
/// Gets the font-size property
pub fn Element::get_font_size(self : Self) -> String {
  self.style().get("fontSize").cast()
}

///|
/// Sets the font-family property
pub fn Element::set_font_family(self : Self, value : String) -> Unit {
  self.style().set("fontFamily", value |> js) |> ignore
}

///|
/// Sets the font-weight property
pub fn Element::set_font_weight(self : Self, value : String) -> Unit {
  self.style().set("fontWeight", value |> js) |> ignore
}

///|
/// Sets the text-align property
pub fn Element::set_text_align(self : Self, value : String) -> Unit {
  self.style().set("textAlign", value |> js) |> ignore
}

///|
/// Sets the z-index property
pub fn Element::set_z_index(self : Self, value : Int) -> Unit {
  self.style().set("zIndex", value.to_string() |> js) |> ignore
}

///|
/// Gets the z-index property
pub fn Element::get_z_index(self : Self) -> String {
  self.style().get("zIndex").cast()
}

///|
/// Sets the overflow property
pub fn Element::set_overflow(self : Self, value : String) -> Unit {
  self.style().set("overflow", value |> js) |> ignore
}

///|
/// Sets the cursor property
pub fn Element::set_cursor(self : Self, value : String) -> Unit {
  self.style().set("cursor", value |> js) |> ignore
}

///|
/// Sets the pointer-events property
pub fn Element::set_pointer_events(self : Self, value : String) -> Unit {
  self.style().set("pointerEvents", value |> js) |> ignore
}

///|
/// Sets the transform property
pub fn Element::set_transform(self : Self, value : String) -> Unit {
  self.style().set("transform", value |> js) |> ignore
}

///|
/// Sets the transition property
pub fn Element::set_transition(self : Self, value : String) -> Unit {
  self.style().set("transition", value |> js) |> ignore
}

///|
/// Sets the animation property
pub fn Element::set_animation(self : Self, value : String) -> Unit {
  self.style().set("animation", value |> js) |> ignore
}

///|
/// Sets the flex property
pub fn Element::set_flex(self : Self, value : String) -> Unit {
  self.style().set("flex", value |> js) |> ignore
}

///|
/// Sets the flex-direction property
pub fn Element::set_flex_direction(self : Self, value : String) -> Unit {
  self.style().set("flexDirection", value |> js) |> ignore
}

///|
/// Sets the justify-content property
pub fn Element::set_justify_content(self : Self, value : String) -> Unit {
  self.style().set("justifyContent", value |> js) |> ignore
}

///|
/// Sets the align-items property
pub fn Element::set_align_items(self : Self, value : String) -> Unit {
  self.style().set("alignItems", value |> js) |> ignore
}

///|
/// Sets the grid property
pub fn Element::set_grid(self : Self, value : String) -> Unit {
  self.style().set("grid", value |> js) |> ignore
}

///|
/// Sets the grid-template-columns property
pub fn Element::set_grid_template_columns(self : Self, value : String) -> Unit {
  self.style().set("gridTemplateColumns", value |> js) |> ignore
}

///|
/// Sets the grid-template-rows property
pub fn Element::set_grid_template_rows(self : Self, value : String) -> Unit {
  self.style().set("gridTemplateRows", value |> js) |> ignore
}

///|
/// Sets the gap property
pub fn Element::set_gap(self : Self, value : String) -> Unit {
  self.style().set("gap", value |> js) |> ignore
}
