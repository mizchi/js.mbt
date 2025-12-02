///|
/// Additional LSP types for moonbit-lsp capabilities

///|
/// Hover result
pub(all) struct Hover {
  contents : MarkupContent
  range : Range?
}

///|
pub fn Hover::from_json(json : @nostd.Any) -> Hover {
  let contents = json._get("contents")
  let range_json = json._get("range")
  let range = if @nostd.is_nullish(range_json) {
    None
  } else {
    Some(Range::from_json(range_json))
  }
  { contents: MarkupContent::from_json(contents), range }
}

///|
/// Markup content for hover
pub(all) struct MarkupContent {
  kind : String
  value : String
}

///|
pub fn MarkupContent::from_json(json : @nostd.Any) -> MarkupContent {
  // Can be string or { kind, value }
  if ffi_typeof(json) == "string" {
    { kind: "plaintext", value: json.cast() }
  } else {
    { kind: json._get("kind").cast(), value: json._get("value").cast() }
  }
}

///|
extern "js" fn ffi_typeof(value : @nostd.Any) -> String =
  #|(value) => typeof value

///|
/// Completion item
pub(all) struct CompletionItem {
  label : String
  kind : Int?
  detail : String?
  documentation : String?
  insert_text : String?
  insert_text_format : Int?
}

///|
pub fn CompletionItem::from_json(json : @nostd.Any) -> CompletionItem {
  let kind_json = json._get("kind")
  let detail_json = json._get("detail")
  let doc_json = json._get("documentation")
  let insert_text_json = json._get("insertText")
  let insert_format_json = json._get("insertTextFormat")
  {
    label: json._get("label").cast(),
    kind: if @nostd.is_nullish(kind_json) {
      None
    } else {
      Some(kind_json.cast())
    },
    detail: if @nostd.is_nullish(detail_json) {
      None
    } else {
      Some(detail_json.cast())
    },
    documentation: if @nostd.is_nullish(doc_json) {
      None
    } else if ffi_typeof(doc_json) == "string" {
      Some(doc_json.cast())
    } else {
      Some(doc_json._get("value").cast())
    },
    insert_text: if @nostd.is_nullish(insert_text_json) {
      None
    } else {
      Some(insert_text_json.cast())
    },
    insert_text_format: if @nostd.is_nullish(insert_format_json) {
      None
    } else {
      Some(insert_format_json.cast())
    },
  }
}

///|
/// Completion list
pub(all) struct CompletionList {
  is_incomplete : Bool
  items : Array[CompletionItem]
}

///|
pub fn CompletionList::from_json(json : @nostd.Any) -> CompletionList {
  // Can be CompletionItem[] or CompletionList
  if ffi_is_array(json) {
    let items : Array[CompletionItem] = []
    let len : Int = json._get("length").cast()
    for i in 0..<len {
      items.push(CompletionItem::from_json(json._get_by_index(i)))
    }
    { is_incomplete: false, items }
  } else {
    let items_json = json._get("items")
    let items : Array[CompletionItem] = []
    let len : Int = items_json._get("length").cast()
    for i in 0..<len {
      items.push(CompletionItem::from_json(items_json._get_by_index(i)))
    }
    { is_incomplete: json._get("isIncomplete").cast(), items }
  }
}

///|
/// Signature help
pub(all) struct SignatureHelp {
  signatures : Array[SignatureInformation]
  active_signature : Int?
  active_parameter : Int?
}

///|
pub fn SignatureHelp::from_json(json : @nostd.Any) -> SignatureHelp {
  let sigs_json = json._get("signatures")
  let signatures : Array[SignatureInformation] = []
  let len : Int = sigs_json._get("length").cast()
  for i in 0..<len {
    signatures.push(SignatureInformation::from_json(sigs_json._get_by_index(i)))
  }
  let active_sig = json._get("activeSignature")
  let active_param = json._get("activeParameter")
  {
    signatures,
    active_signature: if @nostd.is_nullish(active_sig) {
      None
    } else {
      Some(active_sig.cast())
    },
    active_parameter: if @nostd.is_nullish(active_param) {
      None
    } else {
      Some(active_param.cast())
    },
  }
}

