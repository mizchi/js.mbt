///|

///|
fn render_to_string(element : Element) -> String {
  let react_dom_server : @js.Any = @node.require("react-dom/server")
  @js.identity(react_dom_server.get("renderToString").call_self([element]))
}

///|
priv struct TestProps {
  v : String
}

///|
test "React createElement" {
  @react.init_react_api(@node.require("react"))
  let el = @react.createElement("div", [])
  assert_eq(@js.identity(el.get("type")), "div")
  let with_attrs = @react.createElement(
    "button",
    props={
      "className": "my-button" |> @js.js,
      "onClick": @js.from_fn0(fn() { @js.log("Button clicked") }),
    },
    [],
  )
  assert_eq(@js.identity(with_attrs.get("props").get("className")), "my-button")
  let c1 = (_ : EmptyProps) => {
    let r : ReactRef[@dom.Element] = useRef(None)
    @react.createElement("span", ref_=r, [])
  }
  @react.component(c1, EmptyProps::default()) |> ignore
  let c2 = (props : TestProps) => @react.createElement("p", [props.v])
  @react.component(c2, { v: "Hello, World!" }) |> ignore
}

///|
test "render_to_string" {
  @react.init_react_api(@node.require("react"))
  let el = @react.createElement("h1", ["ssr"])
  let s = render_to_string(el)
  assert_eq(s, "<h1>ssr</h1>")
}

///|
test "createElement with key" {
  @react.init_react_api(@node.require("react"))
  let el = @react.createElement("div", ["test"], key="my-key")
  assert_eq(@js.identity(el.get("key")), "my-key")
}

///|
test "createElement with style" {
  @react.init_react_api(@node.require("react"))
  let el = @react.createElement("div", [], style={
    "color": "red",
    "fontSize": "16px",
  })
  let s = render_to_string(el)
  assert_eq(s.contains("color:red"), true)
  assert_eq(s.contains("font-size:16px"), true)
}

///|
test "createElement with ref" {
  @react.init_react_api(@node.require("react"))
  let comp = (_props : EmptyProps) => {
    let r : ReactRef[@dom.Element] = useRef(None)
    @react.createElement("span", ["test"], ref_=r)
  }
  let el = @react.component(comp, EmptyProps::default())
  let s = render_to_string(el)
  assert_eq(s.contains("test"), true)
}

///|
test "component with key" {
  @react.init_react_api(@node.require("react"))
  let c = (props : TestProps) => @react.createElement("div", [props.v])
  let el = @react.component(c, { v: "keyed-value" }, key="comp-key")
  let s = render_to_string(el)
  assert_eq(s.contains("keyed-value"), true)
}

///|
test "component with children" {
  @react.init_react_api(@node.require("react"))
  let c = (_props : EmptyProps) => @react.createElement("div", ["parent"])
  let el = @react.component(c, EmptyProps::default(), children=[
    @react.createElement("span", ["child"]),
  ])
  let s = render_to_string(el)
  assert_eq(s.contains("parent"), true)
}

///|
test "fragment" {
  @react.init_react_api(@node.require("react"))
  let el = fragment([
    createElement("div", ["1"]),
    @react.createElement("div", ["2"]),
  ])
  let s = render_to_string(el)
  assert_eq(s, "<div>1</div><div>2</div>")
}

///|
test "fragment with key" {
  @react.init_react_api(@node.require("react"))
  let el = fragment([createElement("div", ["item"])], key="frag-key")
  assert_eq(@js.identity(el.get("key")), "frag-key")
}

///|
test "suspense" {
  @react.init_react_api(@node.require("react"))
  let fallback_el = @react.createElement("div", ["Loading..."])
  let child = @react.createElement("div", ["Content"])
  let el = suspense([child], fallback=fallback_el)
  let s = render_to_string(el)
  assert_eq(s.contains("Content"), true)
}

///|
test "provider" {
  @react.init_react_api(@node.require("react"))
  let ctx : Context[Int] = create_context(Some(42))
  let child = @react.createElement("div", ["child"])
  let el = provider(ctx, [child], value=100)
  let s = render_to_string(el)
  assert_eq(s.contains("child"), true)
}

///|
test "ReactNode Int" {
  @react.init_react_api(@node.require("react"))
  let el = @react.createElement("div", [42])
  let s = render_to_string(el)
  assert_eq(s, "<div>42</div>")
}

///|
test "ReactNode Double" {
  @react.init_react_api(@node.require("react"))
  let el = @react.createElement("div", [3.14])
  let s = render_to_string(el)
  assert_eq(s.contains("3.14"), true)
}

///|
test "ReactNode Bool" {
  @react.init_react_api(@node.require("react"))
  let el = @react.createElement("div", [true])
  let s = render_to_string(el)
  assert_eq(s, "<div></div>")
}

///|
test "ReactNode Option Some" {
  @react.init_react_api(@node.require("react"))
  let text : String? = Some("hello")
  let el = @react.createElement("div", [text])
  let s = render_to_string(el)
  assert_eq(s, "<div>hello</div>")
}

///|
test "ReactNode Option None" {
  @react.init_react_api(@node.require("react"))
  let text : String? = None
  let el = @react.createElement("div", [text])
  let s = render_to_string(el)
  assert_eq(s, "<div></div>")
}

