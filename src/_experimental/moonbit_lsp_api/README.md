# MoonBit LSP API

MoonBit language server client library for programmatic access to moonbit-lsp capabilities.

## Overview

This package provides a type-safe API for interacting with the MoonBit Language Server Protocol (LSP) server. It spawns `moonbit-lsp` as a child process and communicates via JSON-RPC 2.0 over stdio.

## Supported Capabilities

Based on moonbit-lsp server capabilities:

| Capability | Method | Status |
|------------|--------|--------|
| Text Document Sync | `textDocument/didOpen`, `textDocument/didClose` | Supported |
| Hover | `textDocument/hover` | Supported |
| Go to Definition | `textDocument/definition` | Supported |
| Find References | `textDocument/references` | Supported |
| Rename | `textDocument/rename` | Supported |
| Document Symbols | `textDocument/documentSymbol` | Supported |
| Workspace Symbols | `workspace/symbol` | Supported |
| Document Formatting | `textDocument/formatting` | Supported |
| Completion | `textDocument/completion` | Supported |
| Signature Help | `textDocument/signatureHelp` | Supported |
| Code Actions | `textDocument/codeAction` | Supported |
| Call Hierarchy | `callHierarchy/incomingCalls`, `callHierarchy/outgoingCalls` | Supported |
| Inlay Hints | `textDocument/inlayHint` | Supported |
| Code Lens | `textDocument/codeLens` | Not implemented |
| Folding Range | `textDocument/foldingRange` | Not implemented |
| Semantic Tokens | `textDocument/semanticTokens` | Not implemented |
| Inline Completion | `textDocument/inlineCompletion` | Not implemented |

## Usage

### Callback-based API

```moonbit
fn main {
  let client = LspClient::new()

  // Initialize the client
  client.initialize("file:///path/to/project", fn(result) {
    match result {
      Ok(_) => {
        // Open a document
        client.open_document(
          "file:///path/to/file.mbt",
          "moonbit",
          1,
          "fn main { ... }",
        )

        // Get hover information
        client.hover("file:///path/to/file.mbt", 0, 3, fn(result) {
          match result {
            Ok(Some(hover)) => println(hover.contents.value)
            Ok(None) => println("No hover info")
            Err(error) => println("Error: " + error.to_string())
          }
        })

        // Shutdown when done
        client.shutdown(fn(_) { client.exit() })
      }
      Err(error) => println("Failed to initialize: " + error.to_string())
    }
  })
}
```

### Async API

```moonbit
async fn main_async() -> Unit raise LspError {
  let root_uri = path_to_uri("/path/to/project")

  with_lsp_client(root_uri, async fn(client) {
    let uri = path_to_uri("/path/to/file.mbt")

    // Open document
    client.open_document(uri, "moonbit", 1, "fn main { ... }")

    // Get hover information
    let hover = client.hover_async(uri, 0, 3)
    match hover {
      Some(h) => println(h.contents.value)
      None => println("No hover info")
    }

    // Get completions
    let completions = client.completion_async(uri, 0, 10)
    for item in completions.items {
      println(item.label)
    }

    // Get document symbols
    let symbols = client.document_symbol_async(uri)
    for sym in symbols {
      println(sym.name)
    }

    // Rename a symbol
    let edit = client.rename_async(uri, 0, 3, "new_name")
    for entry in edit.changes {
      println("File: " + entry.0)
    }
  })
}
```

## API Reference

### Core Types

- `LspClient` - Main client for LSP communication
- `Position` - Line and character position in a document
- `Range` - Start and end positions
- `Location` - URI and range
- `TextEdit` - A text modification
- `WorkspaceEdit` - Collection of text edits across files

### LSP Response Types

- `Hover` - Hover information with markup content
- `CompletionList` - List of completion items
- `CompletionItem` - Single completion suggestion
- `SignatureHelp` - Function signature information
- `DocumentSymbol` - Symbol in a document with hierarchy
- `SymbolInformation` - Workspace symbol information
- `CodeAction` - Available code action
- `CallHierarchyItem` - Item in call hierarchy
- `CallHierarchyIncomingCall` - Incoming call to a function
- `CallHierarchyOutgoingCall` - Outgoing call from a function
- `InlayHint` - Inlay hint annotation

### LspClient Methods

#### Lifecycle

- `new()` - Create a new LSP client
- `initialize(root_uri, callback)` - Initialize the server
- `shutdown(callback)` - Shutdown the server
- `exit()` - Exit the server process

#### Document Management

- `open_document(uri, language_id, version, text)` - Open a document
- `close_document(uri)` - Close a document

#### Navigation

- `definition(uri, line, character, callback)` - Go to definition
- `references(uri, line, character, include_declaration?, callback)` - Find references

#### Information

- `hover(uri, line, character, callback)` - Get hover information
- `completion(uri, line, character, callback)` - Get completions
- `signature_help(uri, line, character, callback)` - Get signature help
- `document_symbol(uri, callback)` - Get document symbols
- `workspace_symbol(query, callback)` - Search workspace symbols
- `inlay_hint(uri, range, callback)` - Get inlay hints

