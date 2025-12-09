///| AI SDK Provider Adapters
/// Provides bindings for OpenAI, Anthropic, and Google Generative AI providers
/// Based on https://v6.ai-sdk.dev/providers/ai-sdk-providers

///|
/// OpenAI provider options
pub(all) struct OpenAIOptions {
  /// API key (defaults to OPENAI_API_KEY environment variable)
  api_key : String?
  /// Base URL for the API
  base_url : String?
  /// Organization ID
  organization : String?
}

///|
/// Create default OpenAI options
pub fn OpenAIOptions::default() -> OpenAIOptions {
  { api_key: None, base_url: None, organization: None }
}

///|
/// Convert OpenAI options to JS object
pub fn OpenAIOptions::as_any(self : OpenAIOptions) -> @core.Any {
  let obj = @core.new_object()
  if self.api_key is Some(key) {
    obj._set("apiKey", key |> @core.any)
  }
  if self.base_url is Some(url) {
    obj._set("baseURL", url |> @core.any)
  }
  if self.organization is Some(org) {
    obj._set("organization", org |> @core.any)
  }
  obj
}

///|
/// OpenAI provider handle
#external
pub type OpenAIProvider

///|
pub fn OpenAIProvider::as_any(self : OpenAIProvider) -> @core.Any = "%identity"

///|
/// Load the OpenAI provider module
/// Returns the default openai provider function from @ai-sdk/openai
extern "js" fn ffi_openai_require() -> OpenAIProvider =
  #| () => require("@ai-sdk/openai").openai

///|
pub fn OpenAIProvider::require() -> OpenAIProvider {
  ffi_openai_require()
}

///|
#module("@ai-sdk/openai")
extern "js" fn ffi_create_openai(options : @core.Any) -> OpenAIProvider = "createOpenAI"

///|
/// Create a customized OpenAI provider with options
pub fn OpenAIProvider::create(options : OpenAIOptions) -> OpenAIProvider {
  ffi_create_openai(options.as_any())
}

///|
/// Create an OpenAI model instance
/// Example: openai.model("gpt-4o")
pub fn OpenAIProvider::model(self : OpenAIProvider, model_id : String) -> Model {
  self.as_any()._invoke([model_id |> @js.any]) |> @core.identity
}

///|
/// Convenience function to create an OpenAI model with default provider
pub fn openai(model_id : String) -> Model {
  OpenAIProvider::require().model(model_id)
}

///|
/// Convenience function to create an OpenAI model with custom options
pub fn openai_with_options(model_id : String, options : OpenAIOptions) -> Model {
  OpenAIProvider::create(options).model(model_id)
}

///|
/// Anthropic provider options
pub(all) struct AnthropicOptions {
  /// API key (defaults to ANTHROPIC_API_KEY environment variable)
  api_key : String?
  /// Base URL for the API
  base_url : String?
}

///|
/// Create default Anthropic options
pub fn AnthropicOptions::default() -> AnthropicOptions {
  { api_key: None, base_url: None }
}

///|
/// Convert Anthropic options to JS object
pub fn AnthropicOptions::as_any(self : AnthropicOptions) -> @core.Any {
  let obj = @core.new_object()
  if self.api_key is Some(key) {
    obj._set("apiKey", key |> @core.any)
  }
  if self.base_url is Some(url) {
    obj._set("baseURL", url |> @core.any)
  }
  obj
}

///|
/// Anthropic provider handle
#external
pub type AnthropicProvider

///|
pub fn AnthropicProvider::as_any(self : AnthropicProvider) -> @core.Any = "%identity"

///|
/// Load the Anthropic provider module
/// Returns the default anthropic provider function from @ai-sdk/anthropic
extern "js" fn ffi_anthropic_require() -> AnthropicProvider =
  #| () => require("@ai-sdk/anthropic").anthropic

///|
pub fn AnthropicProvider::require() -> AnthropicProvider {
  ffi_anthropic_require()
}

///|
#module("@ai-sdk/anthropic")
extern "js" fn ffi_create_anthropic(options : @core.Any) -> AnthropicProvider = "createAnthropic"

///|
/// Create a customized Anthropic provider with options
pub fn AnthropicProvider::create(
  options : AnthropicOptions,
) -> AnthropicProvider {
  ffi_create_anthropic(options.as_any())
}

///|
/// Create an Anthropic model instance
/// Example: anthropic.model("claude-sonnet-4-20250514")
pub fn AnthropicProvider::model(
  self : AnthropicProvider,
  model_id : String,
) -> Model {
  self.as_any()._invoke([model_id |> @js.any]) |> @core.identity
}

///|
/// Convenience function to create an Anthropic model with default provider
pub fn anthropic(model_id : String) -> Model {
  AnthropicProvider::require().model(model_id)
}

///|
/// Convenience function to create an Anthropic model with custom options
pub fn anthropic_with_options(
  model_id : String,
  options : AnthropicOptions,
) -> Model {
  AnthropicProvider::create(options).model(model_id)
}

///|
/// Google Generative AI provider options
pub(all) struct GoogleOptions {
  /// API key (defaults to GOOGLE_GENERATIVE_AI_API_KEY environment variable)
  api_key : String?
  /// Base URL for the API
  base_url : String?
}

///|
/// Create default Google options
pub fn GoogleOptions::default() -> GoogleOptions {
  { api_key: None, base_url: None }
}

///|
/// Convert Google options to JS object
pub fn GoogleOptions::as_any(self : GoogleOptions) -> @core.Any {
  let obj = @core.new_object()
  if self.api_key is Some(key) {
    obj._set("apiKey", key |> @core.any)
  }
  if self.base_url is Some(url) {
    obj._set("baseURL", url |> @core.any)
  }
  obj
}

///|
/// Google Generative AI provider handle
#external
pub type GoogleProvider

///|
pub fn GoogleProvider::as_any(self : GoogleProvider) -> @core.Any = "%identity"

///|
/// Load the Google Generative AI provider module
/// Returns the default google provider function from @ai-sdk/google
extern "js" fn ffi_google_require() -> GoogleProvider =
  #| () => require("@ai-sdk/google").google

///|
pub fn GoogleProvider::require() -> GoogleProvider {
  ffi_google_require()
}

///|
#module("@ai-sdk/google")
extern "js" fn ffi_create_google(options : @core.Any) -> GoogleProvider = "createGoogleGenerativeAI"

///|
/// Create a customized Google provider with options
pub fn GoogleProvider::create(options : GoogleOptions) -> GoogleProvider {
  ffi_create_google(options.as_any())
}

///|
/// Create a Google Generative AI model instance
/// Example: google.model("gemini-2.0-flash")
pub fn GoogleProvider::model(self : GoogleProvider, model_id : String) -> Model {
  self.as_any()._invoke([model_id |> @js.any]) |> @core.identity
}

///|
/// Convenience function to create a Google model with default provider
pub fn google(model_id : String) -> Model {
  GoogleProvider::require().model(model_id)
}

///|
/// Convenience function to create a Google model with custom options
pub fn google_with_options(model_id : String, options : GoogleOptions) -> Model {
  GoogleProvider::create(options).model(model_id)
}
