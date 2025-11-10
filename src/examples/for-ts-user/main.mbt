///|
/// TODO: english version
fn add(a : Int, b : Int) -> Int {
  a + b
}

///|
fn main {
  let v = "World"
  println("Hello, \{v}!")

  // let mut による明示的な再代入
  let mut sum : Int = 0
  for i in 1..=5 {
    sum += i
  }
  println("Sum of 1 to 5 is \{sum}")

  // 関数パイプラインがある
  add(2, 3) |> add(4) |> println
  // 束縛されない Unit 以外 の返り値はエラー
  // ここでは let _ = ... で明示的に無視している
  let _ = 1 |> ignore

  // 高階関数
  [1, 2, 3].map(fn(x) { x * 2 }) |> println()
  [1, 2, 3].map(x => x * 2) |> println()
  [1, 2, 3].map(_.to_string()) |> println()

  // オプション型もある
  // if は式なので値を返せる
  let opt_value : Int? = Some(10)
  let _result = if opt_value is Some(v) { v } else { -1 }

  // pattern match 式
  let _result2 = match opt_value {
    Some(v) if v > 5 => v * 2
    Some(v) => v + 2
    None => 0
    // いずれにも該当しない場合のデフォルト
    // パターンを網羅している場合、警告
    _ => -1
  }

}

///|
test "guard and panic" {
  let opt_value : Int? = Some(10)

  // 早期リターンを強制する guard 文
  guard opt_value is Some(v) else {
    // ここでは v は束縛されていない
    println("No value")
    // guard の else ブロックでは必ず return や raise しなければならない
    return
  }
  // guard のパターンマッチで束縛された v は以降使える
  assert_eq(v, 10)

  // guard ~ else しない場合、 panic() する
  // これは lint で厳密にできる
  guard opt_value is Some(n) && n > 5

  // 未実装のコードを ... で示せる
  // 呼び出すと panic する
  let _ = () => ...

}

// 構造体の宣言
// derive(Eq, Show) で == の比較と to_string が自動実装される

///|
priv struct Point {
  x : Int
  y : Int
} derive(Eq, Show)

// 構造体の関連関数

///|
fn Point::new(x : Int, y : Int) -> Self {
  Point::{ x, y }
}

// 構造体のメソッド

///|
fn Point::to_tuple(self : Self) -> (Int, Int) {
  (self.x, self.y)
}

///|
test "struct" {
  let p1 = Point::new(10, 20)
  assert_eq(p1, Point::{ x: 10, y: 20 })
  let p2 : Point = { ..p1, y: 30 }
  let { y, .. } = p2
  assert_eq(y, 30)
  let (x, _y) = p2.to_tuple()
  assert_eq(x, 10)
}

///|
test "enum" {
  enum Color {
    Red
    Green
    Blue
    Rgb(r~ : Int, g~ : Int, b~ : Int)
  } derive(Eq, Show)
  let c1 = Color::Red
  let c2 = Color::Green
  let _c3 = Color::Rgb(r=255, g=0, b=0)
  assert_not_eq(c1, c2)
}

// builtin test

///|
test {
  assert_eq(add(2, 3), 5)
}

// error handling

///|
test "builtin error" {
  // 明示的なエラー宣言
  let f = fn(x : Int) -> Int raise {
    if x == 0 {
      fail("Division by zero")
    } else {
      10 / x
    }
  }

  // try catch 式
  try {
    let v = f(0)
    println("Result: " + v.to_string())
  } catch {
    // catch はパターンマッチ
    Failure(e) => println(e)
    _ => ()
  }

  // try? 式で T raise E を Result[T, E] に変換
  let _opt : Result[Int, Error] = try? f(0)

  // () => {} はエラー込みで型推論される
  let _ : () -> Int raise = () => f(0)

  // noraise で明示的に raise しないことを示す
  // 同期関数の場合、デフォルトは noraise
  let _ : () -> Int noraise = () => f(1) catch { _ => -1 }

}

// エラー型の宣言

///|
priv suberror MyError

///|
test "async function" {
  // async 関数
  // noraise はエラーが発生しないことを示す
  let async_fn = async fn(x : Int) -> Int noraise {
    // moonbitcore/async
    // @async.sleep(100)
    x
  }

  // 明示的な raise 関数
  // Error は組み込みのエラー型で、任意のエラーを示す
  let async_fn2 = async fn() -> Unit raise MyError { raise MyError }

  // Error は推論によって省略可能
  let _ = async fn() {
    raise MyError
    // fail(String) -> Unit raise Failure
    fail("error") // Failure 型
    ()
  }

  // Arrow Function の場合、async と raise 込みで推論される
  let _ : async () -> Unit = () => fail("error")

  // 呼び出し側
  let _ = async fn(y : Int) -> Unit noraise {
    let _v : Int = async_fn(y)
    let _ = async_fn2() catch { _ => () }

  }

  // raise の場合、エラー型は伝搬される
  let _ = async fn() -> Unit { async_fn2() |> ignore }

}

// builtin json

///|
test "builtin json and pattern match" {
  let json : Json = { "message": "Test", "value": [10, 2, 30] }
  match json {
    // enum variant のパターンマッチは、省略可能
    {
      "message": Json::String(message),
      "value": [Json::Number(a, ..), 2, Number(c, ..), .. _rest],
      ..
    } => {
      assert_eq(message, "Test")
      assert_eq(a, 10)
      assert_eq(c, 30)
    }
    _ => fail("Pattern did not match")
  }
}

///|
/// キーワード引数
/// param_func(a=10, b=20)
fn param_func(a~ : Int, b~ : Int) -> (Int, Int) {
  (a, b)
}

///|
/// オプショナルなキーワード引数と、そのデフォルト
fn param_func2(a? : Int = 1, b? : Int) -> (Int, Int) {
  (a, b.unwrap_or(-1))
}

///|
/// 現在、 target native で moonbitlang/async を import にしている場合
/// async test {...} が使える
