# mizchi/js_builtin/date

Date and time manipulation with JavaScript's Date API.

## Installation

Add to your `moon.mod`:

```
import {
  "mizchi/js_builtin@0.13.0",
}
```

...and to the `moon.pkg` of the package that uses it:

```
import {
  "mizchi/js_builtin/date",
}
```

## Overview

Provides bindings for JavaScript's Date object for working with dates and times.

## Usage Example

```moonbit
fn main {
  // Create a new Date
  let now = @date.Date()
  
  // Get timestamp
  let timestamp = @date.Date::now()
  
  // Create from timestamp
  let date = @date.Date::from_time(1234567890000.0)
  
  // Get components
  let year = date.getFullYear()
  let month = date.getMonth()
  let day = date.getDate()
  
  // Convert to string
  let str = date.toISOString()
}
```

## Reference

- [MDN: Date](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date)
