///|
/// memfs bindings tests

///|
test "create volume" {
  let vol = @memfs.createVolume()
  inspect(vol.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "create memfs" {
  let (vol, fs) = @memfs.memfs()
  inspect(vol.to_any() |> @js.is_nullish |> not, content="true")
  inspect(fs.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "writeFileSync and readFileSync" {
  let (_, fs) = @memfs.memfs()
  fs.writeFileSync("/test.txt", "Hello, World!")
  let content = fs.readFileSync("/test.txt")
  inspect(content, content="Hello, World!")
}

///|
test "existsSync" {
  let (_, fs) = @memfs.memfs()
  inspect(fs.existsSync("/test.txt"), content="false")
  fs.writeFileSync("/test.txt", "content")
  inspect(fs.existsSync("/test.txt"), content="true")
}

///|
test "mkdirSync" {
  let (_, fs) = @memfs.memfs()
  fs.mkdirSync("/mydir")
  inspect(fs.existsSync("/mydir"), content="true")
}

///|
test "mkdirSync recursive" {
  let (_, fs) = @memfs.memfs()
  fs.mkdirSync("/a/b/c", recursive=true)
  inspect(fs.existsSync("/a"), content="true")
  inspect(fs.existsSync("/a/b"), content="true")
  inspect(fs.existsSync("/a/b/c"), content="true")
}

///|
test "readdirSync" {
  let (_, fs) = @memfs.memfs()
  fs.mkdirSync("/mydir")
  fs.writeFileSync("/mydir/file1.txt", "1")
  fs.writeFileSync("/mydir/file2.txt", "2")
  let files = fs.readdirSync("/mydir")
  inspect(files.length(), content="2")
}

///|
test "unlinkSync" {
  let (_, fs) = @memfs.memfs()
  fs.writeFileSync("/test.txt", "content")
  inspect(fs.existsSync("/test.txt"), content="true")
  fs.unlinkSync("/test.txt")
  inspect(fs.existsSync("/test.txt"), content="false")
}

///|
test "renameSync" {
  let (_, fs) = @memfs.memfs()
  fs.writeFileSync("/old.txt", "content")
  fs.renameSync("/old.txt", "/new.txt")
  inspect(fs.existsSync("/old.txt"), content="false")
  inspect(fs.existsSync("/new.txt"), content="true")
  inspect(fs.readFileSync("/new.txt"), content="content")
}

///|
test "appendFileSync" {
  let (_, fs) = @memfs.memfs()
  fs.writeFileSync("/test.txt", "Hello")
  fs.appendFileSync("/test.txt", ", World!")
  inspect(fs.readFileSync("/test.txt"), content="Hello, World!")
}

///|
test "statSync file" {
  let (_, fs) = @memfs.memfs()
  fs.writeFileSync("/test.txt", "Hello")
  let stats = fs.statSync("/test.txt")
  inspect(stats.isFile(), content="true")
  inspect(stats.isDirectory(), content="false")
  inspect(stats.size(), content="5")
}

///|
test "statSync directory" {
  let (_, fs) = @memfs.memfs()
  fs.mkdirSync("/mydir")
  let stats = fs.statSync("/mydir")
  inspect(stats.isFile(), content="false")
  inspect(stats.isDirectory(), content="true")
}

///|
test "copyFileSync" {
  let (_, fs) = @memfs.memfs()
  fs.writeFileSync("/src.txt", "copy me")
  fs.copyFileSync("/src.txt", "/dest.txt")
  inspect(fs.readFileSync("/dest.txt"), content="copy me")
}

///|
test "rmdirSync" {
  let (_, fs) = @memfs.memfs()
  fs.mkdirSync("/mydir")
  inspect(fs.existsSync("/mydir"), content="true")
  fs.rmdirSync("/mydir")
  inspect(fs.existsSync("/mydir"), content="false")
}

///|
test "volume toJSON" {
  let (vol, fs) = @memfs.memfs()
  fs.writeFileSync("/test.txt", "content")
  let json = vol.toJSON()
  inspect(json |> @js.is_nullish |> not, content="true")
}

///|
test "volume reset" {
  let (vol, fs) = @memfs.memfs()
  fs.writeFileSync("/test.txt", "content")
  inspect(fs.existsSync("/test.txt"), content="true")
  vol.reset()
  inspect(fs.existsSync("/test.txt"), content="false")
}

///|
test "memfsFromJSON" {
  let files = @js.Object::new()
  files.set("/hello.txt", "Hello!")
  files.set("/world.txt", "World!")
  let (_, fs) = @memfs.memfsFromJSON(files.to_any())
  inspect(fs.readFileSync("/hello.txt"), content="Hello!")
  inspect(fs.readFileSync("/world.txt"), content="World!")
}

///|
async test "readFile async" {
  let (_, fs) = @memfs.memfs()
  fs.writeFileSync("/test.txt", "async content")
  let content = fs.readFile("/test.txt")
  inspect(content, content="async content")
}

///|
async test "writeFile async" {
  let (_, fs) = @memfs.memfs()
  fs.writeFile("/test.txt", "async write")
  let content = fs.readFileSync("/test.txt")
  inspect(content, content="async write")
}

///|
async test "mkdir async" {
  let (_, fs) = @memfs.memfs()
  fs.mkdir("/asyncdir")
  inspect(fs.existsSync("/asyncdir"), content="true")
}

///|
async test "readdir async" {
  let (_, fs) = @memfs.memfs()
  fs.mkdirSync("/dir")
  fs.writeFileSync("/dir/a.txt", "a")
  fs.writeFileSync("/dir/b.txt", "b")
  let files = fs.readdir("/dir")
  inspect(files.length(), content="2")
}

///|
async test "stat async" {
  let (_, fs) = @memfs.memfs()
  fs.writeFileSync("/test.txt", "test")
  let stats = fs.stat("/test.txt")
  inspect(stats.isFile(), content="true")
}
