///|
fn setup() -> () -> Unit {
  @global_jsdom.register()
  @preact.init_preact_api(
    @node.require("preact"),
    @node.require("preact/hooks"),
  )
  fn() { cleanup() }
}

///|
test "render basic component" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Hello World"])
  render(vnode) |> ignore
  let s = screen()
  let el = s.getByText("Hello World")
  inspect(
    not(@nostd.is_nullish(el.as_element().as_any().cast())),
    content="true",
  )
}

///|
test "getByRole button" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("button", ["Click me"])
  render(vnode) |> ignore
  let s = screen()
  let button = s.getByRole("button")
  inspect(
    not(@nostd.is_nullish(button.as_element().as_any().cast())),
    content="true",
  )
}

///|
test "queryByText returns null for non-existent" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Hello"])
  render(vnode) |> ignore
  let s = screen()
  let result = s.queryByText("NonExistent")
  inspect(result is None, content="true")
}

///|
test "fireEvent click" {
  let dispose = setup()
  defer dispose()
  let clicked = Ref::new(false)
  let handler : () -> Unit = fn() { clicked.val = true }
  let vnode = @preact.h("button", ["Click me"], props={
    "onClick": handler |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let button = s.getByRole("button")
  fireEvent().click(button) |> ignore
  inspect(clicked.val, content="true")
}

///|
test "render result container" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("span", ["Test Content"])
  let result = render(vnode)
  let container = result.container()
  let inner_html : String = container.innerHTML()
  inspect(inner_html, content="<span>Test Content</span>")
}

///|
test "rerender component" {
  let dispose = setup()
  defer dispose()
  let vnode1 = @preact.h("div", ["Initial"])
  let result = render(vnode1)
  let container = result.container()
  let html1 : String = container.innerHTML()
  inspect(html1, content="<div>Initial</div>")
  let vnode2 = @preact.h("div", ["Updated"])
  result.rerender(vnode2)
  let html2 : String = container.innerHTML()
  inspect(html2, content="<div>Updated</div>")
}

///|
test "unmount removes content" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Will be removed"])
  let result = render(vnode)
  let container = result.container()
  let html1 : String = container.innerHTML()
  inspect(html1, content="<div>Will be removed</div>")
  result.unmount()
  let html2 : String = container.innerHTML()
  inspect(html2, content="")
}

///|
test "getAllByRole returns multiple elements" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.fragment([
    @preact.h("button", ["Button 1"]),
    @preact.h("button", ["Button 2"]),
    @preact.h("button", ["Button 3"]),
  ])
  render(vnode) |> ignore
  let s = screen()
  let buttons = s.getAllByRole("button")
  inspect(buttons.length(), content="3")
}

///|
test "getByTestId finds element" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Test"], props={
    "data-testid": @nostd.any("my-test-id"),
  })
  render(vnode) |> ignore
  let s = screen()
  let el = s.getByTestId("my-test-id")
  inspect(
    not(@nostd.is_nullish(el.as_element().as_any().cast())),
    content="true",
  )
}

