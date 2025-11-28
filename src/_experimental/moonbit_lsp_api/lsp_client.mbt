///|
/// MoonBit LSP Client - Provides type-safe API for interacting with moonbit-lsp
/// Uses JSON-RPC 2.0 protocol over stdio

///|
/// LSP Client for communicating with moonbit-lsp server
pub struct LspClient {
  process : @child_process.ChildProcess
  mut request_id : Int
  pending_requests : Map[Int, (@js.Any) -> Unit]
  mut is_initialized : Bool
  mut buffer : String
}

///|
/// Position in a text document (0-indexed)
pub(all) struct Position {
  line : Int
  character : Int
}

///|
pub impl @js.JsImpl for Position

///|
pub fn Position::to_json(self : Position) -> @js.Any {
  @js.from_map({
    "line": @js.any(self.line),
    "character": @js.any(self.character),
  })
}

///|
pub fn Position::from_json(json : @js.Any) -> Position {
  { line: json.get("line").cast(), character: json.get("character").cast() }
}

///|
/// Range in a text document
pub(all) struct Range {
  start : Position
  end_ : Position
}

///|
pub impl @js.JsImpl for Range

///|
pub fn Range::to_json(self : Range) -> @js.Any {
  @js.from_map({ "start": self.start.to_json(), "end": self.end_.to_json() })
}

///|
pub fn Range::from_json(json : @js.Any) -> Range {
  {
    start: Position::from_json(json.get("start")),
    end_: Position::from_json(json.get("end")),
  }
}

///|
/// Location (uri + range)
pub(all) struct Location {
  uri : String
  range : Range
}

///|
pub impl @js.JsImpl for Location

///|
pub fn Location::from_json(json : @js.Any) -> Location {
  { uri: json.get("uri").cast(), range: Range::from_json(json.get("range")) }
}

///|
/// Text document identifier
pub(all) struct TextDocumentIdentifier {
  uri : String
}

///|
fn TextDocumentIdentifier::to_json(self : TextDocumentIdentifier) -> @js.Any {
  @js.from_map({ "uri": @js.any(self.uri) })
}

///|
/// Text document position params
pub(all) struct TextDocumentPositionParams {
  text_document : TextDocumentIdentifier
  position : Position
}

///|
fn TextDocumentPositionParams::to_json(
  self : TextDocumentPositionParams,
) -> @js.Any {
  @js.from_map({
    "textDocument": self.text_document.to_json(),
    "position": self.position.to_json(),
  })
}

///|
/// Rename params
pub(all) struct RenameParams {
  text_document : TextDocumentIdentifier
  position : Position
  new_name : String
}

///|
fn RenameParams::to_json(self : RenameParams) -> @js.Any {
  @js.from_map({
    "textDocument": self.text_document.to_json(),
    "position": self.position.to_json(),
    "newName": @js.any(self.new_name),
  })
}

///|
/// Text edit for workspace edit
pub(all) struct TextEdit {
  range : Range
  new_text : String
}

///|
pub impl @js.JsImpl for TextEdit

///|
pub fn TextEdit::from_json(json : @js.Any) -> TextEdit {
  {
    range: Range::from_json(json.get("range")),
    new_text: json.get("newText").cast(),
  }
}

///|
/// Workspace edit result from rename
pub(all) struct WorkspaceEdit {
  changes : Map[String, Array[TextEdit]]
}

///|
pub fn WorkspaceEdit::from_json(json : @js.Any) -> WorkspaceEdit {
  let changes_obj = json.get("changes")
  let changes : Map[String, Array[TextEdit]] = {}
  if not(@js.is_nullish(changes_obj)) {
    let keys = @js.Object::keys(changes_obj)
    for i in 0..<keys.length() {
      let key : String = keys.get(i).unwrap()
      let edits_arr = changes_obj.get(key)
      let edits : Array[TextEdit] = []
      let len : Int = edits_arr.get("length").cast()
      for j in 0..<len {
        edits.push(TextEdit::from_json(edits_arr.get(j)))
      }
      changes[key] = edits
    }
  }
  { changes, }
}

///|
/// LSP error type
pub suberror LspError {
  ServerError(code~ : Int, message~ : String)
}

