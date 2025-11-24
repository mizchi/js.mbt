///|

///|

///|

///|
fn init_react() -> Unit {
  @react.init_react_api(@node.require("react"))
}

///| renderToString test

///|
async test "React DOM Server: renderToString should render a simple element" {
  init_react()
  let element = @react.createElement("div", [])
  let html = @react_dom_server.renderToString(element)
  inspect(html, content="<div></div>")
}

///|
async test "React DOM Server: renderToString should render an element with text" {
  init_react()
  let element = @react.createElement("p", ["Hello, World!"])
  let html = @react_dom_server.renderToString(element)
  inspect(html, content="<p>Hello, World!</p>")
}

///| renderToReadableStream tests

///|
extern "js" fn text_decoder_new() -> @js.Any =
  #|() => new TextDecoder()

///|
extern "js" fn text_decoder_decode(decoder : @js.Any, value : @js.Any) -> String =
  #|(decoder, value) => decoder.decode(value)

///|
async test "React DOM Server: renderToReadableStream should return a Promise of ReadableStream" {
  init_react()
  let element = @react.createElement("div", [])
  let stream = @react_dom_server.renderToReadableStream(element).wait()
  let reader = stream.getReader()

  // Read first chunk
  let result : @js.Any = reader.read().wait()
  let done : Bool = @js.identity(result.get("done"))

  // Should have at least one chunk
  inspect(done, content="false")
  reader.releaseLock()
}

///|
async test "React DOM Server: renderToReadableStream should render HTML content" {
  init_react()
  let element = @react.createElement("h1", ["Test Title"])
  let stream = @react_dom_server.renderToReadableStream(element).wait()
  let reader = stream.getReader()
  let html_parts : Array[String] = []
  let decoder = text_decoder_new()

  // Read all chunks
  while true {
    let result : @js.Any = reader.read().wait()
    let done : Bool = @js.identity(result.get("done"))
    if done {
      break
    }
    let value : @js.Any = result.get("value")
    let chunk = text_decoder_decode(decoder, value)
    html_parts.push(chunk)
  }
  reader.releaseLock()
  let html = html_parts.join("")
  // Check if HTML contains the expected content
  let contains_h1 = html.contains("h1")
  let contains_title = html.contains("Test Title")
  inspect(contains_h1, content="true")
  inspect(contains_title, content="true")
}

///|
async test "React DOM Server: renderToReadableStream should handle nested elements" {
  init_react()
  let inner = @react.createElement("span", ["Inner"])
  let outer = @react.createElement("div", [inner])
  let stream = @react_dom_server.renderToReadableStream(outer).wait()
  let reader = stream.getReader()
  let html_parts : Array[String] = []
  let decoder = text_decoder_new()

  // Read all chunks
  while true {
    let result : @js.Any = reader.read().wait()
    let done : Bool = @js.identity(result.get("done"))
    if done {
      break
    }
    let value : @js.Any = result.get("value")
    let chunk = text_decoder_decode(decoder, value)
    html_parts.push(chunk)
  }
  reader.releaseLock()
  let html = html_parts.join("")
  let contains_div = html.contains("div")
  let contains_span = html.contains("span")
  let contains_inner = html.contains("Inner")
  inspect(contains_div, content="true")
  inspect(contains_span, content="true")
  inspect(contains_inner, content="true")
}
