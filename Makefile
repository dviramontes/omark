SRC := main.odin
BIN := omark

.PHONY: build run clean fmt

build:
	odin build $(SRC) -file -out:$(BIN)

run: build
	./$(BIN)

clean:
	rm -f $(BIN)

fmt:
	odinfmt -w $(SRC)
