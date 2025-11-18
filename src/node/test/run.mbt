///|
pub(all) struct TestShard {
  total : Int
  index : Int
}

///|
pub impl JsImpl for TestShard

///|
/// https://nodejs.org/api/test.html#runoptions
/// node:test.run()
pub fn run(
  files? : Array[String],
  cwd? : String,
  forceExit? : Bool,
  inspectPort? : Int,
  only? : Bool,
  concurrency? : Int,
  globPatterns? : Array[String],
  isolation? : Bool,
  execArgv? : Array[String],
  argv? : Array[String],
  watch? : Bool,
  shard? : TestShard,
  signal? : @js.AbortSignal,
  testNamePatterns? : Array[String],
  testSkipPatterns? : Array[String],
  timeout? : Int,
  rerunFailuresFilePath? : String,
  setup? : () -> Unit,

  // coverage
  coverage? : Bool,
  lineCoverage? : Bool,
  functionCoverage? : Bool,
  branchCoverage? : Bool,
  coverageIncludeGlobs? : Array[String],
  coverageExcludeGlobs? : Array[String],
) -> @stream.Stream {
  let obj = @js.Object::new()
  if files is Some(files) {
    obj.set("files", @js.from_array(files))
  }
  if cwd is Some(cwd) {
    obj.set("cwd", @js.js(cwd))
  }
  if forceExit is Some(forceExit) {
    obj.set("forceExit", @js.js(forceExit))
  }
  if only is Some(only) {
    obj.set("only", @js.js(only))
  }
  if inspectPort is Some(inspectPort) {
    obj.set("inspectPort", @js.js(inspectPort))
  }
  if concurrency is Some(concurrency) {
    obj.set("concurrency", @js.js(concurrency))
  }
  if globPatterns is Some(globPatterns) {
    obj.set("globPatterns", @js.from_array(globPatterns))
  }
  if isolation is Some(isolation) {
    obj.set("isolation", @js.js(isolation))
  }
  if execArgv is Some(execArgv) {
    obj.set("execArgv", @js.from_array(execArgv))
  }
  if coverage is Some(coverage) {
    obj.set("coverage", @js.js(coverage))
  }
  if watch is Some(watch) {
    obj.set("watch", @js.js(watch))
  }
  if signal is Some(signal) {
    obj.set("signal", @js.js(signal))
  }
  if testNamePatterns is Some(testNamePatterns) {
    obj.set("testNamePatterns", @js.from_array(testNamePatterns))
  }
  if testSkipPatterns is Some(testSkipPatterns) {
    obj.set("testSkipPatterns", @js.from_array(testSkipPatterns))
  }
  if timeout is Some(timeout) {
    obj.set("timeout", @js.js(timeout))
  }
  if shard is Some(shard) {
    obj.set("shard", @js.js(shard))
  }
  if rerunFailuresFilePath is Some(rerunFailuresFilePath) {
    obj.set("rerunFailuresFilePath", @js.js(rerunFailuresFilePath))
  }
  if setup is Some(setup) {
    obj.set("setup", @js.from_fn0(setup))
  }
  nodetest().invoke("run", [obj]) |> unsafe_cast
}
