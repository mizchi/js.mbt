///|
test "dom test" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  div.setAttribute("id", "test-div")
  div.setAttribute("data-value", "123")
  div.as_node().setTextContent("Hello, World!")
  assert_eq(div.as_node().textContent(), "Hello, World!")
  let body = doc.body().unwrap()
  body.as_element().append(div.as_node())
  assert_eq(div.getAttribute("id").unwrap(), "test-div")
  assert_eq(div.id(), "test-div")
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()

  // innerHTML test
  body.as_html_element().setInnerHTML("<span>Hello</span><p>World</p>")
  body.as_html_element().innerHTML()
  |> inspect(content="<span>Hello</span><p>World</p>")

  // innerText test - works in happy-dom
  body.as_html_element().setInnerText("Plain text")
  body.as_html_element().innerText() |> inspect(content="Plain text")
}

///|
test "HTMLElement trait - outerHTML" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()

  // createElement test
  let div = doc.createElement("div")
  div.tagName() |> inspect(content="DIV")

  // createTextNode test
  let text = doc.createTextNode("Hello, World!")
  text.as_node().textContent() |> inspect(content="Hello, World!")
}

///|
test "Document - document properties" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()

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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()

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
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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
test "cast_from - upcast Node to specific Element types" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child = doc.createElement("span")
  parent.as_node().appendChild(child.as_node()) |> ignore

  // Get first child as Node
  let first_child_node = parent.as_node().firstChild().unwrap()

  // Upcast Node to Element using cast_from_node
  let first_child_element = Element::cast_from_node(first_child_node)
  first_child_element.tagName() |> inspect(content="SPAN")

  // Upcast Node to HTMLElement using cast_from_node
  let first_child_html = HTMLElement::cast_from_node(first_child_node)
  // innerText works in happy-dom
  first_child_html.setInnerText("test")
  first_child_html.innerText() |> inspect(content="test")

  // Upcast Element to HTMLElement using cast_from_element
  let html_from_element = HTMLElement::cast_from_element(first_child_element)
  html_from_element.innerText() |> inspect(content="test")

  // Upcast Node directly to HTMLSpanElement
  let span = HTMLSpanElement::cast_from_node(first_child_node)
  span.tagName() |> inspect(content="SPAN")
}

///|
test "cast_from - upcast childNodes to specific types" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let span = doc.createElement("span")
  let p = doc.createElement("p")
  span.as_node().setTextContent("Hello")
  p.as_node().setTextContent("World")
  parent.as_node().appendChild(span.as_node()) |> ignore
  parent.as_node().appendChild(p.as_node()) |> ignore

  // childNodes returns Array[Node] - upcast each to Element
  let children = parent.as_node().childNodes()
  let elements = children.map(fn(node) { Element::cast_from_node(node) })
  elements.length() |> inspect(content="2")
  elements[0].tagName() |> inspect(content="SPAN")
  elements[1].tagName() |> inspect(content="P")

  // Upcast to HTMLElement to access innerText (works in happy-dom)
  let html_elements = children.map(fn(node) {
    HTMLElement::cast_from_node(node)
  })
  html_elements[0].innerText() |> inspect(content="Hello")
  html_elements[1].innerText() |> inspect(content="World")
}

///|
test "cast_from_event_target - upcast EventTarget to DOM types" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  div.setId("cast-test")
  div.as_node().setTextContent("Test Content")

  // Get as EventTarget
  let event_target = div.as_event_target()

  // Upcast EventTarget to Node
  let as_node = Node::cast_from_event_target(event_target)
  as_node.nodeName() |> inspect(content="DIV")

  // Upcast EventTarget to Element
  let as_element = Element::cast_from_event_target(event_target)
  as_element.tagName() |> inspect(content="DIV")

  // Upcast EventTarget to HTMLElement
  let as_html = HTMLElement::cast_from_event_target(event_target)
  as_html.innerText() |> inspect(content="Test Content")

  // Upcast EventTarget directly to HTMLDivElement
  let as_div = HTMLDivElement::cast_from_event_target(event_target)
  as_div.id() |> inspect(content="cast-test")
}

///|
test "EventTarget - removeEventListener" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
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

///|
test "ShadowRoot - attachShadow and basic properties" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let div_html = HTMLElement::cast_from_element(div)
  let body = doc.body().unwrap()
  body.as_node().appendChild(div.as_node()) |> ignore

  // attachShadow test with open mode
  let shadow = div_html.attachShadow(ShadowRootInit::new("open"))

  // mode test
  shadow.mode() |> inspect(content="open")

  // host test
  shadow.host().tagName() |> inspect(content="DIV")

  // shadowRoot should be accessible for open mode
  let retrieved = div_html.shadowRoot()
  assert_eq(retrieved is None, false)
}

