///|
using @react {
  type Component,
  h,
  c,
  component,
  use_effect,
  use_state,
  use_callback
}

///|
using @js {log}

///|
fnalias @js.identity as js

///|
struct ItemProps {
  name : String
} derive(ToJson)

///|
let item_view : Component[ItemProps] = component(props => h(
  "div",
  { "className": "item" |> js },
  [props.name],
))

///|
struct FooProps {
  x : Int
  items : Array[String]
} derive(ToJson)

///|
let foo : Component[FooProps] = component(props => {
  let (cnt, set_cnt) = use_state(props.x)
  let textarea_ref : @react.ReactRef[@dom.Element] = @react.use_ref(None)
  let handler = use_callback(
    () => {
      set_cnt(cnt + 1)
      @js.log("Clicked!")
    },
    [cnt],
  )
  use_effect(
    () => {
      // log("Textarea rows: \{textarea.get_attribute("rows" |> identity) |> identity}")
      log("Component mounted with x = \{props.x}")
      () => log("Component unmounted")
    },
    [cnt |> js, textarea_ref |> js],
  )
  use_effect(
    () => {
      if textarea_ref.current() is Some(textarea) {
        textarea.focus()
      }
      () => log("Component unmounted")
    },
    [textarea_ref |> js],
  )
  let (text, set_text) = use_state("")
  let on_change = use_callback(
    (e : @dom.Event) => {
      let target = e.target()
      let value : String = target.get_value()
      set_text(value)
      log("Textarea changed: \{value}")
    },
    [text],
  )
  h("div", { "id": "foo" |> js, "onClick": js(handler) }, [
    "Foo component: x = \{cnt}",
    h("div", {}, [
      h(
        "textarea",
        { "rows": 4 |> js, "cols": 40 |> js, "onChange": on_change |> js },
        ref_=textarea_ref |> js,
        ["This is a textarea."],
      ),
    ]),
    h(
      "ul",
      {},
      props.items.mapi((idx, item) => h("li", {}, key=idx.to_string(), [
        c(item_view, { name: item }, key=idx |> js),
      ])),
    ),
    h("svg", { "width": 100 |> js, "height": 100 |> js }, [
      h(
        "circle",
        {
          "cx": 50 |> js,
          "cy": 50 |> js,
          "r": 40 |> js,
          "stroke": "black" |> js,
          "strokeWidth": 3 |> js,
          "fill": "red" |> js,
        },
        [],
      ),
    ]),
  ])
})

///|
fn main {
  let dom = @dom.document().query_selector("#app").unwrap()
  let items = ["Item 1", "Item 2", "Item 3"]
  @react.render(
    h("div", { "id": "hello" |> @js.identity }, [c(foo, { x: 42, items })]),
    dom,
  )
}
