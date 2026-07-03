package main

import "core:fmt"
import "core:os"

main :: proc() {
	// Part 1: read file into memory as a string
	fmt.println("Hello from Omark!\n================")
	path := "README.md"
	contents := read_markdown_file_contents(path)
	_ = contents
}

read_markdown_file_contents :: proc(path: string) -> string {
	data, err := os.read_entire_file(path, context.allocator)
	if err != os.ERROR_NONE {
		fmt.eprintln("failed to read file: %v\n", err)
		return ""
	}
	defer delete(data, context.allocator)

	// data is []u8
	fmt.println(string(data))
	
	contents := string(data)
	return contents
}
