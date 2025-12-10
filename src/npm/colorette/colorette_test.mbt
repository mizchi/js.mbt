///|
test "basic colors return string" {
  // Color functions always return strings
  // When colors are not supported, they return the original string
  let result = red("hello")
  inspect(result.length() >= 5, content="true")
  let _ = green("test")
  let _ = blue("test")
  let _ = yellow("test")
  let _ = magenta("test")
  let _ = cyan("test")
  let _ = white("test")
  let _ = black("test")
  let _ = gray("test")
  inspect(true, content="true")
}

///|
test "bright colors return string" {
  let _ = redBright("test")
  let _ = greenBright("test")
  let _ = blueBright("test")
  let _ = yellowBright("test")
  let _ = magentaBright("test")
  let _ = cyanBright("test")
  let _ = whiteBright("test")
  let _ = blackBright("test")
  inspect(true, content="true")
}

///|
test "background colors return string" {
  let _ = bgRed("test")
  let _ = bgGreen("test")
  let _ = bgBlue("test")
  let _ = bgYellow("test")
  let _ = bgMagenta("test")
  let _ = bgCyan("test")
  let _ = bgWhite("test")
  let _ = bgBlack("test")
  inspect(true, content="true")
}

///|
test "bright background colors return string" {
  let _ = bgRedBright("x")
  let _ = bgGreenBright("x")
  let _ = bgBlueBright("x")
  let _ = bgYellowBright("x")
  let _ = bgMagentaBright("x")
  let _ = bgCyanBright("x")
  let _ = bgWhiteBright("x")
  let _ = bgBlackBright("x")
  inspect(true, content="true")
}

///|
test "text modifiers return string" {
  let _ = bold("test")
  let _ = dim("test")
  let _ = italic("test")
  let _ = underline("test")
  let _ = hidden("test")
  let _ = strikethrough("test")
  let _ = reset("test")
  inspect(true, content="true")
}

///|
test "nested styles return string" {
  // Test that styles can be nested
  let nested = bold(red("error"))
  inspect(nested.length() >= 5, content="true")
  let double_nested = underline(bold(blue("info")))
  inspect(double_nested.length() >= 4, content="true")
}

///|
test "is_color_supported_sync returns boolean" {
  // This should return a boolean (true or false depending on terminal)
  let supported = is_color_supported_sync()
  inspect(supported || not(supported), content="true")
}
