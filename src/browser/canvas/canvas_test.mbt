///| Canvas tests

// =============================================================================
// Test Helper FFI Functions
// =============================================================================
// These FFI functions are used ONLY for testing purposes in Node.js environment.
// They use the `node-canvas` package to create canvas elements for testing.
//
// In browser environments, you would use document.createElement('canvas')
// which is wrapped in @dom.Document.
//
// Requires: npm install canvas
// =============================================================================

///|
/// [Test Helper] Creates a canvas element using node-canvas for Node.js testing.
/// In browsers, use document.createElement('canvas') instead.
extern "js" fn test_ffi_create_canvas(
  width : @js.Any,
  height : @js.Any,
) -> @js.Any =
  #|(width, height) => {
  #|  const { createCanvas } = require('canvas');
  #|  return createCanvas(width, height);
  #|}

///|
/// [Test Helper] Creates an empty ImageData using node-canvas.
/// In browsers, use CanvasRenderingContext2D.createImageData() instead.
extern "js" fn test_ffi_create_image_data(
  width : @js.Any,
  height : @js.Any,
) -> @js.Any =
  #|(width, height) => {
  #|  const { createImageData } = require('canvas');
  #|  return createImageData(width, height);
  #|}

///|
/// [Test Helper] Creates ImageData from a Uint8Array using node-canvas.
extern "js" fn test_ffi_create_image_data_with_data(
  data : @js.Any,
  width : @js.Any,
  height : @js.Any,
) -> @js.Any =
  #|(data, width, height) => {
  #|  const { createImageData } = require('canvas');
  #|  return createImageData(new Uint8ClampedArray(data.buffer), width, height);
  #|}

///|
fn create_test_canvas(width : Int, height : Int) -> @dom.HTMLCanvasElement {
  @js.identity(test_ffi_create_canvas(width |> @js.any, height |> @js.any))
}

///|
/// Basic drawing operations tests
test "fillRect draws a rectangle" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.fillStyle = "red"
  ctx.fillRect(10.0, 10.0, 100.0, 50.0)
  inspect(ctx.fillStyle, content="#ff0000")
}

///|
test "strokeRect draws a rectangle outline" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.strokeStyle = "blue"
  ctx.lineWidth = 2.0
  ctx.strokeRect(10.0, 10.0, 100.0, 50.0)
  inspect(ctx.strokeStyle, content="#0000ff")
  inspect(ctx.lineWidth, content="2")
}

///|
test "clearRect clears a rectangle area" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.fillStyle = "green"
  ctx.fillRect(0.0, 0.0, 200.0, 200.0)
  ctx.clearRect(50.0, 50.0, 100.0, 100.0)
  // Test passes if no error is thrown
}

///|
/// Path operations tests
test "beginPath and closePath work correctly" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.beginPath()
  ctx.moveTo(10.0, 10.0)
  ctx.lineTo(100.0, 10.0)
  ctx.lineTo(100.0, 100.0)
  ctx.closePath()
  ctx.stroke()
  // Test passes if no error is thrown
}

///|
test "arc draws a circle" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.beginPath()
  ctx.arc(100.0, 100.0, 50.0, 0.0, 6.28318530718, counterclockwise=false)
  ctx.stroke()
  // Test passes if no error is thrown
}

///|
test "arc with default counterclockwise" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.beginPath()
  ctx.arc(100.0, 100.0, 50.0, 0.0, 6.28318530718)
  ctx.fill()
  // Test passes if no error is thrown
}

///|
test "arcTo draws an arc between two tangents" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.beginPath()
  ctx.moveTo(20.0, 20.0)
  ctx.arcTo(100.0, 20.0, 100.0, 100.0, 50.0)
  ctx.stroke()
  // Test passes if no error is thrown
}

///|
test "bezierCurveTo draws a cubic bezier curve" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.beginPath()
  ctx.moveTo(20.0, 100.0)
  ctx.bezierCurveTo(20.0, 20.0, 180.0, 20.0, 180.0, 100.0)
  ctx.stroke()
  // Test passes if no error is thrown
}

///|
test "quadraticCurveTo draws a quadratic curve" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.beginPath()
  ctx.moveTo(20.0, 100.0)
  ctx.quadraticCurveTo(100.0, 20.0, 180.0, 100.0)
  ctx.stroke()
  // Test passes if no error is thrown
}

///|
test "rect adds a rectangle to the path" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.beginPath()
  ctx.rect(10.0, 10.0, 100.0, 50.0)
  ctx.fill()
  // Test passes if no error is thrown
}

///|
test "fill and stroke work correctly" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.beginPath()
  ctx.rect(10.0, 10.0, 100.0, 50.0)
  ctx.fillStyle = "red"
  ctx.fill()
  ctx.strokeStyle = "blue"
  ctx.stroke()
  // Test passes if no error is thrown
}

///|
test "clip restricts drawing region" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.beginPath()
  ctx.rect(50.0, 50.0, 100.0, 100.0)
  ctx.clip()
  ctx.fillStyle = "green"
  ctx.fillRect(0.0, 0.0, 200.0, 200.0)
  // Test passes if no error is thrown
}

///|
/// Text operations tests
test "fillText draws text" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.font = "20px Arial"
  ctx.fillStyle = "black"
  ctx.fillText("Hello", 10.0, 50.0)
  inspect(ctx.font, content="20px Arial")
}

///|
test "fillText with max_width parameter" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.font = "20px Arial"
  ctx.fillText("Hello World", 10.0, 50.0, max_width=100.0)
  // Test passes if no error is thrown
}

///|
test "strokeText draws outlined text" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.font = "30px Arial"
  ctx.strokeStyle = "blue"
  ctx.strokeText("Hello", 10.0, 50.0)
  // Test passes if no error is thrown
}

