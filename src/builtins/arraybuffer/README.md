# mizchi/js/builtins/typedarray

Binary data handling with ArrayBuffer and TypedArrays.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/builtins/typedarray"
  ]
}
```

## Overview

Provides bindings for JavaScript's binary data types:
- **ArrayBuffer** - Raw binary data buffer
- **TypedArrays** - Typed views over ArrayBuffer (Int8Array, Uint8Array, Float32Array, etc.)
- **DataView** - Low-level interface for reading/writing binary data

## Usage Example

```moonbit
fn main {
  // Create a Uint8Array
  let arr = @typedarray.Uint8Array::from_size(10)
  
  // Set values
  arr.set_at(0, 42)
  arr.set_at(1, 100)
  
  // Get values
  let value = arr.get_at(0) // 42
  
  // Byte operations
  let bytes = Bytes::new(10)
  let typed_arr = @typedarray.bytes_to_uint8array(bytes)
}
```

## Available Types

- `Int8Array`, `Uint8Array`, `Uint8ClampedArray`
- `Int16Array`, `Uint16Array`
- `Int32Array`, `Uint32Array`
- `BigInt64Array`, `BigUint64Array`
- `Float32Array`, `Float64Array`
- `ArrayBuffer`
- `DataView`

## Reference

- [MDN: TypedArray](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)
- [MDN: ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer)
