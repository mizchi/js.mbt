# mizchi/js/node/test

## node:test

Node.js native test runner APIs

### Test Functions
- [x] test(name, options?, fn) - Define a test
- [x] it(name, options?, fn) - Alias for test (BDD style)
- [x] describe(name, options?, fn) - Group tests (suite)
- [x] before(fn, options?) - Run before all tests
- [x] after(fn, options?) - Run after all tests
- [x] beforeEach(fn, options?) - Run before each test
- [x] afterEach(fn, options?) - Run after each test

### Test Context
- [x] TestContext type
- [x] name - Test name
- [x] skip(message?) - Skip test
- [x] todo(message?) - Mark as TODO
- [x] diagnostic(message) - Output diagnostic info

### Assertions (from node:assert)
- [x] ok(value, message?) - Assert truthy
- [x] equal(actual, expected, message?) - Shallow equality
- [x] notEqual(actual, expected, message?) - Shallow inequality
- [x] deepEqual(actual, expected, message?) - Deep equality
- [x] notDeepEqual(actual, expected, message?) - Deep inequality
- [x] strictEqual(actual, expected, message?) - Strict equality
- [x] notStrictEqual(actual, expected, message?) - Strict inequality
- [x] throws(fn, error?, message?) - Assert throws
- [x] doesNotThrow(fn, message?) - Assert doesn't throw
- [x] rejects(promise, error?, message?) - Assert promise rejects
- [x] doesNotReject(promise, message?) - Assert promise doesn't reject
- [x] fail(message?) - Force failure
- [x] match(actual, regexp, message?) - Assert regex match
- [x] doesNotMatch(actual, regexp, message?) - Assert regex doesn't match

### Mock APIs (Experimental)
- [x] MockTracker type
- [x] mock(fn) - Create mock function
- [x] method(object, methodName, implementation?, options?) - Mock method
- [x] getter(object, propertyName, implementation?, options?) - Mock getter
- [x] setter(object, propertyName, implementation?, options?) - Mock setter
- [x] reset() - Reset all mocks
- [x] restoreAll() - Restore all mocked functions

### Mock Function
- [x] MockFunction type
- [x] mock.calls - Array of call records
- [x] mock.callCount() - Number of calls
- [x] mock.mockImplementation(fn) - Set implementation
- [x] mock.mockImplementationOnce(fn) - Set one-time implementation
- [x] mock.restore() - Restore original

## Usage
This package is used extensively in test files under `src/_tests/`

## Test Coverage
Used in all async test files in src/_tests/
