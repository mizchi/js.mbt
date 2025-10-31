///|
priv struct AppProps {} derive(Default)

///|
using @val {type Val, js}
using @node_test {it, before_each}

///|
fn app(_props : AppProps) -> @react.Element {
  let (cnt, set_cnt) = @react.use_state(0)
  let on_click = (_event : @dom.MouseEvent) => set_cnt(cnt + 1)
  @react.h("div", [
    "Hello RTL",
    @react.h("div", ["Count: \{cnt}"]),
    @react.h("button", attributes={ "onClick": on_click |> js }, ["click me"]),
  ])
}

///|
test {
  let { render, fire_event, screen, cleanup } = ReactTestingLibrary::init()
  before_each(() => {
    @react.init_react_client() |> ignore
    cleanup()
  })
  it("renders app and responds to click", _ => {
    render(@react.c(app, AppProps::default()))
    fire_event.click(screen.get_by_text("click me"))
    let target = screen.get_by_text("Count: 1")
    assert_eq(target.get_text_content(), "Count: 1")
  })
}
