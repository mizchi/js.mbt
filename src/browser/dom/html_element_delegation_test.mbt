///|
test "HTMLElement - tagName, append" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let html_elem = HTMLElement::cast_from_element(div)
  let span = doc.createElement("span")

  // tagName via HTMLElement
  html_elem.tagName() |> inspect(content="DIV")

  // append via HTMLElement
  html_elem.append(span.as_node())
  assert_eq(div.childNodes().length(), 1)
}

///|
test "HTMLElement - className, id" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let html_elem = HTMLElement::cast_from_element(div)

  // setClassName, className via HTMLElement
  html_elem.setClassName("test-class")
  html_elem.className() |> inspect(content="test-class")

  // setId, id via HTMLElement
  html_elem.setId("test-id")
  html_elem.id() |> inspect(content="test-id")
}

///|
test "HTMLElement - getAttribute, setAttribute, hasAttribute, removeAttribute" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let html_elem = HTMLElement::cast_from_element(div)

  // setAttribute, getAttribute via HTMLElement
  html_elem.setAttribute("data-test", "value")
  assert_eq(html_elem.getAttribute("data-test").unwrap(), "value")

  // hasAttribute via HTMLElement
  assert_eq(html_elem.hasAttribute("data-test"), true)

  // removeAttribute via HTMLElement
  html_elem.removeAttribute("data-test")
  assert_eq(html_elem.hasAttribute("data-test"), false)
}

///|
test "HTMLElement - getElementsByTagName, getElementsByClassName, querySelector, querySelectorAll" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let span1 = doc.createElement("span")
  let span2 = doc.createElement("span")
  span1.setClassName("highlight")
  span2.setClassName("highlight")
  div.appendChild(span1.as_node()) |> ignore
  div.appendChild(span2.as_node()) |> ignore
  let html_elem = HTMLElement::cast_from_element(div)

  // getElementsByTagName via HTMLElement
  let spans = html_elem.getElementsByTagName("span")
  assert_eq(spans.length(), 2)

  // getElementsByClassName via HTMLElement
  let highlights = html_elem.getElementsByClassName("highlight")
  assert_eq(highlights.length(), 2)

  // querySelector via HTMLElement
  let found = html_elem.querySelector("span")
  assert_eq(found is None, false)

  // querySelectorAll via HTMLElement
  let all = html_elem.querySelectorAll("span")
  assert_eq(all.length(), 2)
}

///|
test "HTMLElement - before, after, prepend, replaceChildren" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  let span = doc.createElement("span")
  let p = doc.createElement("p")
  body.appendChild(div.as_node()) |> ignore
  let html_elem = HTMLElement::cast_from_element(div)

  // before via HTMLElement
  html_elem.before([span.as_node()])
  assert_eq(body.childNodes().length() >= 2, true)

  // after via HTMLElement
  html_elem.after([p.as_node()])
  assert_eq(body.childNodes().length() >= 3, true)

  // prepend via HTMLElement
  let inner = doc.createElement("a")
  html_elem.prepend([inner.as_node()])
  assert_eq(div.childNodes().length() > 0, true)

  // replaceChildren via HTMLElement
  let new_child = doc.createElement("b")
  html_elem.replaceChildren([new_child.as_node()])
  assert_eq(div.childNodes().length(), 1)
}

///|
test "HTMLElement - insertAdjacentElement, insertAdjacentHTML, insertAdjacentText" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  body.appendChild(div.as_node()) |> ignore
  let html_elem = HTMLElement::cast_from_element(div)

  // insertAdjacentHTML via HTMLElement
  html_elem.insertAdjacentHTML("afterbegin", "<span>test</span>")
  assert_eq(div.childNodes().length() > 0, true)

  // insertAdjacentText via HTMLElement
  html_elem.insertAdjacentText("beforeend", "text")
  let inner = html_elem.innerHTML()
  assert_eq(inner.contains("text"), true)

  // insertAdjacentElement via HTMLElement
  let p = doc.createElement("p")
  let result = html_elem.insertAdjacentElement("afterend", p)
  assert_eq(result is None, false)
}

