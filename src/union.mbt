///|
/// TS: A | B
#external
pub type Union2[A, B]

///|
pub fn[A, B] Union2::from(x : @nostd.Any) -> Self[A, B] {
  x.cast()
}

///|
pub fn[A, B] Union2::to_any(self : Union2[A, B]) -> @nostd.Any = "%identity"

///|
pub fn[A, B] Union2::to0(self : Self[A, B]) -> A {
  self |> identity
}

///|
pub fn[A, B] Union2::to1(self : Self[A, B]) -> B {
  self |> identity
}

///|
/// TS: A | B | C
#external
pub type Union3[A, B, C]

///|
pub fn[A, B, C] Union3::from(x : @nostd.Any) -> Self[A, B, C] {
  x.cast()
}

///|
pub fn[A, B, C] Union3::to_any(self : Union3[A, B, C]) -> @nostd.Any = "%identity"

///|
pub fn[A, B, C] Union3::to0(self : Self[A, B, C]) -> A {
  self |> identity
}

///|
pub fn[A, B, C] Union3::to1(self : Self[A, B, C]) -> B {
  self |> identity
}

///|
/// TS: A | B | C
pub fn[A, B, C] Union3::to2(self : Self[A, B, C]) -> C {
  self |> identity
}

///|
/// TS: A | B | C | D
#external
pub type Union4[A, B, C, D]

///|
pub fn[A, B, C, D] Union4::from(x : @nostd.Any) -> Self[A, B, C, D] {
  x.cast()
}

///|
pub fn[A, B, C, D] Union4::to_any(self : Union4[A, B, C, D]) -> @nostd.Any = "%identity"

///|
pub fn[A, B, C, D] Union4::to0(self : Self[A, B, C, D]) -> A {
  self |> identity
}

///|
pub fn[A, B, C, D] Union4::to1(self : Self[A, B, C, D]) -> B {
  self |> identity
}

///|
pub fn[A, B, C, D] Union4::to2(self : Self[A, B, C, D]) -> C {
  self |> identity
}

///|
pub fn[A, B, C, D] Union4::to3(self : Self[A, B, C, D]) -> D {
  self |> identity
}

///|
/// TS: A | B | C | D | E
#external
pub type Union5[A, B, C, D, E]

///|
pub fn[A, B, C, D, E] Union5::from(x : @nostd.Any) -> Self[A, B, C, D, E] {
  x.cast()
}

///|
pub fn[A, B, C, D, E] Union5::to_any(
  self : Union5[A, B, C, D, E],
) -> @nostd.Any = "%identity"

///|
pub fn[A, B, C, D, E] Union5::to0(self : Self[A, B, C, D, E]) -> A {
  self |> identity
}

///|
pub fn[A, B, C, D, E] Union5::to1(self : Self[A, B, C, D, E]) -> B {
  self |> identity
}

///|
pub fn[A, B, C, D, E] Union5::to2(self : Self[A, B, C, D, E]) -> C {
  self |> identity
}

///|
pub fn[A, B, C, D, E] Union5::to3(self : Self[A, B, C, D, E]) -> D {
  self |> identity
}

///|
pub fn[A, B, C, D, E] Union5::to4(self : Self[A, B, C, D, E]) -> E {
  self |> identity
}
