///|
test "dom test" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let div = doc.createElement("div")
  div.setAttribute("id", "test-div")
  div.setAttribute("data-value", "123")
  div.as_node().setTextContent("Hello, World!")
  assert_eq(div.as_node().textContent(), "Hello, World!")
  let body = doc.body().unwrap()
  body.as_element().append(div.as_node())
  assert_eq(div.getAttribute("id").unwrap(), "test-div")
  assert_eq(div.id(), "test-div")
  // println("Added div to body")
  body.as_element().append(doc.createElement("p").as_node())
  body.as_html_element().innerHTML()
  |> inspect(
    content=(
      #|<div id="test-div" data-value="123">Hello, World!</div><p></p>
    ),
  )
}

///|
test "Node trait - appendChild, removeChild, childNodes" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")

  // appendChild test
  parent.as_node().appendChild(child1.as_node()) |> ignore
  parent.as_node().appendChild(child2.as_node()) |> ignore
  assert_eq(parent.as_node().childNodes().length(), 2)

  // childNodes test
  let children = parent.as_node().childNodes()
  assert_eq(children.length(), 2)

  // removeChild test
  parent.as_node().removeChild(child1.as_node()) |> ignore
  assert_eq(parent.as_node().childNodes().length(), 1)
}

///|
test "Node trait - insertBefore, replaceChild" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  let child3 = doc.createElement("a")
  parent.as_node().appendChild(child1.as_node()) |> ignore
  parent.as_node().appendChild(child2.as_node()) |> ignore

  // insertBefore test
  parent.as_node().insertBefore(child3.as_node(), Some(child2.as_node()))
  |> ignore
  let children = parent.as_node().childNodes()
  assert_eq(children.length(), 3)

  // replaceChild test
  let new_child = doc.createElement("div")
  parent.as_node().replaceChild(new_child.as_node(), child3.as_node()) |> ignore
  assert_eq(parent.as_node().childNodes().length(), 3)
}

///|
test "Node trait - cloneNode, contains, hasChildNodes" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let parent = doc.createElement("div")
  let child = doc.createElement("span")
  parent.as_node().appendChild(child.as_node()) |> ignore

  // hasChildNodes test
  assert_eq(parent.as_node().hasChildNodes(), true)

  // cloneNode shallow
  let shallow_clone = parent.as_node().cloneNode(false)
  shallow_clone.hasChildNodes() |> inspect(content="false")

  // cloneNode deep
  let deep_clone = parent.as_node().cloneNode(true)
  deep_clone.hasChildNodes() |> inspect(content="true")

  // contains test
  assert_eq(parent.as_node().contains(Some(child.as_node())), true)
  assert_eq(parent.as_node().contains(None), false)
}

///|
test "Node trait - node properties" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let div = doc.createElement("div")
  let span = doc.createElement("span")
  let text = doc.createTextNode("test")
  div.as_node().appendChild(span.as_node()) |> ignore
  span.as_node().appendChild(text.as_node()) |> ignore

  // nodeName test
  div.as_node().nodeName() |> inspect(content="DIV")

  // nodeType test (1 = ELEMENT_NODE)
  div.as_node().nodeType() |> inspect(content="1")

  // firstChild, lastChild test
  assert_eq(div.as_node().firstChild() is None, false)
  assert_eq(div.as_node().lastChild() is None, false)

  // parentNode test
  assert_eq(span.as_node().parentNode() is None, false)
}

///|
test "Node trait - sibling navigation" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  parent.as_node().appendChild(child1.as_node()) |> ignore
  parent.as_node().appendChild(child2.as_node()) |> ignore

  // Test that parent has children
  assert_eq(parent.as_node().hasChildNodes(), true)
  assert_eq(parent.as_node().childNodes().length(), 2)

  // Test firstChild and lastChild
  assert_eq(parent.as_node().firstChild() is None, false)
  assert_eq(parent.as_node().lastChild() is None, false)
}

///|
test "Element trait - attributes" {
  @test_utils.global_jsdom_register()
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
  @test_utils.global_jsdom_register()
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
  @test_utils.global_jsdom_register()
  let doc = document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("span")
  let child3 = doc.createElement("p")
  child1.setClassName("test-class")
  child2.setClassName("test-class")
  child3.setId("unique-id")
  parent.as_node().appendChild(child1.as_node()) |> ignore
  parent.as_node().appendChild(child2.as_node()) |> ignore
  parent.as_node().appendChild(child3.as_node()) |> ignore
  let body = doc.body().unwrap()
  body.as_node().appendChild(parent.as_node()) |> ignore

  // querySelector test
  let found = parent.querySelector(".test-class")
  assert_eq(found is None, false)

  // querySelectorAll test
  let all_spans = parent.querySelectorAll("span")
  all_spans.length() |> inspect(content="2")

  // querySelector by id
  let by_id = parent.querySelector("#unique-id")
  assert_eq(by_id is None, false)
}

///|
test "Element trait - getElementsByTagName and getElementsByClassName" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let parent = doc.createElement("div")
  let span1 = doc.createElement("span")
  let span2 = doc.createElement("span")
  let p = doc.createElement("p")
  span1.setClassName("highlight")
  span2.setClassName("highlight")
  parent.as_node().appendChild(span1.as_node()) |> ignore
  parent.as_node().appendChild(span2.as_node()) |> ignore
  parent.as_node().appendChild(p.as_node()) |> ignore

  // getElementsByTagName test
  let spans = parent.getElementsByTagName("span")
  spans.length() |> inspect(content="2")

  // getElementsByClassName test
  let highlights = parent.getElementsByClassName("highlight")
  highlights.length() |> inspect(content="2")
}

