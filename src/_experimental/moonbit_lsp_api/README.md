# MoonBit LSP API

MoonBit language server client library for programmatic access to moonbit-lsp capabilities.

## Overview

This package provides a type-safe async API for interacting with the MoonBit Language Server Protocol (LSP) server. It spawns `moonbit-lsp` as a child process and communicates via JSON-RPC 2.0 over stdio.

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

```moonbit
async fn main_async() -> Unit raise LspError {
  let root_uri = path_to_uri("/path/to/project")

  with_lsp_client(root_uri, async fn(client) {
    let uri = path_to_uri("/path/to/file.mbt")

    // Open document
    client.open_document(uri, "moonbit", 1, "fn main { ... }")

    // Get hover information
    let hover = client.hover(uri, 0, 3)
    match hover {
      Some(h) => println(h.contents.value)
      None => println("No hover info")
    }

    // Get completions
    let completions = client.completion(uri, 0, 10)
    for item in completions.items {
      println(item.label)
    }

    // Get document symbols
    let symbols = client.document_symbol(uri)
    for sym in symbols {
      println(sym.name)
    }

    // Rename a symbol
    let edit = client.rename(uri, 0, 3, "new_name")
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

All methods are async and raise `LspError` on failure.

#### Lifecycle

- `new()` - Create a new LSP client
- `initialize(root_uri)` -> `@nostd.Any` - Initialize the server
- `shutdown()` -> `Unit` - Shutdown the server
- `exit()` - Exit the server process (sync)

#### Document Management (sync)

- `open_document(uri, language_id, version, text)` - Open a document
- `close_document(uri)` - Close a document

#### Navigation

- `definition(uri, line, character)` -> `Array[Location]`
- `references(uri, line, character, include_declaration?)` -> `Array[Location]`

#### Information

- `hover(uri, line, character)` -> `Hover?`
- `completion(uri, line, character)` -> `CompletionList`
- `signature_help(uri, line, character)` -> `SignatureHelp?`
- `document_symbol(uri)` -> `Array[DocumentSymbol]`
- `workspace_symbol(query)` -> `Array[SymbolInformation]`
- `inlay_hint(uri, range)` -> `Array[InlayHint]`

#### Refactoring

- `rename(uri, line, character, new_name)` -> `WorkspaceEdit`
- `formatting(uri, tab_size?, insert_spaces?)` -> `Array[TextEdit]`
- `code_action(uri, range)` -> `Array[CodeAction]`

#### Call Hierarchy

- `prepare_call_hierarchy(uri, line, character)` -> `Array[CallHierarchyItem]`
- `incoming_calls(item)` -> `Array[CallHierarchyIncomingCall]`
- `outgoing_calls(item)` -> `Array[CallHierarchyOutgoingCall]`

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

All async operations can fail with `LspError`:

```moonbit
pub suberror LspError {
  ServerError(code~ : Int, message~ : String)
}
```

Errors are raised and can be caught with try-catch.

## Requirements

- MoonBit toolchain with `moonbit-lsp` installed
- Node.js runtime (for child_process spawn)
