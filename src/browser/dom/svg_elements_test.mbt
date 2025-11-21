///|
/// Tests for SVG Element access using jsdom

///|
test "SVGElement - create circle element" {
  @global_jsdom.register()
  let doc = document()

  // Create SVG namespace element
  let element = doc.createElementNs("http://www.w3.org/2000/svg", "circle")

  // Cast to SVGCircleElement and set attributes
  let circle : SVGCircleElement = element |> @js.unsafe_cast
  circle.setAttribute("cx", "50")
  circle.setAttribute("cy", "50")
  circle.setAttribute("r", "40")

  // Verify no errors occurred
  true |> inspect(content="true")
}

///|
test "SVGElement - create rect element" {
  @global_jsdom.register()
  let doc = document()
  let element = doc.createElementNs("http://www.w3.org/2000/svg", "rect")
  let rect : SVGRectElement = element |> @js.unsafe_cast
  rect.setAttribute("x", "10")
  rect.setAttribute("y", "20")
  rect.setAttribute("width", "100")
  rect.setAttribute("height", "50")

  // Verify no errors occurred
  true |> inspect(content="true")
}

///|
test "SVGElement - create path element" {
  @global_jsdom.register()
  let doc = document()
  let element = doc.createElementNs("http://www.w3.org/2000/svg", "path")
  let path : SVGPathElement = element |> @js.unsafe_cast
  path.setAttribute("d", "M 10 10 L 90 90")

  // Verify no errors occurred
  true |> inspect(content="true")
}
