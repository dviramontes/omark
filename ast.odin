package main

Node :: enum {
	Document,

	// block level
	Heading,
	Paragraph,
	Code_Block,
	List,
	List_Item,
	Blockquote,

	// inline level
	Text,
	Emphasis,
	Strong,
	Code_Span,
	Link,
}

Node_Kind :: enum {
	Document,

	// Block-level
	Heading,
	Paragraph,
	Code_Block,
	Blockquote,
	List,
	List_Item,

	// Inline-level
	Text,
	Soft_Break,
	Hard_Break,
	Emphasis,
	Strong,
	Code_Span,
	Link,
}

Source_Span :: struct {
	start: int,
	end:   int,
}

Text_Node :: struct {
	kind: Node_Kind,
	span: Source_Span,
	text: string,
}

Heading_Node :: struct {
	kind:    Node_Kind,
	span:    Source_Span,
	level:   int, // 1-6
	inlines: [dynamic]Inline_Node,
}

Paragraph_Node :: struct {
	kind:    Node_Kind,
	span:    Source_Span,
	inlines: [dynamic]Inline_Node,
}

Code_Block_Node :: struct {
	kind:     Node_Kind,
	span:     Source_Span,
	language: string,
	code:     string,
}

Blockquote_Node :: struct {
	kind:   Node_Kind,
	span:   Source_Span,
	blocks: [dynamic]Block_Node,
}

List_Node :: struct {
	kind:      Node_Kind,
	span:      Source_Span,
	ordered:   bool,
	start_num: int,
	items:     [dynamic]List_Item_Node,
}

List_Item_Node :: struct {
	kind:   Node_Kind,
	span:   Source_Span,
	blocks: [dynamic]Block_Node,
}

Soft_Break_Node :: struct {
	kind: Node_Kind,
	span: Source_Span,
}

Hard_Break_Node :: struct {
	kind: Node_Kind,
	span: Source_Span,
}

Emphasis_Node :: struct {
	kind:     Node_Kind,
	span:     Source_Span,
	children: [dynamic]Inline_Node,
}

Strong_Node :: struct {
	kind:     Node_Kind,
	span:     Source_Span,
	children: [dynamic]Inline_Node,
}

Code_Span_Node :: struct {
	kind: Node_Kind,
	span: Source_Span,
	code: string,
}

Link_Node :: struct {
	kind:  Node_Kind,
	span:  Source_Span,
	text:  [dynamic]Inline_Node,
	url:   string,
	title: string,
}

Block_Node :: union {
	Heading_Node,
	Paragraph_Node,
	Code_Block_Node,
	Blockquote_Node,
	List_Node,
	List_Item_Node,
}

Inline_Node :: union {
	Text_Node,
	Soft_Break_Node,
	Hard_Break_Node,
	Emphasis_Node,
	Strong_Node,
	Code_Span_Node,
	Link_Node,
}

Document_Node :: struct {
	kind:   Node_Kind,
	span:   Source_Span,
	blocks: [dynamic]Block_Node,
}
