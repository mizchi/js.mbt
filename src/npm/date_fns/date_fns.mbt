///| npm date-fns package FFI bindings
/// https://date-fns.org/
/// https://github.com/date-fns/date-fns

///|
fn date_fns() -> @js.Any {
  @node.require("date-fns")
}

///|
pub(open) trait DateArgs {
  to_date(Self) -> @js.Any = _
}

///|
impl DateArgs with to_date(self) {
  self |> @js.identity
}

///|
pub impl DateArgs for String

///|
pub impl DateArgs for Int

///|
pub impl DateArgs for @date.Date

///| Formatting

///|
/// Format a date using a format string
/// https://date-fns.org/docs/format
pub fn format(date : &DateArgs, format_str : String) -> String {
  date_fns().call2("format", date.to_date(), format_str).cast()
}

///|
/// Format a date in ISO 8601 format
#alias(format_iso)
pub fn formatISO(date : &DateArgs) -> String {
  date_fns().call1("formatISO", date.to_date()).cast()
}

///|
/// Format a date relative to now (e.g., "5 minutes ago")
#alias(format_distance)
pub fn formatDistance(date : &DateArgs, base_date : &DateArgs) -> String {
  date_fns().call2("formatDistance", date.to_date(), base_date.to_date()).cast()
}

///|
/// Format a date relative to now with suffix
#alias(format_distance_to_now)
pub fn formatDistanceToNow(date : &DateArgs) -> String {
  date_fns().call1("formatDistanceToNow", date.to_date()).cast()
}

///|
/// Format a date as relative time (e.g., "yesterday", "in 3 days")
#alias(format_relative)
pub fn formatRelative(date : &DateArgs, base_date : &DateArgs) -> String {
  date_fns().call2("formatRelative", date.to_date(), base_date.to_date()).cast()
}

///| Parsing

///|
/// Parse a date string with a format
pub fn parse(
  date_str : String,
  format_str : String,
  reference : &DateArgs,
) -> @date.Date {
  date_fns().call("parse", [date_str, format_str, reference.to_date()]).cast()
}

///|
/// Parse an ISO 8601 string
#alias(parse_iso)
pub fn parseISO(date_str : String) -> @date.Date {
  date_fns().call1("parseISO", date_str).cast()
}

///| Comparison

///|
/// Check if date is valid
#alias(is_valid)
pub fn isValid(date : &DateArgs) -> Bool {
  date_fns().call1("isValid", date.to_date()).cast()
}

///|
/// Check if date1 is before date2
#alias(is_before)
pub fn isBefore(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  date_fns().call2("isBefore", date1.to_date(), date2.to_date()).cast()
}

///|
/// Check if date1 is after date2
#alias(is_after)
pub fn isAfter(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  date_fns().call2("isAfter", date1.to_date(), date2.to_date()).cast()
}

///|
/// Check if two dates are equal
#alias(is_equal)
pub fn isEqual(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  date_fns().call2("isEqual", date1.to_date(), date2.to_date()).cast()
}

///|
/// Check if date is same day
#alias(is_same_day)
pub fn isSameDay(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  date_fns().call2("isSameDay", date1.to_date(), date2.to_date()).cast()
}

///|
/// Check if date is same month
#alias(is_same_month)
pub fn isSameMonth(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  date_fns().call2("isSameMonth", date1.to_date(), date2.to_date()).cast()
}

///|
/// Check if date is same year
#alias(is_same_year)
pub fn isSameYear(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  date_fns().call2("isSameYear", date1.to_date(), date2.to_date()).cast()
}

///|
/// Compare two dates (for sorting)
#alias(compare_asc)
pub fn compareAsc(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns().call2("compareAsc", date1.to_date(), date2.to_date()).cast()
}

///|
/// Compare two dates descending
#alias(compare_desc)
pub fn compareDesc(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns().call2("compareDesc", date1.to_date(), date2.to_date()).cast()
}

///| Difference calculations

///|
/// Difference in milliseconds
#alias(difference_in_milliseconds)
pub fn differenceInMilliseconds(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns()
  .call2("differenceInMilliseconds", date1.to_date(), date2.to_date())
  .cast()
}

///|
/// Difference in seconds
#alias(difference_in_seconds)
pub fn differenceInSeconds(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns()
  .call2("differenceInSeconds", date1.to_date(), date2.to_date())
  .cast()
}

