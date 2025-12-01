# @mizchi/js/node/assert

MoonBit bindings for Node.js `assert` module.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/node/assert"
  ]
}
```

## API

### Basic Assertions

- `ok(value: Bool, message?: String) -> Unit` - Assert that a value is truthy
- `equal(actual: &JsImpl, expected: &JsImpl, message?: String) -> Unit` - Assert equality (==)
- `notEqual(actual: &JsImpl, expected: &JsImpl, message?: String) -> Unit` - Assert inequality (!=)
- `deepEqual(actual: &JsImpl, expected: &JsImpl, message?: String) -> Unit` - Assert deep equality
- `notDeepEqual(actual: &JsImpl, expected: &JsImpl, message?: String) -> Unit` - Assert deep inequality
- `strictEqual(actual: &JsImpl, expected: &JsImpl, message?: String) -> Unit` - Assert strict equality (===)
- `notStrictEqual(actual: &JsImpl, expected: &JsImpl, message?: String) -> Unit` - Assert strict inequality (!==)

### Error Assertions

- `throws(fn: () -> Unit, message?: String) -> Unit` - Assert that a function throws
- `doesNotThrow(fn: () -> Unit, message?: String) -> Unit` - Assert that a function does not throw
- `rejects(promise: &JsImpl, error?: &JsImpl, message?: String) -> Promise[Unit]` - Assert that a promise rejects
- `doesNotReject(promise: &JsImpl, message?: String) -> Promise[Unit]` - Assert that a promise does not reject

### Other Assertions

- `fail(message?: String) -> Unit` - Always fails
- `match_(actual: String, regexp: String, message?: String) -> Unit` - Assert regex match
- `doesNotMatch(actual: String, regexp: String, message?: String) -> Unit` - Assert regex does not match
- `instanceOf(value: &JsImpl, constructor: &JsImpl, message?: String) -> Unit` - Assert that value is instance of constructor
- `notInstanceOf(value: &JsImpl, constructor: &JsImpl, message?: String) -> Unit` - Assert that value is not instance of constructor

## Example

```moonbit
test "basic assertions" {
  @assert.ok(true)
  @assert.equal(@nostd.any(42), @nostd.any(42))
  @assert.strictEqual(@nostd.any("hello"), @nostd.any("hello"))
}

test "error assertions" {
  @assert.throws(fn() {
    @js.throw_("error")
    ()
  })
  
  @assert.doesNotThrow(fn() {
    ()
  })
}

test "pattern matching" {
  @assert.match_("hello world", "hello")
  @assert.doesNotMatch("hello", "\\d+")
}
```
