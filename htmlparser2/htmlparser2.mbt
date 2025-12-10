///|
/// htmlparser2 bindings for MoonBit
/// https://github.com/fb55/htmlparser2
///
/// A fast and forgiving HTML/XML parser.

///| Parser Types

///|
/// HTML/XML Parser instance
#external
pub type Parser

///|
/// DOM Document node
pub(all) struct Document {
  children : Array[Node]
}

///|
/// DOM Element node
pub(all) struct Element {
  name : String
  attribs : @core.Any
  children : Array[Node]
  parent : @core.Any
}

///|
/// DOM Node (base type)
pub(all) struct Node {
  type_ : String
  name : String
  data : String
  children : Array[Node]
  parent : @core.Any
  attribs : @core.Any
}

///| as_any helpers

///|
pub extern "js" fn Parser::as_any(self : Parser) -> @core.Any =
  #| (x) => x

///|
pub fn Document::as_any(self : Document) -> @core.Any = "%identity"

///|
pub fn Element::as_any(self : Element) -> @core.Any = "%identity"

///|
pub fn Node::as_any(self : Node) -> @core.Any = "%identity"

///| Special getters for reserved keywords

///|
/// Get node type (accessing JS "type" property)
pub extern "js" fn Node::get_type(self : Node) -> String =
  #| (node) => node.type || ''

///| FFI Functions

///|
#module("htmlparser2")
extern "js" fn ffi_parse_document(html : String) -> Document = "parseDocument"

///|
#module("htmlparser2")
extern "js" fn ffi_parse_document_with_options(
  html : String,
  options : @core.Any,
) -> Document = "parseDocument"

///|
extern "js" fn ffi_create_parser(handlers : @core.Any) -> Parser =
  #| (handlers) => {
  #|   const htmlparser2 = require('htmlparser2');
  #|   return new htmlparser2.Parser(handlers);
  #| }

///|
extern "js" fn ffi_create_parser_with_options(
  handlers : @core.Any,
  options : @core.Any,
) -> Parser =
  #| (handlers, options) => {
  #|   const htmlparser2 = require('htmlparser2');
  #|   return new htmlparser2.Parser(handlers, options);
  #| }

///|
extern "js" fn ffi_parser_write(parser : Parser, chunk : String) -> Unit =
  #| (parser, chunk) => {
  #|   parser.write(chunk);
  #| }

///|
extern "js" fn ffi_parser_end(parser : Parser) -> Unit =
  #| (parser) => {
  #|   parser.end();
  #| }

///|
extern "js" fn ffi_parser_reset(parser : Parser) -> Unit =
  #| (parser) => {
  #|   parser.reset();
  #| }

///|
extern "js" fn ffi_parser_parse_complete(
  parser : Parser,
  input : String,
) -> Unit =
  #| (parser, input) => {
  #|   parser.parseComplete(input);
  #| }

///| DOM Traversal FFI (removed - now using get_raw_* functions)

///|
extern "js" fn ffi_dom_utils_get_inner_html(node : @core.Any) -> String =
  #| (node) => require('htmlparser2').DomUtils.getInnerHTML(node)

///|
extern "js" fn ffi_dom_utils_get_outer_html(node : @core.Any) -> String =
  #| (node) => require('htmlparser2').DomUtils.getOuterHTML(node)

///|
extern "js" fn ffi_dom_utils_get_text(node : @core.Any) -> String =
  #| (node) => require('htmlparser2').DomUtils.getText(node)

///|
extern "js" fn ffi_dom_utils_get_elements_by_tag_name(
  name : String,
  nodes : @core.Any,
  recurse : Bool,
  limit : Int,
) -> @core.Any =
  #| (name, nodes, recurse, limit) => require('htmlparser2').DomUtils.getElementsByTagName(name, nodes, recurse, limit)

///|
extern "js" fn ffi_dom_utils_get_element_by_id(
  id : String,
  nodes : @core.Any,
  recurse : Bool,
) -> @core.Any =
  #| (id, nodes, recurse) => require('htmlparser2').DomUtils.getElementById(id, nodes, recurse)

///|
extern "js" fn ffi_dom_utils_find_all(
  predicate : @core.Any,
  nodes : @core.Any,
) -> @core.Any =
  #| (predicate, nodes) => require('htmlparser2').DomUtils.findAll(predicate, nodes)

///|
extern "js" fn ffi_dom_utils_find_one(
  predicate : @core.Any,
  nodes : @core.Any,
  recurse : Bool,
) -> @core.Any =
  #| (predicate, nodes, recurse) => require('htmlparser2').DomUtils.findOne(predicate, nodes, recurse)

///| Module Functions

///|
/// Parse HTML/XML string into a DOM document
pub fn parseDocument(
  html : String,
  xmlMode? : Bool,
  decodeEntities? : Bool,
  lowerCaseTags? : Bool,
  lowerCaseAttributeNames? : Bool,
) -> Document {
  if xmlMode is None &&
    decodeEntities is None &&
    lowerCaseTags is None &&
    lowerCaseAttributeNames is None {
    ffi_parse_document(html)
  } else {
    let options = @core.new_object()
    if xmlMode is Some(v) {
      options["xmlMode"] = @core.any(v)
    }
    if decodeEntities is Some(v) {
      options["decodeEntities"] = @core.any(v)
    }
    if lowerCaseTags is Some(v) {
      options["lowerCaseTags"] = @core.any(v)
    }
    if lowerCaseAttributeNames is Some(v) {
      options["lowerCaseAttributeNames"] = @core.any(v)
    }
    ffi_parse_document_with_options(html, options)
  }
}

