///|
test "Document - Node methods (nodeType, nodeName, childNodes)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()

  // nodeType for Document is 9
  doc.nodeType() |> inspect(content="9")

  // nodeName for Document is #document
  doc.nodeName() |> inspect(content="#document")

  // parentNode for Document should be None
  assert_eq(doc.parentNode() is None, true)

  // childNodes should include html element
  let children = doc.childNodes()
  assert_eq(children.length() > 0, true)

  // firstChild and lastChild
  assert_eq(doc.firstChild() is None, false)
  assert_eq(doc.lastChild() is None, false)

  // hasChildNodes
  assert_eq(doc.hasChildNodes(), true)
}

///|
test "Document - Node methods (contains, getRootNode, isConnected)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let body = doc.body().unwrap()

  // contains - document contains body
  assert_eq(doc.contains(Some(body.as_node())), true)

  // contains with None
  assert_eq(doc.contains(None), false)

  // getRootNode for document returns itself
  let root = doc.getRootNode()
  assert_eq(root.nodeName(), "#document")

  // isConnected - document is always connected
  assert_eq(doc.isConnected(), true)
}

///|
test "Document - Node methods (compareDocumentPosition)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()
  let div = doc.createElement("div")
  let body = doc.body().unwrap()
  body.as_node().appendChild(div.as_node()) |> ignore

  // compareDocumentPosition - document precedes elements
  let pos = doc.compareDocumentPosition(div.as_node())
  // Should be non-zero (DOCUMENT_POSITION_FOLLOWING | DOCUMENT_POSITION_CONTAINED_BY)
  assert_eq(pos > 0, true)
}

///|
test "Document - Node methods (isSameNode, isEqualNode)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()

  // isSameNode with itself
  assert_eq(doc.isSameNode(Some(doc.as_node())), true)

  // isSameNode with different node
  let div = doc.createElement("div")
  assert_eq(doc.isSameNode(Some(div.as_node())), false)

  // isSameNode with None
  assert_eq(doc.isSameNode(None), false)

  // isEqualNode with itself
  assert_eq(doc.isEqualNode(Some(doc.as_node())), true)
}

///|
test "Document - Node methods (ownerDocument, nodeValue)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()

  // ownerDocument for document is null
  assert_eq(doc.ownerDocument() is None, true)

  // nodeValue for document is null
  assert_eq(doc.nodeValue() is None, true)
}

///|
test "Document - Node methods (previousSibling, nextSibling)" {
  let window = @test_utils.create_happy_window()
  defer window.close()
  let doc = window.document()

  // previousSibling for document should be None
  assert_eq(doc.previousSibling() is None, true)

  // nextSibling for document should be None
  assert_eq(doc.nextSibling() is None, true)
}
