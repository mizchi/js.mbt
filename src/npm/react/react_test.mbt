///|
using @js {type Val, trait Js, global_this, js, unsafe_cast, log}

///|
fn render_to_string(element : Element) -> String {
  let react_dom_server : Val = @node.require("react-dom/server")
  unsafe_cast(react_dom_server.get("renderToString").invoke_self([element]))
}

///|
priv struct TestProps {
  v : String
}

///|
test "create_element" {
  init_react()
  let el = create_element("div", [])
  assert_eq(unsafe_cast(el.get("type")), "div")
  let with_attrs = create_element(
    "button",
    attributes={
      "className": "my-button" |> js,
      "onClick": js(fn() { log("Button clicked") }),
    },
    [],
  )
  assert_eq(unsafe_cast(with_attrs.get("props").get("className")), "my-button")
  let c1 = (_ : EmptyProps) => {
    let r : ReactRef[@dom.Element] = use_ref(None)
    create_element("span", ref_=r, [])
  }
  c(c1, EmptyProps::default()) |> ignore
  let c2 = (props : TestProps) => create_element("p", [props.v])
  c(c2, { v: "Hello, World!" }) |> ignore
}

///|
test "render_to_string" {
  init_react()
  let el = create_element("h1", ["ssr"])
  let s = render_to_string(el)
  assert_eq(s, "<h1>ssr</h1>")
}