///|
test "fireEvent change" {
  let dispose = setup()
  defer dispose()
  let value = Ref::new("")
  let handler : (@nostd.Any) -> Unit = fn(e) {
    let target : @nostd.Any = e._get("target")
    value.val = target._get("value").cast()
  }
  let vnode = @preact.h("input", [], props={
    "type": @nostd.any("text"),
    "onChange": handler |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let input = s.getByRole("textbox")
  let event : @nostd.Any = @nostd.from_entries([
    ("target", @nostd.from_entries([("value", @nostd.any("hello"))]).cast()),
  ]).cast()
  fireEvent().change(input, event) |> ignore
  inspect(value.val, content="hello")
}

///|
test "fireEvent input" {
  let dispose = setup()
  defer dispose()
  let value = Ref::new("")
  let handler : (@nostd.Any) -> Unit = fn(e) {
    let target : @nostd.Any = e._get("target")
    value.val = target._get("value").cast()
  }
  let vnode = @preact.h("input", [], props={
    "type": @nostd.any("text"),
    "onInput": handler |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let input = s.getByRole("textbox")
  let event : @nostd.Any = @nostd.from_entries([
    ("target", @nostd.from_entries([("value", @nostd.any("world"))]).cast()),
  ]).cast()
  fireEvent().input(input, event) |> ignore
  inspect(value.val, content="world")
}

///|
test "fireEvent focus and blur" {
  let dispose = setup()
  defer dispose()
  let focused = Ref::new(false)
  let focus_handler : () -> Unit = fn() { focused.val = true }
  let blur_handler : () -> Unit = fn() { focused.val = false }
  let vnode = @preact.h("input", [], props={
    "type": @nostd.any("text"),
    "onFocus": focus_handler |> @nostd.identity,
    "onBlur": blur_handler |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let input = s.getByRole("textbox")
  fireEvent().focus(input) |> ignore
  inspect(focused.val, content="true")
  fireEvent().blur(input) |> ignore
  inspect(focused.val, content="false")
}

///|
test "fireEvent keyDown" {
  let dispose = setup()
  defer dispose()
  let key_pressed = Ref::new("")
  let handler : (@nostd.Any) -> Unit = fn(e) {
    key_pressed.val = e._get("key").cast()
  }
  let vnode = @preact.h("input", [], props={
    "type": @nostd.any("text"),
    "onKeyDown": handler |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let input = s.getByRole("textbox")
  let event : @nostd.Any = @nostd.from_entries([("key", @nostd.any("Enter"))]).cast()
  fireEvent().keyDown(input, event) |> ignore
  inspect(key_pressed.val, content="Enter")
}

///|
test "fireEvent keyUp" {
  let dispose = setup()
  defer dispose()
  let key_released = Ref::new("")
  let handler : (@nostd.Any) -> Unit = fn(e) {
    key_released.val = e._get("key").cast()
  }
  let vnode = @preact.h("input", [], props={
    "type": @nostd.any("text"),
    "onKeyUp": handler |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let input = s.getByRole("textbox")
  let event : @nostd.Any = @nostd.from_entries([("key", @nostd.any("Escape"))]).cast()
  fireEvent().keyUp(input, event) |> ignore
  inspect(key_released.val, content="Escape")
}

///|
test "fireEvent dblClick" {
  let dispose = setup()
  defer dispose()
  let count = Ref::new(0)
  let handler : () -> Unit = fn() { count.val = count.val + 1 }
  let vnode = @preact.h("button", ["Double Click"], props={
    "onDblClick": handler |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let button = s.getByRole("button")
  fireEvent().dblClick(button) |> ignore
  inspect(count.val, content="1")
}

///|
test "fireEvent mouseDown and mouseUp" {
  let dispose = setup()
  defer dispose()
  let down = Ref::new(false)
  let up = Ref::new(false)
  let down_handler : () -> Unit = fn() { down.val = true }
  let up_handler : () -> Unit = fn() { up.val = true }
  let vnode = @preact.h("button", ["Mouse"], props={
    "onMouseDown": down_handler |> @nostd.identity,
    "onMouseUp": up_handler |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let button = s.getByRole("button")
  fireEvent().mouseDown(button) |> ignore
  inspect(down.val, content="true")
  fireEvent().mouseUp(button) |> ignore
  inspect(up.val, content="true")
}

///|
test "fireEvent mouseEnter and mouseLeave" {
  let dispose = setup()
  defer dispose()
  let entered = Ref::new(false)
  let left = Ref::new(false)
  let enter_handler : () -> Unit = fn() { entered.val = true }
  let leave_handler : () -> Unit = fn() { left.val = true }
  let vnode = @preact.h("div", ["Hover me"], props={
    "onMouseEnter": enter_handler |> @nostd.identity,
    "onMouseLeave": leave_handler |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let el = s.getByText("Hover me")
  fireEvent().mouseEnter(el) |> ignore
  inspect(entered.val, content="true")
  fireEvent().mouseLeave(el) |> ignore
  inspect(left.val, content="true")
}

///|
test "render result baseElement" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Test"])
  let result = render(vnode)
  let base = result.baseElement()
  // baseElement should be the body element
  let tag_name : String = base.tagName()
  inspect(tag_name, content="BODY")
}

///|
test "render result asFragment" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Fragment Test"])
  let result = render(vnode)
  let frag = result.asFragment()
  inspect(not(@nostd.is_nullish(frag)), content="true")
}

///|
test "getByLabelText" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.fragment([
    @preact.h("label", ["Username"], props={
      "for": @nostd.any("username-input"),
    }),
    @preact.h("input", [], props={
      "id": @nostd.any("username-input"),
      "type": @nostd.any("text"),
    }),
  ])
  render(vnode) |> ignore
  let s = screen()
  let input = s.getByLabelText("Username")
  inspect(
    not(@nostd.is_nullish(input.as_element().as_any().cast())),
    content="true",
  )
}

///|
test "getByPlaceholderText" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("input", [], props={
    "type": @nostd.any("text"),
    "placeholder": @nostd.any("Enter your name"),
  })
  render(vnode) |> ignore
  let s = screen()
  let input = s.getByPlaceholderText("Enter your name")
  inspect(
    not(@nostd.is_nullish(input.as_element().as_any().cast())),
    content="true",
  )
}

///|
test "getByDisplayValue" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("input", [], props={
    "type": @nostd.any("text"),
    "value": @nostd.any("current value"),
    "onChange": (fn() {  }) |> @nostd.identity,
  })
  render(vnode) |> ignore
  let s = screen()
  let input = s.getByDisplayValue("current value")
  inspect(
    not(@nostd.is_nullish(input.as_element().as_any().cast())),
    content="true",
  )
}

///|
test "getByAltText" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("img", [], props={
    "alt": @nostd.any("Profile picture"),
    "src": @nostd.any("profile.jpg"),
  })
  render(vnode) |> ignore
  let s = screen()
  let img = s.getByAltText("Profile picture")
  inspect(
    not(@nostd.is_nullish(img.as_element().as_any().cast())),
    content="true",
  )
}

///|
test "getByTitle" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("span", ["Info"], props={
    "title": @nostd.any("More information"),
  })
  render(vnode) |> ignore
  let s = screen()
  let el = s.getByTitle("More information")
  inspect(
    not(@nostd.is_nullish(el.as_element().as_any().cast())),
    content="true",
  )
}

///|
test "queryAllByRole returns empty array" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["No buttons"])
  render(vnode) |> ignore
  let s = screen()
  let buttons = s.queryAllByRole("button")
  inspect(buttons.length(), content="0")
}

///|
test "getAllByText returns multiple" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.fragment([
    @preact.h("span", ["Same text"]),
    @preact.h("span", ["Same text"]),
  ])
  render(vnode) |> ignore
  let s = screen()
  let elements = s.getAllByText("Same text")
  inspect(elements.length(), content="2")
}

///|
test "getAllByTestId returns multiple" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.fragment([
    @preact.h("div", ["Item 1"], props={ "data-testid": @nostd.any("item") }),
    @preact.h("div", ["Item 2"], props={ "data-testid": @nostd.any("item") }),
  ])
  render(vnode) |> ignore
  let s = screen()
  let items = s.getAllByTestId("item")
  inspect(items.length(), content="2")
}

///|
async test "findByText" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Async content"])
  render(vnode) |> ignore
  let s = screen()
  let el = s.findByText("Async content")
  inspect(
    not(@nostd.is_nullish(el.as_element().as_any().cast())),
    content="true",
  )
}

///|
async test "findByRole" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("button", ["Async button"])
  render(vnode) |> ignore
  let s = screen()
  let button = s.findByRole("button")
  inspect(
    not(@nostd.is_nullish(button.as_element().as_any().cast())),
    content="true",
  )
}

///|
async test "findByTestId" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Test"], props={
    "data-testid": @nostd.any("async-test"),
  })
  render(vnode) |> ignore
  let s = screen()
  let el = s.findByTestId("async-test")
  inspect(
    not(@nostd.is_nullish(el.as_element().as_any().cast())),
    content="true",
  )
}

