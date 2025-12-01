///|
pub(all) struct TestShard {
  total : Int
  index : Int
}

///|
pub fn TestShard::as_any(self : TestShard) -> @nostd.Any = "%identity"

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
  let obj = @mbtconv.from_option_map({
    "files": files.map(fn(x) { @nostd.identity(@js.from_array(x)) }),
    "cwd": cwd.map(fn(x) { @nostd.any(x) }),
    "forceExit": forceExit.map(fn(x) { @nostd.any(x) }),
    "only": only.map(fn(x) { @nostd.any(x) }),
    "inspectPort": inspectPort.map(fn(x) { @nostd.any(x) }),
    "concurrency": concurrency.map(fn(x) { @nostd.any(x) }),
    "globPatterns": globPatterns.map(fn(x) {
      @nostd.identity(@js.from_array(x))
    }),
    "isolation": isolation.map(fn(x) { @nostd.any(x) }),
    "execArgv": execArgv.map(fn(x) { @nostd.identity(@js.from_array(x)) }),
    "argv": argv.map(fn(x) { @nostd.identity(@js.from_array(x)) }),
    "coverage": coverage.map(fn(x) { @nostd.any(x) }),
    "lineCoverage": lineCoverage.map(fn(x) { @nostd.any(x) }),
    "functionCoverage": functionCoverage.map(fn(x) { @nostd.any(x) }),
    "branchCoverage": branchCoverage.map(fn(x) { @nostd.any(x) }),
    "coverageIncludeGlobs": coverageIncludeGlobs.map(fn(x) {
      @nostd.identity(@js.from_array(x))
    }),
    "coverageExcludeGlobs": coverageExcludeGlobs.map(fn(x) {
      @nostd.identity(@js.from_array(x))
    }),
    "watch": watch.map(fn(x) { @nostd.any(x) }),
    "signal": signal.map(fn(x) { @nostd.identity(x) }),
    "testNamePatterns": testNamePatterns.map(fn(x) {
      @nostd.identity(@js.from_array(x))
    }),
    "testSkipPatterns": testSkipPatterns.map(fn(x) {
      @nostd.identity(@js.from_array(x))
    }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "shard": shard.map(fn(x) { @nostd.identity(x.as_any()) }),
    "rerunFailuresFilePath": rerunFailuresFilePath.map(fn(x) { @nostd.any(x) }),
    "setup": setup.map(fn(x) { @nostd.identity(@js.from_fn0(x)) }),
  }).cast()
  nodetest()._call("run", [obj]).cast()
}
