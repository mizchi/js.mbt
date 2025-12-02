///|
/// DataTransfer is used to hold data being dragged during a drag and drop operation
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
pub(all) struct DataTransfer {
  mut dropEffect : String
  mut effectAllowed : String
  items : @core.Any
  files : @core.Any
  types : @core.Any
}

///|
pub fn DataTransfer::as_any(self : DataTransfer) -> @core.Any = "%identity"

///|
/// Returns an array of files being dragged
pub fn DataTransfer::get_files(self : Self) -> Array[@core.Any] {
  @core.array_from(self.files).map(fn(v) { v })
}

///|
/// Returns an array of formats used in the drag operation
pub fn DataTransfer::get_types(self : Self) -> Array[String] {
  @core.array_from(self.types).map(fn(v) { @core.identity(v) })
}

///|
/// Retrieves the data for a given type
pub fn DataTransfer::getData(self : Self, format : String) -> String {
  self.as_any()._call("getData", [@core.any(format)]).cast()
}

///|
/// Sets the data for a given type
pub fn DataTransfer::setData(
  self : Self,
  format : String,
  data : String,
) -> Unit {
  self.as_any()._call("setData", [@core.any(format), @core.any(data)]) |> ignore
}

///|
/// Removes the data for a given type
pub fn DataTransfer::clearData(self : Self, format : String) -> Unit {
  self.as_any()._call("clearData", [@core.any(format)]) |> ignore
}

///|
/// DataTransferItem represents one drag data item
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransferItem
#external
pub type DataTransferItem

///|
pub fn DataTransferItem::as_any(self : DataTransferItem) -> @core.Any = "%identity"

///|
/// ClipboardData provides access to clipboard data
/// Note: This is typically accessed through ClipboardEvent.clipboardData
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
pub(all) struct ClipboardData(DataTransfer)
