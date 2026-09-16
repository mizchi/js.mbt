# mizchi/js_node/module

## node:module

Module system APIs

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_node@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_node/module",
}
```

### Module
- [x] Module type
- [x] createRequire(filename) - Create require function
- [x] builtinModules - Array of built-in module names
- [x] syncBuiltinESMExports() - Sync built-in ES module exports

### Module Resolution
- [x] Module::createRequire(filename) - Create require from path
- [x] Module::wrap(script) - Wrap script in module wrapper
- [x] Module::runMain() - Run main module

## Usage
Provides access to Node.js module system internals.
