# mizchi/js/browser/dom

DOM API bindings for MoonBit, providing type-safe access to browser DOM operations.

## DOM API Support Status

| API | Package | Status | Note |
|-----|---------|--------|------|
| Document | `mizchi/js/browser/dom` | ✅ Tested | DOM manipulation |
| Element | `mizchi/js/browser/dom` | ✅ Tested | Element operations |
| Node | `mizchi/js/browser/dom` | ✅ Tested | Node interface |
| HTMLElement | `mizchi/js/browser/dom` | ✅ Tested | HTML elements |
| Event | `mizchi/js/browser/event` | ✅ Tested | Event handling |
| MouseEvent | `mizchi/js/browser/event` | ✅ Tested | Mouse events |
| KeyboardEvent | `mizchi/js/browser/event` | ✅ Tested | Keyboard events |
| PointerEvent | `mizchi/js/browser/event` | ✅ Tested | Pointer events |
| FocusEvent | `mizchi/js/browser/event` | ✅ Tested | Focus events |
| CustomEvent | `mizchi/js/browser/dom` | ✅ Tested | Custom events |
| Text | `mizchi/js/browser/dom` | ✅ Tested | Text nodes |
| Window | `mizchi/js/browser/dom` | ✅ Tested | Window object |
| Navigator | `mizchi/js/browser/dom` | ✅ Tested | Browser info |
| CSS/Style | `mizchi/js/browser/dom` | ✅ Tested | Style manipulation |
| Storage | `mizchi/js/browser/storage` | ✅ Tested | localStorage/sessionStorage |
| Canvas 2D | `mizchi/js/browser/canvas` | 🤖 AI Generated | Canvas rendering |
| Blob | `mizchi/js/browser/blob` | 🤖 AI Generated | Blob handling |
| File | `mizchi/js/browser/file` | 🤖 AI Generated | File operations |
| Observer | `mizchi/js/browser/observer` | 🤖 AI Generated | MutationObserver, etc. |
| ShadowDOM | `mizchi/js/browser/dom` | 🤖 AI Generated | Shadow DOM |
| IndexedDB | - | 📅 Planned | Client-side database |
| ServiceWorker | - | 📅 Planned | Background workers |
| FileSystem | - | 📅 Planned | File System Access API |
| WebGL | - | 📅 Planned | 3D graphics |
| AudioContext | - | 📅 Planned | Web Audio API |

### Status Legend

- ✅ **Tested**: Comprehensive test coverage with JSDOM
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation

## Overview

This package provides comprehensive bindings to the Web DOM API, including:

- **Document**: Document object methods and properties
- **Element**: Element manipulation, attributes, and DOM traversal
- **Event**: Event handling (Mouse, Keyboard, Pointer, Focus, etc.)
- **Node**: Node interface operations
- **Navigator**: Browser information and capabilities
- **Style**: CSS style manipulation

All APIs are aligned with TypeScript's standard DOM type definitions and include MDN documentation links.
