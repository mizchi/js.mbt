///| npm date-fns package FFI bindings
/// https://date-fns.org/
/// https://github.com/date-fns/date-fns

// FFI functions using #module("date-fns")

///|
#module("date-fns")
extern "js" fn ffi_format(date : @core.Any, format_str : String) -> String = "format"

///|
#module("date-fns")
extern "js" fn ffi_format_iso(date : @core.Any) -> String = "formatISO"

///|
#module("date-fns")
extern "js" fn ffi_format_distance(
  date : @core.Any,
  base : @core.Any,
) -> String = "formatDistance"

///|
#module("date-fns")
extern "js" fn ffi_format_distance_to_now(date : @core.Any) -> String = "formatDistanceToNow"

///|
#module("date-fns")
extern "js" fn ffi_format_relative(
  date : @core.Any,
  base : @core.Any,
) -> String = "formatRelative"

///|
#module("date-fns")
extern "js" fn ffi_parse(
  date_str : String,
  format_str : String,
  reference : @core.Any,
) -> @date.Date = "parse"

///|
#module("date-fns")
extern "js" fn ffi_parse_iso(date_str : String) -> @date.Date = "parseISO"

///|
#module("date-fns")
extern "js" fn ffi_is_valid(date : @core.Any) -> Bool = "isValid"

///|
#module("date-fns")
extern "js" fn ffi_is_before(date1 : @core.Any, date2 : @core.Any) -> Bool = "isBefore"

///|
#module("date-fns")
extern "js" fn ffi_is_after(date1 : @core.Any, date2 : @core.Any) -> Bool = "isAfter"

///|
#module("date-fns")
extern "js" fn ffi_is_equal(date1 : @core.Any, date2 : @core.Any) -> Bool = "isEqual"

///|
#module("date-fns")
extern "js" fn ffi_is_same_day(date1 : @core.Any, date2 : @core.Any) -> Bool = "isSameDay"

///|
#module("date-fns")
extern "js" fn ffi_is_same_month(date1 : @core.Any, date2 : @core.Any) -> Bool = "isSameMonth"

///|
#module("date-fns")
extern "js" fn ffi_is_same_year(date1 : @core.Any, date2 : @core.Any) -> Bool = "isSameYear"

///|
#module("date-fns")
extern "js" fn ffi_compare_asc(date1 : @core.Any, date2 : @core.Any) -> Int = "compareAsc"

///|
#module("date-fns")
extern "js" fn ffi_compare_desc(date1 : @core.Any, date2 : @core.Any) -> Int = "compareDesc"

///|
#module("date-fns")
extern "js" fn ffi_difference_in_milliseconds(
  date1 : @core.Any,
  date2 : @core.Any,
) -> Int = "differenceInMilliseconds"

///|
#module("date-fns")
extern "js" fn ffi_difference_in_seconds(
  date1 : @core.Any,
  date2 : @core.Any,
) -> Int = "differenceInSeconds"

///|
#module("date-fns")
extern "js" fn ffi_difference_in_minutes(
  date1 : @core.Any,
  date2 : @core.Any,
) -> Int = "differenceInMinutes"

///|
#module("date-fns")
extern "js" fn ffi_difference_in_hours(
  date1 : @core.Any,
  date2 : @core.Any,
) -> Int = "differenceInHours"

///|
#module("date-fns")
extern "js" fn ffi_difference_in_days(
  date1 : @core.Any,
  date2 : @core.Any,
) -> Int = "differenceInDays"

///|
#module("date-fns")
extern "js" fn ffi_difference_in_weeks(
  date1 : @core.Any,
  date2 : @core.Any,
) -> Int = "differenceInWeeks"

///|
#module("date-fns")
extern "js" fn ffi_difference_in_months(
  date1 : @core.Any,
  date2 : @core.Any,
) -> Int = "differenceInMonths"

///|
#module("date-fns")
extern "js" fn ffi_difference_in_years(
  date1 : @core.Any,
  date2 : @core.Any,
) -> Int = "differenceInYears"

///|
#module("date-fns")
extern "js" fn ffi_add(date : @core.Any, duration : @core.Any) -> @date.Date = "add"

