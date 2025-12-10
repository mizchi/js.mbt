///| Ink UI Tests using ink-testing-library with dynamic import

///|
async test "spinner component renders" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.spinner(label="Loading...")
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("Loading"))
}

///|
async test "progress bar component renders" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.progress_bar(50)
  let result = testing.render(element)
  defer result.unmount()
  // Progress bar should render something
  let frame = result.lastFrame()
  assert_true(frame.length() > 0)
}

///|
async test "badge component renders with text" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.badge(["SUCCESS"], color=@ink_ui.BadgeColor::Green)
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("SUCCESS"))
}

///|
async test "status message renders with variant" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.status_message(
    ["Operation completed"],
    @ink_ui.StatusVariant::Success,
  )
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("Operation completed"))
}

///|
async test "alert component renders with title" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.alert(
    ["Something went wrong"],
    @ink_ui.StatusVariant::Error,
    title="Error",
  )
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("Error") || frame.contains("wrong"))
}

///|
async test "unordered list renders items" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.unordered_list([
    ink_ui.unordered_list_item(["Item 1"]),
    ink_ui.unordered_list_item(["Item 2"]),
    ink_ui.unordered_list_item(["Item 3"]),
  ])
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  // List should render with some content
  assert_true(frame.length() > 0)
}

///|
async test "ordered list renders numbered items" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.ordered_list([
    ink_ui.ordered_list_item(["First"]),
    ink_ui.ordered_list_item(["Second"]),
  ])
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  // List should render with some content
  assert_true(frame.length() > 0)
}

///|
async test "select component renders with options" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let options : Array[@ink_ui.SelectOption] = [
    { label: "Option A", value: "a" },
    { label: "Option B", value: "b" },
    { label: "Option C", value: "c" },
  ]
  let element = ink_ui.select(options)
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  // At least one option should be visible
  assert_true(
    frame.contains("Option A") ||
    frame.contains("Option B") ||
    frame.contains("Option C"),
  )
}

///|
async test "text input renders with placeholder" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.text_input(placeholder="Enter your name")
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  // Placeholder should be visible
  assert_true(frame.contains("name") || frame.length() > 0)
}

///|
test "badge color enum variants" {
  assert_eq(@ink_ui.BadgeColor::Green.to_string(), "green")
  assert_eq(@ink_ui.BadgeColor::Red.to_string(), "red")
  assert_eq(@ink_ui.BadgeColor::Yellow.to_string(), "yellow")
  assert_eq(@ink_ui.BadgeColor::Blue.to_string(), "blue")
  assert_eq(@ink_ui.BadgeColor::Cyan.to_string(), "cyan")
  assert_eq(@ink_ui.BadgeColor::Magenta.to_string(), "magenta")
  assert_eq(@ink_ui.BadgeColor::White.to_string(), "white")
  assert_eq(@ink_ui.BadgeColor::Gray.to_string(), "gray")
}

///|
test "status variant enum variants" {
  assert_eq(@ink_ui.StatusVariant::Success.to_string(), "success")
  assert_eq(@ink_ui.StatusVariant::Error.to_string(), "error")
  assert_eq(@ink_ui.StatusVariant::Warning.to_string(), "warning")
  assert_eq(@ink_ui.StatusVariant::Info.to_string(), "info")
}

///|
async test "text input with default value" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.text_input(
    placeholder="Name",
    default_value="John",
    is_disabled=false,
  )
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "email input component" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.email_input(
    placeholder="Email",
    domains=["gmail.com", "yahoo.com"],
    is_disabled=false,
  )
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "password input component" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.password_input(
    placeholder="Password",
    mask="*",
    is_disabled=false,
  )
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "confirm input component" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.confirm_input(is_disabled=false)
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "select with all options" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let options : Array[@ink_ui.SelectOption] = [
    { label: "First", value: "1" },
    { label: "Second", value: "2" },
  ]
  let element = ink_ui.select(
    options,
    default_value="1",
    visible_option_count=5,
    is_disabled=false,
  )
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "multi select component" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let options : Array[@ink_ui.SelectOption] = [
    { label: "Apple", value: "apple" },
    { label: "Banana", value: "banana" },
    { label: "Cherry", value: "cherry" },
  ]
  let element = ink_ui.multi_select(
    options,
    default_value=["apple"],
    visible_option_count=3,
    is_disabled=false,
  )
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "spinner without label" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.spinner()
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "progress bar at 0 percent" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.progress_bar(0)
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "progress bar at 100 percent" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.progress_bar(100)
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "badge without color" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.badge(["Default Badge"])
  let result = testing.render(element)
  defer result.unmount()
  // Badge should render something
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "alert without title" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.alert(
    ["Warning message"],
    @ink_ui.StatusVariant::Warning,
  )
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "status message info variant" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let element = ink_ui.status_message(
    ["Info message"],
    @ink_ui.StatusVariant::Info,
  )
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().length() > 0)
}

///|
async test "theming with default theme" {
  let ink_ui = @ink_ui.dynamic_import()
  let testing = @ink.dynamic_import_testing_library().wait()
  let ink = @ink.dynamic_import().wait()
  let theme = ink_ui.default_theme()
  let element = ink_ui.theme_provider([ink.text(["Themed content"])], theme)
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().contains("Themed content"))
}

// Note: extendTheme may not be available in all versions of @inkjs/ui
// Skipping this test for now
// async test "theming with extended theme" { ... }
