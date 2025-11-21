///|
test "dom test" {
  @global_jsdom.register()
  let doc = document()
  let div = doc.createElement("div")
  div.setAttribute("id", "test-div")
  div.setAttribute("data-value", "123")
  div.setTextContent("Hello, World!")
  assert_eq(div.textContent(), "Hello, World!")
  let body = doc.body().unwrap()
  body.append(div)
  assert_eq(div.getAttribute("id").unwrap(), "test-div")
  assert_eq(div.id(), "test-div")
  // println("Added div to body")
  body.append(doc.createElement("p"))
  body.innerHTML()
  |> inspect(
    content=(
      #|<div id="test-div" data-value="123">Hello, World!</div><p></p>
    ),
  )
}

///|
test "Node trait - appendChild, removeChild, childNodes" {
  @global_jsdom.register()
  let doc = document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")

  // appendChild test
  parent.appendChild(child1) |> ignore
  parent.appendChild(child2) |> ignore
  assert_eq(parent.childNodes().length(), 2)

  // childNodes test
  let children = parent.childNodes()
  assert_eq(children.length(), 2)

  // removeChild test
  parent.removeChild(child1) |> ignore
  assert_eq(parent.childNodes().length(), 1)
}

///|
test "Node trait - insertBefore, replaceChild" {
  @global_jsdom.register()
  let doc = document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  let child3 = doc.createElement("a")
  parent.appendChild(child1) |> ignore
  parent.appendChild(child2) |> ignore

  // insertBefore test
  parent.insertBefore(child3, Some(child2)) |> ignore
  let children = parent.childNodes()
  assert_eq(children.length(), 3)

  // replaceChild test
  let new_child = doc.createElement("div")
  parent.replaceChild(new_child, child3) |> ignore
  assert_eq(parent.childNodes().length(), 3)
}

///|
test "Node trait - cloneNode, contains, hasChildNodes" {
  @global_jsdom.register()
  let doc = document()
  let parent = doc.createElement("div")
  let child = doc.createElement("span")
  parent.appendChild(child) |> ignore

  // hasChildNodes test
  assert_eq(parent.hasChildNodes(), true)

  // cloneNode shallow
  let shallow_clone = parent.cloneNode(false)
  shallow_clone.hasChildNodes() |> inspect(content="false")

  // cloneNode deep
  let deep_clone = parent.cloneNode(true)
  deep_clone.hasChildNodes() |> inspect(content="true")

  // contains test
  assert_eq(parent.contains(Some(child)), true)
  assert_eq(parent.contains(None), false)
}

///|
test "Node trait - node properties" {
  @global_jsdom.register()
  let doc = document()
  let div = doc.createElement("div")
  let span = doc.createElement("span")
  let text = doc.createTextNode("test")
  div.appendChild(span) |> ignore
  span.appendChild(text) |> ignore

  // nodeName test
  div.nodeName() |> inspect(content="DIV")

  // nodeType test (1 = ELEMENT_NODE)
  div.nodeType() |> inspect(content="1")

  // firstChild, lastChild test
  assert_eq(div.firstChild().is_empty(), false)
  assert_eq(div.lastChild().is_empty(), false)

  // parentNode test
  assert_eq(span.parentNode().is_empty(), false)
}

///|
test "Node trait - sibling navigation" {
  @global_jsdom.register()
  let doc = document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  parent.appendChild(child1) |> ignore
  parent.appendChild(child2) |> ignore

  // Test that parent has children
  assert_eq(parent.hasChildNodes(), true)
  assert_eq(parent.childNodes().length(), 2)

  // Test firstChild and lastChild
  assert_eq(parent.firstChild().is_empty(), false)
  assert_eq(parent.lastChild().is_empty(), false)
}

///|
test "Element trait - attributes" {
  @global_jsdom.register()
  let doc = document()
  let div = doc.createElement("div")

  // setAttribute, getAttribute test
  div.setAttribute("data-test", "value123")
  assert_eq(div.getAttribute("data-test").unwrap(), "value123")

  // hasAttribute test
  assert_eq(div.hasAttribute("data-test"), true)
  assert_eq(div.hasAttribute("nonexistent"), false)

  // Test multiple attributes
  div.setAttribute("id", "my-id")
  div.setAttribute("class", "my-class")
  assert_eq(div.hasAttribute("id"), true)
  assert_eq(div.hasAttribute("class"), true)
}

///|
test "Element trait - id and className" {
  @global_jsdom.register()
  let doc = document()
  let div = doc.createElement("div")

  // id test
  div.setId("test-id")
  div.id() |> inspect(content="test-id")

  // className test
  div.setClassName("class1 class2")
  div.className() |> inspect(content="class1 class2")

  // tagName test
  div.tagName() |> inspect(content="DIV")
}

///|
test "Element trait - querySelector and querySelectorAll" {
  @global_jsdom.register()
  let doc = document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("span")
  let child3 = doc.createElement("p")
  child1.setClassName("test-class")
  child2.setClassName("test-class")
  child3.setId("unique-id")
  parent.appendChild(child1) |> ignore
  parent.appendChild(child2) |> ignore
  parent.appendChild(child3) |> ignore
  let body = doc.body().unwrap()
  body.appendChild(parent) |> ignore

  // querySelector test
  let found = parent.querySelector(".test-class")
  assert_eq(found.is_empty(), false)

  // querySelectorAll test
  let all_spans = parent.querySelectorAll("span")
  all_spans.length() |> inspect(content="2")

  // querySelector by id
  let by_id = parent.querySelector("#unique-id")
  assert_eq(by_id.is_empty(), false)
}

