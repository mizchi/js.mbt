///|
/// JavaScript Performance API
/// Provides access to performance-related information for the current page

///|
/// Performance interface - provides access to performance-related information
pub(all) struct Performance {
  timeOrigin : Double
}

///|
pub fn Performance::as_any(self : Performance) -> @nostd.Any = "%identity"

///|
/// PerformanceEntry represents a single performance metric
pub(all) struct PerformanceEntry {
  name : String
  entryType : String
  startTime : Double
  duration : Double
}

///|
pub fn PerformanceEntry::as_any(self : PerformanceEntry) -> @nostd.Any = "%identity"

///|
/// Get the Performance object from globalThis
pub fn performance() -> Performance {
  @nostd.global_this()["performance"].cast()
}

///|
/// JS: performance.now()
/// Returns a high resolution timestamp in milliseconds
pub fn Performance::now(self : Performance) -> Double {
  self.as_any()._call("now", []).cast()
}

///|
/// JS: performance.mark(name)
/// Creates a timestamp in the browser's performance entry buffer with the given name
pub fn Performance::mark(self : Performance, name : String) -> PerformanceEntry {
  self.as_any()._call("mark", [@nostd.any(name)]).cast()
}

///|
/// JS: performance.measure(name, startMark?, endMark?)
/// Creates a named timestamp in the browser's performance entry buffer between two marks
pub fn Performance::measure(
  self : Performance,
  name : String,
  startMark? : String,
  endMark? : String,
) -> PerformanceEntry {
  let s = self.as_any()
  match (startMark, endMark) {
    (Some(start), Some(end)) =>
      s
      ._call("measure", [@nostd.any(name), @nostd.any(start), @nostd.any(end)])
      .cast()
    (Some(start), None) =>
      s._call("measure", [@nostd.any(name), @nostd.any(start)]).cast()
    (None, _) => s._call("measure", [@nostd.any(name)]).cast()
  }
}

///|
/// JS: performance.getEntries()
/// Returns a list of all PerformanceEntry objects
pub fn Performance::getEntries(self : Performance) -> Array[PerformanceEntry] {
  self.as_any()._call("getEntries", []).cast()
}

///|
/// JS: performance.getEntriesByType(type)
/// Returns a list of PerformanceEntry objects of the given entry type
pub fn Performance::getEntriesByType(
  self : Performance,
  entryType : String,
) -> Array[PerformanceEntry] {
  self.as_any()._call("getEntriesByType", [@nostd.any(entryType)]).cast()
}

///|
/// JS: performance.getEntriesByName(name)
/// Returns a list of PerformanceEntry objects with the given name
pub fn Performance::getEntriesByName(
  self : Performance,
  name : String,
) -> Array[PerformanceEntry] {
  self.as_any()._call("getEntriesByName", [@nostd.any(name)]).cast()
}

///|
/// JS: performance.clearMarks(name?)
/// Removes marks from the browser's performance entry buffer
pub fn Performance::clearMarks(self : Performance, name? : String) -> Unit {
  let s = self.as_any()
  match name {
    Some(n) => s._call("clearMarks", [@nostd.any(n)]) |> ignore
    None => s._call("clearMarks", []) |> ignore
  }
}

///|
/// JS: performance.clearMeasures(name?)
/// Removes measures from the browser's performance entry buffer
pub fn Performance::clearMeasures(self : Performance, name? : String) -> Unit {
  let s = self.as_any()
  match name {
    Some(n) => s._call("clearMeasures", [@nostd.any(n)]) |> ignore
    None => s._call("clearMeasures", []) |> ignore
  }
}
