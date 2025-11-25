///| Ink Tests - Enum variants only (ink requires ESM, cannot use require())
/// These tests verify the type definitions work correctly

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
