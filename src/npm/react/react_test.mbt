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

///|
test "ReactNode Array of ReactNode" {
  init_react_api(@node.require("react"))
  let items : Array[&ReactNode] = ["item1", "item2", "item3"]
  let el = createElement("div", [items])
  let s = render_to_string(el)
  assert_eq(s, "<div>item1<!-- -->item2<!-- -->item3</div>")
}

///|
test "ReactNode nested Array with Elements" {
  init_react_api(@node.require("react"))
  let nested : Array[&ReactNode] = [
    createElement("span", ["a"], key="a"),
    createElement("span", ["b"], key="b"),
    createElement("span", ["c"], key="c"),
  ]
  let el = createElement("div", [nested])
  let s = render_to_string(el)
  assert_eq(s, "<div><span>a</span><span>b</span><span>c</span></div>")
}

///|
test "ReactNode Array with mixed types" {
  init_react_api(@node.require("react"))
  let mixed : Array[&ReactNode] = [
    "text",
    42,
    createElement("strong", ["bold"], key="bold"),
  ]
  let el = createElement("div", [mixed])
  let s = render_to_string(el)
  assert_eq(s, "<div>text<!-- -->42<strong>bold</strong></div>")
}

///|
test "ReactNode deeply nested Arrays" {
  init_react_api(@node.require("react"))
  let inner : Array[&ReactNode] = ["inner1", "inner2"]
  let outer : Array[&ReactNode] = ["outer", inner, "end"]
  let el = createElement("div", [outer])
  let s = render_to_string(el)
  assert_eq(s, "<div>outer<!-- -->inner1<!-- -->inner2<!-- -->end</div>")
}

///|
test "ReactNode Array with Option values" {
  init_react_api(@node.require("react"))
  let opt_some : String? = Some("middle")
  let opt_none : String? = None
  let with_option : Array[&ReactNode] = [
    "start",
    opt_some,
    opt_none,
    "end",
  ]
  let el = createElement("div", [with_option])
  let s = render_to_string(el)
  assert_eq(s, "<div>start<!-- -->middle<!-- -->end</div>")
}

///|
test "ReactNode Array with for expression" {
  init_react_api(@node.require("react"))
  let items = ["apple", "banana", "cherry"]
  let children : Array[&ReactNode] = items.map(fn(item) {
    createElement("li", [item], key=item)
  })
  let el = createElement("ul", [children])
  let s = render_to_string(el)
  assert_eq(s, "<ul><li>apple</li><li>banana</li><li>cherry</li></ul>")
}

///|
test "ReactNode fragment with for expression" {
  init_react_api(@node.require("react"))
  let items = [1, 2, 3]
  let children : Array[&ReactNode] = items.map(fn(i) {
    createElement("div", [i], key=i.to_string())
  })
  let el = fragment(children)
  let s = render_to_string(el)
  assert_eq(s, "<div>1</div><div>2</div><div>3</div>")
}

///|
test "ReactNode Array with map in fragment" {
  init_react_api(@node.require("react"))
  let numbers = [10, 20, 30]
  let mapped : Array[&ReactNode] = numbers.map(fn(n) {
    createElement("span", [n], key=n.to_string())
  })
  let el = fragment(mapped)
  let s = render_to_string(el)
  assert_eq(s, "<span>10</span><span>20</span><span>30</span>")
}

///|
test "ReactNode conditional rendering in for expression" {
  init_react_api(@node.require("react"))
  let items = [1, 2, 3, 4, 5]
  let children : Array[&ReactNode] = items.map(fn(i) {
    if i % 2 == 0 {
      createElement("strong", [i], key=i.to_string())
    } else {
      createElement("em", [i], key=i.to_string())
    }
  })
  let el = createElement("div", [children])
  let s = render_to_string(el)
  assert_eq(s, "<div><em>1</em><strong>2</strong><em>3</em><strong>4</strong><em>5</em></div>")
}
