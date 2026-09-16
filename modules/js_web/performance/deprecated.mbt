// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `PerformanceObserver(..)` constructor.
#deprecated("use `PerformanceObserver(..)` instead")
pub fn PerformanceObserver::new(
  callback : (PerformanceObserverEntryList, PerformanceObserver) -> Unit,
) -> PerformanceObserver {
  PerformanceObserver(callback)
}
