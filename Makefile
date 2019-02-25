srcfiles=$(wildcard src/*.c)

all: builddir marked

%.c: %.rl
	ragel -o $@ $<

marked: src/parser.c
	$(CC) -shared $(srcfiles) -o build/libmarked.so

.PHONY: builddir
builddir:
	@mkdir -p build

.PHONY: clean
clean:
	rm -rf build

.PHONY: test
test: marked
	$(CC) test/test.c -o build/test -Isrc -Lbuild -lmarked
	build/test
