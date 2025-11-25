///| npm date-fns package FFI bindings
/// https://date-fns.org/
/// https://github.com/date-fns/date-fns

///|
fn date_fns() -> @js.Any {
  @node.require("date-fns")
}

///| Formatting

///|
/// Format a date using a format string
/// https://date-fns.org/docs/format
pub fn format(date : @js.Any, format_str : String) -> String {
  date_fns().call2("format", date, format_str).cast()
}

///|
/// Format a date in ISO 8601 format
#alias(format_iso)
pub fn formatISO(date : @js.Any) -> String {
  date_fns().call1("formatISO", date).cast()
}

///|
/// Format a date relative to now (e.g., "5 minutes ago")
#alias(format_distance)
pub fn formatDistance(date : @js.Any, base_date : @js.Any) -> String {
  date_fns().call2("formatDistance", date, base_date).cast()
}

///|
/// Format a date relative to now with suffix
#alias(format_distance_to_now)
pub fn formatDistanceToNow(date : @js.Any) -> String {
  date_fns().call1("formatDistanceToNow", date).cast()
}

///|
/// Format a date as relative time (e.g., "yesterday", "in 3 days")
#alias(format_relative)
pub fn formatRelative(date : @js.Any, base_date : @js.Any) -> String {
  date_fns().call2("formatRelative", date, base_date).cast()
}

///| Parsing

///|
/// Parse a date string with a format
pub fn parse(
  date_str : String,
  format_str : String,
  reference : @js.Any,
) -> @js.Any {
  date_fns().call("parse", [date_str, format_str, reference])
}

///|
/// Parse an ISO 8601 string
#alias(parse_iso)
pub fn parseISO(date_str : String) -> @js.Any {
  date_fns().call1("parseISO", date_str)
}

///| Comparison

///|
/// Check if date is valid
#alias(is_valid)
pub fn isValid(date : @js.Any) -> Bool {
  date_fns().call1("isValid", date).cast()
}

///|
/// Check if date1 is before date2
#alias(is_before)
pub fn isBefore(date1 : @js.Any, date2 : @js.Any) -> Bool {
  date_fns().call2("isBefore", date1, date2).cast()
}

///|
/// Check if date1 is after date2
#alias(is_after)
pub fn isAfter(date1 : @js.Any, date2 : @js.Any) -> Bool {
  date_fns().call2("isAfter", date1, date2).cast()
}

///|
/// Check if two dates are equal
#alias(is_equal)
pub fn isEqual(date1 : @js.Any, date2 : @js.Any) -> Bool {
  date_fns().call2("isEqual", date1, date2).cast()
}

///|
/// Check if date is same day
#alias(is_same_day)
pub fn isSameDay(date1 : @js.Any, date2 : @js.Any) -> Bool {
  date_fns().call2("isSameDay", date1, date2).cast()
}

///|
/// Check if date is same month
#alias(is_same_month)
pub fn isSameMonth(date1 : @js.Any, date2 : @js.Any) -> Bool {
  date_fns().call2("isSameMonth", date1, date2).cast()
}

///|
/// Check if date is same year
#alias(is_same_year)
pub fn isSameYear(date1 : @js.Any, date2 : @js.Any) -> Bool {
  date_fns().call2("isSameYear", date1, date2).cast()
}

///|
/// Compare two dates (for sorting)
#alias(compare_asc)
pub fn compareAsc(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("compareAsc", date1, date2).cast()
}

///|
/// Compare two dates descending
#alias(compare_desc)
pub fn compareDesc(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("compareDesc", date1, date2).cast()
}

///| Difference calculations

///|
/// Difference in milliseconds
#alias(difference_in_milliseconds)
pub fn differenceInMilliseconds(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("differenceInMilliseconds", date1, date2).cast()
}

///|
/// Difference in seconds
#alias(difference_in_seconds)
pub fn differenceInSeconds(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("differenceInSeconds", date1, date2).cast()
}

///|
/// Difference in minutes
#alias(difference_in_minutes)
pub fn differenceInMinutes(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("differenceInMinutes", date1, date2).cast()
}

///|
/// Difference in hours
#alias(difference_in_hours)
pub fn differenceInHours(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("differenceInHours", date1, date2).cast()
}

///|
/// Difference in days
#alias(difference_in_days)
pub fn differenceInDays(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("differenceInDays", date1, date2).cast()
}

