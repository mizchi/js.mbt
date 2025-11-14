# mizchi/js/dom

DOM API bindings for MoonBit, providing type-safe access to browser DOM operations.

## Overview

This package provides comprehensive bindings to the Web DOM API, including:

- **Document**: Document object methods and properties
- **Element**: Element manipulation, attributes, and DOM traversal
- **Event**: Event handling (Mouse, Keyboard, Pointer, Focus, etc.)
- **Node**: Node interface operations
- **Navigator**: Browser information and capabilities
- **Storage**: localStorage and sessionStorage
- **Style**: CSS style manipulation

All APIs are aligned with TypeScript's standard DOM type definitions and include MDN documentation links.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/dom"
  ]
}
```

## Usage Examples

### Creating Elements

```moonbit
let doc = @dom.document()
let div = doc.create_element("div")
div.set_attribute("id", "app")
div.set_attribute("class", "container")

let text = doc.create_text_node("Hello, World!")
div.append_child(text.as_element()) |> ignore
```

### Element Manipulation

```moonbit
// Property access
div.set("innerHTML", "Hello World")
let content = div.get("innerHTML")

// Attributes
div.set_attribute("data-value", "123")
let value = div.get_attribute("data-value") // Some("123")
div.remove_attribute("data-value")

// Class manipulation
div.add_class("active")
div.remove_class("inactive")
div.toggle_class("hidden")
inspect(div.contains_class("active")) // true

// DOM properties
div.set_id("main")
div.set_class_name("app container")
div.set_inner_html("<span>Content</span>")
```

### DOM Traversal

```moonbit
let parent = element.parent_element()
let children = element.children()
let first = element.first_child()
let last = element.last_child()
let next = element.next_sibling()
let prev = element.previous_sibling()

// Element-only traversal (skips text nodes)
let first_elem = element.first_element_child()
let next_elem = element.next_element_sibling()
```

### Query Selectors

```moonbit
let doc = @dom.document()

// Single element
let el = doc.query_selector("#app")
match el {
  Some(element) => element.set_text_content("Found!")
  None => ()
}

// By ID
let element = doc.get_element_by_id("main")

// Multiple elements
let elements = doc.query_selector_all(".item")
let by_tag = doc.get_elements_by_tag_name("div")
let by_class = doc.get_elements_by_class_name("container")
```

### Event Handling

```moonbit
fn handle_click(event : @dom.Event) -> Unit {
  event.prevent_default()
  event.stop_propagation()
  let target = event.target()
  target.set_text_content("Clicked!")
}

element.add_event_listener("click", handle_click)

// Remove listener
element.remove_event_listener("click", handle_click)
```

### Mouse Events

```moonbit
fn handle_mouse(event : @dom.MouseEvent) -> Unit {
  let x = event.client_x()
  let y = event.client_y()
  let button = event.button()
  
  if event.ctrl_key() {
    // Handle Ctrl+Click
  }
}

element.add_event_listener("click", fn(e) { 
  handle_mouse(e |> @js.unsafe_cast) 
})
```

### Keyboard Events

```moonbit
fn handle_keydown(event : @dom.KeyboardEvent) -> Unit {
  let key = event.key()
  let code = event.code()
  
  if event.ctrl_key() && key == "s" {
    event.prevent_default()
    // Handle Ctrl+S
  }
}
```

### Style Manipulation

```moonbit
// Inline styles
div.set_display("block")
div.set_color("red")
div.set_width("100px")
div.set_height("50px")
div.set_opacity(0.5)

// CSS properties
div.set_style_property("background-color", "blue")
div.set_style_property("border-radius", "5px")

// Get computed style
let computed = @dom.get_computed_style(div)
let color = computed.get("color")
```

### Flexbox & Grid

```moonbit
container.set_display("flex")
container.set_flex_direction("row")
container.set_justify_content("center")
container.set_align_items("center")
container.set_gap("10px")

// Grid
grid.set_display("grid")
grid.set_grid_template_columns("1fr 2fr 1fr")
grid.set_grid_template_rows("auto")
```

### Storage (localStorage/sessionStorage)

```moonbit
let storage = @dom.get_local_storage()

// Set and get
storage.set_item("user", "Alice")
let user = storage.get_item("user") // Some("Alice")

// Remove
storage.remove_item("user")

// Check existence
if storage.has_item("token") {
  // ...
}

// Iterate
let keys = storage.keys()
let values = storage.values()
let entries = storage.entries()

// Clear all
storage.clear()
```

### Navigator

```moonbit
let nav = @dom.navigator()
let ua = nav.user_agent()
let lang = nav.language()
let online = nav.on_line()
let platform = nav.platform()
let cores = nav.hardware_concurrency()
```

### Document Operations

```moonbit
let doc = @dom.document()

// Document properties
let title = doc.title()
doc.set_title("New Title")
let url = doc.url()
let domain = doc.domain()

// Body and head
let body = doc.body()
let head = doc.head()

// Create fragment
let fragment = doc.create_document_fragment()
```

### Geometry

```moonbit
// Client dimensions
let width = element.client_width()
let height = element.client_height()

// Scroll dimensions
let scroll_width = element.scroll_width()
let scroll_height = element.scroll_height()

// Scroll position
let scroll_top = element.scroll_top()
element.set_scroll_top(100.0)

// Bounding rect
let rect = element.get_bounding_client_rect()
```

### Node Operations

```moonbit
// Clone node
let clone = element.clone_node(true) // deep clone

// Check containment
if parent.contains(child) {
  // parent contains child
}

// Compare nodes
if node1.is_equal_node(node2) {
  // nodes are equal
}

// Text content
element.set_text_content("New text")
let text = element.text_content()
```

## Testing with JSDOM

This package includes comprehensive tests using `global-jsdom` to emulate a browser environment in Node.js.

```moonbit
// Setup JSDOM
extern "js" fn require(module_name : String) -> @js.Val =
  #| (moduleName) => require(moduleName)

fn setup_jsdom() -> Unit {
  let jsdom = require("global-jsdom")
  jsdom.call([]) |> ignore
}

// Run tests
test "basic DOM operations" {
  setup_jsdom()
  let doc = @dom.document()
  let div = doc.create_element("div")
  div.set_attribute("id", "test")
  inspect(div.get_attribute("id"), content="Some(\"test\")")
}
```

## Type Safety

All DOM operations are type-safe and use MoonBit's FFI system:

- `Element`: DOM elements
- `Document`: Document object
- `Event`, `MouseEvent`, `KeyboardEvent`, etc.: Event types
- `Navigator`: Browser navigator
- `Storage`: Web Storage
- `TextNode`: Text nodes

Most functions return `Option` types for nullable values:

```moonbit
match element.parent_element() {
  Some(parent) => // Handle parent
  None => // No parent
}
```

## API Documentation

All functions include:
- Type signatures
- MDN documentation links
- Usage examples
- Safety notes where applicable

See the source files for detailed documentation:
- `element.mbt` - Element operations
- `document.mbt` - Document operations
- `event.mbt` - Event types and handlers
- `node.mbt` - Node interface
- `style.mbt` - CSS styling
- `storage.mbt` - Web Storage
- `navigator.mbt` - Browser information

## Related Packages

- `mizchi/js` - Core JavaScript FFI
- `mizchi/js/async` - Async/Promise support
- `mizchi/js/console` - Console logging

## License

See the main project license.