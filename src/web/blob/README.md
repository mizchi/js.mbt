# mizchi/js/web/blob

Blob API for binary data handling.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/web/blob"
  ]
}
```

## Overview

Provides bindings for the Blob and File APIs, representing immutable binary data.

## Usage Example

```moonbit
fn main {
  // Create a Blob from string
  let blob = @blob.Blob::from_string("Hello, world!")
  
  // Get blob size
  let size = blob.size()
  
  // Get blob type
  let mime_type = blob.type_()
  
  // Slice a blob
  let slice = blob.slice(0, 5)
  
  // Create from array of parts
  let parts = ["part1", "part2"]
  let combined = @blob.Blob::from_array(parts)
}
```

## Available Types

- **Blob** - Immutable binary data
- **File** - Blob with name and metadata

## Reference

- [MDN: Blob](https://developer.mozilla.org/en-US/docs/Web/API/Blob)
- [MDN: File](https://developer.mozilla.org/en-US/docs/Web/API/File)
