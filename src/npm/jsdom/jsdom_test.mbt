///|
async test "create jsdom and access window" {
  let jsdom = create_jsdom()
  let window = jsdom.window()
  @core.typeof_(window.as_any()) |> assert_eq("object")
}

///|
async test "create jsdom with HTML" {
  let jsdom = create_jsdom(
    html="<html><body><div id=\"test\">Hello</div></body></html>",
  )
  let window = jsdom.window()
  let document = window.document()
  let element = document.getElementById("test")
  inspect(element is Some(_), content="true")
}

///|
async test "create_window convenience function" {
  let window = create_window(html="<html><body><p>Test</p></body></html>")
  let document = window.document()
  guard document.body() is Some(body)
  let html = body.innerHTML()
  inspect(html.contains("Test"), content="true")
}

///|
async test "serialize document" {
  let jsdom = create_jsdom(html="<html><body><div>Content</div></body></html>")
  let html = jsdom.serialize()
  inspect(html.contains("Content"), content="true")
}

///|
async test "document manipulation" {
  let window = create_window()
  let document = window.document()
  guard document.body() is Some(body)
  let div = document.createElement("div")
  div.setId("new-div")
  div.setTextContent("Created")
  body.as_node().appendChild(div.as_node()) |> ignore
  let found = document.getElementById("new-div")
  inspect(found is Some(_), content="true")
}

///|
async test "querySelector" {
  let window = create_window(
    html="<html><body><div class=\"item\">1</div></body></html>",
  )
  let document = window.document()
  let first = document.querySelector(".item")
  inspect(first is Some(_), content="true")
}

///|
async test "querySelectorAll" {
  let window = create_window(
    html="<html><body><div class=\"item\">1</div><div class=\"item\">2</div></body></html>",
  )
  let document = window.document()
  let all = document.querySelectorAll(".item")
  inspect(all.length(), content="2")
}

///|
async test "jsdom with custom URL" {
  let jsdom = create_jsdom(options={
    url: Some("https://example.com/page"),
    referrer: None,
    content_type: None,
    run_scripts: None,
    resources: None,
    pretend_to_be_visual: None,
  })
  let window = jsdom.window()
  let location = window.location()
  let href : String = location["href"].cast()
  inspect(href.contains("example.com"), content="true")
}