///|
test "HTMLElement trait - innerHTML and innerText" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let body = doc.body().unwrap()

  // innerHTML test
  body.as_html_element().setInnerHTML("<span>Hello</span><p>World</p>")
  body.as_html_element().innerHTML()
  |> inspect(content="<span>Hello</span><p>World</p>")

  // innerText test
  body.as_html_element().setInnerText("Plain text")
  body.as_html_element().innerText() |> inspect(content="Plain text")
}

///|
test "HTMLElement trait - outerHTML" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let body = doc.body().unwrap()
  body.as_element().setId("outer-test")
  body.as_html_element().setInnerHTML("<span>Content</span>")

  // outerHTML test
  let outer = body.as_html_element().outerHTML()
  assert_eq(outer.contains("<body"), true)
  assert_eq(outer.contains("id=\"outer-test\""), true)
  assert_eq(outer.contains("<span>Content</span>"), true)
}

///|
test "Document - createElement and createTextNode" {
  @test_utils.global_jsdom_register()
  let doc = document()

  // createElement test
  let div = doc.createElement("div")
  div.tagName() |> inspect(content="DIV")

  // createTextNode test
  let text = doc.createTextNode("Hello, World!")
  text.as_node().textContent() |> inspect(content="Hello, World!")
}

///|
test "Document - document properties" {
  @test_utils.global_jsdom_register()
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
  @test_utils.global_jsdom_register()
  let doc = document()
  let div = doc.createElement("div")
  div.setId("test-element")
  let body = doc.body().unwrap()
  body.as_node().appendChild(div.as_node()) |> ignore

  // getElementById test
  let found = doc.getElementById("test-element")
  assert_eq(found is None, false)

  // body test
  assert_eq(doc.body() is None, false)

  // head test
  assert_eq(doc.head() is None, false)

  // documentElement test
  let root = doc.documentElement()
  root.tagName() |> inspect(content="HTML")
}

///|
test "Document - querySelector and querySelectorAll" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let body = doc.body().unwrap()

  // Create test elements
  let div1 = doc.createElement("div")
  div1.setId("app")
  div1.setClassName("container")
  let div2 = doc.createElement("div")
  div2.setClassName("container")
  let span = doc.createElement("span")
  span.setClassName("text")
  body.as_node().appendChild(div1.as_node()) |> ignore
  body.as_node().appendChild(div2.as_node()) |> ignore
  div1.as_node().appendChild(span.as_node()) |> ignore

  // querySelector by id
  let app = doc.querySelector("#app")
  assert_eq(app is None, false)
  assert_eq(app.unwrap().id(), "app")

  // querySelector by class
  let container = doc.querySelector(".container")
  assert_eq(container is None, false)

  // querySelector by tag
  let first_span = doc.querySelector("span")
  assert_eq(first_span is None, false)

  // querySelectorAll by class
  let containers = doc.querySelectorAll(".container")
  containers.length() |> inspect(content="2")

  // querySelectorAll by tag
  let divs = doc.querySelectorAll("div")
  assert_eq(divs.length() >= 2, true)

  // querySelector that doesn't match
  let not_found = doc.querySelector(".nonexistent")
  assert_eq(not_found is None, true)
}

///|
test "Document - createDocumentFragment and createComment" {
  @test_utils.global_jsdom_register()
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
  @test_utils.global_jsdom_register()
  let doc = document()
  let div = doc.createElement("div")
  let mut event_fired = false

  // addEventListener test
  let handler = fn(_event) { event_fired = true }
  div.as_event_target().addEventListener("click", handler)
  defer div.as_event_target().removeEventListener("click", handler)

  // Create and dispatch custom event
  let event = doc.createEvent("Event")
  event
  .as_any()
  ._call("initEvent", [@core.any("click"), @core.any(false), @core.any(false)])
  |> ignore

  // dispatchEvent test
  let result = div.as_event_target().dispatchEvent(event.as_event())
  assert_eq(result, true)
  assert_eq(event_fired, true)
}

///|
test "EventTarget - removeEventListener" {
  @test_utils.global_jsdom_register()
  let doc = document()
  let div = doc.createElement("div")
  let mut call_count = 0
  let handler = fn(_event) { call_count = call_count + 1 }

  // Add event listener
  div.as_event_target().addEventListener("test-event", handler)

  // Create and dispatch event
  let event = doc.createEvent("Event")
  event
  .as_any()
  ._call("initEvent", [
    @core.any("test-event"),
    @core.any(false),
    @core.any(false),
  ])
  |> ignore
  div.as_event_target().dispatchEvent(event.as_event()) |> ignore
  assert_eq(call_count, 1)

  // Remove event listener
  div.as_event_target().removeEventListener("test-event", handler)

  // Dispatch event again - should not fire
  let event2 = doc.createEvent("Event")
  event2
  .as_any()
  ._call("initEvent", [
    @core.any("test-event"),
    @core.any(false),
    @core.any(false),
  ])
  |> ignore
  div.as_event_target().dispatchEvent(event2.as_event()) |> ignore

  // Count should still be 1
  assert_eq(call_count, 1)
}
