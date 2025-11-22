# TODO

## Future Improvements

### API Enhancements

- [ ] **Add comprehensive tests for AI-generated bindings**
  - SubtleCrypto cryptographic operations
  - Worker and MessageChannel APIs
  - WebAssembly integration

### Documentation

- [ ] **Add more usage examples**
  - Complex web application patterns
  - Server-side rendering with React
  - Edge computing best practices

### Type System Improvements

- [ ] **Wait for MoonBit language support for Option fields in FFI structs**
  - Currently using `@js.Nullable[T]` as a workaround
  - Native Option support would provide better ergonomics

### Platform Support

- [ ] **Expand Deno API coverage**
  - Currently using Node.js APIs as fallback
  - Add Deno-specific APIs when stable

- [ ] **MCP (Model Context Protocol) support**
  - Server implementation
  - Client bindings

### Performance

- [ ] **Benchmark and optimize hot paths**
  - FFI call overhead measurement
  - Identify optimization opportunities
