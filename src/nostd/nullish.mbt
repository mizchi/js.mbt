///|
/// null | undefined | T
#external
pub type Nullish[T]

///|
pub fn[T] Nullish::to_option(self : Nullish[T]) -> T? {
  if is_nullish(self |> any) {
    None
  } else {
    Some(self |> identity)
  }
}

///|
/// null or T
#external
pub type Nullable[T]

///|
pub fn[T] Nullable::to_option(self : Nullable[T]) -> T? {
  if is_null(self |> any) {
    None
  } else {
    Some(self |> identity)
  }
}
