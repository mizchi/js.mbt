///|

///|
using @react {createElement, init_react_api}

///|
using @react_dom_server {renderToReadableStream, renderToString}

///|
fn init_react() -> Unit {
  init_react_api(@node.require("react"))
}

///| renderToString test

///|
test {
  it("renderToString should render a simple element", _ => {
    init_react()
    let element = createElement("div", [])
    let html = renderToString(element)
    inspect(html, content="<div></div>")
  })
}

///|
test {
  it("renderToString should render an element with text", _ => {
    init_react()
    let element = createElement("p", ["Hello, World!"])
    let html = renderToString(element)
    inspect(html, content="<p>Hello, World!</p>")
  })
}

///| renderToReadableStream tests

///|
extern "js" fn text_decoder_new() -> @js.Js =
  #|() => new TextDecoder()

///|
extern "js" fn text_decoder_decode(decoder : @js.Js, value : @js.Js) -> String =
  #|(decoder, value) => decoder.decode(value)

///|
test {
  it("renderToReadableStream should return a Promise of ReadableStream", _ => {
    init_react()
    let element = createElement("div", [])
    let stream = renderToReadableStream(element).unwrap()
    let reader = stream.getReader()

    // Read first chunk
    let result : @js.Js = reader.read().unwrap()
    let done : Bool = @js.unsafe_cast(result.get("done"))

    // Should have at least one chunk
    inspect(done, content="false")
    reader.releaseLock()
  })
}

///|
test {
  it("renderToReadableStream should render HTML content", _ => {
    init_react()
    let element = createElement("h1", ["Test Title"])
    let stream = renderToReadableStream(element).unwrap()
    let reader = stream.getReader()
    let html_parts : Array[String] = []
    let decoder = text_decoder_new()

    // Read all chunks
    while true {
      let result : @js.Js = reader.read().unwrap()
      let done : Bool = @js.unsafe_cast(result.get("done"))
      if done {
        break
      }
      let value : @js.Js = result.get("value")
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
  })
}

///|
test {
  it("renderToReadableStream should handle nested elements", _ => {
    init_react()
    let inner = createElement("span", ["Inner"])
    let outer = createElement("div", [inner])
    let stream = renderToReadableStream(outer).unwrap()
    let reader = stream.getReader()
    let html_parts : Array[String] = []
    let decoder = text_decoder_new()

    // Read all chunks
    while true {
      let result : @js.Js = reader.read().unwrap()
      let done : Bool = @js.unsafe_cast(result.get("done"))
      if done {
        break
      }
      let value : @js.Js = result.get("value")
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
  })
}
