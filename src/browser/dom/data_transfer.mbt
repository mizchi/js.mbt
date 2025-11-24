///|
/// DataTransfer is used to hold data being dragged during a drag and drop operation
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
pub(all) struct DataTransfer {
  mut dropEffect : String
  mut effectAllowed : String
  items : @js.Any
  files : @js.Any
  types : @js.Any
}

///|
pub impl @js.JsImpl for DataTransfer

///|
/// Returns an array of files being dragged
pub fn DataTransfer::get_files(self : Self) -> Array[@js.Any] {
  @js.array_from(self.files).map(fn(v) { v })
}

///|
/// Returns an array of formats used in the drag operation
pub fn DataTransfer::get_types(self : Self) -> Array[String] {
  @js.array_from(self.types).map(fn(v) { @js.identity(v) })
}

///|
/// Retrieves the data for a given type
pub fn DataTransfer::getData(self : Self, format : String) -> String {
  self.call("getData", [format]).cast()
}

///|
/// Sets the data for a given type
pub fn DataTransfer::setData(
  self : Self,
  format : String,
  data : String,
) -> Unit {
  ignore(self.call2("setData", format, data))
}

///|
/// Removes the data for a given type
pub fn DataTransfer::clearData(self : Self, format : String) -> Unit {
  ignore(self.call("clearData", [format]))
}

///|
/// DataTransferItem represents one drag data item
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransferItem
#external
pub type DataTransferItem

///|
pub impl @js.JsImpl for DataTransferItem

///|
/// ClipboardData provides access to clipboard data
/// Note: This is typically accessed through ClipboardEvent.clipboardData
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
pub(all) struct ClipboardData(DataTransfer)
