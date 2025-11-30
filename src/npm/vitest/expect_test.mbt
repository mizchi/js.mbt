///|
test "expect toBe basic" {
  @vitest.setup_standalone()
  @vitest.expect(@nostd.any(1 + 1)).toBe(@nostd.any(2))
  @vitest.expect(@nostd.any("hello")).toBe(@nostd.any("hello"))
}

///|
test "expect toEqual" {
  @vitest.setup_standalone()
  let obj = @nostd.Object::new()
  obj["a"] = @nostd.any(1)
  obj["b"] = @nostd.any(2)
  let expected = @nostd.Object::new()
  expected["a"] = @nostd.any(1)
  expected["b"] = @nostd.any(2)
  @vitest.expect(obj).toEqual(expected)
}

///|
test "expect toBeDefined and toBeUndefined" {
  @vitest.setup_standalone()
  @vitest.expect(@nostd.any(42)).toBeDefined()
  @vitest.expect(@nostd.undefined()).toBeUndefined()
}

///|
test "expect toBeNull" {
  @vitest.setup_standalone()
  @vitest.expect(@nostd.null()).toBeNull()
}

///|
test "expect toBeTruthy and toBeFalsy" {
  @vitest.setup_standalone()
  @vitest.expect(@nostd.any(true)).toBeTruthy()
  @vitest.expect(@nostd.any(1)).toBeTruthy()
  @vitest.expect(@nostd.any("hello")).toBeTruthy()
  @vitest.expect(@nostd.any(false)).toBeFalsy()
  @vitest.expect(@nostd.any(0)).toBeFalsy()
  @vitest.expect(@nostd.any("")).toBeFalsy()
}

///|
test "expect numeric comparisons" {
  @vitest.setup_standalone()
  @vitest.expect(@nostd.any(10)).toBeGreaterThan(5.0)
  @vitest.expect(@nostd.any(10)).toBeGreaterThanOrEqual(10.0)
  @vitest.expect(@nostd.any(5)).toBeLessThan(10.0)
  @vitest.expect(@nostd.any(5)).toBeLessThanOrEqual(5.0)
}

///|
test "expect toBeCloseTo" {
  @vitest.setup_standalone()
  @vitest.expect(@nostd.any(0.1 + 0.2)).toBeCloseTo(0.3)
}

///|
test "expect toContain" {
  @vitest.setup_standalone()
  @vitest.expect(@nostd.any("hello world")).toContain(@nostd.any("world"))
  let arr = @nostd.any([1, 2, 3])
  @vitest.expect(arr).toContain(@nostd.any(2))
}

///|
test "expect toHaveLength" {
  @vitest.setup_standalone()
  let arr = @nostd.any([1, 2, 3])
  @vitest.expect(arr).toHaveLength(3)
  @vitest.expect(@nostd.any("hello")).toHaveLength(5)
}

///|
test "expect not_ negation" {
  @vitest.setup_standalone()
  @vitest.expect(@nostd.any(1)).not_().toBe(@nostd.any(2))
  @vitest.expect(@nostd.any("hello")).not_().toContain(@nostd.any("xyz"))
}

///|
test "expect toHaveProperty" {
  @vitest.setup_standalone()
  let obj = @nostd.Object::new()
  obj["name"] = @nostd.any("Alice")
  obj["age"] = @nostd.any(30)
  @vitest.expect(obj).toHaveProperty("name")
  @vitest.expect(obj).toHaveProperty("age", value=@nostd.any(30))
}

///|
test "expect toMatch" {
  @vitest.setup_standalone()
  @vitest.expect(@nostd.any("hello world")).toMatch("world")
  @vitest.expect(@nostd.any("test@example.com")).toMatch("@")
}
