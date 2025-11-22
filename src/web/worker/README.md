# mizchi/js/web/worker

Web Workers API for background processing in separate threads.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/web/worker"
  ]
}
```

## Overview

Provides bindings for Web Workers and MessagePort for multi-threaded JavaScript execution.

## Usage Example

```moonbit
fn main {
  // Create a worker
  let worker = @worker.Worker::new("worker.js")
  
  // Send message to worker
  worker.post_message("Hello, worker!")
  
  // Receive messages from worker
  worker.set_onmessage(fn(event) {
    @console.log("Worker says:", event.data())
  })
  
  // Handle errors
  worker.set_onerror(fn(event) {
    @console.error("Worker error:", event.message())
  })
  
  // Terminate worker
  worker.terminate()
}
```

## Available Types

- **Worker** - Background thread worker
- **SharedWorker** - Worker shared across contexts
- **MessagePort** - Communication channel

## Reference

- [MDN: Web Workers API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API)
- [MDN: Worker](https://developer.mozilla.org/en-US/docs/Web/API/Worker)
- [MDN: MessagePort](https://developer.mozilla.org/en-US/docs/Web/API/MessagePort)
