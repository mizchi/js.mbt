# Browser DOM API Examples

Practical examples for working with Browser DOM APIs in MoonBit.

## Document & Element

### Basic DOM Operations

```moonbit nocheck
///|
fn basic_dom_example() -> Unit {
  let doc = @dom.document()

  // Create elements
  let div = doc.createElement("div")
  div.setId("my-div")
  div.setClassName("container")
  div.as_node().setTextContent("Hello, World!")

  // Set attributes
  div.setAttribute("data-value", "123")

  // Query elements
  guard doc.getElementById("app") is Some(app) else { return }
  app.as_node().appendChild(div.as_node()) |> ignore
}
```

### Query Selectors

```moonbit nocheck
///|
fn query_example() -> Unit {
  let doc = @dom.document()

  // Single element
  guard doc.documentElement().querySelector(".my-class") is Some(el) else {
    return
  }
  @js.log(el.tagName())

  // Multiple elements
  let items = doc.documentElement().querySelectorAll("li")
  for item in items {
    @js.log(item.as_node().textContent())
  }

  // By ID
  guard doc.getElementById("header") is Some(header) else { return }
  header.setClassName("active")
}
```

### Node Tree Manipulation

```moonbit nocheck
///|
fn tree_manipulation() -> Unit {
  let doc = @dom.document()
  let parent = doc.createElement("ul")

  // Create and append children
  let item1 = doc.createElement("li")
  item1.as_node().setTextContent("Item 1")
  let item2 : @dom.HTMLLIElement = doc.createElement("li").as_any().cast()
  item2.as_node().setTextContent("Item 2")
  parent.as_node().appendChild(item1.as_node()) |> ignore
  parent.as_node().appendChild(item2.as_node()) |> ignore

  // Insert before
  let item0 = doc.createElement("li")
  item0.as_node().setTextContent("Item 0")
  parent.as_node().insertBefore(item0.as_node(), Some(item1.as_node()))
  |> ignore

  // Clone node (deep)
  let _cloned = parent.as_node().cloneNode(true)

  // Check relationships
  let _has_children = parent.as_node().hasChildNodes() // true
  let _contains_item = parent.as_node().contains(Some(item1.as_node()))
  // true
}
```

## Event Handling

### Adding Event Listeners

```moonbit nocheck
///|
fn event_listener_example() -> Unit {
  let doc = @dom.document()
  guard doc.documentElement().querySelector("#my-button") is Some(button) else {
    return
  }

  // Basic click handler
  button
  .as_event_target()
  .addEventListener("click", fn(event) {
    @js.log("Button clicked!")
    @js.log(event) // MouseEvent object
  })

  // With options
  button
  .as_event_target()
  .addEventListener("click", fn(_event) { @js.log("Once only!") }, once=true)

  // Passive listener (for scroll performance)
  doc
  .as_event_target()
  .addEventListener(
    "scroll",
    fn(_event) { @js.log("Scrolling...") },
    passive=true,
  )
}
```

### Event with AbortController

```moonbit nocheck
///|
fn abort_controller_example() -> Unit {
  let doc = @dom.document()
  let controller = @js.AbortController::new()
  doc
  .as_event_target()
  .addEventListener(
    "mousemove",
    fn(_event) { @js.log("Mouse moved") },
    signal=controller.signal(),
  )

  // Later: remove the listener
  controller.abort()
}
```

## Storage API

### localStorage / sessionStorage

```moonbit nocheck
///|
fn storage_example() -> Unit {
  let storage = @storage.localStorage()

  // Set item
  storage.setItem("username", "alice")
  storage.setItem("theme", "dark")

  // Get item
  match storage.getItem("username") {
    Some(name) => @js.log("User: " + name)
    None => @js.log("No user found")
  }

  // Check existence
  if storage.hasItem("theme") {
    @js.log("Theme is set")
  }

  // Get all keys
  let keys = storage.keys()
  keys.iter().each(fn(key) { @js.log(key) })

  // Get all entries
  let entries = storage.entries()
  entries
  .iter()
  .each(fn(entry) {
    let (key, value) = entry
    @js.log(key + ": " + value)
  })

  // Remove item
  storage.removeItem("theme")

  // Clear all
  storage.clear()
}
```

## Window & Location

### Window Object

```moonbit nocheck
///|
fn window_example() -> Unit {
  let win = @dom.window()

  // Dimensions
  let width = win.innerWidth()
  let height = win.innerHeight()
  @js.log("Window size: " + width.to_string() + "x" + height.to_string())

  // Scroll
  win.scrollTo(0, 100)
  win.scrollBy(0, 50)

  // Timers
  let timer_id = win.setTimeout(fn() { @js.log("Timeout fired!") }, 1000)

  // Cancel if needed
  win.clearTimeout(timer_id)

  // Interval
  let interval_id = win.setInterval(fn() { @js.log("Interval tick") }, 1000)
  win.clearInterval(interval_id)
}
```

## Canvas (2D)

### Basic Canvas Drawing

```moonbit nocheck
///|
fn canvas_example() -> Unit {
  let doc = @dom.document()
  guard doc.documentElement().querySelector("canvas") is Some(canvas_el) else {
    return
  }
  let canvas : @dom.HTMLCanvasElement = canvas_el |> @js.identity

  // Get 2D context
  let ctx : @canvas.CanvasRenderingContext2D = canvas.getContext("2d").cast()

  // Draw rectangle
  ctx.fillStyle = "blue"
  ctx.fillRect(10.0, 10.0, 100.0, 50.0)

  // Draw path
  ctx.beginPath()
  ctx.moveTo(200.0, 50.0)
  ctx.lineTo(250.0, 100.0)
  ctx.lineTo(150.0, 100.0)
  ctx.closePath()
  ctx.fillStyle = "red"
  ctx.fill()

  // Draw text
  ctx.font = "24px Arial"
  ctx.fillStyle = "black"
  ctx.fillText("Hello Canvas!", 50.0, 200.0)
}
```

### Canvas to Blob (async)

```moonbit nocheck
///|
async fn canvas_to_blob_example() -> Unit {
  let doc = @dom.document()
  guard doc.documentElement().querySelector("canvas") is Some(canvas_el) else {
    return
  }
  let canvas : @dom.HTMLCanvasElement = canvas_el |> @js.identity

  // Convert to blob (async)
  let blob = canvas.toBlob(image_type="image/png")
  @js.log(blob)
}
```

## See Also

- [Browser README](../../browser/README.md) - Full API reference
- [Web APIs](../../web/README.md) - Platform-independent Web Standard APIs
- [FFI Best Practices](./ffi_bestpractice.mbt.md) - General FFI patterns
