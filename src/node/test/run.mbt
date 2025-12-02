///|
pub(all) struct TestShard {
  total : Int
  index : Int
}

///|
pub fn TestShard::as_any(self : TestShard) -> @core.Any = "%identity"

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
    "files": files.map(fn(x) { @core.identity(@core.any(x)) }),
    "cwd": cwd.map(fn(x) { @core.any(x) }),
    "forceExit": forceExit.map(fn(x) { @core.any(x) }),
    "only": only.map(fn(x) { @core.any(x) }),
    "inspectPort": inspectPort.map(fn(x) { @core.any(x) }),
    "concurrency": concurrency.map(fn(x) { @core.any(x) }),
    "globPatterns": globPatterns.map(fn(x) { @core.identity(@core.any(x)) }),
    "isolation": isolation.map(fn(x) { @core.any(x) }),
    "execArgv": execArgv.map(fn(x) { @core.identity(@core.any(x)) }),
    "argv": argv.map(fn(x) { @core.identity(@core.any(x)) }),
    "coverage": coverage.map(fn(x) { @core.any(x) }),
    "lineCoverage": lineCoverage.map(fn(x) { @core.any(x) }),
    "functionCoverage": functionCoverage.map(fn(x) { @core.any(x) }),
    "branchCoverage": branchCoverage.map(fn(x) { @core.any(x) }),
    "coverageIncludeGlobs": coverageIncludeGlobs.map(fn(x) {
      @core.identity(@core.any(x))
    }),
    "coverageExcludeGlobs": coverageExcludeGlobs.map(fn(x) {
      @core.identity(@core.any(x))
    }),
    "watch": watch.map(fn(x) { @core.any(x) }),
    "signal": signal.map(fn(x) { @core.identity(x) }),
    "testNamePatterns": testNamePatterns.map(fn(x) {
      @core.identity(@core.any(x))
    }),
    "testSkipPatterns": testSkipPatterns.map(fn(x) {
      @core.identity(@core.any(x))
    }),
    "timeout": timeout.map(fn(x) { @core.any(x) }),
    "shard": shard.map(fn(x) { @core.identity(x.as_any()) }),
    "rerunFailuresFilePath": rerunFailuresFilePath.map(fn(x) { @core.any(x) }),
    "setup": setup.map(fn(x) { @core.identity(@js.from_fn0(x)) }),
  }).cast()
  nodetest()._call("run", [obj]).cast()
}
