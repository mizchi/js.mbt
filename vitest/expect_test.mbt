///|
async test "expect toBe basic" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(1 + 1)).toBe(@core.any(2))
  @vitest.expect(@core.any("hello")).toBe(@core.any("hello"))
}

///|
async test "expect toEqual" {
  @vitest.setup_standalone()
  let obj = @core.new_object()
  obj["a"] = @core.any(1)
  obj["b"] = @core.any(2)
  let expected = @core.new_object()
  expected["a"] = @core.any(1)
  expected["b"] = @core.any(2)
  @vitest.expect(obj).toEqual(expected)
}

///|
async test "expect toBeDefined and toBeUndefined" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(42)).toBeDefined()
  @vitest.expect(@core.undefined()).toBeUndefined()
}

///|
async test "expect toBeNull" {
  @vitest.setup_standalone()
  @vitest.expect(@core.null()).toBeNull()
}

///|
async test "expect toBeTruthy and toBeFalsy" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(true)).toBeTruthy()
  @vitest.expect(@core.any(1)).toBeTruthy()
  @vitest.expect(@core.any("hello")).toBeTruthy()
  @vitest.expect(@core.any(false)).toBeFalsy()
  @vitest.expect(@core.any(0)).toBeFalsy()
  @vitest.expect(@core.any("")).toBeFalsy()
}

///|
async test "expect numeric comparisons" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(10)).toBeGreaterThan(5.0)
  @vitest.expect(@core.any(10)).toBeGreaterThanOrEqual(10.0)
  @vitest.expect(@core.any(5)).toBeLessThan(10.0)
  @vitest.expect(@core.any(5)).toBeLessThanOrEqual(5.0)
}

///|
async test "expect toBeCloseTo" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(0.1 + 0.2)).toBeCloseTo(0.3)
}

///|
async test "expect toContain" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any("hello world")).toContain(@core.any("world"))
  let arr = @core.any([1, 2, 3])
  @vitest.expect(arr).toContain(@core.any(2))
}

///|
async test "expect toHaveLength" {
  @vitest.setup_standalone()
  let arr = @core.any([1, 2, 3])
  @vitest.expect(arr).toHaveLength(3)
  @vitest.expect(@core.any("hello")).toHaveLength(5)
}

///|
async test "expect not_ negation" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any(1)).not_().toBe(@core.any(2))
  @vitest.expect(@core.any("hello")).not_().toContain(@core.any("xyz"))
}

///|
async test "expect toHaveProperty" {
  @vitest.setup_standalone()
  let obj = @core.new_object()
  obj["name"] = @core.any("Alice")
  obj["age"] = @core.any(30)
  @vitest.expect(obj).toHaveProperty("name")
  @vitest.expect(obj).toHaveProperty("age", value=@core.any(30))
}

///|
async test "expect toMatch" {
  @vitest.setup_standalone()
  @vitest.expect(@core.any("hello world")).toMatch("world")
  @vitest.expect(@core.any("test@example.com")).toMatch("@")
}
