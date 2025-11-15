///|
/// Whitebox test for Date internal consistency
test "Date internal consistency" {
  let date = Date::from_millis(1000000000)
  // Verify get_time and value_of return same value
  inspect(date.get_time() == date.value_of(), content="true")
}

///|
/// Whitebox test for Date mutation
test "Date setters mutate internal state" {
  let date = Date::new()
  let original_time = date.get_time()

  // Mutate and verify change
  ignore(date.set_time(1000000000))
  inspect(date.get_time() != original_time, content="true")
  inspect(date.get_time(), content="1000000000")
}

///|
/// Whitebox test for Date UTC vs local consistency
test "Date UTC and local time consistency" {
  let date = Date::from_string("2024-06-15T12:00:00.000Z")

  // UTC values should be fixed
  inspect(date.get_utc_full_year(), content="2024")
  inspect(date.get_utc_month(), content="5")
  inspect(date.get_utc_date(), content="15")
  inspect(date.get_utc_hours(), content="12")

  // Local values depend on timezone but should be consistent
  let local_year = date.get_full_year()
  let local_month = date.get_month()
  inspect(local_year >= 2024, content="true")
}

///|
/// Whitebox test for Date string conversion consistency
test "Date string conversions are consistent" {
  let date = Date::from_millis(1000000000)

  // ISO and JSON should match for this timestamp
  let iso = date.to_iso_string()
  let json = date.to_json()
  inspect(iso == json, content="true")
}

///|
/// Whitebox test for Date setter return values
test "Date setters return updated timestamp" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")

  // Setters return the new timestamp
  let new_time = date.set_utc_date(15)
  inspect(new_time == date.get_time(), content="true")
}

///|
/// Whitebox test for Date component overflow
test "Date handles component overflow" {
  let date = Date::from_ymd(2024, 0, 1)

  // Setting day to 0 should roll back to previous month
  ignore(date.set_date(0))
  let new_month = date.get_month()
  // Should be in previous month (11 of previous year)
  inspect(new_month == 11, content="true")
}

///|
/// Whitebox test for Date millisecond precision
test "Date maintains millisecond precision" {
  let millis = 1000000123
  let date = Date::from_millis(millis)
  inspect(date.get_time(), content="1000000123")
  inspect(date.value_of(), content="1000000123")
  inspect(date.get_utc_milliseconds(), content="123")
}

///|
/// Whitebox test for Date negative timestamps
test "Date handles negative timestamps (before 1970)" {
  let date = Date::from_millis(-86400000) // One day before epoch
  inspect(date.get_utc_full_year(), content="1969")
  inspect(date.get_utc_month(), content="11")
  inspect(date.get_utc_date(), content="31")
}

///|
/// Whitebox test for Date timezone offset consistency
test "Date timezone offset is consistent" {
  let date1 = Date::new()
  let date2 = Date::from_string("2024-06-15T00:00:00.000Z")
  let offset1 = date1.get_timezone_offset()
  let offset2 = date2.get_timezone_offset()

  // Offset might differ due to DST, but should be reasonable
  inspect(offset1.abs() <= 720, content="true") // Max ±12 hours
  inspect(offset2.abs() <= 720, content="true")
}

///|
/// Whitebox test for Date Js trait integration
test "Date integrates with Js trait properly" {
  let date = Date::from_string("2024-01-01T00:00:00.000Z")
  let val = date.to_js()

  // Should convert to Val without being null or undefined
  inspect(@js.is_null(val), content="false")
  inspect(@js.is_undefined(val), content="false")
}

///|
/// Whitebox test for Date parse edge cases
test "Date.parse handles various formats" {
  // ISO 8601 format
  let millis1 = Date::parse("2024-01-01T00:00:00.000Z")
  inspect(millis1 > 1000000000, content="true")

  // Simplified ISO format
  let millis2 = Date::parse("2024-01-01")
  inspect(millis2 > 0, content="true")
}

///|
/// Whitebox test for Date component bounds
test "Date component getters respect bounds" {
  let date = Date::from_string("2024-06-15T14:30:45.123Z")

  // Month should be 0-11
  let month = date.get_utc_month()
  inspect(month >= 0 && month <= 11, content="true")

  // Day should be 1-31
  let day = date.get_utc_date()
  inspect(day >= 1 && day <= 31, content="true")

  // Hours should be 0-23
  let hours = date.get_utc_hours()
  inspect(hours >= 0 && hours <= 23, content="true")

  // Minutes should be 0-59
  let minutes = date.get_utc_minutes()
  inspect(minutes >= 0 && minutes <= 59, content="true")

  // Seconds should be 0-59
  let seconds = date.get_utc_seconds()
  inspect(seconds >= 0 && seconds <= 59, content="true")

  // Milliseconds should be 0-999
  let ms = date.get_utc_milliseconds()
  inspect(ms >= 0 && ms <= 999, content="true")

  // Day of week should be 0-6
  let dow = date.get_utc_day()
  inspect(dow >= 0 && dow <= 6, content="true")
}
