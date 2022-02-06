dev:
	find . -name "*.idr" | entr -cdr bash -c "idris2 Main.idr -o Main && build/exec/Main"
.PHONY: dev

test-watch:
	find test -type l -delete
	cd test && ln -s ../src/* ./
	find . -name "*.idr" | entr -cdr bash -c "idris2 --build forth-test.ipkg"
.PHONY: test-watch

repl:
	rlwrap idris2 --repl forth.ipkg
.PHONY: repl
