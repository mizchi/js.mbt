# mizchi/js/node/test

## node:test

Node.js native test runner APIs

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/node/test"
  ]
}
```

### Implemented APIs

#### Test Functions
- [x] it(name, fn) - Define a test (BDD style)
- [x] beforeAll(fn) - Run before all tests
- [x] afterAll(fn) - Run after all tests
- [x] beforeEach(fn) - Run before each test
- [x] afterEach(fn) - Run after each test

#### Test Context
- [x] TestContext type
- [x] todo(message) - Mark test as TODO

#### Test Runner
- [x] run(options?) - Run tests programmatically
  - Options: files, testNamePatterns, timeout, concurrency, watch

#### Mock APIs
- [x] MockTracker type
- [x] mock() - Create mock tracker
- [x] fn_(original?, options?) - Create mock function
- [x] method_(object, methodName, implementation?, options?) - Mock method
- [x] getter_(object, propertyName, implementation?, options?) - Mock getter
- [x] setter_(object, propertyName, implementation?, options?) - Mock setter
- [x] reset() - Reset all mocks
- [x] restoreAll() - Restore all mocked functions

#### Mock Function Context
- [x] MockFunctionContext type
- [x] calls() - Get array of call records
- [x] callCount() - Get number of calls
- [x] mockImplementation(fn) - Set implementation
- [x] mockImplementationOnce(fn) - Set one-time implementation
- [x] resetCalls() - Reset call history
- [x] restore() - Restore original function

### Types
- [x] TestContext - Test execution context
- [x] MockTracker - Mock management
- [x] MockFunctionContext - Mock function control

## Usage
This package is used extensively in test files under `src/_tests/`

## Test Coverage
- Tests in src/node/test/mock_test.mbt
- Used in all async test files in src/_tests/
