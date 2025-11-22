# mizchi/js/browser/file

File API for file handling in the browser.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/browser/file"
  ]
}
```

## Overview

Provides bindings for the File and FileReader APIs for reading files selected by users.

## Usage Example

```moonbit
fn main {
  // Get file input element
  let doc = @dom.document()
  let input = doc.get_element_by_id("fileInput")
  
  // Access selected files
  let files = input.files()
  let file = files.item(0)
  
  // Read file as text
  let reader = @file.FileReader::new()
  
  reader.set_onload(fn(event) {
    let result = reader.result()
    @console.log("File content:", result)
  })
  
  reader.read_as_text(file)
  
  // Other reading methods:
  // reader.read_as_data_url(file)
  // reader.read_as_array_buffer(file)
}
```

## Available Types

- **File** - File object with name, size, type
- **FileReader** - Read file contents
- **FileList** - List of files from input

## Reading Methods

- `readAsText()` - Read as text string
- `readAsDataURL()` - Read as data URL (for images)
- `readAsArrayBuffer()` - Read as binary data

## Reference

- [MDN: File API](https://developer.mozilla.org/en-US/docs/Web/API/File_API)
- [MDN: FileReader](https://developer.mozilla.org/en-US/docs/Web/API/FileReader)