///|
#module("date-fns")
extern "js" fn ffi_sub(date : @core.Any, duration : @core.Any) -> @date.Date = "sub"

///|
#module("date-fns")
extern "js" fn ffi_add_days(date : @core.Any, amount : Int) -> @date.Date = "addDays"

///|
#module("date-fns")
extern "js" fn ffi_sub_days(date : @core.Any, amount : Int) -> @date.Date = "subDays"

///|
#module("date-fns")
extern "js" fn ffi_add_months(date : @core.Any, amount : Int) -> @date.Date = "addMonths"

///|
#module("date-fns")
extern "js" fn ffi_sub_months(date : @core.Any, amount : Int) -> @date.Date = "subMonths"

///|
#module("date-fns")
extern "js" fn ffi_add_years(date : @core.Any, amount : Int) -> @date.Date = "addYears"

///|
#module("date-fns")
extern "js" fn ffi_sub_years(date : @core.Any, amount : Int) -> @date.Date = "subYears"

///|
#module("date-fns")
extern "js" fn ffi_add_hours(date : @core.Any, amount : Int) -> @date.Date = "addHours"

///|
#module("date-fns")
extern "js" fn ffi_sub_hours(date : @core.Any, amount : Int) -> @date.Date = "subHours"

///|
#module("date-fns")
extern "js" fn ffi_add_minutes(date : @core.Any, amount : Int) -> @date.Date = "addMinutes"

///|
#module("date-fns")
extern "js" fn ffi_sub_minutes(date : @core.Any, amount : Int) -> @date.Date = "subMinutes"

///|
#module("date-fns")
extern "js" fn ffi_get_year(date : @core.Any) -> Int = "getYear"

///|
#module("date-fns")
extern "js" fn ffi_get_month(date : @core.Any) -> Int = "getMonth"

///|
#module("date-fns")
extern "js" fn ffi_get_date(date : @core.Any) -> Int = "getDate"

///|
#module("date-fns")
extern "js" fn ffi_get_day(date : @core.Any) -> Int = "getDay"

///|
#module("date-fns")
extern "js" fn ffi_get_hours(date : @core.Any) -> Int = "getHours"

///|
#module("date-fns")
extern "js" fn ffi_get_minutes(date : @core.Any) -> Int = "getMinutes"

///|
#module("date-fns")
extern "js" fn ffi_get_seconds(date : @core.Any) -> Int = "getSeconds"

///|
#module("date-fns")
extern "js" fn ffi_get_unix_time(date : @core.Any) -> Int = "getUnixTime"

///|
#module("date-fns")
extern "js" fn ffi_get_time(date : @core.Any) -> Int = "getTime"

///|
#module("date-fns")
extern "js" fn ffi_set_year(date : @core.Any, year : Int) -> @date.Date = "setYear"

///|
#module("date-fns")
extern "js" fn ffi_set_month(date : @core.Any, month : Int) -> @date.Date = "setMonth"

///|
#module("date-fns")
extern "js" fn ffi_set_date(date : @core.Any, day : Int) -> @date.Date = "setDate"

///|
#module("date-fns")
extern "js" fn ffi_set_hours(date : @core.Any, hours : Int) -> @date.Date = "setHours"

///|
#module("date-fns")
extern "js" fn ffi_set_minutes(date : @core.Any, minutes : Int) -> @date.Date = "setMinutes"

///|
#module("date-fns")
extern "js" fn ffi_set_seconds(date : @core.Any, seconds : Int) -> @date.Date = "setSeconds"

///|
#module("date-fns")
extern "js" fn ffi_start_of_day(date : @core.Any) -> @date.Date = "startOfDay"

///|
#module("date-fns")
extern "js" fn ffi_end_of_day(date : @core.Any) -> @date.Date = "endOfDay"

///|
#module("date-fns")
extern "js" fn ffi_start_of_month(date : @core.Any) -> @date.Date = "startOfMonth"

///|
#module("date-fns")
extern "js" fn ffi_end_of_month(date : @core.Any) -> @date.Date = "endOfMonth"

