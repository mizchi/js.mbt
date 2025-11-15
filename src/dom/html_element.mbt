///|
using @blob {type Blob}

///|
#external
pub type HTMLCanvasElement

///|
pub impl Js for HTMLCanvasElement with to_js(self) -> Val {
  self |> js
}

///|
/// Canvas properties
pub fn HTMLCanvasElement::width(self : Self) -> Int {
  self.to_js().get("width").cast()
}

///|
pub fn HTMLCanvasElement::set_width(self : Self, value : Int) -> Unit {
  self.to_js().set("width", value)
}

///|
pub fn HTMLCanvasElement::height(self : Self) -> Int {
  self.to_js().get("height").cast()
}

///|
pub fn HTMLCanvasElement::set_height(self : Self, value : Int) -> Unit {
  self.to_js().set("height", value)
}

///|
/// Canvas methods
pub fn HTMLCanvasElement::get_context(
  self : Self,
  context_type : String,
) -> Val {
  self.to_js().call_method("getContext", [context_type])
}

///|
pub fn HTMLCanvasElement::to_data_url(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> String {
  match (image_type, quality) {
    (Some(t), Some(q)) => self.to_js().call_method("toDataURL", [t, q]).cast()
    (Some(t), None) => self.to_js().call_method("toDataURL", [t]).cast()
    (None, _) => self.to_js().call_method("toDataURL", []).cast()
  }
}

///|
pub fn HTMLCanvasElement::to_blob(
  self : Self,
  image_type? : String,
  quality? : Double,
) -> Promise[Blob] {
  match (image_type, quality) {
    (Some(t), Some(q)) => self.to_js().call_method("toBlob", [t, q]).cast()
    (Some(t), None) => self.to_js().call_method("toBlob", [t]).cast()
    (None, _) => self.to_js().call_method("toBlob", []).cast()
  }
}
