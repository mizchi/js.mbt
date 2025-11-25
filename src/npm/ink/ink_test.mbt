///| Ink Tests using ink-testing-library with dynamic import

///|
async test "text component renders text" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.text(["Hello, World!"])
  let result = testing.render(element)
  defer result.unmount()
  assert_eq(result.lastFrame(), "Hello, World!")
}

///|
async test "text component with color" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  // Note: Colors may be rendered as ANSI codes in the actual output
  let element = ink.text(["Colored"], color="green")
  let result = testing.render(element)
  defer result.unmount()
  // The frame should contain the text (with possible ANSI color codes)
  assert_true(result.lastFrame().contains("Colored"))
}

///|
async test "text component with bold" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.text(["Bold text"], bold=true)
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().contains("Bold text"))
}

///|
async test "box component with children" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.box_([ink.text(["Inside box"])])
  let result = testing.render(element)
  defer result.unmount()
  assert_true(result.lastFrame().contains("Inside box"))
}

///|
async test "box component with flex direction column" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.box_(
    [ink.text(["Line 1"]), ink.text(["Line 2"])],
    flex_direction=@ink.FlexDirection::Column,
  )
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("Line 1"))
  assert_true(frame.contains("Line 2"))
}

///|
async test "newline component" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.box_(
    [ink.text(["Before"]), ink.newline(), ink.text(["After"])],
    flex_direction=@ink.FlexDirection::Column,
  )
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("Before"))
  assert_true(frame.contains("After"))
}

///|
async test "spacer component" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.box_(
    [ink.text(["Left"]), ink.spacer(), ink.text(["Right"])],
    width=20,
  )
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("Left"))
  assert_true(frame.contains("Right"))
}

///|
async test "rerender with new content" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.text(["Initial"])
  let result = testing.render(element)
  defer result.unmount()
  assert_eq(result.lastFrame(), "Initial")
  // Rerender with new content
  let new_element = ink.text(["Updated"])
  result.rerender(new_element)
  assert_eq(result.lastFrame(), "Updated")
}

///|
async test "frames captures render history" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.text(["Frame 1"])
  let result = testing.render(element)
  defer result.unmount()
  result.rerender(ink.text(["Frame 2"]))
  result.rerender(ink.text(["Frame 3"]))
  let frames = result.frames()
  assert_true(frames.length() >= 3)
}

///|
async test "box with border" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.box_(
    [ink.text(["Bordered"])],
    border_style=@ink.BorderStyle::Single,
  )
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("Bordered"))
  // Check for border characters
  assert_true(frame.contains("─") || frame.contains("-"))
}

///|
async test "box with padding" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.box_([ink.text(["Padded"])], padding=1)
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("Padded"))
}

///|
async test "nested boxes" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.box_(
    [ink.box_([ink.text(["Inner 1"])]), ink.box_([ink.text(["Inner 2"])])],
    flex_direction=@ink.FlexDirection::Column,
  )
  let result = testing.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame.contains("Inner 1"))
  assert_true(frame.contains("Inner 2"))
}

///|
async test "transform component" {
  let ink = @ink.dynamic_import()
  let testing = @ink.dynamic_import_testing_library()
  let element = ink.transform([ink.text(["lowercase"])], fn(s) { s.to_upper() })
  let result = testing.render(element)
  defer result.unmount()
  assert_eq(result.lastFrame(), "LOWERCASE")
}

///|
test "text wrap enum variants" {
  assert_eq(@ink.TextWrap::Wrap.to_string(), "wrap")
  assert_eq(@ink.TextWrap::Truncate.to_string(), "truncate")
  assert_eq(@ink.TextWrap::TruncateStart.to_string(), "truncate-start")
  assert_eq(@ink.TextWrap::TruncateMiddle.to_string(), "truncate-middle")
  assert_eq(@ink.TextWrap::TruncateEnd.to_string(), "truncate-end")
}

///|
test "flex direction enum variants" {
  assert_eq(@ink.FlexDirection::Row.to_string(), "row")
  assert_eq(@ink.FlexDirection::Column.to_string(), "column")
  assert_eq(@ink.FlexDirection::RowReverse.to_string(), "row-reverse")
  assert_eq(@ink.FlexDirection::ColumnReverse.to_string(), "column-reverse")
}

///|
test "flex wrap mode enum variants" {
  assert_eq(@ink.FlexWrapMode::NoWrap.to_string(), "nowrap")
  assert_eq(@ink.FlexWrapMode::Wrap.to_string(), "wrap")
  assert_eq(@ink.FlexWrapMode::WrapReverse.to_string(), "wrap-reverse")
}

///|
test "justify content enum variants" {
  assert_eq(@ink.JustifyContent::FlexStart.to_string(), "flex-start")
  assert_eq(@ink.JustifyContent::FlexEnd.to_string(), "flex-end")
  assert_eq(@ink.JustifyContent::Center.to_string(), "center")
  assert_eq(@ink.JustifyContent::SpaceBetween.to_string(), "space-between")
  assert_eq(@ink.JustifyContent::SpaceAround.to_string(), "space-around")
  assert_eq(@ink.JustifyContent::SpaceEvenly.to_string(), "space-evenly")
}

///|
test "align items enum variants" {
  assert_eq(@ink.AlignItems::FlexStart.to_string(), "flex-start")
  assert_eq(@ink.AlignItems::FlexEnd.to_string(), "flex-end")
  assert_eq(@ink.AlignItems::Center.to_string(), "center")
  assert_eq(@ink.AlignItems::Stretch.to_string(), "stretch")
}

///|
test "align self enum variants" {
  assert_eq(@ink.AlignSelf::Auto.to_string(), "auto")
  assert_eq(@ink.AlignSelf::FlexStart.to_string(), "flex-start")
  assert_eq(@ink.AlignSelf::FlexEnd.to_string(), "flex-end")
  assert_eq(@ink.AlignSelf::Center.to_string(), "center")
  assert_eq(@ink.AlignSelf::Stretch.to_string(), "stretch")
}

///|
test "border style enum variants" {
  assert_eq(@ink.BorderStyle::Single.to_string(), "single")
  assert_eq(@ink.BorderStyle::Double.to_string(), "double")
  assert_eq(@ink.BorderStyle::Round.to_string(), "round")
  assert_eq(@ink.BorderStyle::Bold.to_string(), "bold")
  assert_eq(@ink.BorderStyle::SingleDouble.to_string(), "singleDouble")
  assert_eq(@ink.BorderStyle::DoubleSingle.to_string(), "doubleSingle")
  assert_eq(@ink.BorderStyle::Classic.to_string(), "classic")
  assert_eq(@ink.BorderStyle::Arrow.to_string(), "arrow")
}

///|
test "overflow enum variants" {
  assert_eq(@ink.Overflow::Visible.to_string(), "visible")
  assert_eq(@ink.Overflow::Hidden.to_string(), "hidden")
}

///|
test "display enum variants" {
  assert_eq(@ink.Display::Flex.to_string(), "flex")
  assert_eq(@ink.Display::None.to_string(), "none")
}

///|
test "render options default" {
  let opts = @ink.RenderOptions::default()
  assert_true(opts.stdout is None)
  assert_true(opts.stdin is None)
  assert_true(opts.stderr is None)
  assert_true(opts.debug is None)
  assert_true(opts.exit_on_ctrl_c is None)
  assert_true(opts.patch_console is None)
}
