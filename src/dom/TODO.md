# DOM API TODO

This document tracks remaining tasks and future improvements for the DOM API bindings.

## Completed ✅

- [x] Add more event types (TouchEvent, ClipboardEvent, TransitionEvent, AnimationEvent, WheelEvent, ScrollEvent)
- [x] HTMLElement-specific properties (contentEditable, hidden, tabIndex, draggable, spellcheck, offset properties, etc.)
- [x] MutationObserver bindings
- [x] IntersectionObserver bindings
- [x] ResizeObserver bindings
- [x] Shadow DOM support (ShadowRoot, attachShadow, slots)
- [x] Custom Elements support (CustomElementRegistry, define, get, whenDefined)
- [x] CSS Object Model (CSSStyleDeclaration, CSSRule, CSSStyleSheet)
- [x] MediaQueryList and matchMedia
- [x] CSS helper functions (CSS.escape, CSS.supports)

## In Progress 🚧

None

## Planned Features 📋

### High Priority

- [ ] **DataTransfer API** - Full clipboard and drag-and-drop data transfer
  - DataTransfer object methods
  - DataTransferItem and DataTransferItemList
  - File handling in drag events

- [ ] **Selection API** - Text selection and ranges
  - Selection object
  - Range object
  - Selection manipulation methods

- [ ] **History API** - Browser history manipulation
  - pushState, replaceState
  - popstate event
  - History navigation

- [ ] **Location API** - URL manipulation
  - Location object properties
  - Navigation methods
  - Hash change events

- [ ] **Performance API** - Performance monitoring
  - PerformanceObserver
  - PerformanceEntry types
  - Navigation timing
  - Resource timing

### Medium Priority

- [ ] **WebGL/Canvas APIs** - Graphics rendering
  - HTMLCanvasElement methods
  - CanvasRenderingContext2D
  - WebGLRenderingContext
  - OffscreenCanvas

- [ ] **WebSocket API** - Real-time communication
  - WebSocket constructor
  - Connection states
  - Message sending/receiving
  - Event handlers

- [ ] **File API** - File handling
  - File object
  - FileReader
  - Blob operations
  - URL.createObjectURL

- [ ] **IndexedDB API** - Client-side storage
  - IDBFactory
  - IDBDatabase
  - IDBTransaction
  - IDBObjectStore

- [ ] **Fetch enhancements** - More complete fetch API
  - Request/Response types
  - Headers manipulation
  - Stream handling
  - AbortController

### Low Priority

- [ ] **Notification API** - Push notifications
  - Notification constructor
  - Permission requests
  - Notification events

- [ ] **Geolocation API** - Location services
  - getCurrentPosition
  - watchPosition
  - Position object

- [ ] **Web Audio API** - Audio processing
  - AudioContext
  - Audio nodes
  - Audio processing graph

- [ ] **WebRTC API** - Peer-to-peer communication
  - RTCPeerConnection
  - MediaStream
  - Data channels

- [ ] **Service Worker API** - Offline capabilities
  - ServiceWorker registration
  - Cache API
  - Background sync

- [ ] **Web Workers** - Background threads
  - Worker constructor
  - Message passing
  - Shared workers

## Type System Improvements 🔧

- [ ] **Stricter Event Types** - Better event type checking
  - Event type discrimination
  - Type-safe event listeners
  - Generic event handlers

- [ ] **CSS Type Safety** - Type-safe CSS manipulation
  - CSS property enums
  - CSS value types
  - CSS unit types

- [ ] **DOM Type Hierarchy** - Proper type inheritance
  - EventTarget base type
  - Node inheritance chain
  - Element specializations (HTMLElement, SVGElement)

## Testing Improvements 🧪

- [ ] **Browser-specific Tests** - Test in actual browsers
  - Chrome/Edge tests
  - Firefox tests
  - Safari tests
  - Cross-browser compatibility

- [ ] **Performance Tests** - Benchmark critical operations
  - DOM manipulation performance
  - Event handling overhead
  - Observer callback performance

- [ ] **Integration Tests** - Real-world usage scenarios
  - Complex DOM manipulation
  - Event delegation patterns
  - Shadow DOM with slots

## Documentation Enhancements 📚

- [ ] **Migration Guides** - Help users upgrade
  - Breaking changes by version
  - Upgrade paths
  - Common patterns

- [ ] **Best Practices** - Usage recommendations
  - Performance tips
  - Memory management
  - Common pitfalls

- [ ] **Examples** - More real-world examples
  - Form handling
  - Dynamic content
  - Animation
  - Component patterns

## Known Limitations ⚠️

### JSDOM Limitations
The following APIs are not fully supported in JSDOM (used for testing):
- IntersectionObserver (constructor not available)
- ResizeObserver (constructor not available)
- matchMedia (method not available)
- CSS.supports (not available)
- Touch events (limited support)
- Geolocation (not available)

These APIs are implemented and work in real browsers but may have limited test coverage.

### Browser Compatibility
Some newer APIs may not be available in older browsers:
- ResizeObserver (not in IE11)
- IntersectionObserver (polyfill needed for IE11)
- Custom Elements v1 (not in IE11)
- Shadow DOM v1 (not in IE11)

## Contributing 🤝

When implementing new features:
1. Add TypeScript type definitions as reference
2. Include MDN documentation links
3. Write comprehensive tests (skip JSDOM-unsupported features)
4. Update this TODO list
5. Add usage examples to README.md

## Notes 📝

- Prioritize APIs that are widely used in modern web development
- Focus on type safety and ergonomic APIs
- Maintain backward compatibility when possible
- Document breaking changes clearly
- Keep tests maintainable and fast
