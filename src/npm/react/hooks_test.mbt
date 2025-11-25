///|

///|
fn init_jsdom() -> Unit {
  @node.require("global-jsdom/register") |> ignore
  @react.init_react_api(@node.require("react"))
}

///|
test "useState_lazy" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (count, set_count) = use_state_lazy(fn() { 10 })
    let on_click : @dom.MouseEventHandler = _ => set_count(count + 1) |> ignore
    @react_element.div([
      @react_element.span(["Count: \{count}"], id="count"),
      @react_element.button(on_click~, ["increment"], id="btn"),
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen()
  .getByText("Count: 10")
  .get("textContent")
  .cast()
  |> assert_eq("Count: 10")
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("increment"),
  )
  @react_testing_library.screen()
  .getByText("Count: 11")
  .get("textContent")
  .cast()
  |> assert_eq("Count: 11")
}

///|
test "useCallback" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (count, set_count) = useState(0)
    let on_click = useCallback(fn() { set_count(count + 1) }, [count])
    @react_element.div([
      @react_element.span(["Count: \{count}"]),
      @react_element.button(on_click=_ => on_click(), ["increment"]),
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("increment"),
  )
  @react_testing_library.screen()
  .getByText("Count: 1")
  .get("textContent")
  .cast()
  |> assert_eq("Count: 1")
}

///|
test "useEffect" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
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
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen().getByText("Mounted").get("textContent").cast()
  |> assert_eq("Mounted")
}

///|
test "useLayoutEffect" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
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
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen()
  .getByText("Layout mounted")
  .get("textContent")
  .cast()
  |> assert_eq("Layout mounted")
}

///|
test "useMemo" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (count, set_count) = useState(1)
    let doubled = useMemo(fn() { count * 2 }, [count])
    @react_element.div([
      @react_element.span(["Doubled: \{doubled}"]),
      @react_element.button(on_click=_ => set_count(count + 1), ["increment"]),
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen()
  .getByText("Doubled: 2")
  .get("textContent")
  .cast()
  |> assert_eq("Doubled: 2")
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("increment"),
  )
  @react_testing_library.screen()
  .getByText("Doubled: 4")
  .get("textContent")
  .cast()
  |> assert_eq("Doubled: 4")
}

///|
test "useRef with Some" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let r : ReactRef[@dom.HTMLDivElement] = useRef(
      Some(@js.identity(@js.Object::new())),
    )
    @react_element.div(ref_=r, ["Ref test"])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen()
  .getByText("Ref test")
  .get("textContent")
  .cast()
  |> assert_eq("Ref test")
}

///|
test "useRef with None" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let r : ReactRef[@dom.HTMLDivElement] = useRef(None)
    @react_element.div(ref_=r, ["Ref None test"])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen()
  .getByText("Ref None test")
  .get("textContent")
  .cast()
  |> assert_eq("Ref None test")
}

///|
test "ReactRef::current and set_current" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
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
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("update"),
  )
  @react_testing_library.screen().getByText("updated").get("textContent").cast()
  |> assert_eq("updated")
}

///|
test "ReactRef::current None case" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
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
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("check"),
  )
  @react_testing_library.screen().getByText("no ref").get("textContent").cast()
  |> assert_eq("no ref")
}

///|
test "ReactRef::set_current" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (msg, set_msg) = useState("initial")
    let r : ReactRef[@js.Any] = useRef(None)
    let on_click : @dom.MouseEventHandler = _ => {
      r.set_current(Some(@js.identity("custom value")))
      match r.get_current() {
        Some(v) => {
          let s : String = @js.identity(v)
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
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("set"),
  )
  @react_testing_library.screen()
  .getByText("custom value")
  .get("textContent")
  .cast()
  |> assert_eq("custom value")
}

///|
test "useContext" {
  init_jsdom()
  @react_testing_library.cleanup()
  let ctx : Context[Int] = create_context(Some(42))
  let comp = (_props : Unit) => {
    let value = use_context(ctx)
    @react_element.div(["Context value: \{value}"])
  }
  let el = provider(ctx, [@react.component(comp, ())], value=99)
  @react_testing_library.render(el) |> ignore
  @react_testing_library.screen()
  .getByText("Context value: 99")
  .get("textContent")
  .cast()
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
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
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
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("+"),
  )
  @react_testing_library.screen()
  .getByText("Count: 1")
  .get("textContent")
  .cast()
  |> assert_eq("Count: 1")
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("+"),
  )
  @react_testing_library.screen()
  .getByText("Count: 2")
  .get("textContent")
  .cast()
  |> assert_eq("Count: 2")
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("-"),
  )
  @react_testing_library.screen()
  .getByText("Count: 1")
  .get("textContent")
  .cast()
  |> assert_eq("Count: 1")
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("reset"),
  )
  @react_testing_library.screen()
  .getByText("Count: 0")
  .get("textContent")
  .cast()
  |> assert_eq("Count: 0")
}

///|
test "useActionState" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
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
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.screen()
  .getByText("State: 0")
  .get("textContent")
  .cast()
  |> assert_eq("State: 0")
}

///|
test "startTransition" {
  init_jsdom()
  @react_testing_library.cleanup()
  let comp = (_props : Unit) => {
    let (count, set_count) = useState(0)
    let on_click : @dom.MouseEventHandler = _ => start_transition(fn() {
      set_count(count + 1)
    })
    @react_element.div([
      @react_element.span(["Count: \{count}"]),
      @react_element.button(on_click~, ["transition"]),
    ])
  }
  @react_testing_library.render(@react.component(comp, ())) |> ignore
  @react_testing_library.fireEvent().click(
    @react_testing_library.screen().getByText("transition"),
  )
  @react_testing_library.screen()
  .getByText("Count: 1")
  .get("textContent")
  .cast()
  |> assert_eq("Count: 1")
}
