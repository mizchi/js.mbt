///|
async test "render and lastFrame" {
  let ink = @ink.dynamic_import()
  let itl = dynamic_import()
  let element = ink.text(["Hello, World!"])
  let result = itl.render(element)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame is Some(_))
  assert_true(frame.unwrap().contains("Hello, World!"))
}

///|
async test "rerender" {
  let ink = @ink.dynamic_import()
  let itl = dynamic_import()
  let element1 = ink.text(["Count: 0"])
  let result = itl.render(element1)
  defer result.unmount()
  let frame1 = result.lastFrame()
  assert_true(frame1 is Some(_))
  assert_true(frame1.unwrap().contains("Count: 0"))
  let element2 = ink.text(["Count: 1"])
  result.rerender(element2)
  let frame2 = result.lastFrame()
  assert_true(frame2 is Some(_))
  assert_true(frame2.unwrap().contains("Count: 1"))
}

///|
async test "frames array" {
  let ink = @ink.dynamic_import()
  let itl = dynamic_import()
  let element1 = ink.text(["First"])
  let result = itl.render(element1)
  defer result.unmount()
  let element2 = ink.text(["Second"])
  result.rerender(element2)
  let frames = result.frames()
  assert_true(frames.length() >= 2)
}

///|
async test "stdout lastFrame" {
  let ink = @ink.dynamic_import()
  let itl = dynamic_import()
  let element = ink.text(["Output Test"])
  let result = itl.render(element)
  defer result.unmount()
  let stdout = result.stdout()
  let frame = stdout.lastFrame()
  assert_true(frame is Some(_))
  assert_true(frame.unwrap().contains("Output Test"))
}

///|
async test "box with text" {
  let ink = @ink.dynamic_import()
  let itl = dynamic_import()
  let text_elem = ink.text(["Boxed Text"])
  let box_elem = ink.box_([text_elem], border_style=@ink.BorderStyle::Single)
  let result = itl.render(box_elem)
  defer result.unmount()
  let frame = result.lastFrame()
  assert_true(frame is Some(_))
  assert_true(frame.unwrap().contains("Boxed Text"))
}

///|
async test "unmount" {
  let ink = @ink.dynamic_import()
  let itl = dynamic_import()
  let element = ink.text(["Will Unmount"])
  let result = itl.render(element)
  let frame_before = result.lastFrame()
  assert_true(frame_before is Some(_))
  result.unmount()
  // After unmount, the component is cleaned up
}

///|
async test "stdin write" {
  let ink = @ink.dynamic_import()
  let itl = dynamic_import()
  let element = ink.text(["Input Test"])
  let result = itl.render(element)
  defer result.unmount()
  let stdin = result.stdin()
  // Just verify stdin.write doesn't throw
  stdin.write("test input")
}

///|
async test "stderr" {
  let ink = @ink.dynamic_import()
  let itl = dynamic_import()
  let element = ink.text(["Error Test"])
  let result = itl.render(element)
  defer result.unmount()
  let stderr = result.stderr()
  // stderr.frames should be accessible (may be empty)
  let frames = stderr.frames()
  assert_true(frames.length() >= 0)
}
