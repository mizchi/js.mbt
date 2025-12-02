///|
/// js-yaml bindings tests

///|
test "yaml load simple object" {
  let yaml_str = "name: Alice\nage: 30"
  let result = @js_yaml.load(yaml_str)
  inspect(result["name"].cast() == "Alice", content="true")
  inspect(result["age"].cast() == 30, content="true")
}

///|
test "yaml load array" {
  let yaml_str = "- apple\n- banana\n- cherry"
  let result = @js_yaml.load(yaml_str)
  let arr : Array[String] = result.cast()
  inspect(arr.length(), content="3")
  inspect(arr[0], content="apple")
  inspect(arr[1], content="banana")
  inspect(arr[2], content="cherry")
}

///|
test "yaml load nested object" {
  let yaml_str = "person:\n  name: Bob\n  age: 25"
  let result = @js_yaml.load(yaml_str)
  let person = result["person"]
  inspect(person["name"].cast() == "Bob", content="true")
  inspect(person["age"].cast() == 25, content="true")
}

///|
test "yaml dump simple object" {
  let obj = @core.new_object()
  obj["name"] = @core.any("Charlie")
  obj["age"] = @core.any(35)
  let yaml_str = @js_yaml.dump(obj)
  // YAML output contains the key-value pairs
  inspect(yaml_str.contains("name: Charlie"), content="true")
  inspect(yaml_str.contains("age: 35"), content="true")
}

///|
test "yaml loadObject convenience" {
  let yaml_str = "key: value"
  let obj = @js_yaml.loadObject(yaml_str)
  inspect(obj["key"].cast() == "value", content="true")
}

///|
test "yaml dumpObject convenience" {
  let obj = @core.new_object()
  obj["foo"] = @core.any("bar")
  let yaml_str = @js_yaml.dump(obj)
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
  let yaml_str = @js_yaml.jsonToYaml(json_str)
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
  let obj = @core.new_object()
  obj["a"] = @core.any(1)
  obj["b"] = @core.any(2)
  let yaml_str = @js_yaml.dump(obj, indent=4, sortKeys=true)
  // Should contain the keys with 4-space indent
  inspect(yaml_str.contains("a: 1"), content="true")
  inspect(yaml_str.contains("b: 2"), content="true")
}

///|
test "yaml load boolean values" {
  let yaml_str = "enabled: true\ndisabled: false"
  let obj = @js_yaml.loadObject(yaml_str)
  let enabled : Bool = obj["enabled"].cast()
  let disabled : Bool = obj["disabled"].cast()
  inspect(enabled, content="true")
  inspect(disabled, content="false")
}

///|
test "yaml load null value" {
  let yaml_str = "value: null"
  let result = @js_yaml.load(yaml_str)
  inspect(@core.is_nullish(result["value"]), content="true")
}

///|
test "yaml schema functions exist" {
  let _ = @js_yaml.defaultSchema()
  let _ = @js_yaml.failsafeSchema()
  let _ = @js_yaml.jsonSchema()
  let _ = @js_yaml.coreSchema()
  ()
}
