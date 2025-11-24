///|
pub(all) struct TestShard {
  total : Int
  index : Int
}

///|
pub impl @js.JsImpl for TestShard

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
    ("cwd", cwd.map(x => x)),
    ("forceExit", forceExit.map(x => x)),
    ("only", only.map(x => x)),
    ("inspectPort", inspectPort.map(x => x)),
    ("concurrency", concurrency.map(x => x)),
    ("globPatterns", globPatterns.map(fn(x) { @js.from_array(x) })),
    ("isolation", isolation.map(x => x)),
    ("execArgv", execArgv.map(fn(x) { @js.from_array(x) })),
    ("argv", argv.map(fn(x) { @js.from_array(x) })),
    ("coverage", coverage.map(x => x)),
    ("lineCoverage", lineCoverage.map(x => x)),
    ("functionCoverage", functionCoverage.map(x => x)),
    ("branchCoverage", branchCoverage.map(x => x)),
    (
      "coverageIncludeGlobs",
      coverageIncludeGlobs.map(fn(x) { @js.from_array(x) }),
    ),
    (
      "coverageExcludeGlobs",
      coverageExcludeGlobs.map(fn(x) { @js.from_array(x) }),
    ),
    ("watch", watch.map(x => x)),
    ("signal", signal.map(x => x)),
    ("testNamePatterns", testNamePatterns.map(fn(x) { @js.from_array(x) })),
    ("testSkipPatterns", testSkipPatterns.map(fn(x) { @js.from_array(x) })),
    ("timeout", timeout.map(x => x)),
    ("shard", shard.map(x => x)),
    ("rerunFailuresFilePath", rerunFailuresFilePath.map(x => x)),
    ("setup", setup.map(fn(x) { @js.from_fn0(x) })),
  ])
  nodetest().call("run", [obj]) |> @js.identity
}
