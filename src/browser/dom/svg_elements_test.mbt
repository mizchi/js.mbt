///|
/// Tests for SVG Element access using happy-dom

///|
test "SVGElement - create circle element" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()

  // Create SVG namespace element
  let element = doc.createElementNs("http://www.w3.org/2000/svg", "circle")

  // Cast to SVGCircleElement and set attributes
  let circle : SVGCircleElement = element |> @core.identity
  circle.setAttribute("cx", "50")
  circle.setAttribute("cy", "50")
  circle.setAttribute("r", "40")

  // Verify no errors occurred
  true |> inspect(content="true")
}

///|
test "SVGElement - create rect element" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let element = doc.createElementNs("http://www.w3.org/2000/svg", "rect")
  let rect : SVGRectElement = element |> @core.identity
  rect.setAttribute("x", "10")
  rect.setAttribute("y", "20")
  rect.setAttribute("width", "100")
  rect.setAttribute("height", "50")

  // Verify no errors occurred
  true |> inspect(content="true")
}

///|
test "SVGElement - create path element" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let element = doc.createElementNs("http://www.w3.org/2000/svg", "path")
  let path : SVGPathElement = element |> @core.identity
  path.setAttribute("d", "M 10 10 L 90 90")

  // Verify no errors occurred
  true |> inspect(content="true")
}
