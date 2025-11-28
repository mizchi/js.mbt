# WebExtensions API

MoonBit bindings for WebExtensions API (browser extensions).

https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API

## Supported APIs

| API | Package | Status | Note |
|-----|---------|--------|------|
| [chrome](chrome/) | `mizchi/js/webextensions/chrome` | 🤖 AI Generated | Unified wrapper for all APIs |
| [storage](storage/) | `mizchi/js/webextensions/storage` | 🤖 AI Generated | local, sync, session storage |
| [runtime](runtime/) | `mizchi/js/webextensions/runtime` | 🤖 AI Generated | messaging, extension info |
| [tabs](tabs/) | `mizchi/js/webextensions/tabs` | 🤖 AI Generated | tab management |

## Quick Start (Using Chrome Wrapper)

```moonbit
// Initialize Chrome wrapper - provides unified access to all APIs
let chrome = @chrome.chrome()

// Storage
chrome.storage.local_area.set_item("key", "value" |> @js.any)
let value = chrome.storage.local_area.get_item("key")

// Runtime
let manifest = chrome.runtime.get_manifest()
chrome.runtime.send_message(message)

// Tabs
let tabs = chrome.tabs.query(options={ active: Some(true) })
chrome.tabs.create(options={ url: Some("https://example.com") })
```

## Usage

### Storage API

```moonbit
// Get storage area
let storage = @storage.local_storage()

// Set item
storage.set_item("key", "value" |> @js.any)

// Get item
let value = storage.get_item("key")

// Get all items
let all = storage.get_all()

// Remove item
storage.remove_item("key")

// Clear all
storage.clear()

// Listen for changes
@storage.on_changed(fn(changes, area_name) {
  @js.log("Storage changed in: \{area_name}")
})
```

### Runtime API

```moonbit
// Get manifest
let manifest = @runtime.get_manifest()

// Get extension URL
let url = @runtime.get_url("popup.html")

// Send message (within extension)
let response = @runtime.send_message(message)

// Listen for messages
@runtime.on_message(fn(message, sender, send_response) {
  @js.log("Received message")
  send_response("response" |> @js.any)
  true  // Return true to indicate async response
})

// Long-lived connections
let port = @runtime.connect(name="my-port")
port.post_message("hello" |> @js.any)
port.on_message(fn(msg) {
  @js.log("Port message received")
})

// Listen for extension install
@runtime.on_installed(fn(details) {
  @js.log("Extension installed/updated")
})
```

### Tabs API

```moonbit
// Query tabs
let tabs = @tabs.query(options={ active: Some(true), current_window: Some(true) })

// Get current tab
let current = @tabs.get_current()

// Create tab
let tab = @tabs.create(options={ url: Some("https://example.com") })

// Update tab
@tabs.update(tab_id, { url: Some("https://new-url.com"), ..@tabs.UpdateOptions::default() })

// Remove tab
@tabs.remove_tab(tab_id)

// Send message to content script
let response = @tabs.send_message(tab_id, message)

// Listen for tab events
@tabs.on_created(fn(tab) {
  @js.log("Tab created: \{tab.id}")
})

@tabs.on_updated(fn(tab_id, change_info, tab) {
  @js.log("Tab updated")
})

@tabs.on_removed(fn(tab_id, remove_info) {
  @js.log("Tab removed")
})
```

## Browser Compatibility

Works with:
- Firefox (using `browser` namespace)
- Chrome/Chromium (using `chrome` namespace)
- Edge, Opera, etc.

The bindings automatically detect the browser and use the appropriate namespace.
