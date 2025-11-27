# htmlparser2 Bindings

MoonBit bindings for [htmlparser2](https://github.com/fb55/htmlparser2), a fast and forgiving HTML/XML parser.

## Installation

```bash
npm install htmlparser2
```

## Usage

### DOM Parsing

```moonbit
fn main {
  let html = "<div id=\"main\"><p>Hello <span>World</span></p></div>"
  let doc = @htmlparser2.parse_document(html)

  // Get text content
  let text = @htmlparser2.get_text_from_document(doc)
  println(text) // "Hello World"

  // Find elements by tag name
  let paragraphs = @htmlparser2.get_elements_by_tag_name(doc, "p")
  for p in paragraphs {
    println(p.name()) // "p"
  }

  // Find element by ID
  match @htmlparser2.get_element_by_id(doc, "main") {
    Some(elem) => println("Found: " + elem.name())
    None => println("Not found")
  }
}
```

### Streaming Parser

```moonbit
fn main {
  let handlers = @js.Object::new()
  handlers["onopentag"] = @js.from_fn1(fn(name : String) {
    println("Opening: " + name)
  })
  handlers["ontext"] = @js.from_fn1(fn(text : String) {
    println("Text: " + text)
  })
  handlers["onclosetag"] = @js.from_fn1(fn(name : String) {
    println("Closing: " + name)
  })

  let parser = @htmlparser2.create_parser(handlers)
  parser.write("<div>Hello</div>")
  parser.end()
}
```

## API

### Module Functions

- `parse_document(html)` - Parse HTML/XML string into a DOM document
- `parse_document_with_options(html, xml_mode?, decode_entities?, ...)` - Parse with options
- `create_parser(handlers)` - Create a streaming parser with event handlers
- `create_parser_with_options(handlers, xml_mode?, ...)` - Create parser with options

### Document Methods

- `children()` - Get children nodes of the document

### Element Methods

- `name()` - Get element tag name
- `attribs()` - Get element attributes as Object
- `get_attribute(name)` - Get a specific attribute value
- `children()` - Get children nodes
- `parent()` - Get parent node

### Node Methods

- `node_type()` - Get node type ("tag", "text", "comment", etc.)
- `data()` - Get text content (for text nodes)
- `name()` - Get node name (for element nodes)
- `is_element()` - Check if node is an element
- `is_text()` - Check if node is a text node
- `is_comment()` - Check if node is a comment
- `as_element()` - Cast node to element (unsafe)
- `children()` - Get children nodes
- `parent()` - Get parent node
- `attribs()` - Get attributes (if element)

### Parser Methods

- `write(chunk)` - Write a chunk of data to the parser
- `end()` - Signal end of input
- `reset()` - Reset the parser
- `parse_complete(input)` - Parse complete input (write + end)

### DomUtils Functions

- `get_inner_html(node)` - Get inner HTML of a node
- `get_outer_html(node)` - Get outer HTML of a node
- `get_text(node)` - Get text content of a node and descendants
- `get_text_from_document(doc)` - Get text content of a document
- `get_elements_by_tag_name(doc, name, recurse?, limit?)` - Find elements by tag name
- `get_element_by_id(doc, id)` - Find element by ID
- `find_all(doc, predicate)` - Find all elements matching a predicate
- `find_one(doc, predicate)` - Find first element matching a predicate

### Parser Options

| Option | Type | Description |
|--------|------|-------------|
| `xml_mode` | Bool | Parse as XML (stricter parsing) |
| `decode_entities` | Bool | Decode HTML entities |
| `lowercase_tags` | Bool | Lowercase tag names |
| `lowercase_attribute_names` | Bool | Lowercase attribute names |

### Event Handlers

When using the streaming parser, you can provide these handlers:

- `onopentag(name)` - Opening tag
- `onclosetag(name)` - Closing tag
- `ontext(text)` - Text content
- `oncomment(comment)` - Comment
- `onerror(error)` - Parse error

## See Also

- [htmlparser2 Documentation](https://github.com/fb55/htmlparser2)
- [domutils Documentation](https://github.com/fb55/domutils)
