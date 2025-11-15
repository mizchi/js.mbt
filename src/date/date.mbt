///|
/// JavaScript Date object wrapper.
///
/// Represents a single moment in time in a platform-independent format.
/// Corresponds to JavaScript's `Date` constructor and object.
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date
#external
pub type Date

///|
pub impl Js for Date

///|
/// Get the current time in milliseconds since Unix epoch (January 1, 1970, 00:00:00 UTC).
///
/// JavaScript API: `Date.now()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/now
pub extern "js" fn Date::now() -> Int =
  #| () => Date.now()

///|
/// Create a new Date object with the current date and time.
///
/// JavaScript API: `new Date()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date
pub extern "js" fn Date::new() -> Date =
  #| () => new Date()

///|
/// Create a new Date object from milliseconds since Unix epoch.
///
/// JavaScript API: `new Date(value)`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date
pub extern "js" fn Date::from_millis(value : Int) -> Date =
  #| (value) => new Date(value)

///|
/// Create a new Date object from a date string.
///
/// JavaScript API: `new Date(dateString)`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date
pub extern "js" fn Date::from_string(date_string : String) -> Date =
  #| (dateString) => new Date(dateString)

///|
/// Create a new Date object from individual date components (year, month, day).
///
/// JavaScript API: `new Date(year, monthIndex, day)`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date
pub extern "js" fn Date::from_ymd(year : Int, month : Int, day : Int) -> Date =
  #| (year, month, day) => new Date(year, month, day)

///|
/// Create a new Date object from individual date and time components.
///
/// JavaScript API: `new Date(year, monthIndex, day, hours, minutes, seconds, milliseconds)`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date
pub extern "js" fn Date::from_ymdhms(
  year : Int,
  month : Int,
  day : Int,
  hours : Int,
  minutes : Int,
  seconds : Int,
) -> Date =
  #| (year, month, day, hours, minutes, seconds) => new Date(year, month, day, hours, minutes, seconds)

///|
/// Create a new Date object from full date and time components including milliseconds.
///
/// JavaScript API: `new Date(year, monthIndex, day, hours, minutes, seconds, milliseconds)`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date
pub extern "js" fn Date::from_full(
  year : Int,
  month : Int,
  day : Int,
  hours : Int,
  minutes : Int,
  seconds : Int,
  milliseconds : Int,
) -> Date =
  #| (year, month, day, hours, minutes, seconds, milliseconds) => new Date(year, month, day, hours, minutes, seconds, milliseconds)

///|
/// Parse a date string and return milliseconds since Unix epoch.
///
/// JavaScript API: `Date.parse()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/parse
pub extern "js" fn Date::parse(date_string : String) -> Int =
  #| (dateString) => Date.parse(dateString)

///|
/// Create a Date from UTC time components.
///
/// JavaScript API: `Date.UTC()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/UTC
pub extern "js" fn Date::utc(
  year : Int,
  month : Int,
  day : Int,
  hours : Int,
  minutes : Int,
  seconds : Int,
  milliseconds : Int,
) -> Int =
  #| (year, month, day, hours, minutes, seconds, milliseconds) => Date.UTC(year, month, day, hours, minutes, seconds, milliseconds)

///|
/// Get the day of the month (1-31) for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.getDate()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getDate
pub extern "js" fn Date::get_date(self : Date) -> Int =
  #| (date) => date.getDate()

///|
/// Get the day of the week (0-6) for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.getDay()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getDay
pub extern "js" fn Date::get_day(self : Date) -> Int =
  #| (date) => date.getDay()

///|
/// Get the year (4 digits) of the specified date according to local time.
///
/// JavaScript API: `Date.prototype.getFullYear()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getFullYear
pub extern "js" fn Date::get_full_year(self : Date) -> Int =
  #| (date) => date.getFullYear()

///|
/// Get the hours (0-23) for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.getHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getHours
pub extern "js" fn Date::get_hours(self : Date) -> Int =
  #| (date) => date.getHours()

