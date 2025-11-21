# Pending Tasks - Post-Release Improvements

## Medium Priority: Post-Release

### Node.js FS Type Refinement
- [ ] Change `statSync(String) -> @js.Js` to return a `Stats` struct
- [ ] Define `Stats` struct with fields: `isFile`, `isDirectory`, `size`, `mtime`, etc.

**Status**: Deferred until after initial release. Current `@js.Js` return type provides sufficient flexibility for most use cases.

## Refactoring Tasks (Post-Release)

### Coding Convention Standardization

1. **`#alias` Consistency**
   - Always use snake_case for `#alias` names
   - Implementation should use the original JavaScript function name
   - Example: `#alias(create_element)` + `fn createElement(...)`

2. **Function Naming Conventions**
   - Web Standard APIs: Use camelCase (JavaScript convention)
   - MoonBit-specific wrappers: Use snake_case

3. **Documentation Links**
   - Web Standard APIs: Include MDN reference links
   - Node.js modules: Include links to official Node.js documentation

4. **Type Declaration Optimization**
   - Review `#external pub type` declarations
   - Convert to `pub(all) struct` when the type meets these criteria:
     - Not constructed from MoonBit side
     - Primarily consists of simple getters
   - Examples: `DOMRect`, `DOMRectReadOnly`

## Completed Tasks ✅

- ✅ `src/console/` - Accept `&JsImpl` instead of `@js.Js`
- ✅ `src/crypto/` - Remove redundant `.to_js()` calls in SubtleCrypto methods
- ✅ `src/http/` - Change `Response::json_(@js.Js)` to accept `&JsImpl`
- ✅ `src/dom/` - Return concrete types (Element, DocumentFragment, Node) instead of `@js.Js`
- ✅ `src/websocket/` - Use concrete types for properties and event helpers
- ✅ Package reorganization - Extract web standard APIs to `src/web/*`
- ✅ Documentation updates - Reflect new package structure across all READMEs

## Notes

- The goal is to improve type safety while maintaining JavaScript interoperability
- Avoid over-constraining types that need flexibility (e.g., Stream options)
- All changes should pass `moon test` before committing
- Type refinement decisions documented in `src/examples/js_ffi.mbt.md`
