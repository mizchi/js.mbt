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
#external
pub type Document

///|
/// DOM Element node
#external
pub type Element

///|
/// DOM Node (base type)
#external
pub type Node

///| as_any helpers

///|
pub extern "js" fn Parser::as_any(self : Parser) -> @nostd.Any =
  #| (x) => x

///|
pub extern "js" fn Document::as_any(self : Document) -> @nostd.Any =
  #| (x) => x

///|
pub extern "js" fn Element::as_any(self : Element) -> @nostd.Any =
  #| (x) => x

///|
pub extern "js" fn Node::as_any(self : Node) -> @nostd.Any =
  #| (x) => x

///| FFI Functions

///|
extern "js" fn ffi_parse_document(html : String) -> Document =
  #| (html) => {
  #|   const htmlparser2 = require('htmlparser2');
  #|   return htmlparser2.parseDocument(html);
  #| }

///|
extern "js" fn ffi_parse_document_with_options(
  html : String,
  options : @nostd.Any,
) -> Document =
  #| (html, options) => {
  #|   const htmlparser2 = require('htmlparser2');
  #|   return htmlparser2.parseDocument(html, options);
  #| }

///|
extern "js" fn ffi_create_parser(handlers : @nostd.Any) -> Parser =
  #| (handlers) => {
  #|   const htmlparser2 = require('htmlparser2');
  #|   return new htmlparser2.Parser(handlers);
  #| }

