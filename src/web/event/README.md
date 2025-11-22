# mizchi/js/web/event

Event API for event-driven programming.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/web/event"
  ]
}
```

## Overview

Provides bindings for the Event API, including Event, CustomEvent, and MessageEvent.

## Usage Example

```moonbit
fn main {
  // Create a custom event
  let event = @event.CustomEvent::new("myevent")
  
  // Create event with detail
  let detail_event = @event.CustomEvent::new_with_detail("myevent", "detail data")
  
  // Create a message event
  let msg_event = @event.MessageEvent::new("message")
  
  // Event properties
  let event_type = event.type_()
  let bubbles = event.bubbles()
  let cancelable = event.cancelable()
}
```

## Available Types

- **Event** - Base event type
- **CustomEvent** - Events with custom data
- **MessageEvent** - Events for message passing
- **EventTarget** - Event listener registration

## Reference

- [MDN: Event](https://developer.mozilla.org/en-US/docs/Web/API/Event)
- [MDN: CustomEvent](https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent)
- [MDN: MessageEvent](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent)
