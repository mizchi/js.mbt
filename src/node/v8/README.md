# mizchi/js/node/v8

## node:v8

V8 engine specific APIs

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/node/v8"
  ]
}
```

### Heap Statistics
- [x] getHeapStatistics() - Get heap statistics
- [x] getHeapSpaceStatistics() - Get heap space statistics
- [x] getHeapSnapshot() - Get heap snapshot
- [x] getHeapCodeStatistics() - Get heap code statistics

### Serialization
- [x] serialize(value) - Serialize value to buffer
- [x] deserialize(buffer) - Deserialize buffer to value
- [x] Serializer - Custom serialization
- [x] Deserializer - Custom deserialization

### Other
- [x] setFlagsFromString(flags) - Set V8 flags
- [x] cachedDataVersionTag() - Get cached data version tag
- [x] writeHeapSnapshot(filename?) - Write heap snapshot to file

## Usage
These APIs provide access to V8 engine internals for debugging and optimization.
