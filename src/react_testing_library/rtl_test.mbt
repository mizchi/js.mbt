///|
priv struct AppProps {}
///|
fn app(_props : AppProps) -> @react.Element {
  let (cnt, set_cnt) = @react.use_state(0)
  let on_click = (_event: @dom.MouseEvent) => {
    @js.log("App clicked!")
    set_cnt(cnt + 1)
  }
  @react.h("div", [
    "Hello RTL",
    @react.h("div", ["Count: \{cnt}"]),
    @react.h(
      "button",
      attributes={ "onClick": on_click |> @js.identity },
      ["click me"],
    ),
  ])
}


///|
test {
  @js.run_async(() => try {
    let _ = @react.init_react_client()
    let testing = @react_testing_library.ReactTestingLibrary::load()
    let screen = testing.screen()
    let fire_event = testing.fire_event()
    defer testing.cleanup()

    // render app
    testing.render(@react.c(app, AppProps::{  }))
    fire_event.click(screen.get_by_text("click me"))
    let target = screen.get_by_text("Count: 1")
    guard target.get_text_content() == "Count: 1"
  } catch {
    _err => {
      println("Test failed: \{_err}")
      panic()
    }
  })
}