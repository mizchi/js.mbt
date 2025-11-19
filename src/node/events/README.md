# mizchi/js/node/events

## node:events

Event emitter implementation

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/promise",
    "mizchi/js/node/events"
  ]
}
```

### EventEmitter Class
- [x] EventEmitter type
- [x] EventEmitter::new() - Create new emitter
- [x] on(event, listener) - Add listener
- [x] once(event, listener) - Add one-time listener
- [x] off(event, listener) - Remove listener
- [x] emit(event, args) - Emit event
- [x] removeAllListeners(event?) - Remove all listeners
- [x] listenerCount(event) - Get listener count
- [x] eventNames() - Get array of event names

### EventEmitterImpl Trait
- [x] EventEmitterImpl trait for types that wrap EventEmitter
  - Provides: on, on2, once, off, removeListener, emit, removeAllListeners, listenerCount, listeners, eventNames

## Usage
Types can implement EventEmitterImpl to get event emitter functionality:
- ChildProcess
- Server
- Socket
- Stream types (Readable, Writable, etc.)