///|
/// Get the milliseconds (0-999) for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.getMilliseconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getMilliseconds
pub extern "js" fn Date::get_milliseconds(self : Date) -> Int =
  #| (date) => date.getMilliseconds()

///|
/// Get the minutes (0-59) for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.getMinutes()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getMinutes
pub extern "js" fn Date::get_minutes(self : Date) -> Int =
  #| (date) => date.getMinutes()

///|
/// Get the month (0-11) for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.getMonth()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getMonth
pub extern "js" fn Date::get_month(self : Date) -> Int =
  #| (date) => date.getMonth()

///|
/// Get the seconds (0-59) for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.getSeconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getSeconds
pub extern "js" fn Date::get_seconds(self : Date) -> Int =
  #| (date) => date.getSeconds()

///|
/// Get the time value in milliseconds since Unix epoch.
///
/// JavaScript API: `Date.prototype.getTime()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getTime
pub extern "js" fn Date::get_time(self : Date) -> Int =
  #| (date) => date.getTime()

///|
/// Get the timezone offset in minutes from UTC.
///
/// JavaScript API: `Date.prototype.getTimezoneOffset()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getTimezoneOffset
pub extern "js" fn Date::get_timezone_offset(self : Date) -> Int =
  #| (date) => date.getTimezoneOffset()

///|
/// Get the day of the month (1-31) for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.getUTCDate()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getUTCDate
pub extern "js" fn Date::get_utc_date(self : Date) -> Int =
  #| (date) => date.getUTCDate()

///|
/// Get the day of the week (0-6) for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.getUTCDay()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getUTCDay
pub extern "js" fn Date::get_utc_day(self : Date) -> Int =
  #| (date) => date.getUTCDay()

///|
/// Get the year (4 digits) of the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.getUTCFullYear()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getUTCFullYear
pub extern "js" fn Date::get_utc_full_year(self : Date) -> Int =
  #| (date) => date.getUTCFullYear()

///|
/// Get the hours (0-23) for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.getUTCHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getUTCHours
pub extern "js" fn Date::get_utc_hours(self : Date) -> Int =
  #| (date) => date.getUTCHours()

///|
/// Get the milliseconds (0-999) for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.getUTCMilliseconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getUTCMilliseconds
pub extern "js" fn Date::get_utc_milliseconds(self : Date) -> Int =
  #| (date) => date.getUTCMilliseconds()

///|
/// Get the minutes (0-59) for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.getUTCMinutes()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getUTCMinutes
pub extern "js" fn Date::get_utc_minutes(self : Date) -> Int =
  #| (date) => date.getUTCMinutes()

///|
/// Get the month (0-11) for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.getUTCMonth()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getUTCMonth
pub extern "js" fn Date::get_utc_month(self : Date) -> Int =
  #| (date) => date.getUTCMonth()

///|
/// Get the seconds (0-59) for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.getUTCSeconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getUTCSeconds
pub extern "js" fn Date::get_utc_seconds(self : Date) -> Int =
  #| (date) => date.getUTCSeconds()

///|
/// Set the day of the month for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.setDate()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setDate
pub extern "js" fn Date::set_date(self : Date, day : Int) -> Int =
  #| (date, day) => date.setDate(day)

///|
/// Set the full year for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.setFullYear()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setFullYear
pub extern "js" fn Date::set_full_year(
  self : Date,
  year : Int,
  month : Int,
  day : Int,
) -> Int =
  #| (date, year, month, day) => date.setFullYear(year, month, day)

///|
/// Set the full year for the specified date according to local time (with optional month).
///
/// JavaScript API: `Date.prototype.setFullYear()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setFullYear
pub extern "js" fn Date::set_full_year_ym(
  self : Date,
  year : Int,
  month : Int,
) -> Int =
  #| (date, year, month) => date.setFullYear(year, month)

