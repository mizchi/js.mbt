///|
/// DataTransfer is used to hold data being dragged during a drag and drop operation
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
pub(all) struct DataTransfer {
  mut dropEffect : String
  mut effectAllowed : String
  items : @nostd.Any
  files : @nostd.Any
  types : @nostd.Any
}

///|
pub fn DataTransfer::as_any(self : DataTransfer) -> @nostd.Any = "%identity"

///|
/// Returns an array of files being dragged
pub fn DataTransfer::get_files(self : Self) -> Array[@nostd.Any] {
  @js.array_from(self.files).map(fn(v) { v })
}

///|
/// Returns an array of formats used in the drag operation
pub fn DataTransfer::get_types(self : Self) -> Array[String] {
  @js.array_from(self.types).map(fn(v) { @nostd.identity(v) })
}

///|
/// Retrieves the data for a given type
pub fn DataTransfer::getData(self : Self, format : String) -> String {
  self.as_any()._call("getData", [@nostd.any(format)]).cast()
}

///|
/// Sets the data for a given type
pub fn DataTransfer::setData(
  self : Self,
  format : String,
  data : String,
) -> Unit {
  self.as_any()._call("setData", [@nostd.any(format), @nostd.any(data)])
  |> ignore
}

///|
/// Removes the data for a given type
pub fn DataTransfer::clearData(self : Self, format : String) -> Unit {
  self.as_any()._call("clearData", [@nostd.any(format)]) |> ignore
}

///|
/// DataTransferItem represents one drag data item
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransferItem
#external
pub type DataTransferItem

///|
pub fn DataTransferItem::as_any(self : DataTransferItem) -> @nostd.Any = "%identity"

///|
/// ClipboardData provides access to clipboard data
/// Note: This is typically accessed through ClipboardEvent.clipboardData
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
pub(all) struct ClipboardData(DataTransfer)