///|
test "ShadowRoot - closed mode" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let div_html = HTMLElement::cast_from_element(div)
  let body = doc.body().unwrap()
  body.as_node().appendChild(div.as_node()) |> ignore

  // attachShadow with closed mode
  let shadow = div_html.attachShadow(ShadowRootInit::new("closed"))
  shadow.mode() |> inspect(content="closed")

  // shadowRoot should NOT be accessible for closed mode
  let retrieved = div_html.shadowRoot()
  assert_eq(retrieved is None, true)
}

///|
test "ShadowRoot - innerHTML" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let div_html = HTMLElement::cast_from_element(div)
  let body = doc.body().unwrap()
  body.as_node().appendChild(div.as_node()) |> ignore
  let shadow = div_html.attachShadow(ShadowRootInit::new("open"))

  // setInnerHTML test
  shadow.setInnerHTML("<span>Shadow Content</span>")
  shadow.innerHTML() |> inspect(content="<span>Shadow Content</span>")
}

///|
test "ShadowRoot - as_node operations" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let div_html = HTMLElement::cast_from_element(div)
  let body = doc.body().unwrap()
  body.as_node().appendChild(div.as_node()) |> ignore
  let shadow = div_html.attachShadow(ShadowRootInit::new("open"))

  // Add elements to shadow root via as_node
  let span = doc.createElement("span")
  span.as_node().setTextContent("Hello Shadow DOM")
  shadow.as_node().appendChild(span.as_node()) |> ignore

  // Verify children
  assert_eq(shadow.as_node().hasChildNodes(), true)
  shadow.as_node().childNodes().length() |> inspect(content="1")
}

///|
test "ShadowRoot - ShadowRootInit options" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let div_html = HTMLElement::cast_from_element(div)
  let body = doc.body().unwrap()
  body.as_node().appendChild(div.as_node()) |> ignore

  // Test with slotAssignment option
  let init = ShadowRootInit::new("open", slotAssignment="named")
  let shadow = div_html.attachShadow(init)
  shadow.mode() |> inspect(content="open")
  shadow.slotAssignment() |> inspect(content="named")
}

///|
test "CustomElementRegistry - get and define_" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let registry = window.customElements()
  let html_element = window.htmlElementClass()

  // Before defining, get should return None
  let before = registry.get("my-test-element")
  assert_eq(before is None, true)

  // Define a custom element using define_ with html_element_class
  registry.define_("my-test-element", html_element_class=html_element)

  // After defining, get should return the constructor
  let after = registry.get("my-test-element")
  assert_eq(after is None, false)
}

///|
test "CustomElementRegistry - getName with happy-dom" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let registry = window.customElements()
  let html_element = window.htmlElementClass()
  registry.define_("my-named-element", html_element_class=html_element)

  // Get the constructor
  let ctor = registry.get("my-named-element").unwrap()

  // getName should return the element name
  let name = registry.getName(ctor)
  name |> inspect(content="Some(\"my-named-element\")")
}

///|
test "CustomElementRegistry - upgrade with happy-dom" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let registry = window.customElements()
  let html_element = window.htmlElementClass()

  // Create element before defining
  let element = doc.createElement("my-upgrade-element")
  let body = doc.body().unwrap()
  body.as_node().appendChild(element.as_node()) |> ignore

  // Define the custom element
  registry.define_("my-upgrade-element", html_element_class=html_element)

  // Upgrade should work without error
  registry.upgrade(element.as_node())
}

///|
test "CustomElementRegistry - lifecycle callbacks with happy-dom" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let registry = window.customElements()
  let html_element = window.htmlElementClass()
  let mut connected_called = false
  let mut disconnected_called = false
  registry.define_(
    "my-lifecycle-element",
    on_connected=fn() { connected_called = true },
    on_disconnected=fn() { disconnected_called = true },
    html_element_class=html_element,
  )

  // Create and append element
  let element = doc.createElement("my-lifecycle-element")
  let body = doc.body().unwrap()
  body.as_node().appendChild(element.as_node()) |> ignore

  // connectedCallback should have been called
  assert_eq(connected_called, true)

  // Remove element
  body.as_node().removeChild(element.as_node()) |> ignore

  // disconnectedCallback should have been called
  assert_eq(disconnected_called, true)
}

///|
test "CustomElementRegistry - define_ with observed_attributes" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let registry = window.customElements()
  let html_element = window.htmlElementClass()
  registry.define_(
    "my-observed-element",
    observed_attributes=["data-value", "data-name"],
    html_element_class=html_element,
  )

  // Verify element is defined
  let ctor = registry.get("my-observed-element")
  assert_eq(ctor is None, false)
}
