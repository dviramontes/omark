package main

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
	markdown = "lorem ipsum\nlorem ipsum"

	arena: mem.Arena
	buffer := make([]byte, 1024 * 1024)
	defer delete(buffer)
	mem.arena_init(&arena, buffer)
	doc: Document_Node

	allocator := mem.arena_allocator(&arena)
	doc = parse(markdown, allocator)
	testing.expect(t, len(doc.blocks) == 1, "expected 1 block")
	if len(doc.blocks) != 1 {
		return
	}
	paragraph, ok := doc.blocks[0].(Paragraph_Node)
	testing.expect(t, ok, "expected paragraph node")
	if !ok {
		return
	}
	testing.expect(t, len(paragraph.inlines) == 1, "expected 1 inline")
	if len(paragraph.inlines) != 1 {
		return
	}
	text, text_ok := paragraph.inlines[0].(Text_Node)
	testing.expect(t, text_ok, "expected text node")
	if !text_ok {
		return
	}
	testing.expect(t, text.kind == .Text, "expected text kind")
	testing.expect(t, text.text == "lorem ipsum\nlorem ipsum", "expected text content")

	markdown = "First.\n\nSecond." // two paragraph

	doc = parse(markdown, allocator)
	testing.expect(t, len(doc.blocks) == 2, "expected 2 blocks")
	if len(doc.blocks) != 2 {
		return
	}

	one, ok_one := doc.blocks[0].(Paragraph_Node)
	two, ok_two := doc.blocks[1].(Paragraph_Node)
	if !ok_one || !ok_two {
		return
	}
	testing.expect(t, ok_one, "expected first paragraph node")
	testing.expect(t, ok_two, "expected second paragraph node")
	testing.expect(t, len(one.inlines) == 1, "expected first paragraph to have 1 inline")
	testing.expect(t, len(two.inlines) == 1, "expected second paragraph to have 1 inline")


	text_one, text_ok_one := one.inlines[0].(Text_Node)
	text_two, text_ok_two := two.inlines[0].(Text_Node)
	if !text_ok_one || !text_ok_two {
		return
	}

	testing.expect(t, text_ok_one, "expected first text node")
	testing.expect(t, text_ok_two, "expected text node")
	testing.expect(t, text_one.kind == .Text, "expected first text kind")
	testing.expect(t, text_one.text == `First.`, "expected first text content")
	testing.expect(t, text_two.kind == .Text, "expected second text kind")
	testing.expect(t, text_two.text == `Second.`, "expected second text content")
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
	if !ok {
		testing.expect(t, ok, "expected paragraph node")
		return
	}
	text, text_ok := paragraph.inlines[0].(Text_Node)
	
	// log.infof("text: %#v", text.text)
	testing.expect(t, text_ok, "expected text node")
	testing.expect(t, text.kind == .Text, "expected text kind")
	testing.expect(t, text.text == "lorem *ipsum*", "expected text content")
}
