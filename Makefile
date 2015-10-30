PREFIX ?= /usr/local
BINPREFIX ?= "$(PREFIX)/bin"
BINPATH ?= "$(PREFIX)/bin/dick"

default: install

install:
	@mkdir -p $(BINPREFIX)
	cp -f dick.sh $(BINPATH)
	@chmod a+x $(BINPATH)

uninstall:
	rm -fr $(BINPATH)

test:
	bash test.sh

.PHONY: default install test
