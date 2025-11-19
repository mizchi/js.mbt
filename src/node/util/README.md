# mizchi/js/node/util

## node:util

Utility functions

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/node/util"
  ]
}
```

### Implemented APIs

#### Text Formatting
- [x] inspect(value, options?) - Return string representation of value
  - Options: depth, colors, compact, sorted, breakLength, maxArrayLength, maxStringLength

#### Argument Parsing
- [x] parseArgs(args, options, allowPositionals?) - Parse command line arguments
  - ParseArgsOption enum: Boolean(key, short), String(key, short, multiple, default)
  - Returns: ParseArgsResult with values, positionals, tokens

### Types
- [x] Util - Main utility type
- [x] ParseArgsOption - Argument option configuration
- [x] ParseArgsResult - Parse result structure

## Test Coverage
- Tests in src/node/util/inspect_test.mbt
- Tests in src/node/util/parse_args_test.mbt
