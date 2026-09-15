# mizchi/js_browser

Browser-specific API bindings for MoonBit, providing type-safe access to browser DOM operations and browser-specific features.

## Packages

| Package | Status | Note |
|---------|--------|------|
| `mizchi/js_browser/dom` | 🧪 Tested | Document, Element, Node, HTMLElement, SVGElement, Window, Events, CSS |
| `mizchi/js_browser/canvas` | 🧪 Tested | Canvas 2D, OffscreenCanvas |
| `mizchi/js_browser/file` | 🧪 Tested | File, FileReader, FileList |
| `mizchi/js_browser/history` | 🧪 Tested | History API |
| `mizchi/js_browser/location` | 🧪 Tested | Location API |
| `mizchi/js_browser/navigator` | 🧪 Tested | Navigator API |
| `mizchi/js_browser/storage` | 🤖 AI Generated | localStorage, sessionStorage |
| `mizchi/js_browser/indexeddb` | 🧪 Tested | IndexedDB |
| `mizchi/js_browser/observer` | 🤖 AI Generated | MutationObserver, IntersectionObserver, ResizeObserver |
| `mizchi/js_browser/serviceworker` | 🧪 Tested | ServiceWorker, ServiceWorkerRegistration |

### Status Legend

- 🧪 **Tested**: Has test coverage
- 🤖 **AI Generated**: FFI bindings created, needs testing

## Overview

This package provides comprehensive bindings to browser-specific APIs, including:

- **DOM**: Document, Element, Node, HTMLElement, SVGElement, Window, Text, DocumentFragment
- **Events**: Mouse, Keyboard, Pointer, Focus, Drag event handling
- **Canvas**: 2D rendering context, OffscreenCanvas
- **Storage**: localStorage, sessionStorage, IndexedDB
- **Navigation**: History, Location
- **Browser Info**: Navigator
- **Workers**: ServiceWorker

All APIs are aligned with TypeScript's standard DOM type definitions.

### See Also

- **[mizchi/js_web](../web/README.md)** - Platform-independent Web Standard APIs (fetch, Streams, WebSocket, etc.)
- **[mizchi/js_node](../../js_node/src/README.md)** - Node.js-specific APIs
