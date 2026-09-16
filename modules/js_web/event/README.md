# mizchi/js_web/event

Event API for event-driven programming.

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
  "mizchi/js_web/event",
}
```

## Overview

Provides bindings for `Event`, `EventTarget` and `EventSource` (server-sent
events).

## Usage Example

```moonbit
///|
pub fn dispatch(target : @event.EventTarget) -> Bool {
  // Create an event
  let event = @event.Event("myevent", bubbles=true, cancelable=true)

  // Event properties
  let _ = event.type_()
  let _ = event.bubbles()
  let _ = event.cancelable()

  // Register a listener, then dispatch
  target.addEventListener("myevent", _ev => ())
  target.dispatchEvent(event)
}
```

Server-sent events go through `EventSource`:

```moonbit
///|
pub fn subscribe() -> @event.EventSource {
  let source = @event.EventSource("/stream")
  source.set_onmessage(ev => println(@event.get_event_data(ev)))
  source
}
```

## Available Types

- **Event** - Base event type
- **EventTarget** - Event listener registration and dispatch
- **EventSource** - Server-sent events

`CustomEvent` and `MessageEvent` are not bound in this package. A message
event's payload is readable from the raw value with the `get_event_data` /
`get_event_origin` / `get_last_event_id` helpers above; `@message` covers
`MessageChannel` and `MessagePort`.

## Reference

- [MDN: Event](https://developer.mozilla.org/en-US/docs/Web/API/Event)
- [MDN: EventTarget](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget)
- [MDN: EventSource](https://developer.mozilla.org/en-US/docs/Web/API/EventSource)
