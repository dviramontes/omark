package main

import "core:fmt"
import "core:mem"
import "core:os"

// Markdown in -> AST -> HTML out
main :: proc() {
	fmt.println("Hello from Omark!\n================")
	path := "README.md"

	// arena allocator for the AST
	// allocates memory for the AST nodes
	// pass the AST allocator into the parser functions

	arena: mem.Arena
	backing_buffer := make([]u8, 1024 * 1024)
	mem.arena_init(&arena, backing_buffer)
	allocator := mem.arena_allocator(&arena)


	contents := read_markdown_file_contents(path)
	nodes := parse(allocator, contents)
	defer delete(nodes, allocator)
	fmt.println("nodes: %v\n", nodes)
}

read_markdown_file_contents :: proc(path: string) -> []u8 {
	data, err := os.read_entire_file(path, context.allocator)
	if err != os.ERROR_NONE {
		fmt.eprintln("failed to read file: %v\n", err)
		return nil
	}
	defer delete(data, context.allocator)

	return data
}

parse :: proc(allocator: mem.Allocator, contents: []u8) -> []Node {
	nodes := []Node{}

	return nodes
}
