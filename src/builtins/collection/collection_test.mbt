///| JsMap tests

///|
test "JsMap creation and basic operations" {
  let map : JsMap[String, Int] = JsMap::new()

  // Add items
  map.set("one", 1) |> ignore
  map.set("two", 2) |> ignore
  map.set("three", 3) |> ignore

  // Check size
  assert_eq(map.size(), 3)

  // Get items
  assert_eq(map.get("one"), Some(1))
  assert_eq(map.get("two"), Some(2))
  assert_eq(map.get("three"), Some(3))
  assert_eq(map.get("four"), None)

  // Has items
  assert_true(map.has("one"))
  assert_false(map.has("four"))
}

///|
test "JsMap::from_entries" {
  let map = JsMap::from_entries([("a", 1), ("b", 2), ("c", 3)])
  assert_eq(map.size(), 3)
  assert_eq(map.get("a"), Some(1))
  assert_eq(map.get("b"), Some(2))
  assert_eq(map.get("c"), Some(3))
}

///|
test "JsMap delete and clear" {
  let map : JsMap[String, Int] = JsMap::new()
  map.set("a", 1) |> ignore
  map.set("b", 2) |> ignore
  map.set("c", 3) |> ignore

  // Delete one item
  assert_true(map.delete("b"))
  assert_eq(map.size(), 2)
  assert_eq(map.get("b"), None)
  assert_false(map.delete("nonexistent"))

  // Clear all
  map.clear()
  assert_eq(map.size(), 0)
  assert_eq(map.get("a"), None)
}

///|
test "JsMap iteration" {
  let map = JsMap::from_entries([("x", 10), ("y", 20), ("z", 30)])

  // Test keys
  let keys = map.keys().toArray()
  assert_eq(keys.length(), 3)
  assert_true(keys.contains("x"))
  assert_true(keys.contains("y"))
  assert_true(keys.contains("z"))

  // Test values
  let values = map.values().toArray()
  assert_eq(values.length(), 3)
  assert_true(values.contains(10))
  assert_true(values.contains(20))
  assert_true(values.contains(30))

  // Test entries
  let entries = map.entries().toArray()
  assert_eq(entries.length(), 3)
}

///|
test "JsMap forEach" {
  let map = JsMap::from_entries([("a", 1), ("b", 2)])
  let mut sum = 0
  map.forEach(fn(value, _key) { sum = sum + value })
  assert_eq(sum, 3)
}

///| JsSet tests

///|
test "JsSet creation and basic operations" {
  let set : JsSet[Int] = JsSet::new()

  // Add items
  set.add(1) |> ignore
  set.add(2) |> ignore
  set.add(3) |> ignore
  set.add(2) |> ignore // Duplicate, should not increase size

  // Check size
  assert_eq(set.size(), 3)

  // Has items
  assert_true(set.has(1))
  assert_true(set.has(2))
  assert_true(set.has(3))
  assert_false(set.has(4))
}

///|
test "JsSet::from_array" {
  let set = JsSet::from_array([1, 2, 3, 2, 1])

  // Duplicates should be removed
  assert_eq(set.size(), 3)
  assert_true(set.has(1))
  assert_true(set.has(2))
  assert_true(set.has(3))
}

///|
test "JsSet delete and clear" {
  let set = JsSet::from_array([10, 20, 30])

  // Delete one item
  assert_true(set.delete(20))
  assert_eq(set.size(), 2)
  assert_false(set.has(20))
  assert_false(set.delete(40))

  // Clear all
  set.clear()
  assert_eq(set.size(), 0)
  assert_false(set.has(10))
}

///|
test "JsSet iteration" {
  let set = JsSet::from_array([5, 10, 15])

  // Test values
  let values = set.values().toArray()
  assert_eq(values.length(), 3)
  assert_true(values.contains(5))
  assert_true(values.contains(10))
  assert_true(values.contains(15))

  // Test keys (same as values for Set)
  let keys = set.keys().toArray()
  assert_eq(keys.length(), 3)
  assert_true(keys.contains(5))
}

///|
test "JsSet forEach" {
  let set = JsSet::from_array([1, 2, 3])
  let mut sum = 0
  set.forEach(fn(value) { sum = sum + value })
  assert_eq(sum, 6)
}

///|
test "JsSet with strings" {
  let set = JsSet::from_array(["apple", "banana", "cherry"])
  assert_eq(set.size(), 3)
  assert_true(set.has("apple"))
  assert_false(set.has("orange"))
  set.add("orange") |> ignore
  assert_true(set.has("orange"))
  assert_eq(set.size(), 4)
}
