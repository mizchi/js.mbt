///|
/// SVGElement is the base interface for all SVG elements
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGElement
#external
pub type SVGElement

///|
pub fn SVGElement::as_any(self : SVGElement) -> @nostd.Any = "%identity"

///|
pub fn SVGElement::as_event_target(self : SVGElement) -> @event.EventTarget = "%identity"

///|
pub fn SVGElement::as_node(self : SVGElement) -> Node = "%identity"

///|
pub fn SVGElement::as_element(self : SVGElement) -> Element = "%identity"

///|
pub impl @js.JsImpl for SVGElement

///|
pub impl @event.EventTargetImpl for SVGElement

///|
pub impl NodeImpl for SVGElement

///|
pub impl ElementImpl for SVGElement

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
  self.call("getAttribute", [name]) |> @js.identity_option()
}

///|
/// SVGSVGElement represents an <svg> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGSVGElement
#external
pub type SVGSVGElement

///|
pub fn SVGSVGElement::as_any(self : SVGSVGElement) -> @nostd.Any = "%identity"

///|
pub fn SVGSVGElement::as_event_target(
  self : SVGSVGElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGSVGElement::as_node(self : SVGSVGElement) -> Node = "%identity"

///|
pub fn SVGSVGElement::as_element(self : SVGSVGElement) -> Element = "%identity"

///|
pub fn SVGSVGElement::as_svg_element(self : SVGSVGElement) -> SVGElement = "%identity"

///|
pub impl @js.JsImpl for SVGSVGElement

///|
pub impl @event.EventTargetImpl for SVGSVGElement

///|
pub impl NodeImpl for SVGSVGElement

///|
pub impl ElementImpl for SVGSVGElement

///|
/// Gets the current viewport width
pub fn SVGSVGElement::width(self : Self) -> Double {
  self.get("width").get("baseVal").get("value").cast()
}

///|
/// Gets the current viewport height
pub fn SVGSVGElement::height(self : Self) -> Double {
  self.get("height").get("baseVal").get("value").cast()
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
  self.call("getAttribute", [name]) |> @js.identity_option
}

///|
/// SVGCircleElement represents a <circle> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGCircleElement
#external
pub type SVGCircleElement

///|
pub fn SVGCircleElement::as_any(self : SVGCircleElement) -> @nostd.Any = "%identity"

///|
pub fn SVGCircleElement::as_event_target(
  self : SVGCircleElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGCircleElement::as_node(self : SVGCircleElement) -> Node = "%identity"

///|
pub fn SVGCircleElement::as_element(self : SVGCircleElement) -> Element = "%identity"

///|
pub fn SVGCircleElement::as_svg_element(self : SVGCircleElement) -> SVGElement = "%identity"

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
  self.get("cx").get("baseVal").get("value").cast()
}

///|
/// Gets the cy coordinate
pub fn SVGCircleElement::cy(self : Self) -> Double {
  self.get("cy").get("baseVal").get("value").cast()
}

///|
/// Gets the radius
pub fn SVGCircleElement::r(self : Self) -> Double {
  self.get("r").get("baseVal").get("value").cast()
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
#external
pub type SVGRectElement

///|
pub fn SVGRectElement::as_any(self : SVGRectElement) -> @nostd.Any = "%identity"

///|
pub fn SVGRectElement::as_event_target(
  self : SVGRectElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGRectElement::as_node(self : SVGRectElement) -> Node = "%identity"

///|
pub fn SVGRectElement::as_element(self : SVGRectElement) -> Element = "%identity"

///|
pub fn SVGRectElement::as_svg_element(self : SVGRectElement) -> SVGElement = "%identity"

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
  self.get("x").get("baseVal").get("value").cast()
}

///|
/// Gets the y coordinate
pub fn SVGRectElement::y(self : Self) -> Double {
  self.get("y").get("baseVal").get("value").cast()
}

///|
/// Gets the width
pub fn SVGRectElement::width(self : Self) -> Double {
  self.get("width").get("baseVal").get("value").cast()
}

///|
/// Gets the height
pub fn SVGRectElement::height(self : Self) -> Double {
  self.get("height").get("baseVal").get("value").cast()
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
#external
pub type SVGEllipseElement

///|
pub fn SVGEllipseElement::as_any(self : SVGEllipseElement) -> @nostd.Any = "%identity"

///|
pub fn SVGEllipseElement::as_event_target(
  self : SVGEllipseElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGEllipseElement::as_node(self : SVGEllipseElement) -> Node = "%identity"

///|
pub fn SVGEllipseElement::as_element(self : SVGEllipseElement) -> Element = "%identity"

///|
pub fn SVGEllipseElement::as_svg_element(
  self : SVGEllipseElement,
) -> SVGElement = "%identity"

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
  self.get("cx").get("baseVal").get("value").cast()
}

///|
/// Gets the cy coordinate
pub fn SVGEllipseElement::cy(self : Self) -> Double {
  self.get("cy").get("baseVal").get("value").cast()
}

///|
/// Gets the x-axis radius
pub fn SVGEllipseElement::rx(self : Self) -> Double {
  self.get("rx").get("baseVal").get("value").cast()
}

///|
/// Gets the y-axis radius
pub fn SVGEllipseElement::ry(self : Self) -> Double {
  self.get("ry").get("baseVal").get("value").cast()
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
#external
pub type SVGLineElement

///|
pub fn SVGLineElement::as_any(self : SVGLineElement) -> @nostd.Any = "%identity"

///|
pub fn SVGLineElement::as_event_target(
  self : SVGLineElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGLineElement::as_node(self : SVGLineElement) -> Node = "%identity"

///|
pub fn SVGLineElement::as_element(self : SVGLineElement) -> Element = "%identity"

///|
pub fn SVGLineElement::as_svg_element(self : SVGLineElement) -> SVGElement = "%identity"

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
  self.get("x1").get("baseVal").get("value").cast()
}

///|
/// Gets the y1 coordinate
pub fn SVGLineElement::y1(self : Self) -> Double {
  self.get("y1").get("baseVal").get("value").cast()
}

///|
/// Gets the x2 coordinate
pub fn SVGLineElement::x2(self : Self) -> Double {
  self.get("x2").get("baseVal").get("value").cast()
}

///|
/// Gets the y2 coordinate
pub fn SVGLineElement::y2(self : Self) -> Double {
  self.get("y2").get("baseVal").get("value").cast()
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
#external
pub type SVGPolygonElement

///|
pub fn SVGPolygonElement::as_any(self : SVGPolygonElement) -> @nostd.Any = "%identity"

///|
pub fn SVGPolygonElement::as_event_target(
  self : SVGPolygonElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGPolygonElement::as_node(self : SVGPolygonElement) -> Node = "%identity"

///|
pub fn SVGPolygonElement::as_element(self : SVGPolygonElement) -> Element = "%identity"

///|
pub fn SVGPolygonElement::as_svg_element(
  self : SVGPolygonElement,
) -> SVGElement = "%identity"

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
#external
pub type SVGPolylineElement

///|
pub fn SVGPolylineElement::as_any(self : SVGPolylineElement) -> @nostd.Any = "%identity"

///|
pub fn SVGPolylineElement::as_event_target(
  self : SVGPolylineElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGPolylineElement::as_node(self : SVGPolylineElement) -> Node = "%identity"

///|
pub fn SVGPolylineElement::as_element(self : SVGPolylineElement) -> Element = "%identity"

///|
pub fn SVGPolylineElement::as_svg_element(
  self : SVGPolylineElement,
) -> SVGElement = "%identity"

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
#external
pub type SVGPathElement

///|
pub fn SVGPathElement::as_any(self : SVGPathElement) -> @nostd.Any = "%identity"

///|
pub fn SVGPathElement::as_event_target(
  self : SVGPathElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGPathElement::as_node(self : SVGPathElement) -> Node = "%identity"

///|
pub fn SVGPathElement::as_element(self : SVGPathElement) -> Element = "%identity"

///|
pub fn SVGPathElement::as_svg_element(self : SVGPathElement) -> SVGElement = "%identity"

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
  self.get("d").cast()
}

///|
/// Gets the total length of the path
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPathElement/getTotalLength
pub fn SVGPathElement::getTotalLength(self : Self) -> Double {
  self.call0("getTotalLength").cast()
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
#external
pub type SVGTextElement

///|
pub fn SVGTextElement::as_any(self : SVGTextElement) -> @nostd.Any = "%identity"

///|
pub fn SVGTextElement::as_event_target(
  self : SVGTextElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGTextElement::as_node(self : SVGTextElement) -> Node = "%identity"

///|
pub fn SVGTextElement::as_element(self : SVGTextElement) -> Element = "%identity"

///|
pub fn SVGTextElement::as_svg_element(self : SVGTextElement) -> SVGElement = "%identity"

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
  self.get("x").get("baseVal").get(0).get("value").cast()
}

///|
/// Gets the y coordinate
pub fn SVGTextElement::y(self : Self) -> Double {
  self.get("y").get("baseVal").get(0).get("value").cast()
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
#external
pub type SVGImageElement

///|
pub fn SVGImageElement::as_any(self : SVGImageElement) -> @nostd.Any = "%identity"

///|
pub fn SVGImageElement::as_event_target(
  self : SVGImageElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGImageElement::as_node(self : SVGImageElement) -> Node = "%identity"

///|
pub fn SVGImageElement::as_element(self : SVGImageElement) -> Element = "%identity"

///|
pub fn SVGImageElement::as_svg_element(self : SVGImageElement) -> SVGElement = "%identity"

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
  self.get("x").get("baseVal").get("value").cast()
}

///|
/// Gets the y coordinate
pub fn SVGImageElement::y(self : Self) -> Double {
  self.get("y").get("baseVal").get("value").cast()
}

///|
/// Gets the width
pub fn SVGImageElement::width(self : Self) -> Double {
  self.get("width").get("baseVal").get("value").cast()
}

///|
/// Gets the height
pub fn SVGImageElement::height(self : Self) -> Double {
  self.get("height").get("baseVal").get("value").cast()
}

///|
/// Gets the href attribute
pub fn SVGImageElement::href(self : Self) -> String {
  self.get("href").get("baseVal").cast()
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
#external
pub type SVGGElement

///|
pub fn SVGGElement::as_any(self : SVGGElement) -> @nostd.Any = "%identity"

///|
pub fn SVGGElement::as_event_target(self : SVGGElement) -> @event.EventTarget = "%identity"

///|
pub fn SVGGElement::as_node(self : SVGGElement) -> Node = "%identity"

///|
pub fn SVGGElement::as_element(self : SVGGElement) -> Element = "%identity"

///|
pub fn SVGGElement::as_svg_element(self : SVGGElement) -> SVGElement = "%identity"

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