///|
/// Signature information
pub(all) struct SignatureInformation {
  label : String
  documentation : String?
  parameters : Array[ParameterInformation]
}

///|
pub fn SignatureInformation::from_json(
  json : @nostd.Any,
) -> SignatureInformation {
  let doc_json = json._get("documentation")
  let params_json = json._get("parameters")
  let parameters : Array[ParameterInformation] = []
  if not(@nostd.is_nullish(params_json)) {
    let len : Int = params_json._get("length").cast()
    for i in 0..<len {
      parameters.push(
        ParameterInformation::from_json(params_json._get_by_index(i)),
      )
    }
  }
  {
    label: json._get("label").cast(),
    documentation: if @nostd.is_nullish(doc_json) {
      None
    } else if ffi_typeof(doc_json) == "string" {
      Some(doc_json.cast())
    } else {
      Some(doc_json._get("value").cast())
    },
    parameters,
  }
}

///|
/// Parameter information
pub(all) struct ParameterInformation {
  label : String
  documentation : String?
}

///|
pub fn ParameterInformation::from_json(
  json : @nostd.Any,
) -> ParameterInformation {
  let label_json = json._get("label")
  let doc_json = json._get("documentation")
  {
    label: if ffi_typeof(label_json) == "string" {
      label_json.cast()
    } else {
      // label can be [start, end] tuple
      ""
    },
    documentation: if @nostd.is_nullish(doc_json) {
      None
    } else if ffi_typeof(doc_json) == "string" {
      Some(doc_json.cast())
    } else {
      Some(doc_json._get("value").cast())
    },
  }
}

///|
/// Document symbol
pub(all) struct DocumentSymbol {
  name : String
  detail : String?
  kind : Int
  range : Range
  selection_range : Range
  children : Array[DocumentSymbol]
}

///|
pub fn DocumentSymbol::from_json(json : @nostd.Any) -> DocumentSymbol {
  let detail_json = json._get("detail")
  let children_json = json._get("children")
  let children : Array[DocumentSymbol] = []
  if not(@nostd.is_nullish(children_json)) {
    let len : Int = children_json._get("length").cast()
    for i in 0..<len {
      children.push(DocumentSymbol::from_json(children_json._get_by_index(i)))
    }
  }
  {
    name: json._get("name").cast(),
    detail: if @nostd.is_nullish(detail_json) {
      None
    } else {
      Some(detail_json.cast())
    },
    kind: json._get("kind").cast(),
    range: Range::from_json(json._get("range")),
    selection_range: Range::from_json(json._get("selectionRange")),
    children,
  }
}

///|
/// Symbol information (for workspace symbols)
pub(all) struct SymbolInformation {
  name : String
  kind : Int
  location : Location
  container_name : String?
}

///|
pub fn SymbolInformation::from_json(json : @nostd.Any) -> SymbolInformation {
  let container_json = json._get("containerName")
  {
    name: json._get("name").cast(),
    kind: json._get("kind").cast(),
    location: Location::from_json(json._get("location")),
    container_name: if @nostd.is_nullish(container_json) {
      None
    } else {
      Some(container_json.cast())
    },
  }
}

///|
/// Code action
pub(all) struct CodeAction {
  title : String
  kind : String?
  diagnostics : Array[@nostd.Any]
  is_preferred : Bool?
  edit : WorkspaceEdit?
}