///|
/// Set the full year for the specified date according to local time (year only).
///
/// JavaScript API: `Date.prototype.setFullYear()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setFullYear
pub extern "js" fn Date::set_full_year_y(self : Date, year : Int) -> Int =
  #| (date, year) => date.setFullYear(year)

///|
/// Set the hours for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.setHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setHours
pub extern "js" fn Date::set_hours(
  self : Date,
  hours : Int,
  minutes : Int,
  seconds : Int,
  milliseconds : Int,
) -> Int =
  #| (date, hours, minutes, seconds, milliseconds) => date.setHours(hours, minutes, seconds, milliseconds)

///|
/// Set the hours for the specified date according to local time (with minutes, seconds).
///
/// JavaScript API: `Date.prototype.setHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setHours
pub extern "js" fn Date::set_hours_hms(
  self : Date,
  hours : Int,
  minutes : Int,
  seconds : Int,
) -> Int =
  #| (date, hours, minutes, seconds) => date.setHours(hours, minutes, seconds)

///|
/// Set the hours for the specified date according to local time (with minutes).
///
/// JavaScript API: `Date.prototype.setHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setHours
pub extern "js" fn Date::set_hours_hm(
  self : Date,
  hours : Int,
  minutes : Int,
) -> Int =
  #| (date, hours, minutes) => date.setHours(hours, minutes)

///|
/// Set the hours for the specified date according to local time (hours only).
///
/// JavaScript API: `Date.prototype.setHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setHours
pub extern "js" fn Date::set_hours_h(self : Date, hours : Int) -> Int =
  #| (date, hours) => date.setHours(hours)

///|
/// Set the milliseconds for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.setMilliseconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setMilliseconds
pub extern "js" fn Date::set_milliseconds(
  self : Date,
  milliseconds : Int,
) -> Int =
  #| (date, milliseconds) => date.setMilliseconds(milliseconds)

///|
/// Set the minutes for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.setMinutes()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setMinutes
pub extern "js" fn Date::set_minutes(
  self : Date,
  minutes : Int,
  seconds : Int,
  milliseconds : Int,
) -> Int =
  #| (date, minutes, seconds, milliseconds) => date.setMinutes(minutes, seconds, milliseconds)

///|
/// Set the minutes for the specified date according to local time (with seconds).
///
/// JavaScript API: `Date.prototype.setMinutes()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setMinutes
pub extern "js" fn Date::set_minutes_ms(
  self : Date,
  minutes : Int,
  seconds : Int,
) -> Int =
  #| (date, minutes, seconds) => date.setMinutes(minutes, seconds)

///|
/// Set the minutes for the specified date according to local time (minutes only).
///
/// JavaScript API: `Date.prototype.setMinutes()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setMinutes
pub extern "js" fn Date::set_minutes_m(self : Date, minutes : Int) -> Int =
  #| (date, minutes) => date.setMinutes(minutes)

///|
/// Set the month for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.setMonth()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setMonth
pub extern "js" fn Date::set_month(self : Date, month : Int, day : Int) -> Int =
  #| (date, month, day) => date.setMonth(month, day)

///|
/// Set the month for the specified date according to local time (month only).
///
/// JavaScript API: `Date.prototype.setMonth()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setMonth
pub extern "js" fn Date::set_month_m(self : Date, month : Int) -> Int =
  #| (date, month) => date.setMonth(month)

///|
/// Set the seconds for the specified date according to local time.
///
/// JavaScript API: `Date.prototype.setSeconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setSeconds
pub extern "js" fn Date::set_seconds(
  self : Date,
  seconds : Int,
  milliseconds : Int,
) -> Int =
  #| (date, seconds, milliseconds) => date.setSeconds(seconds, milliseconds)

///|
/// Set the seconds for the specified date according to local time (seconds only).
///
/// JavaScript API: `Date.prototype.setSeconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setSeconds
pub extern "js" fn Date::set_seconds_s(self : Date, seconds : Int) -> Int =
  #| (date, seconds) => date.setSeconds(seconds)

