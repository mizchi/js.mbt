# mizchi/js_web/message

MessageChannel API for two-way communication between contexts.

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_web@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_web/message",
}
```

## Overview

Provides bindings for MessageChannel and MessagePort for creating communication channels.

## Usage Example

```moonbit
fn main {
  // Create a message channel
  let channel = @message.MessageChannel()
  
  // Get the two ports
  let port1 = channel.port1()
  let port2 = channel.port2()
  
  // Set up message handler on port1
  port1.set_onmessage(fn(event) {
    @console.log("Port1 received:", event.data())
  })
  
  // Send message from port2 to port1
  port2.post_message("Hello from port2!")
  
  // Start receiving messages
  port1.start()
}
```

## Use Cases

- Communication between main thread and workers
- Iframe communication
- Creating isolated communication channels

## Reference

- [MDN: MessageChannel](https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel)
- [MDN: MessagePort](https://developer.mozilla.org/en-US/docs/Web/API/MessagePort)
