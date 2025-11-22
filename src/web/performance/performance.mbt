///|
/// JavaScript Performance API
/// Provides access to performance-related information for the current page

///|
/// Performance interface - provides access to performance-related information
pub(all) struct Performance {
  timeOrigin : Double
}

///|
pub impl @js.JsImpl for Performance

///|
/// PerformanceEntry represents a single performance metric
pub(all) struct PerformanceEntry {
  name : String
  entryType : String
  startTime : Double
  duration : Double
}

///|
pub impl @js.JsImpl for PerformanceEntry

///|
/// Get the Performance object from globalThis
pub fn performance() -> Performance {
  @js.global_this().get("performance") |> @js.unsafe_cast
}

///|
/// JS: performance.now()
/// Returns a high resolution timestamp in milliseconds
pub fn Performance::now(self : Performance) -> Double {
  self.call0("now") |> @js.unsafe_cast
}

///|
/// JS: performance.mark(name)
/// Creates a timestamp in the browser's performance entry buffer with the given name
pub fn Performance::mark(self : Performance, name : String) -> PerformanceEntry {
  self.call("mark", [name]) |> @js.unsafe_cast
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
  match (startMark, endMark) {
    (Some(s), Some(e)) => self.call("measure", [name, s, e]) |> @js.unsafe_cast
    (Some(s), None) => self.call2("measure", name, s) |> @js.unsafe_cast
    (None, _) => self.call("measure", [name]) |> @js.unsafe_cast
  }
}

///|
/// JS: performance.getEntries()
/// Returns a list of all PerformanceEntry objects
pub fn Performance::getEntries(self : Performance) -> Array[PerformanceEntry] {
  self.call0("getEntries") |> @js.unsafe_cast
}

///|
/// JS: performance.getEntriesByType(type)
/// Returns a list of PerformanceEntry objects of the given entry type
pub fn Performance::getEntriesByType(
  self : Performance,
  entryType : String,
) -> Array[PerformanceEntry] {
  self.call("getEntriesByType", [entryType]) |> @js.unsafe_cast
}

///|
/// JS: performance.getEntriesByName(name)
/// Returns a list of PerformanceEntry objects with the given name
pub fn Performance::getEntriesByName(
  self : Performance,
  name : String,
) -> Array[PerformanceEntry] {
  self.call("getEntriesByName", [name]) |> @js.unsafe_cast
}

///|
/// JS: performance.clearMarks(name?)
/// Removes marks from the browser's performance entry buffer
pub fn Performance::clearMarks(self : Performance, name? : String) -> Unit {
  match name {
    Some(n) => self.call("clearMarks", [n]) |> ignore
    None => self.call0("clearMarks") |> ignore
  }
}

///|
/// JS: performance.clearMeasures(name?)
/// Removes measures from the browser's performance entry buffer
pub fn Performance::clearMeasures(self : Performance, name? : String) -> Unit {
  match name {
    Some(n) => self.call("clearMeasures", [n]) |> ignore
    None => self.call0("clearMeasures") |> ignore
  }
}
