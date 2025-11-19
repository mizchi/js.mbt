# mizchi/js/node/path

## node:path

File path manipulation utilities

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/node/path"
  ]
}
```

### Functions
- [x] basename(path, ext?) - Get filename from path
- [x] dirname(path) - Get directory name
- [x] extname(path) - Get file extension
- [x] format(pathObject) - Format path from object
- [x] isAbsolute(path) - Check if path is absolute
- [x] join(paths...) - Join path segments
- [x] normalize(path) - Normalize path
- [x] parse(path) - Parse path into object
- [x] relative(from, to) - Get relative path
- [x] resolve(paths...) - Resolve to absolute path
- [x] toNamespacedPath(path) - Convert to namespaced path (Windows)

### Platform-specific
- [x] sep - Path segment separator
- [x] delimiter - Path delimiter
- [x] win32 - Windows-specific path methods
- [x] posix - POSIX-specific path methods
