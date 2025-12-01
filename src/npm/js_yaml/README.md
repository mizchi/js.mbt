# js-yaml Bindings

MoonBit bindings for [js-yaml](https://github.com/nodeca/js-yaml), a YAML parser and serializer for JavaScript.

## Installation

```bash
npm install js-yaml
```

## Usage

```moonbit
fn main {
  // Parse YAML string
  let yaml_str = "name: Alice\nage: 30"
  let obj = @js_yaml.load_object(yaml_str)

  // Access parsed values
  let name : String = @js.identity(obj._get("name"))
  let age : Int = @js.identity(obj._get("age"))
  println("Name: " + name)
  println("Age: " + age.to_string())

  // Serialize to YAML
  let new_obj = @nostd.Object::new()
  new_obj["key"] = "value"
  let yaml_output = @js_yaml.dump_object(new_obj)
  println(yaml_output)
}
```

## API

### Load Functions

- `load(str)` - Parse YAML string to JavaScript value
- `load_with_options(str, filename?, schema?, json?)` - Parse with options
- `load_all(str)` - Parse multi-document YAML string
- `load_all_with_options(str, filename?, schema?, json?)` - Parse multi-document with options
- `load_object(str)` - Parse YAML to Object (convenience)

### Dump Functions

- `dump(obj)` - Serialize JavaScript value to YAML string
- `dump_with_options(obj, indent?, no_array_indent?, skip_invalid?, flow_level?, sort_keys?, line_width?, no_refs?, no_compat_mode?, condense_flow?, quoting_type?, force_quotes?, schema?)` - Serialize with options
- `dump_object(obj)` - Dump Object to YAML (convenience)

### Conversion Functions

- `yaml_to_json(yaml_str)` - Parse YAML and convert to JSON string
- `json_to_yaml(json_str)` - Parse JSON and convert to YAML string (may raise error)

### Schema Constants

- `default_schema()` - Default schema with all supported YAML types
- `failsafe_schema()` - Strings, arrays, plain objects only
- `json_schema()` - All JSON-supported types
- `core_schema()` - Equivalent to JSON_SCHEMA

## Dump Options

| Option | Type | Description |
|--------|------|-------------|
| `indent` | Int | Indentation width (default: 2) |
| `no_array_indent` | Bool | Don't add indent for array elements |
| `skip_invalid` | Bool | Skip invalid types instead of throwing |
| `flow_level` | Int | Level for flow style (-1 = block style) |
| `sort_keys` | Bool | Sort object keys |
| `line_width` | Int | Max line width (default: 80) |
| `no_refs` | Bool | Don't use references (anchors/aliases) |
| `no_compat_mode` | Bool | Don't quote "yes", "no", etc. |
| `condense_flow` | Bool | Remove whitespace in flow style |
| `quoting_type` | String | Quote type: "'" or "\"" |
| `force_quotes` | Bool | Always quote strings |
| `schema` | Schema | Schema to use |

## See Also

- [js-yaml Documentation](https://github.com/nodeca/js-yaml)
- [YAML Specification](https://yaml.org/spec/)
