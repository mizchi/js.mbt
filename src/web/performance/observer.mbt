///|
/// PerformanceObserver - observes performance measurement events
#external
pub type PerformanceObserver

///|
pub impl @js.JsImpl for PerformanceObserver

///|
/// PerformanceObserverEntryList - list of observed performance entries
#external
pub type PerformanceObserverEntryList

///|
pub impl @js.JsImpl for PerformanceObserverEntryList

///|
extern "js" fn ffi_new_performance_observer(
  callback : (@js.Js, @js.Js) -> Unit,
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
    callback(@js.identity(list), @js.identity(observer))
  })
}

///|
/// JS: observer.observe(options)
/// Start observing performance entries
/// Example: observer.observe({ entryTypes: ["measure", "mark"] })
pub fn PerformanceObserver::observe(
  self : PerformanceObserver,
  options : @js.Object,
) -> Unit {
  self.call("observe", [options]) |> ignore
}

///|
/// JS: observer.disconnect()
/// Stop observing performance entries
pub fn PerformanceObserver::disconnect(self : PerformanceObserver) -> Unit {
  self.call0("disconnect") |> ignore
}

///|
/// JS: observer.takeRecords()
/// Returns the current list of performance entries and clears the buffer
pub fn PerformanceObserver::takeRecords(
  self : PerformanceObserver,
) -> Array[PerformanceEntry] {
  self.call0("takeRecords") |> @js.identity
}

///|
/// JS: list.getEntries()
/// Returns all observed performance entries
pub fn PerformanceObserverEntryList::getEntries(
  self : PerformanceObserverEntryList,
) -> Array[PerformanceEntry] {
  self.call0("getEntries") |> @js.identity
}

///|
/// JS: list.getEntriesByType(type)
/// Returns observed performance entries of the given type
pub fn PerformanceObserverEntryList::getEntriesByType(
  self : PerformanceObserverEntryList,
  entryType : String,
) -> Array[PerformanceEntry] {
  self.call("getEntriesByType", [entryType]).cast()
}

///|
/// JS: list.getEntriesByName(name)
/// Returns observed performance entries with the given name
pub fn PerformanceObserverEntryList::getEntriesByName(
  self : PerformanceObserverEntryList,
  name : String,
) -> Array[PerformanceEntry] {
  self.call("getEntriesByName", [name]).cast()
}
