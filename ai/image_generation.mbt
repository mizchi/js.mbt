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
pub fn ImageModel::as_any(self : ImageModel) -> @core.Any = "%identity"

// ============================================================
// Generated Image
// ============================================================

///|
/// A generated image from the model
pub(all) struct GeneratedImage {
  /// Base64-encoded image data
  base64 : String
  /// Binary image data (Uint8Array in JS)
  uint8_array : @core.Any
  /// Raw image object
  raw : @core.Any
}

///|
pub fn GeneratedImage::from_any(value : @core.Any) -> GeneratedImage {
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
  raw : @core.Any
}

///|
pub fn GenerateImageResult::from_any(value : @core.Any) -> GenerateImageResult {
  // Parse images array
  let images_raw = value._get("images")
  let images : Array[GeneratedImage] = if @core.is_undefined(images_raw) ||
    @core.is_null(images_raw) {
    []
  } else {
    let arr : Array[@core.Any] = @core.identity(images_raw)
    arr.map(GeneratedImage::from_any)
  }
  // Parse warnings array
  let warnings_raw = value._get("warnings")
  let warnings : Array[CallWarning] = if @core.is_undefined(warnings_raw) ||
    @core.is_null(warnings_raw) {
    []
  } else {
    let arr : Array[@core.Any] = @core.identity(warnings_raw)
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
  aspectRatio? : String,
  /// Seed for reproducible results
  seed? : Int,
  /// Provider-specific options
  providerOptions? : @core.Any,
  /// Maximum retries
  maxRetries? : Int,
  /// Abort signal
  abortSignal? : @core.Any,
  /// Custom headers
  headers? : @core.Any,
) -> GenerateImageResult {
  let opts = @core.new_object()
  let model_any : @core.Any = model.as_any().cast()
  opts._set("model", model_any)
  opts._set("prompt", prompt |> @core.any)
  if n is Some(num) {
    opts._set("n", num |> @core.any)
  }
  if size is Some(s) {
    opts._set("size", s |> @core.any)
  }
  if aspectRatio is Some(ar) {
    opts._set("aspectRatio", ar |> @core.any)
  }
  if seed is Some(s) {
    opts._set("seed", s |> @core.any)
  }
  if providerOptions is Some(po) {
    opts._set("providerOptions", po)
  }
  if maxRetries is Some(r) {
    opts._set("maxRetries", r |> @core.any)
  }
  if abortSignal is Some(s) {
    opts._set("abortSignal", s)
  }
  if headers is Some(h) {
    opts._set("headers", h)
  }
  // Use experimental_generateImage function
  let result = ffi_experimental_generate_image(opts).wait()
  GenerateImageResult::from_any(result)
}