///|
pub impl Show for LspError with output(self, logger) {
  match self {
    ServerError(code~, message~) => {
      logger.write_string("LspError(")
      logger.write_string(code.to_string())
      logger.write_string(", ")
      logger.write_string(message)
      logger.write_string(")")
    }
  }
}

///|
/// Create a new LSP client by spawning moonbit-lsp
pub fn LspClient::new() -> LspClient {
  let lsp_path = get_lsp_path()
  let process = @child_process.spawn(lsp_path, args=["--stdio"])
  let client : LspClient = {
    process,
    request_id: 0,
    pending_requests: {},
    is_initialized: false,
    buffer: "",
  }
  // Setup stdout handler for responses
  client.setup_response_handler()
  client
}

///|
extern "js" fn ffi_get_lsp_path() -> String =
  #|() => {
  #|  const path = require('node:path');
  #|  const os = require('node:os');
  #|  const moonHome = process.env.MOON_HOME || path.join(os.homedir(), '.moon');
  #|  return path.join(moonHome, 'bin', 'moonbit-lsp');
  #|}

///|
fn get_lsp_path() -> String {
  ffi_get_lsp_path()
}

///|
fn LspClient::setup_response_handler(self : LspClient) -> Unit {
  self.process.stdout.call2(
    "on",
    "data",
    @js.from_fn1(fn(data : @js.Any) {
      let chunk : String = data.call0("toString").cast()
      self.buffer = self.buffer + chunk
      self.process_buffer()
    }),
  )
  |> ignore
}

///|
fn LspClient::process_buffer(self : LspClient) -> Unit {
  // LSP uses Content-Length header
  // Format: Content-Length: <length>\r\n\r\n<json>
  while true {
    let header_end = ffi_index_of(self.buffer, "\r\n\r\n")
    if header_end < 0 {
      break
    }
    let header = ffi_substring(self.buffer, 0, header_end)
    let content_length = parse_content_length(header)
    if content_length < 0 {
      break
    }
    let content_start = header_end + 4
    let total_length = content_start + content_length
    if ffi_string_length(self.buffer) < total_length {
      break
    }
    let content = ffi_substring(self.buffer, content_start, total_length)
    self.buffer = ffi_substring(
      self.buffer,
      total_length,
      ffi_string_length(self.buffer),
    )
    self.handle_message(content)
  }
}

///|
extern "js" fn ffi_index_of(s : String, search : String) -> Int =
  #|(s, search) => s.indexOf(search)

///|
extern "js" fn ffi_substring(s : String, start : Int, end : Int) -> String =
  #|(s, start, end) => s.substring(start, end)

///|
extern "js" fn ffi_string_length(s : String) -> Int =
  #|(s) => s.length

///|
fn parse_content_length(header : String) -> Int {
  ffi_parse_content_length(header)
}

///|
extern "js" fn ffi_parse_content_length(header : String) -> Int =
  #|(header) => {
  #|  const match = header.match(/Content-Length:\s*(\d+)/i);
  #|  return match ? parseInt(match[1], 10) : -1;
  #|}

///|
extern "js" fn ffi_json_parse(content : String) -> @js.Any =
  #|(content) => JSON.parse(content)

///|
fn LspClient::handle_message(self : LspClient, content : String) -> Unit {
  let json = ffi_json_parse(content)
  let id = json.get("id")
  if not(@js.is_nullish(id)) {
    let request_id : Int = id.cast()
    match self.pending_requests.get(request_id) {
      Some(callback) => {
        self.pending_requests.remove(request_id)
        callback(json)
      }
      None => ()
    }
  }
}

///|
fn LspClient::send_request(
  self : LspClient,
  method_name : String,
  params : @js.Any,
  callback : (@js.Any) -> Unit,
) -> Unit {
  self.request_id = self.request_id + 1
  let id = self.request_id
  let request = @js.from_map({
    "jsonrpc": @js.any("2.0"),
    "id": @js.any(id),
    "method": @js.any(method_name),
    "params": params,
  })
  let content = @js.JSON::stringify(request)
  let message = "Content-Length: " +
    ffi_string_length(content).to_string() +
    "\r\n\r\n" +
    content
  self.pending_requests[id] = callback
  self.process.stdin.call("write", [message]) |> ignore
}