///|
test "strokeText with max_width parameter" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.font = "30px Arial"
  ctx.strokeText("Hello World", 10.0, 50.0, max_width=150.0)
  // Test passes if no error is thrown
}

///|
test "measureText returns text metrics" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.font = "20px Arial"
  let metrics = ctx.measureText("Hello")
  let width = metrics.width
  inspect(width > 0.0, content="true")
}

///|
test "textAlign property works" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.textAlign = "center"
  inspect(ctx.textAlign, content="center")
}

///|
test "textBaseline property works" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.textBaseline = "middle"
  inspect(ctx.textBaseline, content="middle")
}

///|
/// Transformation tests
test "scale transformation works" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.scale(2.0, 2.0)
  ctx.fillRect(10.0, 10.0, 50.0, 50.0)
  // Test passes if no error is thrown
}

///|
test "rotate transformation works" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.rotate(0.785398163397) // 45 degrees in radians
  ctx.fillRect(50.0, 0.0, 50.0, 50.0)
  // Test passes if no error is thrown
}

///|
test "translate transformation works" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.translate(50.0, 50.0)
  ctx.fillRect(0.0, 0.0, 50.0, 50.0)
  // Test passes if no error is thrown
}

///|
test "transform applies custom transformation matrix" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.transform(1.0, 0.5, -0.5, 1.0, 30.0, 10.0)
  ctx.fillRect(0.0, 0.0, 50.0, 50.0)
  // Test passes if no error is thrown
}

///|
test "setTransform sets transformation matrix" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.setTransform(1.0, 0.0, 0.0, 1.0, 50.0, 50.0)
  ctx.fillRect(0.0, 0.0, 50.0, 50.0)
  // Test passes if no error is thrown
}

///|
test "resetTransform resets to identity matrix" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.scale(2.0, 2.0)
  ctx.rotate(0.785398163397)
  ctx.resetTransform()
  ctx.fillRect(10.0, 10.0, 50.0, 50.0)
  // Test passes if no error is thrown
}

///|
/// State management tests
test "save and restore canvas state" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.fillStyle = "red"
  ctx.save()
  ctx.fillStyle = "blue"
  inspect(ctx.fillStyle, content="#0000ff")
  ctx.restore()
  inspect(ctx.fillStyle, content="#ff0000")
}

///|
test "multiple save and restore" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.fillStyle = "red"
  ctx.save()
  ctx.fillStyle = "green"
  ctx.save()
  ctx.fillStyle = "blue"
  ctx.restore()
  inspect(ctx.fillStyle, content="#008000")
  ctx.restore()
  inspect(ctx.fillStyle, content="#ff0000")
}

///|
/// Property getter/setter tests
test "fillStyle property getter and setter" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.fillStyle = "#FF5733"
  inspect(ctx.fillStyle, content="#ff5733")
}

///|
test "strokeStyle property getter and setter" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.strokeStyle = "#3498db"
  inspect(ctx.strokeStyle, content="#3498db")
}

///|
test "lineWidth property getter and setter" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.lineWidth = 5.5
  inspect(ctx.lineWidth, content="5.5")
}

///|
test "font property getter and setter" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.font = "italic 24px Georgia"
  inspect(ctx.font, content="italic 24px Georgia")
}

///|
test "globalAlpha property getter and setter" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.globalAlpha = 0.5
  inspect(ctx.globalAlpha, content="0.5")
}

///|
test "canvas property returns HTMLCanvasElement" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  let retrieved_canvas = ctx.canvas
  inspect(retrieved_canvas.width, content="200")
  inspect(retrieved_canvas.height, content="200")
}

///|
/// ImageData tests
test "createImageData creates new ImageData" {
  let canvas = create_test_canvas(200, 200)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  let image_data = ctx.createImageData(100, 50)
  inspect(image_data.width, content="100")
  inspect(image_data.height, content="50")
}

///|
test "ImageData constructor works" {
  let image_data : ImageData = @js.identity(
    test_ffi_create_image_data(10 |> @js.any, 20 |> @js.any),
  )
  inspect(image_data.width, content="10")
  inspect(image_data.height, content="20")
}

///|
test "ImageData data property returns Uint8Array" {
  let image_data : ImageData = @js.identity(
    test_ffi_create_image_data(10 |> @js.any, 10 |> @js.any),
  )
  let data = image_data.data
  let length = data.length()
  // 10 * 10 * 4 (RGBA) = 400
  inspect(length, content="400")
}

///|
test "ImageData from_data creates ImageData from Uint8Array" {
  let data = @typedarray.Uint8Array::from_size(40) // 10 * 1 * 4 (RGBA)
  let image_data : ImageData = @js.identity(
    test_ffi_create_image_data_with_data(
      data.to_any(),
      10 |> @js.any,
      1 |> @js.any,
    ),
  )
  inspect(image_data.width, content="10")
  inspect(image_data.height, content="1")
}

///|
test "getImageData retrieves pixel data" {
  let canvas = create_test_canvas(100, 100)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  ctx.fillStyle = "red"
  ctx.fillRect(0.0, 0.0, 100.0, 100.0)
  let image_data = ctx.getImageData(0.0, 0.0, 50.0, 50.0)
  inspect(image_data.width, content="50")
  inspect(image_data.height, content="50")
}

///|
test "putImageData writes pixel data to canvas" {
  let canvas = create_test_canvas(100, 100)
  let ctx : CanvasRenderingContext2D = @js.identity(canvas.getContext("2d"))
  let image_data : ImageData = @js.identity(
    test_ffi_create_image_data(50 |> @js.any, 50 |> @js.any),
  )
  ctx.putImageData(image_data, 10.0, 10.0)
  // Test passes if no error is thrown
}
