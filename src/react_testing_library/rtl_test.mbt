///|
priv struct AppProps {} derive(Default)
using @val {type Val, js}

///|
fn app(_props : AppProps) -> @react.Element {
  let (cnt, set_cnt) = @react.use_state(0)
  let on_click = (_event : @dom.MouseEvent) => set_cnt(cnt + 1)
  @react.h("div", [
    "Hello RTL",
    @react.h("div", ["Count: \{cnt}"]),
    @react.h("button", attributes={ "onClick": on_click |> js }, [
      "click me",
    ]),
  ])
}

///|
test {
  @promise.run_async(() => try {
    let rtl = ReactTestingLibrary::load()
    @node_test.before_each(() => {
      let _ = @react.init_react_client()
    })
    @node_test.it("renders app and responds to click", _ => {
      rtl.render(@react.c(app, AppProps::default()))
      rtl.fire_event().click(rtl.screen().get_by_text("click me"))
      let target = rtl.screen().get_by_text("Count: 1")
      assert_eq(target.get_text_content(), "Count: 1")
    })
  } catch {
    _ => panic()
  })
}
