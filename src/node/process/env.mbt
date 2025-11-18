///|
#external
pub type ProcessEnv

///|
pub extern "js" fn ProcessEnv::get(e : ProcessEnv, key : String) -> String? =
  #| (env, key) => env[key]

///|
pub extern "js" fn ProcessEnv::has(e : ProcessEnv, key : String) -> Bool =
  #| (env, key) => !!env[key]