///|
/// Difference in minutes
#alias(difference_in_minutes)
pub fn differenceInMinutes(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns()
  .call2("differenceInMinutes", date1.to_date(), date2.to_date())
  .cast()
}

///|
/// Difference in hours
#alias(difference_in_hours)
pub fn differenceInHours(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns().call2("differenceInHours", date1.to_date(), date2.to_date()).cast()
}

///|
/// Difference in days
#alias(difference_in_days)
pub fn differenceInDays(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns().call2("differenceInDays", date1.to_date(), date2.to_date()).cast()
}

///|
/// Difference in weeks
#alias(difference_in_weeks)
pub fn differenceInWeeks(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns().call2("differenceInWeeks", date1.to_date(), date2.to_date()).cast()
}

///|
/// Difference in months
#alias(difference_in_months)
pub fn differenceInMonths(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns()
  .call2("differenceInMonths", date1.to_date(), date2.to_date())
  .cast()
}

///|
/// Difference in years
#alias(difference_in_years)
pub fn differenceInYears(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  date_fns().call2("differenceInYears", date1.to_date(), date2.to_date()).cast()
}

///| Add / Subtract

///|
/// Add duration to date
pub fn add(
  date : &DateArgs,
  years? : Int,
  months? : Int,
  weeks? : Int,
  days? : Int,
  hours? : Int,
  minutes? : Int,
  seconds? : Int,
) -> @date.Date {
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
  date_fns().call2("add", date.to_date(), duration.as_any()).cast()
}

///|
/// Subtract duration from date
pub fn sub(
  date : &DateArgs,
  years? : Int,
  months? : Int,
  weeks? : Int,
  days? : Int,
  hours? : Int,
  minutes? : Int,
  seconds? : Int,
) -> @date.Date {
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
  date_fns().call2("sub", date.to_date(), duration.as_any()).cast()
}

///|
/// Add days
#alias(add_days)
pub fn addDays(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("addDays", date.to_date(), amount).cast()
}

///|
/// Sub days
#alias(sub_days)
pub fn subDays(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("subDays", date.to_date(), amount).cast()
}

///|
/// Add months
#alias(add_months)
pub fn addMonths(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("addMonths", date.to_date(), amount).cast()
}

///|
/// Sub months
#alias(sub_months)
pub fn subMonths(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("subMonths", date.to_date(), amount).cast()
}

///|
/// Add years
#alias(add_years)
pub fn addYears(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("addYears", date.to_date(), amount).cast()
}

///|
/// Sub years
#alias(sub_years)
pub fn subYears(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("subYears", date.to_date(), amount).cast()
}

///|
/// Add hours
#alias(add_hours)
pub fn addHours(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("addHours", date.to_date(), amount).cast()
}

///|
/// Sub hours
#alias(sub_hours)
pub fn subHours(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("subHours", date.to_date(), amount).cast()
}

///|
/// Add minutes
#alias(add_minutes)
pub fn addMinutes(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("addMinutes", date.to_date(), amount).cast()
}

///|
/// Sub minutes
#alias(sub_minutes)
pub fn subMinutes(date : &DateArgs, amount : Int) -> @date.Date {
  date_fns().call2("subMinutes", date.to_date(), amount).cast()
}

///| Getters

///|
/// Get year
#alias(get_year)
pub fn getYear(date : &DateArgs) -> Int {
  date_fns().call1("getYear", date.to_date()).cast()
}

///|
/// Get month (0-11)
#alias(get_month)
pub fn getMonth(date : &DateArgs) -> Int {
  date_fns().call1("getMonth", date.to_date()).cast()
}

///|
/// Get date (day of month)
#alias(get_date)
pub fn getDate(date : &DateArgs) -> Int {
  date_fns().call1("getDate", date.to_date()).cast()
}

///|
/// Get day of week (0-6)
#alias(get_day)
pub fn getDay(date : &DateArgs) -> Int {
  date_fns().call1("getDay", date.to_date()).cast()
}

///|
/// Get hours
#alias(get_hours)
pub fn getHours(date : &DateArgs) -> Int {
  date_fns().call1("getHours", date.to_date()).cast()
}

///|
/// Get minutes
#alias(get_minutes)
pub fn getMinutes(date : &DateArgs) -> Int {
  date_fns().call1("getMinutes", date.to_date()).cast()
}

