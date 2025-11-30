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
pub impl @js.JsImpl for ImageModel

// ============================================================
// Generated Image
// ============================================================

///|
/// A generated image from the model
pub(all) struct GeneratedImage {
  /// Base64-encoded image data
  base64 : String
  /// Binary image data (Uint8Array in JS)
  uint8_array : @js.Any
  /// Raw image object
  raw : @js.Any
}

///|
pub fn GeneratedImage::from_any(value : @js.Any) -> GeneratedImage {
  {
    base64: value.get("base64").cast(),
    uint8_array: value.get("uint8Array"),
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
  raw : @js.Any
}

///|
pub fn GenerateImageResult::from_any(value : @js.Any) -> GenerateImageResult {
  // Parse images array
  let images_raw = value.get("images")
  let images : Array[GeneratedImage] = if @js.is_undefined(images_raw) ||
    @js.is_null(images_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(images_raw)
    arr.map(GeneratedImage::from_any)
  }
  // Parse warnings array
  let warnings_raw = value.get("warnings")
  let warnings : Array[CallWarning] = if @js.is_undefined(warnings_raw) ||
    @js.is_null(warnings_raw) {
    []
  } else {
    let arr : Array[@js.Any] = @js.identity(warnings_raw)
    arr.map(CallWarning::from_any)
  }
  {
    image: GeneratedImage::from_any(value.get("image")),
    images,
    warnings,
    provider_metadata: ProviderMetadata::from_any(value.get("providerMetadata")),
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
  provider_options? : @js.Any,
  /// Maximum retries
  max_retries? : Int,
  /// Abort signal
  abort_signal? : @js.Any,
  /// Custom headers
  headers? : @js.Any,
) -> GenerateImageResult {
  let opts = @js.Object::new()
  opts.set("model", model.as_any())
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
  let promise : @js.Promise[@js.Any] = ai_module()
    .get("experimental_generateImage")
    .call_self([opts.as_any()])
    |> @js.identity
  let result = promise.wait()
  GenerateImageResult::from_any(result)
}
