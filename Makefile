EMACS=emacs

.PHONY: help package elpa clean make-test compile-test test lint

help:
	@printf "\
Main targets\n\
compile    -- compile .el files\n\
elpa 	   -- create a package with the elpa format \n\
package    -- create a tar.gz file with the .el files \n\
test       -- run tests in batch mode\n\
clean      -- delete generated files\n\
lint       -- run package-lint in batch mode\n\
help       -- print this message\n"

package: *.el
	@ver=`grep -o "Version: .*" monroe.el | cut -c 10-`; \
	tar czvf monroe-$$ver.tar.gz --mode 644 $$(find . -name \*.el)

elpa: *.el
	@version=`grep -o "Version: .*" monroe.el | cut -c 10-`; \
	dir=monroe-$$version; \
	mkdir -p "$$dir"; \
	cp $$(find . -name \*.el) monroe-$$version; \
	echo "(define-package \"monroe\" \"$$version\" \
	\"Modular in-buffer completion framework\")" \
	> "$$dir"/monroe-pkg.el; \
	tar cvf monroe-$$version.tar --mode 644 "$$dir"

clean:
	@rm -rf *.elc ert.el .elpa/ $$(find . -print | grep -i ".elc")

make-test:
	${EMACS}  --batch -l test/make-install.el -l test/make-test.el 


test: make-test clean

compile:
	${EMACS} --batch -l test/make-install.el -L . -f batch-byte-compile monroe.el $$(find . -print | grep -i "monroe-")

compile-test: compile clean

lint:
	${EMACS} --batch -l test/make-install.el -f package-lint-batch-and-exit $$(find . -print | grep -i "monroe-")
