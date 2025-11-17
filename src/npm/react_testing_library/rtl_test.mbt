///|
using @js {type Val, js, safe_js, unsafe_cast}

///|
using @react {h, component}

///|
using @element {div, button}

///|
priv struct AppProps {} derive(Default)

///|
fn app(_props : AppProps) -> @react.Element {
  let (cnt, set_cnt) = @react.use_state(0)
  let on_click = (_ : @dom.MouseEvent) => set_cnt(cnt + 1)
  div(["Hello RTL", div(["Count: \{cnt}"]), button(on_click~, ["click me"])])
}

///|
test "testing-library render and fireEvent" {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react() |> ignore
  cleanup()
  render(component(app, AppProps::default()))
  fireEvent().click(screen().getByText("click me"))
  // screen().debug()
  screen().getByText("Count: 1").get("textContent")
  |> unsafe_cast
  |> assert_eq("Count: 1")
}
