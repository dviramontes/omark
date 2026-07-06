package main

import "core:fmt"
import "core:mem"
import "core:os"

// Markdown in -> AST -> HTML out
main :: proc() {
	fmt.println("Hello from Omark!\n================")
	path := "README.md"

	arena: mem.Arena
	backing_buffer := make([]u8, 1024 * 1024)
	mem.arena_init(&arena, backing_buffer)
	allocator := mem.arena_allocator(&arena)

	contents_as_string := read_markdown_file_contents(path)
	doc := parse(contents_as_string, allocator)
	defer delete(doc.blocks)

	fmt.printf("doc: %+v\n", doc)
}

read_markdown_file_contents :: proc(path: string) -> string {
	data, err := os.read_entire_file(path, context.allocator)
	if err != os.ERROR_NONE {
		fmt.eprintln("failed to read file: %v\n", err)
		return ""
	}

	return string(data)
}

parse :: proc(contents: string, allocator: mem.Allocator = context.allocator) -> Document_Node {
	doc: Document_Node
	doc.kind = .Document
	doc.span = Source_Span {
		start = 0,
		end   = len(contents),
	}
	doc.blocks = make([dynamic]Block_Node, 0, allocator)

	pos := 0
	for pos < len(contents) {
		c := contents[pos]
		if c == '\n' {
			pos += 1
			continue
		}

		block := parse_block(contents[pos:], allocator)
		_, _ = append(&doc.blocks, block)
		pos += 1
	}

	return doc
}

parse_block :: proc(contents: string, allocator: mem.Allocator = context.allocator) -> Block_Node {
	paragraph := Paragraph_Node {
		kind = .Paragraph,
		span = Source_Span{start = 0, end = len(contents)},
	}

	paragraph.inlines = parse_inline(contents, allocator)
	return Block_Node(paragraph)
}

parse_inline :: proc(
	contents: string,
	allocator: mem.Allocator = context.allocator,
) -> [dynamic]Inline_Node {
	nodes := make([dynamic]Inline_Node, 0, 1, allocator)

	text := Text_Node {
		kind = .Text,
		span = Source_Span{start = 0, end = len(contents)},
		text = contents,
	}

	_, _ = append(&nodes, Inline_Node(text))
	return nodes
}