#### Refactoring

- `rename(uri, line, character, new_name, callback)` - Rename symbol
- `formatting(uri, tab_size?, insert_spaces?, callback)` - Format document
- `code_action(uri, range, callback)` - Get code actions

#### Call Hierarchy

- `prepare_call_hierarchy(uri, line, character, callback)` - Prepare call hierarchy
- `incoming_calls(item, callback)` - Get incoming calls
- `outgoing_calls(item, callback)` - Get outgoing calls

### Async Methods

All callback-based methods have async versions with `_async` suffix:

- `initialize_async(root_uri)` -> `@js.Any`
- `shutdown_async()` -> `Unit`
- `definition_async(uri, line, character)` -> `Array[Location]`
- `references_async(uri, line, character, include_declaration?)` -> `Array[Location]`
- `hover_async(uri, line, character)` -> `Hover?`
- `completion_async(uri, line, character)` -> `CompletionList`
- `signature_help_async(uri, line, character)` -> `SignatureHelp?`
- `document_symbol_async(uri)` -> `Array[DocumentSymbol]`
- `workspace_symbol_async(query)` -> `Array[SymbolInformation]`
- `formatting_async(uri, tab_size?, insert_spaces?)` -> `Array[TextEdit]`
- `code_action_async(uri, range)` -> `Array[CodeAction]`
- `prepare_call_hierarchy_async(uri, line, character)` -> `Array[CallHierarchyItem]`
- `incoming_calls_async(item)` -> `Array[CallHierarchyIncomingCall]`
- `outgoing_calls_async(item)` -> `Array[CallHierarchyOutgoingCall]`
- `inlay_hint_async(uri, range)` -> `Array[InlayHint]`
- `rename_async(uri, line, character, new_name)` -> `WorkspaceEdit`

### Utility Functions

- `path_to_uri(path)` - Convert file path to file:// URI
- `uri_to_path(uri)` - Convert file:// URI to file path
- `with_lsp_client(root_uri, action)` - Helper for managed client lifecycle

## Symbol Kind Constants

```moonbit
SYMBOL_KIND_FILE = 1
SYMBOL_KIND_MODULE = 2
SYMBOL_KIND_NAMESPACE = 3
SYMBOL_KIND_PACKAGE = 4
SYMBOL_KIND_CLASS = 5
SYMBOL_KIND_METHOD = 6
SYMBOL_KIND_PROPERTY = 7
SYMBOL_KIND_FIELD = 8
SYMBOL_KIND_CONSTRUCTOR = 9
SYMBOL_KIND_ENUM = 10
SYMBOL_KIND_INTERFACE = 11
SYMBOL_KIND_FUNCTION = 12
SYMBOL_KIND_VARIABLE = 13
SYMBOL_KIND_CONSTANT = 14
SYMBOL_KIND_STRING = 15
SYMBOL_KIND_NUMBER = 16
SYMBOL_KIND_BOOLEAN = 17
SYMBOL_KIND_ARRAY = 18
SYMBOL_KIND_OBJECT = 19
SYMBOL_KIND_KEY = 20
SYMBOL_KIND_NULL = 21
SYMBOL_KIND_ENUM_MEMBER = 22
SYMBOL_KIND_STRUCT = 23
SYMBOL_KIND_EVENT = 24
SYMBOL_KIND_OPERATOR = 25
SYMBOL_KIND_TYPE_PARAMETER = 26
```

## Completion Kind Constants

```moonbit
COMPLETION_KIND_TEXT = 1
COMPLETION_KIND_METHOD = 2
COMPLETION_KIND_FUNCTION = 3
COMPLETION_KIND_CONSTRUCTOR = 4
COMPLETION_KIND_FIELD = 5
COMPLETION_KIND_VARIABLE = 6
COMPLETION_KIND_CLASS = 7
COMPLETION_KIND_INTERFACE = 8
COMPLETION_KIND_MODULE = 9
COMPLETION_KIND_PROPERTY = 10
COMPLETION_KIND_UNIT = 11
COMPLETION_KIND_VALUE = 12
COMPLETION_KIND_ENUM = 13
COMPLETION_KIND_KEYWORD = 14
COMPLETION_KIND_SNIPPET = 15
COMPLETION_KIND_COLOR = 16
COMPLETION_KIND_FILE = 17
COMPLETION_KIND_REFERENCE = 18
COMPLETION_KIND_FOLDER = 19
COMPLETION_KIND_ENUM_MEMBER = 20
COMPLETION_KIND_CONSTANT = 21
COMPLETION_KIND_STRUCT = 22
COMPLETION_KIND_EVENT = 23
COMPLETION_KIND_OPERATOR = 24
COMPLETION_KIND_TYPE_PARAMETER = 25
```

## Error Handling

All operations can fail with `LspError`:

```moonbit
pub suberror LspError {
  ServerError(code~ : Int, message~ : String)
}
```

For async operations, errors are raised and can be caught with try-catch.

## Requirements

- MoonBit toolchain with `moonbit-lsp` installed
- Node.js runtime (for child_process spawn)
