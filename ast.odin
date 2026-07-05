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