///|
#module("date-fns")
extern "js" fn ffi_start_of_year(date : @core.Any) -> @date.Date = "startOfYear"

///|
#module("date-fns")
extern "js" fn ffi_end_of_year(date : @core.Any) -> @date.Date = "endOfYear"

///|
#module("date-fns")
extern "js" fn ffi_start_of_week(date : @core.Any) -> @date.Date = "startOfWeek"

///|
#module("date-fns")
extern "js" fn ffi_end_of_week(date : @core.Any) -> @date.Date = "endOfWeek"

///|
#module("date-fns")
extern "js" fn ffi_from_unix_time(timestamp : Int) -> @date.Date = "fromUnixTime"

///|
pub(open) trait DateArgs {
  to_date(Self) -> @core.Any = _
}

///|
impl DateArgs with to_date(self) {
  self |> @core.identity
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
  ffi_format(date.to_date(), format_str)
}

///|
/// Format a date in ISO 8601 format
#alias(format_iso)
pub fn formatISO(date : &DateArgs) -> String {
  ffi_format_iso(date.to_date())
}

///|
/// Format a date relative to now (e.g., "5 minutes ago")
#alias(format_distance)
pub fn formatDistance(date : &DateArgs, base_date : &DateArgs) -> String {
  ffi_format_distance(date.to_date(), base_date.to_date())
}

///|
/// Format a date relative to now with suffix
#alias(format_distance_to_now)
pub fn formatDistanceToNow(date : &DateArgs) -> String {
  ffi_format_distance_to_now(date.to_date())
}

///|
/// Format a date as relative time (e.g., "yesterday", "in 3 days")
#alias(format_relative)
pub fn formatRelative(date : &DateArgs, base_date : &DateArgs) -> String {
  ffi_format_relative(date.to_date(), base_date.to_date())
}

///| Parsing

///|
/// Parse a date string with a format
pub fn parse(
  date_str : String,
  format_str : String,
  reference : &DateArgs,
) -> @date.Date {
  ffi_parse(date_str, format_str, reference.to_date())
}

///|
/// Parse an ISO 8601 string
#alias(parse_iso)
pub fn parseISO(date_str : String) -> @date.Date {
  ffi_parse_iso(date_str)
}

///| Comparison

///|
/// Check if date is valid
#alias(is_valid)
pub fn isValid(date : &DateArgs) -> Bool {
  ffi_is_valid(date.to_date())
}

///|
/// Check if date1 is before date2
#alias(is_before)
pub fn isBefore(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  ffi_is_before(date1.to_date(), date2.to_date())
}

///|
/// Check if date1 is after date2
#alias(is_after)
pub fn isAfter(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  ffi_is_after(date1.to_date(), date2.to_date())
}

///|
/// Check if two dates are equal
#alias(is_equal)
pub fn isEqual(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  ffi_is_equal(date1.to_date(), date2.to_date())
}

///|
/// Check if date is same day
#alias(is_same_day)
pub fn isSameDay(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  ffi_is_same_day(date1.to_date(), date2.to_date())
}

///|
/// Check if date is same month
#alias(is_same_month)
pub fn isSameMonth(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  ffi_is_same_month(date1.to_date(), date2.to_date())
}

///|
/// Check if date is same year
#alias(is_same_year)
pub fn isSameYear(date1 : &DateArgs, date2 : &DateArgs) -> Bool {
  ffi_is_same_year(date1.to_date(), date2.to_date())
}

///|
/// Compare two dates (for sorting)
#alias(compare_asc)
pub fn compareAsc(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_compare_asc(date1.to_date(), date2.to_date())
}

///|
/// Compare two dates descending
#alias(compare_desc)
pub fn compareDesc(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_compare_desc(date1.to_date(), date2.to_date())
}

///| Difference calculations

///|
/// Difference in milliseconds
#alias(difference_in_milliseconds)
pub fn differenceInMilliseconds(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_difference_in_milliseconds(date1.to_date(), date2.to_date())
}

///|
/// Difference in seconds
#alias(difference_in_seconds)
pub fn differenceInSeconds(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_difference_in_seconds(date1.to_date(), date2.to_date())
}

