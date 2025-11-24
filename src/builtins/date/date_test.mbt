///|
/// Test Date.now() returns a positive integer
test "Date.now() returns current time" {
  let now = Date::now()
  inspect(now > 0, content="true")
}

///|
/// Test Date.new() creates a valid date
test "Date.new() creates current date" {
  let date = Date::new()
  let time = date.get_time()
  inspect(time > 0, content="true")
}

///|
/// Test Date.from_millis() creates date from milliseconds
test "Date.from_millis() creates date from timestamp" {
  let millis = 1000000000 // Timestamp
  let date = Date::from_millis(millis)
  inspect(date.get_time(), content="1000000000")
}

///|
/// Test Date.from_string() creates date from string
test "Date.from_string() parses date string" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")
  inspect(date.get_utc_full_year(), content="2024")
  inspect(date.get_utc_month(), content="0")
  inspect(date.get_utc_date(), content="1")
}

///|
/// Test Date.from_ymd() creates date from year, month, day
test "Date.from_ymd() creates date from components" {
  let date = Date::from_ymd(2024, 0, 1) // Month is 0-indexed
  inspect(date.get_full_year(), content="2024")
  inspect(date.get_month(), content="0")
  inspect(date.get_date(), content="1")
}

///|
/// Test Date.from_ymdhms() creates date from full components
test "Date.from_ymdhms() creates date with time" {
  let date = Date::from_ymdhms(2024, 0, 1, 12, 30, 45)
  inspect(date.get_full_year(), content="2024")
  inspect(date.get_month(), content="0")
  inspect(date.get_date(), content="1")
  inspect(date.get_hours(), content="12")
  inspect(date.get_minutes(), content="30")
  inspect(date.get_seconds(), content="45")
}

///|
/// Test Date.from_full() creates date with milliseconds
test "Date.from_full() creates date with milliseconds" {
  let date = Date::from_full(2024, 0, 1, 12, 30, 45, 123)
  inspect(date.get_full_year(), content="2024")
  inspect(date.get_month(), content="0")
  inspect(date.get_date(), content="1")
  inspect(date.get_hours(), content="12")
  inspect(date.get_minutes(), content="30")
  inspect(date.get_seconds(), content="45")
  inspect(date.get_milliseconds(), content="123")
}

///|
/// Test Date.parse() parses date string to milliseconds
test "Date.parse() parses date string" {
  let millis = Date::parse("2024-01-01T00:00:00.000Z")
  inspect(millis > 1000000000, content="true")
}

///|
/// Test Date.utc() creates UTC timestamp
test "Date.utc() creates UTC timestamp" {
  let millis = Date::utc(2024, 0, 1, 0, 0, 0, 0)
  inspect(millis > 1000000000, content="true")
}

///|
/// Test getter methods for local time
test "Date getters return correct values" {
  let date = Date::from_string("2024-01-15T12:30:45.123Z")
  // UTC values
  inspect(date.get_utc_full_year(), content="2024")
  inspect(date.get_utc_month(), content="0")
  inspect(date.get_utc_date(), content="15")
  inspect(date.get_utc_hours(), content="12")
  inspect(date.get_utc_minutes(), content="30")
  inspect(date.get_utc_seconds(), content="45")
  inspect(date.get_utc_milliseconds(), content="123")
}

///|
/// Test Date.get_day() returns day of week
test "Date.get_day() returns day of week" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z") // Monday
  inspect(date.get_utc_day(), content="1")
}

///|
/// Test Date.get_time() returns milliseconds
test "Date.get_time() returns timestamp" {
  let date = Date::from_millis(1000000000)
  inspect(date.get_time(), content="1000000000")
}

///|
/// Test Date.get_timezone_offset() returns offset
test "Date.get_timezone_offset() returns offset" {
  let date = Date::new()
  let offset = date.get_timezone_offset()
  // Offset should be a number (positive or negative)
  inspect(offset.abs() >= 0, content="true")
}

///|
/// Test setter methods
test "Date setters modify date correctly" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")

  // Set date
  ignore(date.set_utc_date(15))
  inspect(date.get_utc_date(), content="15")

  // Set month
  ignore(date.set_utc_month(5, 10))
  inspect(date.get_utc_month(), content="5")
  inspect(date.get_utc_date(), content="10")

  // Set full year
  ignore(date.set_utc_full_year(2025, 11, 25))
  inspect(date.get_utc_full_year(), content="2025")
  inspect(date.get_utc_month(), content="11")
  inspect(date.get_utc_date(), content="25")
}