///|
test "ReactNode Array of ReactNode" {
  @react.init_react_api(@node.require("react"))
  let items : Array[&ReactNode] = ["item1", "item2", "item3"]
  let el = @react.createElement("div", [items])
  let s = render_to_string(el)
  assert_eq(s, "<div>item1<!-- -->item2<!-- -->item3</div>")
}

///|
test "ReactNode nested Array with Elements" {
  @react.init_react_api(@node.require("react"))
  let nested : Array[&ReactNode] = [
    @react.createElement("span", ["a"], key="a"),
    @react.createElement("span", ["b"], key="b"),
    @react.createElement("span", ["c"], key="c"),
  ]
  let el = @react.createElement("div", [nested])
  let s = render_to_string(el)
  assert_eq(s, "<div><span>a</span><span>b</span><span>c</span></div>")
}

///|
test "ReactNode Array with mixed types" {
  @react.init_react_api(@node.require("react"))
  let mixed : Array[&ReactNode] = [
    "text",
    42,
    @react.createElement("strong", ["bold"], key="bold"),
  ]
  let el = @react.createElement("div", [mixed])
  let s = render_to_string(el)
  assert_eq(s, "<div>text<!-- -->42<strong>bold</strong></div>")
}

///|
test "ReactNode deeply nested Arrays" {
  @react.init_react_api(@node.require("react"))
  let inner : Array[&ReactNode] = ["inner1", "inner2"]
  let outer : Array[&ReactNode] = ["outer", inner, "end"]
  let el = @react.createElement("div", [outer])
  let s = render_to_string(el)
  assert_eq(s, "<div>outer<!-- -->inner1<!-- -->inner2<!-- -->end</div>")
}

///|
test "ReactNode Array with Option values" {
  @react.init_react_api(@node.require("react"))
  let opt_some : String? = Some("middle")
  let opt_none : String? = None
  let with_option : Array[&ReactNode] = ["start", opt_some, opt_none, "end"]
  let el = @react.createElement("div", [with_option])
  let s = render_to_string(el)
  assert_eq(s, "<div>start<!-- -->middle<!-- -->end</div>")
}

///|
test "ReactNode Array with for expression" {
  @react.init_react_api(@node.require("react"))
  let items = ["apple", "banana", "cherry"]
  let children : Array[&ReactNode] = items.map(fn(item) {
    @react.createElement("li", [item], key=item)
  })
  let el = @react.createElement("ul", [children])
  let s = render_to_string(el)
  assert_eq(s, "<ul><li>apple</li><li>banana</li><li>cherry</li></ul>")
}

///|
test "ReactNode fragment with for expression" {
  @react.init_react_api(@node.require("react"))
  let items = [1, 2, 3]
  let children : Array[&ReactNode] = items.map(fn(i) {
    @react.createElement("div", [i], key=i.to_string())
  })
  let el = fragment(children)
  let s = render_to_string(el)
  assert_eq(s, "<div>1</div><div>2</div><div>3</div>")
}

///|
test "ReactNode Array with map in fragment" {
  @react.init_react_api(@node.require("react"))
  let numbers = [10, 20, 30]
  let mapped : Array[&ReactNode] = numbers.map(fn(n) {
    @react.createElement("span", [n], key=n.to_string())
  })
  let el = fragment(mapped)
  let s = render_to_string(el)
  assert_eq(s, "<span>10</span><span>20</span><span>30</span>")
}

///|
test "ReactNode conditional rendering in for expression" {
  @react.init_react_api(@node.require("react"))
  let items = [1, 2, 3, 4, 5]
  let children : Array[&ReactNode] = items.map(fn(i) {
    if i % 2 == 0 {
      @react.createElement("strong", [i], key=i.to_string())
    } else {
      @react.createElement("em", [i], key=i.to_string())
    }
  })
  let el = @react.createElement("div", [children])
  let s = render_to_string(el)
  assert_eq(
    s, "<div><em>1</em><strong>2</strong><em>3</em><strong>4</strong><em>5</em></div>",
  )
}

///|
extern "js" fn load_lazy_component_stub() -> @js.Promise[@js.Any] =
  #|() => Promise.resolve({ default: () => globalThis.__ReactApi.createElement("div", null, "lazy_component") })

///|
test "lazy_ with EmptyProps" {
  @react.init_react_api(@node.require("react"))
  let lazy_comp : Component[EmptyProps] = lazy_(load_lazy_component_stub)
  let fallback = @react.createElement("div", ["Loading..."])
  let lazy_el = @react.component(lazy_comp, EmptyProps::default())
  let el = suspense([lazy_el], fallback~)
  let s = render_to_string(el)
  // Lazy components render fallback during SSR with renderToString
  assert_eq(s.contains("Loading..."), true)
}

///|
extern "js" fn load_lazy_typed_component_stub() -> @js.Promise[@js.Any] =
  #|() => Promise.resolve({ default: (props) => globalThis.__ReactApi.createElement("div", null, "Hello, " + props.v) })

///|
test "lazy_ with custom props" {
  @react.init_react_api(@node.require("react"))
  let lazy_comp : Component[TestProps] = lazy_(load_lazy_typed_component_stub)
  let fallback = @react.createElement("div", ["Loading..."])
  let lazy_el = @react.component(lazy_comp, { v: "World" })
  let el = suspense([lazy_el], fallback~)
  let s = render_to_string(el)
  // Lazy components render fallback during SSR with renderToString
  assert_eq(s.contains("Loading..."), true)
}
