///|
test "expect toBe basic" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(1 + 1)).toBe(@core.any(2))
  @vitest.expect(@core.any("hello")).toBe(@core.any("hello"))
}

///|
test "expect toEqual" {
  @vitest.setup_standalone()
  let obj = @core.Object::new()
  obj["a"] = @core.any(1)
  obj["b"] = @core.any(2)
  let expected = @core.Object::new()
  expected["a"] = @core.any(1)
  expected["b"] = @core.any(2)
  @vitest.expect(obj).toEqual(expected)
}

///|
test "expect toBeDefined and toBeUndefined" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(42)).toBeDefined()
  @vitest.expect(@core.undefined()).toBeUndefined()
}

///|
test "expect toBeNull" {
  @vitest.setup_standalone()
  @vitest.expect(@core.null()).toBeNull()
}

///|
test "expect toBeTruthy and toBeFalsy" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(true)).toBeTruthy()
  @vitest.expect(@core.any(1)).toBeTruthy()
  @vitest.expect(@core.any("hello")).toBeTruthy()
  @vitest.expect(@core.any(false)).toBeFalsy()
  @vitest.expect(@core.any(0)).toBeFalsy()
  @vitest.expect(@core.any("")).toBeFalsy()
}

///|
test "expect numeric comparisons" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(10)).toBeGreaterThan(5.0)
  @vitest.expect(@core.any(10)).toBeGreaterThanOrEqual(10.0)
  @vitest.expect(@core.any(5)).toBeLessThan(10.0)
  @vitest.expect(@core.any(5)).toBeLessThanOrEqual(5.0)
}

///|
test "expect toBeCloseTo" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(0.1 + 0.2)).toBeCloseTo(0.3)
}

///|
test "expect toContain" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any("hello world")).toContain(@core.any("world"))
  let arr = @core.any([1, 2, 3])
  @vitest.expect(arr).toContain(@core.any(2))
}

///|
test "expect toHaveLength" {
  @vitest.setup_standalone()
  let arr = @core.any([1, 2, 3])
  @vitest.expect(arr).toHaveLength(3)
  @vitest.expect(@core.any("hello")).toHaveLength(5)
}

///|
test "expect not_ negation" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(1)).not_().toBe(@core.any(2))
  @vitest.expect(@core.any("hello")).not_().toContain(@core.any("xyz"))
}

///|
test "expect toHaveProperty" {
  @vitest.setup_standalone()
  let obj = @core.Object::new()
  obj["name"] = @core.any("Alice")
  obj["age"] = @core.any(30)
  @vitest.expect(obj).toHaveProperty("name")
  @vitest.expect(obj).toHaveProperty("age", value=@core.any(30))
}

///|
test "expect toMatch" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any("hello world")).toMatch("world")
  @vitest.expect(@core.any("test@example.com")).toMatch("@")
}
