///|
/// Direct require function for Node.js modules
extern "js" fn require(module_name : String) -> @js.Val =
  #| (moduleName) => require(moduleName)

///|
/// Setup global-jsdom for DOM testing
fn setup_jsdom() -> Unit {
  let jsdom = require("global-jsdom")
  jsdom.call([]) |> ignore
}

///|
/// Test: document creation and basic operations
test "document exists after jsdom setup" {
  setup_jsdom()
  let doc = document()
  inspect(doc.to_js().type_of(), content="object")
}

///|
/// Test: create element
test "document.createElement creates an element" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  inspect(div.to_js().type_of(), content="object")
}

///|
/// Test: element attributes
test "element setAttribute and getAttribute" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  div.set_attribute("id", "test-id")
  div.set_attribute("class", "test-class")
  let id = div.get_attribute("id")
  let class_name = div.get_attribute("class")
  inspect(
    id,
    content=(
      #|Some("test-id")
    ),
  )
  inspect(
    class_name,
    content=(
      #|Some("test-class")
    ),
  )
}

///|
/// Test: element property access
test "element property get and set" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  div.set("innerHTML", "Hello World")
  let content = div.get("innerHTML")
  let content_str : String = content.cast()
  inspect(content_str, content="Hello World")
}

///|
/// Test: appendChild
test "element appendChild" {
  setup_jsdom()
  let doc = document()
  let parent = doc.create_element("div")
  let child = doc.create_element("span")
  parent.append_child(child) |> ignore
  let first = parent.first_child()
  inspect(first.is_empty(), content="false")
}

///|
/// Test: create text node
test "document.createTextNode creates a text node" {
  setup_jsdom()
  let doc = document()
  let text = doc.create_text_node("Hello, World!")
  inspect(text.to_js().type_of(), content="object")
}

///|
/// Test: querySelector
test "document.querySelector finds element" {
  setup_jsdom()
  let doc = document()
  let body = doc.body()
  let div = doc.create_element("div")
  div.set_attribute("id", "test-element")
  body.append_child(div) |> ignore
  let found = doc.query_selector("#test-element")
  inspect(found.is_empty(), content="false")
}

///|
/// Test: element textContent
test "element textContent" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  div.set("textContent", "Test Content")
  let content = div.text_content()
  inspect(content, content="Test Content")
}

///|
/// Test: parent and child navigation
test "element parent/child navigation" {
  setup_jsdom()
  let doc = document()
  let parent = doc.create_element("div")
  let child1 = doc.create_element("span")
  let child2 = doc.create_element("span")
  parent.append_child(child1) |> ignore
  parent.append_child(child2) |> ignore
  let first = parent.first_child()
  let last = parent.last_child()
  inspect(first.is_empty(), content="false")
  inspect(last.is_empty(), content="false")
  match first {
    Some(fc) => {
      let next = fc.next_sibling()
      inspect(next.is_empty(), content="false")
    }
    None => ()
  }
}

///|
/// Test: navigator userAgent
test "navigator.userAgent exists" {
  setup_jsdom()
  let nav = navigator()
  let ua = nav.user_agent()
  // jsdom provides a default user agent
  inspect(ua.length() > 0, content="true")
}

///|
/// Test: localStorage basic operations
test "localStorage setItem and getItem" {
  setup_jsdom()
  let storage = get_local_storage()
  storage.set_item("test-key", "test-value")
  let value = storage.get_item("test-key")
  inspect(
    value,
    content=(
      #|Some("test-value")
    ),
  )
}

///|
/// Test: localStorage removeItem
test "localStorage removeItem" {
  setup_jsdom()
  let storage = get_local_storage()
  storage.set_item("remove-test", "value")
  storage.remove_item("remove-test")
  let value = storage.get_item("remove-test")
  inspect(value.is_empty(), content="false")
}

///|
/// Test: window object
test "window object exists" {
  setup_jsdom()
  let win = window()
  inspect(win.to_js().type_of(), content="object")
}

///|
/// Test: element class manipulation
test "element classList operations" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  div.add_class("active")
  inspect(div.contains_class("active"), content="true")
  div.remove_class("active")
  inspect(div.contains_class("active"), content="false")
}

///|
/// Test: element style manipulation
test "element style operations" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  div.set_display("block")
  div.set_color("red")
  div.set_width("100px")
  let display = div.get_display()
  inspect(display, content="block")
}

///|
/// Test: clone node
test "element cloneNode" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  div.set_attribute("id", "original")
  let clone = div.clone_node(true)
  let clone_id = clone.get_attribute("id")
  inspect(
    clone_id,
    content=(
      #|Some("original")
    ),
  )
}

///|
/// Test: document getElementById
test "document.getElementById" {
  setup_jsdom()
  let doc = document()
  let body = doc.body()
  let div = doc.create_element("div")
  div.set_id("test-id")
  body.append_child(div) |> ignore
  let found = doc.get_element_by_id("test-id")
  inspect(found.is_empty(), content="false")
}

///|
/// Test: element tag name
test "element tagName" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  let tag = div.tag_name()
  // Tag names are uppercase in DOM
  inspect(tag, content="DIV")
}

///|
/// Test: element has_attribute
test "element hasAttribute" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  div.set_attribute("data-test", "value")
  inspect(div.has_attribute("data-test"), content="true")
  inspect(div.has_attribute("data-missing"), content="false")
}

///|
/// Test: element remove_attribute
test "element removeAttribute" {
  setup_jsdom()
  let doc = document()
  let div = doc.create_element("div")
  div.set_attribute("data-test", "value")
  inspect(div.has_attribute("data-test"), content="true")
  div.remove_attribute("data-test")
  inspect(div.has_attribute("data-test"), content="false")
}

///|
/// Test: storage length and keys
test "storage length and keys" {
  setup_jsdom()
  let storage = get_local_storage()
  storage.clear()
  storage.set_item("key1", "value1")
  storage.set_item("key2", "value2")
  let length = storage.length()
  inspect(length, content="2")
  let keys = storage.keys()
  inspect(keys.length(), content="2")
}

///|
/// Test: element children count
test "element childElementCount" {
  setup_jsdom()
  let doc = document()
  let parent = doc.create_element("div")
  let child1 = doc.create_element("span")
  let child2 = doc.create_element("span")
  parent.append_child(child1) |> ignore
  parent.append_child(child2) |> ignore
  let count = parent.child_element_count()
  inspect(count, content="2")
}
