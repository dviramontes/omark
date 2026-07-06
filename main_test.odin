package main

import "core:log"
import "core:mem"
import "core:testing"

@(test)
test_parse_block :: proc(t: ^testing.T) {
	markdown := "# README"

	arena: mem.Arena
	buffer := make([]byte, 1024 * 1024)
	defer delete(buffer)
	mem.arena_init(&arena, buffer)

	allocator := mem.arena_allocator(&arena)
	parsed := parse(markdown, allocator)
	testing.expect(t, parsed.kind == .Document, "expected document node")
	testing.expect(t, len(parsed.blocks) == 1, "expected 1 block")
}

@(test)
test_parse_paragraph :: proc(t: ^testing.T) {
	markdown := `lorem ipsum\n\nlorem ipsum`

	arena: mem.Arena
	buffer := make([]byte, 1024 * 1024)
	defer delete(buffer)
	mem.arena_init(&arena, buffer)

	// document node
	allocator := mem.arena_allocator(&arena)
	parsed := parse(markdown, allocator)
	testing.expect(t, parsed.kind == .Document, "expected document node")
	testing.expect(t, len(parsed.blocks) == 1, "expected 1 block")

	// paragraph node
	paragraph, ok := parsed.blocks[0].(Paragraph_Node)
	testing.expect(t, ok, "expected paragraph node")
	testing.expect(t, paragraph.kind == .Paragraph, "expected paragraph kind")
	testing.expect(t, len(paragraph.inlines) == 1, "expected 1 inline")

	// text node
	text, text_ok :=  paragraph.inlines[0].(Text_Node)
	log.infof("text: %+v", text)
	testing.expect(t, text_ok, "expected text node")
	testing.expect(t, text.kind == .Text, "expected text kind")
	testing.expect(t, text.text == "lorem ipsum\\n\\nlorem ipsum", "expected text content")
}

@(test)
test_parse_inline :: proc(t: ^testing.T) {
	markdown := `lorem *ipsum*`

	arena: mem.Arena
	buffer := make([]byte, 1024 * 1024)
	defer delete(buffer)
	mem.arena_init(&arena, buffer)

	// document node
	allocator := mem.arena_allocator(&arena)
	parsed := parse(markdown, allocator)
	testing.expect(t, parsed.kind == .Document, "expected document node")
	testing.expect(t, len(parsed.blocks) == 1, "expected 1 block")

	// paragraph node
	paragraph, ok := parsed.blocks[0].(Paragraph_Node)
	testing.expect(t, ok, "expected paragraph node")
	testing.expect(t, paragraph.kind == .Paragraph, "expected paragraph kind")
	testing.expect(t, len(paragraph.inlines) == 1, "expected 1 inline")

	// text node
	text, text_ok :=  paragraph.inlines[0].(Text_Node)
	log.infof("text: %+v", text)
	testing.expect(t, text_ok, "expected text node")
	testing.expect(t, text.kind == .Text, "expected text kind")
	testing.expect(t, text.text == "lorem *ipsum*", "expected text content")
}