///|
/// Difference in weeks
#alias(difference_in_weeks)
pub fn differenceInWeeks(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("differenceInWeeks", date1, date2).cast()
}

///|
/// Difference in months
#alias(difference_in_months)
pub fn differenceInMonths(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("differenceInMonths", date1, date2).cast()
}

///|
/// Difference in years
#alias(difference_in_years)
pub fn differenceInYears(date1 : @js.Any, date2 : @js.Any) -> Int {
  date_fns().call2("differenceInYears", date1, date2).cast()
}

///| Add / Subtract

///|
/// Add duration to date
pub fn add(
  date : @js.Any,
  years? : Int,
  months? : Int,
  weeks? : Int,
  days? : Int,
  hours? : Int,
  minutes? : Int,
  seconds? : Int,
) -> @js.Any {
  let duration = @js.Object::new()
  match years {
    Some(v) => duration.set("years", v)
    None => ()
  }
  match months {
    Some(v) => duration.set("months", v)
    None => ()
  }
  match weeks {
    Some(v) => duration.set("weeks", v)
    None => ()
  }
  match days {
    Some(v) => duration.set("days", v)
    None => ()
  }
  match hours {
    Some(v) => duration.set("hours", v)
    None => ()
  }
  match minutes {
    Some(v) => duration.set("minutes", v)
    None => ()
  }
  match seconds {
    Some(v) => duration.set("seconds", v)
    None => ()
  }
  date_fns().call2("add", date, duration.to_any())
}

///|
/// Subtract duration from date
pub fn sub(
  date : @js.Any,
  years? : Int,
  months? : Int,
  weeks? : Int,
  days? : Int,
  hours? : Int,
  minutes? : Int,
  seconds? : Int,
) -> @js.Any {
  let duration = @js.Object::new()
  match years {
    Some(v) => duration.set("years", v)
    None => ()
  }
  match months {
    Some(v) => duration.set("months", v)
    None => ()
  }
  match weeks {
    Some(v) => duration.set("weeks", v)
    None => ()
  }
  match days {
    Some(v) => duration.set("days", v)
    None => ()
  }
  match hours {
    Some(v) => duration.set("hours", v)
    None => ()
  }
  match minutes {
    Some(v) => duration.set("minutes", v)
    None => ()
  }
  match seconds {
    Some(v) => duration.set("seconds", v)
    None => ()
  }
  date_fns().call2("sub", date, duration.to_any())
}

///|
/// Add days
#alias(add_days)
pub fn addDays(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("addDays", date, amount)
}

///|
/// Sub days
#alias(sub_days)
pub fn subDays(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("subDays", date, amount)
}

///|
/// Add months
#alias(add_months)
pub fn addMonths(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("addMonths", date, amount)
}

///|
/// Sub months
#alias(sub_months)
pub fn subMonths(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("subMonths", date, amount)
}

///|
/// Add years
#alias(add_years)
pub fn addYears(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("addYears", date, amount)
}

///|
/// Sub years
#alias(sub_years)
pub fn subYears(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("subYears", date, amount)
}

///|
/// Add hours
#alias(add_hours)
pub fn addHours(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("addHours", date, amount)
}

///|
/// Sub hours
#alias(sub_hours)
pub fn subHours(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("subHours", date, amount)
}

///|
/// Add minutes
#alias(add_minutes)
pub fn addMinutes(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("addMinutes", date, amount)
}

///|
/// Sub minutes
#alias(sub_minutes)
pub fn subMinutes(date : @js.Any, amount : Int) -> @js.Any {
  date_fns().call2("subMinutes", date, amount)
}

///| Getters

///|
/// Get year
#alias(get_year)
pub fn getYear(date : @js.Any) -> Int {
  date_fns().call1("getYear", date).cast()
}

///|
/// Get month (0-11)
#alias(get_month)
pub fn getMonth(date : @js.Any) -> Int {
  date_fns().call1("getMonth", date).cast()
}

///|
/// Get date (day of month)
#alias(get_date)
pub fn getDate(date : @js.Any) -> Int {
  date_fns().call1("getDate", date).cast()
}

///|
/// Get day of week (0-6)
#alias(get_day)
pub fn getDay(date : @js.Any) -> Int {
  date_fns().call1("getDay", date).cast()
}

///|
/// Get hours
#alias(get_hours)
pub fn getHours(date : @js.Any) -> Int {
  date_fns().call1("getHours", date).cast()
}

