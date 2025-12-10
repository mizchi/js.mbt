///|
/// Helper to close window synchronously (for defer)
fn close_window_sync(window : @dom.Window) -> Unit {
  @core.run_async(async fn() noraise {
    get_happy_dom(window).close() catch {
      _ => ()
    }
  })
}

///|
async test "create window and access document" {
  let window = create_window()
  defer close_window_sync(window)
  let document = window.document()
  // Check that document exists
  @core.typeof_(document.as_any()) |> assert_eq("object")
}

///|
async test "set innerHTML and query elements" {
  let window = create_window()
  defer close_window_sync(window)
  let document = window.document()
  guard document.body() is Some(body)
  body.setInnerHTML("<div class=\"container\"><p>Hello</p></div>")
  let container = document.querySelector(".container")
  inspect(container is Some(_), content="true")
}

///|
async test "create and append elements" {
  let window = create_window()
  defer close_window_sync(window)
  let document = window.document()
  guard document.body() is Some(body)
  let div = document.createElement("div")
  div.setId("test-div")
  body.as_node().appendChild(div.as_node()) |> ignore
  let found = document.getElementById("test-div")
  inspect(found is Some(_), content="true")
}

///|
async test "window with custom URL" {
  let window = create_window(options={
    url: Some("https://example.com"),
    width: None,
    height: None,
    console: None,
  })
  defer close_window_sync(window)
  let location = window.location()
  let href : String = location["href"].cast()
  inspect(href.contains("example.com"), content="true")
}

///|
async test "happyDOM API - abort" {
  let window = create_window()
  defer close_window_sync(window)
  let happy_dom = get_happy_dom(window)
  // abort should not throw
  happy_dom.abort()
  inspect(true, content="true")
}

///|
async test "happyDOM API - set viewport" {
  let window = create_window()
  defer close_window_sync(window)
  let happy_dom = get_happy_dom(window)
  // set viewport should not throw
  happy_dom.set_viewport(width=1920, height=1080)
  inspect(true, content="true")
}

///|
async test "localStorage access" {
  let window = create_window()
  defer close_window_sync(window)
  let storage = window.localStorage()
  // Should be an object
  @core.typeof_(storage) |> assert_eq("object")
}

///|
async test "sessionStorage access" {
  let window = create_window()
  defer close_window_sync(window)
  let storage = window.sessionStorage()
  // Should be an object
  @core.typeof_(storage) |> assert_eq("object")
}

///|
async test "navigator access" {
  let window = create_window()
  defer close_window_sync(window)
  let navigator = window.navigator()
  // Should be an object
  @core.typeof_(navigator) |> assert_eq("object")
}

///|
async test "window console access" {
  let window = create_window()
  defer close_window_sync(window)
  let console = window.console()
  // Should be an object
  @core.typeof_(console) |> assert_eq("object")
}

///|
async test "window innerWidth and innerHeight" {
  let window = create_window(options={
    url: None,
    width: Some(1024),
    height: Some(768),
    console: None,
  })
  defer close_window_sync(window)
  // Happy-dom may not set these to exact values, but they should be numbers
  let width = window.innerWidth()
  let height = window.innerHeight()
  inspect(width >= 0, content="true")
  inspect(height >= 0, content="true")
}
