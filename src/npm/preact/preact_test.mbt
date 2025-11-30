///|
/// Mutable box for test state (avoids collision with preact Ref type)
priv struct MutBox[T] {
  mut val : T
}

///|
fn setup() -> () -> Unit {
  @global_jsdom.register()
  init_preact_api(@node.require("preact"), @node.require("preact/hooks"))
  let signals : @nostd.Any = @node.require("@preact/signals").cast()
  init_preact_signals(signals)
  let ssr : @nostd.Any = @node.require("preact-render-to-string").cast()
  init_preact_ssr(ssr)
  fn() { () }
}

///|
fn get_container() -> @dom.HTMLElement {
  let doc = @dom.document()
  let container : @dom.HTMLElement = @nostd.identity(doc.createElement("div"))
  guard doc.body() is Some(body) else { abort("body not found") }
  body.as_node().appendChild(container.as_node()) |> ignore
  container
}

///|
test "h creates VNode" {
  let dispose = setup()
  defer dispose()
  let vnode = h("div", ["Hello"])
  // VNode should be created
  inspect(not(@nostd.is_nullish(vnode.as_any())), content="true")
}

///|
test "h with props" {
  let dispose = setup()
  defer dispose()
  let vnode = h("button", ["Click me"], props={ "disabled": @nostd.any(true) })
  inspect(not(@nostd.is_nullish(vnode.as_any())), content="true")
}

///|
test "h with style" {
  let dispose = setup()
  defer dispose()
  let vnode = h("div", ["Styled"], style={ "color": "red", "fontSize": "16px" })
  inspect(not(@nostd.is_nullish(vnode.as_any())), content="true")
}

///|
test "fragment" {
  let dispose = setup()
  defer dispose()
  let vnode = fragment(["Hello", " ", "World"])
  inspect(not(@nostd.is_nullish(vnode.as_any())), content="true")
}

///|
test "component function" {
  let dispose = setup()
  defer dispose()
  let my_component : Component[Unit] = fn(_props) {
    h("div", ["Component content"])
  }
  let vnode = component(my_component, ())
  inspect(not(@nostd.is_nullish(vnode.as_any())), content="true")
}

///|
test "render to container" {
  let dispose = setup()
  defer dispose()
  let container = get_container()
  let vnode = h("div", ["Rendered"])
  render(vnode, container.as_element())
  let inner_html : String = container.innerHTML()
  inspect(inner_html, content="<div>Rendered</div>")
}

///|
test "useState hook" {
  let dispose = setup()
  defer dispose()
  let container = get_container()
  let counter_component : Component[Unit] = fn(_props) {
    let (count, _set_count) = useState(0)
    h("span", [count])
  }
  render(component(counter_component, ()), container.as_element())
  let inner_html : String = container.innerHTML()
  inspect(inner_html, content="<span>0</span>")
}

///|
test "createContext and useContext" {
  let dispose = setup()
  defer dispose()
  let ctx : Context[Int] = createContext(Some(42))
  let container = get_container()
  let consumer : Component[Unit] = fn(_props) {
    let value = useContext(ctx)
    h("span", [value.to_string()])
  }
  render(
    provider(ctx, [component(consumer, ())], value=100),
    container.as_element(),
  )
  let inner_html : String = container.innerHTML()
  inspect(inner_html, content="<span>100</span>")
}

///|
test "useRef" {
  let dispose = setup()
  defer dispose()
  let container = get_container()
  let ref_component : Component[Unit] = fn(_props) {
    let my_ref : Ref[Int] = useRef(Some(42))
    let value = my_ref.get_current()
    h("span", [
      match value {
        Some(v) => v.to_string()
        None => "none"
      },
    ])
  }
  render(component(ref_component, ()), container.as_element())
  let inner_html : String = container.innerHTML()
  inspect(inner_html, content="<span>42</span>")
}

