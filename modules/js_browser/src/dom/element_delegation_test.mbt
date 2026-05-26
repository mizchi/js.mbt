///|
test "Element - Node delegation (nodeType, nodeName, isConnected)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let body = doc.body().unwrap()
  body.as_node().appendChild(div.as_node()) |> ignore

  // nodeType via Element delegation
  div.nodeType() |> inspect(content="1")

  // nodeName via Element delegation
  div.nodeName() |> inspect(content="DIV")

  // isConnected via Element delegation
  assert_eq(div.isConnected(), true)

  // disconnected element
  let disconnected = doc.createElement("span")
  assert_eq(disconnected.isConnected(), false)
}

///|
test "Element - Node delegation (parentNode, childNodes)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child = doc.createElement("span")
  parent.as_node().appendChild(child.as_node()) |> ignore

  // parentNode via Element delegation
  let parent_node = child.parentNode()
  assert_eq(parent_node is None, false)

  // childNodes via Element delegation
  let children = parent.childNodes()
  assert_eq(children.length(), 1)

  // firstChild, lastChild via Element delegation
  assert_eq(parent.firstChild() is None, false)
  assert_eq(parent.lastChild() is None, false)
}

///|
test "Element - Node delegation (appendChild, removeChild)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child = doc.createElement("span")

  // appendChild via Element delegation
  parent.appendChild(child.as_node()) |> ignore
  assert_eq(parent.childNodes().length(), 1)

  // removeChild via Element delegation
  parent.removeChild(child.as_node()) |> ignore
  assert_eq(parent.childNodes().length(), 0)
}

///|
test "Element - Node delegation (insertBefore, replaceChild)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  let child3 = doc.createElement("a")
  parent.appendChild(child1.as_node()) |> ignore
  parent.appendChild(child2.as_node()) |> ignore

  // insertBefore via Element delegation
  parent.insertBefore(child3.as_node(), Some(child2.as_node())) |> ignore
  assert_eq(parent.childNodes().length(), 3)

  // replaceChild via Element delegation
  let new_child = doc.createElement("div")
  parent.replaceChild(new_child.as_node(), child3.as_node()) |> ignore
  assert_eq(parent.childNodes().length(), 3)
}

///|
test "Element - Node delegation (cloneNode, contains, hasChildNodes)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child = doc.createElement("span")
  parent.appendChild(child.as_node()) |> ignore

  // hasChildNodes via Element delegation
  assert_eq(parent.hasChildNodes(), true)

  // cloneNode shallow via Element delegation
  let shallow_clone = parent.cloneNode(false)
  shallow_clone.hasChildNodes() |> inspect(content="false")

  // cloneNode deep via Element delegation
  let deep_clone = parent.cloneNode(true)
  deep_clone.hasChildNodes() |> inspect(content="true")

  // contains via Element delegation
  assert_eq(parent.contains(Some(child.as_node())), true)
  assert_eq(parent.contains(None), false)
}

///|
test "Element - Node delegation (textContent)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")

  // setTextContent and textContent via Element delegation
  div.setTextContent("Hello World")
  div.textContent() |> inspect(content="Hello World")
}

///|
test "Element - Node delegation (compareDocumentPosition, getRootNode)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div1 = doc.createElement("div")
  let div2 = doc.createElement("div")
  body.appendChild(div1.as_node()) |> ignore
  body.appendChild(div2.as_node()) |> ignore

  // compareDocumentPosition via Element delegation
  let pos = div1.compareDocumentPosition(div2.as_node())
  // Should be non-zero (DOCUMENT_POSITION_FOLLOWING)
  assert_eq(pos > 0, true)

  // getRootNode via Element delegation
  let root = div1.getRootNode()
  root.nodeName() |> inspect(content="#document")
}

///|
test "Element - Node delegation (isEqualNode, isSameNode)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div1 = doc.createElement("div")
  let div2 = doc.createElement("div")

  // isSameNode via Element delegation
  assert_eq(div1.isSameNode(Some(div1.as_node())), true)
  assert_eq(div1.isSameNode(Some(div2.as_node())), false)

  // isEqualNode via Element delegation - two empty divs are equal
  assert_eq(div1.isEqualNode(Some(div2.as_node())), true)
}

///|
test "Element - Node delegation (nodeValue, ownerDocument, siblings)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  parent.appendChild(child1.as_node()) |> ignore
  parent.appendChild(child2.as_node()) |> ignore

  // nodeValue for element is null
  assert_eq(child1.nodeValue() is None, true)

  // ownerDocument via Element delegation
  assert_eq(child1.ownerDocument() is None, false)

  // previousSibling, nextSibling via Element delegation
  assert_eq(child1.previousSibling() is None, true)
  assert_eq(child1.nextSibling() is None, false)
  assert_eq(child2.previousSibling() is None, false)
  assert_eq(child2.nextSibling() is None, true)
}

///|
test "Element - before, after, prepend" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  let span = doc.createElement("span")
  let p = doc.createElement("p")
  body.appendChild(div.as_node()) |> ignore

  // before - insert before div
  div.before([span.as_node()])
  assert_eq(body.childNodes().length() >= 2, true)

  // after - insert after div
  div.after([p.as_node()])
  assert_eq(body.childNodes().length() >= 3, true)

  // prepend - insert at beginning of div
  let inner = doc.createElement("a")
  div.prepend([inner.as_node()])
  assert_eq(div.as_node().firstChild() is None, false)
}

///|
test "Element - replaceWith, remove" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  let span = doc.createElement("span")
  body.appendChild(div.as_node()) |> ignore

  // replaceWith
  div.replaceWith([span.as_node()])
  assert_eq(div.parentNode() is None, true)

  // remove
  span.remove()
  assert_eq(span.parentNode() is None, true)
}

