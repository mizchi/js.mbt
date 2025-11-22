# mizchi/js/builtins/regexp

Regular expressions with JavaScript's RegExp API.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/builtins/regexp"
  ]
}
```

## Overview

Provides bindings for JavaScript's RegExp object for pattern matching and text manipulation.

## Usage Example

```moonbit
fn main {
  // Create a RegExp
  let pattern = @regexp.RegExp::new("\\d+", "g")
  
  // Test a string
  let matches = pattern.test("abc123")  // true
  
  // Execute pattern
  let result = pattern.exec("test123")
  
  // String methods with RegExp
  let text = "hello world"
  let replaced = text.replace(pattern, "***")
}
```

## Available Methods

- `test(string)` - Test if pattern matches
- `exec(string)` - Execute pattern and return match details
- Pattern properties: `source`, `flags`, `global`, `ignoreCase`, `multiline`

## Reference

- [MDN: RegExp](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp)