///|
extern "js" fn ffi_create_parser_with_options(
  handlers : @nostd.Any,
  options : @nostd.Any,
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

///| DOM Traversal FFI

///|
extern "js" fn ffi_get_children(node : @nostd.Any) -> @nostd.Any =
  #| (node) => {
  #|   return node.children || [];
  #| }

///|
extern "js" fn ffi_get_parent(node : @nostd.Any) -> @nostd.Any =
  #| (node) => {
  #|   return node.parent;
  #| }

///|
extern "js" fn ffi_get_name(node : @nostd.Any) -> String =
  #| (node) => {
  #|   return node.name || '';
  #| }

///|
extern "js" fn ffi_get_type(node : @nostd.Any) -> String =
  #| (node) => {
  #|   return node.type || '';
  #| }

///|
extern "js" fn ffi_get_data(node : @nostd.Any) -> String =
  #| (node) => {
  #|   return node.data || '';
  #| }

///|
extern "js" fn ffi_get_attribs(node : @nostd.Any) -> @nostd.Any =
  #| (node) => {
  #|   return node.attribs || {};
  #| }

///|
extern "js" fn ffi_dom_utils_get_inner_html(node : @nostd.Any) -> String =
  #| (node) => {
  #|   const { DomUtils } = require('htmlparser2');
  #|   return DomUtils.getInnerHTML(node);
  #| }

///|
extern "js" fn ffi_dom_utils_get_outer_html(node : @nostd.Any) -> String =
  #| (node) => {
  #|   const { DomUtils } = require('htmlparser2');
  #|   return DomUtils.getOuterHTML(node);
  #| }

///|
extern "js" fn ffi_dom_utils_get_text(node : @nostd.Any) -> String =
  #| (node) => {
  #|   const { DomUtils } = require('htmlparser2');
  #|   return DomUtils.getText(node);
  #| }

///|
extern "js" fn ffi_dom_utils_get_elements_by_tag_name(
  name : String,
  nodes : @nostd.Any,
  recurse : Bool,
  limit : Int,
) -> @nostd.Any =
  #| (name, nodes, recurse, limit) => {
  #|   const { DomUtils } = require('htmlparser2');
  #|   return DomUtils.getElementsByTagName(name, nodes, recurse, limit);
  #| }

///|
extern "js" fn ffi_dom_utils_get_element_by_id(
  id : String,
  nodes : @nostd.Any,
  recurse : Bool,
) -> @nostd.Any =
  #| (id, nodes, recurse) => {
  #|   const { DomUtils } = require('htmlparser2');
  #|   return DomUtils.getElementById(id, nodes, recurse);
  #| }

///|
extern "js" fn ffi_dom_utils_find_all(
  predicate : @nostd.Any,
  nodes : @nostd.Any,
) -> @nostd.Any =
  #| (predicate, nodes) => {
  #|   const { DomUtils } = require('htmlparser2');
  #|   return DomUtils.findAll(predicate, nodes);
  #| }

///|
extern "js" fn ffi_dom_utils_find_one(
  predicate : @nostd.Any,
  nodes : @nostd.Any,
  recurse : Bool,
) -> @nostd.Any =
  #| (predicate, nodes, recurse) => {
  #|   const { DomUtils } = require('htmlparser2');
  #|   return DomUtils.findOne(predicate, nodes, recurse);
  #| }

///| Module Functions

///|
/// Parse HTML/XML string into a DOM document
pub fn parseDocument(html : String) -> Document {
  ffi_parse_document(html)
}

///|
/// Parse HTML/XML string with options
pub fn parseDocumentWithOptions(
  html : String,
  xmlMode? : Bool,
  decodeEntities? : Bool,
  lowerCaseTags? : Bool,
  lowerCaseAttributeNames? : Bool,
) -> Document {
  let options = @nostd.Object::new()
  if xmlMode is Some(v) {
    options["xmlMode"] = @nostd.any(v)
  }
  if decodeEntities is Some(v) {
    options["decodeEntities"] = @nostd.any(v)
  }
  if lowerCaseTags is Some(v) {
    options["lowerCaseTags"] = @nostd.any(v)
  }
  if lowerCaseAttributeNames is Some(v) {
    options["lowerCaseAttributeNames"] = @nostd.any(v)
  }
  ffi_parse_document_with_options(html, options)
}

///|
/// Create a streaming parser with event handlers
pub fn createParser(handlers : @nostd.Any) -> Parser {
  ffi_create_parser(handlers)
}

///|
/// Create a streaming parser with options
pub fn createParserWithOptions(
  handlers : @nostd.Any,
  xmlMode? : Bool,
  decodeEntities? : Bool,
  lowerCaseTags? : Bool,
  lowerCaseAttributeNames? : Bool,
) -> Parser {
  let options = @nostd.Object::new()
  if xmlMode is Some(v) {
    options["xmlMode"] = @nostd.any(v)
  }
  if decodeEntities is Some(v) {
    options["decodeEntities"] = @nostd.any(v)
  }
  if lowerCaseTags is Some(v) {
    options["lowerCaseTags"] = @nostd.any(v)
  }
  if lowerCaseAttributeNames is Some(v) {
    options["lowerCaseAttributeNames"] = @nostd.any(v)
  }
  ffi_create_parser_with_options(handlers, options)
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
  @nostd.identity(ffi_get_children(self.as_any()))
}

///| Element Methods

///|
/// Get element tag name
pub fn Element::name(self : Element) -> String {
  ffi_get_name(self.as_any())
}

///|
/// Get element attributes as Object
pub fn Element::attribs(self : Element) -> @nostd.Any {
  ffi_get_attribs(self.as_any())
}

///|
/// Get a specific attribute value
pub fn Element::getAttribute(self : Element, name : String) -> String? {
  let attribs = self.attribs()
  let value = attribs[name]
  if @nostd.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get children of an element
pub fn Element::children(self : Element) -> Array[Node] {
  @nostd.identity(ffi_get_children(self.as_any()))
}

///|
/// Get parent of an element
pub fn Element::parent(self : Element) -> Node? {
  let parent = ffi_get_parent(self.as_any())
  if @nostd.is_nullish(parent) {
    None
  } else {
    Some(@nostd.identity(parent))
  }
}

///| Node Methods

///|
/// Get node type ("tag", "text", "comment", "directive", etc.)
pub fn Node::nodeType(self : Node) -> String {
  ffi_get_type(self.as_any())
}

///|
/// Get text content (for text nodes)
pub fn Node::data(self : Node) -> String {
  ffi_get_data(self.as_any())
}

///|
/// Get node name (for element nodes)
pub fn Node::name(self : Node) -> String {
  ffi_get_name(self.as_any())
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
  @nostd.identity(self.as_any())
}

///|
/// Get children of a node
pub fn Node::children(self : Node) -> Array[Node] {
  @nostd.identity(ffi_get_children(self.as_any()))
}

///|
/// Get parent of a node
pub fn Node::parent(self : Node) -> Node? {
  let parent = ffi_get_parent(self.as_any())
  if @nostd.is_nullish(parent) {
    None
  } else {
    Some(@nostd.identity(parent))
  }
}

///|
/// Get attributes of a node (if element)
pub fn Node::attribs(self : Node) -> @nostd.Any {
  ffi_get_attribs(self.as_any())
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
  @nostd.identity(
    ffi_dom_utils_get_elements_by_tag_name(
      name,
      ffi_get_children(doc.as_any()),
      recurse,
      limit,
    ),
  )
}

///|
/// Find element by ID
pub fn getElementById(doc : Document, id : String) -> Element? {
  let result = ffi_dom_utils_get_element_by_id(
    id,
    ffi_get_children(doc.as_any()),
    true,
  )
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(@nostd.identity(result))
  }
}

///|
/// Find all elements matching a predicate
pub fn findAll(doc : Document, predicate : (Element) -> Bool) -> Array[Element] {
  let pred_fn = @nostd.from_fn1(fn(elem : @nostd.Any) -> Bool {
    let e : Element = @nostd.identity(elem)
    predicate(e)
  })
  @nostd.identity(
    ffi_dom_utils_find_all(pred_fn, ffi_get_children(doc.as_any())),
  )
}

///|
/// Find first element matching a predicate
pub fn findOne(doc : Document, predicate : (Element) -> Bool) -> Element? {
  let pred_fn = @nostd.from_fn1(fn(elem : @nostd.Any) -> Bool {
    let e : Element = @nostd.identity(elem)
    predicate(e)
  })
  let result = ffi_dom_utils_find_one(
    pred_fn,
    ffi_get_children(doc.as_any()),
    true,
  )
  if @nostd.is_nullish(result) {
    None
  } else {
    Some(@nostd.identity(result))
  }
}