///|
/// Difference in minutes
#alias(difference_in_minutes)
pub fn differenceInMinutes(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_difference_in_minutes(date1.to_date(), date2.to_date())
}

///|
/// Difference in hours
#alias(difference_in_hours)
pub fn differenceInHours(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_difference_in_hours(date1.to_date(), date2.to_date())
}

///|
/// Difference in days
#alias(difference_in_days)
pub fn differenceInDays(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_difference_in_days(date1.to_date(), date2.to_date())
}

///|
/// Difference in weeks
#alias(difference_in_weeks)
pub fn differenceInWeeks(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_difference_in_weeks(date1.to_date(), date2.to_date())
}

///|
/// Difference in months
#alias(difference_in_months)
pub fn differenceInMonths(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_difference_in_months(date1.to_date(), date2.to_date())
}

///|
/// Difference in years
#alias(difference_in_years)
pub fn differenceInYears(date1 : &DateArgs, date2 : &DateArgs) -> Int {
  ffi_difference_in_years(date1.to_date(), date2.to_date())
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
  let duration = @core.new_object()
  match years {
    Some(v) => duration._set("years", v |> @core.any)
    None => ()
  }
  match months {
    Some(v) => duration._set("months", v |> @core.any)
    None => ()
  }
  match weeks {
    Some(v) => duration._set("weeks", v |> @core.any)
    None => ()
  }
  match days {
    Some(v) => duration._set("days", v |> @core.any)
    None => ()
  }
  match hours {
    Some(v) => duration._set("hours", v |> @core.any)
    None => ()
  }
  match minutes {
    Some(v) => duration._set("minutes", v |> @core.any)
    None => ()
  }
  match seconds {
    Some(v) => duration._set("seconds", v |> @core.any)
    None => ()
  }
  ffi_add(date.to_date(), duration)
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
  let duration = @core.new_object()
  match years {
    Some(v) => duration._set("years", v |> @core.any)
    None => ()
  }
  match months {
    Some(v) => duration._set("months", v |> @core.any)
    None => ()
  }
  match weeks {
    Some(v) => duration._set("weeks", v |> @core.any)
    None => ()
  }
  match days {
    Some(v) => duration._set("days", v |> @core.any)
    None => ()
  }
  match hours {
    Some(v) => duration._set("hours", v |> @core.any)
    None => ()
  }
  match minutes {
    Some(v) => duration._set("minutes", v |> @core.any)
    None => ()
  }
  match seconds {
    Some(v) => duration._set("seconds", v |> @core.any)
    None => ()
  }
  ffi_sub(date.to_date(), duration)
}

///|
/// Add days
#alias(add_days)
pub fn addDays(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_add_days(date.to_date(), amount)
}

///|
/// Sub days
#alias(sub_days)
pub fn subDays(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_sub_days(date.to_date(), amount)
}

///|
/// Add months
#alias(add_months)
pub fn addMonths(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_add_months(date.to_date(), amount)
}

///|
/// Sub months
#alias(sub_months)
pub fn subMonths(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_sub_months(date.to_date(), amount)
}

///|
/// Add years
#alias(add_years)
pub fn addYears(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_add_years(date.to_date(), amount)
}

///|
/// Sub years
#alias(sub_years)
pub fn subYears(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_sub_years(date.to_date(), amount)
}

///|
/// Add hours
#alias(add_hours)
pub fn addHours(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_add_hours(date.to_date(), amount)
}

///|
/// Sub hours
#alias(sub_hours)
pub fn subHours(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_sub_hours(date.to_date(), amount)
}

///|
/// Add minutes
#alias(add_minutes)
pub fn addMinutes(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_add_minutes(date.to_date(), amount)
}

///|
/// Sub minutes
#alias(sub_minutes)
pub fn subMinutes(date : &DateArgs, amount : Int) -> @date.Date {
  ffi_sub_minutes(date.to_date(), amount)
}

///| Getters

///|
/// Get year
#alias(get_year)
pub fn getYear(date : &DateArgs) -> Int {
  ffi_get_year(date.to_date())
}

///|
/// Get month (0-11)
#alias(get_month)
pub fn getMonth(date : &DateArgs) -> Int {
  ffi_get_month(date.to_date())
}

