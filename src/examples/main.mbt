///|
using @react {
  type Component,
  type Context,
  h,
  c,
  fragment,
  provider,
  component,
  use_effect,
  use_state,
  use_callback,
  use_context,
  use_reducer,
  create_context
}

///|
using @js {log}

///|
using @element {
  h1,
  h2,
  hr,
  ul,
  li,
  form,
  input,
  main_,
  section,
  div,
  textarea,
  svg,
  circle,
  rect,
  line,
  text
}

///|
fnalias @js.identity as js

///|
struct EmptyProps {} derive(Eq)

///|
struct MyContextProps {
  v : String
}

///|
struct ItemProps {
  name : String
}

///|
let item_view : Component[ItemProps] = component(props => h(
  "div",
  style={ "padding": "5px", "borderBottom": "1px solid #ccc" },
  [props.name],
))

///|
let myctx : Context[MyContextProps] = create_context(None)

///|
let ctx_consumer : Component[EmptyProps] = component(_props => {
  let ctx_value : MyContextProps = use_context(myctx)
  h("div", attributes={ "className": "context-value" |> js }, [
    "Context value: \{ctx_value.v}",
  ])
})

///|
enum CounterAction {
  Increment
}

///|
/// WIP: async action state
// let counter_async : Component[EmptyProps] = component(_ => {
//   let f = async fn(state : Int, action : CounterAction) -> Int noraise {
//     if action is CounterAction::Increment {
//       state + 1
//     } else {
//       state
//     }
//   }
//   @js.log(f)
//   let (count, set_count, is_pending) = use_action_state(f, 0)
//   h(
//     "button",
//     attributes={ "onClick": js(() => set_count(CounterAction::Increment)) },
//     [if is_pending { "Updating..." } else { "Async Count: \{count}" }],
//   )
// })

///|
let counter : Component[EmptyProps] = component(_props => {
  let (count, dispatch) = use_reducer(
    (state : Int, _action : CounterAction) => if _action
      is CounterAction::Increment {
      state + 1
    } else {
      state
    },
    0,
  )
  let on_click = use_callback(
    () => {
      dispatch(CounterAction::Increment)
      log("Counter clicked: \{count + 1}")
    },
    [count],
  )
  h("button", attributes={ "onClick": on_click |> js }, ["Count: \{count}"])
})

///|
struct FooProps {
  x : Int
  items : Array[String]
}

///|
let app : Component[FooProps] = component(props => {
  let (cnt, set_cnt) = use_state(props.x)
  let textarea_ref : @react.ReactRef[@dom.Element] = @react.use_ref(None)
  let handler = use_callback(
    _ => {
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
    [cnt, textarea_ref],
  )
  use_effect(
    () => {
      if textarea_ref.current() is Some(textarea) {
        textarea.focus()
      }
      () => log("Component unmounted")
    },
    [],
  )
  let (input_text, set_text) = use_state("")
  let on_change = use_callback(
    (e : @dom.ChangeEvent) => {
      let target = e.target()
      let value : String = target.get_value()
      set_text(value)
      log("Textarea changed: \{value}")
    },
    [input_text],
  )
  provider(myctx, value={ v: "xxx" }, [
    h1(["Hello, Moonbit React!"]),
    div(
      id="foo",
      class="foo bar",
      style={ "border": "1px solid black", "padding": "10px" },
      on_click=handler,
      [
        "Foo component: x = \{cnt}",
        fragment([h("h1", ["xxx"])]),
        div(id="textarea-container", [
          textarea(
            id="my-textarea",
            on_change~,
            attributes={ "rows": js(4), "cols": js(40) },
            ref_=textarea_ref,
            ["This is a textarea."],
          ),
          div(class="textarea-value", ["Textarea value: \{input_text}"]),
        ]),
        ul(
          props.items.mapi((idx, item) => h("li", key=idx.to_string(), [
            c(item_view, { name: item }, key=idx.to_string()),
          ])),
        ),
        c(ctx_consumer, EmptyProps::{  }),
        c(counter, EmptyProps::{  }),
        hr(),
        form(
          method_="post",
          style={ "marginTop": "10px" },
          enc_type="application/x-www-form-urlencoded",
          action=form => {
            log(form)
            let v : String = form.get("username") |> js
            log("Username: \{v}")
          },
          [
            input(type_="text", name="username"),
            input(type_="submit", value="Submit"),
          ],
        ),
        svg(width=500, height=100, [
          circle(cx=50, cy=50, r=40, stroke="black", stroke_width=3, fill="red"),
          rect(
            x=120,
            y=10,
            width=80,
            height=80,
            stroke="blue",
            stroke_width=3,
            fill="green",
          ),
          text(x=100, y=30, dx="50%", dy="50%", ["Hello, SVG Text!"]),
          line(x1=220, y1=10, x2=300, y2=90, stroke="black", stroke_width=2),
        ]),
      ],
    ),
  ])
})

///|
fn main {
  let dom = @dom.document().query_selector("#app").unwrap()
  let items = ["Item 1", "Item 2", "Item 3"]
  @react.render(c(app, { x: 42, items }), dom)
}
