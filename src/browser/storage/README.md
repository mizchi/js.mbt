# mizchi/js/browser/storage

Web Storage API (localStorage, sessionStorage) for client-side data persistence.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/browser/storage"
  ]
}
```

## Overview

Provides bindings for Web Storage API to store key-value pairs in the browser.

## Usage Example

```moonbit
fn main {
  // localStorage - Persistent storage
  let local = @storage.local_storage()
  
  // Set item
  local.set_item("key", "value")
  
  // Get item
  let value = local.get_item("key")  // Some("value")
  
  // Remove item
  local.remove_item("key")
  
  // Clear all
  local.clear()
  
  // Get number of items
  let length = local.length()
  
  // sessionStorage - Session-only storage
  let session = @storage.session_storage()
  session.set_item("temp", "data")
  
  // Get key by index
  let key = local.key(0)
}
```

## Storage Types

- **localStorage** - Data persists until explicitly deleted
- **sessionStorage** - Data cleared when page session ends

## Storage Limits

- Typically 5-10 MB per origin
- Synchronous API (use IndexedDB for large data)
- String-only storage (serialize objects as JSON)

## Reference

- [MDN: Web Storage API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API)
- [MDN: localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage)
- [MDN: sessionStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage)
