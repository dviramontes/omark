# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`omark` is a Markdown parser written in Odin, built as a learning project. The intended pipeline is **Markdown in → AST → HTML out**; only the first two stages exist so far (see `PLAN.md` for progress — HTML rendering, file output, and CLI args are not yet implemented).

This is a learning project: do not write or modify code unless explicitly instructed. Exception — for test files (`*_test.odin`), you may write and run tests without asking for permission.

When you have a code suggestion, present it as an edit so it shows up in the diff viewer (rather than only describing it in prose). The user reviews suggestions there.

## Commands

- `make build` — compile to `./omark`
- `make run` — build and run (parses the hardcoded `README.md` and prints the AST)
- `make test` — run all tests
- `make fmt` — format root `*.odin` files with `odinfmt` (does not touch `base/`, `core/`, `examples/`)
- `make clean` — remove the binary

The Makefile has no single-test target; `make test` runs the whole suite.

## Architecture

All source is in the `main` package at the repo root (Odin packages are directory-based):

- `main.odin` — entry point and the parser. `main` sets up a 1 MiB `mem.Arena` and threads its allocator through `read_markdown_file_contents` → `parse` → `parse_block` → `parse_inline`. Currently the input path is hardcoded to `README.md`.
- `ast.odin` — the AST type definitions. Nodes are Odin structs; `Block_Node` and `Inline_Node` are **tagged unions** over the concrete node structs. Type-switch / union assertions (e.g. `blocks[0].(Paragraph_Node)`) are how you dispatch on node type. Every node carries a `Source_Span{start, end}` (byte offsets into the source).
- `main_test.odin` — tests using `core:testing`.

### Parsing model

`parse` splits the document into blocks by scanning for blank-line boundaries (a `\n` followed by another `\n` or EOF). Each block currently becomes a `Paragraph_Node` regardless of content — heading/list/code-block/blockquote parsing described in the README is not yet implemented. `parse_inline` currently wraps the whole block as a single `Text_Node`.

### Allocator convention

Parser procs take `allocator: mem.Allocator = context.allocator` as a trailing parameter and pass it to every `make`. The arena owns all AST allocations; the arena's backing buffer is freed as a whole rather than freeing individual nodes.

## Gotchas

- `base/`, `core/`, and `examples/` are **gitignored local copies of the Odin standard library and demo code** — reference material, not part of this project. Don't edit them or treat them as project code.
- Test procedures only run if annotated with `@(test)`. In `main_test.odin`, only `test_parse_block` has it; `test_parse_paragraph` and the commented-out `test_parse_inline_block` do not run.
- `ast.odin` defines two enums, `Node` and `Node_Kind`. Only `Node_Kind` is used by the node structs; `Node` is currently dead.
