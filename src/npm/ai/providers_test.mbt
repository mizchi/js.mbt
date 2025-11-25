///| Provider Adapter Tests

///|
test "OpenAIOptions::default creates empty options" {
  let opts = OpenAIOptions::default()
  assert_true(opts.api_key is None)
  assert_true(opts.base_url is None)
  assert_true(opts.organization is None)
}

///|
test "OpenAIOptions::to_any with all fields" {
  let opts : OpenAIOptions = {
    api_key: Some("test-key"),
    base_url: Some("https://api.openai.com/v1"),
    organization: Some("org-123"),
  }
  let js_obj = opts.to_any()
  let api_key : String = js_obj.get("apiKey").cast()
  assert_eq(api_key, "test-key")
  let base_url : String = js_obj.get("baseURL").cast()
  assert_eq(base_url, "https://api.openai.com/v1")
  let org : String = js_obj.get("organization").cast()
  assert_eq(org, "org-123")
}

///|
test "OpenAIOptions::to_any with empty options" {
  let opts = OpenAIOptions::default()
  let js_obj = opts.to_any()
  assert_true(@js.is_undefined(js_obj.get("apiKey")))
  assert_true(@js.is_undefined(js_obj.get("baseURL")))
  assert_true(@js.is_undefined(js_obj.get("organization")))
}

///|
test "AnthropicOptions::default creates empty options" {
  let opts = AnthropicOptions::default()
  assert_true(opts.api_key is None)
  assert_true(opts.base_url is None)
}

///|
test "AnthropicOptions::to_any with all fields" {
  let opts : AnthropicOptions = {
    api_key: Some("anthropic-key"),
    base_url: Some("https://api.anthropic.com/v1"),
  }
  let js_obj = opts.to_any()
  let api_key : String = js_obj.get("apiKey").cast()
  assert_eq(api_key, "anthropic-key")
  let base_url : String = js_obj.get("baseURL").cast()
  assert_eq(base_url, "https://api.anthropic.com/v1")
}

///|
test "AnthropicOptions::to_any with empty options" {
  let opts = AnthropicOptions::default()
  let js_obj = opts.to_any()
  assert_true(@js.is_undefined(js_obj.get("apiKey")))
  assert_true(@js.is_undefined(js_obj.get("baseURL")))
}

///|
test "GoogleOptions::default creates empty options" {
  let opts = GoogleOptions::default()
  assert_true(opts.api_key is None)
  assert_true(opts.base_url is None)
}

///|
test "GoogleOptions::to_any with all fields" {
  let opts : GoogleOptions = {
    api_key: Some("google-key"),
    base_url: Some("https://generativelanguage.googleapis.com/v1beta"),
  }
  let js_obj = opts.to_any()
  let api_key : String = js_obj.get("apiKey").cast()
  assert_eq(api_key, "google-key")
  let base_url : String = js_obj.get("baseURL").cast()
  assert_eq(base_url, "https://generativelanguage.googleapis.com/v1beta")
}

///|
test "GoogleOptions::to_any with empty options" {
  let opts = GoogleOptions::default()
  let js_obj = opts.to_any()
  assert_true(@js.is_undefined(js_obj.get("apiKey")))
  assert_true(@js.is_undefined(js_obj.get("baseURL")))
}
