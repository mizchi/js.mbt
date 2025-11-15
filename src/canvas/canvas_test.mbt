///| Canvas tests

// Note: Canvas API tests are omitted as they require a browser environment.
// Canvas APIs (HTMLCanvasElement, CanvasRenderingContext2D, ImageData, ImageBitmap, OffscreenCanvas)
// are browser-specific and are not available in Node.js without the canvas package.

// Example usage pattern (for documentation):
//
// Canvas element:
// let canvas = document.createElement("canvas")
// canvas.set_width(300)
// canvas.set_height(200)
//
// 2D context:
// let ctx = canvas.get_context("2d")
// ctx.set_fill_style("red")
// ctx.fill_rect(10.0, 10.0, 100.0, 50.0)
//
// ImageData:
// let image_data = ctx.create_image_data(10, 20)
// let data = image_data.data()
//
// ImageBitmap:
// let bitmap = await create_image_bitmap(image_element)
//
// OffscreenCanvas:
// let offscreen = OffscreenCanvas::new(300, 200)
// let ctx = offscreen.get_context("2d")
// ctx.set_fill_style("blue")
// ctx.fill_rect(0.0, 0.0, 100.0, 100.0)
// let bitmap = offscreen.transfer_to_image_bitmap()
//
// Transferable with postMessage:
// let offscreen = OffscreenCanvas::new(100, 100)
// worker.post_message_with_transfer(
//   message,
//   [offscreen.to_transferable()]
// )
