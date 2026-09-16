# mizchi/js_browser/observer

Observer APIs for monitoring DOM and element changes.

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_browser@0.13.0",
  "mizchi/js_core@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_core" @core,
  "mizchi/js_browser/observer",
}
```

## Overview

Provides bindings for Observer APIs to monitor changes in the DOM and elements.

## Usage Example

```moonbit
fn main {
  // MutationObserver - Watch DOM changes
  let mutation_observer = @observer.MutationObserver(fn(mutations, observer) {
    @console.log("DOM changed")
  })
  
  let target = @dom.document().body()
  let config = @core.Object::new()
  config.set("childList", true)
  config.set("subtree", true)
  mutation_observer.observe(target, config)
  
  // IntersectionObserver - Watch element visibility
  let intersection_observer = @observer.IntersectionObserver(fn(entries, observer) {
    @console.log("Element visibility changed")
  })
  
  let element = @dom.document().get_element_by_id("target")
  intersection_observer.observe(element)
  
  // ResizeObserver - Watch element size changes
  let resize_observer = @observer.ResizeObserver(fn(entries, observer) {
    @console.log("Element resized")
  })
  
  resize_observer.observe(element)
}
```

## Available Types

- **MutationObserver** - Monitor DOM tree changes
- **IntersectionObserver** - Monitor element visibility in viewport
- **ResizeObserver** - Monitor element size changes

## Use Cases

- Lazy loading images
- Infinite scroll
- Responsive layouts
- Dynamic content updates

## Reference

- [MDN: MutationObserver](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver)
- [MDN: IntersectionObserver](https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver)
- [MDN: ResizeObserver](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver)
