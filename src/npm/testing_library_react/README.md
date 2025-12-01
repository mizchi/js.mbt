# mizchi/js/npm/react_testing_library

React Testing Library bindings for testing React components in Node.js environment.

## Installation

```bash
npm add @testing-library/react @testing-library/jest-dom　global-jsdom
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/npm/react",
    {
      "path": "mizchi/js/npm/react_testing_library",
      "alias": "rtl"
    }
  ]
}
```

`rtl` is shorthand

## Usage

**Note**: React Testing Library is designed for Node.js testing environments and uses synchronous `require()`. No dynamic import initialization is needed.

```moonbit
fn test_component() -> Unit {
  // Setup React for testing
  let react_module = @node.require("react")
  @react.init_react_api(react_module)
  
  // Render component
  let result = @react_testing_library.render(my_component)
  
  // Query elements
  let screen = @react_testing_library.screen()
  let button = screen.getByRole("button")
  
  // Fire events
  let fire = @react_testing_library.fireEvent()
  fire.click(button)
  
  // Check element properties
  let text : String = button._get("textContent") |> @js.identity
  @js.log("Button text: \{text}")
  
  // Cleanup
  @react_testing_library.cleanup()
}
```

## API

### Rendering
- `render(element: Element) -> RenderResult` - Render a React component
- `cleanup() -> Unit` - Cleanup after tests
- `act(callback: () -> Unit) -> Js` - Wrap state updates

### Queries (via Screen)
- `screen() -> Screen` - Get screen queries
- `getBy*` - Throw error if not found
- `queryBy*` - Return null if not found  
- `findBy*` - Return Promise (async)
- `getAllBy*`, `queryAllBy*`, `findAllBy*` - Array versions

### Events
- `fireEvent() -> FireEvent` - Get event simulator
- `FireEvent::click(element)` - Simulate click
- `FireEvent::change(element, event)` - Simulate change
- `FireEvent::input(element, event)` - Simulate input
- And more...

### Hooks Testing
- `renderHook(hook: Js) -> RenderHookResult` - Test hooks
- `RenderHookResult::result() -> Js` - Get hook result
- `RenderHookResult::rerender(props)` - Rerender with new props

## Resources

- [@testing-library/react Documentation](https://testing-library.com/docs/react-testing-library/intro/)
- [Common Queries](https://testing-library.com/docs/queries/about)