///|
fn LspClient::send_notification(
  self : LspClient,
  method_name : String,
  params : @js.Any,
) -> Unit {
  let notification = @js.from_map({
    "jsonrpc": @js.any("2.0"),
    "method": @js.any(method_name),
    "params": params,
  })
  let content = @js.JSON::stringify(notification)
  let message = "Content-Length: " +
    ffi_string_length(content).to_string() +
    "\r\n\r\n" +
    content
  self.process.stdin.call("write", [message]) |> ignore
}

///|
extern "js" fn ffi_get_pid() -> Int =
  #|() => process.pid

///|
extern "js" fn ffi_is_array(value : @js.Any) -> Bool =
  #|(value) => Array.isArray(value)

///|
/// Initialize the LSP server
pub async fn LspClient::initialize(
  self : LspClient,
  root_uri : String,
) -> @js.Any raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = @js.from_map({
      "processId": @js.any(ffi_get_pid()),
      "rootUri": @js.any(root_uri),
      "capabilities": @js.from_map({
        "textDocument": @js.from_map({
          "definition": @js.from_map({ "dynamicRegistration": @js.any(true) }),
          "references": @js.from_map({ "dynamicRegistration": @js.any(true) }),
          "rename": @js.from_map({
            "dynamicRegistration": @js.any(true),
            "prepareSupport": @js.any(true),
          }),
        }),
      }),
    })
    self.send_request("initialize", params, fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        self.is_initialized = true
        // Send initialized notification
        self.send_notification("initialized", @js.from_map({}))
        resolve(response.get("result"))
      }
    })
  })
}

///|
/// Shutdown the LSP server
pub async fn LspClient::shutdown(self : LspClient) -> Unit raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.send_request("shutdown", @js.null_(), fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        resolve(())
      }
    })
  })
}

///|
/// Exit the LSP server
pub fn LspClient::exit(self : LspClient) -> Unit {
  self.send_notification("exit", @js.null_())
  self.process.kill() |> ignore
}

///|
/// Open a text document
pub fn LspClient::open_document(
  self : LspClient,
  uri : String,
  language_id : String,
  version : Int,
  text : String,
) -> Unit {
  let params = @js.from_map({
    "textDocument": @js.from_map({
      "uri": @js.any(uri),
      "languageId": @js.any(language_id),
      "version": @js.any(version),
      "text": @js.any(text),
    }),
  })
  self.send_notification("textDocument/didOpen", params)
}

///|
/// Close a text document
pub fn LspClient::close_document(self : LspClient, uri : String) -> Unit {
  let params = @js.from_map({
    "textDocument": @js.from_map({ "uri": @js.any(uri) }),
  })
  self.send_notification("textDocument/didClose", params)
}

///|
/// Go to definition
pub async fn LspClient::definition(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> Array[Location] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = TextDocumentPositionParams::{
      text_document: { uri, },
      position: { line, character },
    }
    self.send_request("textDocument/definition", params.to_json(), fn(
      response,
    ) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let locations : Array[Location] = []
        if not(@js.is_nullish(result)) {
          // Result can be Location | Location[] | null
          if ffi_is_array(result) {
            let len : Int = result.get("length").cast()
            for i in 0..<len {
              locations.push(Location::from_json(result.get(i)))
            }
          } else {
            locations.push(Location::from_json(result))
          }
        }
        resolve(locations)
      }
    })
  })
}

///|
/// Find all references
pub async fn LspClient::references(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
  include_declaration? : Bool,
) -> Array[Location] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = @js.from_map({
      "textDocument": @js.from_map({ "uri": @js.any(uri) }),
      "position": @js.from_map({
        "line": @js.any(line),
        "character": @js.any(character),
      }),
      "context": @js.from_map({
        "includeDeclaration": @js.any(include_declaration.unwrap_or(true)),
      }),
    })
    self.send_request("textDocument/references", params, fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let locations : Array[Location] = []
        if not(@js.is_nullish(result)) {
          let len : Int = result.get("length").cast()
          for i in 0..<len {
            locations.push(Location::from_json(result.get(i)))
          }
        }
        resolve(locations)
      }
    })
  })
}

///|
/// Rename symbol
pub async fn LspClient::rename(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
  new_name : String,
) -> WorkspaceEdit raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = RenameParams::{
      text_document: { uri, },
      position: { line, character },
      new_name,
    }
    self.send_request("textDocument/rename", params.to_json(), fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        if @js.is_nullish(result) {
          resolve({ changes: {} })
        } else {
          resolve(WorkspaceEdit::from_json(result))
        }
      }
    })
  })
}

