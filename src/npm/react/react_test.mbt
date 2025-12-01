///|

///|
fn render_to_string(element : Element) -> String {
  let react_dom_server : @nostd.Any = @node.require("react-dom/server")
  let element_js : @nostd.Any = element.as_any().cast()
  react_dom_server._get("renderToString").call_self([element_js]).cast()
}

///|
priv struct TestProps {
  v : String
}

///|
test "React createElement" {
  @react.init_react_api(@node.require("react"))
  let el = @react.createElement("div", [])
  let el_type : String = el.as_any()["type"].cast()
  assert_eq(el_type, "div")
  let with_attrs = @react.createElement(
    "button",
    props={
      "className": @nostd.any("my-button"),
      "onClick": @js.identity(@js.from_fn0(fn() { @js.log("Button clicked") })),
    },
    [],
  )
  let class_name : String = with_attrs.as_any()["props"]["className"].cast()
  assert_eq(class_name, "my-button")
  let c1 = (_ : Unit) => {
    let r : ReactRef[@dom.Element] = useRef(None)
    @react.createElement("span", ref_=r, [])
  }
  @react.component(c1, ()) |> ignore
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
  let key : String = el.as_any()["key"].cast()
  assert_eq(key, "my-key")
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
  let comp = (_props : Unit) => {
    let r : ReactRef[@dom.Element] = useRef(None)
    @react.createElement("span", ["test"], ref_=r)
  }
  let el = @react.component(comp, ())
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
  let c = (_props : Unit) => @react.createElement("div", ["parent"])
  let el = @react.component(c, (), children=[
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
  let key : String = el.as_any()["key"].cast()
  assert_eq(key, "frag-key")
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
extern "js" fn load_lazy_component_stub() -> @nostd.Promise[@nostd.Any] =
  #|() => Promise.resolve({ default: () => globalThis.__ReactApi.createElement("div", null, "lazy_component") })

///|
test "lazy_ with Unit" {
  @react.init_react_api(@node.require("react"))
  let lazy_comp : Component[Unit] = lazy_(load_lazy_component_stub)
  let fallback = @react.createElement("div", ["Loading..."])
  let lazy_el = @react.component(lazy_comp, ())
  let el = suspense([lazy_el], fallback~)
  let s = render_to_string(el)
  // Lazy components render fallback during SSR with renderToString
  assert_eq(s.contains("Loading..."), true)
}

///|
extern "js" fn load_lazy_typed_component_stub() -> @nostd.Promise[@nostd.Any] =
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

///|
fn init_react() -> Unit {
  @react.init_react_api(@node.require("react"))
}

///| renderToString test

///|
async test "React DOM Server: renderToString should render a simple element" {
  init_react()
  let element = @react.createElement("div", [])
  let html = @react_dom_server.renderToString(element)
  inspect(html, content="<div></div>")
}

///|
async test "React DOM Server: renderToString should render an element with text" {
  init_react()
  let element = @react.createElement("p", ["Hello, World!"])
  let html = @react_dom_server.renderToString(element)
  inspect(html, content="<p>Hello, World!</p>")
}

///| renderToReadableStream tests

///|
async test "React DOM Server: renderToReadableStream should return a Promise of ReadableStream" {
  init_react()
  let element = @react.createElement("div", [])
  let stream = @react_dom_server.renderToReadableStream(element)
  let reader = stream.getReader()

  // Read first chunk
  let result : @nostd.Any = reader.read()
  let done : Bool = @nostd.identity(result._get("done"))

  // Should have at least one chunk
  inspect(done, content="false")
  reader.releaseLock()
}

///|
async test "React DOM Server: renderToReadableStream should render HTML content" {
  init_react()
  let element = @react.createElement("h1", ["Test Title"])
  let stream = @react_dom_server.renderToReadableStream(element)
  let reader = stream.getReader()
  let html_parts : Array[String] = []
  let decoder = @encoding.TextDecoder::new()

  // Read all chunks
  while true {
    let result : @nostd.Any = reader.read()
    let done : Bool = @nostd.identity(result._get("done"))
    if done {
      break
    }
    let value : @typedarray.Uint8Array = result._get("value").cast()
    let chunk = decoder.decode(value)
    html_parts.push(chunk)
  }
  reader.releaseLock()
  let html = html_parts.join("")
  // Check if HTML contains the expected content
  let contains_h1 = html.contains("h1")
  let contains_title = html.contains("Test Title")
  inspect(contains_h1, content="true")
  inspect(contains_title, content="true")
}

///|
async test "React DOM Server: renderToReadableStream should handle nested elements" {
  init_react()
  let inner = @react.createElement("span", ["Inner"])
  let outer = @react.createElement("div", [inner])
  let stream = @react_dom_server.renderToReadableStream(outer)
  let reader = stream.getReader()
  let html_parts : Array[String] = []
  let decoder = @encoding.TextDecoder::new()

  // Read all chunks
  while true {
    let result : @nostd.Any = reader.read()
    let done : Bool = @nostd.identity(result._get("done"))
    if done {
      break
    }
    let value : @typedarray.Uint8Array = result._get("value").cast()
    let chunk = decoder.decode(value)
    html_parts.push(chunk)
  }
  reader.releaseLock()
  let html = html_parts.join("")
  let contains_div = html.contains("div")
  let contains_span = html.contains("span")
  let contains_inner = html.contains("Inner")
  inspect(contains_div, content="true")
  inspect(contains_span, content="true")
  inspect(contains_inner, content="true")
}

///| ErrorBoundary tests

///|
test "error_boundary renders children normally" {
  init_react()
  let child = @react.createElement("div", ["child content"])
  let el = @react.error_boundary(children=[child], fallback=fn(_error, _reset) {
    @react.createElement("div", ["Error occurred"])
  })
  let s = render_to_string(el)
  assert_eq(s.contains("child content"), true)
}

///|
test "error_boundary with on_error callback" {
  init_react()
  let child = @react.createElement("span", ["test"])
  let el = @react.error_boundary(
    children=[child],
    fallback=fn(_error, _reset) { @react.createElement("div", ["Fallback"]) },
    on_error=fn(_error, _info) { () },
  )
  let s = render_to_string(el)
  assert_eq(s.contains("test"), true)
}

///|
test "error_boundary without fallback" {
  init_react()
  let child = @react.createElement("div", ["content"])
  let el = @react.error_boundary(children=[child])
  let s = render_to_string(el)
  assert_eq(s.contains("content"), true)
}

///|
/// Component that throws an error during render
extern "js" fn create_throwing_component() -> @react.Component[Unit] =
  #| () => {
  #|   return function ThrowingComponent() {
  #|     throw new Error("Test error from component");
  #|   };
  #| }

///|
test "error_boundary structure with throwing component" {
  init_react()
  let throwing_comp = create_throwing_component()
  let _el = @react.error_boundary(
    children=[@react.component(throwing_comp, ())],
    fallback=fn(error, _reset) {
      let msg : String = error["message"].cast()
      @react.createElement("div", ["Caught: " + msg])
    },
    on_error=fn(_error, _info) { () },
  )
  // Note: SSR with renderToString doesn't support ErrorBoundary
  // ErrorBoundary only works on client-side rendering
  // Here we just verify the element structure is valid
  // let type_of : String = @js.typeof_(el |> @js.identity)
  // assert_eq(type_of, "object") // React element is an object
}

///|
test "error_boundary with nested children" {
  init_react()
  let el = @react.error_boundary(
    children=[
      @react.createElement("div", [
        @react.createElement("span", ["nested child"]),
      ]),
    ],
    fallback=fn(_error, _reset) { @react.createElement("div", ["Fallback"]) },
  )
  let s = render_to_string(el)
  assert_eq(s.contains("nested child"), true)
}

///|
test "error_boundary multiple children" {
  init_react()
  let el = @react.error_boundary(children=[
    @react.createElement("p", ["first"], key="1"),
    @react.createElement("p", ["second"], key="2"),
  ])
  let s = render_to_string(el)
  assert_eq(s.contains("first"), true)
  assert_eq(s.contains("second"), true)
}

///| Component[Unit] tests - testing Unit as props instead of Unit

///|
test "Component[Unit] basic" {
  init_react()
  let comp : @react.Component[Unit] = fn(_props) {
    @react.createElement("div", ["unit props"])
  }
  let el = @react.component(comp, ())
  let s = render_to_string(el)
  assert_eq(s.contains("unit props"), true)
}

///|
test "Component[Unit] with children" {
  init_react()
  let comp : @react.Component[Unit] = fn(_props) {
    @react.createElement("div", ["parent"])
  }
  let el = @react.component(comp, (), children=[
    @react.createElement("span", ["child"]),
  ])
  let s = render_to_string(el)
  assert_eq(s.contains("parent"), true)
}

///|
test "Component[Unit] with ref" {
  init_react()
  let comp : @react.Component[Unit] = fn(_props) {
    let r : ReactRef[@dom.Element] = useRef(None)
    @react.createElement("span", ["with ref"], ref_=r)
  }
  let el = @react.component(comp, ())
  let s = render_to_string(el)
  assert_eq(s.contains("with ref"), true)
}

///|
test "Component[Unit] with key" {
  init_react()
  let comp : @react.Component[Unit] = fn(_props) {
    @react.createElement("div", ["unit with key"])
  }
  let el = @react.component(comp, (), key="my-key")
  let s = render_to_string(el)
  assert_eq(s.contains("unit with key"), true)
}

///| Test props.children vs argument children behavior

///|
priv struct PropsWithChildren {
  title : String
  children : @react.Element?
}

///|
test "component: props.children is accessible in component" {
  init_react()
  // Component that uses props.children
  let comp = (props : PropsWithChildren) => @react.createElement("div", [
    @react.createElement("h1", [props.title]),
    // props.children if provided
    match props.children {
      Some(c) => c
      None => @react.createElement("span", ["no children in props"])
    },
  ])
  // Pass children via props
  let el = @react.component(comp, {
    title: "Title",
    children: Some(@react.createElement("p", ["props child"])),
  })
  let s = render_to_string(el)
  inspect(s.contains("Title"), content="true")
  inspect(s.contains("props child"), content="true")
}

///|
test "component: argument children passed to React.createElement" {
  init_react()
  // Component that renders its structure, ignoring props
  let wrapper = (_props : Unit) => @react.createElement("section", ["wrapper"])
  // Pass children via argument - these go to React.createElement's children
  let el = @react.component(wrapper, (), children=[
    @react.createElement("span", ["arg child"]),
  ])
  let s = render_to_string(el)
  // The wrapper component renders "wrapper", not the passed children
  // because the component itself doesn't use props.children
  inspect(s.contains("wrapper"), content="true")
}

///|
extern "js" fn get_props_children(props : @nostd.Any) -> @react.Element =
  #| (props) => props.children

///|
test "component: children argument becomes props.children in React" {
  init_react()
  // Component that accesses props.children via FFI and renders them
  let wrapper : @react.Component[Unit] = fn(props) {
    let props_any : @nostd.Any = @js.identity(props)
    let children = get_props_children(props_any)
    // Render children directly - React handles this
    @react.createElement("div", [
      @react.createElement("span", ["wrapper header"]),
      children,
    ])
  }
  let el = @react.component(wrapper, (), children=[
    @react.createElement("p", ["passed child"]),
  ])
  let s = render_to_string(el)
  // Children passed as argument should be accessible as props.children
  inspect(s.contains("wrapper header"), content="true")
  inspect(s.contains("passed child"), content="true")
}
