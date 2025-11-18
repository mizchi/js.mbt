///|
test {
  it("Promise::withResolvers resolve", _ => {
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(0)
      resolver.resolve(42)
    })
    let v = resolver.promise.unwrap()
    assert_eq(v, 42)
  })
}

///|
test {
  it("fs writeFile/readFile/stat", _ => {
    let tmpdir = @os.tmpdir()
    let outpath = @path.join([tmpdir, "moonbit_example.txt"])
    let content =
      #|This is an example file created by Moonbit.
    @fs.writeFile(outpath, content).unwrap()
    let read_content = @fs.readFile(outpath).unwrap()
    assert_eq(content, read_content)
    let _ = @fs.stat(outpath).unwrap()
    // assert_true(stat.isFile())

  })
}

///|
test {
  it("fs mkdir/rm", _ => {
    let tmpdir = @os.tmpdir()
    let testdir = @path.join([tmpdir, "moonbit_test_dir"])
    @fs.mkdir(testdir, recursive=true).unwrap()
    let stat = @fs.stat(testdir).unwrap()
    @fs.rm(testdir, recursive=true).unwrap()
    ignore(stat)
  })
}

///|
test {
  it("fs rename", _ => {
    let tmpdir = @os.tmpdir()
    let oldpath = @path.join([tmpdir, "moonbit_old.txt"])
    let newpath = @path.join([tmpdir, "moonbit_new.txt"])
    @fs.writeFile(oldpath, "rename test").unwrap()
    @fs.rename(oldpath, newpath).unwrap()
    let content = @fs.readFile(newpath).unwrap()
    assert_eq(content, "rename test")
    @fs.rm(newpath, force=true).unwrap()
  })
}

///|
test {
  it("fs cp", _ => {
    let tmpdir = @os.tmpdir()
    let srcpath = @path.join([tmpdir, "moonbit_src.txt"])
    let dstpath = @path.join([tmpdir, "moonbit_dst.txt"])
    @fs.writeFile(srcpath, "copy test").unwrap()
    @fs.cp(srcpath, dstpath).unwrap()
    let content = @fs.readFile(dstpath).unwrap()
    assert_eq(content, "copy test")
    @fs.rm(srcpath, force=true).unwrap()
    @fs.rm(dstpath, force=true).unwrap()
  })
}

///|
test {
  it("fs operations sequence", _ => {
    let tmpdir = @os.tmpdir()
    let testfile = @path.join([tmpdir, "moonbit_sequence.txt"])
    // write
    @fs.writeFile(testfile, "step1").unwrap()
    sleep(5)
    // read
    let content1 = @fs.readFile(testfile).unwrap()
    assert_eq(content1, "step1")
    // overwrite
    @fs.writeFile(testfile, "step2").unwrap()
    sleep(5)
    // read again
    let content2 = @fs.readFile(testfile).unwrap()
    assert_eq(content2, "step2")
    // cleanup
    @fs.rm(testfile, force=true).unwrap()
  })
}

///|
test {
  it("concurrent file operations", _ => {
    let tmpdir = @os.tmpdir()
    let file1 = @path.join([tmpdir, "concurrent1.txt"])
    let file2 = @path.join([tmpdir, "concurrent2.txt"])
    let file3 = @path.join([tmpdir, "concurrent3.txt"])
    @fs.writeFile(file1, "file1").unwrap()
    @fs.writeFile(file2, "file2").unwrap()
    @fs.writeFile(file3, "file3").unwrap()
    let content1 = @fs.readFile(file1).unwrap()
    let content2 = @fs.readFile(file2).unwrap()
    let content3 = @fs.readFile(file3).unwrap()
    assert_eq(content1, "file1")
    assert_eq(content2, "file2")
    assert_eq(content3, "file3")
    @fs.rm(file1, force=true).unwrap()
    @fs.rm(file2, force=true).unwrap()
    @fs.rm(file3, force=true).unwrap()
  })
}

///|
test {
  it("fs readFile non-existent file", _ => {
    let result = try? @fs.readFile("/nonexistent/file.txt").unwrap()
    assert_true(result is Err(_))
  })
}