///|
/// Get hover information
pub async fn LspClient::hover(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> Hover? raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = TextDocumentPositionParams::{
      text_document: { uri, },
      position: { line, character },
    }
    self.send_request("textDocument/hover", params.to_json(), fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        if @js.is_nullish(result) {
          resolve(None)
        } else {
          resolve(Some(Hover::from_json(result)))
        }
      }
    })
  })
}

///|
/// Get completion items
pub async fn LspClient::completion(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> CompletionList raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = TextDocumentPositionParams::{
      text_document: { uri, },
      position: { line, character },
    }
    self.send_request("textDocument/completion", params.to_json(), fn(
      response,
    ) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        if @js.is_nullish(result) {
          resolve({ is_incomplete: false, items: [] })
        } else {
          resolve(CompletionList::from_json(result))
        }
      }
    })
  })
}

///|
/// Get signature help
pub async fn LspClient::signature_help(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> SignatureHelp? raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = TextDocumentPositionParams::{
      text_document: { uri, },
      position: { line, character },
    }
    self.send_request("textDocument/signatureHelp", params.to_json(), fn(
      response,
    ) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        if @js.is_nullish(result) {
          resolve(None)
        } else {
          resolve(Some(SignatureHelp::from_json(result)))
        }
      }
    })
  })
}

///|
/// Get document symbols
pub async fn LspClient::document_symbol(
  self : LspClient,
  uri : String,
) -> Array[DocumentSymbol] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = @js.from_map({
      "textDocument": @js.from_map({ "uri": @js.any(uri) }),
    })
    self.send_request("textDocument/documentSymbol", params, fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let symbols : Array[DocumentSymbol] = []
        if not(@js.is_nullish(result)) {
          let len : Int = result.get("length").cast()
          for i in 0..<len {
            symbols.push(DocumentSymbol::from_json(result.get(i)))
          }
        }
        resolve(symbols)
      }
    })
  })
}

///|
/// Search workspace symbols
pub async fn LspClient::workspace_symbol(
  self : LspClient,
  query : String,
) -> Array[SymbolInformation] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = @js.from_map({ "query": @js.any(query) })
    self.send_request("workspace/symbol", params, fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let symbols : Array[SymbolInformation] = []
        if not(@js.is_nullish(result)) {
          let len : Int = result.get("length").cast()
          for i in 0..<len {
            symbols.push(SymbolInformation::from_json(result.get(i)))
          }
        }
        resolve(symbols)
      }
    })
  })
}

///|
/// Format document
pub async fn LspClient::formatting(
  self : LspClient,
  uri : String,
  tab_size? : Int,
  insert_spaces? : Bool,
) -> Array[TextEdit] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = @js.from_map({
      "textDocument": @js.from_map({ "uri": @js.any(uri) }),
      "options": @js.from_map({
        "tabSize": @js.any(tab_size.unwrap_or(2)),
        "insertSpaces": @js.any(insert_spaces.unwrap_or(true)),
      }),
    })
    self.send_request("textDocument/formatting", params, fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let edits : Array[TextEdit] = []
        if not(@js.is_nullish(result)) {
          let len : Int = result.get("length").cast()
          for i in 0..<len {
            edits.push(TextEdit::from_json(result.get(i)))
          }
        }
        resolve(edits)
      }
    })
  })
}

///|
/// Get code actions
pub async fn LspClient::code_action(
  self : LspClient,
  uri : String,
  range : Range,
) -> Array[CodeAction] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = @js.from_map({
      "textDocument": @js.from_map({ "uri": @js.any(uri) }),
      "range": range.to_json(),
      "context": @js.from_map({
        "diagnostics": @js.from_array(([] : Array[@js.Any])),
      }),
    })
    self.send_request("textDocument/codeAction", params, fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let actions : Array[CodeAction] = []
        if not(@js.is_nullish(result)) {
          let len : Int = result.get("length").cast()
          for i in 0..<len {
            actions.push(CodeAction::from_json(result.get(i)))
          }
        }
        resolve(actions)
      }
    })
  })
}

