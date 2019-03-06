CFLAGS += -Wall -Wextra -Wpedantic \
          -Wformat=2 -Wno-unused-parameter -Wshadow \
          -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
          -Wredundant-decls -Wnested-externs -Wmissing-include-dirs

# GCC warnings that Clang doesn't provide:
ifeq ($(CC),gcc)
    CFLAGS += -Wjump-misses-init -Wlogical-op
endif

srcfiles=$(wildcard src/*.c)

all: marked

%.c: %.rl
	ragel -o $@ $<

marked: builddir src/parser.c
	$(CC) $(CFLAGS) -shared $(srcfiles) -o build/libmarked.so

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