///|
/// Set the time value in milliseconds since Unix epoch.
///
/// JavaScript API: `Date.prototype.setTime()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setTime
pub extern "js" fn Date::set_time(self : Date, time : Int) -> Int =
  #| (date, time) => date.setTime(time)

///|
/// Set the day of the month for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.setUTCDate()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCDate
pub extern "js" fn Date::set_utc_date(self : Date, day : Int) -> Int =
  #| (date, day) => date.setUTCDate(day)

///|
/// Set the full year for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.setUTCFullYear()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCFullYear
pub extern "js" fn Date::set_utc_full_year(
  self : Date,
  year : Int,
  month : Int,
  day : Int,
) -> Int =
  #| (date, year, month, day) => date.setUTCFullYear(year, month, day)

///|
/// Set the full year for the specified date according to UTC (with optional month).
///
/// JavaScript API: `Date.prototype.setUTCFullYear()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCFullYear
pub extern "js" fn Date::set_utc_full_year_ym(
  self : Date,
  year : Int,
  month : Int,
) -> Int =
  #| (date, year, month) => date.setUTCFullYear(year, month)

///|
/// Set the full year for the specified date according to UTC (year only).
///
/// JavaScript API: `Date.prototype.setUTCFullYear()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCFullYear
pub extern "js" fn Date::set_utc_full_year_y(self : Date, year : Int) -> Int =
  #| (date, year) => date.setUTCFullYear(year)

///|
/// Set the hours for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.setUTCHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCHours
pub extern "js" fn Date::set_utc_hours(
  self : Date,
  hours : Int,
  minutes : Int,
  seconds : Int,
  milliseconds : Int,
) -> Int =
  #| (date, hours, minutes, seconds, milliseconds) => date.setUTCHours(hours, minutes, seconds, milliseconds)

///|
/// Set the hours for the specified date according to UTC (with minutes, seconds).
///
/// JavaScript API: `Date.prototype.setUTCHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCHours
pub extern "js" fn Date::set_utc_hours_hms(
  self : Date,
  hours : Int,
  minutes : Int,
  seconds : Int,
) -> Int =
  #| (date, hours, minutes, seconds) => date.setUTCHours(hours, minutes, seconds)

///|
/// Set the hours for the specified date according to UTC (with minutes).
///
/// JavaScript API: `Date.prototype.setUTCHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCHours
pub extern "js" fn Date::set_utc_hours_hm(
  self : Date,
  hours : Int,
  minutes : Int,
) -> Int =
  #| (date, hours, minutes) => date.setUTCHours(hours, minutes)

///|
/// Set the hours for the specified date according to UTC (hours only).
///
/// JavaScript API: `Date.prototype.setUTCHours()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCHours
pub extern "js" fn Date::set_utc_hours_h(self : Date, hours : Int) -> Int =
  #| (date, hours) => date.setUTCHours(hours)

///|
/// Set the milliseconds for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.setUTCMilliseconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCMilliseconds
pub extern "js" fn Date::set_utc_milliseconds(
  self : Date,
  milliseconds : Int,
) -> Int =
  #| (date, milliseconds) => date.setUTCMilliseconds(milliseconds)

///|
/// Set the minutes for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.setUTCMinutes()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCMinutes
pub extern "js" fn Date::set_utc_minutes(
  self : Date,
  minutes : Int,
  seconds : Int,
  milliseconds : Int,
) -> Int =
  #| (date, minutes, seconds, milliseconds) => date.setUTCMinutes(minutes, seconds, milliseconds)

///|
/// Set the minutes for the specified date according to UTC (with seconds).
///
/// JavaScript API: `Date.prototype.setUTCMinutes()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCMinutes
pub extern "js" fn Date::set_utc_minutes_ms(
  self : Date,
  minutes : Int,
  seconds : Int,
) -> Int =
  #| (date, minutes, seconds) => date.setUTCMinutes(minutes, seconds)

