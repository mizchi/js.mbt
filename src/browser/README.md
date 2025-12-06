# mizchi/js/browser

Browser-specific API bindings for MoonBit, providing type-safe access to browser DOM operations and browser-specific features.

## Packages

| Package | Status | Note |
|---------|--------|------|
| `mizchi/js/browser/dom` | 🧪 Tested | Document, Element, Node, HTMLElement, SVGElement, Window, Events, CSS |
| `mizchi/js/browser/canvas` | 🧪 Tested | Canvas 2D, OffscreenCanvas |
| `mizchi/js/browser/file` | 🧪 Tested | File, FileReader, FileList |
| `mizchi/js/browser/history` | 🧪 Tested | History API |
| `mizchi/js/browser/location` | 🧪 Tested | Location API |
| `mizchi/js/browser/navigator` | 🧪 Tested | Navigator API |
| `mizchi/js/browser/storage` | 🤖 AI Generated | localStorage, sessionStorage |
| `mizchi/js/browser/indexeddb` | 🧪 Tested | IndexedDB |
| `mizchi/js/browser/observer` | 🤖 AI Generated | MutationObserver, IntersectionObserver, ResizeObserver |
| `mizchi/js/browser/serviceworker` | 🧪 Tested | ServiceWorker, ServiceWorkerRegistration |

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

- **[mizchi/js/web](../web/README.md)** - Platform-independent Web Standard APIs (fetch, Streams, WebSocket, etc.)
- **[mizchi/js/node](../node/README.md)** - Node.js-specific APIs
