///|
test "sqlite exec and prepare" {
  let database = DatabaseSync::new(":memory:")
  let query =
    #|CREATE TABLE t3(x, y);
    #|INSERT INTO t3 VALUES ('a', 4), ('b', 5);
  database.exec(query)
  let prepared = database.prepare("SELECT * from t3;")
  let result = prepared.all()
  inspect(
    result |> @js.json_stringify,
    content=(
      #|[
      #|  {
      #|    "x": "a",
      #|    "y": 4
      #|  },
      #|  {
      #|    "x": "b",
      #|    "y": 5
      #|  }
      #|]
    ),
  )
}

///|
test "node:sqlite aggregate" {
  let database = DatabaseSync::new(":memory:")
  let query =
    #|CREATE TABLE t3(x, y);
    #|INSERT INTO t3 VALUES ('a', 4), ('b', 5);
  database.exec(query)
  let _ = database.aggregate("sumint", start=0, step=(acc, value) => acc + value)
  let result = database.prepare("SELECT sumint(y) as total FROM t3").get() // { total: 21 }
  inspect(
    result |> @js.json_stringify,
    content=(
      #|{
      #|  "total": 9
      #|}
    ),
  )
}