///|
/// Set the minutes for the specified date according to UTC (minutes only).
///
/// JavaScript API: `Date.prototype.setUTCMinutes()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCMinutes
pub extern "js" fn Date::set_utc_minutes_m(self : Date, minutes : Int) -> Int =
  #| (date, minutes) => date.setUTCMinutes(minutes)

///|
/// Set the month for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.setUTCMonth()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCMonth
pub extern "js" fn Date::set_utc_month(
  self : Date,
  month : Int,
  day : Int,
) -> Int =
  #| (date, month, day) => date.setUTCMonth(month, day)

///|
/// Set the month for the specified date according to UTC (month only).
///
/// JavaScript API: `Date.prototype.setUTCMonth()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCMonth
pub extern "js" fn Date::set_utc_month_m(self : Date, month : Int) -> Int =
  #| (date, month) => date.setUTCMonth(month)

///|
/// Set the seconds for the specified date according to UTC.
///
/// JavaScript API: `Date.prototype.setUTCSeconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCSeconds
pub extern "js" fn Date::set_utc_seconds(
  self : Date,
  seconds : Int,
  milliseconds : Int,
) -> Int =
  #| (date, seconds, milliseconds) => date.setUTCSeconds(seconds, milliseconds)

///|
/// Set the seconds for the specified date according to UTC (seconds only).
///
/// JavaScript API: `Date.prototype.setUTCSeconds()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/setUTCSeconds
pub extern "js" fn Date::set_utc_seconds_s(self : Date, seconds : Int) -> Int =
  #| (date, seconds) => date.setUTCSeconds(seconds)

///|
/// Convert the date to a string in ISO 8601 format.
///
/// JavaScript API: `Date.prototype.toISOString()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toISOString
pub extern "js" fn Date::to_iso_string(self : Date) -> String =
  #| (date) => date.toISOString()

///|
/// Convert the date to a JSON string representation.
///
/// JavaScript API: `Date.prototype.toJSON()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toJSON
pub extern "js" fn Date::to_json(self : Date) -> String =
  #| (date) => date.toJSON()

///|
/// Convert the date to a string representing the date portion in the current locale.
///
/// JavaScript API: `Date.prototype.toLocaleDateString()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleDateString
pub extern "js" fn Date::to_locale_date_string(self : Date) -> String =
  #| (date) => date.toLocaleDateString()

///|
/// Convert the date to a string in the current locale.
///
/// JavaScript API: `Date.prototype.toLocaleString()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleString
pub extern "js" fn Date::to_locale_string(self : Date) -> String =
  #| (date) => date.toLocaleString()

///|
/// Convert the date to a string representing the time portion in the current locale.
///
/// JavaScript API: `Date.prototype.toLocaleTimeString()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleTimeString
pub extern "js" fn Date::to_locale_time_string(self : Date) -> String =
  #| (date) => date.toLocaleTimeString()

///|
/// Convert the date to a human-readable string.
///
/// JavaScript API: `Date.prototype.toString()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toString
pub extern "js" fn Date::to_string(self : Date) -> String =
  #| (date) => date.toString()

///|
/// Convert the date to a string representing the date portion.
///
/// JavaScript API: `Date.prototype.toDateString()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toDateString
pub extern "js" fn Date::to_date_string(self : Date) -> String =
  #| (date) => date.toDateString()

///|
/// Convert the date to a string representing the time portion.
///
/// JavaScript API: `Date.prototype.toTimeString()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toTimeString
pub extern "js" fn Date::to_time_string(self : Date) -> String =
  #| (date) => date.toTimeString()

///|
/// Convert the date to a string in UTC format.
///
/// JavaScript API: `Date.prototype.toUTCString()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toUTCString
pub extern "js" fn Date::to_utc_string(self : Date) -> String =
  #| (date) => date.toUTCString()

///|
/// Get the primitive value of the Date object (milliseconds since Unix epoch).
///
/// JavaScript API: `Date.prototype.valueOf()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/valueOf
pub extern "js" fn Date::value_of(self : Date) -> Int =
  #| (date) => date.valueOf()
