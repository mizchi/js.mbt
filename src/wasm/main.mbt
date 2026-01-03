// main.mbt - WASM entry point and test exports
//
// Known limitations with MoonBit WASM-GC + js-string-builtins:
// - %identity for Int -> Any generates i32 instead of externref
// - Any::cast() to String causes (ref extern) vs externref mismatch
// - Int.to_string() has similar type issues

///|
fn main {
  // Entry point for WASM module
}

// ============================================
// Test: Object operations
// ============================================

///|
/// Test object creation and property access
pub fn test_object_ops() -> String {
  let obj = @core.new_object()
  obj["name"] = @core.any("MoonBit")
  obj["type"] = @core.any("language")

  // Nested object
  let nested = @core.new_object()
  nested["version"] = @core.any("latest")
  obj["meta"] = nested
  @core.json_stringify(obj)
}

// ============================================
// Test: Type checks
// ============================================

///|
/// Test null and undefined checks
pub fn test_null_undefined() -> String {
  let results = @core.new_object()

  // Test null
  let null_val = @core.null()
  results["is_null_null"] = @core.any(
    if @core.is_null(null_val) {
      "true"
    } else {
      "false"
    },
  )
  results["is_nullish_null"] = @core.any(
    if @core.is_nullish(null_val) {
      "true"
    } else {
      "false"
    },
  )

  // Test undefined
  let undef_val = @core.undefined()
  results["is_undefined_undef"] = @core.any(
    if @core.is_undefined(undef_val) {
      "true"
    } else {
      "false"
    },
  )
  results["is_nullish_undef"] = @core.any(
    if @core.is_nullish(undef_val) {
      "true"
    } else {
      "false"
    },
  )

  // Test non-null value
  let str_val = @core.any("hello")
  results["is_null_string"] = @core.any(
    if @core.is_null(str_val) {
      "true"
    } else {
      "false"
    },
  )
  results["is_nullish_string"] = @core.any(
    if @core.is_nullish(str_val) {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

///|
/// Test object and array type checks
pub fn test_type_checks() -> String {
  let results = @core.new_object()

  // Object check
  let obj = @core.new_object()
  results["is_object_obj"] = @core.any(
    if @core.is_object(obj) {
      "true"
    } else {
      "false"
    },
  )

  // Array check
  let arr = @core.new_array()
  results["is_array_arr"] = @core.any(
    if @core.is_array(arr) {
      "true"
    } else {
      "false"
    },
  )
  results["is_object_arr"] = @core.any(
    if @core.is_object(arr) {
      "true"
    } else {
      "false"
    },
  )

  // String check (not an object)
  let str = @core.any("test")
  results["is_object_str"] = @core.any(
    if @core.is_object(str) {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

// ============================================
// Test: Global access
// ============================================

///|
/// Test globalThis access
pub fn test_global_this() -> String {
  let global = @core.global_this()
  let results = @core.new_object()

  // Check if globalThis is an object
  results["is_object"] = @core.any(
    if @core.is_object(global) {
      "true"
    } else {
      "false"
    },
  )

  // Access Math.PI via globalThis
  let math = global["Math"]
  results["has_math"] = @core.any(
    if @core.is_object(math) {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

// ============================================
// Test: Method calls
// ============================================

///|
/// Test calling JavaScript methods
pub fn test_method_calls() -> String {
  let results = @core.new_object()

  // Array push and join
  let arr = @core.new_array()
  arr._call("push", [@core.any("a")]) |> ignore
  arr._call("push", [@core.any("b")]) |> ignore
  arr._call("push", [@core.any("c")]) |> ignore

  // Join the array
  let joined = arr._call("join", [@core.any("-")])
  results["joined"] = joined

  // String methods via global
  let str = @core.any("hello world")
  let upper = str._call("toUpperCase", [])
  results["upper"] = upper
  @core.json_stringify(results)
}

// ============================================
// Test: JSON operations
// ============================================

///|
/// Test JSON parse and stringify
pub fn test_json() -> String {
  // Parse JSON string
  let parsed = @core.json_parse("{\"x\":\"one\",\"y\":\"two\"}")

  // Modify and stringify
  parsed["z"] = @core.any("three")
  @core.json_stringify(parsed)
}

// ============================================
// Legacy test (for compatibility)
// ============================================

///|
pub fn test_core() -> String {
  let obj = @core.new_object()
  obj["greeting"] = @core.any("Hello from WASM!")
  obj["language"] = @core.any("MoonBit")
  @core.json_stringify(obj)
}

///|
/// Exported function to test DOM operations from JavaScript
pub fn test_dom() -> Unit {
  console_log("test_dom called from WASM")

  // Create a div element
  let div = create_element("div")
  set_id(div, "wasm-created")
  set_text_content(div, "Created by MoonBit WASM")
  set_style(div, "padding", "10px")
  set_style(div, "background", "#f0f0f0")
  set_style(div, "border", "1px solid #ccc")
  set_style(div, "margin", "10px")

  // Append to body
  append_child(document_body(), div) |> ignore
  console_log("DOM element created successfully")
}

// ============================================
// Extended DOM Tests for Browser
// ============================================
// NOTE: MoonBit closures cannot be directly passed to JavaScript in WASM-GC
// (type mismatch: MoonBit closure refs vs externref)
// Event handlers must be set up from JavaScript side

///|
/// Test creating nested DOM structure
pub fn test_dom_nested() -> Unit {
  console_log("test_dom_nested: Creating nested structure")
  let container = create_element("div")
  set_id(container, "nested-container")
  set_style(container, "border", "2px solid #333")
  set_style(container, "padding", "15px")
  set_style(container, "margin", "10px")

  // Create header
  let header = create_element("h3")
  set_text_content(header, "Nested DOM Test")
  set_style(header, "margin", "0 0 10px 0")
  append_child(container, header) |> ignore

  // Create list
  let ul = create_element("ul")
  for i = 1; i <= 3; i = i + 1 {
    let li = create_element("li")
    set_text_content(li, "Item " + i.to_string())
    append_child(ul, li) |> ignore
  }
  append_child(container, ul) |> ignore
  append_child(document_body(), container) |> ignore
  console_log("test_dom_nested: Done")
}

///|
/// Test DOM attributes
pub fn test_dom_attributes() -> Unit {
  console_log("test_dom_attributes: Testing attributes")
  let link = create_element("a")
  set_attribute(link, "href", "https://moonbitlang.com")
  set_attribute(link, "target", "_blank")
  set_text_content(link, "Visit MoonBit")
  set_style(link, "display", "block")
  set_style(link, "margin", "10px")

  // Verify attribute
  let href = get_attribute(link, "href")
  console_log("href attribute: " + href.to_string())
  append_child(document_body(), link) |> ignore
  console_log("test_dom_attributes: Done")
}

///|
/// Test innerHTML
pub fn test_dom_inner_html() -> Unit {
  console_log("test_dom_inner_html: Testing innerHTML")
  let div = create_element("div")
  set_id(div, "inner-html-test")
  set_style(div, "margin", "10px")
  set_style(div, "padding", "10px")
  set_style(div, "background", "#e0e0e0")
  set_inner_html(
    div, "<strong>Bold</strong> and <em>italic</em> from innerHTML",
  )
  append_child(document_body(), div) |> ignore
  console_log("test_dom_inner_html: Done")
}

///|
/// Test querySelector
pub fn test_dom_query_selector() -> Unit {
  console_log("test_dom_query_selector: Testing querySelector")
  let div = create_element("div")
  set_class_name(div, "query-test")
  set_text_content(div, "This element has class 'query-test'")
  set_style(div, "margin", "10px")
  set_style(div, "padding", "10px")
  set_style(div, "background", "#c0ffc0")
  append_child(document_body(), div) |> ignore

  // Query it back
  let found = query_selector(".query-test")
  if not(@core.is_null(found)) {
    console_log("Found element with class 'query-test'")
    set_style(found, "border", "2px solid green")
  } else {
    console_log("Element not found!")
  }
  console_log("test_dom_query_selector: Done")
}

///|
/// Run all DOM tests (no event handlers - must be set up from JS)
pub fn test_dom_all() -> Unit {
  console_log("=== Running All DOM Tests ===")

  // Add a header
  let header = create_element("h1")
  set_text_content(header, "MoonBit WASM-GC DOM Tests")
  set_style(header, "font-family", "sans-serif")
  set_style(header, "color", "#333")
  set_style(header, "padding", "10px")
  append_child(document_body(), header) |> ignore
  test_dom()
  test_dom_nested()
  test_dom_attributes()
  test_dom_inner_html()
  test_dom_query_selector()
  console_log("=== All DOM Tests Complete ===")
}

// ============================================
// Test: Array operations
// ============================================

///|
/// Test array operations including index access
pub fn test_array_ops() -> String {
  let results = @core.new_object()

  // Create array and add elements
  let arr = @core.new_array()
  arr._call("push", [@core.any("first")]) |> ignore
  arr._call("push", [@core.any("second")]) |> ignore
  arr._call("push", [@core.any("third")]) |> ignore

  // Test index access
  let first = arr._get_by_index(0)
  let second = arr._get_by_index(1)
  results["first"] = first
  results["second"] = second

  // Array length via property
  let length = arr["length"]
  results["length"] = length

  // Array slice
  let sliced = arr._call("slice", [@core.any("1"), @core.any("3")])
  results["sliced_length"] = sliced["length"]

  // Array reverse (creates new array)
  let reversed = arr._call("slice", [])._call("reverse", [])
  results["reversed_first"] = reversed._get_by_index(0)
  @core.json_stringify(results)
}

// ============================================
// Test: Object utilities
// ============================================

///|
/// Test object utility functions
/// Note: object_keys/object_values return MoonBit arrays which have type issues in WASM-GC
pub fn test_object_utils() -> String {
  let results = @core.new_object()

  // Create test object
  let obj = @core.new_object()
  obj["a"] = @core.any("alpha")
  obj["b"] = @core.any("beta")
  obj["c"] = @core.any("gamma")

  // object_has_own
  let has_a = @core.object_has_own(obj, "a")
  let has_x = @core.object_has_own(obj, "x")
  results["has_a"] = @core.any(if has_a { "true" } else { "false" })
  results["has_x"] = @core.any(if has_x { "true" } else { "false" })

  // object_assign
  let target = @core.new_object()
  target["existing"] = @core.any("value")
  let source = @core.new_object()
  source["new_key"] = @core.any("new_value")
  @core.object_assign(target, source) |> ignore
  results["assign_has_new"] = @core.any(
    if @core.object_has_own(target, "new_key") {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

// ============================================
// Test: typeof checks
// ============================================

///|
/// Test typeof function
/// Note: typeof_ returns String which has WASM-GC type compatibility issues
/// when converting to Any, so we test it indirectly
pub fn test_typeof() -> String {
  let results = @core.new_object()

  // Test typeof by checking specific conditions
  // Since typeof_ -> String -> Any has type issues, we use a workaround
  let str_val = @core.any("hello")
  let obj_val = @core.new_object()
  let arr_val = @core.new_array()
  let null_val = @core.null()
  let undef_val = @core.undefined()

  // Check is_object works for typeof-like checks
  results["str_is_object"] = @core.any(
    if @core.is_object(str_val) {
      "true"
    } else {
      "false"
    },
  )
  results["obj_is_object"] = @core.any(
    if @core.is_object(obj_val) {
      "true"
    } else {
      "false"
    },
  )
  results["arr_is_array"] = @core.any(
    if @core.is_array(arr_val) {
      "true"
    } else {
      "false"
    },
  )
  results["null_is_null"] = @core.any(
    if @core.is_null(null_val) {
      "true"
    } else {
      "false"
    },
  )
  results["undef_is_undefined"] = @core.any(
    if @core.is_undefined(undef_val) {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

// ============================================
// Test: Equality checks
// ============================================

///|
/// Test equal function for strict equality
pub fn test_equality() -> String {
  let results = @core.new_object()

  // String equality
  let str1 = @core.any("hello")
  let str2 = @core.any("hello")
  let str3 = @core.any("world")
  results["str_equal_same"] = @core.any(
    if @core.equal(str1, str2) {
      "true"
    } else {
      "false"
    },
  )
  results["str_equal_diff"] = @core.any(
    if @core.equal(str1, str3) {
      "true"
    } else {
      "false"
    },
  )

  // null/undefined equality
  let null1 = @core.null()
  let null2 = @core.null()
  let undef = @core.undefined()
  results["null_equal_null"] = @core.any(
    if @core.equal(null1, null2) {
      "true"
    } else {
      "false"
    },
  )
  results["null_equal_undef"] = @core.any(
    if @core.equal(null1, undef) {
      "true"
    } else {
      "false"
    },
  )

  // Object reference equality
  let obj1 = @core.new_object()
  let obj2 = @core.new_object()
  let obj3 = obj1
  results["obj_equal_diff"] = @core.any(
    if @core.equal(obj1, obj2) {
      "true"
    } else {
      "false"
    },
  )
  results["obj_equal_same"] = @core.any(
    if @core.equal(obj1, obj3) {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

// ============================================
// Test: Function invocation
// ============================================

///|
/// Test function invocation via _invoke
pub fn test_invoke() -> String {
  let results = @core.new_object()

  // Get Math.max from globalThis
  let global = @core.global_this()
  let math = global["Math"]
  let max_fn = math["max"]

  // Invoke Math.max with arguments
  let max_result = max_fn._invoke([@core.any("5"), @core.any("10")])
  results["max_5_10"] = max_result

  // Get Math.min and invoke
  let min_fn = math["min"]
  let min_result = min_fn._invoke([@core.any("3"), @core.any("7")])
  results["min_3_7"] = min_result

  // Test Math.abs
  let abs_fn = math["abs"]
  let abs_result = abs_fn._invoke([@core.any("-42")])
  results["abs_neg42"] = abs_result

  // Test Array.isArray via function reference
  let array_obj = global["Array"]
  let is_array_fn = array_obj["isArray"]
  let arr = @core.new_array()
  let is_arr_result = is_array_fn._invoke([arr])
  results["is_array_arr"] = is_arr_result
  @core.json_stringify(results)
}

// ============================================
// Test: Constructor invocation
// ============================================

///|
/// Test new constructor calls
pub fn test_constructor() -> String {
  let results = @core.new_object()
  let global = @core.global_this()

  // Create Date object
  let date_class = global["Date"]
  let date = @core.new(date_class, [])
  results["date_is_object"] = @core.any(
    if @core.is_object(date) {
      "true"
    } else {
      "false"
    },
  )

  // Create Array with length
  let array_class = global["Array"]
  let arr = @core.new(array_class, [@core.any("3")])
  results["array_length"] = arr["length"]

  // Create Map
  let map_class = global["Map"]
  let map = @core.new(map_class, [])
  map._call("set", [@core.any("key"), @core.any("value")]) |> ignore
  let map_size = map["size"]
  results["map_size"] = map_size

  // Create Set
  let set_class = global["Set"]
  let set = @core.new(set_class, [])
  set._call("add", [@core.any("item1")]) |> ignore
  set._call("add", [@core.any("item2")]) |> ignore
  let set_size = set["size"]
  results["set_size"] = set_size
  @core.json_stringify(results)
}

// ============================================
// Test: ToAny trait with primitives
// ============================================

///|
/// Test ToAny trait implementations for primitive types
pub fn test_to_any() -> String {
  let results = @core.new_object()

  // Test Int -> Any via ToAny trait
  let int_val : Int = 42
  results["int_value"] = @core.ToAny::to_any(int_val)

  // Test Double -> Any
  let double_val : Double = 3.14
  results["double_value"] = @core.ToAny::to_any(double_val)

  // Test Bool -> Any
  let bool_val : Bool = true
  results["bool_value"] = @core.ToAny::to_any(bool_val)

  // Test String -> Any
  let str_val : String = "hello"
  results["string_value"] = @core.ToAny::to_any(str_val)

  // Test with arithmetic
  let sum : Int = 10 + 20
  results["sum"] = @core.ToAny::to_any(sum)

  // Test Array[Any] -> Any
  let arr : Array[@core.Any] = [
    @core.ToAny::to_any(1),
    @core.ToAny::to_any(2),
    @core.ToAny::to_any(3),
  ]
  results["array"] = @core.ToAny::to_any(arr)

  // Test Bytes -> Any (Uint8Array)
  let bytes : Bytes = b"\x01\x02\x03"
  results["bytes"] = @core.ToAny::to_any(bytes)

  // Test BigInt -> Any (via Int64)
  // Note: BigInt cannot be JSON.stringify'd, so convert to string
  let big : BigInt = 9223372036854775807N // Int64 max
  let bigint_any = @core.ToAny::to_any(big)
  results["bigint"] = bigint_any._call("toString", [])

  // Test Int64 -> BigInt directly
  let i64_val : Int64 = 1234567890123456789L
  let i64_bigint = @core.int64_to_bigint(i64_val)
  results["int64_as_bigint"] = i64_bigint._call("toString", [])
  @core.json_stringify(results)
}

// ============================================
// Test: classList operations
// ============================================

///|
/// Test classList add/remove/toggle/contains
pub fn test_class_list() -> Unit {
  console_log("test_class_list: Testing classList operations")
  let div = create_element("div")
  set_id(div, "classlist-test")

  // Add classes
  class_list_add(div, "class-a")
  class_list_add(div, "class-b")
  class_list_add(div, "class-c")

  // Check contains
  let has_a = class_list_contains(div, "class-a")
  let has_x = class_list_contains(div, "class-x")
  console_log(
    "has class-a: " + has_a.to_string() + ", has class-x: " + has_x.to_string(),
  )

  // Remove a class
  class_list_remove(div, "class-b")
  let has_b = class_list_contains(div, "class-b")
  console_log("after remove, has class-b: " + has_b.to_string())

  // Toggle
  let toggle_result = class_list_toggle(div, "class-d")
  console_log("toggle class-d result: " + toggle_result.to_string())
  set_text_content(div, "classList test: " + div["className"].to_string())
  set_style(div, "margin", "10px")
  set_style(div, "padding", "10px")
  set_style(div, "background", "#e0f0ff")
  append_child(document_body(), div) |> ignore
  console_log("test_class_list: Done")
}

// ============================================
// Test: dataset (data-* attributes)
// ============================================

///|
/// Test dataset for data-* attributes
pub fn test_dataset() -> Unit {
  console_log("test_dataset: Testing data-* attributes")
  let div = create_element("div")
  set_id(div, "dataset-test")

  // Set data attributes
  set_dataset(div, "userId", "12345")
  set_dataset(div, "userName", "moonbit")
  set_dataset(div, "isActive", "true")

  // Get data attributes
  let user_id = get_dataset(div, "userId")
  let user_name = get_dataset(div, "userName")
  console_log(
    "userId: " + user_id.to_string() + ", userName: " + user_name.to_string(),
  )
  set_text_content(div, "Dataset: userId=" + user_id.to_string())
  set_style(div, "margin", "10px")
  set_style(div, "padding", "10px")
  set_style(div, "background", "#f0e0ff")
  append_child(document_body(), div) |> ignore
  console_log("test_dataset: Done")
}

// ============================================
// Test: DOM Traversal
// ============================================

///|
/// Test DOM traversal functions
pub fn test_dom_traversal() -> Unit {
  console_log("test_dom_traversal: Testing DOM traversal")

  // Create a structure: container > [child1, child2, child3]
  let container = create_element("div")
  set_id(container, "traversal-container")
  set_style(container, "margin", "10px")
  set_style(container, "padding", "10px")
  set_style(container, "border", "1px solid #999")
  let child1 = create_element("span")
  set_text_content(child1, "First")
  set_class_name(child1, "child")
  let child2 = create_element("span")
  set_text_content(child2, "Second")
  set_class_name(child2, "child")
  let child3 = create_element("span")
  set_text_content(child3, "Third")
  set_class_name(child3, "child")
  append_child(container, child1) |> ignore
  append_child(container, child2) |> ignore
  append_child(container, child3) |> ignore

  // Test traversal
  let count = child_element_count(container)
  console_log("childElementCount: " + count.to_string())
  let first = first_element_child(container)
  let last = last_element_child(container)
  console_log(
    "firstElementChild text: " +
    get_text_content(first).to_string() +
    ", lastElementChild text: " +
    get_text_content(last).to_string(),
  )

  // Test parent
  let parent_of_child1 = parent_element(child1)
  let parent_id = parent_of_child1["id"].to_string()
  console_log("parent of child1 id: " + parent_id)

  // Add header to show results
  let header = create_element("div")
  set_text_content(
    header,
    "Traversal: " +
    count.to_string() +
    " children, first=" +
    get_text_content(first).to_string() +
    ", last=" +
    get_text_content(last).to_string(),
  )
  set_style(header, "font-weight", "bold")
  set_style(header, "margin-bottom", "5px")
  insert_before(container, header, first) |> ignore
  append_child(document_body(), container) |> ignore
  console_log("test_dom_traversal: Done")
}

// ============================================
// Test: querySelectorAll
// ============================================

///|
/// Test querySelectorAll
pub fn test_query_selector_all() -> Unit {
  console_log("test_query_selector_all: Testing querySelectorAll")
  let container = create_element("div")
  set_id(container, "qsa-container")
  set_style(container, "margin", "10px")
  set_style(container, "padding", "10px")
  set_style(container, "background", "#fff0e0")

  // Create multiple items with same class
  for i = 1; i <= 5; i = i + 1 {
    let item = create_element("span")
    set_class_name(item, "qsa-item")
    set_text_content(item, "Item " + i.to_string())
    set_style(item, "margin-right", "10px")
    set_style(item, "padding", "5px")
    set_style(item, "background", "#e0e0e0")
    append_child(container, item) |> ignore
  }
  append_child(document_body(), container) |> ignore

  // Query all items
  let items = query_selector_all_on(container, ".qsa-item")
  let length_any = items["length"]
  console_log("querySelectorAll found " + length_any.to_string() + " items")

  // Modify each item using for loop with JS comparison
  // Use a simple loop that checks item existence
  for i = 0; i < 10; i = i + 1 {
    let item = items._get_by_index(i)
    if @core.is_undefined(item) {
      break
    }
    set_style(item, "border", "1px solid blue")
  }
  console_log("test_query_selector_all: Done")
}

// ============================================
// Test: Form elements
// ============================================

///|
/// Test form input elements
pub fn test_form_elements() -> Unit {
  console_log("test_form_elements: Testing form elements")
  let container = create_element("div")
  set_id(container, "form-container")
  set_style(container, "margin", "10px")
  set_style(container, "padding", "10px")
  set_style(container, "background", "#f0fff0")

  // Text input
  let text_input = create_element("input")
  set_attribute(text_input, "type", "text")
  set_attribute(text_input, "placeholder", "Enter text")
  set_value(text_input, "Hello WASM")
  set_style(text_input, "margin-right", "10px")
  append_child(container, text_input) |> ignore

  // Read value back
  let value = get_value(text_input)
  console_log("input value: " + value.to_string())

  // Checkbox
  let checkbox = create_element("input")
  set_attribute(checkbox, "type", "checkbox")
  set_id(checkbox, "test-checkbox")
  set_checked(checkbox, true)
  append_child(container, checkbox) |> ignore
  let label = create_element("label")
  set_attribute(label, "for", "test-checkbox")
  set_text_content(label, " Checked by WASM")
  set_style(label, "margin-right", "10px")
  append_child(container, label) |> ignore

  // Verify checkbox state
  let is_checked = get_checked(checkbox)
  console_log("checkbox checked: " + is_checked.to_string())

  // Select element
  let select = create_element("select")
  for i = 1; i <= 3; i = i + 1 {
    let option = create_element("option")
    set_attribute(option, "value", "opt" + i.to_string())
    set_text_content(option, "Option " + i.to_string())
    append_child(select, option) |> ignore
  }
  set_selected_index(select, 1) // Select second option
  append_child(container, select) |> ignore
  let selected_idx = get_selected_index(select)
  console_log("selectedIndex: " + selected_idx.to_string())

  // Disabled button
  let button = create_element("button")
  set_text_content(button, "Disabled Button")
  set_disabled(button, true)
  set_style(button, "margin-left", "10px")
  append_child(container, button) |> ignore
  let is_disabled = get_disabled(button)
  console_log("button disabled: " + is_disabled.to_string())
  append_child(document_body(), container) |> ignore
  console_log("test_form_elements: Done")
}

// ============================================
// Test: Clone and Replace
// ============================================

///|
/// Test cloneNode and replaceChild
pub fn test_clone_replace() -> Unit {
  console_log("test_clone_replace: Testing clone and replace")
  let container = create_element("div")
  set_id(container, "clone-container")
  set_style(container, "margin", "10px")
  set_style(container, "padding", "10px")
  set_style(container, "background", "#ffe0f0")

  // Create original element
  let original = create_element("div")
  set_text_content(original, "Original Element")
  set_class_name(original, "original")
  set_style(original, "padding", "5px")
  set_style(original, "background", "#fff")
  append_child(container, original) |> ignore

  // Clone it
  let cloned = clone_node(original, true)
  set_text_content(cloned, "Cloned Element")
  set_class_name(cloned, "cloned")
  append_child(container, cloned) |> ignore

  // Create replacement
  let replacement = create_element("div")
  set_text_content(replacement, "Replacement Element")
  set_style(replacement, "padding", "5px")
  set_style(replacement, "background", "#ffc")

  // Replace cloned with replacement
  replace_child(container, replacement, cloned) |> ignore
  append_child(document_body(), container) |> ignore
  console_log("test_clone_replace: Done")
}

// ============================================
// Test: Attribute operations
// ============================================

///|
/// Test attribute operations
pub fn test_attributes() -> Unit {
  console_log("test_attributes: Testing attribute operations")
  let results = @core.new_object()
  let div = create_element("div")
  set_attribute(div, "data-test", "value1")
  set_attribute(div, "data-foo", "bar")

  // has_attribute - returns Any (JS boolean)
  let has_test = has_attribute(div, "data-test")
  let has_xyz = has_attribute(div, "data-xyz")
  results["has_test"] = has_test
  results["has_xyz"] = has_xyz

  // remove_attribute
  remove_attribute(div, "data-foo")
  let has_foo_after = has_attribute(div, "data-foo")
  results["has_foo_after_remove"] = has_foo_after
  set_id(div, "attr-test")
  set_text_content(div, @core.json_stringify(results))
  set_style(div, "margin", "10px")
  set_style(div, "padding", "10px")
  set_style(div, "background", "#e0e0ff")
  set_style(div, "font-family", "monospace")
  append_child(document_body(), div) |> ignore
  console_log("test_attributes: Done")
}

// ============================================
// Test: URL API
// ============================================

///|
/// Test URL and URLSearchParams
pub fn test_url_api() -> String {
  let results = @core.new_object()
  let global = @core.global_this()

  // Create URL object
  let url_class = global["URL"]
  let url = @core.new(url_class, [
    @core.any("https://example.com/path?foo=bar&baz=qux#section"),
  ])
  results["protocol"] = url["protocol"]
  results["host"] = url["host"]
  results["pathname"] = url["pathname"]
  results["hash"] = url["hash"]

  // Access search params
  let search_params = url["searchParams"]
  let foo_val = search_params._call("get", [@core.any("foo")])
  let baz_val = search_params._call("get", [@core.any("baz")])
  results["param_foo"] = foo_val
  results["param_baz"] = baz_val

  // Modify URL
  search_params._call("set", [@core.any("new_key"), @core.any("new_value")])
  |> ignore
  results["modified_search"] = url["search"]
  @core.json_stringify(results)
}

// ============================================
// Test: Storage API
// ============================================

///|
/// Test localStorage (if available)
pub fn test_storage() -> String {
  let results = @core.new_object()
  let global = @core.global_this()
  let storage = global["localStorage"]

  // Check if storage exists
  if @core.is_nullish(storage) {
    results["available"] = @core.any("false")
    return @core.json_stringify(results)
  }
  results["available"] = @core.any("true")

  // Set item
  storage._call("setItem", [
    @core.any("wasm_test_key"),
    @core.any("wasm_test_value"),
  ])
  |> ignore

  // Get item
  let value = storage._call("getItem", [@core.any("wasm_test_key")])
  results["retrieved"] = value

  // Get length
  let length = storage["length"]
  results["length_after_set"] = length

  // Remove item
  storage._call("removeItem", [@core.any("wasm_test_key")]) |> ignore
  let after_remove = storage._call("getItem", [@core.any("wasm_test_key")])
  results["after_remove_is_null"] = @core.any(
    if @core.is_null(after_remove) {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

// ============================================
// Test: Error handling
// ============================================

///|
/// Test try/catch behavior
pub fn test_error_handling() -> String {
  let results = @core.new_object()

  // Test JSON.parse with invalid JSON (should throw)
  // We can't catch JS errors in WASM, so we test valid parse
  let valid_json = @core.json_parse("{\"valid\": true}")
  results["valid_parse"] = valid_json["valid"]

  // Test accessing undefined property (should return undefined)
  let obj = @core.new_object()
  let undef_prop = obj["nonexistent"]
  results["undefined_access_is_undefined"] = @core.any(
    if @core.is_undefined(undef_prop) {
      "true"
    } else {
      "false"
    },
  )

  // Test calling method on object
  let arr = @core.new_array()
  arr._call("push", [@core.any("item")]) |> ignore
  let pop_result = arr._call("pop", [])
  results["pop_result"] = pop_result

  // Empty array pop returns undefined
  let empty_pop = arr._call("pop", [])
  results["empty_pop_is_undefined"] = @core.any(
    if @core.is_undefined(empty_pop) {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

// ============================================
// Test: Math operations
// ============================================

///|
/// Test Math API
pub fn test_math_api() -> String {
  let results = @core.new_object()
  let global = @core.global_this()
  let math = global["Math"]

  // Constants
  results["PI"] = math["PI"]
  results["E"] = math["E"]

  // Methods
  let sqrt_result = math._call("sqrt", [@core.any("16")])
  results["sqrt_16"] = sqrt_result
  let pow_result = math._call("pow", [@core.any("2"), @core.any("10")])
  results["pow_2_10"] = pow_result
  let floor_result = math._call("floor", [@core.any("3.7")])
  results["floor_3_7"] = floor_result
  let ceil_result = math._call("ceil", [@core.any("3.2")])
  results["ceil_3_2"] = ceil_result
  let round_result = math._call("round", [@core.any("3.5")])
  results["round_3_5"] = round_result

  // random returns a number between 0 and 1
  let random_result = math._call("random", [])
  let is_between = @core.is_object(random_result) == false // primitive number
  results["random_is_number"] = @core.any(
    if is_between {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

// ============================================
// Test: String methods via JS
// ============================================

///|
/// Test JavaScript String methods
pub fn test_string_methods() -> String {
  let results = @core.new_object()
  let str = @core.any("Hello, World!")

  // Basic methods
  results["length"] = str["length"]
  results["upper"] = str._call("toUpperCase", [])
  results["lower"] = str._call("toLowerCase", [])

  // indexOf
  let index_o = str._call("indexOf", [@core.any("o")])
  results["indexOf_o"] = index_o

  // slice
  let sliced = str._call("slice", [@core.any("0"), @core.any("5")])
  results["slice_0_5"] = sliced

  // split
  let split_result = str._call("split", [@core.any(", ")])
  results["split_length"] = split_result["length"]
  results["split_first"] = split_result._get_by_index(0)

  // replace
  let replaced = str._call("replace", [@core.any("World"), @core.any("WASM")])
  results["replaced"] = replaced

  // trim
  let with_spaces = @core.any("  trimmed  ")
  results["trimmed"] = with_spaces._call("trim", [])

  // startsWith / endsWith
  let starts_h = str._call("startsWith", [@core.any("Hello")])
  let ends_exclaim = str._call("endsWith", [@core.any("!")])
  results["starts_with_hello"] = starts_h
  results["ends_with_exclaim"] = ends_exclaim
  @core.json_stringify(results)
}

// ============================================
// Test: Date API
// ============================================

///|
/// Test Date API
pub fn test_date_api() -> String {
  let results = @core.new_object()
  let global = @core.global_this()
  let date_class = global["Date"]

  // Create specific date
  let date = @core.new(date_class, [@core.any("2024-01-15T12:30:00Z")])
  results["year"] = date._call("getUTCFullYear", [])
  results["month"] = date._call("getUTCMonth", []) // 0-indexed
  results["day"] = date._call("getUTCDate", [])
  results["hours"] = date._call("getUTCHours", [])
  results["minutes"] = date._call("getUTCMinutes", [])

  // ISO string
  let iso = date._call("toISOString", [])
  results["iso"] = iso

  // Date.now()
  let now = date_class._call("now", [])
  let now_is_number = not(@core.is_object(now))
  results["now_is_number"] = @core.any(
    if now_is_number {
      "true"
    } else {
      "false"
    },
  )
  @core.json_stringify(results)
}

// ============================================
// Run all extended tests
// ============================================

///|
/// Run all extended DOM tests
pub fn test_dom_extended() -> Unit {
  console_log("=== Running Extended DOM Tests ===")
  test_class_list()
  test_dataset()
  test_dom_traversal()
  test_query_selector_all()
  test_form_elements()
  test_clone_replace()
  test_attributes()
  console_log("=== Extended DOM Tests Complete ===")
}
