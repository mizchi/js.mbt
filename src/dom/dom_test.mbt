///|
using @js {type Val}

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