///|
test "Element trait - getElementsByTagName and getElementsByClassName" {
  @global_jsdom.register()
  let doc = document()
  let parent = doc.createElement("div")
  let span1 = doc.createElement("span")
  let span2 = doc.createElement("span")
  let p = doc.createElement("p")
  span1.setClassName("highlight")
  span2.setClassName("highlight")
  parent.appendChild(span1) |> ignore
  parent.appendChild(span2) |> ignore
  parent.appendChild(p) |> ignore

  // getElementsByTagName test
  let spans = parent.getElementsByTagName("span")
  spans.length() |> inspect(content="2")

  // getElementsByClassName test
  let highlights = parent.getElementsByClassName("highlight")
  highlights.length() |> inspect(content="2")
}

///|
test "HTMLElement trait - innerHTML and innerText" {
  @global_jsdom.register()
  let doc = document()
  let body = doc.body().unwrap()

  // innerHTML test
  body.setInnerHTML("<span>Hello</span><p>World</p>")
  body.innerHTML() |> inspect(content="<span>Hello</span><p>World</p>")

  // innerText test
  body.setInnerText("Plain text")
  body.innerText() |> inspect(content="Plain text")
}

///|
test "HTMLElement trait - outerHTML" {
  @global_jsdom.register()
  let doc = document()
  let body = doc.body().unwrap()
  body.setId("outer-test")
  body.setInnerHTML("<span>Content</span>")

  // outerHTML test
  let outer = body.outerHTML()
  assert_eq(outer.contains("<body"), true)
  assert_eq(outer.contains("id=\"outer-test\""), true)
  assert_eq(outer.contains("<span>Content</span>"), true)
}

///|
test "Document - createElement and createTextNode" {
  @global_jsdom.register()
  let doc = document()

  // createElement test
  let div = doc.createElement("div")
  div.tagName() |> inspect(content="DIV")

  // createTextNode test
  let text = doc.createTextNode("Hello, World!")
  text.textContent() |> inspect(content="Hello, World!")
}

///|
test "Document - document properties" {
  @global_jsdom.register()
  let doc = document()

  // title test
  doc.setTitle("Test Title")
  doc.title() |> inspect(content="Test Title")

  // readyState test
  let state = doc.readyState()
  assert_eq(state.length() > 0, true)

  // characterSet test
  let charset = doc.characterSet()
  assert_eq(charset.length() > 0, true)

  // contentType test
  let content_type = doc.contentType()
  assert_eq(content_type.length() > 0, true)
}

///|
test "Document - getElementById and document element accessors" {
  @global_jsdom.register()
  let doc = document()
  let div = doc.createElement("div")
  div.setId("test-element")
  let body = doc.body().unwrap()
  body.appendChild(div) |> ignore

  // getElementById test
  let found = doc.getElementById("test-element")
  assert_eq(found.is_empty(), false)

  // body test
  assert_eq(doc.body().is_empty(), false)

  // head test
  assert_eq(doc.head().is_empty(), false)

  // documentElement test
  let root = doc.documentElement()
  root.tagName() |> inspect(content="HTML")
}

///|
test "Document - createDocumentFragment and createComment" {
  @global_jsdom.register()
  let doc = document()

  // createDocumentFragment test
  let fragment = doc.createDocumentFragment()
  // Verify fragment is created - just ensure no exception is thrown
  let _ = fragment

  // createComment test
  let comment = doc.createComment("This is a comment")
  // Verify comment is created - just ensure no exception is thrown
  let _ = comment

}

///|
test "EventTarget - addEventListener and dispatchEvent" {
  @global_jsdom.register()
  let doc = document()
  let div = doc.createElement("div")
  let mut event_fired = false

  // addEventListener test
  div.addEventListener("click", fn(_event) { event_fired = true })

  // Create and dispatch custom event
  let event = doc.createEvent("Event")
  event.call("initEvent", ["click", false, false]) |> ignore

  // dispatchEvent test
  let result = div.dispatchEvent(event.to_js())
  assert_eq(result, true)
  assert_eq(event_fired, true)
}

///|
test "EventTarget - removeEventListener" {
  @global_jsdom.register()
  let doc = document()
  let div = doc.createElement("div")
  let mut call_count = 0
  let handler = fn(_event) { call_count = call_count + 1 }

  // Add event listener
  div.addEventListener("test-event", handler)

  // Create and dispatch event
  let event = doc.createEvent("Event")
  event.call("initEvent", ["test-event", false, false]) |> ignore
  div.dispatchEvent(event.to_js()) |> ignore
  assert_eq(call_count, 1)

  // Remove event listener
  div.removeEventListener("test-event", handler)

  // Dispatch event again - should not fire
  let event2 = doc.createEvent("Event")
  event2.call("initEvent", ["test-event", false, false]) |> ignore
  div.dispatchEvent(event2.to_js()) |> ignore

  // Count should still be 1
  assert_eq(call_count, 1)
}