///|
/// Get date (day of month)
#alias(get_date)
pub fn getDate(date : &DateArgs) -> Int {
  ffi_get_date(date.to_date())
}

///|
/// Get day of week (0-6)
#alias(get_day)
pub fn getDay(date : &DateArgs) -> Int {
  ffi_get_day(date.to_date())
}

///|
/// Get hours
#alias(get_hours)
pub fn getHours(date : &DateArgs) -> Int {
  ffi_get_hours(date.to_date())
}

///|
/// Get minutes
#alias(get_minutes)
pub fn getMinutes(date : &DateArgs) -> Int {
  ffi_get_minutes(date.to_date())
}

///|
/// Get seconds
#alias(get_seconds)
pub fn getSeconds(date : &DateArgs) -> Int {
  ffi_get_seconds(date.to_date())
}

///|
/// Get Unix timestamp (seconds)
#alias(get_unix_time)
pub fn getUnixTime(date : &DateArgs) -> Int {
  ffi_get_unix_time(date.to_date())
}

///|
/// Get time in milliseconds
#alias(get_time)
pub fn getTime(date : &DateArgs) -> Int {
  ffi_get_time(date.to_date())
}

///| Setters

///|
/// Set year
#alias(set_year)
pub fn setYear(date : &DateArgs, year : Int) -> @date.Date {
  ffi_set_year(date.to_date(), year)
}

///|
/// Set month
#alias(set_month)
pub fn setMonth(date : &DateArgs, month : Int) -> @date.Date {
  ffi_set_month(date.to_date(), month)
}

///|
/// Set date (day of month)
#alias(set_date)
pub fn setDate(date : &DateArgs, day : Int) -> @date.Date {
  ffi_set_date(date.to_date(), day)
}

///|
/// Set hours
#alias(set_hours)
pub fn setHours(date : &DateArgs, hours : Int) -> @date.Date {
  ffi_set_hours(date.to_date(), hours)
}

///|
/// Set minutes
#alias(set_minutes)
pub fn setMinutes(date : &DateArgs, minutes : Int) -> @date.Date {
  ffi_set_minutes(date.to_date(), minutes)
}

///|
/// Set seconds
#alias(set_seconds)
pub fn setSeconds(date : &DateArgs, seconds : Int) -> @date.Date {
  ffi_set_seconds(date.to_date(), seconds)
}

///| Start/End of period

///|
/// Start of day
#alias(start_of_day)
pub fn startOfDay(date : &DateArgs) -> @date.Date {
  ffi_start_of_day(date.to_date())
}

///|
/// End of day
#alias(end_of_day)
pub fn endOfDay(date : &DateArgs) -> @date.Date {
  ffi_end_of_day(date.to_date())
}

///|
/// Start of month
#alias(start_of_month)
pub fn startOfMonth(date : &DateArgs) -> @date.Date {
  ffi_start_of_month(date.to_date())
}

///|
/// End of month
#alias(end_of_month)
pub fn endOfMonth(date : &DateArgs) -> @date.Date {
  ffi_end_of_month(date.to_date())
}

///|
/// Start of year
#alias(start_of_year)
pub fn startOfYear(date : &DateArgs) -> @date.Date {
  ffi_start_of_year(date.to_date())
}

///|
/// End of year
#alias(end_of_year)
pub fn endOfYear(date : &DateArgs) -> @date.Date {
  ffi_end_of_year(date.to_date())
}

///|
/// Start of week
#alias(start_of_week)
pub fn startOfWeek(date : &DateArgs) -> @date.Date {
  ffi_start_of_week(date.to_date())
}

///|
/// End of week
#alias(end_of_week)
pub fn endOfWeek(date : &DateArgs) -> @date.Date {
  ffi_end_of_week(date.to_date())
}

///| Helpers

///|
/// Create a new Date from timestamp
#alias(from_unix_time)
pub fn fromUnixTime(timestamp : Int) -> @date.Date {
  ffi_from_unix_time(timestamp)
}

///|
extern "js" fn ffi_new_date_from_time(time : Int) -> @core.Any =
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
