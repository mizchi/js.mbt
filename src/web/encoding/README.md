# mizchi/js/web/encoding

Text encoding and decoding API (TextEncoder, TextDecoder).

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/web/encoding"
  ]
}
```

## Overview

Provides bindings for encoding and decoding text between strings and binary data.

## Usage Example

```moonbit
fn main {
  // Encode string to bytes
  let encoder = @encoding.TextEncoder::new()
  let bytes = encoder.encode("Hello, world!")
  
  // Decode bytes to string
  let decoder = @encoding.TextDecoder::new()
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
