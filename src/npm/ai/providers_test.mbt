///| Provider Adapter Tests

///|
test "OpenAIOptions::default creates empty options" {
  let opts = OpenAIOptions::default()
  assert_true(opts.api_key is None)
  assert_true(opts.base_url is None)
  assert_true(opts.organization is None)
}

///|
test "OpenAIOptions::as_any with all fields" {
  let opts : OpenAIOptions = {
    api_key: Some("test-key"),
    base_url: Some("https://api.openai.com/v1"),
    organization: Some("org-123"),
  }
  let js_obj = opts.as_any()
  let api_key : String = js_obj._get("apiKey").cast()
  assert_eq(api_key, "test-key")
  let base_url : String = js_obj._get("baseURL").cast()
  assert_eq(base_url, "https://api.openai.com/v1")
  let org : String = js_obj._get("organization").cast()
  assert_eq(org, "org-123")
}

///|
test "OpenAIOptions::as_any with empty options" {
  let opts = OpenAIOptions::default()
  let js_obj = opts.as_any()
  assert_true(@js.is_undefined(js_obj._get("apiKey")))
  assert_true(@js.is_undefined(js_obj._get("baseURL")))
  assert_true(@js.is_undefined(js_obj._get("organization")))
}

///|
test "AnthropicOptions::default creates empty options" {
  let opts = AnthropicOptions::default()
  assert_true(opts.api_key is None)
  assert_true(opts.base_url is None)
}

///|
test "AnthropicOptions::as_any with all fields" {
  let opts : AnthropicOptions = {
    api_key: Some("anthropic-key"),
    base_url: Some("https://api.anthropic.com/v1"),
  }
  let js_obj = opts.as_any()
  let api_key : String = js_obj._get("apiKey").cast()
  assert_eq(api_key, "anthropic-key")
  let base_url : String = js_obj._get("baseURL").cast()
  assert_eq(base_url, "https://api.anthropic.com/v1")
}

///|
test "AnthropicOptions::as_any with empty options" {
  let opts = AnthropicOptions::default()
  let js_obj = opts.as_any()
  assert_true(@js.is_undefined(js_obj._get("apiKey")))
  assert_true(@js.is_undefined(js_obj._get("baseURL")))
}

///|
test "GoogleOptions::default creates empty options" {
  let opts = GoogleOptions::default()
  assert_true(opts.api_key is None)
  assert_true(opts.base_url is None)
}

///|
test "GoogleOptions::as_any with all fields" {
  let opts : GoogleOptions = {
    api_key: Some("google-key"),
    base_url: Some("https://generativelanguage.googleapis.com/v1beta"),
  }
  let js_obj = opts.as_any()
  let api_key : String = js_obj._get("apiKey").cast()
  assert_eq(api_key, "google-key")
  let base_url : String = js_obj._get("baseURL").cast()
  assert_eq(base_url, "https://generativelanguage.googleapis.com/v1beta")
}

///|
test "GoogleOptions::as_any with empty options" {
  let opts = GoogleOptions::default()
  let js_obj = opts.as_any()
  assert_true(@js.is_undefined(js_obj._get("apiKey")))
  assert_true(@js.is_undefined(js_obj._get("baseURL")))
}

///|
test "OpenAIOptions::as_any with partial fields - api_key only" {
  let opts : OpenAIOptions = {
    api_key: Some("my-key"),
    base_url: None,
    organization: None,
  }
  let js_obj = opts.as_any()
  let api_key : String = js_obj._get("apiKey").cast()
  assert_eq(api_key, "my-key")
  assert_true(@js.is_undefined(js_obj._get("baseURL")))
  assert_true(@js.is_undefined(js_obj._get("organization")))
}

///|
test "OpenAIOptions::as_any with partial fields - base_url only" {
  let opts : OpenAIOptions = {
    api_key: None,
    base_url: Some("https://custom.api.com"),
    organization: None,
  }
  let js_obj = opts.as_any()
  assert_true(@js.is_undefined(js_obj._get("apiKey")))
  let base_url : String = js_obj._get("baseURL").cast()
  assert_eq(base_url, "https://custom.api.com")
  assert_true(@js.is_undefined(js_obj._get("organization")))
}

///|
test "OpenAIOptions::as_any with partial fields - organization only" {
  let opts : OpenAIOptions = {
    api_key: None,
    base_url: None,
    organization: Some("my-org"),
  }
  let js_obj = opts.as_any()
  assert_true(@js.is_undefined(js_obj._get("apiKey")))
  assert_true(@js.is_undefined(js_obj._get("baseURL")))
  let org : String = js_obj._get("organization").cast()
  assert_eq(org, "my-org")
}

///|
test "AnthropicOptions::as_any with partial fields - api_key only" {
  let opts : AnthropicOptions = {
    api_key: Some("anthropic-key"),
    base_url: None,
  }
  let js_obj = opts.as_any()
  let api_key : String = js_obj._get("apiKey").cast()
  assert_eq(api_key, "anthropic-key")
  assert_true(@js.is_undefined(js_obj._get("baseURL")))
}

///|
test "AnthropicOptions::as_any with partial fields - base_url only" {
  let opts : AnthropicOptions = {
    api_key: None,
    base_url: Some("https://custom.anthropic.com"),
  }
  let js_obj = opts.as_any()
  assert_true(@js.is_undefined(js_obj._get("apiKey")))
  let base_url : String = js_obj._get("baseURL").cast()
  assert_eq(base_url, "https://custom.anthropic.com")
}

///|
test "GoogleOptions::as_any with partial fields - api_key only" {
  let opts : GoogleOptions = { api_key: Some("google-key"), base_url: None }
  let js_obj = opts.as_any()
  let api_key : String = js_obj._get("apiKey").cast()
  assert_eq(api_key, "google-key")
  assert_true(@js.is_undefined(js_obj._get("baseURL")))
}

///|
test "GoogleOptions::as_any with partial fields - base_url only" {
  let opts : GoogleOptions = {
    api_key: None,
    base_url: Some("https://custom.google.com"),
  }
  let js_obj = opts.as_any()
  assert_true(@js.is_undefined(js_obj._get("apiKey")))
  let base_url : String = js_obj._get("baseURL").cast()
  assert_eq(base_url, "https://custom.google.com")
}
