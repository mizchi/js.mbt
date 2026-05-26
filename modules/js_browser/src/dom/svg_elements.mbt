///|
/// SVGElement is the base interface for all SVG elements
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGElement
#external
pub type SVGElement

///|
pub fn SVGElement::as_any(self : SVGElement) -> @core.Any = "%identity"

///|
pub fn SVGElement::as_event_target(self : SVGElement) -> @event.EventTarget = "%identity"

///|
pub fn SVGElement::as_node(self : SVGElement) -> Node = "%identity"

///|
pub fn SVGElement::as_element(self : SVGElement) -> Element = "%identity"

///|

///|

///|

///|

///|
/// Sets an attribute on the SVG element
pub fn SVGElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// Gets an attribute from the SVG element
pub fn SVGElement::getAttribute(self : Self, name : String) -> String? {
  let v : @core.Any = self
    .as_any()
    ._call("getAttribute", [@core.any(name)])
    .cast()
  v |> @core.identity_option()
}

///|
/// SVGSVGElement represents an <svg> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGSVGElement
#external
pub type SVGSVGElement

///|
pub fn SVGSVGElement::as_any(self : SVGSVGElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Gets the current viewport width
pub fn SVGSVGElement::width(self : Self) -> Double {
  self.as_any()._get("width")._get("baseVal")._get("value").cast()
}

///|
/// Gets the current viewport height
pub fn SVGSVGElement::height(self : Self) -> Double {
  self.as_any()._get("height")._get("baseVal")._get("value").cast()
}

///|
/// Sets an attribute on the SVG element
pub fn SVGSVGElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// Gets an attribute from the SVG element
pub fn SVGSVGElement::getAttribute(self : Self, name : String) -> String? {
  let v : @core.Any = self
    .as_any()
    ._call("getAttribute", [@core.any(name)])
    .cast()
  v |> @core.identity_option
}

///|
/// SVGCircleElement represents a <circle> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGCircleElement
#external
pub type SVGCircleElement

///|
pub fn SVGCircleElement::as_any(self : SVGCircleElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Gets the cx coordinate
pub fn SVGCircleElement::cx(self : Self) -> Double {
  self.as_any()._get("cx")._get("baseVal")._get("value").cast()
}

///|
/// Gets the cy coordinate
pub fn SVGCircleElement::cy(self : Self) -> Double {
  self.as_any()._get("cy")._get("baseVal")._get("value").cast()
}

///|
/// Gets the radius
pub fn SVGCircleElement::r(self : Self) -> Double {
  self.as_any()._get("r")._get("baseVal")._get("value").cast()
}

///|
/// Sets an attribute on the SVG element
pub fn SVGCircleElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// SVGRectElement represents a <rect> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGRectElement
#external
pub type SVGRectElement

///|
pub fn SVGRectElement::as_any(self : SVGRectElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Gets the x coordinate
pub fn SVGRectElement::x(self : Self) -> Double {
  self.as_any()._get("x")._get("baseVal")._get("value").cast()
}

///|
/// Gets the y coordinate
pub fn SVGRectElement::y(self : Self) -> Double {
  self.as_any()._get("y")._get("baseVal")._get("value").cast()
}

///|
/// Gets the width
pub fn SVGRectElement::width(self : Self) -> Double {
  self.as_any()._get("width")._get("baseVal")._get("value").cast()
}

///|
/// Gets the height
pub fn SVGRectElement::height(self : Self) -> Double {
  self.as_any()._get("height")._get("baseVal")._get("value").cast()
}

///|
/// Sets an attribute on the SVG element
pub fn SVGRectElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// SVGEllipseElement represents an <ellipse> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGEllipseElement
#external
pub type SVGEllipseElement

///|
pub fn SVGEllipseElement::as_any(self : SVGEllipseElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Gets the cx coordinate
pub fn SVGEllipseElement::cx(self : Self) -> Double {
  self.as_any()._get("cx")._get("baseVal")._get("value").cast()
}

///|
/// Gets the cy coordinate
pub fn SVGEllipseElement::cy(self : Self) -> Double {
  self.as_any()._get("cy")._get("baseVal")._get("value").cast()
}

///|
/// Gets the x-axis radius
pub fn SVGEllipseElement::rx(self : Self) -> Double {
  self.as_any()._get("rx")._get("baseVal")._get("value").cast()
}

///|
/// Gets the y-axis radius
pub fn SVGEllipseElement::ry(self : Self) -> Double {
  self.as_any()._get("ry")._get("baseVal")._get("value").cast()
}

///|
/// Sets an attribute on the SVG element
pub fn SVGEllipseElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// SVGLineElement represents a <line> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGLineElement
#external
pub type SVGLineElement

///|
pub fn SVGLineElement::as_any(self : SVGLineElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Gets the x1 coordinate
pub fn SVGLineElement::x1(self : Self) -> Double {
  self.as_any()._get("x1")._get("baseVal")._get("value").cast()
}

///|
/// Gets the y1 coordinate
pub fn SVGLineElement::y1(self : Self) -> Double {
  self.as_any()._get("y1")._get("baseVal")._get("value").cast()
}

///|
/// Gets the x2 coordinate
pub fn SVGLineElement::x2(self : Self) -> Double {
  self.as_any()._get("x2")._get("baseVal")._get("value").cast()
}

///|
/// Gets the y2 coordinate
pub fn SVGLineElement::y2(self : Self) -> Double {
  self.as_any()._get("y2")._get("baseVal")._get("value").cast()
}

///|
/// Sets an attribute on the SVG element
pub fn SVGLineElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// SVGPolygonElement represents a <polygon> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPolygonElement
#external
pub type SVGPolygonElement

///|
pub fn SVGPolygonElement::as_any(self : SVGPolygonElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Sets an attribute on the SVG element
pub fn SVGPolygonElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// SVGPolylineElement represents a <polyline> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPolylineElement
#external
pub type SVGPolylineElement

///|
pub fn SVGPolylineElement::as_any(self : SVGPolylineElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Sets an attribute on the SVG element
pub fn SVGPolylineElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// SVGPathElement represents a <path> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPathElement
#external
pub type SVGPathElement

///|
pub fn SVGPathElement::as_any(self : SVGPathElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Gets the path data
pub fn SVGPathElement::d(self : Self) -> String {
  self.as_any()._get("d").cast()
}

///|
/// Gets the total length of the path
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPathElement/getTotalLength
pub fn SVGPathElement::getTotalLength(self : Self) -> Double {
  self.as_any()._call("getTotalLength", []).cast()
}

///|
/// Sets an attribute on the SVG element
pub fn SVGPathElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// SVGTextElement represents a <text> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGTextElement
#external
pub type SVGTextElement

///|
pub fn SVGTextElement::as_any(self : SVGTextElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Gets the x coordinate
pub fn SVGTextElement::x(self : Self) -> Double {
  self
  .as_any()
  ._get("x")
  ._get("baseVal")
  ._call("at", [@core.any(0)])
  ._get("value")
  .cast()
}

///|
/// Gets the y coordinate
pub fn SVGTextElement::y(self : Self) -> Double {
  self
  .as_any()
  ._get("y")
  ._get("baseVal")
  ._call("at", [@core.any(0)])
  ._get("value")
  .cast()
}

///|
/// Sets an attribute on the SVG element
pub fn SVGTextElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// SVGImageElement represents an <image> element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGImageElement
#external
pub type SVGImageElement

///|
pub fn SVGImageElement::as_any(self : SVGImageElement) -> @core.Any = "%identity"

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

///|

///|

///|

///|
/// Gets the x coordinate
pub fn SVGImageElement::x(self : Self) -> Double {
  self.as_any()._get("x")._get("baseVal")._get("value").cast()
}

///|
/// Gets the y coordinate
pub fn SVGImageElement::y(self : Self) -> Double {
  self.as_any()._get("y")._get("baseVal")._get("value").cast()
}

///|
/// Gets the width
pub fn SVGImageElement::width(self : Self) -> Double {
  self.as_any()._get("width")._get("baseVal")._get("value").cast()
}

///|
/// Gets the height
pub fn SVGImageElement::height(self : Self) -> Double {
  self.as_any()._get("height")._get("baseVal")._get("value").cast()
}

///|
/// Gets the href attribute
pub fn SVGImageElement::href(self : Self) -> String {
  self.as_any()._get("href")._get("baseVal").cast()
}

///|
/// Sets an attribute on the SVG element
pub fn SVGImageElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

///|
/// SVGGElement represents a <g> grouping element
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGGElement
#external
pub type SVGGElement

///|
pub fn SVGGElement::as_any(self : SVGGElement) -> @core.Any = "%identity"

///|
pub fn SVGGElement::as_event_target(self : SVGGElement) -> @event.EventTarget = "%identity"

///|
pub fn SVGGElement::as_node(self : SVGGElement) -> Node = "%identity"

///|
pub fn SVGGElement::as_element(self : SVGGElement) -> Element = "%identity"

///|
pub fn SVGGElement::as_svg_element(self : SVGGElement) -> SVGElement = "%identity"

///|

///|

///|

///|

///|
/// Sets an attribute on the SVG element
pub fn SVGGElement::setAttribute(
  self : Self,
  name : String,
  value : String,
) -> Unit {
  self.as_any()._call("setAttribute", [@core.any(name), @core.any(value)])
  |> ignore
}

// =============================================================================
// SVG Geometry Types (Browser FFI)
// =============================================================================

///|
/// SVGRect represents a rectangle in SVG
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGRect
#external
pub type SVGRect

///|
pub fn SVGRect::as_any(self : SVGRect) -> @core.Any = "%identity"

///|
/// Get x coordinate
pub fn SVGRect::x(self : Self) -> Double {
  self.as_any()._get("x").cast()
}

///|
/// Set x coordinate
pub fn SVGRect::set_x(self : Self, value : Double) -> Unit {
  self.as_any()._set("x", @core.any(value))
}

///|
/// Get y coordinate
pub fn SVGRect::y(self : Self) -> Double {
  self.as_any()._get("y").cast()
}

///|
/// Set y coordinate
pub fn SVGRect::set_y(self : Self, value : Double) -> Unit {
  self.as_any()._set("y", @core.any(value))
}

///|
/// Get width
pub fn SVGRect::width(self : Self) -> Double {
  self.as_any()._get("width").cast()
}

///|
/// Set width
pub fn SVGRect::set_width(self : Self, value : Double) -> Unit {
  self.as_any()._set("width", @core.any(value))
}

///|
/// Get height
pub fn SVGRect::height(self : Self) -> Double {
  self.as_any()._get("height").cast()
}

///|
/// Set height
pub fn SVGRect::set_height(self : Self, value : Double) -> Unit {
  self.as_any()._set("height", @core.any(value))
}

///|
/// SVGPoint represents a point in SVG coordinate space
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGPoint
#external
pub type SVGPoint

///|
pub fn SVGPoint::as_any(self : SVGPoint) -> @core.Any = "%identity"

///|
/// Get x coordinate
pub fn SVGPoint::x(self : Self) -> Double {
  self.as_any()._get("x").cast()
}

///|
/// Set x coordinate
pub fn SVGPoint::set_x(self : Self, value : Double) -> Unit {
  self.as_any()._set("x", @core.any(value))
}

///|
/// Get y coordinate
pub fn SVGPoint::y(self : Self) -> Double {
  self.as_any()._get("y").cast()
}

///|
/// Set y coordinate
pub fn SVGPoint::set_y(self : Self, value : Double) -> Unit {
  self.as_any()._set("y", @core.any(value))
}

///|
/// Transform this point by a matrix
pub fn SVGPoint::matrixTransform(self : Self, matrix : SVGMatrix) -> SVGPoint {
  self.as_any()._call("matrixTransform", [matrix.as_any()]).cast()
}

///|
/// SVGMatrix represents a 2D transformation matrix
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGMatrix
#external
pub type SVGMatrix

///|
pub fn SVGMatrix::as_any(self : SVGMatrix) -> @core.Any = "%identity"

///|
/// Get a (scale x)
pub fn SVGMatrix::a(self : Self) -> Double {
  self.as_any()._get("a").cast()
}

///|
/// Set a (scale x)
pub fn SVGMatrix::set_a(self : Self, value : Double) -> Unit {
  self.as_any()._set("a", @core.any(value))
}

///|
/// Get b (skew y)
pub fn SVGMatrix::b(self : Self) -> Double {
  self.as_any()._get("b").cast()
}

///|
/// Set b (skew y)
pub fn SVGMatrix::set_b(self : Self, value : Double) -> Unit {
  self.as_any()._set("b", @core.any(value))
}

///|
/// Get c (skew x)
pub fn SVGMatrix::c(self : Self) -> Double {
  self.as_any()._get("c").cast()
}

///|
/// Set c (skew x)
pub fn SVGMatrix::set_c(self : Self, value : Double) -> Unit {
  self.as_any()._set("c", @core.any(value))
}

///|
/// Get d (scale y)
pub fn SVGMatrix::d(self : Self) -> Double {
  self.as_any()._get("d").cast()
}

///|
/// Set d (scale y)
pub fn SVGMatrix::set_d(self : Self, value : Double) -> Unit {
  self.as_any()._set("d", @core.any(value))
}

///|
/// Get e (translate x)
pub fn SVGMatrix::e(self : Self) -> Double {
  self.as_any()._get("e").cast()
}

///|
/// Set e (translate x)
pub fn SVGMatrix::set_e(self : Self, value : Double) -> Unit {
  self.as_any()._set("e", @core.any(value))
}

///|
/// Get f (translate y)
pub fn SVGMatrix::f(self : Self) -> Double {
  self.as_any()._get("f").cast()
}

///|
/// Set f (translate y)
pub fn SVGMatrix::set_f(self : Self, value : Double) -> Unit {
  self.as_any()._set("f", @core.any(value))
}

///|
/// Multiply this matrix by another matrix
pub fn SVGMatrix::multiply(self : Self, other : SVGMatrix) -> SVGMatrix {
  self.as_any()._call("multiply", [other.as_any()]).cast()
}

///|
/// Get the inverse of this matrix
pub fn SVGMatrix::inverse(self : Self) -> SVGMatrix {
  self.as_any()._call("inverse", []).cast()
}

///|
/// Apply translation to this matrix
pub fn SVGMatrix::translate(self : Self, x : Double, y : Double) -> SVGMatrix {
  self.as_any()._call("translate", [@core.any(x), @core.any(y)]).cast()
}

///|
/// Apply scale to this matrix
pub fn SVGMatrix::scale(self : Self, factor : Double) -> SVGMatrix {
  self.as_any()._call("scale", [@core.any(factor)]).cast()
}

///|
/// Apply non-uniform scale to this matrix
pub fn SVGMatrix::scaleNonUniform(
  self : Self,
  sx : Double,
  sy : Double,
) -> SVGMatrix {
  self.as_any()._call("scaleNonUniform", [@core.any(sx), @core.any(sy)]).cast()
}

///|
/// Apply rotation to this matrix (angle in degrees)
pub fn SVGMatrix::rotate(self : Self, angle : Double) -> SVGMatrix {
  self.as_any()._call("rotate", [@core.any(angle)]).cast()
}

///|
/// Apply skew X to this matrix (angle in degrees)
pub fn SVGMatrix::skewX(self : Self, angle : Double) -> SVGMatrix {
  self.as_any()._call("skewX", [@core.any(angle)]).cast()
}

///|
/// Apply skew Y to this matrix (angle in degrees)
pub fn SVGMatrix::skewY(self : Self, angle : Double) -> SVGMatrix {
  self.as_any()._call("skewY", [@core.any(angle)]).cast()
}

///|
/// Flip on X axis
pub fn SVGMatrix::flipX(self : Self) -> SVGMatrix {
  self.as_any()._call("flipX", []).cast()
}

///|
/// Flip on Y axis
pub fn SVGMatrix::flipY(self : Self) -> SVGMatrix {
  self.as_any()._call("flipY", []).cast()
}

// =============================================================================
// SVGSVGElement Factory Methods
// =============================================================================

///|
/// Create a new SVGRect object
pub fn SVGSVGElement::createSVGRect(self : Self) -> SVGRect {
  self.as_any()._call("createSVGRect", []).cast()
}

///|
/// Create a new SVGPoint object
pub fn SVGSVGElement::createSVGPoint(self : Self) -> SVGPoint {
  self.as_any()._call("createSVGPoint", []).cast()
}

///|
/// Create a new SVGMatrix object
pub fn SVGSVGElement::createSVGMatrix(self : Self) -> SVGMatrix {
  self.as_any()._call("createSVGMatrix", []).cast()
}

///|
/// Create a new SVGNumber object
pub fn SVGSVGElement::createSVGNumber(self : Self) -> @core.Any {
  self.as_any()._call("createSVGNumber", [])
}

///|
/// Create a new SVGLength object
pub fn SVGSVGElement::createSVGLength(self : Self) -> @core.Any {
  self.as_any()._call("createSVGLength", [])
}

///|
/// Create a new SVGAngle object
pub fn SVGSVGElement::createSVGAngle(self : Self) -> @core.Any {
  self.as_any()._call("createSVGAngle", [])
}

///|
/// Create a new SVGTransform object
pub fn SVGSVGElement::createSVGTransform(self : Self) -> @core.Any {
  self.as_any()._call("createSVGTransform", [])
}

// =============================================================================
// SVGGraphicsElement (base for elements with getBBox)
// =============================================================================

///|
/// SVGGraphicsElement is the base interface for SVG elements that can be rendered
/// https://developer.mozilla.org/en-US/docs/Web/API/SVGGraphicsElement
#external
pub type SVGGraphicsElement

///|
pub fn SVGGraphicsElement::as_any(self : SVGGraphicsElement) -> @core.Any = "%identity"

///|
pub fn SVGGraphicsElement::as_event_target(
  self : SVGGraphicsElement,
) -> @event.EventTarget = "%identity"

///|
pub fn SVGGraphicsElement::as_node(self : SVGGraphicsElement) -> Node = "%identity"

///|
pub fn SVGGraphicsElement::as_element(self : SVGGraphicsElement) -> Element = "%identity"

///|
pub fn SVGGraphicsElement::as_svg_element(
  self : SVGGraphicsElement,
) -> SVGElement = "%identity"

///|
/// Get the bounding box of the element (fill only, default)
pub fn SVGGraphicsElement::getBBox(self : Self) -> SVGRect {
  self.as_any()._call("getBBox", []).cast()
}

///|
/// Get the bounding box with options
/// Options: { fill: bool, stroke: bool, markers: bool, clipped: bool }
pub fn SVGGraphicsElement::getBBoxWithOptions(
  self : Self,
  fill : Bool,
  stroke : Bool,
  markers : Bool,
  clipped : Bool,
) -> SVGRect {
  let options = @core.new_object()
  options._set("fill", @core.any(fill))
  options._set("stroke", @core.any(stroke))
  options._set("markers", @core.any(markers))
  options._set("clipped", @core.any(clipped))
  self.as_any()._call("getBBox", [options]).cast()
}

///|
/// Get the Current Transformation Matrix (from user space to viewport)
pub fn SVGGraphicsElement::getCTM(self : Self) -> SVGMatrix? {
  let result = self.as_any()._call("getCTM", [])
  let opt : @core.Any? = result |> @core.identity_option()
  match opt {
    Some(v) => Some(v.cast())
    None => None
  }
}

///|
/// Get the Screen CTM (from user space to screen pixels)
pub fn SVGGraphicsElement::getScreenCTM(self : Self) -> SVGMatrix? {
  let result = self.as_any()._call("getScreenCTM", [])
  let opt : @core.Any? = result |> @core.identity_option()
  match opt {
    Some(v) => Some(v.cast())
    None => None
  }
}

// =============================================================================
// Conversion methods for SVG element types to SVGGraphicsElement
// =============================================================================

///|
pub fn SVGCircleElement::as_graphics_element(
  self : SVGCircleElement,
) -> SVGGraphicsElement = "%identity"

///|
pub fn SVGRectElement::as_graphics_element(
  self : SVGRectElement,
) -> SVGGraphicsElement = "%identity"

///|
pub fn SVGEllipseElement::as_graphics_element(
  self : SVGEllipseElement,
) -> SVGGraphicsElement = "%identity"

///|
pub fn SVGLineElement::as_graphics_element(
  self : SVGLineElement,
) -> SVGGraphicsElement = "%identity"

///|
pub fn SVGPathElement::as_graphics_element(
  self : SVGPathElement,
) -> SVGGraphicsElement = "%identity"

///|
pub fn SVGPolygonElement::as_graphics_element(
  self : SVGPolygonElement,
) -> SVGGraphicsElement = "%identity"

///|
pub fn SVGPolylineElement::as_graphics_element(
  self : SVGPolylineElement,
) -> SVGGraphicsElement = "%identity"

///|
pub fn SVGTextElement::as_graphics_element(
  self : SVGTextElement,
) -> SVGGraphicsElement = "%identity"

///|
pub fn SVGGElement::as_graphics_element(
  self : SVGGElement,
) -> SVGGraphicsElement = "%identity"

///|
pub fn SVGImageElement::as_graphics_element(
  self : SVGImageElement,
) -> SVGGraphicsElement = "%identity"
