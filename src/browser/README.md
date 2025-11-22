# mizchi/js/browser

Browser-specific API bindings for MoonBit, providing type-safe access to browser DOM operations and browser-specific features.

## Browser API Support Status

### DOM APIs

| API | Package | Status | Note |
|-----|---------|--------|------|
| Document | `mizchi/js/browser/dom` | 🧪 Tested | DOM manipulation |
| Element | `mizchi/js/browser/dom` | 🧪 Tested | Element operations |
| Node | `mizchi/js/browser/dom` | 🧪 Tested | Node interface |
| HTMLElement | `mizchi/js/browser/dom` | 🧪 Tested | HTML elements |
| Text | `mizchi/js/browser/dom` | 🧪 Tested | Text nodes |
| ShadowDOM | `mizchi/js/browser/dom` | 🤖 AI Generated | Shadow DOM |

### Event APIs

| API | Package | Status | Note |
|-----|---------|--------|------|
| Event | `mizchi/js/browser/event` | 🧪 Tested | Event handling |
| MouseEvent | `mizchi/js/browser/event` | 🧪 Tested | Mouse events |
| KeyboardEvent | `mizchi/js/browser/event` | 🧪 Tested | Keyboard events |
| PointerEvent | `mizchi/js/browser/event` | 🧪 Tested | Pointer events |
| FocusEvent | `mizchi/js/browser/event` | 🧪 Tested | Focus events |
| CustomEvent | `mizchi/js/browser/dom` | 🧪 Tested | Custom events |

### Browser Objects

| API | Package | Status | Note |
|-----|---------|--------|------|
| Window | `mizchi/js/browser/dom` | 🧪 Tested | Window object |
| Navigator | `mizchi/js/browser/dom` | 🧪 Tested | Browser info |

### Browser Storage

| API | Package | Status | Note |
|-----|---------|--------|------|
| Storage | `mizchi/js/browser/storage` | 🧪 Tested | localStorage/sessionStorage |
| IndexedDB | - | 📅 Planned | Client-side database |

### Rendering & Media

| API | Package | Status | Note |
|-----|---------|--------|------|
| Canvas 2D | `mizchi/js/browser/canvas` | 🤖 AI Generated | Canvas rendering |
| CSS/Style | `mizchi/js/browser/dom` | 🧪 Tested | Style manipulation |
| WebGL | - | 📅 Planned | 3D graphics |
| AudioContext | - | 📅 Planned | Web Audio API |

### File & Blob APIs

| API | Package | Status | Note |
|-----|---------|--------|------|
| Blob | `mizchi/js/browser/blob` | 🤖 AI Generated | Binary data (also in web) |
| File | `mizchi/js/browser/file` | 🤖 AI Generated | File objects (also in web) |
| FileSystem | - | 📅 Planned | File System Access API |

### Observers

| API | Package | Status | Note |
|-----|---------|--------|------|
| Observer | `mizchi/js/browser/observer` | 🤖 AI Generated | MutationObserver, etc. |

### Service Workers

| API | Package | Status | Note |
|-----|---------|--------|------|
| ServiceWorker | - | 📅 Planned | Background workers |

### Status Legend

- 🧪 **Tested**: Comprehensive test coverage with JSDOM
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation

## Overview

This package provides comprehensive bindings to browser-specific APIs, including:

- **DOM**: Document, Element, Node, HTMLElement manipulation
- **Events**: Mouse, Keyboard, Pointer, Focus event handling
- **Browser Objects**: Window, Navigator
- **Storage**: localStorage, sessionStorage
- **Rendering**: Canvas 2D, CSS/Style manipulation
- **Observers**: MutationObserver, IntersectionObserver, ResizeObserver

All APIs are aligned with TypeScript's standard DOM type definitions and include MDN documentation links.

### See Also

- **[mizchi/js/web](../web/README.md)** - Platform-independent Web Standard APIs (fetch, Streams, WebSocket, etc.)
- **[mizchi/js/node](../node/README.md)** - Node.js-specific APIs
- **[mizchi/js/cloudflare](../cloudflare/README.md)** - Cloudflare Workers APIs
