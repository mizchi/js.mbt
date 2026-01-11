///|
/// Tests for HTML Element property access using happy-dom

///|
test "HTMLTextAreaElement - create and access value" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let textarea : HTMLTextAreaElement = doc.createElement("textarea")
    |> @core.identity

  // Read initial value
  textarea.value |> inspect(content="")

  // Write value
  textarea.value = "Hello, World!"

  // Read updated value
  textarea.value |> inspect(content="Hello, World!")
}

///|
test "HTMLTextAreaElement - placeholder property" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let textarea : HTMLTextAreaElement = doc.createElement("textarea")
    |> @core.identity

  // Set placeholder
  textarea.placeholder = "Enter text here"

  // Read placeholder
  textarea.placeholder |> inspect(content="Enter text here")
}

///|
test "HTMLTextAreaElement - disabled property" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let textarea : HTMLTextAreaElement = doc.createElement("textarea")
    |> @core.identity

  // Check initial state
  textarea.disabled |> inspect(content="false")

  // Disable
  textarea.disabled = true

  // Verify disabled
  textarea.disabled |> inspect(content="true")
}

///|
test "HTMLTextAreaElement - rows and cols" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let textarea : HTMLTextAreaElement = doc.createElement("textarea")
    |> @core.identity

  // Set rows and cols
  textarea.rows = 10
  textarea.cols = 50

  // Verify
  textarea.rows |> inspect(content="10")
  textarea.cols |> inspect(content="50")
}

///|
test "HTMLInputElement - create and access value" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let input : HTMLInputElement = doc.createElement("input") |> @core.identity

  // Read initial value
  input.value |> inspect(content="")

  // Write value
  input.value = "test input"

  // Read updated value
  input.value |> inspect(content="test input")
}

///|
test "HTMLInputElement - checked property" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let input : HTMLInputElement = doc.createElement("input") |> @core.identity
  input.setType("checkbox")

  // Check initial state
  input.checked |> inspect(content="false")

  // Check the checkbox
  input.checked = true

  // Verify checked
  input.checked |> inspect(content="true")
}

///|
test "HTMLInputElement - disabled property" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let input : HTMLInputElement = doc.createElement("input") |> @core.identity

  // Set disabled
  input.disabled = true

  // Verify
  input.disabled |> inspect(content="true")
}

///|
test "HTMLInputElement - placeholder property" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let input : HTMLInputElement = doc.createElement("input") |> @core.identity

  // Set placeholder
  input.placeholder = "Enter your name"

  // Verify
  input.placeholder |> inspect(content="Enter your name")
}

///|
test "HTMLCanvasElement - width and height properties" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let canvas : HTMLCanvasElement = doc.createElement("canvas") |> @core.identity

  // Set width and height
  canvas.width = 800
  canvas.height = 600

  // Verify
  canvas.width |> inspect(content="800")
  canvas.height |> inspect(content="600")
}

///|
test "HTMLCanvasElement - default dimensions" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let canvas : HTMLCanvasElement = doc.createElement("canvas") |> @core.identity

  // Check default dimensions (300x150 per HTML spec)
  canvas.width |> inspect(content="300")
  canvas.height |> inspect(content="150")
}

///|
test "HTMLIFrameElement - src and sandbox properties" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let iframe : HTMLIFrameElement = doc.createElement("iframe") |> @core.identity

  // Set src and sandbox
  iframe.src = "https://example.com"
  iframe.setAttribute("sandbox", "allow-scripts")

  // Verify (happy-dom normalizes URLs by adding trailing slash)
  iframe.src |> inspect(content="https://example.com/")
  // sandbox returns DOMTokenList in happy-dom, use getAttribute instead
  iframe.getAttribute("sandbox").unwrap() |> inspect(content="allow-scripts")
}

///|
test "HTMLIFrameElement - width and height properties" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let iframe : HTMLIFrameElement = doc.createElement("iframe") |> @core.identity

  // Set width and height as strings
  iframe.width = "640"
  iframe.height = "480"

  // Verify
  iframe.width |> inspect(content="640")
  iframe.height |> inspect(content="480")
}

///|
test "HTMLIFrameElement - name property" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let iframe : HTMLIFrameElement = doc.createElement("iframe") |> @core.identity

  // Set name
  iframe.name = "myFrame"

  // Verify
  iframe.name |> inspect(content="myFrame")
}
