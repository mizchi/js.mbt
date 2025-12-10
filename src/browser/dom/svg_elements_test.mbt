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

///|
test "SVGElement - width property access (baseVal.value)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let element = doc.createElementNs("http://www.w3.org/2000/svg", "rect")
  let rect : SVGRectElement = element |> @core.identity
  rect.setAttribute("width", "100")

  // SVG properties like width return SVGAnimatedLength, need baseVal.value
  let value = rect.as_any()._get("width")._get("baseVal")._get("value")
  let value_double : Double = value.cast()
  value_double |> inspect(content="100")
}

///|
test "SVGElement - use width() method" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let element = doc.createElementNs("http://www.w3.org/2000/svg", "rect")
  let rect : SVGRectElement = element |> @core.identity
  rect.setAttribute("width", "150")
  rect.setAttribute("height", "75")
  rect.setAttribute("x", "10")
  rect.setAttribute("y", "20")

  // Test the width() method
  rect.width() |> inspect(content="150")
  rect.height() |> inspect(content="75")
  rect.x() |> inspect(content="10")
  rect.y() |> inspect(content="20")
}

///|
test "SVGCircleElement - cx, cy, r methods" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let element = doc.createElementNs("http://www.w3.org/2000/svg", "circle")
  let circle : SVGCircleElement = element |> @core.identity
  circle.setAttribute("cx", "50")
  circle.setAttribute("cy", "60")
  circle.setAttribute("r", "25")

  // Test the accessor methods
  circle.cx() |> inspect(content="50")
  circle.cy() |> inspect(content="60")
  circle.r() |> inspect(content="25")
}
