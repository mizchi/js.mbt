///|
fn init_jsdom() -> Unit {
  @global_jsdom.register()
  @react.init_react_api(@node.require("react"))
  @testing_library_react.setup_matchers()
  @testing_library_react.cleanup()
}

///|
test "useState_lazy" {
  init_jsdom()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (count, set_count) = use_state_lazy(fn() { 10 })
    let on_click : @dom.MouseEventHandler = _ => set_count(count + 1) |> ignore
    @react_element.div([
      @react_element.span(["Count: \{count}"], id="count"),
      @react_element.button(on_click~, ["increment"], id="btn"),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 10"),
  )..toHaveTextContent("Count: 10")
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("increment"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 11"),
  )..toHaveTextContent("Count: 11")
}

///|
test "useCallback" {
  init_jsdom()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (count, set_count) = useState(0)
    let on_click = useCallback(fn() { set_count(count + 1) }, [
      @nostd.any(count),
    ])
    @react_element.div([
      @react_element.span(["Count: \{count}"]),
      @react_element.button(on_click=_ => on_click(), ["increment"]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("increment"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 1"),
  )..toHaveTextContent("Count: 1")
}

///|
test "useEffect" {
  init_jsdom()
  defer @testing_library_react.cleanup()
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
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Mounted"),
  )..toHaveTextContent("Mounted")
}

///|
test "useLayoutEffect" {
  init_jsdom()
  defer @testing_library_react.cleanup()
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
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Layout mounted"),
  )..toHaveTextContent("Layout mounted")
}

///|
test "useMemo" {
  init_jsdom()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (count, set_count) = useState(1)
    let doubled = useMemo(fn() { count * 2 }, [@nostd.any(count)])
    @react_element.div([
      @react_element.span(["Doubled: \{doubled}"]),
      @react_element.button(on_click=_ => set_count(count + 1), ["increment"]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Doubled: 2"),
  )..toHaveTextContent("Doubled: 2")
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("increment"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Doubled: 4"),
  )..toHaveTextContent("Doubled: 4")
}

///|
test "useRef with Some" {
  init_jsdom()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let r : ReactRef[@dom.HTMLDivElement] = useRef(
      Some(@js.identity(@nostd.Object::new())),
    )
    @react_element.div(ref_=r, ["Ref test"])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Ref test"),
  )..toHaveTextContent("Ref test")
}

///|
test "useRef with None" {
  init_jsdom()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let r : ReactRef[@dom.HTMLDivElement] = useRef(None)
    @react_element.div(ref_=r, ["Ref None test"])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Ref None test"),
  )..toHaveTextContent("Ref None test")
}

///|
test "ReactRef::current and set_current" {
  init_jsdom()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (text, set_text) = useState("initial")
    let r : ReactRef[@dom.HTMLSpanElement] = useRef(None)
    let on_click : @dom.MouseEventHandler = _ => match r.get_current() {
      Some(el) => {
        el.as_node().setTextContent("Updated by ref")
        set_text("updated")
      }
      None => ()
    }
    @react_element.div([
      @react_element.span(ref_=r, [text], id="target"),
      @react_element.button(on_click~, ["update"]),
    ])
  }
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("update"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("updated"),
  )..toHaveTextContent("updated")
}

///|
test "ReactRef::current None case" {
  init_jsdom()
  defer @testing_library_react.cleanup()
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
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("check"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("no ref"),
  )..toHaveTextContent("no ref")
}

///|
test "ReactRef::set_current" {
  init_jsdom()
  defer @testing_library_react.cleanup()
  let comp = (_props : Unit) => {
    let (msg, set_msg) = useState("initial")
    let r : ReactRef[@nostd.Any] = useRef(None)
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
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("set"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("custom value"),
  )..toHaveTextContent("custom value")
}

///|
test "useContext" {
  init_jsdom()
  defer @testing_library_react.cleanup()
  let ctx : Context[Int] = create_context(Some(42))
  let comp = (_props : Unit) => {
    let value = use_context(ctx)
    @react_element.div(["Context value: \{value}"])
  }
  let el = provider(ctx, [@react.component(comp, ())], value=99)
  @testing_library_react.render(el) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Context value: 99"),
  )..toHaveTextContent("Context value: 99")
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
  defer @testing_library_react.cleanup()
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
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("+"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 1"),
  )..toHaveTextContent("Count: 1")
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("+"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 2"),
  )..toHaveTextContent("Count: 2")
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("-"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 1"),
  )..toHaveTextContent("Count: 1")
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("reset"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 0"),
  )..toHaveTextContent("Count: 0")
}

///|
test "useActionState" {
  init_jsdom()
  defer @testing_library_react.cleanup()
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
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("State: 0"),
  )..toHaveTextContent("State: 0")
}

///|
test "startTransition" {
  init_jsdom()
  defer @testing_library_react.cleanup()
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
  @testing_library_react.render(@react.component(comp, ())) |> ignore
  @testing_library_react.fireEvent().click(
    @testing_library_react.screen().getByText("transition"),
  )
  |> ignore
  @testing_library_react.expect(
    @testing_library_react.screen().getByText("Count: 1"),
  )..toHaveTextContent("Count: 1")
}
