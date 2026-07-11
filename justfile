src := "."
bin := "omark"

build:
    odin build {{src}} -out:{{bin}}

run: build
    ./{{bin}}

clean:
    rm -f {{bin}}

fmt:
    for f in ./*.odin; do [ -f "$f" ] && odinfmt -w "$f"; done

test:
    odin test {{src}}

test-one test_name:
    odin test {{src}} -define:ODIN_TEST_NAMES={{test_name}}
