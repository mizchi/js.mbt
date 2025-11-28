///|
/// Async API for MoonBit LSP Client
/// Promise-based wrapper around callback-based LspClient

///|
/// Initialize the LSP server (async)
pub async fn LspClient::initialize_async(
  self : LspClient,
  root_uri : String,
) -> @js.Any raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.initialize(root_uri, fn(result) {
      match result {
        Ok(value) => resolve(value)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Shutdown the LSP server (async)
pub async fn LspClient::shutdown_async(self : LspClient) -> Unit raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.shutdown(fn(result) {
      match result {
        Ok(_) => resolve(())
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Go to definition (async)
pub async fn LspClient::definition_async(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> Array[Location] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.definition(uri, line, character, fn(result) {
      match result {
        Ok(locations) => resolve(locations)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Find all references (async)
pub async fn LspClient::references_async(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
  include_declaration? : Bool,
) -> Array[Location] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.references(
      uri,
      line,
      character,
      include_declaration=include_declaration.unwrap_or(true),
      fn(result) {
        match result {
          Ok(locations) => resolve(locations)
          Err(error) => reject(error)
        }
      },
    )
  })
}

///|
/// Rename symbol (async)
pub async fn LspClient::rename_async(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
  new_name : String,
) -> WorkspaceEdit raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.rename(uri, line, character, new_name, fn(result) {
      match result {
        Ok(edit) => resolve(edit)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Get hover information (async)
pub async fn LspClient::hover_async(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> Hover? raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.hover(uri, line, character, fn(result) {
      match result {
        Ok(hover) => resolve(hover)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Get completion items (async)
pub async fn LspClient::completion_async(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> CompletionList raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.completion(uri, line, character, fn(result) {
      match result {
        Ok(list) => resolve(list)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Get signature help (async)
pub async fn LspClient::signature_help_async(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> SignatureHelp? raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.signature_help(uri, line, character, fn(result) {
      match result {
        Ok(help) => resolve(help)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Get document symbols (async)
pub async fn LspClient::document_symbol_async(
  self : LspClient,
  uri : String,
) -> Array[DocumentSymbol] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.document_symbol(uri, fn(result) {
      match result {
        Ok(symbols) => resolve(symbols)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Search workspace symbols (async)
pub async fn LspClient::workspace_symbol_async(
  self : LspClient,
  query : String,
) -> Array[SymbolInformation] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.workspace_symbol(query, fn(result) {
      match result {
        Ok(symbols) => resolve(symbols)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Format document (async)
pub async fn LspClient::formatting_async(
  self : LspClient,
  uri : String,
  tab_size? : Int,
  insert_spaces? : Bool,
) -> Array[TextEdit] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.formatting(
      uri,
      tab_size=tab_size.unwrap_or(2),
      insert_spaces=insert_spaces.unwrap_or(true),
      fn(result) {
        match result {
          Ok(edits) => resolve(edits)
          Err(error) => reject(error)
        }
      },
    )
  })
}

///|
/// Get code actions (async)
pub async fn LspClient::code_action_async(
  self : LspClient,
  uri : String,
  range : Range,
) -> Array[CodeAction] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.code_action(uri, range, fn(result) {
      match result {
        Ok(actions) => resolve(actions)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Prepare call hierarchy (async)
pub async fn LspClient::prepare_call_hierarchy_async(
  self : LspClient,
  uri : String,
  line : Int,
  character : Int,
) -> Array[CallHierarchyItem] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.prepare_call_hierarchy(uri, line, character, fn(result) {
      match result {
        Ok(items) => resolve(items)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Get incoming calls (async)
pub async fn LspClient::incoming_calls_async(
  self : LspClient,
  item : CallHierarchyItem,
) -> Array[CallHierarchyIncomingCall] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.incoming_calls(item, fn(result) {
      match result {
        Ok(calls) => resolve(calls)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Get outgoing calls (async)
pub async fn LspClient::outgoing_calls_async(
  self : LspClient,
  item : CallHierarchyItem,
) -> Array[CallHierarchyOutgoingCall] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.outgoing_calls(item, fn(result) {
      match result {
        Ok(calls) => resolve(calls)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Get inlay hints (async)
pub async fn LspClient::inlay_hint_async(
  self : LspClient,
  uri : String,
  range : Range,
) -> Array[InlayHint] raise LspError {
  @js.suspend(fn(resolve, reject) {
    self.inlay_hint(uri, range, fn(result) {
      match result {
        Ok(hints) => resolve(hints)
        Err(error) => reject(error)
      }
    })
  })
}

///|
/// Helper: Create client, initialize, run action, then shutdown and exit
pub async fn[T] with_lsp_client(
  root_uri : String,
  action : async (LspClient) -> T raise LspError,
) -> T raise LspError {
  let client = LspClient::new()
  let _ = client.initialize_async(root_uri)
  // Give the server time to initialize
  @js.sleep(100)
  let result = action(client)
  client.shutdown_async()
  client.exit()
  result
}
