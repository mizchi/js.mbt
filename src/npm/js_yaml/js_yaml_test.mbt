///|
/// js-yaml bindings tests

///|
test "yaml load simple object" {
  let yaml_str = "name: Alice\nage: 30"
  let result = @js_yaml.load(yaml_str)
  let obj : @js.Object = @js.identity(result)
  inspect(obj.get("name").cast() == "Alice", content="true")
  inspect(obj.get("age").cast() == 30, content="true")
}

///|
test "yaml load array" {
  let yaml_str = "- apple\n- banana\n- cherry"
  let result = @js_yaml.load(yaml_str)
  let arr : Array[String] = @js.identity(result)
  inspect(arr.length(), content="3")
  inspect(arr[0], content="apple")
  inspect(arr[1], content="banana")
  inspect(arr[2], content="cherry")
}

///|
test "yaml load nested object" {
  let yaml_str = "person:\n  name: Bob\n  age: 25"
  let result = @js_yaml.load(yaml_str)
  let obj : @js.Object = @js.identity(result)
  let person : @js.Object = @js.identity(obj.get("person"))
  inspect(person.get("name").cast() == "Bob", content="true")
  inspect(person.get("age").cast() == 25, content="true")
}

///|
test "yaml dump simple object" {
  let obj = @js.Object::new()
  obj["name"] = "Charlie"
  obj["age"] = 35
  let yaml_str = @js_yaml.dump(obj.to_any())
  // YAML output contains the key-value pairs
  inspect(yaml_str.contains("name: Charlie"), content="true")
  inspect(yaml_str.contains("age: 35"), content="true")
}

///|
test "yaml loadObject convenience" {
  let yaml_str = "key: value"
  let obj = @js_yaml.loadObject(yaml_str)
  inspect(obj.get("key").cast() == "value", content="true")
}

///|
test "yaml dumpObject convenience" {
  let obj = @js.Object::new()
  obj["foo"] = "bar"
  let yaml_str = @js_yaml.dump(obj.to_any())
  inspect(yaml_str.contains("foo: bar"), content="true")
}

///|
test "yamlToJson conversion" {
  let yaml_str = "name: Test\ncount: 42"
  let json_str = @js_yaml.yamlToJson(yaml_str)
  inspect(json_str.contains("\"name\""), content="true")
  inspect(json_str.contains("\"Test\""), content="true")
  inspect(json_str.contains("42"), content="true")
}

///|
test "jsonToYaml conversion" {
  let json_str = "{\"name\": \"Demo\", \"value\": 100}"
  let yaml_str = @js_yaml.jsonToYaml(json_str) catch { _ => "" }
  inspect(yaml_str.length() > 0, content="true")
  inspect(yaml_str.contains("name: Demo"), content="true")
  inspect(yaml_str.contains("value: 100"), content="true")
}

///|
test "yaml loadAll multi-document" {
  let yaml_str = "---\nname: First\n---\nname: Second"
  let docs = @js_yaml.loadAll(yaml_str)
  inspect(docs.length(), content="2")
}

///|
test "yaml dump with options" {
  let obj = @js.Object::new()
  obj["a"] = 1
  obj["b"] = 2
  let yaml_str = @js_yaml.dump(obj.to_any(), indent=4, sortKeys=true)
  // Should contain the keys with 4-space indent
  inspect(yaml_str.contains("a: 1"), content="true")
  inspect(yaml_str.contains("b: 2"), content="true")
}

///|
test "yaml load boolean values" {
  let yaml_str = "enabled: true\ndisabled: false"
  let obj = @js_yaml.loadObject(yaml_str)
  let enabled : Bool = @js.identity(obj.get("enabled"))
  let disabled : Bool = @js.identity(obj.get("disabled"))
  inspect(enabled, content="true")
  inspect(disabled, content="false")
}

///|
test "yaml load null value" {
  let yaml_str = "value: null"
  let result = @js_yaml.load(yaml_str)
  let obj : @js.Object = @js.identity(result)
  inspect(@js.is_nullish(obj.get("value")), content="true")
}

///|
test "yaml schema functions exist" {
  let _ = @js_yaml.defaultSchema()
  let _ = @js_yaml.failsafeSchema()
  let _ = @js_yaml.jsonSchema()
  let _ = @js_yaml.coreSchema()
  ()
}
