///|
test "Symbol creation and well-known symbols" {
  let sym = @symbol.symbol("test")
  let iter_sym = @symbol.Symbol::iterator()
  let dispose_sym = @symbol.Symbol::dispose()
  let async_dispose_sym = @symbol.Symbol::asyncDispose()
  assert_eq(@core.typeof_(@core.any(sym)), "symbol")
  assert_eq(@core.typeof_(@core.any(iter_sym)), "symbol")
  assert_eq(@core.typeof_(@core.any(dispose_sym)), "symbol")
  assert_eq(@core.typeof_(@core.any(async_dispose_sym)), "symbol")
}

///|
test "Symbol::for_ global registry" {
  let sym1 = @symbol.Symbol::for_("mySymbol")
  let sym2 = @symbol.Symbol::for_("mySymbol")
  assert_eq(@core.typeof_(@core.any(sym1)), "symbol")
  assert_eq(@core.typeof_(@core.any(sym2)), "symbol")
  let sym3 = @symbol.Symbol::for_("differentSymbol")
  assert_eq(@core.typeof_(@core.any(sym3)), "symbol")
}

///|
test "Symbol::asyncIterator" {
  let async_iter_sym = @symbol.Symbol::asyncIterator()
  assert_eq(@core.typeof_(@core.any(async_iter_sym)), "symbol")
}