///|
pub fn CodeAction::from_json(json : @nostd.Any) -> CodeAction {
  let kind_json = json._get("kind")
  let pref_json = json._get("isPreferred")
  let edit_json = json._get("edit")
  let diag_json = json._get("diagnostics")
  let diagnostics : Array[@nostd.Any] = []
  if not(@nostd.is_nullish(diag_json)) {
    let len : Int = diag_json._get("length").cast()
    for i in 0..<len {
      diagnostics.push(diag_json._get_by_index(i))
    }
  }
  {
    title: json._get("title").cast(),
    kind: if @nostd.is_nullish(kind_json) {
      None
    } else {
      Some(kind_json.cast())
    },
    diagnostics,
    is_preferred: if @nostd.is_nullish(pref_json) {
      None
    } else {
      Some(pref_json.cast())
    },
    edit: if @nostd.is_nullish(edit_json) {
      None
    } else {
      Some(WorkspaceEdit::from_json(edit_json))
    },
  }
}

///|
/// Call hierarchy item
pub(all) struct CallHierarchyItem {
  name : String
  kind : Int
  detail : String?
  uri : String
  range : Range
  selection_range : Range
}

///|
pub fn CallHierarchyItem::from_json(json : @nostd.Any) -> CallHierarchyItem {
  let detail_json = json._get("detail")
  {
    name: json._get("name").cast(),
    kind: json._get("kind").cast(),
    detail: if @nostd.is_nullish(detail_json) {
      None
    } else {
      Some(detail_json.cast())
    },
    uri: json._get("uri").cast(),
    range: Range::from_json(json._get("range")),
    selection_range: Range::from_json(json._get("selectionRange")),
  }
}

///|
/// Call hierarchy incoming call
pub(all) struct CallHierarchyIncomingCall {
  from : CallHierarchyItem
  from_ranges : Array[Range]
}

///|
pub fn CallHierarchyIncomingCall::from_json(
  json : @nostd.Any,
) -> CallHierarchyIncomingCall {
  let ranges_json = json._get("fromRanges")
  let from_ranges : Array[Range] = []
  let len : Int = ranges_json._get("length").cast()
  for i in 0..<len {
    from_ranges.push(Range::from_json(ranges_json._get_by_index(i)))
  }
  { from: CallHierarchyItem::from_json(json._get("from")), from_ranges }
}

///|
/// Call hierarchy outgoing call
pub(all) struct CallHierarchyOutgoingCall {
  to : CallHierarchyItem
  from_ranges : Array[Range]
}

///|
pub fn CallHierarchyOutgoingCall::from_json(
  json : @nostd.Any,
) -> CallHierarchyOutgoingCall {
  let ranges_json = json._get("fromRanges")
  let from_ranges : Array[Range] = []
  let len : Int = ranges_json._get("length").cast()
  for i in 0..<len {
    from_ranges.push(Range::from_json(ranges_json._get_by_index(i)))
  }
  { to: CallHierarchyItem::from_json(json._get("to")), from_ranges }
}

///|
/// Inlay hint
pub(all) struct InlayHint {
  position : Position
  label : String
  kind : Int?
  padding_left : Bool?
  padding_right : Bool?
}

///|
pub fn InlayHint::from_json(json : @nostd.Any) -> InlayHint {
  let label_json = json._get("label")
  let kind_json = json._get("kind")
  let pl_json = json._get("paddingLeft")
  let pr_json = json._get("paddingRight")
  {
    position: Position::from_json(json._get("position")),
    label: if ffi_typeof(label_json) == "string" {
      label_json.cast()
    } else {
      // label can be InlayHintLabelPart[]
      let parts : Array[String] = []
      let len : Int = label_json._get("length").cast()
      for i in 0..<len {
        let part_value : String = label_json
          ._get_by_index(i)
          ._get("value")
          .cast()
        parts.push(part_value)
      }
      parts.join("")
    },
    kind: if @nostd.is_nullish(kind_json) {
      None
    } else {
      Some(kind_json.cast())
    },
    padding_left: if @nostd.is_nullish(pl_json) {
      None
    } else {
      Some(pl_json.cast())
    },
    padding_right: if @nostd.is_nullish(pr_json) {
      None
    } else {
      Some(pr_json.cast())
    },
  }
}

