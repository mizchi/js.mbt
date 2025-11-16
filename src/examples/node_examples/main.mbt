///|
fn main {
  @async.run_async(() => try {
    let tmpdir = @os.tmpdir()
    let outpath = @path.join([tmpdir, "moonbit_example.txt"])
    let content =
      #|This is an example file created by Moonbit.
    println("Writing to file: " + outpath)
    @fs.writeFile(outpath, content).unwrap()
    let read_content = @fs.readFile(outpath).unwrap()
    @js.log("Read content: " + read_content)
    assert_eq(content, read_content)

    let stat = @fs.stat(outpath).unwrap()
    @js.log(stat.size())
    assert_true(stat.isFile())
  } catch {
    e => {
      @js.log(e)
    }
  })
}
