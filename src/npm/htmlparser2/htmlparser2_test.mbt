///|
/// htmlparser2 bindings tests

///|
test "parse simple html" {
  let html = "<div>Hello</div>"
  let doc = @htmlparser2.parseDocument(html)
  let children = doc.children()
  inspect(children.length() > 0, content="true")
}

///|
test "parse and get text" {
  let html = "<div>Hello <span>World</span></div>"
  let doc = @htmlparser2.parseDocument(html)
  let divs = @htmlparser2.getElementsByTagName(doc, "div")
  let div = divs[0]
  // Convert Element to Node to use getText
  let node : @htmlparser2.Node = @core.identity(div.as_any())
  let text = @htmlparser2.getText(node)
  inspect(text, content="Hello World")
}

///|
test "get elements by tag name" {
  let html = "<div><p>First</p><p>Second</p></div>"
  let doc = @htmlparser2.parseDocument(html)
  let paragraphs = @htmlparser2.getElementsByTagName(doc, "p")
  inspect(paragraphs.length(), content="2")
}

///|
test "get element by id" {
  let html = "<div id=\"main\"><span id=\"child\">Text</span></div>"
  let doc = @htmlparser2.parseDocument(html)
  let elem = @htmlparser2.getElementById(doc, "main")
  inspect(elem is Some(_), content="true")
  guard elem is Some(e) else { return }
  inspect(e.name(), content="div")
}

///|
test "element attributes" {
  let html = "<a href=\"https://example.com\" class=\"link\">Click</a>"
  let doc = @htmlparser2.parseDocument(html)
  let links = @htmlparser2.getElementsByTagName(doc, "a")
  inspect(links.length(), content="1")
  let link = links[0]
  inspect(link.getAttribute("href"), content="Some(\"https://example.com\")")
  inspect(link.getAttribute("class"), content="Some(\"link\")")
  inspect(link.getAttribute("missing"), content="None")
}

///|
test "node type checking" {
  let html = "<div>text<!-- comment --></div>"
  let doc = @htmlparser2.parseDocument(html)
  let divs = @htmlparser2.getElementsByTagName(doc, "div")
  let div = divs[0]
  let children = div.children()
  // Should have text node and comment node
  inspect(children.length() >= 1, content="true")
}

///|
test "find all with predicate" {
  let html = "<div class=\"item\"><span class=\"item\">A</span></div><p class=\"other\">B</p>"
  let doc = @htmlparser2.parseDocument(html)
  let items = @htmlparser2.findAll(doc, fn(elem) {
    elem.getAttribute("class") == Some("item")
  })
  inspect(items.length(), content="2")
}

///|
test "find one with predicate" {
  let html = "<div><span id=\"first\">A</span><span id=\"second\">B</span></div>"
  let doc = @htmlparser2.parseDocument(html)
  let found = @htmlparser2.findOne(doc, fn(elem) {
    elem.getAttribute("id") == Some("second")
  })
  inspect(found is Some(_), content="true")
}

///|
test "parse xml mode" {
  let xml = "<root><item/></root>"
  let doc = @htmlparser2.parseDocumentWithOptions(xml, xmlMode=true)
  let items = @htmlparser2.getElementsByTagName(doc, "item")
  inspect(items.length(), content="1")
}

///|
test "get outer html" {
  let html = "<div><span>text</span></div>"
  let doc = @htmlparser2.parseDocument(html)
  let divs = @htmlparser2.getElementsByTagName(doc, "div")
  let div = divs[0]
  // Convert Element to Node
  let node : @htmlparser2.Node = @core.identity(div.as_any())
  let outer = @htmlparser2.getOuterHTML(node)
  inspect(outer.contains("<div>"), content="true")
  inspect(outer.contains("</div>"), content="true")
}

///|
test "streaming parser" {
  let tags : Array[String] = []
  let handlers = @core.new_object()
  handlers["onopentag"] = @core.from_fn1(fn(name : String) { tags.push(name) })
  let parser = @htmlparser2.createParser(handlers)
  parser.write("<div>")
  parser.write("<span>")
  parser.end()
  inspect(tags.length(), content="2")
  inspect(tags[0], content="div")
  inspect(tags[1], content="span")
}
