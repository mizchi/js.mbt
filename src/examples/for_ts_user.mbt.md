# MoonBit for TypeScript Users

This guide helps TypeScript developers understand MoonBit language features through comparisons and examples.

## Basic Functions

Functions in MoonBit are similar to TypeScript but with explicit type annotations:

```moonbit
// MoonBit function
///|
fn add(a : Int, b : Int) -> Int {
  a + b
}

///|
test "basic function" {
  assert_eq(add(2, 3), 5)
}
```

**TypeScript equivalent:**
```typescript
function add(a: number, b: number): number {
  return a + b
}
```

## Option Types and Guard Statements

MoonBit uses `Option[T]` (like TypeScript's `T | null`) and has a special `guard` statement for early returns:

```moonbit
///|
test "guard and option types" {
  let opt_value : Int? = Some(10) // Int? is shorthand for Option[Int]

  // Guard statement for early return
  guard opt_value is Some(v) else {
    inspect("No value")
    return
  }
  // `v` is bound and available after guard
  assert_eq(v, 10)

  // Guard without else panics if condition fails
  guard opt_value is Some(n) && n > 5
  assert_eq(n, 10)
}
```

**TypeScript equivalent:**
```typescript
const optValue: number | null = 10
if (optValue === null) {
  console.log("No value")
  return
}
const v = optValue
```

## Structs

Structs are like TypeScript interfaces/classes with auto-implemented traits:

```moonbit
///|
struct Point {
  x : Int
  y : Int
} derive(Eq, Show)

///|
fn Point::new(x : Int, y : Int) -> Self {
  Point::{ x, y }
}

///|
fn Point::to_tuple(self : Self) -> (Int, Int) {
  (self.x, self.y)
}

///|
test "struct usage" {
  let p1 = Point::new(10, 20)
  assert_eq(p1, Point::{ x: 10, y: 20 })

  // Struct update syntax
  let p2 : Point = { ..p1, y: 30 }

  // Destructuring
  let { y, .. } = p2
  assert_eq(y, 30)
  let (x, _y) = p2.to_tuple()
  assert_eq(x, 10)
}
```

**TypeScript equivalent:**
```typescript
interface Point {
  x: number
  y: number
}

function newPoint(x: number, y: number): Point {
  return { x, y }
}

const p1 = newPoint(10, 20)
const p2 = { ...p1, y: 30 }
const { y } = p2
```

## Enums (Tagged Unions)

Enums are like TypeScript discriminated unions:

```moonbit
///|
test "enum types" {
  enum Color {
    Red
    Green
    Blue
    Rgb(r~ : Int, g~ : Int, b~ : Int)
  } derive(Eq, Show)
  let c1 = Color::Red
  let c2 = Color::Green
  let c3 = Color::Rgb(r=255, g=0, b=0)
  assert_not_eq(c1, c2)
  assert_eq(c3, Color::Rgb(r=255, g=0, b=0))
}
```

**TypeScript equivalent:**
```typescript
type Color = 
  | { type: 'Red' }
  | { type: 'Green' }
  | { type: 'Blue' }
  | { type: 'Rgb', r: number, g: number, b: number }

const c1: Color = { type: 'Red' }
const c2: Color = { type: 'Green' }
const c3: Color = { type: 'Rgb', r: 255, g: 0, b: 0 }
```

## Pattern Matching

MoonBit has powerful pattern matching, including for JSON:

```moonbit
///|
test "pattern matching with json" {
  let json : Json = { "message": "Test", "value": [10, 2, 30] }
  match json {
    {
      "message": String(message),
      "value": [Number(a, ..), 2, Number(c, ..), .. _rest],
      ..
    } => {
      assert_eq(message, "Test")
      assert_eq(a, 10)
      assert_eq(c, 30)
    }
    _ => fail("Pattern did not match")
  }
}
```

**TypeScript equivalent:**
```typescript
const json = { message: "Test", value: [10, 2, 30] }
if (json.message === "Test" && 
    Array.isArray(json.value) && 
    json.value[1] === 2) {
  const message = json.message
  const a = json.value[0]
  const c = json.value[2]
}
```

## Named and Optional Parameters

MoonBit supports named parameters with `~` and optional parameters with `?`:

```moonbit
// Named parameters (required)
///|
fn param_func(a~ : Int, b~ : Int) -> (Int, Int) {
  (a, b)
}

// Optional parameters with defaults

///|
fn param_func2(a? : Int = 1, b? : Int) -> (Int, Int) {
  (a, b.unwrap_or(-1))
}

///|
test "parameter styles" {
  // Named parameters
  let result1 = param_func(a=10, b=20)
  assert_eq(result1, (10, 20))

  // Optional parameters
  let result2 = param_func2()
  assert_eq(result2, (1, -1))
  let result3 = param_func2(a=5, b=15)
  assert_eq(result3, (5, 15))
}
```

**TypeScript equivalent:**
```typescript
function paramFunc({ a, b }: { a: number, b: number }) {
  return [a, b]
}

function paramFunc2({ a = 1, b }: { a?: number, b?: number } = {}) {
  return [a, b ?? -1]
}
```

## Error Handling

MoonBit has explicit error handling with `raise` and `try/catch`:

```moonbit
///|
test "error handling" {
  // Function that can raise errors
  let divide = fn(x : Int) -> Int raise {
    if x == 0 {
      fail("Division by zero")
    } else {
      10 / x
    }
  }

  // Try-catch expression
  let result1 = divide(0) catch {
    Failure(msg) => {
      // Check that error message contains expected text
      assert_true(msg.contains("Division by zero"))
      assert_true(msg.contains("FAILED"))
      -1
    }
    _ => -1
  }
  assert_eq(result1, -1)

  // Safe division
  let result2 = divide(2) catch { _ => -1 }
  assert_eq(result2, 5)
}
```

**TypeScript equivalent:**
```typescript
function divide(x: number): number {
  if (x === 0) {
    throw new Error("Division by zero")
  }
  return 10 / x
}

try {
  const result = divide(0)
} catch (e) {
  console.log(e.message)
}
```

## Custom Error Types

Define custom error types with `suberror`:

```moonbit
///|
suberror MyError

///|
test "custom errors" {
  let risky_operation = fn() -> Int raise MyError { raise MyError }
  let result = risky_operation() catch {
    MyError => {
      inspect("Caught MyError", content="Caught MyError")
      -1
    }
  }
  assert_eq(result, -1)
}
```

## Key Differences from TypeScript

### 1. **Immutability by Default**
MoonBit variables are immutable unless explicitly marked as mutable:

```moonbit
///|
test "mutability" {
  let x = 10 // immutable
  // x = 20  // ERROR: cannot reassign

  let mut y = 10 // mutable
  y = 20 // OK
  assert_eq(y, 20)
}
```

### 2. **No Null or Undefined**
Use `Option[T]` instead:

```moonbit
///|
test "no null" {
  let value : Int? = Some(42)
  let empty : Int? = None
  assert_eq(value.unwrap_or(0), 42)
  assert_eq(empty.unwrap_or(0), 0)
}
```

### 3. **Type Inference**
MoonBit has strong type inference:

```moonbit
///|
test "type inference" {
  let x = 42 // inferred as Int
  let y = "hello" // inferred as String
  let z = [1, 2, 3] // inferred as Array[Int]
  assert_eq(x, 42)
  assert_eq(y, "hello")
  assert_eq(z.length(), 3)
}
```

### 4. **Expression-Based**
Everything is an expression in MoonBit:

```moonbit
///|
test "expressions" {
  let result = if true { 10 } else { 20 }
  assert_eq(result, 10)
  let value = {
    let x = 5
    let y = 10
    x +
    y // last expression is returned
  }
  assert_eq(value, 15)
}
```

### 5. **Tuple Types**
Native tuple support:

```moonbit
///|
test "tuples" {
  let pair : (Int, String) = (42, "answer")
  let (num, text) = pair
  assert_eq(num, 42)
  assert_eq(text, "answer")

  // Nested tuples
  let nested : ((Int, Int), String) = ((1, 2), "test")
  let ((a, b), c) = nested
  assert_eq(a, 1)
  assert_eq(b, 2)
  assert_eq(c, "test")
}
```

## Summary

MoonBit offers TypeScript developers:
- **Stronger type safety** with no `null`/`undefined`
- **Algebraic data types** (enums, pattern matching)
- **Explicit error handling** with `raise`
- **Immutability by default**
- **Powerful type inference**
- **Expression-based syntax**

For JavaScript/TypeScript FFI, see `js_examples.mbt.md` in this directory.
