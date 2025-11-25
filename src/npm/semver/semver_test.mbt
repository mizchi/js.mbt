///|
/// Test npm semver package FFI bindings
test "parse" {
  let result = parse("1.2.3")
  inspect(
    result,
    content=(
      #|Some("1.2.3")
    ),
  )
}

///|
test "valid" {
  let result = valid("1.2.3")
  inspect(
    result,
    content=(
      #|Some("1.2.3")
    ),
  )
  let invalid = valid("not a version")
  inspect(invalid, content="None")
}

///|
test "clean" {
  let result = clean("  =v1.2.3   ")
  inspect(
    result,
    content=(
      #|Some("1.2.3")
    ),
  )
}

///|
test "compare" {
  inspect(compare("1.2.3", "1.2.4"), content="-1")
  inspect(compare("1.2.4", "1.2.3"), content="1")
  inspect(compare("1.2.3", "1.2.3"), content="0")
}

///|
test "comparison operators" {
  inspect(gt("1.2.4", "1.2.3"), content="true")
  inspect(gte("1.2.3", "1.2.3"), content="true")
  inspect(lt("1.2.3", "1.2.4"), content="true")
  inspect(lte("1.2.3", "1.2.3"), content="true")
  inspect(eq("1.2.3", "1.2.3"), content="true")
  inspect(neq("1.2.3", "1.2.4"), content="true")
}

///|
test "satisfies" {
  inspect(satisfies("1.2.3", "1.x || >=2.5.0 || 5.0.0 - 7.2.3"), content="true")
  inspect(satisfies("2.6.0", "1.x || >=2.5.0 || 5.0.0 - 7.2.3"), content="true")
  inspect(
    satisfies("0.5.0", "1.x || >=2.5.0 || 5.0.0 - 7.2.3"),
    content="false",
  )
}

///|
test "inc" {
  inspect(
    inc("1.2.3", "major"),
    content=(
      #|Some("2.0.0")
    ),
  )
  inspect(
    inc("1.2.3", "minor"),
    content=(
      #|Some("1.3.0")
    ),
  )
  inspect(
    inc("1.2.3", "patch"),
    content=(
      #|Some("1.2.4")
    ),
  )
  inspect(
    inc("1.2.3", "prerelease", identifier="beta"),
    content=(
      #|Some("1.2.4-beta.0")
    ),
  )
}

///|
test "major, minor, patch" {
  inspect(major("1.2.3"), content="1")
  inspect(minor("1.2.3"), content="2")
  inspect(patch("1.2.3"), content="3")
}

///|
test "prerelease" {
  inspect(
    prerelease("1.2.3-alpha.1"),
    content=(
      #|["alpha",1]
    ),
  )
  inspect(prerelease("1.2.3"), content="null")
}

///|
test "diff" {
  inspect(
    diff("1.2.3", "1.2.4"),
    content=(
      #|Some("patch")
    ),
  )
  inspect(
    diff("1.2.3", "1.3.0"),
    content=(
      #|Some("minor")
    ),
  )
  inspect(
    diff("1.2.3", "2.0.0"),
    content=(
      #|Some("major")
    ),
  )
}

///|
test "coerce" {
  inspect(
    coerce("v1.2.3"),
    content=(
      #|Some("1.2.3")
    ),
  )
  inspect(
    coerce("1.2.3.4"),
    content=(
      #|Some("1.2.3")
    ),
  )
  inspect(
    coerce("1.2"),
    content=(
      #|Some("1.2.0")
    ),
  )
}

///|
test "valid_range" {
  inspect(
    valid_range("1.x || >=2.5.0"),
    content=(
      #|Some(">=1.0.0 <2.0.0-0||>=2.5.0")
    ),
  )
  inspect(valid_range("not a range"), content="None")
}

///|
test "sort" {
  let versions = ["1.2.3", "1.0.0", "2.0.0", "1.5.0"]
  inspect(
    sort(versions),
    content=(
      #|["1.0.0", "1.2.3", "1.5.0", "2.0.0"]
    ),
  )
  inspect(
    rsort(versions),
    content=(
      #|["2.0.0", "1.5.0", "1.2.3", "1.0.0"]
    ),
  )
}

///|
test "compare_loose" {
  inspect(compare_loose("1.2.3", "1.2.4"), content="-1")
}

///|
test "max_satisfying and min_satisfying" {
  let versions = ["1.2.3", "1.0.0", "2.0.0", "1.5.0"]
  inspect(
    max_satisfying(versions, "^1.0.0"),
    content=(
      #|Some("1.5.0")
    ),
  )
  inspect(
    min_satisfying(versions, "^1.0.0"),
    content=(
      #|Some("1.0.0")
    ),
  )
}

///|
test "gtr and ltr" {
  inspect(gtr("2.0.0", "^1.0.0"), content="true")
  inspect(ltr("0.5.0", "^1.0.0"), content="true")
}

///|
test "outside" {
  inspect(outside("2.0.0", "^1.0.0", ">"), content="true")
  inspect(outside("0.5.0", "^1.0.0", "<"), content="true")
}