///|
/// Create a streaming parser with event handlers
pub fn createParser(
  handlers : @core.Any,
  xmlMode? : Bool,
  decodeEntities? : Bool,
  lowerCaseTags? : Bool,
  lowerCaseAttributeNames? : Bool,
) -> Parser {
  if xmlMode is None &&
    decodeEntities is None &&
    lowerCaseTags is None &&
    lowerCaseAttributeNames is None {
    ffi_create_parser(handlers)
  } else {
    let options = @core.new_object()
    if xmlMode is Some(v) {
      options["xmlMode"] = @core.any(v)
    }
    if decodeEntities is Some(v) {
      options["decodeEntities"] = @core.any(v)
    }
    if lowerCaseTags is Some(v) {
      options["lowerCaseTags"] = @core.any(v)
    }
    if lowerCaseAttributeNames is Some(v) {
      options["lowerCaseAttributeNames"] = @core.any(v)
    }
    ffi_create_parser_with_options(handlers, options)
  }
}

///| Parser Methods

///|
/// Write a chunk of data to the parser
pub fn Parser::write(self : Parser, chunk : String) -> Unit {
  ffi_parser_write(self, chunk)
}

///|
/// Signal end of input
pub fn Parser::end(self : Parser) -> Unit {
  ffi_parser_end(self)
}

///|
/// Reset the parser
pub fn Parser::reset(self : Parser) -> Unit {
  ffi_parser_reset(self)
}

///|
/// Parse complete input (write + end)
pub fn Parser::parseComplete(self : Parser, input : String) -> Unit {
  ffi_parser_parse_complete(self, input)
}

///| Document Methods

///|
/// Get children of a document
pub fn Document::children(self : Document) -> Array[Node] {
  self.children
}

///| Element Methods

///|
/// Get element tag name
pub fn Element::name(self : Element) -> String {
  self.name
}

///|
/// Get element attributes as Object
pub fn Element::attribs(self : Element) -> @core.Any {
  self.attribs
}

///|
/// Get a specific attribute value
pub fn Element::getAttribute(self : Element, name : String) -> String? {
  let attribs = self.attribs()
  let value = attribs[name]
  if @core.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get children of an element
pub fn Element::children(self : Element) -> Array[Node] {
  self.children
}

///|
/// Get parent of an element
pub fn Element::parent(self : Element) -> Node? {
  if @core.is_nullish(self.parent) {
    None
  } else {
    Some(@core.identity(self.parent))
  }
}

///| Node Methods

///|
/// Get node type ("tag", "text", "comment", "directive", etc.)
pub fn Node::nodeType(self : Node) -> String {
  self.get_type()
}

///|
/// Get text content (for text nodes)
pub fn Node::data(self : Node) -> String {
  self.data
}

///|
/// Get node name (for element nodes)
pub fn Node::name(self : Node) -> String {
  self.name
}

///|
/// Check if node is an element
pub fn Node::isElement(self : Node) -> Bool {
  self.nodeType() == "tag"
}

///|
/// Check if node is a text node
pub fn Node::isText(self : Node) -> Bool {
  self.nodeType() == "text"
}

///|
/// Check if node is a comment
pub fn Node::isComment(self : Node) -> Bool {
  self.nodeType() == "comment"
}

///|
/// Cast node to element (unsafe)
pub fn Node::asElement(self : Node) -> Element {
  self.as_any().cast()
}

///|
/// Get parent of a node
pub fn Node::parent(self : Node) -> Node? {
  if @core.is_nullish(self.parent) {
    None
  } else {
    Some(self.parent.cast())
  }
}

///|
/// Get attributes of a node (if element)
pub fn Node::attribs(self : Node) -> @core.Any {
  self.attribs
}

///| DomUtils Functions

///|
/// Get inner HTML of a node
pub fn getInnerHTML(node : Node) -> String {
  ffi_dom_utils_get_inner_html(node.as_any())
}

///|
/// Get outer HTML of a node
pub fn getOuterHTML(node : Node) -> String {
  ffi_dom_utils_get_outer_html(node.as_any())
}

///|
/// Get text content of a node and its descendants
pub fn getText(node : Node) -> String {
  ffi_dom_utils_get_text(node.as_any())
}

///|
/// Get text content of a document
pub fn getTextFromDocument(doc : Document) -> String {
  ffi_dom_utils_get_text(doc.as_any())
}

///|
/// Find elements by tag name
pub fn getElementsByTagName(
  doc : Document,
  name : String,
  recurse? : Bool = true,
  limit? : Int = 0x7FFFFFFF,
) -> Array[Element] {
  let result = ffi_dom_utils_get_elements_by_tag_name(
    name,
    @core.any(doc.children),
    recurse,
    limit,
  )
  @core.identity(result)
}

///|
/// Find element by ID
pub fn getElementById(doc : Document, id : String) -> Element? {
  let result = ffi_dom_utils_get_element_by_id(
    id,
    @core.any(doc.children),
    true,
  )
  if @core.is_nullish(result) {
    None
  } else {
    Some(@core.identity(result))
  }
}

///|
/// Find all elements matching a predicate
pub fn findAll(doc : Document, predicate : (Element) -> Bool) -> Array[Element] {
  let pred_fn = @core.from_fn1(fn(elem : @core.Any) -> Bool {
    predicate(@core.identity(elem))
  })
  let result = ffi_dom_utils_find_all(pred_fn, @core.any(doc.children))
  @core.identity(result)
}

///|
/// Find first element matching a predicate
pub fn findOne(doc : Document, predicate : (Element) -> Bool) -> Element? {
  let pred_fn = @core.from_fn1(fn(elem : @core.Any) -> Bool {
    predicate(@core.identity(elem))
  })
  let result = ffi_dom_utils_find_one(pred_fn, @core.any(doc.children), true)
  if @core.is_nullish(result) {
    None
  } else {
    Some(@core.identity(result))
  }
}
