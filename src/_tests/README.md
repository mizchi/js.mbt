# async tests directory

This directory contains asynchronous test cases for the `js.mbt` project. Each test case is designed to validate the functionality of asynchronous operations within the codebase.

In near future, we plan to expand this directory to include more comprehensive asynchronous tests, covering various scenarios and edge cases to ensure robustness and reliability of the asynchronous features in the project.

```mbt
// before async test
test {
  it("test-case", () => {
    // ...  
  })
}

// after async test
async test "test-case" {
  // ...
}
```
