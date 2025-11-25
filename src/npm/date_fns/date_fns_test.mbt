///|
test "format date" {
  let date = fromYMD(2024, 0, 15) // January 15, 2024
  let result = format(date, "yyyy-MM-dd")
  assert_eq(result, "2024-01-15")
}

///|
test "format with pattern" {
  let date = fromYMD(2024, 5, 20) // June 20, 2024
  let result = format(date, "MMMM d, yyyy")
  assert_eq(result, "June 20, 2024")
}

///|
test "parseISO" {
  let date = parseISO("2024-03-15")
  assert_eq(isValid(date), true)
  assert_eq(getYear(date), 2024)
  assert_eq(getMonth(date), 2) // March = 2 (0-indexed)
  assert_eq(getDate(date), 15)
}

///|
test "isValid" {
  let valid = parseISO("2024-01-15")
  assert_eq(isValid(valid), true)
  let invalid = parseISO("not-a-date")
  assert_eq(isValid(invalid), false)
}

///|
test "isBefore isAfter" {
  let date1 = fromYMD(2024, 0, 1)
  let date2 = fromYMD(2024, 0, 15)
  assert_eq(isBefore(date1, date2), true)
  assert_eq(isAfter(date1, date2), false)
  assert_eq(isAfter(date2, date1), true)
}

///|
test "isSameDay" {
  let date1 = fromYMD(2024, 0, 15)
  let date2 = fromYMD(2024, 0, 15)
  let date3 = fromYMD(2024, 0, 16)
  assert_eq(isSameDay(date1, date2), true)
  assert_eq(isSameDay(date1, date3), false)
}

///|
test "differenceInDays" {
  let date1 = fromYMD(2024, 0, 1)
  let date2 = fromYMD(2024, 0, 11)
  assert_eq(differenceInDays(date2, date1), 10)
}

///|
test "differenceInMonths" {
  let date1 = fromYMD(2024, 0, 1)
  let date2 = fromYMD(2024, 6, 1)
  assert_eq(differenceInMonths(date2, date1), 6)
}

///|
test "differenceInYears" {
  let date1 = fromYMD(2020, 0, 1)
  let date2 = fromYMD(2024, 0, 1)
  assert_eq(differenceInYears(date2, date1), 4)
}

///|
test "addDays" {
  let date = fromYMD(2024, 0, 15)
  let result = addDays(date, 10)
  assert_eq(getDate(result), 25)
}

///|
test "subDays" {
  let date = fromYMD(2024, 0, 15)
  let result = subDays(date, 10)
  assert_eq(getDate(result), 5)
}

///|
test "addMonths" {
  let date = fromYMD(2024, 0, 15) // January
  let result = addMonths(date, 3)
  assert_eq(getMonth(result), 3) // April
}

///|
test "add with duration" {
  let date = fromYMD(2024, 0, 1)
  let result = add(date, days=5, months=1)
  assert_eq(getMonth(result), 1) // February
  assert_eq(getDate(result), 6)
}

///|
test "sub with duration" {
  let date = fromYMD(2024, 1, 15) // February 15
  let result = sub(date, days=10, months=1)
  assert_eq(getMonth(result), 0) // January
  assert_eq(getDate(result), 5)
}

///|
test "getYear getMonth getDate" {
  let date = fromYMD(2024, 5, 20)
  assert_eq(getYear(date), 2024)
  assert_eq(getMonth(date), 5) // June
  assert_eq(getDate(date), 20)
}

///|
test "setYear setMonth setDate" {
  let date = fromYMD(2024, 0, 1)
  let d1 = setYear(date, 2025)
  assert_eq(getYear(d1), 2025)
  let d2 = setMonth(date, 6)
  assert_eq(getMonth(d2), 6)
  let d3 = setDate(date, 15)
  assert_eq(getDate(d3), 15)
}

///|
test "startOfDay endOfDay" {
  let date = parseISO("2024-01-15T12:30:00")
  let start = startOfDay(date)
  let end = endOfDay(date)
  assert_eq(getHours(start), 0)
  assert_eq(getMinutes(start), 0)
  assert_eq(getHours(end), 23)
  assert_eq(getMinutes(end), 59)
}

///|
test "startOfMonth endOfMonth" {
  let date = fromYMD(2024, 0, 15) // January 15
  let start = startOfMonth(date)
  let end = endOfMonth(date)
  assert_eq(getDate(start), 1)
  assert_eq(getDate(end), 31) // January has 31 days
}

///|
test "compareAsc" {
  let date1 = fromYMD(2024, 0, 1)
  let date2 = fromYMD(2024, 0, 15)
  assert_eq(compareAsc(date1, date2), -1)
  assert_eq(compareAsc(date2, date1), 1)
  assert_eq(compareAsc(date1, date1), 0)
}

///|
test "formatISO" {
  let date = fromYMD(2024, 0, 15)
  let result = formatISO(date)
  // formatISO returns ISO string, should contain 2024-01-15
  assert_eq(result.has_prefix("2024-01-15"), true)
}

///|
test "fromUnixTime" {
  // Unix timestamp for 2024-01-01 00:00:00 UTC is 1704067200
  let date = fromUnixTime(1704067200)
  assert_eq(getYear(date), 2024)
}

///|
test "getUnixTime" {
  let date = parseISO("2024-01-01T00:00:00Z")
  let timestamp = getUnixTime(date)
  assert_eq(timestamp, 1704067200)
}
