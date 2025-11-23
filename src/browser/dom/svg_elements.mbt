///|
/// SVGElement is the base interface for all SVG elements
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGElement
#external
pub type SVGElement

///|
pub impl @js.JsImpl for SVGElement

///|
/// Sets an attribute on the SVG element
pub fn SVGElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// Gets an attribute from the SVG element
pub fn SVGElement::getAttribute(self : Self, name : String) -> String? {
  self.call("getAttribute", [name]) |> @js.unsafe_cast_option()
}

///|
/// SVGSVGElement represents an <svg> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGSVGElement
#external
pub type SVGSVGElement

///|
pub impl @js.JsImpl for SVGSVGElement

///|
/// Gets the current viewport width
pub fn SVGSVGElement::width(self : Self) -> Double {
  self.get("width").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the current viewport height
pub fn SVGSVGElement::height(self : Self) -> Double {
  self.get("height").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Sets an attribute on the SVG element
pub fn SVGSVGElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// Gets an attribute from the SVG element
pub fn SVGSVGElement::getAttribute(self : Self, name : String) -> String? {
  self.call("getAttribute", [name]) |> @js.unsafe_cast_option()
}

///|
/// SVGCircleElement represents a <circle> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGCircleElement
pub(all) struct SVGCircleElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGCircleElement

///|
pub impl @event.EventTargetImpl for SVGCircleElement

///|
pub impl NodeImpl for SVGCircleElement

///|
pub impl ElementImpl for SVGCircleElement

///|
/// Gets the cx coordinate
pub fn SVGCircleElement::cx(self : Self) -> Double {
  self.get("cx").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the cy coordinate
pub fn SVGCircleElement::cy(self : Self) -> Double {
  self.get("cy").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the radius
pub fn SVGCircleElement::r(self : Self) -> Double {
  self.get("r").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Sets an attribute on the SVG element
pub fn SVGCircleElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// SVGRectElement represents a <rect> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGRectElement
pub(all) struct SVGRectElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGRectElement

///|
pub impl @event.EventTargetImpl for SVGRectElement

///|
pub impl NodeImpl for SVGRectElement

///|
pub impl ElementImpl for SVGRectElement

///|
/// Gets the x coordinate
pub fn SVGRectElement::x(self : Self) -> Double {
  self.get("x").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the y coordinate
pub fn SVGRectElement::y(self : Self) -> Double {
  self.get("y").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the width
pub fn SVGRectElement::width(self : Self) -> Double {
  self.get("width").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the height
pub fn SVGRectElement::height(self : Self) -> Double {
  self.get("height").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Sets an attribute on the SVG element
pub fn SVGRectElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// SVGEllipseElement represents an <ellipse> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGEllipseElement
pub(all) struct SVGEllipseElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGEllipseElement

///|
pub impl @event.EventTargetImpl for SVGEllipseElement

///|
pub impl NodeImpl for SVGEllipseElement

///|
pub impl ElementImpl for SVGEllipseElement

///|
/// Gets the cx coordinate
pub fn SVGEllipseElement::cx(self : Self) -> Double {
  self.get("cx").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the cy coordinate
pub fn SVGEllipseElement::cy(self : Self) -> Double {
  self.get("cy").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the x-axis radius
pub fn SVGEllipseElement::rx(self : Self) -> Double {
  self.get("rx").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the y-axis radius
pub fn SVGEllipseElement::ry(self : Self) -> Double {
  self.get("ry").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Sets an attribute on the SVG element
pub fn SVGEllipseElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// SVGLineElement represents a <line> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGLineElement
pub(all) struct SVGLineElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGLineElement

///|
pub impl @event.EventTargetImpl for SVGLineElement

///|
pub impl NodeImpl for SVGLineElement

///|
pub impl ElementImpl for SVGLineElement

///|
/// Gets the x1 coordinate
pub fn SVGLineElement::x1(self : Self) -> Double {
  self.get("x1").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the y1 coordinate
pub fn SVGLineElement::y1(self : Self) -> Double {
  self.get("y1").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the x2 coordinate
pub fn SVGLineElement::x2(self : Self) -> Double {
  self.get("x2").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the y2 coordinate
pub fn SVGLineElement::y2(self : Self) -> Double {
  self.get("y2").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Sets an attribute on the SVG element
pub fn SVGLineElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// SVGPolygonElement represents a <polygon> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPolygonElement
pub(all) struct SVGPolygonElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGPolygonElement

///|
pub impl @event.EventTargetImpl for SVGPolygonElement

///|
pub impl NodeImpl for SVGPolygonElement

///|
pub impl ElementImpl for SVGPolygonElement

///|
/// Sets an attribute on the SVG element
pub fn SVGPolygonElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// SVGPolylineElement represents a <polyline> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPolylineElement
pub(all) struct SVGPolylineElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGPolylineElement

///|
pub impl @event.EventTargetImpl for SVGPolylineElement

///|
pub impl NodeImpl for SVGPolylineElement

///|
pub impl ElementImpl for SVGPolylineElement

///|
/// Sets an attribute on the SVG element
pub fn SVGPolylineElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// SVGPathElement represents a <path> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPathElement
pub(all) struct SVGPathElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGPathElement

///|
pub impl @event.EventTargetImpl for SVGPathElement

///|
pub impl NodeImpl for SVGPathElement

///|
pub impl ElementImpl for SVGPathElement

///|
/// Gets the path data
pub fn SVGPathElement::d(self : Self) -> String {
  self.get("d") |> @js.unsafe_cast
}

///|
/// Gets the total length of the path
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPathElement/getTotalLength
pub fn SVGPathElement::getTotalLength(self : Self) -> Double {
  self.call0("getTotalLength") |> @js.unsafe_cast
}

///|
/// Sets an attribute on the SVG element
pub fn SVGPathElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// SVGTextElement represents a <text> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGTextElement
pub(all) struct SVGTextElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGTextElement

///|
pub impl @event.EventTargetImpl for SVGTextElement

///|
pub impl NodeImpl for SVGTextElement

///|
pub impl ElementImpl for SVGTextElement

///|
/// Gets the x coordinate
pub fn SVGTextElement::x(self : Self) -> Double {
  self.get("x").get("baseVal").get(0).get("value") |> @js.unsafe_cast
}

///|
/// Gets the y coordinate
pub fn SVGTextElement::y(self : Self) -> Double {
  self.get("y").get("baseVal").get(0).get("value") |> @js.unsafe_cast
}

///|
/// Sets an attribute on the SVG element
pub fn SVGTextElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// SVGImageElement represents an <image> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGImageElement
pub(all) struct SVGImageElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGImageElement

///|
pub impl @event.EventTargetImpl for SVGImageElement

///|
pub impl NodeImpl for SVGImageElement

///|
pub impl ElementImpl for SVGImageElement

///|
/// Gets the x coordinate
pub fn SVGImageElement::x(self : Self) -> Double {
  self.get("x").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the y coordinate
pub fn SVGImageElement::y(self : Self) -> Double {
  self.get("y").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the width
pub fn SVGImageElement::width(self : Self) -> Double {
  self.get("width").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the height
pub fn SVGImageElement::height(self : Self) -> Double {
  self.get("height").get("baseVal").get("value") |> @js.unsafe_cast
}

///|
/// Gets the href attribute
pub fn SVGImageElement::href(self : Self) -> String {
  self.get("href").get("baseVal") |> @js.unsafe_cast
}

///|
/// Sets an attribute on the SVG element
pub fn SVGImageElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}

///|
/// SVGGElement represents a <g> grouping element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGGElement
pub(all) struct SVGGElement {} derive(Show)

///|
pub impl @js.JsImpl for SVGGElement

///|
pub impl @event.EventTargetImpl for SVGGElement

///|
pub impl NodeImpl for SVGGElement

///|
pub impl ElementImpl for SVGGElement

///|
/// Sets an attribute on the SVG element
pub fn SVGGElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  ignore(self.call2("setAttribute", name, value))
}
