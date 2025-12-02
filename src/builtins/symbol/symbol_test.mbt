///|
test "Symbol creation and well-known symbols" {
  let sym = @symbol.symbol("test")
  let iter_sym = @symbol.Symbol::iterator()
  let dispose_sym = @symbol.Symbol::dispose()
  let async_dispose_sym = @symbol.Symbol::asyncDispose()
  assert_eq(@nostd.typeof_(@nostd.any(sym)), "symbol")
  assert_eq(@nostd.typeof_(@nostd.any(iter_sym)), "symbol")
  assert_eq(@nostd.typeof_(@nostd.any(dispose_sym)), "symbol")
  assert_eq(@nostd.typeof_(@nostd.any(async_dispose_sym)), "symbol")
}

///|
test "Symbol::for_ global registry" {
  let sym1 = @symbol.Symbol::for_("mySymbol")
  let sym2 = @symbol.Symbol::for_("mySymbol")
  assert_eq(@nostd.typeof_(@nostd.any(sym1)), "symbol")
  assert_eq(@nostd.typeof_(@nostd.any(sym2)), "symbol")
  let sym3 = @symbol.Symbol::for_("differentSymbol")
  assert_eq(@nostd.typeof_(@nostd.any(sym3)), "symbol")
}

///|
test "Symbol::asyncIterator" {
  let async_iter_sym = @symbol.Symbol::asyncIterator()
  assert_eq(@nostd.typeof_(@nostd.any(async_iter_sym)), "symbol")
}
