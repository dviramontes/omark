# Omark
An Odin markdown parser project.

## Goals
- Build a markdown parser in Odin, as a learning project.
- Add clear tests as parser features are implemented.

## Prerequisites
- [Odin](https://odin-lang.org/) installed and available in your `PATH`.
- [just](https://just.systems/) installed and available in your `PATH`.

## Development

### Commands
- `just build`
- `just run`
- `just clean`
- `just fmt`
- `just test`
- `just test-one parser_handle_x` — run a single test by name

### Markdown Support
[Not full markdown](https://commonmark.org/) but enough for basic parsing. 

#### Supports
- Headings
- Paragraphs
- Fenced code blocks 
- Inline code
- Bold / Italic
- Unordered lists
- Links
- Blockquotes