///|
/// Prepare call hierarchy
pub async fn LspClient::prepare_call_hierarchy(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> Array[CallHierarchyItem] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = TextDocumentPositionParams::{
      text_document: { uri, },
      position: { line, character },
    }
    self.send_request("textDocument/prepareCallHierarchy", params.to_json(), fn(
      response,
    ) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let items : Array[CallHierarchyItem] = []
        if not(@js.is_nullish(result)) {
          let len : Int = result.get("length").cast()
          for i in 0..<len {
            items.push(CallHierarchyItem::from_json(result.get(i)))
          }
        }
        resolve(items)
      }
    })
  })
}

///|
/// Get incoming calls
pub async fn LspClient::incoming_calls(
  self : LspClient,
  item : CallHierarchyItem,
) -> Array[CallHierarchyIncomingCall] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = @js.from_map({
      "item": @js.from_map({
        "name": @js.any(item.name),
        "kind": @js.any(item.kind),
        "uri": @js.any(item.uri),
        "range": item.range.to_json(),
        "selectionRange": item.selection_range.to_json(),
      }),
    })
    self.send_request("callHierarchy/incomingCalls", params, fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let calls : Array[CallHierarchyIncomingCall] = []
        if not(@js.is_nullish(result)) {
          let len : Int = result.get("length").cast()
          for i in 0..<len {
            calls.push(CallHierarchyIncomingCall::from_json(result.get(i)))
          }
        }
        resolve(calls)
      }
    })
  })
}

///|
/// Get outgoing calls
pub async fn LspClient::outgoing_calls(
  self : LspClient,
  item : CallHierarchyItem,
) -> Array[CallHierarchyOutgoingCall] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = @js.from_map({
      "item": @js.from_map({
        "name": @js.any(item.name),
        "kind": @js.any(item.kind),
        "uri": @js.any(item.uri),
        "range": item.range.to_json(),
        "selectionRange": item.selection_range.to_json(),
      }),
    })
    self.send_request("callHierarchy/outgoingCalls", params, fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let calls : Array[CallHierarchyOutgoingCall] = []
        if not(@js.is_nullish(result)) {
          let len : Int = result.get("length").cast()
          for i in 0..<len {
            calls.push(CallHierarchyOutgoingCall::from_json(result.get(i)))
          }
        }
        resolve(calls)
      }
    })
  })
}

///|
/// Get inlay hints
pub async fn LspClient::inlay_hint(
  self : LspClient,
  uri : String,
  range : Range,
) -> Array[InlayHint] raise LspError {
  @js.suspend(fn(resolve, reject) {
    let params = @js.from_map({
      "textDocument": @js.from_map({ "uri": @js.any(uri) }),
      "range": range.to_json(),
    })
    self.send_request("textDocument/inlayHint", params, fn(response) {
      let error = response.get("error")
      if not(@js.is_nullish(error)) {
        reject(
          ServerError(
            code=error.get("code").cast(),
            message=error.get("message").cast(),
          ),
        )
      } else {
        let result = response.get("result")
        let hints : Array[InlayHint] = []
        if not(@js.is_nullish(result)) {
          let len : Int = result.get("length").cast()
          for i in 0..<len {
            hints.push(InlayHint::from_json(result.get(i)))
          }
        }
        resolve(hints)
      }
    })
  })
}

///|
/// Convert file path to URI
pub fn path_to_uri(path : String) -> String {
  ffi_path_to_uri(path)
}

///|
extern "js" fn ffi_path_to_uri(path : String) -> String =
  #|(path) => {
  #|  const { pathToFileURL } = require('node:url');
  #|  const { resolve } = require('node:path');
  #|  return pathToFileURL(resolve(path)).href;
  #|}

///|
/// Convert URI to file path
pub fn uri_to_path(uri : String) -> String {
  ffi_uri_to_path(uri)
}

///|
extern "js" fn ffi_uri_to_path(uri : String) -> String =
  #|(uri) => {
  #|  const { fileURLToPath } = require('node:url');
  #|  return fileURLToPath(uri);
  #|}

///|
/// Helper: Create client, initialize, run action, then shutdown and exit
pub async fn[T] with_lsp_client(
  root_uri : String,
  action : async (LspClient) -> T raise LspError,
) -> T raise LspError {
  let client = LspClient::new()
  let _ = client.initialize(root_uri)
  // Give the server time to initialize
  @js.sleep(100)
  let result = action(client)
  client.shutdown()
  client.exit()
  result
}