///|
test "Element - replaceChildren" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let span1 = doc.createElement("span")
  let span2 = doc.createElement("span")
  let p = doc.createElement("p")
  div.appendChild(span1.as_node()) |> ignore
  div.appendChild(span2.as_node()) |> ignore

  // replaceChildren - replace all children with new nodes
  div.replaceChildren([p.as_node()])
  assert_eq(div.childNodes().length(), 1)
  assert_eq(div.as_node().firstChild().unwrap().nodeName(), "P")
}

///|
test "Element - insertAdjacentElement" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  let span = doc.createElement("span")
  body.appendChild(div.as_node()) |> ignore

  // insertAdjacentElement - afterend
  let result = div.insertAdjacentElement("afterend", span)
  assert_eq(result is None, false)
}

///|
test "Element - insertAdjacentHTML, insertAdjacentText" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")

  // insertAdjacentHTML - afterbegin
  div.insertAdjacentHTML("afterbegin", "<span>test</span>")
  assert_eq(div.childNodes().length() > 0, true)

  // insertAdjacentText - beforeend
  div.insertAdjacentText("beforeend", "text content")
  let inner = HTMLElement::cast_from_element(div).innerHTML()
  assert_eq(inner.contains("text content"), true)
}

///|
test "Element - closest, matches" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let outer = doc.createElement("div")
  outer.setClassName("outer-class")
  let inner = doc.createElement("span")
  inner.setClassName("inner-class")
  outer.appendChild(inner.as_node()) |> ignore
  body.appendChild(outer.as_node()) |> ignore

  // closest - find ancestor matching selector
  let found = inner.closest(".outer-class")
  assert_eq(found is None, false)

  // closest - no match
  let not_found = inner.closest(".nonexistent")
  assert_eq(not_found is None, true)

  // matches - element matches selector
  assert_eq(inner.matches(".inner-class"), true)
  assert_eq(inner.matches(".other-class"), false)
}

///|
test "Element - toggleAttribute" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")

  // toggleAttribute - add attribute
  let result1 = div.toggleAttribute("disabled")
  assert_eq(result1, true)
  assert_eq(div.hasAttribute("disabled"), true)

  // toggleAttribute - remove attribute
  let result2 = div.toggleAttribute("disabled")
  assert_eq(result2, false)
  assert_eq(div.hasAttribute("disabled"), false)

  // toggleAttribute with force=true
  let result3 = div.toggleAttribute("hidden", force=true)
  assert_eq(result3, true)
  assert_eq(div.hasAttribute("hidden"), true)

  // toggleAttribute with force=false
  let result4 = div.toggleAttribute("hidden", force=false)
  assert_eq(result4, false)
  assert_eq(div.hasAttribute("hidden"), false)
}

///|
test "Element - getAttributeNames, hasAttributes" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")

  // hasAttributes - no attributes
  assert_eq(div.hasAttributes(), false)

  // Add attributes
  div.setAttribute("id", "test-id")
  div.setAttribute("class", "test-class")
  div.setAttribute("data-value", "123")

  // hasAttributes - with attributes
  assert_eq(div.hasAttributes(), true)

  // getAttributeNames
  let names = div.getAttributeNames()
  assert_eq(names.length(), 3)
}

///|
test "Element - removeAttribute" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  div.setAttribute("data-test", "value")
  assert_eq(div.hasAttribute("data-test"), true)

  // removeAttribute
  div.removeAttribute("data-test")
  assert_eq(div.hasAttribute("data-test"), false)
}

///|
test "Element - children, childElementCount" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  let text = doc.createTextNode("text")
  parent.appendChild(child1.as_node()) |> ignore
  parent.appendChild(text.as_node()) |> ignore
  parent.appendChild(child2.as_node()) |> ignore

  // children - only element children (not text nodes)
  let children = parent.children()
  assert_eq(children.length(), 2)

  // childElementCount
  parent.childElementCount() |> inspect(content="2")
}

///|
test "Element - firstElementChild, lastElementChild" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  parent.appendChild(child1.as_node()) |> ignore
  parent.appendChild(child2.as_node()) |> ignore

  // firstElementChild
  let first = parent.firstElementChild()
  assert_eq(first is None, false)
  assert_eq(first.unwrap().tagName(), "SPAN")

  // lastElementChild
  let last = parent.lastElementChild()
  assert_eq(last is None, false)
  assert_eq(last.unwrap().tagName(), "P")
}

///|
test "Element - parentElement, nextElementSibling, previousElementSibling" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  parent.appendChild(child1.as_node()) |> ignore
  parent.appendChild(child2.as_node()) |> ignore

  // parentElement
  let parent_elem = child1.parentElement()
  assert_eq(parent_elem is None, false)
  assert_eq(parent_elem.unwrap().tagName(), "DIV")

  // nextElementSibling
  let next = child1.nextElementSibling()
  assert_eq(next is None, false)
  assert_eq(next.unwrap().tagName(), "P")

  // previousElementSibling
  let prev = child2.previousElementSibling()
  assert_eq(prev is None, false)
  assert_eq(prev.unwrap().tagName(), "SPAN")
}

///|
test "Element - setOuterHTML" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  div.setId("to-replace")
  body.appendChild(div.as_node()) |> ignore

  // setOuterHTML - replace element with new HTML
  div.setOuterHTML("<span id=\"replaced\">New Content</span>")

  // Original div should be replaced
  let found = doc.getElementById("replaced")
  assert_eq(found is None, false)
}
