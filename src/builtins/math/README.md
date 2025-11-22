# mizchi/js/builtins/math

Mathematical operations with JavaScript's Math API.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/builtins/math"
  ]
}
```

## Overview

Provides bindings for JavaScript's Math object for mathematical operations and constants.

## Usage Example

```moonbit
fn main {
  // Basic operations
  let abs_val = @math.abs(-5.5)        // 5.5
  let rounded = @math.round(3.7)       // 4.0
  let power = @math.pow(2.0, 3.0)      // 8.0
  
  // Trigonometry
  let sine = @math.sin(0.0)            // 0.0
  let cosine = @math.cos(0.0)          // 1.0
  
  // Random
  let random = @math.random()          // 0.0 <= x < 1.0
  
  // Constants
  let pi = @math.PI
  let e = @math.E
}
```

## Available Functions

- Rounding: `abs`, `ceil`, `floor`, `round`, `trunc`
- Power/Roots: `pow`, `sqrt`, `cbrt`, `exp`, `log`
- Trigonometry: `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2`
- Min/Max: `min`, `max`
- Random: `random`

## Reference

- [MDN: Math](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math)
