///|
// type EmptyProps,
using @react {
  type Component,
  type Context,
  h,
  c,
  props,
  fragment,
  provider,
  component,
  use_effect,
  use_state,
  use_callback,
  use_context,
  create_context
}

///|
struct MyContextProps {
  v : String
} derive(ToJson)

///|
let myctx : Context[MyContextProps] = create_context(
  None,
  // Some({ v: "Default value" }),
)

///|
using @js {log}

///|
fnalias @js.identity as js

///|
struct EmptyProps {} derive(Eq)

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
let ctx_consumer : Component[EmptyProps] = component(_props => {
  let ctx_value : MyContextProps = use_context(myctx)
  h("div", { "className": "context-value" |> js }, [
    "Context value: \{ctx_value.v}",
  ])
})

///|
let counter : Component[EmptyProps] = component(_props => {
  let (count, set_count) = use_state(0)
  let on_click = use_callback(
    () => {
      set_count(count + 1)
      log("Counter clicked: \{count + 1}")
    },
    [count],
  )
  h("button", { "onClick": on_click |> js }, ["Count: \{count}"])
})

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
  provider(myctx, { v: "xxx" }, [
    h("div", { "id": "foo" |> js, "onClick": js(handler) }, [
      "Foo component: x = \{cnt}",
      fragment([h("h1", {}, ["xxx"])]),
      // suspense(
      //   fallback=h("div", { "className": "loading" |> js }, ["Loading..."]),
      //   [h("div", { "className": "loading" |> js }, ["Loading..."])],
      // ),
      h("div", @react.props(id="textarea-container"), [
        h(
          "textarea",
          { "rows": 4 |> js, "cols": 40 |> js, "onChange": on_change |> js },
          ref_=textarea_ref |> js,
          ["This is a textarea."],
        ),
        h("div", { "className": "textarea-value" |> js }, [
          "Textarea value: \{text}",
        ]),
      ]),
      h(
        "ul",
        {},
        props.items.mapi((idx, item) => h("li", {}, key=idx.to_string(), [
          c(item_view, { name: item }, key=idx |> js),
        ])),
      ),
      c(ctx_consumer, EmptyProps::{  }),
      c(counter, EmptyProps::{  }),
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
