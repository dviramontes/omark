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
	markdown: string
	markdown = `lorem ipsum\nlorem ipsum`

	arena: mem.Arena
	buffer := make([]byte, 1024 * 1024)
	defer delete(buffer)
	mem.arena_init(&arena, buffer)
	doc: Document_Node

	allocator := mem.arena_allocator(&arena)
	doc = parse(markdown, allocator)

	paragraph, ok := doc.blocks[0].(Paragraph_Node)
	text, text_ok := paragraph.inlines[0].(Text_Node)
	testing.expect(t, len(doc.blocks) == 1, "expected 1 block")
	testing.expect(t, text_ok, "expected text node")
	testing.expect(t, text.kind == .Text, "expected text kind")
	testing.expect(t, text.text == `lorem ipsum\nlorem ipsum`, "expected text content")

	markdown = "First.\n\nSecond." // two paragraph

	doc = parse(markdown, allocator)
	two, ok_two := doc.blocks[1].(Paragraph_Node)
	testing.expect(t, len(doc.blocks) == 2, "expected 2 blocks")
	text_two, text_ok_two := two.inlines[0].(Text_Node)
	text_three, text_ok_three := two.inlines[1].(Text_Node)

	testing.expect(t, ok_two, "expected paragraph node")
	testing.expect(t, text_ok_two, "expected text node")
	testing.expect(t, text_two.kind == .Text, "expected text kind")
	testing.expect(t, text_two.text == `First.`, "expected text content")
	testing.expect(t, text_ok_three, "expected text node")
	testing.expect(t, text_three.kind == .Text, "expected text kind")
	testing.expect(t, text_three.text == `Second.`, "expected text content")
}

@(test)
test_parse_inline :: proc(t: ^testing.T) {
	markdown := `lorem *ipsum*`

	arena: mem.Arena
	buffer := make([]byte, 1024 * 1024)
	defer delete(buffer)
	mem.arena_init(&arena, buffer)

	allocator := mem.arena_allocator(&arena)
	parsed := parse(markdown, allocator)
	paragraph, ok := parsed.blocks[0].(Paragraph_Node)
	text, text_ok := paragraph.inlines[0].(Text_Node)

	testing.expect(t, text_ok, "expected text node")
	testing.expect(t, text.kind == .Text, "expected text kind")
	testing.expect(t, text.text == "lorem *ipsum*", "expected text content")
}
