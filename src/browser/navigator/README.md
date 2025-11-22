# mizchi/js/browser/navigator

Navigator API for browser and device information.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/browser/navigator"
  ]
}
```

## Overview

Provides bindings for the Navigator API to access browser and device information.

## Usage Example

```moonbit
fn main {
  // Get navigator object
  let nav = @navigator.navigator()
  
  // Browser information
  let user_agent = nav.user_agent()
  let language = nav.language()
  let languages = nav.languages()
  let platform = nav.platform()
  
  // Online/offline status
  let is_online = nav.online()
  
  // Hardware information
  let cpu_cores = nav.hardware_concurrency()
  let memory = nav.device_memory()  // GB
  
  // Clipboard access
  let clipboard = nav.clipboard()
  
  // Geolocation
  let geolocation = nav.geolocation()
}
```

## Available Features

- Browser and device information
- Online/offline detection
- Hardware capabilities
- Clipboard API access
- Geolocation API access
- Service Worker registration

## Reference

- [MDN: Navigator](https://developer.mozilla.org/en-US/docs/Web/API/Navigator)
