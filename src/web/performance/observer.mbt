///|
/// PerformanceObserver - observes performance measurement events
#external
pub type PerformanceObserver

///|
pub fn PerformanceObserver::as_any(self : PerformanceObserver) -> @nostd.Any = "%identity"

///|
/// PerformanceObserverEntryList - list of observed performance entries
#external
pub type PerformanceObserverEntryList

///|
pub fn PerformanceObserverEntryList::as_any(
  self : PerformanceObserverEntryList,
) -> @nostd.Any = "%identity"

///|
extern "js" fn ffi_new_performance_observer(
  callback : (@nostd.Any, @nostd.Any) -> Unit,
) -> PerformanceObserver =
  #|(callback) => new PerformanceObserver(callback)

///|
/// JS: new PerformanceObserver(callback)
/// Creates a new PerformanceObserver with the specified callback
/// The callback receives (list, observer) as arguments
pub fn PerformanceObserver::new(
  callback : (PerformanceObserverEntryList, PerformanceObserver) -> Unit,
) -> PerformanceObserver {
  ffi_new_performance_observer(fn(list, observer) {
    callback(@nostd.identity(list), @nostd.identity(observer))
  })
}

///|
/// JS: observer.observe(options)
/// Start observing performance entries
/// Example: observer.observe({ entryTypes: ["measure", "mark"] })
pub fn PerformanceObserver::observe(
  self : PerformanceObserver,
  options : @nostd.Any,
) -> Unit {
  self.as_any()._call("observe", [options]) |> ignore
}

///|
/// JS: observer.disconnect()
/// Stop observing performance entries
pub fn PerformanceObserver::disconnect(self : PerformanceObserver) -> Unit {
  self.as_any()._call("disconnect", []) |> ignore
}

///|
/// JS: observer.takeRecords()
/// Returns the current list of performance entries and clears the buffer
pub fn PerformanceObserver::takeRecords(
  self : PerformanceObserver,
) -> Array[PerformanceEntry] {
  self.as_any()._call("takeRecords", []).cast()
}

///|
/// JS: list.getEntries()
/// Returns all observed performance entries
pub fn PerformanceObserverEntryList::getEntries(
  self : PerformanceObserverEntryList,
) -> Array[PerformanceEntry] {
  self.as_any()._call("getEntries", []).cast()
}

///|
/// JS: list.getEntriesByType(type)
/// Returns observed performance entries of the given type
pub fn PerformanceObserverEntryList::getEntriesByType(
  self : PerformanceObserverEntryList,
  entryType : String,
) -> Array[PerformanceEntry] {
  self.as_any()._call("getEntriesByType", [@nostd.any(entryType)]).cast()
}

///|
/// JS: list.getEntriesByName(name)
/// Returns observed performance entries with the given name
pub fn PerformanceObserverEntryList::getEntriesByName(
  self : PerformanceObserverEntryList,
  name : String,
) -> Array[PerformanceEntry] {
  self.as_any()._call("getEntriesByName", [@nostd.any(name)]).cast()
}
