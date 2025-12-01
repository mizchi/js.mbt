///|
/// TextMatch trait - allows String or RegExp to be used as text matchers
/// This matches the TypeScript type: string | RegExp | ((content: string, element: Element) => boolean)
pub trait TextMatch {
  as_any(Self) -> @nostd.Any = _
}

///|
impl TextMatch with as_any(self) -> @nostd.Any {
  @js.identity(self)
}

///|
/// String implements TextMatch
pub impl TextMatch for String

///|
/// RegExp implements TextMatch
pub impl TextMatch for @regexp.RegExp