///|
test "useMemo" {
  let dispose = setup()
  defer dispose()
  let container = get_container()
  let memo_component : Component[Unit] = fn(_props) {
    let result = useMemo(() => 21 * 2, [])
    h("span", [result.to_string()])
  }
  render(component(memo_component, ()), container.as_element())
  let inner_html : String = container.innerHTML()
  inspect(inner_html, content="<span>42</span>")
}

// Signal tests

///|
test "signal - create and read value" {
  let dispose = setup()
  defer dispose()
  let count : Signal[Int] = signal(0)
  inspect(count.value, content="0")
}

///|
test "signal - set value" {
  let dispose = setup()
  defer dispose()
  let count : Signal[Int] = signal(0)
  count.value = 42
  inspect(count.value, content="42")
}

///|
test "signal - peek value" {
  let dispose = setup()
  defer dispose()
  let count : Signal[Int] = signal(10)
  inspect(count.peek(), content="10")
}

///|
test "signal - subscribe to changes" {
  let dispose = setup()
  defer dispose()
  let count : Signal[Int] = signal(0)
  let last_value : MutBox[Int] = { val: 0 }
  let unsubscribe = count.subscribe(fn(v) { last_value.val = v })
  count.value = 5
  inspect(last_value.val, content="5")
  count.value = 10
  inspect(last_value.val, content="10")
  unsubscribe()
  count.value = 15
  // After unsubscribe, callback should not be called
  inspect(last_value.val, content="10")
}

///|
test "computed - derive from signal" {
  let dispose = setup()
  defer dispose()
  let count : Signal[Int] = signal(5)
  let doubled : ReadonlySignal[Int] = computed(fn() { count.value * 2 })
  inspect(doubled.value, content="10")
  count.value = 10
  inspect(doubled.value, content="20")
}

///|
test "computed - chain multiple signals" {
  let dispose = setup()
  defer dispose()
  let a : Signal[Int] = signal(1)
  let b : Signal[Int] = signal(2)
  let sum : ReadonlySignal[Int] = computed(fn() { a.value + b.value })
  inspect(sum.value, content="3")
  a.value = 10
  inspect(sum.value, content="12")
  b.value = 20
  inspect(sum.value, content="30")
}

///|
test "computed - peek value" {
  let dispose = setup()
  defer dispose()
  let count : Signal[Int] = signal(7)
  let doubled : ReadonlySignal[Int] = computed(fn() { count.value * 2 })
  inspect(doubled.peek(), content="14")
}

///|
test "effect - runs on signal change" {
  let dispose = setup()
  defer dispose()
  let count : Signal[Int] = signal(0)
  let run_count : MutBox[Int] = { val: 0 }
  let dispose_effect = effect(fn() {
    let _ = count.value
    run_count.val = run_count.val + 1
  })
  // Effect runs once initially
  inspect(run_count.val, content="1")
  count.value = 1
  inspect(run_count.val, content="2")
  count.value = 2
  inspect(run_count.val, content="3")
  dispose_effect()
  count.value = 3
  // After dispose, effect should not run
  inspect(run_count.val, content="3")
}

///|
test "batch - batches multiple updates" {
  let dispose = setup()
  defer dispose()
  let a : Signal[Int] = signal(1)
  let b : Signal[Int] = signal(2)
  let run_count : MutBox[Int] = { val: 0 }
  let dispose_effect = effect(fn() {
    let _ = a.value + b.value
    run_count.val = run_count.val + 1
  })
  // Effect runs once initially
  inspect(run_count.val, content="1")
  // Without batch, each set_value would trigger effect
  batch(fn() {
    a.value = 10
    b.value = 20
  })
  // With batch, effect should only run once for both updates
  inspect(run_count.val, content="2")
  dispose_effect()
}