///|
async test "findAllByRole" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.fragment([
    @preact.h("button", ["Btn 1"]),
    @preact.h("button", ["Btn 2"]),
  ])
  render(vnode) |> ignore
  let s = screen()
  let buttons = s.findAllByRole("button")
  // At least 2 buttons should be found
  inspect(buttons.length() >= 2, content="true")
}

///|
async test "findAllByText" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.fragment([
    @preact.h("p", ["Repeated"]),
    @preact.h("p", ["Repeated"]),
    @preact.h("p", ["Repeated"]),
  ])
  render(vnode) |> ignore
  let s = screen()
  let elements = s.findAllByText("Repeated")
  inspect(elements.length(), content="3")
}

///|
async test "findAllByTestId" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.fragment([
    @preact.h("li", ["A"], props={ "data-testid": @nostd.any("list-item") }),
    @preact.h("li", ["B"], props={ "data-testid": @nostd.any("list-item") }),
  ])
  render(vnode) |> ignore
  let s = screen()
  let items = s.findAllByTestId("list-item")
  inspect(items.length(), content="2")
}

///|
test "getByRole with name option" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.fragment([
    @preact.h("button", ["Submit"]),
    @preact.h("button", ["Cancel"]),
  ])
  render(vnode) |> ignore
  let s = screen()
  let submit = s.getByRole("button", name=Some("Submit"))
  let text : String = submit.as_element().as_node().textContent()
  inspect(text, content="Submit")
}

