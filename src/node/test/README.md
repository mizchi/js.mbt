# @mizchi/js/node/test

MoonBit bindings for Node.js `node:test` module - the native test runner.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    {
      "alias": "nodetest",
      "path": "mizchi/js/node/test"
    }
  ]
}
```

## API

### Test Definition Functions

#### Core Test Functions
- `test_(name, skip?, todo?, only?, timeout?, fn)` - Define a test case (note: `test` is reserved keyword in MoonBit)
- `test_skip(name, fn)` - Skip a test
- `test_todo(name, fn?)` - Mark test as TODO
- `test_only(name, fn)` - Run only this test

#### BDD-Style Aliases
- `it(name, skip?, fn)` - Alias for test() with BDD style
- `describe(name, skip?, todo?, only?, fn)` - Group related tests
- `describe_skip(name, fn)` - Skip a test suite
- `describe_todo(name, fn?)` - Mark suite as TODO
- `describe_only(name, fn)` - Run only this suite

### Lifecycle Hooks

- `before(fn, timeout?)` - Run once before suite tests
- `after(fn, timeout?)` - Run once after suite completion
- `beforeEach(fn, timeout?)` - Run before each test
- `afterEach(fn, timeout?)` - Run after each test

#### Aliases
- `beforeAll(fn)` - Alias for `before()`
- `afterAll(fn)` - Alias for `after()`

### TestContext Methods

- `skip(message?)` - Skip the current test
- `todo(message?)` - Mark current test as TODO
- `diagnostic(message)` - Output diagnostic information
- `plan(count)` - Declare expected assertion count
- `runOnly(shouldRunOnlyTests)` - Toggle execution of only-marked subtests

### Snapshot Testing

- `TestContext::assert_snapshot(value, message?)` - Compare value against stored snapshot
- `TestContext::assert_fileSnapshot(value, path, message?)` - File-based snapshot comparison
- `setDefaultSnapshotSerializers(serializers)` - Customize snapshot serialization
- `setResolveSnapshotPath(fn)` - Custom snapshot file location

### Mock APIs

#### MockTracker
- `mock()` - Get the global mock tracker
- `MockTracker::fn_(original?, implementation?)` - Create spy/mock function
- `MockTracker::method_(object, methodName, implementation?)` - Mock object method
- `MockTracker::getter_(object, methodName, implementation?)` - Mock property getter
- `MockTracker::setter_(object, methodName, implementation?)` - Mock property setter
- `MockTracker::module_(specifier, defaultExport?, namedExports?)` - Mock module imports
- `MockTracker::property_(object, propertyName, value?)` - Mock property value
- `MockTracker::reset()` - Clear all tracked mock calls
- `MockTracker::restoreAll()` - Restore original implementations

#### MockFunctionContext
- `MockFunctionContext::calls()` - Get array of call records
- `MockFunctionContext::callCount()` - Get invocation count
- `MockFunctionContext::mockImplementation(implementation)` - Change mock behavior
- `MockFunctionContext::mockImplementationOnce(implementation, onCall?)` - Set behavior for single call
- `MockFunctionContext::resetCalls()` - Clear call history
- `MockFunctionContext::restore()` - Revert to original implementation
- `get_mock_context(func)` - Get mock context from mocked function

### Timer Mocking

- `mock_timers()` - Get the mock.timers object
- `MockTimers::enable(apis?, now?)` - Enable timer mocking
- `MockTimers::tick(milliseconds)` - Advance mocked time
- `MockTimers::runAll()` - Execute all queued timers
- `MockTimers::reset()` - Clear timer queue
- `MockTimers::setTime(milliseconds)` - Set absolute time

### Test Runner

- `run(files?, cwd?, forceExit?, ...)` - Run tests programmatically with extensive options

## Types

- `TestContext` - Test execution context
- `SuiteContext` - Suite execution context
- `MockTracker` - Mock management
- `MockFunctionContext` - Mock function control
- `MockTimers` - Timer mocking control

## Example

### Synchronous vs Asynchronous Tests

MoonBit supports both traditional synchronous tests and modern asynchronous tests:

```moonbit
using @nodetest {it, describe}
// Before: Synchronous test with callbacks
test {
  it("test-case", () => {
    // test logic
  })
}

// After: Asynchronous test (recommended)
async test "test-case" {
  // async test logic with await support
}
```

### Basic Examples

```moonbit
using @nodetest {it, before, afterEach, describe, mock, get_mock_context}

test "basic test" {
  it("addition works", _ => {
    assert_eq(2 + 2, 4)
  })

  it("todo test", ctx => {
    ctx.todo(message="implement later")
  })
}

test "with hooks" {
  before(() => {
    println("setup")
  })

  afterEach(() => {
    println("cleanup")
  })

  describe("math operations", _ => {
    it("multiplication", _ => {
      assert_eq(3 * 4, 12)
    })
  })
}

test "mocking example" {
  it("mock function", _ => {
    let m = mock()
    let fn = m.fn_()
    let ctx = get_mock_context(fn)

    fn._invoke([])
    assert_eq(ctx.callCount(), 1)
  })
}
```

## Usage

This package is used extensively in test files under `src/_tests/`. It provides a complete implementation of Node.js's native test runner for MoonBit.
