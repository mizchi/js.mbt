# mizchi/js/browser/canvas

Canvas API for 2D graphics and drawing.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/browser/canvas"
  ]
}
```

## Overview

Provides bindings for the HTML Canvas API for drawing 2D graphics in the browser.

## Usage Example

```moonbit
fn main {
  // Get canvas element
  let doc = @dom.document()
  let canvas = doc.get_element_by_id("myCanvas")
  
  // Get 2D rendering context
  let ctx = @canvas.get_context_2d(canvas)
  
  // Draw shapes
  ctx.fill_rect(10.0, 10.0, 100.0, 50.0)
  ctx.stroke_rect(150.0, 10.0, 100.0, 50.0)
  
  // Draw paths
  ctx.begin_path()
  ctx.move_to(50.0, 100.0)
  ctx.line_to(150.0, 100.0)
  ctx.line_to(100.0, 150.0)
  ctx.close_path()
  ctx.stroke()
  
  // Set styles
  ctx.set_fill_style("#FF0000")
  ctx.set_stroke_style("#0000FF")
  ctx.set_line_width(2.0)
  
  // Draw text
  ctx.fill_text("Hello, Canvas!", 10.0, 200.0)
}
```

## Available Features

- Shape drawing (rectangles, arcs, paths)
- Text rendering
- Image manipulation
- Gradients and patterns
- Transformations (translate, rotate, scale)
- Pixel manipulation

## Reference

- [MDN: Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API)
- [MDN: CanvasRenderingContext2D](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D)
