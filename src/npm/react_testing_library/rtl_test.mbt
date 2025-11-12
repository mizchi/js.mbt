///|
priv struct AppProps {} derive(Default)

///|
using @js {type Val, js}

///|
using @test {it, before_each}

///|
using @react {h, c}

///|
fn app(_props : AppProps) -> @react.Element {
  let (cnt, set_cnt) = @react.use_state(0)
  let on_click = (_event : @dom.MouseEvent) => set_cnt(cnt + 1)
  h("div", [
    "Hello RTL",
    h("div", ["Count: \{cnt}"]),
    h("button", attributes={ "onClick": on_click |> js }, ["click me"]),
  ])
}

///|
test {
  let { render, fire_event, screen, cleanup } = ReactTestingLibrary::init()
  before_each(() => {
    @react.init_react_async() |> ignore
    cleanup()
  })
  it("renders app and responds to click", _ => {
    render(c(app, AppProps::default()))
    fire_event.click(screen.get_by_text("click me"))
    let target = screen.get_by_text("Count: 1")
    assert_eq(target["textContent"].cast(), "Count: 1")
  })
}
