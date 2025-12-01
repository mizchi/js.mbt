///| AI SDK Image Generation
/// Based on https://v6.ai-sdk.dev/docs/ai-sdk-core/image-generation

// ============================================================
// Image Model
// ============================================================

///|
/// Image generation model handle
#external
pub type ImageModel

///|
pub fn ImageModel::as_any(self : ImageModel) -> @nostd.Any = "%identity"

// ============================================================
// Generated Image
// ============================================================

///|
/// A generated image from the model
pub(all) struct GeneratedImage {
  /// Base64-encoded image data
  base64 : String
  /// Binary image data (Uint8Array in JS)
  uint8_array : @nostd.Any
  /// Raw image object
  raw : @nostd.Any
}

///|
pub fn GeneratedImage::from_any(value : @nostd.Any) -> GeneratedImage {
  {
    base64: value._get("base64").cast(),
    uint8_array: value._get("uint8Array"),
    raw: value,
  }
}

// ============================================================
// Image Generation Result
// ============================================================

///|
/// Result from generateImage() call
pub(all) struct GenerateImageResult {
  /// The first generated image (convenience accessor)
  image : GeneratedImage
  /// All generated images
  images : Array[GeneratedImage]
  /// Warnings from the model
  warnings : Array[CallWarning]
  /// Provider-specific metadata
  provider_metadata : ProviderMetadata?
  /// Raw response
  raw : @nostd.Any
}

///|
pub fn GenerateImageResult::from_any(value : @nostd.Any) -> GenerateImageResult {
  // Parse images array
  let images_raw = value._get("images")
  let images : Array[GeneratedImage] = if @js.is_undefined(images_raw) ||
    @js.is_null(images_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @js.identity(images_raw)
    arr.map(GeneratedImage::from_any)
  }
  // Parse warnings array
  let warnings_raw = value._get("warnings")
  let warnings : Array[CallWarning] = if @js.is_undefined(warnings_raw) ||
    @js.is_null(warnings_raw) {
    []
  } else {
    let arr : Array[@nostd.Any] = @js.identity(warnings_raw)
    arr.map(CallWarning::from_any)
  }
  {
    image: GeneratedImage::from_any(value._get("image")),
    images,
    warnings,
    provider_metadata: ProviderMetadata::from_any(
      value._get("providerMetadata"),
    ),
    raw: value,
  }
}

// ============================================================
// GenerateImage Function
// ============================================================

///|
/// Generate images from a text prompt
/// Note: This is still experimental in AI SDK v6
#alias(generate_image)
pub async fn generateImage(
  /// Image generation model to use
  model~ : ImageModel,
  /// Text description of the desired image
  prompt~ : String,
  /// Number of images to generate
  n? : Int,
  /// Image dimensions (e.g., "1024x1024")
  size? : String,
  /// Aspect ratio (e.g., "16:9")
  aspect_ratio? : String,
  /// Seed for reproducible results
  seed? : Int,
  /// Provider-specific options
  provider_options? : @nostd.Any,
  /// Maximum retries
  max_retries? : Int,
  /// Abort signal
  abort_signal? : @nostd.Any,
  /// Custom headers
  headers? : @nostd.Any,
) -> GenerateImageResult {
  let opts = @nostd.Object::new()
  let model_any : @nostd.Any = model.as_any().cast()
  opts.set("model", model_any)
  opts.set("prompt", prompt)
  if n is Some(num) {
    opts.set("n", num)
  }
  if size is Some(s) {
    opts.set("size", s)
  }
  if aspect_ratio is Some(ar) {
    opts.set("aspectRatio", ar)
  }
  if seed is Some(s) {
    opts.set("seed", s)
  }
  if provider_options is Some(po) {
    opts.set("providerOptions", po)
  }
  if max_retries is Some(r) {
    opts.set("maxRetries", r)
  }
  if abort_signal is Some(s) {
    opts.set("abortSignal", s)
  }
  if headers is Some(h) {
    opts.set("headers", h)
  }
  // Use experimental_generateImage function
  let promise : @js.Promise[@nostd.Any] = ai_module()
    ._get("experimental_generateImage")
    .call_self([opts])
    |> @js.identity
  let result = promise.wait()
  GenerateImageResult::from_any(result)
}