///|
test "queryAllByText returns empty for no match" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Some content"])
  render(vnode) |> ignore
  let s = screen()
  let elements = s.queryAllByText("NonExistent")
  inspect(elements.length(), content="0")
}

///|
test "queryAllByTestId returns empty for no match" {
  let dispose = setup()
  defer dispose()
  let vnode = @preact.h("div", ["Content"])
  render(vnode) |> ignore
  let s = screen()
  let items = s.queryAllByTestId("nonexistent-id")
  inspect(items.length(), content="0")
}

///|
test "fireEvent submit" {
  let dispose = setup()
  defer dispose()
  let submitted = Ref::new(false)
  let handler : (@nostd.Any) -> Unit = fn(e) {
    e._call("preventDefault", []) |> ignore
    submitted.val = true
  }
  let vnode = @preact.h(
    "form",
    [@preact.h("button", ["Submit"], props={ "type": @nostd.any("submit") })],
    props={ "onSubmit": handler |> @nostd.identity },
  )
  let result = render(vnode)
  let form : @dom.HTMLElement = match
    result.container().as_node().firstChild() {
    Some(node) => @nostd.identity(node)
    None => abort("firstChild not found")
  }
  fireEvent().submit(form) |> ignore
  inspect(submitted.val, content="true")
}

///|
test "fireEvent scroll" {
  let dispose = setup()
  defer dispose()
  let scrolled = Ref::new(false)
  let handler : () -> Unit = fn() { scrolled.val = true }
  let style_obj : @nostd.Any = @nostd.from_entries([
    ("overflow", @nostd.any("auto")),
    ("height", @nostd.any("100px")),
  ]).cast()
  let handler_any : @nostd.Any = @nostd.identity(handler)
  let vnode = @preact.h("div", ["Scrollable"], props={
    "onScroll": handler_any,
    "style": style_obj.cast(),
  })
  render(vnode) |> ignore
  let s = screen()
  let el = s.getByText("Scrollable")
  fireEvent().scroll(el) |> ignore
  inspect(scrolled.val, content="true")
}
