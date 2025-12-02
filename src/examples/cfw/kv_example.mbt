///|
/// Cloudflare KV Store example handler
/// This demonstrates KV operations for a simple counter and key-value storage

///|
/// Create JSON response (local to KV handler)
extern "js" fn kv_json_response(body : String, status : Int) -> @http.Response =
  #| (body, status) => new Response(body, { status, headers: { "Content-Type": "application/json" } })

///|
/// Helper to get KV namespace from env
fn get_kv(env : @cloudflare.CloudflareEnv) -> @cloudflare.KVNamespace? {
  let env_js : @core.Any = @core.identity(env)
  let kv_js = env_js._get("MY_KV")
  if @core.typeof_(kv_js) == "undefined" {
    None
  } else {
    Some(@core.identity(kv_js))
  }
}

///|
/// KV handler that provides various KV operations
pub fn get_kv_handler() -> @cloudflare.CloudflareFetchHandler {
  let async_handler = async fn(
    req : @cloudflare.CloudflareRequest,
    env : @cloudflare.CloudflareEnv,
    _ctx : @cloudflare.CloudflareContext,
  ) -> @http.Response {
    let url_str = req.url
    let url = @url.URL::new(url_str)
    let pathname = url.pathname

    // Get KV namespace
    let kv = match get_kv(env) {
      Some(k) => k
      None =>
        return kv_json_response(
          "{\"error\":\"KV namespace not configured\"}", 500,
        )
    }

    // Route handling for KV operations
    if pathname == "/kv/get" {
      // Get a key from KV
      let key = url.searchParams().get("key")
      match key {
        Some(k) => {
          let value = kv.get(k) catch {
            _ =>
              return kv_json_response("{\"error\":\"Failed to get key\"}", 500)
          }
          match value {
            Some(v) =>
              kv_json_response(
                "{\"key\":\"" + k + "\",\"value\":\"" + v + "\"}",
                200,
              )
            None => kv_json_response("{\"error\":\"Key not found\"}", 404)
          }
        }
        None => kv_json_response("{\"error\":\"Missing key parameter\"}", 400)
      }
    } else if pathname == "/kv/put" {
      // Put a key-value pair into KV
      let key = url.searchParams().get("key")
      let value = url.searchParams().get("value")
      match (key, value) {
        (Some(k), Some(v)) => {
          kv.put(k, v) catch {
            _ =>
              return kv_json_response("{\"error\":\"Failed to put key\"}", 500)
          }
          kv_json_response("{\"success\":true,\"key\":\"" + k + "\"}", 200)
        }
        _ =>
          kv_json_response(
            "{\"error\":\"Missing key or value parameter\"}", 400,
          )
      }
    } else if pathname == "/kv/delete" {
      // Delete a key from KV
      let key = url.searchParams().get("key")
      match key {
        Some(k) => {
          kv.delete(k) catch {
            _ =>
              return kv_json_response(
                "{\"error\":\"Failed to delete key\"}", 500,
              )
          }
          kv_json_response("{\"success\":true,\"key\":\"" + k + "\"}", 200)
        }
        None => kv_json_response("{\"error\":\"Missing key parameter\"}", 400)
      }
    } else if pathname == "/kv/counter/increment" {
      // Increment a counter
      let current_str = kv.get("counter") catch {
        _ =>
          return kv_json_response("{\"error\":\"Failed to get counter\"}", 500)
      }
      let current = match current_str {
        Some(s) => @global.parse_int(s).unwrap_or(0)
        None => 0
      }
      let new_value = current + 1
      let new_value_str = new_value.to_string()
      kv.put("counter", new_value_str) catch {
        _ =>
          return kv_json_response(
            "{\"error\":\"Failed to update counter\"}", 500,
          )
      }
      kv_json_response("{\"counter\":" + new_value_str + "}", 200)
    } else if pathname == "/kv/counter/get" {
      // Get current counter value
      let current_str = kv.get("counter") catch {
        _ =>
          return kv_json_response("{\"error\":\"Failed to get counter\"}", 500)
      }
      let current = match current_str {
        Some(s) => s
        None => "0"
      }
      kv_json_response("{\"counter\":" + current + "}", 200)
    } else if pathname == "/kv/list" {
      // List all keys
      let result = kv.list() catch {
        _ => return kv_json_response("{\"error\":\"Failed to list keys\"}", 500)
      }
      let keys = result.keys
      let keys_json = @core.new_array()
      let mut i = 0
      while i < keys.length() {
        let key = keys[i]
        let name = key.name
        keys_json._call("push", [@core.any(name)]) |> ignore
        i = i + 1
      }
      let response_json = @core.new_object()
      response_json["keys"] = keys_json |> @core.any
      response_json["count"] = keys.length() |> @core.any

      // Convert to JSON string
      let json_str = @js.JSON::stringify(response_json)
      kv_json_response(json_str, 200)
    } else {
      // Help/index page
      let help = "{\"endpoints\":[\"/kv/get?key=x\",\"/kv/put?key=x&value=y\",\"/kv/delete?key=x\",\"/kv/counter/increment\",\"/kv/counter/get\",\"/kv/list\"]}"
      kv_json_response(help, 200)
    }
  }
  promisify3(async_handler)
}
