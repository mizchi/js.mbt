// xany.mbt - 共通インターフェース（全ターゲット共通）
// API compatible with tonyfettes/any where applicable

///|
#external
pub type Xany

// ============================================
// Type conversions
// ============================================

///|
/// Unsafely coerce the Xany value to type T without checking.
/// This is zero-cost in JS backend (%identity).
/// API compatible with tonyfettes/any::Any::unsafe_coerce
pub fn[T] Xany::unsafe_coerce(self : Xany) -> T = "%identity"

// ============================================
// Show / Eq implementations (共通)
// ============================================

///|
pub impl Show for Xany with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Eq for Xany with equal(self, other) -> Bool {
  equal(self, other)
}
