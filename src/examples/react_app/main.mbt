///|
using @react {
  type Context,
  type EmptyProps,
  createElement,
  component,
  fragment,
  provider,
  useEffect,
  useActionState,
  useState,
  useCallback,
  useContext,
  useReducer,
  createContext,
}

///|
using @react_router {router_provider}

///|
using @js {log, js, unsafe_cast, sleep, run_async}

///|
using @react_element {
  h1,
  h2,
  hr,
  ul,
  li,
  button,
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
  text,
}

///|
struct MyContextProps {
  v : String
}

///|
struct ItemViewProps {
  name : String
}

///|
fn item_component(props : ItemViewProps) -> @react.Element {
  createElement(
    "div",
    style={ "padding": "5px", "borderBottom": "1px solid #ccc" },
    [props.name],
  )
}

///|
let myctx : Ref[Context[MyContextProps]?] = { val: None }

///|
fn init_myctx() -> Unit {
  myctx.val = Some(createContext(None))
}

///|
fn use_myctx() -> MyContextProps {
  guard myctx.val is Some(ctx)
  useContext(ctx)
}

///|
fn ctx_consumer(_ : EmptyProps) -> @react.Element {
  let ctx_value = use_myctx()
  createElement("div", props={ "className": "context-value" |> js }, [
    "Context value: \{ctx_value.v}",
  ])
}

///|
enum CounterAction {
  Increment
}

///|
fn counter(_ : EmptyProps) -> @react.Element {
  let (count, dispatch) = useReducer(
    (state : Int, action : CounterAction) => match action {
      CounterAction::Increment => state + 1
    },
    0,
  )
  let on_click = useCallback(
    () => {
      dispatch(CounterAction::Increment)
      log("Counter clicked: \{count + 1}")
    },
    [count],
  )
  createElement("button", props={ "onClick": on_click |> unsafe_cast }, [
    "Count: \{count}",
  ])
}

///|
fn async_counter(_ : EmptyProps) -> @react.Element {
  let (count, dispatch, is_pending) = useActionState(
    async fn(state : Int, action : CounterAction) -> Int noraise {
      match action {
        Increment => state + 1
      }
    },
    0,
  )
  let on_click = useCallback(
    _ => run_async(async fn() noraise {
      sleep(500)
      @react.startTransition(() => dispatch(Increment))
    }),
    [count],
  )
  button(on_click~, [
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
  let (cnt, set_cnt) = useState(props.x)
  let textarea_ref : @react.ReactRef[@dom.HTMLTextAreaElement] = @react.useRef(
    None,
  )
  let handler = useCallback(_ => set_cnt(cnt + 1), [cnt])
  useEffect(
    () => {
      log("mounted with x = \{props.x}")
      () => log("unmounted")
    },
    [cnt, textarea_ref],
  )
  useEffect(
    () => {
      run_async(async fn() noraise {
        sleep(300)
        if textarea_ref.get_current() is Some(textarea) {
          textarea.focus()
        }
        log("Starting async operation...")
      })
      () => log("Component unmounted")
    },
    [],
  )
  let (input_text, set_text) = useState("")
  let on_change : @dom.ChangeEventHandler = useCallback(
    ev => {
      let target : @dom.HTMLTextAreaElement = unsafe_cast(ev.target().to_js())
      let value : String = target.value
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
        h2(["Counter: \{cnt}"]),
        "x = \{cnt}",
        fragment([createElement("h1", ["xxx"])]),
        div(id="textarea-container", [
          textarea(
            id="my-textarea",
            on_change~,
            props={
              let obj = @js.Object::new()
              obj.set("rows", 4)
              obj.set("cols", 40)
              obj
            },
            ref_=textarea_ref,
            value=input_text,
            [],
          ),
          div(class="textarea-value", ["Textarea value: \{input_text}"]),
        ]),
        // ]
        ul(
          props.items.mapi((idx, item) => createElement(
            "li",
            key=idx.to_string(),
            [component(item_component, { name: item }, key=idx.to_string())],
          )),
        ),
        component(ctx_consumer, EmptyProps::default()),
        component(counter, EmptyProps::default()),
        component(async_counter, EmptyProps::default()),
        hr(),
        form(
          method_="post",
          style={ "marginTop": "10px" },
          enc_type="application/x-www-form-urlencoded",
          action=form => {
            log(form)
            let v : String = form.get("username") |> unsafe_cast
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
  // lazy init context
  run_async(() => try {
    @react.dynamic_import_async()
    @react_router.dynamic_import_async()
    let client = @react_dom_client.dynamic_import_async()
    guard @dom.document().querySelector("#app") is Some(app_root)
    init_myctx()
    let index = (_props : @react_router.RouteProps) => component(app, {
      x: 42,
      items: ["Item 1", "Item 2", "Item 3"],
    })
    let routes = @react_router.create_browser_router([
      Component(path="/", component=index),
      Element(
        path="/about",
        element=createElement("div", [
          "About page",
          @react_router.link(to="/", ["Go to Top"]),
        ]),
      ),
    ])
    client.create_root(app_root).render(router_provider(routes))
  } catch {
    err => log("Error during React initialization: \{err}")
  })
}
