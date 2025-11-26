///|
test "expect toBe basic" {
  @vitest.setup_standalone()
  @vitest.expect(1 + 1).toBe(2)
  @vitest.expect("hello").toBe("hello")
}

///|
test "expect toEqual" {
  @vitest.setup_standalone()
  let obj = @js.Object::new()
  obj.set("a", 1)
  obj.set("b", 2)
  let expected = @js.Object::new()
  expected.set("a", 1)
  expected.set("b", 2)
  @vitest.expect(obj).toEqual(expected)
}

///|
test "expect toBeDefined and toBeUndefined" {
  @vitest.setup_standalone()
  @vitest.expect(42).toBeDefined()
  @vitest.expect(@js.undefined()).toBeUndefined()
}

///|
test "expect toBeNull" {
  @vitest.setup_standalone()
  @vitest.expect(@js.null_()).toBeNull()
}

///|
test "expect toBeTruthy and toBeFalsy" {
  @vitest.setup_standalone()
  @vitest.expect(true).toBeTruthy()
  @vitest.expect(1).toBeTruthy()
  @vitest.expect("hello").toBeTruthy()
  @vitest.expect(false).toBeFalsy()
  @vitest.expect(0).toBeFalsy()
  @vitest.expect("").toBeFalsy()
}

///|
test "expect numeric comparisons" {
  @vitest.setup_standalone()
  @vitest.expect(10).toBeGreaterThan(5.0)
  @vitest.expect(10).toBeGreaterThanOrEqual(10.0)
  @vitest.expect(5).toBeLessThan(10.0)
  @vitest.expect(5).toBeLessThanOrEqual(5.0)
}

///|
test "expect toBeCloseTo" {
  @vitest.setup_standalone()
  @vitest.expect(0.1 + 0.2).toBeCloseTo(0.3)
}

///|
test "expect toContain" {
  @vitest.setup_standalone()
  @vitest.expect("hello world").toContain("world")
  let arr : @js.Any = [1, 2, 3] |> @js.from_array
  @vitest.expect(arr).toContain(2)
}

///|
test "expect toHaveLength" {
  @vitest.setup_standalone()
  let arr : @js.Any = [1, 2, 3] |> @js.from_array
  @vitest.expect(arr).toHaveLength(3)
  @vitest.expect("hello").toHaveLength(5)
}

///|
test "expect not_ negation" {
  @vitest.setup_standalone()
  @vitest.expect(1).not_().toBe(2)
  @vitest.expect("hello").not_().toContain("xyz")
}

///|
test "expect toHaveProperty" {
  @vitest.setup_standalone()
  let obj = @js.Object::new()
  obj.set("name", "Alice")
  obj.set("age", 30)
  @vitest.expect(obj).toHaveProperty("name")
  @vitest.expect(obj).toHaveProperty("age", value=@js.any(30))
}

///|
test "expect toMatch" {
  @vitest.setup_standalone()
  @vitest.expect("hello world").toMatch("world")
  @vitest.expect("test@example.com").toMatch("@")
}