///|
test "untracked - read without subscribing" {
  let dispose = setup()
  defer dispose()
  let count : Signal[Int] = signal(5)
  let run_count : MutBox[Int] = { val: 0 }
  let dispose_effect = effect(fn() {
    // This read is untracked, so changes won't trigger effect
    let _ = untracked(fn() { count.value })
    run_count.val = run_count.val + 1
  })
  inspect(run_count.val, content="1")
  count.value = 10
  // Effect should NOT run because read was untracked
  inspect(run_count.val, content="1")
  dispose_effect()
}

///|
test "signal with string" {
  let dispose = setup()
  defer dispose()
  let name : Signal[String] = signal("hello")
  inspect(name.value, content="hello")
  name.value = "world"
  inspect(name.value, content="world")
}

///|
test "computed with string" {
  let dispose = setup()
  defer dispose()
  let first : Signal[String] = signal("Hello")
  let last : Signal[String] = signal("World")
  let full : ReadonlySignal[String] = computed(fn() {
    first.value + " " + last.value
  })
  inspect(full.value, content="Hello World")
  first.value = "Goodbye"
  inspect(full.value, content="Goodbye World")
}

// SSR tests

///|
test "renderToString - basic" {
  let dispose = setup()
  defer dispose()
  let vnode = h("div", ["Hello SSR"])
  let html = renderToString(vnode)
  inspect(html, content="<div>Hello SSR</div>")
}

///|
test "renderToString - nested" {
  let dispose = setup()
  defer dispose()
  let vnode = h("div", [h("span", ["Nested"])])
  let html = renderToString(vnode)
  inspect(html, content="<div><span>Nested</span></div>")
}

///|
test "renderToString - component" {
  let dispose = setup()
  defer dispose()
  let greeting : Component[Unit] = fn(_props) { h("h1", ["Hello"]) }
  let html = renderToString(component(greeting, ()))
  inspect(html, content="<h1>Hello</h1>")
}

///|
test "SSR then hydrate" {
  let dispose = setup()
  defer dispose()
  // 1. SSR: render component to string
  let app : Component[Unit] = fn(_props) {
    h("div", [h("button", ["Click me"])], props={ "id": @nostd.any("app") })
  }
  let html = renderToString(component(app, ()))
  inspect(html, content="<div id=\"app\"><button>Click me</button></div>")
  // 2. Set up DOM with SSR HTML
  let container = get_container()
  container.setInnerHTML(html)
  // 3. Hydrate: attach event handlers
  hydrate(component(app, ()), container.as_element())
  // 4. Verify DOM is intact after hydration
  let inner_html : String = container.innerHTML()
  inspect(inner_html, content="<div id=\"app\"><button>Click me</button></div>")
}

///|
async test "renderToStringAsync - basic" {
  let dispose = setup()
  defer dispose()
  let vnode = h("div", ["Async SSR"])
  let html = renderToStringAsync(vnode)
  inspect(html, content="<div>Async SSR</div>")
}

///|
async test "SSR async component then hydrate" {
  let dispose = setup()
  defer dispose()
  // Async component that fetches data
  let async_app : Component[Unit] = fn(_props) {
    let (data, _set_data) = useState("loaded")
    h("article", [h("p", [data])])
  }
  // 1. SSR: async render
  let html = renderToStringAsync(component(async_app, ()))
  inspect(html, content="<article><p>loaded</p></article>")
  // 2. Set up DOM
  let container = get_container()
  container.setInnerHTML(html)
  // 3. Hydrate
  hydrate(component(async_app, ()), container.as_element())
  let inner_html : String = container.innerHTML()
  inspect(inner_html, content="<article><p>loaded</p></article>")
}

// Resource tests

///|
test "createResource - initial loading state" {
  let dispose = setup()
  defer dispose()
  let resource = createResource(fn() { @nostd.Promise::resolve("fetched data") })
  // Resource starts in loading state
  inspect(resource.loading(), content="true")
  inspect(resource.try_value(), content="None")
  inspect(resource.has_error(), content="false")
}
