///|
/// Tests for runtime utilities
/// Note: These tests must be run in a MoonBit project context

///|
/// Test find_moon_mod finds moon.mod.json from cwd
test "find_moon_mod finds project root" {
  let cwd = @process.cwd()
  let result = @runtime.find_moon_mod(cwd)
  // Should find moon.mod.json since we're in a MoonBit project
  assert_true(not(result is None))
  match result {
    Some(m) => {
      assert_true(m.path.has_suffix("moon.mod.json"))
      assert_true(m.root_dir.length() > 0)
      // source should default to "src"
      inspect(m.source, content="src")
    }
    None => ()
  }
}

///|
/// Test find_moon_mod with specific path
test "find_moon_mod from specific path" {
  let cwd = @process.cwd()
  let result = @runtime.find_moon_mod(cwd)
  assert_true(not(result is None))
  match result {
    Some(m) =>
      // Verify module name exists
      assert_true(not(m.name is None))
    None => ()
  }
}

///|
/// Test find_moon_pkg finds moon.pkg.json
test "find_moon_pkg finds package" {
  let cwd = @process.cwd()
  // Find the runtime package directory
  let moon_mod = @runtime.find_moon_mod(cwd)
  match moon_mod {
    Some(m) => {
      let runtime_dir = @path.join([
        m.root_dir,
        m.source,
        "_experimental",
        "runtime",
      ])
      let result = @runtime.find_moon_pkg(runtime_dir)
      assert_true(not(result is None))
      match result {
        Some(pkg) => {
          assert_true(pkg.path.has_suffix("moon.pkg.json"))
          // Package name should include the module name and path
          assert_true(pkg.pkg_name.contains("_experimental/runtime"))
        }
        None => ()
      }
    }
    None => ()
  }
}

///|
/// Test get_source_dir returns None for non-target paths
test "get_source_dir returns None for non-target path" {
  let cwd = @process.cwd()
  let result = @runtime.get_source_dir(cwd)
  // cwd is not inside target/js, so should return None
  inspect(result is None, content="true")
}

///|
/// Test resolve_pkg_name
test "resolve_pkg_name returns None for non-target path" {
  let cwd = @process.cwd()
  let result = @runtime.resolve_pkg_name(cwd)
  // Not in target/js, should return None
  inspect(result is None, content="true")
}

///|
/// Test MoonMod source field
test "MoonMod has correct source field" {
  let cwd = @process.cwd()
  let result = @runtime.find_moon_mod(cwd)
  match result {
    Some(m) =>
      // Default source is "src" for this project
      assert_true(m.source == "src")
    None => assert_true(false)
  }
}

///|
/// Test get_current_file returns a path
test "get_current_file returns path" {
  let current_file = @runtime.get_current_file()
  // Should return a non-empty path when running tests
  assert_true(current_file.length() > 0)
  // Should end with .js or .cjs or .mjs
  assert_true(
    current_file.has_suffix(".js") ||
    current_file.has_suffix(".cjs") ||
    current_file.has_suffix(".mjs"),
  )
}

///|
/// Test get_module_type returns ESM or CommonJS
test "get_module_type returns valid type" {
  let module_type = @runtime.get_module_type()
  // Should be either ESM or CommonJS when running in Node.js
  let is_valid = match module_type {
    @runtime.ESM | @runtime.CommonJS => true
    _ => false
  }
  assert_true(is_valid)
}

///|
/// Test is_target_build returns true when running from target
test "is_target_build returns true for target path" {
  // When running tests via moon test, we're in target/js/
  let is_target = @runtime.is_target_build()
  // Should be true since tests run from target directory
  assert_true(is_target)
}

///|
/// Test is_target_build_path with explicit paths
test "is_target_build_path works correctly" {
  let cwd = @process.cwd()
  // cwd is not in target, should return false
  let result_cwd = @runtime.is_target_build_path(cwd)
  assert_true(not(result_cwd))
  // Current file is in target, should return true
  let current_file = @runtime.get_current_file()
  if current_file.length() > 0 {
    let result_current = @runtime.is_target_build_path(current_file)
    assert_true(result_current)
  }
}