///|
/// Symbol kind constants
pub const SYMBOL_KIND_FILE : Int = 1

///|
pub const SYMBOL_KIND_MODULE : Int = 2

///|
pub const SYMBOL_KIND_NAMESPACE : Int = 3

///|
pub const SYMBOL_KIND_PACKAGE : Int = 4

///|
pub const SYMBOL_KIND_CLASS : Int = 5

///|
pub const SYMBOL_KIND_METHOD : Int = 6

///|
pub const SYMBOL_KIND_PROPERTY : Int = 7

///|
pub const SYMBOL_KIND_FIELD : Int = 8

///|
pub const SYMBOL_KIND_CONSTRUCTOR : Int = 9

///|
pub const SYMBOL_KIND_ENUM : Int = 10

///|
pub const SYMBOL_KIND_INTERFACE : Int = 11

///|
pub const SYMBOL_KIND_FUNCTION : Int = 12

///|
pub const SYMBOL_KIND_VARIABLE : Int = 13

///|
pub const SYMBOL_KIND_CONSTANT : Int = 14

///|
pub const SYMBOL_KIND_STRING : Int = 15

///|
pub const SYMBOL_KIND_NUMBER : Int = 16

///|
pub const SYMBOL_KIND_BOOLEAN : Int = 17

///|
pub const SYMBOL_KIND_ARRAY : Int = 18

///|
pub const SYMBOL_KIND_OBJECT : Int = 19

///|
pub const SYMBOL_KIND_KEY : Int = 20

///|
pub const SYMBOL_KIND_NULL : Int = 21

///|
pub const SYMBOL_KIND_ENUM_MEMBER : Int = 22

///|
pub const SYMBOL_KIND_STRUCT : Int = 23

///|
pub const SYMBOL_KIND_EVENT : Int = 24

///|
pub const SYMBOL_KIND_OPERATOR : Int = 25

///|
pub const SYMBOL_KIND_TYPE_PARAMETER : Int = 26

///|
/// Completion item kind constants
pub const COMPLETION_KIND_TEXT : Int = 1

///|
pub const COMPLETION_KIND_METHOD : Int = 2

///|
pub const COMPLETION_KIND_FUNCTION : Int = 3

///|
pub const COMPLETION_KIND_CONSTRUCTOR : Int = 4

///|
pub const COMPLETION_KIND_FIELD : Int = 5

///|
pub const COMPLETION_KIND_VARIABLE : Int = 6

///|
pub const COMPLETION_KIND_CLASS : Int = 7

///|
pub const COMPLETION_KIND_INTERFACE : Int = 8

///|
pub const COMPLETION_KIND_MODULE : Int = 9

///|
pub const COMPLETION_KIND_PROPERTY : Int = 10

///|
pub const COMPLETION_KIND_UNIT : Int = 11

///|
pub const COMPLETION_KIND_VALUE : Int = 12

///|
pub const COMPLETION_KIND_ENUM : Int = 13

///|
pub const COMPLETION_KIND_KEYWORD : Int = 14

///|
pub const COMPLETION_KIND_SNIPPET : Int = 15

///|
pub const COMPLETION_KIND_COLOR : Int = 16

///|
pub const COMPLETION_KIND_FILE : Int = 17

///|
pub const COMPLETION_KIND_REFERENCE : Int = 18

///|
pub const COMPLETION_KIND_FOLDER : Int = 19

///|
pub const COMPLETION_KIND_ENUM_MEMBER : Int = 20

///|
pub const COMPLETION_KIND_CONSTANT : Int = 21

///|
pub const COMPLETION_KIND_STRUCT : Int = 22

///|
pub const COMPLETION_KIND_EVENT : Int = 23

///|
pub const COMPLETION_KIND_OPERATOR : Int = 24

///|
pub const COMPLETION_KIND_TYPE_PARAMETER : Int = 25
