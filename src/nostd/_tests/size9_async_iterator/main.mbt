///|
/// AsyncIterator wrapper for iterating over JS async iterables
pub struct AsyncIterator {
  raw : @nostd.Any
}

///|
/// Create AsyncIterator from a JS async iterable (calls Symbol.asyncIterator)
pub extern "js" fn async_iterator_from(iterable : @nostd.Any) -> AsyncIterator =
  #| (iterable) => ({ raw: iterable[Symbol.asyncIterator]() })

///|
/// Create AsyncIterator from a raw iterator object
pub fn AsyncIterator::from_raw(raw : @nostd.Any) -> AsyncIterator {
  { raw, }
}

///|
/// Get next value from the async iterator
/// Returns None when iteration is complete
pub async fn AsyncIterator::next(self : AsyncIterator) -> @nostd.Any? {
  let promise : @nostd.Promise[@nostd.Any] = self.raw._call("next", []).cast()
  let result = promise.wait()
  let done : Bool = result["done"].cast()
  if done {
    None
  } else {
    Some(result["value"])
  }
}

///|
extern "js" fn console_log(v : @nostd.Any) -> Unit =
  #| (v) => console.log(v)

///|
/// Create a test async generator
extern "js" fn create_async_generator() -> @nostd.Any =
  #| () => {
  #|   async function* gen() {
  #|     yield 1;
  #|     yield 2;
  #|     yield 3;
  #|   }
  #|   return gen();
  #| }

///|
extern "js" fn console_log_str(s : String) -> Unit =
  #| (s) => console.log(s)

///|
fn main {
  // For bundle size testing, just demonstrate the types exist
  // Actual async iteration would be tested with @async.run or similar
  let gen = create_async_generator()
  let iter = AsyncIterator::from_raw(gen)
  console_log_str("AsyncIterator created")
  console_log(iter.raw)

  // Show structure only - actual async iteration requires proper runtime
  console_log_str("AsyncIterator struct fields accessible")
}
