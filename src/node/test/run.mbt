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
  signal? : @js_async.AbortSignal,
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
  let entries : Array[(String, @core.Any)] = []
  if files is Some(v) {
    entries.push(("files", @core.identity(@core.any(v))))
  }
  if cwd is Some(v) {
    entries.push(("cwd", @core.any(v)))
  }
  if forceExit is Some(v) {
    entries.push(("forceExit", @core.any(v)))
  }
  if only is Some(v) {
    entries.push(("only", @core.any(v)))
  }
  if inspectPort is Some(v) {
    entries.push(("inspectPort", @core.any(v)))
  }
  if concurrency is Some(v) {
    entries.push(("concurrency", @core.any(v)))
  }
  if globPatterns is Some(v) {
    entries.push(("globPatterns", @core.identity(@core.any(v))))
  }
  if isolation is Some(v) {
    entries.push(("isolation", @core.any(v)))
  }
  if execArgv is Some(v) {
    entries.push(("execArgv", @core.identity(@core.any(v))))
  }
  if argv is Some(v) {
    entries.push(("argv", @core.identity(@core.any(v))))
  }
  if coverage is Some(v) {
    entries.push(("coverage", @core.any(v)))
  }
  if lineCoverage is Some(v) {
    entries.push(("lineCoverage", @core.any(v)))
  }
  if functionCoverage is Some(v) {
    entries.push(("functionCoverage", @core.any(v)))
  }
  if branchCoverage is Some(v) {
    entries.push(("branchCoverage", @core.any(v)))
  }
  if coverageIncludeGlobs is Some(v) {
    entries.push(("coverageIncludeGlobs", @core.identity(@core.any(v))))
  }
  if coverageExcludeGlobs is Some(v) {
    entries.push(("coverageExcludeGlobs", @core.identity(@core.any(v))))
  }
  if watch is Some(v) {
    entries.push(("watch", @core.any(v)))
  }
  if signal is Some(v) {
    entries.push(("signal", @core.identity(v)))
  }
  if testNamePatterns is Some(v) {
    entries.push(("testNamePatterns", @core.identity(@core.any(v))))
  }
  if testSkipPatterns is Some(v) {
    entries.push(("testSkipPatterns", @core.identity(@core.any(v))))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if shard is Some(v) {
    entries.push(("shard", @core.identity(v.as_any())))
  }
  if rerunFailuresFilePath is Some(v) {
    entries.push(("rerunFailuresFilePath", @core.any(v)))
  }
  if setup is Some(v) {
    entries.push(("setup", @core.identity(@core.from_fn0(v))))
  }
  let obj = @core.from_entries(entries).cast()
  nodetest()._call("run", [obj]).cast()
}
