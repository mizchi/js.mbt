///|
/// DataTransfer is used to hold data being dragged during a drag and drop operation
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
#external
pub type DataTransfer

///|
pub impl JsImpl for DataTransfer

///|
/// Gets the type of drag-and-drop operation currently selected
pub fn DataTransfer::dropEffect(self : Self) -> String {
  self.get("dropEffect") |> unsafe_cast
}

///|
/// Sets the type of drag-and-drop operation currently selected
pub fn DataTransfer::setDropEffect(self : Self, effect : String) -> Unit {
  self.set("dropEffect", effect)
}

///|
/// Gets the type of drag-and-drop operation that is allowed
pub fn DataTransfer::effectAllowed(self : Self) -> String {
  self.get("effectAllowed") |> unsafe_cast
}

///|
/// Sets the type of drag-and-drop operation that is allowed
pub fn DataTransfer::setEffectAllowed(self : Self, effect : String) -> Unit {
  self.set("effectAllowed", effect)
}

///|
/// Returns the DataTransferItemList object
pub fn DataTransfer::items(self : Self) -> @js.Js {
  self.get("items")
}

///|
/// Returns an array of files being dragged
pub fn DataTransfer::files(self : Self) -> Array[@js.Js] {
  let files = self.get("files")
  @js.array_from(files).map(fn(v) { v })
}

///|
/// Returns an array of formats used in the drag operation
pub fn DataTransfer::types(self : Self) -> Array[String] {
  let types = self.get("types")
  @js.array_from(types).map(fn(v) { unsafe_cast(v) })
}

///|
/// Retrieves the data for a given type
pub fn DataTransfer::getData(self : Self, format : String) -> String {
  self.call("getData", [format]) |> unsafe_cast
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
pub impl JsImpl for DataTransferItem

///|
/// ClipboardData provides access to clipboard data
/// Note: This is typically accessed through ClipboardEvent.clipboardData
/// https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
pub(all) struct ClipboardData(DataTransfer)
