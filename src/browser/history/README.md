# mizchi/js/browser/history

History API for browser navigation history manipulation.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/browser/history"
  ]
}
```

## Overview

Provides bindings for the History API to manipulate browser session history.

## Usage Example

```moonbit
fn main {
  // Get history object
  let history = @history.history()
  
  // Navigate
  history.back()
  history.forward()
  history.go(-2)  // Go back 2 pages
  
  // Modify history
  history.push_state(state_obj, "title", "/new-url")
  history.replace_state(state_obj, "title", "/replaced-url")
  
  // Get current state
  let state = history.state()
  
  // Get history length
  let length = history.length()
}
```

## Use Cases

- Single Page Application (SPA) routing
- Back/forward navigation
- URL manipulation without page reload
- State management across navigation

## Reference

- [MDN: History API](https://developer.mozilla.org/en-US/docs/Web/API/History_API)
- [MDN: History](https://developer.mozilla.org/en-US/docs/Web/API/History)
