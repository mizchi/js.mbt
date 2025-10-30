///|
pub suberror JsError Value

// https://www.moonbitlang.com/pearls/moonbit-jsffi
///|
pub impl Show for JsError with output(self, logger) {
  logger.write_string("@js.Error: ")
  let JsError(inner) = self
  logger.write_object(inner)
}