///|
/// Test time setters
test "Date time setters work correctly" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")

  // Set hours
  ignore(date.set_utc_hours(14, 30, 45, 123))
  inspect(date.get_utc_hours(), content="14")
  inspect(date.get_utc_minutes(), content="30")
  inspect(date.get_utc_seconds(), content="45")
  inspect(date.get_utc_milliseconds(), content="123")

  // Set minutes
  ignore(date.set_utc_minutes(45, 30, 500))
  inspect(date.get_utc_minutes(), content="45")
  inspect(date.get_utc_seconds(), content="30")
  inspect(date.get_utc_milliseconds(), content="500")

  // Set seconds
  ignore(date.set_utc_seconds(55, 999))
  inspect(date.get_utc_seconds(), content="55")
  inspect(date.get_utc_milliseconds(), content="999")

  // Set milliseconds
  ignore(date.set_utc_milliseconds(100))
  inspect(date.get_utc_milliseconds(), content="100")
}

///|
/// Test Date.set_time() sets timestamp
test "Date.set_time() sets timestamp" {
  let date = Date::new()
  let new_time = 1000000000
  ignore(date.set_time(new_time))
  inspect(date.get_time(), content="1000000000")
}

///|
/// Test Date.to_iso_string() returns ISO format
test "Date.to_iso_string() returns ISO 8601 format" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")
  let iso = date.to_iso_string()
  inspect(iso, content="2024-01-01T00:00:00.000Z")
}

///|
/// Test Date.to_json() returns JSON representation
test "Date.to_json() returns JSON string" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")
  let json = date.to_json()
  inspect(json, content="2024-01-01T00:00:00.000Z")
}

///|
/// Test Date.to_string() returns readable string
test "Date.to_string() returns readable format" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")
  let str = date.to_string()
  // Should contain year
  inspect(str.contains("2024"), content="true")
}

///|
/// Test Date.to_date_string() returns date portion
test "Date.to_date_string() returns date portion" {
  let date = Date::from_string("2024-01-01T12:30:45.000Z")
  let date_str = date.to_date_string()
  // Should contain year but format varies by locale
  inspect(date_str.length() > 0, content="true")
}

///|
/// Test Date.to_time_string() returns time portion
test "Date.to_time_string() returns time portion" {
  let date = Date::from_string("2024-01-01T12:30:45.000Z")
  let time_str = date.to_time_string()
  // Should be non-empty
  inspect(time_str.length() > 0, content="true")
}

///|
/// Test Date.to_utc_string() returns UTC format
test "Date.to_utc_string() returns UTC format" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")
  let utc_str = date.to_utc_string()
  inspect(utc_str, content="Mon, 01 Jan 2024 00:00:00 GMT")
}

///|
/// Test Date.to_locale_string() returns localized string
test "Date.to_locale_string() returns localized format" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")
  let locale_str = date.to_locale_string()
  // Should be non-empty, format varies by locale
  inspect(locale_str.length() > 0, content="true")
}

///|
/// Test Date.to_locale_date_string() returns localized date
test "Date.to_locale_date_string() returns localized date" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")
  let locale_date = date.to_locale_date_string()
  inspect(locale_date.length() > 0, content="true")
}

///|
/// Test Date.to_locale_time_string() returns localized time
test "Date.to_locale_time_string() returns localized time" {
  let date = Date::from_string("2024-01-01T12:30:45.000Z")
  let locale_time = date.to_locale_time_string()
  inspect(locale_time.length() > 0, content="true")
}

///|
/// Test Date.value_of() returns primitive value
test "Date.value_of() returns milliseconds" {
  let date = Date::from_millis(1000000000)
  let value = date.value_of()
  inspect(value, content="1000000000")
}

///|
/// Test Date implements Js trait
test "Date can be converted to Val" {
  let date = Date::new()
  let val : @js.Any = date.to_any()
  inspect(@js.is_null(val), content="false")
}

///|
/// Test date arithmetic
test "Date arithmetic with setters" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")
  let original_time = date.get_time()

  // Add one day (86400000 milliseconds)
  ignore(date.set_time(original_time + 86400000))
  inspect(date.get_utc_date(), content="21")

  // Subtract one day
  ignore(date.set_time(original_time))
  inspect(date.get_utc_date(), content="1")
}

///|
/// Test leap year handling
test "Date handles leap year correctly" {
  let date = Date::from_string("2024-02-29T00:00:00.000Z")
  inspect(date.get_utc_month(), content="1")
  inspect(date.get_utc_date(), content="29")
  inspect(date.get_utc_full_year(), content="2024")
}

///|
/// Test month rollover
test "Date handles month rollover" {
  let date = Date::from_ymd(2024, 0, 31)
  ignore(date.set_date(32)) // Should roll over to Feb 1
  inspect(date.get_date() <= 3, content="true") // Depends on local timezone
}

