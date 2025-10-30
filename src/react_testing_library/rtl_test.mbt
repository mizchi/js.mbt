///|
priv struct AppProps {} derive(Default)

///|
fn app(_props : AppProps) -> @react.Element {
  let (cnt, set_cnt) = @react.use_state(0)
  let on_click = (_event : @dom.MouseEvent) => set_cnt(cnt + 1)
  @react.h("div", [
    "Hello RTL",
    @react.h("div", ["Count: \{cnt}"]),
    @react.h("button", attributes={ "onClick": on_click |> @js.to_js }, [
      "click me",
    ]),
  ])
}

///|
test {
  @js.run_async(() => try {
    let rtl = ReactTestingLibrary::load()
    @js.before_each(() => {
      let _ = @react.init_react_client()
      rtl.cleanup()
    })
    @js.it("renders app and responds to click", _ => {
      rtl.render(@react.c(app, AppProps::default()))
      rtl.fire_event().click(rtl.screen().get_by_text("click me"))
      let target = rtl.screen().get_by_text("Count: 1")
      assert_eq(target.get_text_content(), "Count: 1")
    })
  } catch {
    _ => panic()
  })
}
