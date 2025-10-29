///|
fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
using @react {
  type Context,
  h,
  c,
  fragment,
  provider,
  use_effect,
  use_state,
  use_callback,
  use_context,
  use_reducer,
  create_context,
  init_react_client
}
using @react_router {
  init_react_router,
  router_provider
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
struct ItemViewProps {
  name : String
}

///|
fn item_view(props : ItemViewProps) -> @react.Element {
  h("div", style={ "padding": "5px", "borderBottom": "1px solid #ccc" }, [props.name])
}

///|
let myctx : Ref[Context[MyContextProps]?] = { val: None }

///|
fn init_myctx() -> Unit {
  myctx.val = Some(create_context(None))
}

///|
fn use_myctx() -> MyContextProps {
  guard myctx.val is Some(ctx)
  use_context(ctx)
}

///|
fn ctx_consumer(_: EmptyProps) -> @react.Element {
  let ctx_value = use_myctx()
  h("div", attributes={ "className": "context-value" |> js }, [
    "Context value: \{ctx_value.v}",
  ])
}

///|
enum CounterAction {
  Increment
}

///|
fn counter(_ : EmptyProps) -> @react.Element {
  let (count, dispatch) = use_reducer(
    (state : Int, action : CounterAction) => match action {
      CounterAction::Increment => state + 1
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
}

///|
fn async_counter(_ : EmptyProps) -> @react.Element {
  let (count, dispatch, is_pending) = @react.use_action_state(
    async fn(state : Int, action : CounterAction) -> Int noraise {
      match action {
        CounterAction::Increment => state + 1
      }
    },
    0,
  )
  let on_click = use_callback(
    _ => run_async(async fn() noraise {
      @js.sleep(500)
      @react.start_transition(() => dispatch(CounterAction::Increment))
    }),
    [count],
  )
  h("button", on_click~, [
    "Async Count: \{count}",
    if is_pending {
      " (Updating...)"
    } else {
      ""
    },
  ])
}

///|
priv struct AppProps {
  x : Int
  items : Array[String]
}

///|
fn app(props : AppProps) -> @react.Element {
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
      log("Component mounted with x = \{props.x}")
      () => log("Component unmounted")
    },
    [cnt, textarea_ref],
  )
  use_effect(
    () => {
      run_async(async fn() noraise {
        @js.sleep(300)
        if textarea_ref.current() is Some(textarea) {
          textarea.focus()
        }
        log("Starting async operation...")
      })
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
  guard myctx.val is Some(myctx)
  provider(myctx, value={ v: "xxx" }, [
    h1(["Hello, Moonbit React!"]),
    div(
      id="foo",
      class="foo bar",
      style={ "border": "1px solid black", "padding": "10px" },
      on_click=handler,
      [
        "x = \{cnt}",
        fragment([h("h1", ["xxx"])]),
        div(id="textarea-container", [
          textarea(
            id="my-textarea",
            on_change~,
            attributes={ "rows": js(4), "cols": js(40) },
            ref_=textarea_ref,
            value=input_text,
            [],
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
        c(async_counter, EmptyProps::{  }),
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
}

///|
fn main {
  let app_root = @dom.document().query_selector("#app").unwrap()
  // lazy init context
  run_async(async fn() noraise {
    let client = init_react_client() catch {
      _err => {
        log("Failed to initialize React.")
        return ()
      }
    }
    let _ = init_react_router() catch {
      _err => {
        log("Failed to initialize React Router.")
        return ()
      }
    }
    @js.log(@js.global_this().get("__ReactRouterApi"))
    // lazy init context
    // TODO: use async init later
    init_myctx()

    let index = (_props: @react_router.RouteProps) => {
      c(app, { x: 42, items: ["Item 1", "Item 2", "Item 3"] } )
    }
    let routes = @react_router.create_browser_router([
      Component(
        path="/",
        component=index,
      ),
      Element(
        path="/about",
        element=h("div", [ "About page" ]),
      ),
    ])
    
    client
    .create_root(app_root)
    .render(router_provider(routes))

  })
}
