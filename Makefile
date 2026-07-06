SRC := .
BIN := omark

.PHONY: build run clean fmt

build:
	odin build $(SRC) -out:$(BIN)

run: build
	./$(BIN)

clean:
	rm -f $(BIN)

fmt:
	@for f in ./*.odin; do \
		[ -f "$$f" ] && odinfmt -w "$$f"; \
	done
test:
	odin test $(SRC)
