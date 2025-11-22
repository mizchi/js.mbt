# mizchi/js/web/websocket

WebSocket API for real-time bidirectional communication.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/web/websocket"
  ]
}
```

## Overview

Provides bindings for the WebSocket API for persistent connections to servers.

## Usage Example

```moonbit
fn main {
  // Create a WebSocket connection
  let ws = @websocket.WebSocket::new("wss://example.com/socket")
  
  // Set event handlers
  ws.set_onopen(fn(event) {
    @console.log("Connected")
  })
  
  ws.set_onmessage(fn(event) {
    @console.log("Message:", event.data())
  })
  
  ws.set_onerror(fn(event) {
    @console.error("Error")
  })
  
  ws.set_onclose(fn(event) {
    @console.log("Disconnected")
  })
  
  // Send data
  ws.send("Hello, server!")
  
  // Close connection
  ws.close()
}
```

## Connection States

- `CONNECTING` (0) - Connection is being established
- `OPEN` (1) - Connection is open and ready
- `CLOSING` (2) - Connection is closing
- `CLOSED` (3) - Connection is closed

## Reference

- [MDN: WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket)