///|
test "HTMLElement - closest, matches, toggleAttribute" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  div.setClassName("container")
  let span = doc.createElement("span")
  div.appendChild(span.as_node()) |> ignore
  body.appendChild(div.as_node()) |> ignore
  let html_elem = HTMLElement::cast_from_element(span)

  // closest via HTMLElement
  let found = html_elem.closest(".container")
  assert_eq(found is None, false)

  // matches via HTMLElement
  span.setClassName("test")
  assert_eq(html_elem.matches(".test"), true)

  // toggleAttribute via HTMLElement
  let result = html_elem.toggleAttribute("disabled")
  assert_eq(result, true)
}

///|
test "HTMLElement - getAttributeNames, hasAttributes" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let html_elem = HTMLElement::cast_from_element(div)

  // hasAttributes via HTMLElement - no attributes
  assert_eq(html_elem.hasAttributes(), false)
  div.setAttribute("id", "test")
  div.setAttribute("class", "test-class")

  // hasAttributes via HTMLElement - with attributes
  assert_eq(html_elem.hasAttributes(), true)

  // getAttributeNames via HTMLElement
  let names = html_elem.getAttributeNames()
  assert_eq(names.length(), 2)
}

///|
test "HTMLElement - setOuterHTML" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  div.setId("to-replace-html")
  body.appendChild(div.as_node()) |> ignore
  let html_elem = HTMLElement::cast_from_element(div)

  // setOuterHTML via HTMLElement
  html_elem.setOuterHTML("<span id=\"replaced-html\">Content</span>")
  let found = doc.getElementById("replaced-html")
  assert_eq(found is None, false)
}

///|
test "HTMLElement - children, childElementCount, firstElementChild, lastElementChild" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let span = doc.createElement("span")
  let p = doc.createElement("p")
  div.appendChild(span.as_node()) |> ignore
  div.appendChild(p.as_node()) |> ignore
  let html_elem = HTMLElement::cast_from_element(div)

  // children via HTMLElement
  let children = html_elem.children()
  assert_eq(children.length(), 2)

  // childElementCount via HTMLElement
  html_elem.childElementCount() |> inspect(content="2")

  // firstElementChild via HTMLElement
  let first = html_elem.firstElementChild()
  assert_eq(first.unwrap().tagName(), "SPAN")

  // lastElementChild via HTMLElement
  let last = html_elem.lastElementChild()
  assert_eq(last.unwrap().tagName(), "P")
}

///|
test "HTMLElement - parentElement, nextElementSibling, previousElementSibling" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  parent.appendChild(child1.as_node()) |> ignore
  parent.appendChild(child2.as_node()) |> ignore
  let html_elem1 = HTMLElement::cast_from_element(child1)
  let html_elem2 = HTMLElement::cast_from_element(child2)

  // parentElement via HTMLElement
  let parent_elem = html_elem1.parentElement()
  assert_eq(parent_elem.unwrap().tagName(), "DIV")

  // nextElementSibling via HTMLElement
  let next = html_elem1.nextElementSibling()
  assert_eq(next.unwrap().tagName(), "P")

  // previousElementSibling via HTMLElement
  let prev = html_elem2.previousElementSibling()
  assert_eq(prev.unwrap().tagName(), "SPAN")
}

///|
test "HTMLElement - Node delegation (nodeType, nodeName, appendChild, childNodes)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  let span = doc.createElement("span")
  body.appendChild(div.as_node()) |> ignore
  let html_elem = HTMLElement::cast_from_element(div)

  // nodeType via HTMLElement
  html_elem.nodeType() |> inspect(content="1")

  // nodeName via HTMLElement
  html_elem.nodeName() |> inspect(content="DIV")

  // appendChild via HTMLElement
  html_elem.appendChild(span.as_node()) |> ignore
  assert_eq(div.childNodes().length(), 1)

  // childNodes via HTMLElement
  let children = html_elem.childNodes()
  assert_eq(children.length(), 1)

  // firstChild, lastChild via HTMLElement
  assert_eq(html_elem.firstChild() is None, false)
  assert_eq(html_elem.lastChild() is None, false)

  // parentNode via HTMLElement
  let parent_node = html_elem.parentNode()
  assert_eq(parent_node is None, false)

  // hasChildNodes via HTMLElement
  assert_eq(html_elem.hasChildNodes(), true)

  // contains via HTMLElement
  assert_eq(html_elem.contains(Some(span.as_node())), true)

  // isConnected via HTMLElement
  assert_eq(html_elem.isConnected(), true)
}

