# omark
An Odin markdown parser project.

## Status
This project is just getting started. There is no parser implementation yet.

## Goals
- Build a markdown parser in Odin.
- Keep the codebase small, readable, and easy to extend.
- Add clear tests as parser features are implemented.

## Prerequisites
- [Odin](https://odin-lang.org/) installed and available in your `PATH`.

## Development
This project uses a Makefile setup copied from `../dragon_curve/`, adapted for this repository.

### Commands
- `make build` — build the binary
- `make run` — build and run
- `make clean` — remove built binary
- `make fmt` — format `main.odin`

### Markdown Support
[Not full markdown](https://commonmark.org/) but enough for basic parsing. 

#### Support
- Headings
- Paragraphs
- Fenced code blocks 
- Inline code
- Bold / Italic
- Unordered lists
- Links
- Blockquotes
