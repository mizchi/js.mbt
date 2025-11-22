///|
using @react_testing_library {render, cleanup, screen, fireEvent}

///|
fn init_jsdom() -> Unit {
  @node.require("global-jsdom/register") |> ignore
  init_react_api(@node.require("react"))
}

///|
test "useState_lazy" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let (count, set_count) = use_state_lazy(fn() { 10 })
    let on_click : @dom.MouseEventHandler = _ => set_count(count + 1) |> ignore
    @react_element.div([
      @react_element.span(["Count: \{count}"], id="count"),
      @react_element.button(on_click~, ["increment"], id="btn"),
    ])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  screen().getByText("Count: 10").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Count: 10")
  fireEvent().click(screen().getByText("increment"))
  screen().getByText("Count: 11").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Count: 11")
}

///|
test "useCallback" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let (count, set_count) = useState(0)
    let on_click = useCallback(fn() { set_count(count + 1) }, [count])
    @react_element.div([
      @react_element.span(["Count: \{count}"]),
      @react_element.button(on_click=_ => on_click(), ["increment"]),
    ])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  fireEvent().click(screen().getByText("increment"))
  screen().getByText("Count: 1").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Count: 1")
}

///|
test "useEffect" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let (mounted, set_mounted) = useState(false)
    useEffect(
      fn() {
        set_mounted(true)
        fn() { () }
      },
      [],
    )
    @react_element.div([if mounted { "Mounted" } else { "Not mounted" }])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  screen().getByText("Mounted").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Mounted")
}

///|
test "useLayoutEffect" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let (mounted, set_mounted) = useState(false)
    useLayoutEffect(
      fn() {
        set_mounted(true)
        fn() { () }
      },
      [],
    )
    @react_element.div([if mounted { "Layout mounted" } else { "Not mounted" }])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  screen().getByText("Layout mounted").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Layout mounted")
}

///|
test "useMemo" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let (count, set_count) = useState(1)
    let doubled = useMemo(fn() { count * 2 }, [count])
    @react_element.div([
      @react_element.span(["Doubled: \{doubled}"]),
      @react_element.button(on_click=_ => set_count(count + 1), ["increment"]),
    ])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  screen().getByText("Doubled: 2").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Doubled: 2")
  fireEvent().click(screen().getByText("increment"))
  screen().getByText("Doubled: 4").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Doubled: 4")
}

///|
test "useRef with Some" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let r : ReactRef[@dom.HTMLDivElement] = useRef(
      Some(@js.unsafe_cast(@js.Object::new())),
    )
    @react_element.div(ref_=r, ["Ref test"])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  screen().getByText("Ref test").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Ref test")
}

///|
test "useRef with None" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let r : ReactRef[@dom.HTMLDivElement] = useRef(None)
    @react_element.div(ref_=r, ["Ref None test"])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  screen().getByText("Ref None test").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Ref None test")
}

///|
test "ReactRef::current and set_current" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let (text, set_text) = useState("initial")
    let r : ReactRef[@dom.HTMLSpanElement] = useRef(None)
    let on_click : @dom.MouseEventHandler = _ => match r.get_current() {
      Some(el) => {
        el.set("textContent", "Updated by ref")
        set_text("updated")
      }
      None => ()
    }
    @react_element.div([
      @react_element.span(ref_=r, [text], id="target"),
      @react_element.button(on_click~, ["update"]),
    ])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  fireEvent().click(screen().getByText("update"))
  screen().getByText("updated").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("updated")
}

///|
test "ReactRef::current None case" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let (msg, set_msg) = useState("waiting")
    let r : ReactRef[@dom.Element] = useRef(None)
    let on_click : @dom.MouseEventHandler = _ => match r.get_current() {
      Some(_) => set_msg("has ref")
      None => set_msg("no ref")
    }
    @react_element.div([
      @react_element.span([msg]),
      @react_element.button(on_click~, ["check"]),
    ])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  fireEvent().click(screen().getByText("check"))
  screen().getByText("no ref").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("no ref")
}

///|
test "ReactRef::set_current" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let (msg, set_msg) = useState("initial")
    let r : ReactRef[@js.Js] = useRef(None)
    let on_click : @dom.MouseEventHandler = _ => {
      r.set_current(Some(@js.unsafe_cast("custom value")))
      match r.get_current() {
        Some(v) => {
          let s : String = @js.unsafe_cast(v)
          set_msg(s)
        }
        None => ()
      }
    }
    @react_element.div([
      @react_element.span([msg]),
      @react_element.button(on_click~, ["set"]),
    ])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  fireEvent().click(screen().getByText("set"))
  screen().getByText("custom value").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("custom value")
}

///|
test "useContext" {
  init_jsdom()
  cleanup()
  let ctx : Context[Int] = create_context(Some(42))
  let comp = (_props : EmptyProps) => {
    let value = use_context(ctx)
    @react_element.div(["Context value: \{value}"])
  }
  let el = provider(ctx, [component(comp, EmptyProps::default())], value=99)
  render(el) |> ignore
  screen().getByText("Context value: 99").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Context value: 99")
}

///|
enum CounterAction {
  Increment
  Decrement
  Reset
} derive(Eq)

///|
test "useReducer" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let reducer = fn(state : Int, action : CounterAction) {
      match action {
        Increment => state + 1
        Decrement => state - 1
        Reset => 0
      }
    }
    let (state, dispatch) = use_reducer(reducer, 0)
    @react_element.div([
      @react_element.span(["Count: \{state}"]),
      @react_element.button(on_click=_ => dispatch(Increment), ["+"]),
      @react_element.button(on_click=_ => dispatch(Decrement), ["-"]),
      @react_element.button(on_click=_ => dispatch(Reset), ["reset"]),
    ])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  fireEvent().click(screen().getByText("+"))
  screen().getByText("Count: 1").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Count: 1")
  fireEvent().click(screen().getByText("+"))
  screen().getByText("Count: 2").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Count: 2")
  fireEvent().click(screen().getByText("-"))
  screen().getByText("Count: 1").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Count: 1")
  fireEvent().click(screen().getByText("reset"))
  screen().getByText("Count: 0").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Count: 0")
}

///|
test "useActionState" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let action : async (Int, Int) -> Int noraise = async fn(
      state,
      _delta,
    ) -> Int noraise {
      state + 1
    }
    let (state, dispatch, is_pending) = use_action_state(action, 0)
    @react_element.div([
      @react_element.span(["State: \{state}"]),
      @react_element.span(["Pending: \{is_pending}"]),
      @react_element.button(on_click=_ => dispatch(1), ["dispatch"]),
    ])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  screen().getByText("State: 0").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("State: 0")
}

///|
test "startTransition" {
  init_jsdom()
  cleanup()
  let comp = (_props : EmptyProps) => {
    let (count, set_count) = useState(0)
    let on_click : @dom.MouseEventHandler = _ => start_transition(fn() {
      set_count(count + 1)
    })
    @react_element.div([
      @react_element.span(["Count: \{count}"]),
      @react_element.button(on_click~, ["transition"]),
    ])
  }
  render(component(comp, EmptyProps::default())) |> ignore
  fireEvent().click(screen().getByText("transition"))
  screen().getByText("Count: 1").get("textContent")
  |> @js.unsafe_cast
  |> assert_eq("Count: 1")
}