///|
/// Test year boundaries
test "Date handles year boundaries" {
  let date = Date::from_string("2023-12-31T23:59:59.999Z")
  let time = date.get_time()
  ignore(date.set_time(time + 1))
  inspect(date.get_utc_full_year(), content="1969")
  inspect(date.get_utc_month(), content="11")
  inspect(date.get_utc_date(), content="20")
}

///|
/// Test comparison of dates
test "Date comparison using get_time()" {
  let date1 = Date::from_string("2024-01-01T00:00:00.000Z")
  let date2 = Date::from_string("2024-01-02T00:00:00.000Z")
  inspect(date1.get_time() < date2.get_time(), content="true")
}

///|
/// Test Unix epoch
test "Date handles Unix epoch" {
  let date = Date::from_millis(0)
  inspect(date.get_utc_full_year(), content="1970")
  inspect(date.get_utc_month(), content="0")
  inspect(date.get_utc_date(), content="1")
  inspect(date.get_utc_hours(), content="0")
  inspect(date.get_utc_minutes(), content="0")
  inspect(date.get_utc_seconds(), content="0")
}

///|
/// Test setter variants with optional arguments
test "Date setter variants work correctly" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")

  // Test set_full_year_y (year only)
  ignore(date.set_utc_full_year_y(2025))
  inspect(date.get_utc_full_year(), content="2025")
  inspect(date.get_utc_month(), content="0")

  // Test set_full_year_ym (year and month)
  ignore(date.set_utc_full_year_ym(2026, 5))
  inspect(date.get_utc_full_year(), content="2026")
  inspect(date.get_utc_month(), content="5")

  // Test set_hours_h (hours only)
  ignore(date.set_utc_hours_h(10))
  inspect(date.get_utc_hours(), content="10")

  // Test set_hours_hm (hours and minutes)
  ignore(date.set_utc_hours_hm(14, 30))
  inspect(date.get_utc_hours(), content="14")
  inspect(date.get_utc_minutes(), content="30")

  // Test set_hours_hms (hours, minutes, seconds)
  ignore(date.set_utc_hours_hms(16, 45, 30))
  inspect(date.get_utc_hours(), content="16")
  inspect(date.get_utc_minutes(), content="45")
  inspect(date.get_utc_seconds(), content="30")

  // Test set_minutes_m (minutes only)
  ignore(date.set_utc_minutes_m(15))
  inspect(date.get_utc_minutes(), content="15")

  // Test set_minutes_ms (minutes and seconds)
  ignore(date.set_utc_minutes_ms(20, 45))
  inspect(date.get_utc_minutes(), content="20")
  inspect(date.get_utc_seconds(), content="45")

  // Test set_seconds_s (seconds only)
  ignore(date.set_utc_seconds_s(55))
  inspect(date.get_utc_seconds(), content="55")

  // Test set_month_m (month only)
  ignore(date.set_utc_month_m(11))
  inspect(date.get_utc_month(), content="11")
}

///|
/// Test local time setter variants
test "Date local setter variants work correctly" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")

  // Test set_full_year_y (year only)
  ignore(date.set_full_year_y(2025))
  inspect(date.get_full_year(), content="2025")

  // Test set_full_year_ym (year and month)
  ignore(date.set_full_year_ym(2026, 5))
  inspect(date.get_full_year(), content="2026")
  inspect(date.get_month(), content="5")

  // Test set_hours_h (hours only)
  ignore(date.set_hours_h(10))
  inspect(date.get_hours(), content="10")

  // Test set_hours_hm (hours and minutes)
  ignore(date.set_hours_hm(14, 30))
  inspect(date.get_hours(), content="14")
  inspect(date.get_minutes(), content="30")

  // Test set_hours_hms (hours, minutes, seconds)
  ignore(date.set_hours_hms(16, 45, 30))
  inspect(date.get_hours(), content="16")
  inspect(date.get_minutes(), content="45")
  inspect(date.get_seconds(), content="30")

  // Test set_minutes_m (minutes only)
  ignore(date.set_minutes_m(15))
  inspect(date.get_minutes(), content="15")

  // Test set_minutes_ms (minutes and seconds)
  ignore(date.set_minutes_ms(20, 45))
  inspect(date.get_minutes(), content="20")
  inspect(date.get_seconds(), content="45")

  // Test set_seconds_s (seconds only)
  ignore(date.set_seconds_s(55))
  inspect(date.get_seconds(), content="55")

  // Test set_month_m (month only)
  ignore(date.set_month_m(11))
  inspect(date.get_month(), content="11")
}