///|
/// Get seconds
#alias(get_seconds)
pub fn getSeconds(date : &DateArgs) -> Int {
  date_fns().call1("getSeconds", date.to_date()).cast()
}

///|
/// Get Unix timestamp (seconds)
#alias(get_unix_time)
pub fn getUnixTime(date : &DateArgs) -> Int {
  date_fns().call1("getUnixTime", date.to_date()).cast()
}

///|
/// Get time in milliseconds
#alias(get_time)
pub fn getTime(date : &DateArgs) -> Int {
  date_fns().call1("getTime", date.to_date()).cast()
}

///| Setters

///|
/// Set year
#alias(set_year)
pub fn setYear(date : &DateArgs, year : Int) -> @date.Date {
  date_fns().call2("setYear", date.to_date(), year).cast()
}

///|
/// Set month
#alias(set_month)
pub fn setMonth(date : &DateArgs, month : Int) -> @date.Date {
  date_fns().call2("setMonth", date.to_date(), month).cast()
}

///|
/// Set date (day of month)
#alias(set_date)
pub fn setDate(date : &DateArgs, day : Int) -> @date.Date {
  date_fns().call2("setDate", date.to_date(), day).cast()
}

///|
/// Set hours
#alias(set_hours)
pub fn setHours(date : &DateArgs, hours : Int) -> @date.Date {
  date_fns().call2("setHours", date.to_date(), hours).cast()
}

///|
/// Set minutes
#alias(set_minutes)
pub fn setMinutes(date : &DateArgs, minutes : Int) -> @date.Date {
  date_fns().call2("setMinutes", date.to_date(), minutes).cast()
}

///|
/// Set seconds
#alias(set_seconds)
pub fn setSeconds(date : &DateArgs, seconds : Int) -> @date.Date {
  date_fns().call2("setSeconds", date.to_date(), seconds).cast()
}

///| Start/End of period

///|
/// Start of day
#alias(start_of_day)
pub fn startOfDay(date : &DateArgs) -> @date.Date {
  date_fns().call1("startOfDay", date.to_date()).cast()
}

///|
/// End of day
#alias(end_of_day)
pub fn endOfDay(date : &DateArgs) -> @date.Date {
  date_fns().call1("endOfDay", date.to_date()).cast()
}

///|
/// Start of month
#alias(start_of_month)
pub fn startOfMonth(date : &DateArgs) -> @date.Date {
  date_fns().call1("startOfMonth", date.to_date()).cast()
}

///|
/// End of month
#alias(end_of_month)
pub fn endOfMonth(date : &DateArgs) -> @date.Date {
  date_fns().call1("endOfMonth", date.to_date()).cast()
}

///|
/// Start of year
#alias(start_of_year)
pub fn startOfYear(date : &DateArgs) -> @date.Date {
  date_fns().call1("startOfYear", date.to_date()).cast()
}

///|
/// End of year
#alias(end_of_year)
pub fn endOfYear(date : &DateArgs) -> @date.Date {
  date_fns().call1("endOfYear", date.to_date()).cast()
}

///|
/// Start of week
#alias(start_of_week)
pub fn startOfWeek(date : &DateArgs) -> @date.Date {
  date_fns().call1("startOfWeek", date.to_date()).cast()
}

///|
/// End of week
#alias(end_of_week)
pub fn endOfWeek(date : &DateArgs) -> @date.Date {
  date_fns().call1("endOfWeek", date.to_date()).cast()
}

///| Helpers

///|
/// Create a new Date from timestamp
#alias(from_unix_time)
pub fn fromUnixTime(timestamp : Int) -> @date.Date {
  date_fns().call1("fromUnixTime", timestamp).cast()
}

///|
extern "js" fn ffi_new_date_from_time(time : Int) -> @js.Any =
  #| (time) => new Date(time)

///|
extern "js" fn ffi_new_date_ymd(
  year : Int,
  month : Int,
  day : Int,
) -> @date.Date =
  #| (year, month, day) => new Date(year, month, day)

///|
/// Create current date
pub fn now() -> @date.Date {
  @date.Date::new()
}

///|
/// Create date from timestamp (milliseconds)
#alias(from_time)
pub fn fromTime(time : Int) -> @date.Date {
  ffi_new_date_from_time(time).cast()
}

///|
/// Create date from year, month (0-11), day
#alias(from_ymd)
pub fn fromYMD(year : Int, month : Int, day : Int) -> @date.Date {
  ffi_new_date_ymd(year, month, day)
}
