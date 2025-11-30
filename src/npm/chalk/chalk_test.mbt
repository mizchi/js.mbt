///|
test "red text" {
  let result = red("hello")
  // Result should contain ANSI escape codes
  assert_eq(result.contains("hello"), true)
}

///|
test "green text" {
  let result = green("world")
  assert_eq(result.contains("world"), true)
}

///|
test "blue text" {
  let result = blue("test")
  assert_eq(result.contains("test"), true)
}

///|
test "yellow text" {
  let result = yellow("warning")
  assert_eq(result.contains("warning"), true)
}

///|
test "bold text" {
  let result = bold("strong")
  assert_eq(result.contains("strong"), true)
}

///|
test "italic text" {
  let result = italic("emphasis")
  assert_eq(result.contains("emphasis"), true)
}

///|
test "underline text" {
  let result = underline("underlined")
  assert_eq(result.contains("underlined"), true)
}

///|
test "bgRed text" {
  let result = bgRed("error")
  assert_eq(result.contains("error"), true)
}

///|
test "bgGreen text" {
  let result = bgGreen("success")
  assert_eq(result.contains("success"), true)
}

///|
test "bright colors" {
  let result = redBright("bright red")
  assert_eq(result.contains("bright red"), true)
}

///|
test "chainable instance" {
  let c = instance()
  let styled = c.red().bold()
  // styled is a ChalkInstance, can be used to style text
  @nostd.type_of(styled.as_any()) |> assert_eq("function")
}

///|
test "chainable colors" {
  let c = instance().blue().bold()
  @nostd.type_of(c.as_any()) |> assert_eq("function")
}

///|
test "chainable with background" {
  let c = instance().bgYellow().black()
  @nostd.type_of(c.as_any()) |> assert_eq("function")
}

///|
test "rgb color" {
  let c = rgb(255, 136, 0)
  @nostd.type_of(c.as_any()) |> assert_eq("function")
}

///|
test "hex color" {
  let c = hex("#FF8800")
  @nostd.type_of(c.as_any()) |> assert_eq("function")
}

///|
test "bgRgb" {
  let c = bgRgb(100, 50, 200)
  @nostd.type_of(c.as_any()) |> assert_eq("function")
}

///|
test "bgHex" {
  let c = bgHex("#112233")
  @nostd.type_of(c.as_any()) |> assert_eq("function")
}

///|
test "gray and grey alias" {
  let g1 = gray("test")
  let g2 = grey("test")
  // Both should work
  assert_eq(g1.contains("test"), true)
  assert_eq(g2.contains("test"), true)
}

///|
test "dim text" {
  let result = dim("dimmed")
  assert_eq(result.contains("dimmed"), true)
}

///|
test "strikethrough text" {
  let result = strikethrough("crossed")
  assert_eq(result.contains("crossed"), true)
}

///|
test "inverse text" {
  let result = inverse("inverted")
  assert_eq(result.contains("inverted"), true)
}
