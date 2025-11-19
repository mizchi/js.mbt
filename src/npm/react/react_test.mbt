///|
using @js {type Js, unsafe_cast, log}

///|
fn render_to_string(element : Element) -> String {
  let react_dom_server : Js = @node.require("react-dom/server")
  unsafe_cast(react_dom_server.get("renderToString").call_self([element]))
}

///|
priv struct TestProps {
  v : String
}

///|
test "React createElement" {
  init_react_api(@node.require("react"))
  let el = createElement("div", [])
  assert_eq(unsafe_cast(el.get("type")), "div")
  let with_attrs = createElement(
    "button",
    props={
      "className": "my-button" |> unsafe_cast,
      "onClick": @js.from_fn0(fn() { log("Button clicked") }),
    },
    [],
  )
  assert_eq(unsafe_cast(with_attrs.get("props").get("className")), "my-button")
  let c1 = (_ : EmptyProps) => {
    let r : ReactRef[@dom.Element] = useRef(None)
    createElement("span", ref_=r, [])
  }
  component(c1, EmptyProps::default()) |> ignore
  let c2 = (props : TestProps) => createElement("p", [props.v])
  component(c2, { v: "Hello, World!" }) |> ignore
}

///|
test "render_to_string" {
  init_react_api(@node.require("react"))
  let el = createElement("h1", ["ssr"])
  let s = render_to_string(el)
  assert_eq(s, "<h1>ssr</h1>")
}

///|
test "createElement with key" {
  init_react_api(@node.require("react"))
  let el = createElement("div", ["test"], key="my-key")
  assert_eq(unsafe_cast(el.get("key")), "my-key")
}

///|
test "createElement with style" {
  init_react_api(@node.require("react"))
  let el = createElement("div", [], style={ "color": "red", "fontSize": "16px" })
  let s = render_to_string(el)
  assert_eq(s.contains("color:red"), true)
  assert_eq(s.contains("font-size:16px"), true)
}

///|
test "createElement with ref" {
  init_react_api(@node.require("react"))
  let comp = (_props : EmptyProps) => {
    let r : ReactRef[@dom.Element] = useRef(None)
    createElement("span", ["test"], ref_=r)
  }
  let el = component(comp, EmptyProps::default())
  let s = render_to_string(el)
  assert_eq(s.contains("test"), true)
}

///|
test "component with key" {
  init_react_api(@node.require("react"))
  let c = (props : TestProps) => createElement("div", [props.v])
  let el = component(c, { v: "keyed-value" }, key="comp-key")
  let s = render_to_string(el)
  assert_eq(s.contains("keyed-value"), true)
}

///|
test "component with children" {
  init_react_api(@node.require("react"))
  let c = (_props : EmptyProps) => createElement("div", ["parent"])
  let el = component(c, EmptyProps::default(), children=[
    createElement("span", ["child"]),
  ])
  let s = render_to_string(el)
  assert_eq(s.contains("parent"), true)
}

///|
test "fragment" {
  init_react_api(@node.require("react"))
  let el = fragment([createElement("div", ["1"]), createElement("div", ["2"])])
  let s = render_to_string(el)
  assert_eq(s, "<div>1</div><div>2</div>")
}

///|
test "fragment with key" {
  init_react_api(@node.require("react"))
  let el = fragment([createElement("div", ["item"])], key="frag-key")
  assert_eq(unsafe_cast(el.get("key")), "frag-key")
}

///|
test "suspense" {
  init_react_api(@node.require("react"))
  let fallback_el = createElement("div", ["Loading..."])
  let child = createElement("div", ["Content"])
  let el = suspense([child], fallback=fallback_el)
  let s = render_to_string(el)
  assert_eq(s.contains("Content"), true)
}

///|
test "provider" {
  init_react_api(@node.require("react"))
  let ctx : Context[Int] = create_context(Some(42))
  let child = createElement("div", ["child"])
  let el = provider(ctx, [child], value=100)
  let s = render_to_string(el)
  assert_eq(s.contains("child"), true)
}

///|
test "ReactNode Int" {
  init_react_api(@node.require("react"))
  let el = createElement("div", [42])
  let s = render_to_string(el)
  assert_eq(s, "<div>42</div>")
}

///|
test "ReactNode Double" {
  init_react_api(@node.require("react"))
  let el = createElement("div", [3.14])
  let s = render_to_string(el)
  assert_eq(s.contains("3.14"), true)
}

///|
test "ReactNode Bool" {
  init_react_api(@node.require("react"))
  let el = createElement("div", [true])
  let s = render_to_string(el)
  assert_eq(s, "<div></div>")
}

///|
test "ReactNode Option Some" {
  init_react_api(@node.require("react"))
  let text : String? = Some("hello")
  let el = createElement("div", [text])
  let s = render_to_string(el)
  assert_eq(s, "<div>hello</div>")
}

///|
test "ReactNode Option None" {
  init_react_api(@node.require("react"))
  let text : String? = None
  let el = createElement("div", [text])
  let s = render_to_string(el)
  assert_eq(s, "<div></div>")
}
