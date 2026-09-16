# mizchi/js_web/encoding

Text encoding and decoding API (TextEncoder, TextDecoder).

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_web@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_web/encoding",
}
```

## Overview

Provides bindings for encoding and decoding text between strings and binary data.

## Usage Example

```moonbit
fn main {
  // Encode string to bytes
  let encoder = @encoding.TextEncoder()
  let bytes = encoder.encode("Hello, world!")
  
  // Decode bytes to string
  let decoder = @encoding.TextDecoder()
  let text = decoder.decode(bytes)
  
  // Decode with specific encoding
  let decoder_utf8 = @encoding.TextDecoder::new_with_encoding("utf-8")
}
```

## Available Types

- **TextEncoder** - Encode strings to UTF-8 bytes
- **TextDecoder** - Decode bytes to strings (supports various encodings)

## Reference

- [MDN: TextEncoder](https://developer.mozilla.org/en-US/docs/Web/API/TextEncoder)
- [MDN: TextDecoder](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoder)