///|
/// Get minutes
#alias(get_minutes)
pub fn getMinutes(date : @js.Any) -> Int {
  date_fns().call1("getMinutes", date).cast()
}

///|
/// Get seconds
#alias(get_seconds)
pub fn getSeconds(date : @js.Any) -> Int {
  date_fns().call1("getSeconds", date).cast()
}

///|
/// Get Unix timestamp (seconds)
#alias(get_unix_time)
pub fn getUnixTime(date : @js.Any) -> Int {
  date_fns().call1("getUnixTime", date).cast()
}

///|
/// Get time in milliseconds
#alias(get_time)
pub fn getTime(date : @js.Any) -> Int {
  date_fns().call1("getTime", date).cast()
}

///| Setters

///|
/// Set year
#alias(set_year)
pub fn setYear(date : @js.Any, year : Int) -> @js.Any {
  date_fns().call2("setYear", date, year)
}

///|
/// Set month
#alias(set_month)
pub fn setMonth(date : @js.Any, month : Int) -> @js.Any {
  date_fns().call2("setMonth", date, month)
}

///|
/// Set date (day of month)
#alias(set_date)
pub fn setDate(date : @js.Any, day : Int) -> @js.Any {
  date_fns().call2("setDate", date, day)
}

///|
/// Set hours
#alias(set_hours)
pub fn setHours(date : @js.Any, hours : Int) -> @js.Any {
  date_fns().call2("setHours", date, hours)
}

///|
/// Set minutes
#alias(set_minutes)
pub fn setMinutes(date : @js.Any, minutes : Int) -> @js.Any {
  date_fns().call2("setMinutes", date, minutes)
}

///|
/// Set seconds
#alias(set_seconds)
pub fn setSeconds(date : @js.Any, seconds : Int) -> @js.Any {
  date_fns().call2("setSeconds", date, seconds)
}

///| Start/End of period

///|
/// Start of day
#alias(start_of_day)
pub fn startOfDay(date : @js.Any) -> @js.Any {
  date_fns().call1("startOfDay", date)
}

///|
/// End of day
#alias(end_of_day)
pub fn endOfDay(date : @js.Any) -> @js.Any {
  date_fns().call1("endOfDay", date)
}

///|
/// Start of month
#alias(start_of_month)
pub fn startOfMonth(date : @js.Any) -> @js.Any {
  date_fns().call1("startOfMonth", date)
}

///|
/// End of month
#alias(end_of_month)
pub fn endOfMonth(date : @js.Any) -> @js.Any {
  date_fns().call1("endOfMonth", date)
}

///|
/// Start of year
#alias(start_of_year)
pub fn startOfYear(date : @js.Any) -> @js.Any {
  date_fns().call1("startOfYear", date)
}

///|
/// End of year
#alias(end_of_year)
pub fn endOfYear(date : @js.Any) -> @js.Any {
  date_fns().call1("endOfYear", date)
}

///|
/// Start of week
#alias(start_of_week)
pub fn startOfWeek(date : @js.Any) -> @js.Any {
  date_fns().call1("startOfWeek", date)
}

///|
/// End of week
#alias(end_of_week)
pub fn endOfWeek(date : @js.Any) -> @js.Any {
  date_fns().call1("endOfWeek", date)
}

///| Helpers

///|
/// Create a new Date from timestamp
#alias(from_unix_time)
pub fn fromUnixTime(timestamp : Int) -> @js.Any {
  date_fns().call1("fromUnixTime", timestamp)
}

///|
extern "js" fn ffi_new_date() -> @js.Any =
  #| () => new Date()

///|
extern "js" fn ffi_new_date_from_time(time : Int) -> @js.Any =
  #| (time) => new Date(time)

///|
extern "js" fn ffi_new_date_ymd(year : Int, month : Int, day : Int) -> @js.Any =
  #| (year, month, day) => new Date(year, month, day)

///|
/// Create current date
pub fn now() -> @js.Any {
  ffi_new_date()
}

///|
/// Create date from timestamp (milliseconds)
#alias(from_time)
pub fn fromTime(time : Int) -> @js.Any {
  ffi_new_date_from_time(time)
}

///|
/// Create date from year, month (0-11), day
#alias(from_ymd)
pub fn fromYMD(year : Int, month : Int, day : Int) -> @js.Any {
  ffi_new_date_ymd(year, month, day)
}