///|
test "HTMLElement - Node delegation (removeChild, insertBefore, replaceChild, cloneNode)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let span1 = doc.createElement("span")
  let span2 = doc.createElement("span")
  let span3 = doc.createElement("span")
  div.appendChild(span1.as_node()) |> ignore
  div.appendChild(span2.as_node()) |> ignore
  let html_elem = HTMLElement::cast_from_element(div)

  // insertBefore via HTMLElement
  html_elem.insertBefore(span3.as_node(), Some(span2.as_node())) |> ignore
  assert_eq(div.childNodes().length(), 3)

  // replaceChild via HTMLElement
  let new_span = doc.createElement("span")
  html_elem.replaceChild(new_span.as_node(), span3.as_node()) |> ignore
  assert_eq(div.childNodes().length(), 3)

  // cloneNode via HTMLElement
  let shallow = html_elem.cloneNode(false)
  assert_eq(shallow.hasChildNodes(), false)
  let deep = html_elem.cloneNode(true)
  assert_eq(deep.hasChildNodes(), true)

  // removeChild via HTMLElement
  html_elem.removeChild(span1.as_node()) |> ignore
  assert_eq(div.childNodes().length(), 2)
}

///|
test "HTMLElement - Node delegation (textContent, compareDocumentPosition, getRootNode)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()
  let div = doc.createElement("div")
  body.appendChild(div.as_node()) |> ignore
  let html_elem = HTMLElement::cast_from_element(div)

  // setTextContent, textContent via HTMLElement
  html_elem.setTextContent("Hello")
  html_elem.textContent() |> inspect(content="Hello")

  // compareDocumentPosition via HTMLElement
  let span = doc.createElement("span")
  div.appendChild(span.as_node()) |> ignore
  let pos = html_elem.compareDocumentPosition(span.as_node())
  assert_eq(pos > 0, true)

  // getRootNode via HTMLElement
  let root = html_elem.getRootNode()
  root.nodeName() |> inspect(content="#document")
}

///|
test "HTMLElement - Node delegation (isEqualNode, isSameNode, nodeValue, ownerDocument)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div1 = doc.createElement("div")
  let div2 = doc.createElement("div")
  let html_elem = HTMLElement::cast_from_element(div1)

  // isSameNode via HTMLElement
  assert_eq(html_elem.isSameNode(Some(div1.as_node())), true)
  assert_eq(html_elem.isSameNode(Some(div2.as_node())), false)

  // isEqualNode via HTMLElement
  assert_eq(html_elem.isEqualNode(Some(div2.as_node())), true)

  // nodeValue via HTMLElement (null for elements)
  assert_eq(html_elem.nodeValue() is None, true)

  // ownerDocument via HTMLElement
  assert_eq(html_elem.ownerDocument() is None, false)
}

///|
test "HTMLElement - Node delegation (previousSibling, nextSibling)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let parent = doc.createElement("div")
  let child1 = doc.createElement("span")
  let child2 = doc.createElement("p")
  parent.appendChild(child1.as_node()) |> ignore
  parent.appendChild(child2.as_node()) |> ignore
  let html_elem1 = HTMLElement::cast_from_element(child1)
  let html_elem2 = HTMLElement::cast_from_element(child2)

  // previousSibling via HTMLElement
  assert_eq(html_elem1.previousSibling() is None, true)
  assert_eq(html_elem2.previousSibling() is None, false)

  // nextSibling via HTMLElement
  assert_eq(html_elem1.nextSibling() is None, false)
  assert_eq(html_elem2.nextSibling() is None, true)
}
