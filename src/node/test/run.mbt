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
  let obj = @js.from_entries_option([
    ("files", files.map(fn(x) { @js.from_array(x) })),
    ("cwd", cwd.map(fn(x) { x })),
    ("forceExit", forceExit.map(fn(x) { x })),
    ("only", only.map(fn(x) { x })),
    ("inspectPort", inspectPort.map(fn(x) { x })),
    ("concurrency", concurrency.map(fn(x) { x })),
    ("globPatterns", globPatterns.map(fn(x) { @js.from_array(x) })),
    ("isolation", isolation.map(fn(x) { x })),
    ("execArgv", execArgv.map(fn(x) { @js.from_array(x) })),
    ("coverage", coverage.map(fn(x) { x })),
    ("watch", watch.map(fn(x) { x })),
    ("signal", signal.map(fn(x) { x })),
    ("testNamePatterns", testNamePatterns.map(fn(x) { @js.from_array(x) })),
    ("testSkipPatterns", testSkipPatterns.map(fn(x) { @js.from_array(x) })),
    ("timeout", timeout.map(fn(x) { x })),
    ("shard", shard.map(fn(x) { x })),
    ("rerunFailuresFilePath", rerunFailuresFilePath.map(fn(x) { x })),
    ("setup", setup.map(fn(x) { @js.from_fn0(x) })),
  ])
  nodetest().call("run", [obj]) |> unsafe_cast
}
