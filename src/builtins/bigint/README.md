# mizchi/js/builtins/bigint

Arbitrary-precision integers with JavaScript's BigInt.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/builtins/bigint"
  ]
}
```

## Overview

Provides bindings for JavaScript's BigInt for working with arbitrarily large integers.

## Usage Example

```moonbit
fn main {
  // Create BigInt from string
  let big = @bigint.JsBigInt::from_string("9007199254740991")
  
  // Create from Int64
  let big2 = @bigint.JsBigInt::from_int64(123L)
  
  // Convert to string
  let str = big.to_string()
  
  // Note: Use JavaScript operators via FFI for arithmetic
}
```

## Reference

- [MDN: BigInt](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt)
